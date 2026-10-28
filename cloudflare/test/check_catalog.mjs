// Сверяет уровень и блоки в scripts/catalog.gd (клиент) и src/catalog.js (сервер).
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { BLOCKS, BOMBS, GRID_H, GRID_W, MAPS, reservedRects } from "../src/catalog.js";

const here = dirname(fileURLToPath(import.meta.url));
const gd = readFileSync(join(here, "../../scripts/catalog.gd"), "utf8");

assert.equal(Number(gd.match(/const GRID_W := (\d+)/)[1]), GRID_W, "GRID_W");
assert.equal(Number(gd.match(/const GRID_H := (\d+)/)[1]), GRID_H, "GRID_H");
// карты: имя, старт, флаг, земля и опасные зоны каждой, в том же порядке
const rectList = (text) => [...text.matchAll(/Rect2i\((\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)/g)].map((r) => r.slice(1).map(Number));
const gdMaps = [...gd.matchAll(/\{"name": "([^"]+)", "spawn": Vector2i\((\d+), (\d+)\), "goal": Vector2i\((\d+), (\d+)\),\s*"rects": \[([^\]]*)\],\s*"hazards": \[([^\]]*)\]\}/g)].map((m) => ({
  name: m[1],
  spawn: [Number(m[2]), Number(m[3])],
  goal: [Number(m[4]), Number(m[5])],
  rects: rectList(m[6]),
  hazards: rectList(m[7]),
}));
assert.deepEqual(gdMaps, MAPS, "MAPS");
assert.equal(MAPS.length, 4, "четыре карты");
for (const m of MAPS) {
  const [sx, sy] = m.spawn;
  const [x0, y0, w0] = m.rects[0];
  assert.ok(y0 === sy + 1 && x0 <= sx && sx + 7 < x0 + w0, `${m.name}: старт стоит на первой крыше`);
  const [fx, fy, fw] = m.rects.at(-1);
  assert.ok(m.goal[1] === fy - 1 && fx <= m.goal[0] && m.goal[0] < fx + fw, `${m.name}: флаг стоит на финишной крыше`);
  for (const r of [...m.rects, ...m.hazards]) {
    assert.ok(r[0] >= 0 && r[1] >= 0 && r[0] + r[2] <= GRID_W && r[1] + r[3] <= GRID_H, `${m.name}: ${r} в сетке`);
  }
}
// запретные зоны считаются одинаково на сервере и в Godot (формулы в комментариях catalog.gd/js): проверим на данных карт
for (let i = 0; i < MAPS.length; i++) {
  const [a, b] = reservedRects(i);
  const { spawn, goal } = MAPS[i];
  assert.deepEqual(a, [spawn[0] - 4, Math.max(0, spawn[1] - 8), 12, spawn[1] - Math.max(0, spawn[1] - 8) + 1]);
  assert.ok(b[0] === goal[0] - 6 && b[1] >= 0 && b[2] === 12, `${MAPS[i].name}: зона над флагом`);
}

const gdBlocks = {};
for (const m of gd.matchAll(/"(\w+)":\s*\{[^}]*"size": Vector2i\((\d+),\s*(\d+)\)/g)) {
  gdBlocks[m[1]] = [Number(m[2]), Number(m[3])];
}
assert.deepEqual(gdBlocks, BLOCKS, "BLOCKS");
// набор бомб в catalog.gd и в BOMBS на сервере
const gdBombs = [...gd.matchAll(/"(\w+)":\s*\{[^}]*"kind": "bomb"/g)].map((m) => m[1]);
assert.deepEqual(gdBombs.sort(), [...BOMBS].sort(), "BOMBS");
console.log("OK: catalog.gd и catalog.js совпадают (%d блоков)", Object.keys(BLOCKS).length);
