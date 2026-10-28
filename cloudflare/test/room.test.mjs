// Тесты серверной логики без Cloudflare: Worker и Room запускаются в Node с имитацией
// WebSocketPair и Durable Object. Проверяют правила игры и маршрутизацию, но НЕ среду Workers
// (стриминг wasm, настоящие Durable Objects) — это проверяется только на wrangler dev / после деплоя.
import assert from "node:assert/strict";
import { appendFileSync, writeFileSync } from "node:fs";
import worker from "../src/index.js";
import { makeEnv } from "./fakes.mjs";
import { BLOCKS, BOMBS, GRID_H, GRID_W, blastZone, canPlace, sizeOf } from "../src/catalog.js";
import { buildOffer } from "../src/room.js";

// ---------------------------------------------------------------- клиент-бот

class Client {
  constructor(sock, record = false) {
    this.sock = sock; this.queue = []; this.waiters = []; this.closed = false; this.record = record;
    sock.addEventListener("message", (ev) => {
      // RECORD=файл: сохраняем ответы сервера хосту в полной игре — их проигрывает tests/contracttest.gd
      if (this.record && process.env.RECORD) appendFileSync(process.env.RECORD, ev.data + "\n");
      const msg = JSON.parse(ev.data);
      const i = this.waiters.findIndex((w) => w.pred(msg));
      if (i >= 0) this.waiters.splice(i, 1)[0].resolve(msg);
      else this.queue.push(msg);
    });
    sock.addEventListener("close", () => { this.closed = true; });
    this.id = 0;
  }
  send(obj) { this.sock.send(JSON.stringify(obj)); }
  sendRaw(raw) { this.sock.send(raw); }
  next(pred, ms = 3000) {
    const i = this.queue.findIndex(pred);
    if (i >= 0) return Promise.resolve(this.queue.splice(i, 1)[0]);
    return new Promise((resolve, reject) => {
      const w = { pred, resolve };
      this.waiters.push(w);
      setTimeout(() => {
        const k = this.waiters.indexOf(w);
        if (k >= 0) { this.waiters.splice(k, 1); reject(new Error("таймаут ожидания сообщения")); }
      }, ms);
    });
  }
  type(t, ms) { return this.next((m) => m.t === t, ms); }
  phase(p, ms) { return this.next((m) => m.t === "phase" && m.phase === p, ms); }
  async quiet(t, ms = 250) {
    await new Promise((r) => setTimeout(r, ms));
    return !this.queue.some((m) => m.t === t);
  }
  close() { this.sock.close(); }
}

const ctx = { waitUntil() {} };

async function connect(env, query, record = false) {
  const req = new Request(`https://test.example/ws?${query}`, { headers: { Upgrade: "websocket" } });
  const res = await worker.fetch(req, env, ctx);
  assert.equal(res.status, 101, "ожидалось переключение на WebSocket");
  return new Client(res.webSocket, record);
}

// skin — индекс насекомого 0..6; без него сервер сам выдаёт первый свободный скин
const skinQuery = (skin) => (skin === undefined ? "" : `&skin=${skin}`);

const create = async (env, skin) => {
  const c = await connect(env, `mode=create${skinQuery(skin)}`);
  const joined = await c.type("joined");
  c.id = joined.id; c.code = joined.code; c.joined = joined;
  return c;
};

const join = async (env, code, skin) => connect(env, `mode=join&code=${code}${skinQuery(skin)}`);

// ---------------------------------------------------------------- тесты

let passed = 0;
async function test(name, fn) {
  try {
    await fn();
    passed++;
    console.log("  ✓", name);
  } catch (err) {
    console.error("  ✗", name, "\n   ", err.stack ?? err);
    process.exitCode = 1;
  }
}

await test("создание комнаты: код из 4 символов и параметры игры", async () => {
  const env = makeEnv();
  const host = await create(env, 2);
  assert.match(host.code, /^[A-HJ-NP-Z2-9]{4}$/);
  assert.equal(host.joined.host, host.id);
  assert.equal(host.joined.max, 4);
  assert.equal(host.joined.target, 30);
  const lobby = await host.type("lobby");
  assert.deepEqual(lobby.players.map((p) => [p.skin, p.name]), [[2, "Пчела"]]);
  host.close();
});

await test("вход в несуществующую комнату и неверный формат кода", async () => {
  const env = makeEnv();
  const a = await join(env, "ZZZZ");
  assert.equal((await a.type("error")).msg, "Комната не найдена");
  const b = await join(env, "AB");
  assert.equal((await b.type("error")).msg, "Код комнаты — 4 символа");
});

await test("код регистронезависим, лобби обновляется у всех, скины разные", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code.toLowerCase());
  const j = await guest.type("joined");
  assert.equal(j.code, host.code);
  const lobby = await host.next((m) => m.t === "lobby" && m.players.length === 2);
  assert.equal(new Set(lobby.players.map((p) => p.skin)).size, 2);
  host.close(); guest.close();
});

await test("пятый игрок и вход после старта отклоняются", async () => {
  const env = makeEnv();
  const host = await create(env);
  const others = [];
  for (let i = 0; i < 3; i++) { const g = await join(env, host.code); await g.type("joined"); others.push(g); }
  const fifth = await join(env, host.code);
  assert.match((await fifth.type("error")).msg, /заполнена/);
  host.send({ t: "start" });
  await host.phase(1);
  const late = await join(env, host.code);
  assert.equal((await late.type("error")).msg, "Игра уже идёт");
  [host, ...others].forEach((c) => c.close());
});

await test("старт только у хозяина; в выборе 4 блока и всегда есть ядерная бомба", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code);
  await guest.type("joined");
  guest.send({ t: "start" });
  assert.ok(await host.quiet("phase"), "гость не должен запускать игру");
  host.send({ t: "start" });
  const ph = await host.phase(1);
  assert.equal(ph.data.offer.length, 4, `в выборе ${ph.data.offer.length} блоков`);
  assert.ok(ph.data.offer.includes("nuke"), "ядерная бомба есть в каждом выборе");
  assert.equal(ph.data.round, 1);
  host.close(); guest.close();
});

await test("полная игра: выбор, расстановка, очки, ловушка, победитель", async () => {
  const env = makeEnv({ TIME_SCALE: "0.2" });   // пауза между раундами 1.2 с вместо 6
  if (process.env.RECORD) writeFileSync(process.env.RECORD, "");
  const host = await connect(env, "mode=create&skin=0", true);
  const joined = await host.type("joined");
  host.id = joined.id; host.code = joined.code; host.joined = joined;
  const guest = await join(env, host.code);
  const gj = await guest.type("joined");
  guest.id = gj.id;
  host.send({ t: "start" });

  for (let round = 1; round <= 2; round++) {
    await host.phase(1, 4000); await guest.phase(1, 4000);
    const offer = env.rooms.get(host.code).offer;
    offer[0] = "plank"; offer[1] = "box";       // бомбы в этом тесте не нужны: они не остаются блоками
    host.send({ t: "pick", idx: 0 });
    guest.send({ t: "pick", idx: 0 });          // слот уже занят — игнорируется
    guest.send({ t: "pick", idx: 1 });
    const picks = await host.next((m) => m.t === "picks" && Object.keys(m.picks).length === 2);
    assert.equal(picks.picks["0"], host.id);
    assert.equal(picks.picks["1"], guest.id);
    const place = await host.phase(2);
    assert.deepEqual(Object.keys(place.data.chosen).map(Number).sort(), [host.id, guest.id].sort());
    await guest.phase(2);

    guest.send({ t: "place", x: 0, y: 20 });     // в запретной зоне над стартом
    assert.equal((await guest.type("place_rejected")).msg, "Сюда ставить нельзя");
    host.send({ t: "place", x: 12 + 4 * (round - 1), y: 8, rot: round });   // блоки прошлого раунда на месте — ставим рядом   // хозяин ставит повёрнутый блок (контрактный тест проверяет rot)
    guest.send({ t: "place", x: 20 + 4 * (round - 1), y: 8, rot: 0 });
    const b1 = await host.type("block");
    const b2 = await host.type("block");
    assert.equal(b1.owner, host.id);
    assert.equal(b1.rot, round);
    assert.equal(b2.owner, guest.id);
    assert.equal(b2.rot, 0);
    const run = await host.phase(3);
    assert.deepEqual(run.data.order, [host.id, guest.id]);
    await guest.phase(3);

    guest.send({ t: "state", x: 100, y: 200, vx: 1, vy: 2, flip: true });
    const st = await host.type("state");
    assert.equal(st.id, guest.id);
    assert.ok(await guest.quiet("state", 100), "отправитель не получает свои координаты");

    host.send({ t: "finished" });
    guest.send({ t: "died", uid: b1.uid });      // погиб на блоке хозяина → ловушка +3
    const res = await host.type("result");
    assert.equal(res.msg, "Раунд засчитан!");
    assert.equal(res.reset, false, "уровень накапливается: блоки остаются");
    assert.equal(res.result[host.id].gain, 23);
    assert.deepEqual(res.result[host.id].notes, ["финиш +10", "первым +5", "единственный дошёл +5", "ловушка +3"]);
    assert.equal(res.result[guest.id].gain, 0);
    await guest.type("result");
    const lobby = await host.next((m) => m.t === "lobby" && m.players.some((p) => p.score > 0));
    assert.equal(lobby.players.find((p) => p.id === host.id).score, 23 * round);
  }
  const over = await host.type("over");
  assert.equal(over.winner, host.id);
  await guest.type("over");

  host.queue.length = 0;                        // выбросить накопленные устаревшие сообщения
  host.send({ t: "back" });
  assert.equal((await host.phase(0)).phase, 0);
  const lobby = await host.next((m) => m.t === "lobby" && m.players.every((p) => p.score === 0));
  assert.equal(lobby.players.length, 2);
  host.close(); guest.close();
});

await test("очки не начисляются, если дошли все или никто", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code);
  await guest.type("joined");
  host.send({ t: "start" });
  await host.phase(1);
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 12, y: 8 }); guest.send({ t: "place", x: 20, y: 8 });
  await host.phase(3);
  host.send({ t: "finished" }); guest.send({ t: "finished" });
  const res = await host.type("result");
  assert.equal(res.msg, "Дошли все — очков нет");
  assert.equal(res.reset, false);
  assert.ok(Object.values(res.result).every((r) => r.gain === 0));
  host.close(); guest.close();
});

await test("при уходе хозяина права переходят следующему игроку", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code);
  const gj = await guest.type("joined");
  host.close();
  const lobby = await guest.next((m) => m.t === "lobby" && m.players.length === 1);
  assert.equal(lobby.host, gj.id);
});

await test("комната закрывается и код освобождается, когда все ушли", async () => {
  const env = makeEnv();
  const host = await create(env);
  const code = host.code;
  host.close();
  await new Promise((r) => setTimeout(r, 50));
  const g = await join(env, code);
  assert.equal((await g.type("error")).msg, "Комната не найдена");
});

await test("выход игрока во время расстановки не вешает раунд", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code);
  await guest.type("joined");
  host.send({ t: "start" });
  await host.phase(1);
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 12, y: 8 });
  guest.close();                                // гость ушёл, не поставив блок
  await host.phase(3);                          // раунд идёт дальше
  host.close();
});

await test("мусорные сообщения не ломают сервер", async () => {
  const env = makeEnv();
  const host = await create(env);
  host.sendRaw("не json");
  host.sendRaw("x".repeat(5000));
  host.sendRaw(JSON.stringify({ t: "pick", idx: "a" }));
  host.sendRaw(JSON.stringify({ t: "place", x: 1.5, y: "q" }));
  host.sendRaw(JSON.stringify(null));
  host.send({ t: "ping" });
  host.send({ t: "start" });
  await host.phase(1);                          // сервер жив и отвечает
  host.close();
});

await test("минимум игроков из MIN_PLAYERS", async () => {
  const env = makeEnv({ MIN_PLAYERS: "2" });
  const host = await create(env);
  host.send({ t: "start" });
  assert.match((await host.type("error")).msg, /минимум 2/);
  host.close();
});

await test("таймеры: выбор и расстановка идут по времени, забег — без лимита, пока никто не дошёл", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const host = await create(env);
  host.send({ t: "start" });
  await host.phase(1, 2000);                    // выбор
  await host.phase(2, 2000);                    // авто-выбор → расстановка
  const run = await host.phase(3, 3000);        // время вышло → забег
  assert.equal(run.data.time, 0, "у забега нет лимита времени");
  // раньше забег кончался через 45 с (×0.05 = 2.25 с); теперь сам не кончается
  assert.ok(await host.quiet("result", 3000), "забег не должен завершаться по таймеру");
  host.send({ t: "died", uid: 0 });             // единственный игрок погиб → итоги
  const res = await host.type("result", 4000);
  assert.equal(res.msg, "Никто не дошёл — очков нет");
  const second = await host.phase(1, 3000);     // следующий раунд
  assert.equal(second.data.round, 2);
  host.close();
});

await test("лимит комнат: уникальность кодов при множестве комнат", async () => {
  const env = makeEnv();
  const codes = new Set();
  const clients = [];
  for (let i = 0; i < 60; i++) { const c = await create(env); codes.add(c.code); clients.push(c); }
  assert.equal(codes.size, 60);
  clients.forEach((c) => c.close());
});

await test("скин: выбранный сохраняется, без скина — первый свободный", async () => {
  const env = makeEnv();
  const host = await create(env, 3);
  const guest = await join(env, host.code, 1);
  await guest.type("joined");
  const auto = await join(env, host.code);          // скин не указан → первый свободный (0)
  await auto.type("joined");
  const lobby = await host.next((m) => m.t === "lobby" && m.players.length === 3);
  assert.deepEqual(lobby.players.map((p) => p.skin), [3, 1, 0]);
  assert.deepEqual(lobby.players.map((p) => p.name), ["Стрекоза", "Кузнечик", "Жук"]);
  [host, guest, auto].forEach((c) => c.close());
});

await test("скин занят: вход отклоняется, в ответе список занятых; мусорный skin = авто", async () => {
  const env = makeEnv();
  const host = await create(env, 0);
  const dup = await join(env, host.code, 0);
  const err = await dup.type("error");
  assert.match(err.msg, /Жук.*занят/);
  assert.deepEqual(err.taken, [0]);
  const free = await join(env, host.code, 2);       // свободный скин принимается
  await free.type("joined");
  const junk = await connect(env, `mode=join&code=${host.code}&skin=99`);
  await junk.type("joined");
  const lobby = await host.next((m) => m.t === "lobby" && m.players.length === 3);
  assert.deepEqual(lobby.players.map((p) => p.skin).sort(), [0, 1, 2]);
  [host, free, junk].forEach((c) => c.close());
});

await test("скин освобождается, когда игрок вышел", async () => {
  const env = makeEnv();
  const host = await create(env, 0);
  const guest = await join(env, host.code, 1);
  await guest.type("joined");
  guest.close();
  await host.next((m) => m.t === "lobby" && m.players.length === 1);
  const again = await join(env, host.code, 1);
  await again.type("joined");
  [host, again].forEach((c) => c.close());
});

await test("GET /skins: занятые скины комнаты для меню", async () => {
  const env = makeEnv();
  const host = await create(env, 1);
  const guest = await join(env, host.code, 3);
  await guest.type("joined");
  const peek = async (code) => {
    const res = await worker.fetch(new Request(`https://test.example/skins?code=${code}`), env, ctx);
    return { status: res.status, body: res.status === 200 ? JSON.parse(res.body) : null };
  };
  const ok = await peek(host.code.toLowerCase());
  assert.equal(ok.status, 200);
  assert.deepEqual(ok.body, { exists: true, open: true, taken: [1, 3] });
  assert.deepEqual((await peek("ZZZZ")).body, { exists: false, open: false, taken: [] });
  assert.equal((await peek("AB")).status, 400);
  host.send({ t: "start" });
  await host.phase(1);
  assert.equal((await peek(host.code)).body.open, false);   // игра идёт — войти нельзя
  host.close(); guest.close();
});

await test("поворот: размер меняется, rot приходит в block, сервер проверяет с учётом поворота", async () => {
  const env = makeEnv();
  const host = await create(env);
  host.send({ t: "start" });
  const pick = await host.phase(1);
  env.rooms.get(host.code).offer[0] = "plank";
  const type = "plank";
  host.send({ t: "pick", idx: 0 });
  await host.phase(2);

  const [w, h] = BLOCKS[type];
  assert.deepEqual(sizeOf(type, 1), [h, w]);
  assert.deepEqual(sizeOf(type, 2), [w, h]);
  // у правого края сетки: с поворотом 0 блок шириной 3 не влезает, а повёрнутый 1×3 — влезает (если w != h)
  const occ = new Set();
  assert.equal(canPlace("plank", GRID_W - 2, 5, occ, 0), false);
  assert.equal(canPlace("plank", GRID_W - 1, 5, occ, 1), true);
  assert.equal(canPlace("plank", 5, GRID_H - 3, occ, 1), false);   // 3 клетки вниз выходят за землю
  assert.equal(canPlace("plank", 5, GRID_H - 4, occ, 1), true);
  assert.equal(canPlace("plank", 5, 5, occ, 4), false);
  assert.equal(canPlace("plank", 5, 5, occ, -1), false);
  assert.equal(canPlace("plank", 5, 5, occ, 1.5), false);

  host.send({ t: "place", x: 12, y: 8, rot: 9 });                  // недопустимый поворот
  assert.equal((await host.type("place_rejected")).msg, "Сюда ставить нельзя");
  host.send({ t: "place", x: 12, y: 8, rot: "1" });
  assert.equal((await host.type("place_rejected")).msg, "Сюда ставить нельзя");
  host.send({ t: "place", x: 12, y: 8, rot: 3 });
  const block = await host.type("block");
  assert.equal(block.rot, 3);
  assert.equal(block.type, type);
  host.close();
});

await test("поворот: занятые клетки считаются по повёрнутому блоку", async () => {
  const env = makeEnv({ MIN_PLAYERS: "2" });
  const host = await create(env);
  const guest = await join(env, host.code);
  guest.id = (await guest.type("joined")).id;
  // подменяем предложение: оба берут нужные типы напрямую через комнату
  const room = env.rooms.get(host.code);
  host.send({ t: "start" });
  await host.phase(1);
  room.offer = ["plank", "plank", "plank"];
  host.send({ t: "pick", idx: 0 });
  guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 20, y: 2, rot: 1 });                  // вертикальная щепка 1×3: клетки (20,2..4)
  assert.equal((await host.type("block")).rot, 1);
  guest.send({ t: "place", x: 19, y: 4, rot: 0 });                 // горизонтальная 3×1 на (19..21,4) пересекает (20,4)
  assert.equal((await guest.type("place_rejected")).msg, "Сюда ставить нельзя");
  guest.send({ t: "place", x: 19, y: 5, rot: 0 });                 // ниже — свободно
  assert.equal((await guest.next((m) => m.t === "block" && m.owner === guest.id)).rot, 0);
  host.close(); guest.close();
});

await test("place без rot (старый клиент) = rot 0", async () => {
  const env = makeEnv();
  const host = await create(env);
  host.send({ t: "start" });
  await host.phase(1);
  env.rooms.get(host.code).offer[0] = "plank";
  host.send({ t: "pick", idx: 0 });
  await host.phase(2);
  host.send({ t: "place", x: 12, y: 8 });
  assert.equal((await host.type("block")).rot, 0);
  host.close();
});

await test("новые блоки: динамит 1×1, бомба 2×2, ядерная бомба 3×3 ставятся с поворотом", async () => {
  assert.deepEqual([BLOCKS.dynamite, BLOCKS.bomb, BLOCKS.nuke], [[1, 1], [2, 2], [3, 3]]);
  assert.deepEqual(sizeOf("nuke", 1), [3, 3]);
  assert.equal(canPlace("nuke", GRID_W - 3, 5, new Set(), 1), true);
  assert.equal(canPlace("nuke", GRID_W - 2, 5, new Set(), 0), false);
});

await test("выбор: 4 блока, ядерная бомба всегда, не больше 2 одинаковых, хватает на всех", () => {
  const seen = new Set();
  for (let i = 0; i < 300; i++) {
    const players = 1 + (i % 4);
    const offer = buildOffer(players);
    assert.equal(offer.length, 4, `размер ${offer.length}`);
    assert.ok(offer.length >= players);
    assert.ok(offer.includes("nuke"), "есть ядерная бомба");
    for (const t of new Set(offer)) assert.ok(offer.filter((x) => x === t).length <= 2, `слишком много «${t}»`);
    assert.ok(offer.every((t) => BLOCKS[t]), "только известные блоки");
    offer.forEach((t) => seen.add(t));
  }
  assert.equal(seen.size, Object.keys(BLOCKS).length, "со временем предлагаются все блоки, включая ловушки");
  const sizes = new Set(Array.from({ length: 200 }, () => buildOffer(2).length));
  assert.deepEqual([...sizes], [4]);
});

await test("зона взрыва = клетки самой бомбы: динамит 1×1, бомба 2×2, ядерная 3×3", () => {
  assert.deepEqual([...BOMBS].sort(), ["bomb", "dynamite", "nuke"]);
  assert.deepEqual(blastZone("dynamite", 10, 10, 0), [10, 10, 1, 1]);
  assert.deepEqual(blastZone("bomb", 10, 10, 0), [10, 10, 2, 2]);
  assert.deepEqual(blastZone("nuke", 10, 10, 1), [10, 10, 3, 3]);
});

// три игрока: первые двое ставят доски, хозяин — бомбу; доски лежат до взрыва, бомба взрывается при установке
async function bombScene(bombType, bombPos, planks, env, extra = {}) {
  const host = await create(env);
  const g1 = await join(env, host.code); g1.id = (await g1.type("joined")).id;
  const g2 = await join(env, host.code); g2.id = (await g2.type("joined")).id;
  const room = env.rooms.get(host.code);
  host.send({ t: "start" });
  await host.phase(1);
  room.offer = [bombType, "plank", "plank", "plank", "plank"];
  host.send({ t: "pick", idx: 0 }); g1.send({ t: "pick", idx: 1 }); g2.send({ t: "pick", idx: 2 });
  await host.phase(2);
  g1.send({ t: "place", x: planks[0][0], y: planks[0][1], rot: 0 });
  g2.send({ t: "place", x: planks[1][0], y: planks[1][1], rot: 0 });
  const blocks = [];
  for (let i = 0; i < 2; i++) blocks.push(await host.type("block"));
  host.send({ t: "place", x: bombPos[0], y: bombPos[1], rot: extra.rot ?? 0 });
  const boom = await host.type("boom");
  return { host, g1, g2, room, blocks, boom, all: [host, g1, g2] };
}

await test("динамит: взрывается сразу при установке и насовсем сносит постройку в своей клетке (1×1)", async () => {
  const env = makeEnv();
  // доска 3×1 (8..10, 10) накрывает клетку динамита (10,10); вторая доска вдали
  const { g1, blocks, room, boom, all } = await bombScene("dynamite", [10, 10], [[8, 10], [25, 5]], env);
  const [near, far] = blocks;
  assert.equal(boom.type, "dynamite");
  assert.deepEqual(boom.zone, [10, 10, 1, 1]);
  assert.deepEqual(boom.destroyed, [near.uid], "снесена только доска в клетке динамита");
  assert.ok(!room.blocks.has(near.uid) && room.blocks.has(far.uid), "на сервере осталась уцелевшая доска");
  assert.equal([...room.blocks.values()].some((b) => b.type === "dynamite"), false, "сама бомба на уровне не остаётся");
  assert.equal(canPlace("plank", 8, 10, room.occupied, 0), true, "место снесённой доски свободно");
  assert.equal(canPlace("plank", 25, 5, room.occupied, 0), false, "уцелевшая доска занимает своё место");
  assert.ok(await g1.phase(3), "когда все поставили, начинается забег");
  all.forEach((c) => c.close());
});

await test("динамит не задевает соседнюю клетку", async () => {
  const env = makeEnv();
  const { boom, all } = await bombScene("dynamite", [10, 10], [[11, 10], [25, 5]], env);   // доска 11..13: клетка 10 свободна
  assert.deepEqual(boom.destroyed, []);
  all.forEach((c) => c.close());
});

await test("бомба 2×2: сносит доску, задетую зоной; можно ставить поверх построек, но не на землю", async () => {
  const env = makeEnv();
  const { boom, blocks, room, all } = await bombScene("bomb", [10, 10], [[11, 11], [25, 5]], env);   // доска 11..13 × 11, зона 10..11 × 10..11 → задета
  assert.deepEqual(boom.zone, [10, 10, 2, 2]);
  assert.deepEqual(boom.destroyed, [blocks[0].uid]);
  assert.ok(room.blocks.has(blocks[1].uid));
  all.forEach((c) => c.close());
  // доска рядом, но вне зоны, цела
  const envB = makeEnv();
  const sb = await bombScene("bomb", [10, 10], [[12, 10], [25, 5]], envB);
  assert.deepEqual(sb.boom.destroyed, [], "доска 12..14 вне зоны 10..11");
  sb.all.forEach((c) => c.close());
  // прямо поверх доски: бомба принимается
  const env2 = makeEnv();
  const s2 = await bombScene("bomb", [12, 10], [[12, 10], [25, 5]], env2);
  assert.deepEqual(s2.boom.destroyed, [s2.blocks[0].uid], "бомба поверх доски снесла её");
  s2.all.forEach((c) => c.close());
  // на землю нельзя (на «Пруде» земля [0,27,24,13]), отказ приходит только отправителю
  const env3 = makeEnv();
  const host = await create(env3);
  host.send({ t: "start" });
  await host.phase(1);
  env3.rooms.get(host.code).offer = ["bomb", "plank", "plank", "plank", "plank"];
  host.send({ t: "pick", idx: 0 });
  await host.phase(2);
  host.send({ t: "place", x: 14, y: 26, rot: 0 });
  assert.equal((await host.type("place_rejected")).msg, "Сюда ставить нельзя");
  assert.ok(await host.quiet("boom", 150), "взрыва на земле нет");
  host.close();
});

await test("ядерная бомба 3×3 сносит всё в своей зоне и только там", async () => {
  const env = makeEnv();
  const { boom, room, blocks, all } = await bombScene("nuke", [10, 9], [[12, 11], [25, 5]], env);   // доска 12..14 × 11 — клетка (12,11) в зоне 10..12 × 9..11
  assert.deepEqual(boom.zone, [10, 9, 3, 3]);
  assert.deepEqual(boom.destroyed, [blocks[0].uid]);
  assert.equal(room.blocks.size, 1, "осталась только далёкая доска");
  all.forEach((c) => c.close());
});

await test("ждущий бомбу игрок не зависает: после взрыва раунд идёт дальше", async () => {
  const env = makeEnv();
  const { host, g1, g2, all } = await bombScene("dynamite", [10, 10], [[11, 10], [25, 5]], env);
  const run = await host.phase(3);
  assert.equal(run.data.time, 0);
  assert.equal(run.data.bombs, undefined, "фитилей в забеге больше нет");
  g1.send({ t: "died", uid: -1 }); g2.send({ t: "died", uid: -1 }); host.send({ t: "finished" });
  assert.equal((await host.type("result")).msg, "Раунд засчитан!");
  all.forEach((c) => c.close());
});

// два игрока доходят до забега; возвращает всё нужное тесту
async function runScene(env, offer = ["plank", "box", "pillar", "nuke"]) {
  const host = await create(env);
  const guest = await join(env, host.code); guest.id = (await guest.type("joined")).id;
  host.send({ t: "start" });
  await host.phase(1);
  const room = env.rooms.get(host.code);
  room.offer = offer;
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 12, y: 8, rot: 0 });
  guest.send({ t: "place", x: 20, y: 8, rot: 0 });
  await host.phase(3);
  return { host, guest, room };
}

await test("«Сдаться»: игрок выходит из забега, раунд закрывается, когда остальные дошли", async () => {
  const env = makeEnv();
  const { host, guest } = await runScene(env);
  guest.send({ t: "giveup" });
  assert.deepEqual(await host.type("status"), { t: "status", id: guest.id, status: "left" });
  guest.send({ t: "giveup" });                                       // повтор ничего не меняет
  host.send({ t: "finished" });
  const res = await host.type("result");
  assert.equal(res.msg, "Раунд засчитан!");
  assert.equal(res.result[guest.id].gain, 0);
  host.close(); guest.close();
});

await test("«Сдаться» вне забега игнорируется", async () => {
  const env = makeEnv();
  const host = await create(env);
  host.send({ t: "giveup" });
  host.send({ t: "start" });
  await host.phase(1);
  host.send({ t: "giveup" });
  assert.ok(await host.quiet("status", 150));
  host.close();
});

await test("первый финиш запускает таймер: опоздавший проигрывает, раунд засчитывается", async () => {
  const env = makeEnv({ TIME_SCALE: "0.02" });                       // 20 с → 0,4 с
  const { host, guest } = await runScene(env);
  assert.ok(await host.quiet("countdown", 150), "пока никто не дошёл, таймера нет");
  host.send({ t: "finished" });
  const c = await guest.type("countdown");
  assert.equal(c.time, 20);
  const res = await guest.type("result", 3000);
  assert.equal(res.msg, "Раунд засчитан!");
  assert.equal(res.result[host.id].gain, 20);   // финиш + первым + единственный дошёл
  assert.equal(res.result[guest.id].gain, 0);
  host.close(); guest.close();
});

await test("таймер после финиша не запускается, если больше никто не бежит; не мешает следующему раунду", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const { host, guest, room } = await runScene(env);
  guest.send({ t: "died", uid: -1 });
  host.send({ t: "finished" });
  assert.ok(await host.quiet("countdown", 100), "бежать некому — таймер не нужен");
  await host.type("result");
  const second = await host.phase(1, 3000);
  assert.equal(second.data.round, 2);
  room.offer = ["plank", "box", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 30, y: 8, rot: 0 }); guest.send({ t: "place", x: 25, y: 8, rot: 0 });
  await host.phase(3);
  host.queue.length = 0;
  assert.ok(await host.quiet("result", 1500), "таймер прошлого забега не завершил новый раунд");
  host.close(); guest.close();
});

await test("блоки накапливаются: после засчитанного раунда они на месте и занимают клетки", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const { host, guest, room } = await runScene(env);
  host.send({ t: "finished" });
  guest.send({ t: "died", uid: -1 });
  assert.equal((await host.type("result")).reset, false);
  assert.equal(room.blocks.size, 2, "оба блока остались на уровне");
  const second = await host.phase(1, 3000);
  assert.equal(second.data.round, 2);
  room.offer = ["plank", "box", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 12, y: 8, rot: 0 });                    // старая щепка уже тут
  assert.equal((await host.type("place_rejected")).msg, "Сюда ставить нельзя");
  host.close(); guest.close();
});

await test("аутсайдер: единственный с наименьшим счётом получает +3 за финиш", async () => {
  const env = makeEnv();
  const { host, guest, room } = await runScene(env);
  room.players.get(host.id).score = 10;                              // у гостя 0 — он отстаёт
  guest.send({ t: "finished" });
  host.send({ t: "died", uid: -1 });
  const res = await guest.type("result");
  assert.equal(res.result[guest.id].gain, 23);
  assert.deepEqual(res.result[guest.id].notes, ["финиш +10", "первым +5", "единственный дошёл +5", "аутсайдер +3"]);
  host.close(); guest.close();
});

await test("аутсайдера нет, если счёт у всех одинаков или самый низкий делят двое", async () => {
  const env = makeEnv();
  const { host, guest } = await runScene(env);
  guest.send({ t: "finished" });
  host.send({ t: "died", uid: -1 });
  const res = await guest.type("result");
  assert.equal(res.result[guest.id].gain, 20, "при равном счёте аутсайдера нет");
  host.close(); guest.close();
});

await test("ничья на финише: решающий раунд, побеждает первый дошедший из спорящих", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const { host, guest, room } = await runScene(env);
  room.players.get(host.id).score = 30;
  room.players.get(guest.id).score = 30;
  host.send({ t: "died", uid: -1 }); guest.send({ t: "died", uid: -1 });
  assert.equal((await host.type("result")).msg, "Никто не дошёл — очков нет");
  const sudden = await host.type("sudden", 3000);
  assert.deepEqual(sudden.ids.sort(), [host.id, guest.id].sort());
  await host.phase(1, 3000);
  room.offer = ["plank", "box", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 30, y: 8, rot: 0 }); guest.send({ t: "place", x: 25, y: 8, rot: 0 });
  await host.phase(3);
  guest.send({ t: "finished" });
  host.send({ t: "finished" });
  const res = await host.type("result");
  assert.match(res.msg, /Решающий раунд: первым дошёл/);
  assert.ok(Object.values(res.result).every((r) => r.gain === 0), "в решающем раунде очков нет");
  const over = await host.type("over", 3000);
  assert.equal(over.winner, guest.id, "гость дошёл первым");
  host.close(); guest.close();
});

await test("решающий раунд: если никто из спорящих не дошёл — играем ещё раз", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const { host, guest, room } = await runScene(env);
  room.players.get(host.id).score = 31;
  room.players.get(guest.id).score = 31;
  host.send({ t: "died", uid: -1 }); guest.send({ t: "died", uid: -1 });
  await host.type("sudden", 3000);
  await host.phase(1, 3000);
  room.offer = ["plank", "box", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 30, y: 8, rot: 0 }); guest.send({ t: "place", x: 25, y: 8, rot: 0 });
  await host.phase(3);
  host.send({ t: "died", uid: -1 }); guest.send({ t: "died", uid: -1 });
  assert.ok(await host.next((m) => m.t === "result" && /ещё раз/.test(m.msg)));
  const again = await host.phase(1, 3000);
  assert.equal(again.data.round, 3);
  host.close(); guest.close();
});

await test("без ничьей побеждает единственный лидер с 30+ очками", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const { host, guest, room } = await runScene(env);
  room.players.get(host.id).score = 32;
  room.players.get(guest.id).score = 20;
  host.send({ t: "died", uid: -1 }); guest.send({ t: "died", uid: -1 });
  await host.type("result");
  assert.equal((await host.type("over", 3000)).winner, host.id);
  assert.ok(await host.quiet("sudden", 100));
  host.close(); guest.close();
});

await test("общие часы: ping с меткой возвращает pong с временем сервера; забег сообщает started", async () => {
  const env = makeEnv();
  const { host, guest } = await runScene(env);
  const before = Date.now();
  host.send({ t: "ping", c: 12345 });
  const pong = await host.type("pong");
  assert.equal(pong.c, 12345);
  assert.ok(pong.s >= before && pong.s <= Date.now(), "время сервера");
  host.send({ t: "ping" });                                          // без метки — без ответа (просто keepalive)
  host.send({ t: "ping", c: "x" });
  assert.ok(await host.quiet("pong", 150));
  host.close(); guest.close();
  const env2 = makeEnv();
  const h2 = await create(env2);
  h2.send({ t: "start" });
  await h2.phase(1);
  env2.rooms.get(h2.code).offer = ["plank", "box", "pillar", "nuke"];
  h2.send({ t: "pick", idx: 0 });
  await h2.phase(2);
  const t0 = Date.now();
  h2.send({ t: "place", x: 12, y: 8, rot: 0 });
  const run = await h2.phase(3);
  assert.ok(run.data.started >= t0 && run.data.started <= Date.now(), "started — время начала забега по часам сервера");
  h2.close();
});

await test("монета: подбирается один раз, рассылается всем; дошедший с монетой получает +5", async () => {
  const env = makeEnv();
  const { host, guest, room } = await runScene(env, ["coin", "plank", "pillar", "nuke"]);
  const coinUid = [...room.blocks].find(([, b]) => b.type === "coin")[0];
  guest.send({ t: "coin", uid: 999 });                               // нет такого блока
  guest.send({ t: "coin", uid: [...room.blocks].find(([, b]) => b.type === "plank")[0] });   // не монета
  guest.send({ t: "coin", uid: "x" });
  assert.ok(await host.quiet("coin", 150), "мусорные запросы игнорируются");
  guest.send({ t: "coin", uid: coinUid });
  host.send({ t: "coin", uid: coinUid });                            // уже подобрана
  const c1 = await host.type("coin");
  assert.deepEqual([c1.uid, c1.id], [coinUid, guest.id]);
  assert.ok(await host.quiet("coin", 150), "вторая попытка подобрать — пусто");
  guest.send({ t: "finished" });
  host.send({ t: "died", uid: -1 });
  const res = await guest.type("result");
  assert.deepEqual(res.result[guest.id].notes, ["финиш +10", "первым +5", "единственный дошёл +5", "монета +5"]);
  assert.equal(res.result[guest.id].gain, 25);
  host.close(); guest.close();
});

await test("монета без финиша очков не даёт; мёртвый монету не берёт", async () => {
  const env = makeEnv();
  const { host, guest, room } = await runScene(env, ["coin", "plank", "pillar", "nuke"]);
  const coinUid = [...room.blocks].find(([, b]) => b.type === "coin")[0];
  guest.send({ t: "died", uid: -1 });
  guest.send({ t: "coin", uid: coinUid });
  assert.ok(await host.quiet("coin", 150), "погибший не подбирает");
  host.send({ t: "coin", uid: coinUid });
  await host.type("coin");
  host.send({ t: "died", uid: -1 });                                 // подобрал, но не дошёл
  const res = await host.type("result");
  assert.equal(res.msg, "Никто не дошёл — очков нет");
  // следующий забег: монета снова на месте и её можно подобрать
  assert.equal(room.blocks.get(coinUid).type, "coin");
  host.close(); guest.close();
});

await test("правила: по умолчанию, меняет только хозяин в лобби, мусор игнорируется", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code); const gj = await guest.type("joined");
  assert.deepEqual(gj.rules, { map: 0, mode: "party", death: "out", gravity: "normal", sprint: true, target: 30, accumulate: true, offer: 4 });
  assert.equal(gj.target, 30);
  guest.send({ t: "rule", key: "death", value: "ghost" });            // не хозяин
  host.send({ t: "rule", key: "nope", value: 1 });
  host.send({ t: "rule", key: "target", value: 999 });
  host.send({ t: "rule", key: "sprint", value: "yes" });
  host.send({ t: "rule", key: "constructor", value: 1 });
  host.send({ t: "rule" });
  await new Promise((r) => setTimeout(r, 100));
  assert.deepEqual(env.rooms.get(host.code).rules, gj.rules, "чужие и мусорные запросы правила не изменили");
  host.send({ t: "rule", key: "death", value: "ghost" });
  host.send({ t: "rule", key: "target", value: 20 });
  host.send({ t: "rule", key: "sprint", value: false });
  const lobby = await guest.next((m) => m.t === "lobby" && m.rules.target === 20 && m.rules.sprint === false);
  assert.equal(lobby.rules.death, "ghost");
  assert.equal(lobby.rules.accumulate, true, "нетронутые правила прежние");
  host.send({ t: "start" });
  await host.phase(1);
  host.send({ t: "rule", key: "death", value: "corpse" });           // во время игры правила не меняются
  assert.equal(env.rooms.get(host.code).rules.death, "ghost");
  host.close(); guest.close();
});

await test("правило «размер набора» и «цель очков»", async () => {
  const env = makeEnv();
  const host = await create(env);
  host.send({ t: "rule", key: "offer", value: 6 });
  host.send({ t: "start" });
  assert.equal((await host.phase(1)).data.offer.length, 6);
  host.close();
  const env2 = makeEnv({ TIME_SCALE: "0.05" });
  const { host: h, guest: g, room } = await runScene(env2);
  room.rules = { ...room.rules, target: 20 };
  room.players.get(h.id).score = 20;
  h.send({ t: "died", uid: -1 }); g.send({ t: "died", uid: -1 });
  await h.type("result");
  assert.equal((await h.type("over", 3000)).winner, h.id, "цель 20 очков достигнута");
  h.close(); g.close();
});

await test("правило «блоки очищаются»: после засчитанного раунда уровень пуст, reset = true", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });
  const { host, guest, room } = await runScene(env);
  room.rules = { ...room.rules, accumulate: false };
  host.send({ t: "finished" }); guest.send({ t: "died", uid: -1 });
  const res = await host.type("result");
  assert.equal(res.reset, true);
  assert.equal(room.blocks.size, 0);
  assert.equal(canPlace("plank", 12, 8, room.occupied, 0), true, "клетки свободны");
  host.close(); guest.close();
});

await test("призрак и труп: погибший продолжает слать координаты; при «выбывает» — нет", async () => {
  for (const [death, expected] of [["out", false], ["ghost", true], ["corpse", true]]) {
    const env = makeEnv();
    const { host, guest, room } = await runScene(env);
    room.rules = { ...room.rules, death };
    guest.send({ t: "died", uid: -1 });
    await host.type("status");
    host.queue.length = 0;
    guest.send({ t: "state", x: 50, y: 60, vx: 0, vy: 0, flip: false });
    assert.equal(!(await host.quiet("state", 200)), expected, `death=${death}`);
    host.close(); guest.close();
  }
});

// два игрока доходят до расстановки в режиме «по очереди»
async function classicScene(env) {
  const host = await create(env);
  const guest = await join(env, host.code); guest.id = (await guest.type("joined")).id;
  host.send({ t: "rule", key: "mode", value: "classic" });
  host.send({ t: "start" });
  await host.phase(1);
  const room = env.rooms.get(host.code);
  room.offer = ["plank", "box", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  const place = await host.phase(2);
  return { host, guest, room, place };
}

await test("по очереди: ходы в порядке входа, чужой ход отклоняется, после последнего начинается забег", async () => {
  const env = makeEnv();
  const { host, guest, place } = await classicScene(env);
  assert.equal(place.data.turn, host.id, "первым ходит хозяин");
  assert.equal(place.data.time, 15);
  guest.send({ t: "place", x: 20, y: 8, rot: 0 });
  assert.equal((await guest.type("place_rejected")).msg, "Сейчас не ваш ход");
  host.send({ t: "place", x: 12, y: 8, rot: 0 });
  assert.equal((await guest.type("block")).owner, host.id, "гость видит блок хозяина сразу");
  const turn = await guest.type("turn");
  assert.deepEqual([turn.id, turn.time], [guest.id, 15]);
  host.send({ t: "place", x: 30, y: 8, rot: 0 });                   // хозяин второй раз не ходит: молча игнорируется
  assert.ok(await guest.quiet("block", 150));
  guest.send({ t: "place", x: 20, y: 8, rot: 0 });
  await guest.phase(3);
  host.close(); guest.close();
});

await test("по очереди: не успел — ход пропускается; ушёл — очередь идёт дальше", async () => {
  const env = makeEnv({ TIME_SCALE: "0.05" });                       // ход 15 с → 0,75 с
  const { host, guest } = await classicScene(env);
  const turn = await host.type("turn", 3000);                       // хозяин молчит → ход перешёл к гостю
  assert.equal(turn.id, guest.id);
  guest.send({ t: "place", x: 20, y: 8, rot: 0 });
  await host.phase(3, 3000);
  host.close(); guest.close();
  const env2 = makeEnv();
  const s2 = await classicScene(env2);
  s2.host.close();                                                   // ходящий вышел
  const t2 = await s2.guest.type("turn");
  assert.equal(t2.id, s2.guest.id);
  s2.guest.send({ t: "place", x: 20, y: 8, rot: 0 });
  await s2.guest.phase(3);
  s2.guest.close();
});

await test("по очереди: бомба тоже занимает ход и взрывается сразу", async () => {
  const env = makeEnv();
  const host = await create(env);
  const guest = await join(env, host.code); guest.id = (await guest.type("joined")).id;
  host.send({ t: "rule", key: "mode", value: "classic" });
  host.send({ t: "start" });
  await host.phase(1);
  env.rooms.get(host.code).offer = ["dynamite", "plank", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 }); guest.send({ t: "pick", idx: 1 });
  await host.phase(2);
  host.send({ t: "place", x: 10, y: 10, rot: 0 });
  assert.deepEqual((await guest.type("boom")).zone, [10, 10, 1, 1]);
  assert.equal((await guest.type("turn")).id, guest.id);
  host.close(); guest.close();
});

await test("карты: четыре, хозяин выбирает в лобби; земля и запретные зоны зависят от карты, бомбу на землю не поставить", async () => {
  const env = makeEnv();
  const host = await create(env);
  host.send({ t: "rule", key: "map", value: 4 });                    // пятой карты нет
  host.send({ t: "rule", key: "map", value: -1 });
  host.send({ t: "rule", key: "map", value: 2 });                    // «Болото»: платформа [14,22,18,2], финиш [62,7,18,8], флаг (74,6)
  assert.equal((await host.next((m) => m.t === "lobby" && m.rules.map === 2)).rules.map, 2);
  const room = env.rooms.get(host.code);
  assert.equal(canPlace("plank", 20, 22, room.occupied, 0), false, "на «Болоте» в (20..22,22) платформа");
  assert.equal(canPlace("plank", 20, 26, room.occupied, 0), true, "под платформами пусто (воды как преграды нет)");
  assert.equal(canPlace("plank", 70, 1, room.occupied, 0), false, "над флагом (74,6) строить нельзя");
  assert.equal(canPlace("plank", 1, 24, room.occupied, 0), false, "над стартом строить нельзя");
  host.send({ t: "rule", key: "map", value: 0 });                    // «Пруд»: платформа [22,22,14,2]
  await host.next((m) => m.t === "lobby" && m.rules.map === 0);
  assert.equal(canPlace("plank", 38, 14, room.occupied, 0), true, "на «Пруде» в (38,14) пусто");
  assert.equal(canPlace("plank", 22, 22, room.occupied, 0), false, "на «Пруде» в (22,22) платформа");
  assert.equal(canPlace("plank", 34, 11, room.occupied, 0), true, "на «Болоте» это место занято (платформа [34,11,12,2]), на «Пруде» нет");
  host.send({ t: "rule", key: "map", value: 3 });                    // «Свалка»: постамент [58,31,12,9]
  await host.next((m) => m.t === "lobby" && m.rules.map === 3);
  host.send({ t: "start" });
  await host.phase(1);
  room.offer = ["bomb", "plank", "pillar", "nuke"];
  host.send({ t: "pick", idx: 0 });
  await host.phase(2);
  host.send({ t: "place", x: 60, y: 30, rot: 0 });                   // бомба 2×2 накрывает землю постамента (60,31)
  assert.equal((await host.type("place_rejected")).msg, "Сюда ставить нельзя");
  host.send({ t: "place", x: 40, y: 5, rot: 0 });                    // свободное место — можно
  assert.deepEqual((await host.type("boom")).zone, [40, 5, 2, 2]);
  host.close();
});

await test("скины: 7 насекомых, но в комнате не больше 4 игроков", async () => {
  const env = makeEnv();
  const host = await create(env, 6);
  assert.equal(host.joined.max, 4);
  const lobby = await host.next((m) => m.t === "lobby");
  assert.equal(lobby.players[0].name, "Светлячок");
  const guests = [];
  for (const sk of [4, 5, 0]) { const g = await join(env, host.code, sk); await g.type("joined"); guests.push(g); }
  const full = await connect(env, `mode=join&code=${host.code}&skin=1`);
  assert.match((await full.type("error")).msg, /Комната заполнена/);
  host.close(); guests.forEach((g) => g.close());
});

console.log(process.exitCode ? "\nЕсть упавшие тесты" : `\nВсе тесты прошли (${passed})`);
process.exit(process.exitCode ?? 0);
