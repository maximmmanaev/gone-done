// Зеркало scripts/catalog.gd: уровень, сетка и размеры блоков.
// При изменении уровня или блоков правьте ОБА файла (скрипт test/check_catalog.mjs сверяет их).

export const GRID_W = 80;
export const GRID_H = 40;

// Четыре карты — картинки уровней 1–4 (assets/levels/levelN.jpg лежит фоном на клиенте), в клетках по сетке 80×40 (клетка 16 px, персонаж 1,8 клетки в высоту).
// rects — невидимая земля и платформы ровно по нарисованному; последняя — финишная крыша под флагом (goal — клетка флага).
// spawn — клетка, где стоит игрок в начале (земля под ним — на строку ниже). hazards — зоны, убивающие при касании
// (шипы, слизь); сервер их не использует: смерть решает клиент, как у остальных ловушек.
export const MAPS = [
  {
    name: "Пруд", spawn: [4, 26], goal: [74, 10],
    rects: [[0, 27, 24, 13], [22, 22, 14, 2], [42, 20, 14, 2], [58, 22, 8, 2], [52, 27, 14, 13], [64, 11, 16, 29]],
    hazards: [],
  },
  {
    name: "Лес", spawn: [4, 30], goal: [74, 10],
    rects: [[0, 31, 18, 9], [12, 27, 16, 2], [16, 22, 14, 5], [6, 13, 18, 2], [34, 24, 8, 1], [44, 27, 16, 2], [58, 13, 6, 2], [66, 22, 8, 2], [18, 36, 62, 4], [52, 35, 16, 1], [66, 11, 14, 4]],
    hazards: [[20, 33, 32, 3]],
  },
  {
    name: "Болото", spawn: [4, 30], goal: [74, 6],
    rects: [[0, 31, 16, 9], [14, 22, 18, 2], [34, 11, 12, 2], [34, 18, 16, 2], [56, 15, 10, 1], [50, 22, 8, 2], [16, 33, 14, 2], [36, 35, 24, 1], [62, 7, 18, 8]],
    hazards: [],
  },
  {
    name: "Свалка", spawn: [4, 30], goal: [74, 6],
    rects: [[0, 31, 24, 9], [26, 7, 12, 2], [16, 15, 14, 1], [24, 20, 8, 2], [20, 25, 10, 2], [36, 16, 6, 2], [34, 24, 10, 1], [44, 13, 12, 2], [56, 16, 16, 2], [60, 20, 8, 7], [56, 27, 6, 2], [58, 31, 12, 9], [52, 33, 6, 2], [66, 7, 14, 6]],
    hazards: [[24, 35, 34, 5], [72, 31, 8, 9]],
  },
];
// запретные для строительства зоны: над стартом и над флагом (9 клеток вверх, 12 в ширину, не выше края сетки)
export const reservedRects = (map) => {
  const { spawn, goal } = MAPS[map];
  const zone = ([cx, cy], left) => {
    const y = Math.max(0, cy - 8);
    return [cx - left, y, 12, cy - y + 1];
  };
  return [zone(spawn, 4), zone(goal, 6)];
};

// тип -> [ширина, высота]
export const BLOCKS = {
  plank: [3, 1],
  box: [2, 2],
  pillar: [1, 3],
  spikes: [2, 1],
  saw: [2, 2],
  spring: [1, 1],
  mover: [3, 1],
  dynamite: [1, 1],
  bomb: [2, 2],
  nuke: [3, 3],
  crossbow: [2, 1],
  flamethrower: [1, 1],
  pendulum: [1, 1],
  coin: [1, 1],
  ice: [3, 1],
  honey: [3, 1],
  toxic: [2, 1],
  sawrail: [4, 1],
  teleporter: [1, 1],
  treadmill: [4, 1],
  upblower: [1, 1],
  boulder: [2, 2],
  blackhole: [3, 3],
  crumble: [3, 1],
  autodoor: [1, 3],
  punch: [2, 1],
  hockey: [1, 1],
  cannon: [2, 2],
  beehive: [2, 2],
  pressure: [2, 1],
  hydrant: [1, 1],
  flipper: [2, 1],
  rotator: [3, 1],
  lift: [2, 1],
  plant: [1, 1],
  plank2: [2, 1],
  plank4: [4, 1],
  plank5: [5, 1],
  plank6: [6, 1],
  haybale: [3, 3],
  barrel: [2, 2],
  stairs: [3, 3],
  girder: [4, 4],
  stone_l: [3, 3],
  stone_s: [3, 2],
  stone_sq: [2, 2],
  stone_cube: [1, 1],
  spikyball: [1, 1],
  spikes1: [1, 1],
  spikes3: [3, 1],
  ice2: [2, 1],
  ice1: [1, 1],
  goal: [1, 2],
  sawslide: [3, 1],
  wind: [3, 3],
};

// Бомбы. Взрываются сразу при установке в фазе расстановки. Зона взрыва — сама клетка(и) бомбы:
// динамит 1×1, бомба 2×2, ядерная 3×3; всё построенное в этой зоне исчезает насовсем.
export const BOMBS = new Set(["dynamite", "bomb", "nuke"]);

// Выбор блока: сколько блоков предлагают за раз, сколько копий одного типа допустимо и что обязательно есть в каждом выборе.
export const OFFER_DEFAULT = 4;
export const OFFER_MAX_COPIES = 2;
export const OFFER_GUARANTEED = ["nuke"];

// Блоки, которых нет в инвентаре оригинала (скриншоты фазы строительства): их не предлагают в выборе (зеркало OFFER_EXCLUDED в catalog.gd).
// Сами блоки остаются в BLOCKS: флаг ставит карта, а размеры нужны для проверки расстановки.
export const OFFER_EXCLUDED = ["goal", "boulder", "wind", "toxic", "flamethrower", "crumble", "sawslide", "pillar"];

export const BLOCK_IDS = Object.keys(BLOCKS);
export const OFFER_IDS = BLOCK_IDS.filter((id) => !OFFER_EXCLUDED.includes(id));

const key = (x, y) => x * 1000 + y;

function markRect(set, [rx, ry, rw, rh]) {
  for (let x = rx; x < rx + rw; x++) {
    for (let y = ry; y < ry + rh; y++) set.add(key(x, y));
  }
}

export function staticOccupied(map = 0) {
  const set = new Set();
  const m = MAPS[map] ? map : 0;
  for (const r of MAPS[m].rects) markRect(set, r);
  for (const r of reservedRects(m)) markRect(set, r);
  return set;
}

// Поворот rot: 0..3 четвертей оборота по часовой стрелке; при нечётном rot ширина и высота меняются местами.
export function isValidRot(rot) {
  return Number.isInteger(rot) && rot >= 0 && rot <= 3;
}

export function sizeOf(type, rot = 0) {
  const [sx, sy] = BLOCKS[type];
  return rot % 2 === 1 ? [sy, sx] : [sx, sy];
}

export function canPlace(type, x, y, occupied, rot = 0) {
  if (!BLOCKS[type] || !isValidRot(rot)) return false;
  if (!Number.isInteger(x) || !Number.isInteger(y)) return false;
  const [sx, sy] = sizeOf(type, rot);
  if (x < 0 || y < 0) return false;
  if (x + sx > GRID_W || y + sy > GRID_H - 1) return false;
  for (let cx = x; cx < x + sx; cx++) {
    for (let cy = y; cy < y + sy; cy++) {
      if (occupied.has(key(cx, cy))) return false;
    }
  }
  return true;
}

// Прямоугольник [x, y, ширина, высота] в клетках: блок с поворотом или зона взрыва бомбы.
export function blockRect(type, x, y, rot = 0) {
  const [w, h] = sizeOf(type, rot);
  return [x, y, w, h];
}

export function blastZone(type, x, y, rot = 0) {
  return blockRect(type, x, y, rot);
}

export function rectsOverlap([ax, ay, aw, ah], [bx, by, bw, bh]) {
  return ax < bx + bw && bx < ax + aw && ay < by + bh && by < ay + ah;
}

export function mark(type, x, y, occupied, rot = 0) {
  const [sx, sy] = sizeOf(type, rot);
  for (let cx = x; cx < x + sx; cx++) {
    for (let cy = y; cy < y + sy; cy++) occupied.add(key(cx, cy));
  }
}
