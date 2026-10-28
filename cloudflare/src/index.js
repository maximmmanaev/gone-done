// Worker: маршрутизирует WebSocket в комнаты (Durable Objects) и отдаёт большой файл index.wasm,
// который лежит в статике двумя частями (лимит Cloudflare — 25 МиБ на файл).

import { Room } from "./room.js";

export { Room };

const CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const WASM_PARTS = ["/index.wasm.part0", "/index.wasm.part1"];

function newCode() {
  let code = "";
  for (let i = 0; i < 4; i++) code += CODE_ALPHABET[Math.floor(Math.random() * CODE_ALPHABET.length)];
  return code;
}

// Сообщаем об ошибке через сам WebSocket — так клиент показывает понятный текст.
function rejectSocket(msg) {
  const pair = new WebSocketPair();
  const [client, server] = Object.values(pair);
  server.accept();
  server.send(JSON.stringify({ t: "error", msg }));
  server.close(1000, "rejected");
  return new Response(null, { status: 101, webSocket: client });
}

async function handleWebSocket(request, env, url) {
  if (request.headers.get("Upgrade") !== "websocket") {
    return new Response("Ожидается WebSocket", { status: 426 });
  }
  const mode = url.searchParams.get("mode");
  const skin = url.searchParams.get("skin") ?? "";

  if (mode === "create") {
    for (let attempt = 0; attempt < 8; attempt++) {
      const code = newCode();
      const stub = env.ROOMS.get(env.ROOMS.idFromName(code));
      const target = new URL(request.url);
      target.search = new URLSearchParams({ mode: "create", code, skin }).toString();
      const res = await stub.fetch(new Request(target, request));
      if (res.status !== 409) return res; // 409 — код уже занят, пробуем другой
    }
    return rejectSocket("Не удалось создать комнату, попробуйте ещё раз");
  }

  if (mode === "join") {
    const code = (url.searchParams.get("code") ?? "").trim().toUpperCase();
    if (!/^[A-Z0-9]{4}$/.test(code)) return rejectSocket("Код комнаты — 4 символа");
    const stub = env.ROOMS.get(env.ROOMS.idFromName(code));
    const target = new URL(request.url);
    target.search = new URLSearchParams({ mode: "join", code, skin }).toString();
    return stub.fetch(new Request(target, request));
  }

  return rejectSocket("Неизвестный режим подключения");
}

// Какие скины в комнате уже заняты — меню прячет их до входа.
async function handleSkins(env, url) {
  const code = (url.searchParams.get("code") ?? "").trim().toUpperCase();
  if (!/^[A-Z0-9]{4}$/.test(code)) return new Response("Код комнаты — 4 символа", { status: 400 });
  const stub = env.ROOMS.get(env.ROOMS.idFromName(code));
  const target = new URL(url);
  target.search = new URLSearchParams({ mode: "peek" }).toString();
  return stub.fetch(new Request(target));
}

async function serveWasm(request, env, ctx) {
  const parts = await Promise.all(
    WASM_PARTS.map((p) => env.ASSETS.fetch(new Request(new URL(p, request.url)))),
  );
  if (parts.some((r) => !r.ok || !r.body)) {
    return new Response("Части index.wasm не найдены (запустите scripts/build_web.py)", { status: 500 });
  }
  const lengths = parts.map((r) => Number(r.headers.get("Content-Length")));
  const known = lengths.every((n) => Number.isFinite(n) && n > 0);
  const total = lengths.reduce((a, b) => a + b, 0);

  const { readable, writable } = known ? new FixedLengthStream(total) : new TransformStream();
  const pump = (async () => {
    try {
      for (let i = 0; i < parts.length; i++) {
        await parts[i].body.pipeTo(writable, { preventClose: true });
      }
      await writable.close();
    } catch (err) {
      await writable.abort(err);
    }
  })();

  ctx.waitUntil(pump);
  return new Response(readable, {
    headers: {
      "Content-Type": "application/wasm",
      "Cache-Control": "public, max-age=3600",
    },
  });
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    if (url.pathname === "/ws") return handleWebSocket(request, env, url);

    if (url.pathname === "/skins") return handleSkins(env, url);

    if (url.pathname === "/index.wasm") return serveWasm(request, env, ctx);

    // Всё остальное — статика (index.html, index.js, index.pck, ...). Сюда попадают только
    // запросы, для которых нет файла, поэтому отвечаем 404.
    return new Response("Не найдено", { status: 404 });
  },
};
