// Локальный dev-сервер БЕЗ wrangler: отдаёт public/, склеивает index.wasm из частей и пускает
// WebSocket-клиентов в настоящий код Worker/Room (src/), подставляя имитацию среды Workers.
// Нужен, чтобы проверять игру в браузере там, где wrangler недоступен. На Cloudflare он не используется.
//   node test/dev_server.mjs [порт]
import http from "node:http";
import https from "node:https";
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import worker from "../src/index.js";
import { makeEnv } from "./fakes.mjs";

const here = path.dirname(fileURLToPath(import.meta.url));
const PUBLIC = path.join(here, "../public");
const PORT = Number(process.argv[2] ?? 8787);
const env = makeEnv();
const ctx = { waitUntil() {} };
const MIME = {
  ".html": "text/html; charset=utf-8", ".js": "text/javascript", ".png": "image/png",
  ".pck": "application/octet-stream", ".wasm": "application/wasm",
};

// HTTPS нужен телефону (Godot Web требует безопасный контекст). Если рядом лежат dev-cert.pem и dev-key.pem
// (openssl, см. README), сервер поднимается по https; иначе — обычный http.
const certFile = path.join(here, "dev-cert.pem");
const keyFile = path.join(here, "dev-key.pem");
const useTls = fs.existsSync(certFile) && fs.existsSync(keyFile);
const make = (handler) => useTls
  ? https.createServer({ cert: fs.readFileSync(certFile), key: fs.readFileSync(keyFile) }, handler)
  : http.createServer(handler);

const server = make((req, res) => {
  const url = new URL(req.url, "http://localhost");
  if (url.pathname === "/index.wasm") {
    const parts = [0, 1].map((i) => fs.readFileSync(path.join(PUBLIC, `index.wasm.part${i}`)));
    const body = Buffer.concat(parts);
    res.writeHead(200, { "Content-Type": "application/wasm", "Content-Length": body.length });
    return res.end(body);
  }
  const file = path.join(PUBLIC, url.pathname === "/" ? "index.html" : url.pathname);
  if (!file.startsWith(PUBLIC) || !fs.existsSync(file) || fs.statSync(file).isDirectory()) {
    res.writeHead(404); return res.end("Не найдено");
  }
  res.writeHead(200, { "Content-Type": MIME[path.extname(file)] ?? "application/octet-stream" });
  fs.createReadStream(file).pipe(res);
});

// --- минимальный WebSocket (RFC 6455): только текстовые кадры, без фрагментации ---

function frame(opcode, payload) {
  const data = Buffer.from(payload);
  let header;
  if (data.length < 126) header = Buffer.from([0x80 | opcode, data.length]);
  else if (data.length < 65536) { header = Buffer.alloc(4); header[0] = 0x80 | opcode; header[1] = 126; header.writeUInt16BE(data.length, 2); }
  else { header = Buffer.alloc(10); header[0] = 0x80 | opcode; header[1] = 127; header.writeBigUInt64BE(BigInt(data.length), 2); }
  return Buffer.concat([header, data]);
}

server.on("upgrade", async (req, socket) => {
  const url = new URL(req.url, "http://localhost");
  if (url.pathname !== "/ws") return socket.destroy();
  const key = req.headers["sec-websocket-key"];
  const accept = crypto.createHash("sha1").update(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11").digest("base64");
  socket.write(`HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${accept}\r\n\r\n`);

  const request = new Request(`http://localhost${req.url}`, { headers: { Upgrade: "websocket" } });
  const response = await worker.fetch(request, env, ctx);
  const ws = response.webSocket; // клиентская половина пары — к ней подключаем настоящий сокет
  ws.accept?.();

  ws.addEventListener("message", (ev) => {
    if (ev.data.includes('"t":"joined"')) console.log("joined:", ev.data);
    if (socket.writable) socket.write(frame(0x1, ev.data));
  });
  ws.addEventListener("close", () => { if (socket.writable) socket.end(frame(0x8, Buffer.alloc(0))); });

  let buf = Buffer.alloc(0);
  socket.on("data", (chunk) => {
    buf = Buffer.concat([buf, chunk]);
    for (;;) {
      if (buf.length < 2) return;
      const opcode = buf[0] & 0x0f;
      let len = buf[1] & 0x7f;
      let off = 2;
      if (len === 126) { if (buf.length < 4) return; len = buf.readUInt16BE(2); off = 4; }
      else if (len === 127) { if (buf.length < 10) return; len = Number(buf.readBigUInt64BE(2)); off = 10; }
      const masked = (buf[1] & 0x80) !== 0;
      if (buf.length < off + (masked ? 4 : 0) + len) return;
      const mask = masked ? buf.subarray(off, off + 4) : null;
      off += masked ? 4 : 0;
      const payload = Buffer.from(buf.subarray(off, off + len));
      if (mask) for (let i = 0; i < payload.length; i++) payload[i] ^= mask[i % 4];
      buf = buf.subarray(off + len);
      if (opcode === 0x1) ws.send(payload.toString("utf8"));
      else if (opcode === 0x9) socket.write(frame(0xa, payload));
      else if (opcode === 0x8) { ws.close(); socket.end(); return; }
    }
  });
  socket.on("close", () => ws.close());
  socket.on("error", () => ws.close());
});

server.listen(PORT, "0.0.0.0", () => console.log(`dev-сервер: ${useTls ? "https" : "http"}://localhost:${PORT}`));
