// Durable Object «Room»: одна комната = один объект. Здесь вся серверная логика игры:
// лобби, фазы раунда (выбор → расстановка → забег → итоги), очки.
// Протокол — JSON поверх WebSocket, поле "t" — тип сообщения.
// Упрощение для учебного проекта: движением управляют клиенты (серверу доверяем).

import {
  BLOCK_IDS, BOMBS, OFFER_GUARANTEED, OFFER_MAX_COPIES, OFFER_DEFAULT,
  MAPS, blastZone, blockRect, canPlace, isValidRot, mark, rectsOverlap, staticOccupied,
} from "./catalog.js";

const Phase = { LOBBY: 0, PICK: 1, PLACE: 2, RUN: 3, RESULT: 4, OVER: 5 };

// Скин игрока = насекомое (индекс совпадает с Catalog.INSECT_NAMES в клиенте); один скин на комнату.
export const SKINS = ["Жук", "Кузнечик", "Пчела", "Стрекоза", "Муравей", "Бабочка", "Светлячок"];
const MAX_PLAYERS = 4;
// Правила комнаты: хозяин меняет их в лобби. Значение по умолчанию — первое в списке допустимых.
export const RULES = {
  map: MAPS.map((_, i) => i),          // уровень: какая из 4 карт
  mode: ["party", "classic"],         // режим: все ставят сразу / по очереди
  death: ["out", "ghost", "corpse"],   // что с погибшим: выбывает / призрак / труп, прыгающий на 1 клетку
  gravity: ["normal", "low"],          // физика
  sprint: [true, false],               // физика: разрешён ли бег
  target: [30, 20, 50],                // уровень: до скольки очков играем
  accumulate: [true, false],           // уровень: остаются ли блоки между раундами
  offer: [4, 5, 6],                    // блоки: сколько предлагают на выбор
};
const defaultRules = () => Object.fromEntries(Object.entries(RULES).map(([k, v]) => [k, v[0]]));
const PICK_TIME = 15;
const PLACE_TIME = 25;
const RESULT_TIME = 6;
const ALL_DEAD_RESULT_TIME = 1; // секунд до следующего раунда, если не дошёл никто
const TURN_TIME = 15; // классический режим: секунд на ход при расстановке
const FINISH_GRACE = 20; // секунд остальным после того, как первый игрок дошёл до флага
const MAX_MESSAGE = 2048;

export class Room {
  constructor(state, env) {
    this.env = env;
    // TIME_SCALE нужен только тестам: 0.05 ускоряет все таймеры в 20 раз.
    const scale = parseFloat(env.TIME_SCALE ?? "1");
    this.timeScale = Number.isFinite(scale) && scale > 0 ? scale : 1;
    this.created = false;
    this.rules = defaultRules();
    this.code = "";
    this.players = new Map(); // id -> {ws, name, score, skin, state, killer, finishOrder}
    this.nextId = 1;
    this.host = 0;
    this.phase = Phase.LOBBY;
    this.deadline = 0;
    this.round = 0;
    this.offer = [];
    this.picks = new Map(); // индекс предложения -> id игрока
    this.chosen = new Map(); // id -> тип блока
    this.placed = new Set();
    this.turnOrder = []; // классический режим: очередь расстановки (id игроков)
    this.turnIndex = -1;
    this.turn = 0; // чей сейчас ход (0 — не классический режим)
    this.blocks = new Map(); // uid -> {type, x, y, rot, owner}
    this.occupied = staticOccupied();
    this.nextUid = 0;
    this.finishCount = 0;
    this.coinsTaken = new Set(); // uid монет, уже подобранных в этом забеге
    this.sudden = null; // при ничьей на финише — id игроков, между которыми решающий раунд
    this.pendingWinner = 0;
    this.timer = null;
  }

  get minPlayers() {
    const n = parseInt(this.env.MIN_PLAYERS ?? "1", 10);
    return Number.isFinite(n) && n >= 1 ? Math.min(n, MAX_PLAYERS) : 1;
  }

  // ------------------------------------------------------------------
  //  Подключение
  // ------------------------------------------------------------------

  async fetch(request) {
    const url = new URL(request.url);
    const mode = url.searchParams.get("mode");

    // Список занятых скинов для меню: клиент прячет их ещё до входа.
    if (mode === "peek") {
      return new Response(JSON.stringify({
        exists: this.created,
        open: this.created && this.phase === Phase.LOBBY && this.players.size < MAX_PLAYERS,
        taken: this.takenSkins(),
      }), { headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" } });
    }

    if (request.headers.get("Upgrade") !== "websocket") {
      return new Response("Нужен WebSocket", { status: 426 });
    }
    const skin = parseSkin(url.searchParams.get("skin"));

    if (mode === "create") {
      if (this.created) return new Response("code taken", { status: 409 });
      this.created = true;
      this.code = url.searchParams.get("code") ?? "";
    }

    const pair = new WebSocketPair();
    const [client, server] = Object.values(pair);
    server.accept();

    const error = this.joinError(mode, skin);
    if (error) {
      safeSend(server, { t: "error", msg: error, taken: this.takenSkins() });
      server.close(1000, "rejected");
    } else {
      this.addPlayer(server, skin);
    }
    return new Response(null, { status: 101, webSocket: client });
  }

  takenSkins() {
    return [...this.players.values()].map((p) => p.skin).sort();
  }

  joinError(mode, skin) {
    if (mode !== "create" && !this.created) return "Комната не найдена";
    if (this.phase !== Phase.LOBBY) return "Игра уже идёт";
    if (this.players.size >= MAX_PLAYERS) return `Комната заполнена (максимум ${MAX_PLAYERS})`;
    if (skin !== null && this.takenSkins().includes(skin)) return `Скин «${SKINS[skin]}» уже занят`;
    return null;
  }

  addPlayer(ws, wanted) {
    const id = this.nextId++;
    // скин не указан (или некорректен) — выдаём первый свободный
    let skin = wanted;
    if (skin === null) {
      const used = new Set(this.takenSkins());
      skin = 0;
      while (used.has(skin)) skin++;
    }
    const player = { ws, name: SKINS[skin], score: 0, skin, state: "idle", killer: 0, finishOrder: 0 };
    this.players.set(id, player);
    if (this.players.size === 1) this.host = id;

    ws.addEventListener("message", (ev) => this.onMessage(id, ev.data));
    ws.addEventListener("close", () => this.onLeave(id));
    ws.addEventListener("error", () => this.onLeave(id));

    this.send(id, {
      t: "joined", code: this.code, id, host: this.host,
      target: this.rules.target, rules: this.rules, max: MAX_PLAYERS, resultTime: RESULT_TIME,
    });
    this.broadcastLobby();
    if (!this.timer) this.timer = setInterval(() => this.tick(), 100);
  }

  onLeave(id) {
    const p = this.players.get(id);
    if (!p) return;
    this.players.delete(id);
    this.chosen.delete(id);
    this.placed.delete(id);
    try { p.ws.close(1000, "bye"); } catch { /* уже закрыт */ }

    if (this.players.size === 0) {
      clearInterval(this.timer);
      this.timer = null;
      this.created = false; // комната закрыта, код снова свободен
      return;
    }
    if (this.host === id) this.host = this.players.keys().next().value;
    this.broadcastLobby();
    if (this.phase === Phase.PICK && this.chosen.size >= this.players.size) this.beginPlace();
    else if (this.phase === Phase.PLACE && this.rules.mode === "classic") {
      if (this.turn === id) this.afterTurn();
    } else if (this.phase === Phase.PLACE && this.placed.size >= this.players.size) this.beginRun();
    else if (this.phase === Phase.RUN) this.checkRunEnd();
  }

  // ------------------------------------------------------------------
  //  Отправка
  // ------------------------------------------------------------------

  send(id, obj) {
    const p = this.players.get(id);
    if (p) safeSend(p.ws, obj);
  }

  broadcast(obj, exceptId = 0) {
    const text = JSON.stringify(obj);
    for (const [id, p] of this.players) {
      if (id !== exceptId) {
        try { p.ws.send(text); } catch { /* сокет закрывается */ }
      }
    }
  }

  playersPublic() {
    return [...this.players].map(([id, p]) => ({ id, name: p.name, score: p.score, skin: p.skin }));
  }

  broadcastLobby() {
    this.broadcast({ t: "lobby", host: this.host, players: this.playersPublic(), rules: this.rules });
  }

  broadcastPhase(data) {
    this.broadcast({ t: "phase", phase: this.phase, data });
  }

  // ------------------------------------------------------------------
  //  Сообщения клиентов
  // ------------------------------------------------------------------

  onMessage(id, raw) {
    if (typeof raw !== "string" || raw.length > MAX_MESSAGE) return;
    let msg;
    try { msg = JSON.parse(raw); } catch { return; }
    if (!msg || typeof msg !== "object") return;

    switch (msg.t) {
      case "start": return this.onStart(id);
      case "back": return this.onBack(id);
      case "pick": return this.onPick(id, msg.idx);
      case "place": return this.onPlace(id, msg.x, msg.y, msg.rot);
      case "state": return this.onState(id, msg);
      case "finished": return this.onFinished(id);
      case "died": return this.onDied(id, msg.uid);
      case "giveup": return this.onGiveUp(id);
      case "coin": return this.onCoin(id, msg.uid);
      case "rule": return this.onRule(id, msg.key, msg.value);
      case "ping":
        // с меткой времени клиента — отвечаем часами сервера, чтобы клиент выровнял свои часы забега
        if (Number.isFinite(msg.c)) this.send(id, { t: "pong", c: msg.c, s: Date.now() });
        return;
      default: return; // неизвестное — игнорируем
    }
  }

  onStart(id) {
    if (this.host !== id || this.phase !== Phase.LOBBY) return;
    if (this.players.size < this.minPlayers) {
      this.send(id, { t: "error", msg: `Нужно минимум ${this.minPlayers} игрока(ов)` });
      return;
    }
    for (const p of this.players.values()) p.score = 0;
    this.round = 0;
    this.resetLevel();
    this.broadcastLobby();
    this.beginPick();
  }

  // Правила меняет только хозяин и только в лобби; неизвестные ключи и значения игнорируются.
  onRule(id, key, value) {
    if (this.host !== id || this.phase !== Phase.LOBBY) return;
    if (!Object.hasOwn(RULES, key) || !RULES[key].includes(value)) return;
    this.rules = { ...this.rules, [key]: value };
    this.clearBlocks();   // от карты зависит, какие клетки заняты землёй
    this.broadcastLobby();
  }

  onBack(id) {
    if (this.host !== id || this.phase !== Phase.OVER) return;
    this.phase = Phase.LOBBY;
    for (const p of this.players.values()) p.score = 0;
    this.resetLevel();
    this.broadcastPhase({});
    this.broadcastLobby();
  }

  clearBlocks() {
    this.blocks = new Map();
    this.occupied = staticOccupied(this.rules.map);
  }

  resetLevel() {
    this.sudden = null;
    this.pendingWinner = 0;
    this.clearBlocks();
  }

  // ------------------------------------------------------------------
  //  Раунд: выбор → расстановка → забег → итоги
  // ------------------------------------------------------------------

  setTimer(seconds) {
    this.deadline = Date.now() + seconds * 1000 * this.timeScale;
  }

  beginPick() {
    this.round++;
    this.phase = Phase.PICK;
    this.offer = buildOffer(this.players.size, Math.random, this.rules.offer);
    this.picks = new Map();
    this.chosen = new Map();
    this.placed = new Set();
    this.setTimer(PICK_TIME);
    for (const p of this.players.values()) p.state = "idle";
    this.broadcastPhase({ offer: this.offer, round: this.round, time: PICK_TIME });
  }

  onPick(id, idx) {
    if (this.phase !== Phase.PICK) return;
    if (!Number.isInteger(idx) || idx < 0 || idx >= this.offer.length) return;
    if (this.picks.has(idx) || this.chosen.has(id)) return;
    this.picks.set(idx, id);
    this.chosen.set(id, this.offer[idx]);
    this.sendPicks();
    if (this.chosen.size >= this.players.size) this.beginPlace();
  }

  sendPicks() {
    this.broadcast({ t: "picks", picks: Object.fromEntries(this.picks) });
  }

  autoPick() {
    const free = [];
    for (let i = 0; i < this.offer.length; i++) if (!this.picks.has(i)) free.push(i);
    for (let i = free.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [free[i], free[j]] = [free[j], free[i]];
    }
    for (const id of this.players.keys()) {
      if (!this.chosen.has(id) && free.length > 0) {
        const idx = free.pop();
        this.picks.set(idx, id);
        this.chosen.set(id, this.offer[idx]);
      }
    }
    this.sendPicks();
  }

  beginPlace() {
    this.phase = Phase.PLACE;
    this.turn = 0;
    if (this.rules.mode === "classic") {
      // по очереди: ставят в порядке входа в комнату, у каждого свой ход; остальные смотрят
      this.turnOrder = [...this.players.keys()].filter((id) => this.chosen.has(id));
      this.turnIndex = -1;
      this.turn = this.nextTurnId();
      if (!this.turn) { this.beginRun(); return; }
      this.setTimer(TURN_TIME);
      this.broadcastPhase({ chosen: Object.fromEntries(this.chosen), time: TURN_TIME, turn: this.turn });
      return;
    }
    this.setTimer(PLACE_TIME);
    this.broadcastPhase({ chosen: Object.fromEntries(this.chosen), time: PLACE_TIME });
  }

  nextTurnId() {
    this.turnIndex++;
    while (this.turnIndex < this.turnOrder.length && !this.players.has(this.turnOrder[this.turnIndex])) this.turnIndex++;
    return this.turnOrder[this.turnIndex] ?? 0;
  }

  // ход закончен (поставил, не успел или ушёл): следующий игрок или забег
  afterTurn() {
    this.turn = this.nextTurnId();
    if (!this.turn) { this.beginRun(); return; }
    this.setTimer(TURN_TIME);
    this.broadcast({ t: "turn", id: this.turn, time: TURN_TIME });
  }

  // все ли поставили (party) или кончилась очередь (classic)
  afterPlace() {
    if (this.rules.mode === "classic") this.afterTurn();
    else if (this.placed.size >= this.players.size) this.beginRun();
  }

  onPlace(id, x, y, rawRot) {
    if (this.phase !== Phase.PLACE) return;
    if (!this.chosen.has(id) || this.placed.has(id)) return;
    if (this.rules.mode === "classic" && id !== this.turn) {
      this.send(id, { t: "place_rejected", msg: "Сейчас не ваш ход" });
      return;
    }
    const type = this.chosen.get(id);
    const rot = rawRot === undefined ? 0 : rawRot;   // клиенты без поворота шлют place без rot
    // бомбу можно ставить поверх построек (в этом смысл), но не на землю и не в запретные зоны
    const field = BOMBS.has(type) ? staticOccupied(this.rules.map) : this.occupied;
    if (!isValidRot(rot) || !canPlace(type, x, y, field, rot)) {
      this.send(id, { t: "place_rejected", msg: "Сюда ставить нельзя" });
      return;
    }
    if (BOMBS.has(type)) {
      this.placed.add(id);
      this.detonate(type, x, y, rot, id);
      this.afterPlace();
      return;
    }
    mark(type, x, y, this.occupied, rot);
    const uid = ++this.nextUid;
    this.blocks.set(uid, { type, x, y, rot, owner: id });
    this.placed.add(id);
    this.broadcast({ t: "block", uid, owner: id, type, x, y, rot });
    this.afterPlace();
  }

  // Забег без ограничения по времени: раунд заканчивается, когда каждый игрок дошёл, погиб или вышел.
  beginRun() {
    this.phase = Phase.RUN;
    this.deadline = 0;
    this.finishCount = 0;
    this.coinsTaken = new Set();
    for (const p of this.players.values()) {
      p.coins = 0;
      p.state = "alive";
      p.killer = 0;
      p.finishOrder = 0;
    }
    this.broadcastPhase({ order: [...this.players.keys()], time: 0, started: Date.now() });   // started — для общих часов ловушек
  }

  onState(id, m) {
    const p = this.players.get(id);
    // погибшие продолжают двигаться, если по правилам они призраки или трупы
    const moves = p?.state === "alive" || (p?.state === "dead" && this.rules.death !== "out");
    if (!p || this.phase !== Phase.RUN || !moves) return;
    if (![m.x, m.y, m.vx, m.vy].every(Number.isFinite)) return;
    this.broadcast({ t: "state", id, x: m.x, y: m.y, vx: m.vx, vy: m.vy, flip: !!m.flip }, id);
  }

  onFinished(id) {
    const p = this.players.get(id);
    if (!p || this.phase !== Phase.RUN || p.state !== "alive") return;
    this.finishCount++;
    p.state = "finished";
    p.finishOrder = this.finishCount;
    this.broadcast({ t: "status", id, status: "finished" });
    // первый финиш запускает таймер для остальных: не успел — считается проигравшим
    if (p.finishOrder === 1 && [...this.players.values()].some((q) => q.state === "alive")) {
      this.setTimer(FINISH_GRACE);
      this.broadcast({ t: "countdown", time: FINISH_GRACE });
    }
    this.checkRunEnd();
  }

  // Монета: подобрать можно один раз за забег; дошедший до флага с монетой получает очки.
  onCoin(id, uid) {
    const p = this.players.get(id);
    if (!p || this.phase !== Phase.RUN || p.state !== "alive") return;
    if (this.blocks.get(uid)?.type !== "coin" || this.coinsTaken.has(uid)) return;
    this.coinsTaken.add(uid);
    p.coins++;
    this.broadcast({ t: "coin", uid, id });
  }

  // «Сдаться»: игрок выходит из забега, как погибший (очков за ловушку никому нет), но призраком или трупом не остаётся.
  onGiveUp(id) {
    const p = this.players.get(id);
    if (!p || this.phase !== Phase.RUN || p.state !== "alive") return;
    p.state = "left";
    this.broadcast({ t: "status", id, status: "left" });
    this.checkRunEnd();
  }

  onDied(id, uid) {
    const p = this.players.get(id);
    if (!p || this.phase !== Phase.RUN || p.state !== "alive") return;
    p.state = "dead";
    const block = this.blocks.get(uid);
    if (block && block.owner !== id && this.players.has(block.owner)) p.killer = block.owner;
    this.broadcast({ t: "status", id, status: "dead" });
    this.checkRunEnd();
  }

  // Бомба не остаётся на уровне: она взрывается сразу при установке и насовсем сносит все постройки в зоне
  // (клетки самой бомбы: 1×1, 2×2, 3×3). Землю взрыв не берёт. Так бомбой убирают чужие ловушки и препятствия.
  detonate(type, x, y, rot, owner) {
    const uid = ++this.nextUid;
    const zone = blastZone(type, x, y, rot);
    const destroyed = [];
    for (const [otherUid, other] of this.blocks) {
      if (rectsOverlap(zone, blockRect(other.type, other.x, other.y, other.rot))) destroyed.push(otherUid);
    }
    for (const d of destroyed) this.blocks.delete(d);
    this.occupied = staticOccupied(this.rules.map);
    for (const b of this.blocks.values()) mark(b.type, b.x, b.y, this.occupied, b.rot);
    this.broadcast({ t: "boom", uid, owner, type, zone, destroyed });
  }

  checkRunEnd() {
    for (const p of this.players.values()) if (p.state === "alive") return;
    this.endRun();
  }

  endRun() {
    this.phase = Phase.RESULT;
    const count = this.players.size;
    const finishers = [...this.players].filter(([, p]) => p.state === "finished").map(([id]) => id);
    // все погибли и никто не дошёл — смотреть не на что, следующий раунд через секунду
    this.setTimer(finishers.length === 0 ? ALL_DEAD_RESULT_TIME : RESULT_TIME);
    const result = {};
    for (const id of this.players.keys()) result[id] = { gain: 0, notes: [] };

    let msg;
    if (this.sudden) {
      // решающий раунд: очков нет, побеждает первый из спорящих, кто дошёл до флага
      const rivals = [...this.sudden].filter((id) => this.players.has(id));
      const firsts = finishers.filter((id) => rivals.includes(id))
        .sort((a, b) => this.players.get(a).finishOrder - this.players.get(b).finishOrder);
      if (rivals.length === 1) this.pendingWinner = rivals[0];       // остальные спорщики ушли
      else if (firsts.length > 0) this.pendingWinner = firsts[0];
      else if (rivals.length === 0) this.sudden = null;              // спорить некому — играем как обычно
      msg = this.pendingWinner ? `Решающий раунд: первым дошёл ${this.players.get(this.pendingWinner).name}!` : "Решающий раунд: никто из спорящих не дошёл — ещё раз";
      this.broadcastLobby();
      this.broadcast({ t: "result", result, msg, reset: false });
      return;
    }
    if (finishers.length === 0) {
      msg = "Никто не дошёл — очков нет";
    } else if (finishers.length === count) {
      msg = "Дошли все — очков нет";
    } else {
      msg = "Раунд засчитан!";
      const scores = [...this.players.values()].map((p) => p.score);
      const lowest = Math.min(...scores);
      const lowestCount = scores.filter((s) => s === lowest).length;
      for (const id of finishers) {
        const r = result[id];
        const p = this.players.get(id);
        r.gain += 10;
        r.notes.push("финиш +10");
        if (p.finishOrder === 1) {
          r.gain += 5;
          r.notes.push("первым +5");
        }
        if (finishers.length === 1) {
          r.gain += 5;
          r.notes.push("единственный дошёл +5");
        }
        if (p.coins > 0) {
          r.gain += 5;
          r.notes.push("монета +5");
        }
        // аутсайдер: единственный с наименьшим счётом, а у других счёт выше
        if (p.score === lowest && lowestCount === 1 && Math.max(...scores) > lowest) {
          r.gain += 3;
          r.notes.push("аутсайдер +3");
        }
      }
      for (const p of this.players.values()) {
        if (p.state !== "finished" && p.killer !== 0 && result[p.killer]) {
          result[p.killer].gain += 3;
          result[p.killer].notes.push("ловушка +3");
        }
      }
    }
    for (const [id, p] of this.players) p.score += result[id].gain;
    const reset = !this.rules.accumulate && finishers.length > 0 && finishers.length < count;   // засчитанный раунд очищает уровень
    if (reset) this.clearBlocks();
    this.broadcastLobby();
    this.broadcast({ t: "result", result, msg, reset });
  }

  afterResult() {
    let winner = this.pendingWinner;
    this.pendingWinner = 0;
    let best = 0;
    let leaders = [];
    if (winner === 0 && !this.sudden) {
      for (const [id, p] of this.players) {
        if (p.score < this.rules.target) continue;
        if (p.score > best) { best = p.score; leaders = [id]; }
        else if (p.score === best) leaders.push(id);
      }
      if (leaders.length === 1) winner = leaders[0];
      else if (leaders.length > 1) {
        // ничья на финише: решает отдельный раунд между лидерами
        this.sudden = new Set(leaders);
        this.broadcast({ t: "sudden", ids: leaders });
      }
    }
    if (winner !== 0) {
      this.sudden = null;
      this.phase = Phase.OVER;
      this.deadline = 0;
      this.broadcast({ t: "over", winner });
    } else {
      this.beginPick();
    }
  }

  tick() {
    if (this.deadline === 0 || Date.now() < this.deadline) return;
    this.deadline = 0;
    switch (this.phase) {
      case Phase.PICK:
        this.autoPick();
        this.beginPlace();
        break;
      case Phase.PLACE:
        if (this.rules.mode === "classic") this.afterTurn();   // не успел поставить — ход пропущен
        else this.beginRun();
        break;
      case Phase.RUN:
        // время после первого финиша вышло: кто ещё бежит, тот не успел
        for (const [id, p] of this.players) {
          if (p.state !== "alive") continue;
          p.state = "dead";
          this.broadcast({ t: "status", id, status: "dead" });
        }
        this.endRun();
        break;
      case Phase.RESULT:
        this.afterResult();
        break;
      default:
    }
  }
}

// Блоки, которые предлагают в выборе: size штук (правило комнаты, по умолчанию 4), не больше OFFER_MAX_COPIES одного типа,
// обязательные (ядерная бомба) есть всегда. Блоков не меньше, чем игроков: каждому достаётся свой.
export function buildOffer(playerCount, random = Math.random, size = OFFER_DEFAULT) {
  const count = Math.max(size, playerCount);
  const offer = [...OFFER_GUARANTEED];
  const copies = (type) => offer.filter((t) => t === type).length;
  while (offer.length < count) {
    const type = BLOCK_IDS[Math.floor(random() * BLOCK_IDS.length)];
    if (copies(type) < OFFER_MAX_COPIES) offer.push(type);
  }
  // перемешиваем, чтобы обязательные блоки не стояли всегда первыми
  for (let i = offer.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [offer[i], offer[j]] = [offer[j], offer[i]];
  }
  return offer;
}

// "2" -> 2; пусто или мусор -> null (скин назначит сервер)
function parseSkin(raw) {
  if (raw === null || !/^\d$/.test(raw)) return null;
  const n = Number(raw);
  return n < SKINS.length ? n : null;
}

function safeSend(ws, obj) {
  try { ws.send(JSON.stringify(obj)); } catch { /* сокет закрывается */ }
}
