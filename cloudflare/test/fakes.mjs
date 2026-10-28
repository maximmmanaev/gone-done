// Имитация среды Workers для Node: WebSocketPair, Response со статусом 101 и namespace Durable Objects.
// Нужна тестам (room.test.mjs) и локальному dev-серверу (dev_server.mjs).
import { Room } from "../src/room.js";


export class FakeSocket {
  constructor() { this.listeners = {}; this.peer = null; this.closed = false; this.pending = []; }
  accept() {}
  addEventListener(type, fn) {
    (this.listeners[type] ??= []).push(fn);
    if (type === "message" && this.pending.length) {
      // как в Workers: сообщения, пришедшие до подписки, не теряются
      const queued = this.pending.splice(0);
      queueMicrotask(() => queued.forEach((data) => this.emit("message", { data })));
    }
  }
  emit(type, ev = {}) { for (const fn of this.listeners[type] ?? []) fn(ev); }
  send(data) {
    if (this.closed) throw new Error("socket closed");
    const peer = this.peer;
    queueMicrotask(() => {
      if (peer.closed) return;
      if (peer.listeners.message?.length) peer.emit("message", { data });
      else peer.pending.push(data);
    });
  }
  close() {
    if (this.closed) return;
    this.closed = true;
    const peer = this.peer;
    queueMicrotask(() => {
      this.emit("close");
      if (!peer.closed) { peer.closed = true; peer.emit("close"); }
    });
  }
}

globalThis.WebSocketPair = class {
  constructor() {
    const a = new FakeSocket();
    const b = new FakeSocket();
    a.peer = b; b.peer = a;
    this[0] = a; this[1] = b;
  }
};

globalThis.Response = class FakeResponse {
  constructor(body, init = {}) {
    this.body = body; this.status = init.status ?? 200; this.webSocket = init.webSocket ?? null;
  }
};

export function makeEnv(extra = {}) {
  const rooms = new Map();
  const env = { MIN_PLAYERS: "1", TIME_SCALE: "1", ...extra, rooms };
  env.ROOMS = {
    idFromName: (name) => name,
    get: (id) => {
      if (!rooms.has(id)) rooms.set(id, new Room({}, env));
      const room = rooms.get(id);
      return { fetch: (req) => room.fetch(req) };
    },
  };
  return env;
}

