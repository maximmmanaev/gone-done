#!/usr/bin/env python3
"""Векторизация картинок уровней: tools/level_source/levelN.jpg -> assets/levels/levelN.vec

Картинка трассируется vtracer'ом (цветные слои друг на друге), кривые разбиваются на отрезки с точностью 0.1 px,
контуры упрощаются, всё триангулируется (earcut) и пишется в сжатый бинарный меш, который game.gd рисует одним
MeshInstance2D. Так уровень остаётся чётким при любом приближении.

Нужен Python 3.12 (vtracer падает на 3.14):  python3.12 -m venv v && v/bin/pip install vtracer mapbox-earcut pillow numpy
   v/bin/python tools/vectorize_levels.py [номер уровня ...]

Формат .vec (gzip, little-endian): "GVEC", u32 вершин, u32 индексов, f32 ширина, f32 высота;
затем float32 x,y на вершину, float32 r,g,b,a на вершину (так Godot читает их без цикла), uint32 индексы.
Координаты — в пикселях мира (1280×640): картинка 1280×704 растянута по высоте так же, как раньше растягивался спрайт.
"""
import gzip, math, os, re, struct, sys, tempfile
import numpy as np
import mapbox_earcut as earcut
import vtracer

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "level_source")
OUT = os.path.join(HERE, "..", "assets", "levels")
WORLD_W, WORLD_H = 1280.0, 640.0
FLATTEN_TOL = 0.10      # px исходной картинки: максимальное отклонение отрезка от кривой
SIMPLIFY_EPS = 0.22     # px: упрощение контура (Рамер — Дуглас — Пекер)
TRACE = dict(colormode="color", hierarchical="stacked", mode="spline", filter_speckle=6, color_precision=6,
             layer_difference=12, corner_threshold=60, length_threshold=4.0, splice_threshold=45, path_precision=2)


def parse_svg(path):
    out = []
    text = open(path).read()
    for m in re.finditer(r'<path d="([^"]+)" fill="#([0-9A-Fa-f]{6})"(?: transform="translate\(([-\d.]+),([-\d.]+)\)")?', text):
        d, col = m.group(1), m.group(2)
        tx, ty = float(m.group(3) or 0), float(m.group(4) or 0)
        toks = re.findall(r"[MCLZ]|-?\d+\.?\d*", d)
        i = 0; rings = []; cur = []; cmd = None; pos = (0.0, 0.0)
        while i < len(toks):
            if toks[i] in "MCLZ":
                cmd = toks[i]; i += 1
            if cmd == "M":
                if len(cur) > 2: rings.append(cur)
                pos = (float(toks[i]) + tx, float(toks[i + 1]) + ty); i += 2; cur = [pos]; cmd = "L"
            elif cmd == "L":
                pos = (float(toks[i]) + tx, float(toks[i + 1]) + ty); i += 2; cur.append(pos)
            elif cmd == "C":
                v = [float(t) for t in toks[i:i + 6]]; i += 6
                p0 = pos; p1 = (v[0] + tx, v[1] + ty); p2 = (v[2] + tx, v[3] + ty); p3 = (v[4] + tx, v[5] + ty)
                dx, dy = p3[0] - p0[0], p3[1] - p0[1]; ch = math.hypot(dx, dy) or 1e-9
                dev = max(abs((p1[0] - p0[0]) * dy - (p1[1] - p0[1]) * dx), abs((p2[0] - p0[0]) * dy - (p2[1] - p0[1]) * dx)) / ch
                n = max(1, min(24, math.ceil(math.sqrt(0.75 * dev / FLATTEN_TOL))))
                for k in range(1, n + 1):
                    t = k / n; u = 1 - t
                    cur.append((u**3 * p0[0] + 3 * u * u * t * p1[0] + 3 * u * t * t * p2[0] + t**3 * p3[0],
                                u**3 * p0[1] + 3 * u * u * t * p1[1] + 3 * u * t * t * p2[1] + t**3 * p3[1]))
                pos = p3
            elif cmd == "Z":
                if len(cur) > 2: rings.append(cur)
                cur = []; cmd = None
        if len(cur) > 2: rings.append(cur)
        if rings: out.append((tuple(int(col[k:k + 2], 16) for k in (0, 2, 4)), rings))
    return out


def rdp(pts, eps):
    """Упрощение замкнутого контура: делим по самой далёкой паре точек и упрощаем обе половины."""
    n = len(pts)
    if n < 8: return pts
    a = pts
    i0 = 0
    i1 = int(np.argmax(np.hypot(a[:, 0] - a[0, 0], a[:, 1] - a[0, 1])))
    keep = np.zeros(n, bool); keep[[i0, i1]] = True
    stack = [(i0, i1), (i1, n)]
    while stack:
        s, e = stack.pop()
        if e - s < 2: continue
        p0 = a[s]; p1 = a[e] if e < n else a[0]
        seg = a[s + 1:e]
        d = p1 - p0; ln = math.hypot(d[0], d[1])
        if ln < 1e-9:
            dist = np.hypot(seg[:, 0] - p0[0], seg[:, 1] - p0[1])
        else:
            dist = np.abs(d[0] * (seg[:, 1] - p0[1]) - d[1] * (seg[:, 0] - p0[0])) / ln
        k = int(np.argmax(dist))
        if dist[k] > eps:
            m = s + 1 + k; keep[m] = True
            stack.append((s, m)); stack.append((m, e))
    return a[keep]


def inside(pt, ring):
    x, y = pt; c = False
    xs, ys = ring[:, 0], ring[:, 1]
    j = len(ring) - 1
    for i in range(len(ring)):
        if (ys[i] > y) != (ys[j] > y) and x < (xs[j] - xs[i]) * (y - ys[i]) / (ys[j] - ys[i] + 1e-12) + xs[i]:
            c = not c
        j = i
    return c


def triangulate(rings):
    """rings: список контуров одного пути; вложенные считаем дырками. Возвращает (вершины, индексы)."""
    rs = [rdp(np.asarray(r, np.float64), SIMPLIFY_EPS) for r in rings]
    rs = [r for r in rs if len(r) >= 3]
    if not rs: return None
    area = [abs(0.5 * np.sum(r[:, 0] * np.roll(r[:, 1], -1) - np.roll(r[:, 0], -1) * r[:, 1])) for r in rs]
    order = sorted(range(len(rs)), key=lambda k: -area[k])
    outers = []   # (индекс, [дырки])
    for k in order:
        host = None
        for o in reversed(outers):
            if inside(rs[k][0], rs[o[0]]): host = o; break
        if host is None: outers.append((k, []))
        else: host[1].append(k)
    verts, idx, base = [], [], 0
    for k, holes in outers:
        group = [rs[k]] + [rs[h] for h in holes]
        v = np.concatenate(group); ends = np.cumsum([len(g) for g in group]).astype(np.uint32)
        tri = earcut.triangulate_float64(v, ends)
        if len(tri) == 0: continue
        verts.append(v); idx.append(tri.astype(np.uint32) + base); base += len(v)
    if not verts: return None
    return np.concatenate(verts), np.concatenate(idx)


def build(level):
    jpg = os.path.join(SRC, f"level{level}.jpg")
    with tempfile.TemporaryDirectory() as tmp:
        svg = os.path.join(tmp, "t.svg")
        vtracer.convert_image_to_svg_py(jpg, svg, **TRACE)
        shapes = parse_svg(svg)
    from PIL import Image
    w, h = Image.open(jpg).size
    sx, sy = WORLD_W / w, WORLD_H / h
    V, C, I, base = [], [], [], 0
    for col, rings in shapes:
        t = triangulate(rings)
        if t is None: continue
        v, ix = t
        v = v * np.array([sx, sy])
        V.append(v.astype(np.float32)); C.append(np.tile(np.array([col[0] / 255.0, col[1] / 255.0, col[2] / 255.0, 1.0], np.float32), (len(v), 1))); I.append(ix + base); base += len(v)
    V = np.concatenate(V); C = np.concatenate(C); I = np.concatenate(I)
    blob = b"GVEC" + struct.pack("<IIff", len(V), len(I), WORLD_W, WORLD_H) + V.tobytes() + C.astype(np.float32).tobytes() + I.astype(np.uint32).tobytes()
    out = os.path.join(OUT, f"level{level}.vec")
    with open(out, "wb") as f:
        f.write(gzip.compress(blob, 9, mtime=0))
    print(f"level{level}: {len(shapes)} слоёв, {len(V)} вершин, {len(I) // 3} треугольников, {os.path.getsize(out) // 1024} КБ")


if __name__ == "__main__":
    for lv in ([int(a) for a in sys.argv[1:]] or [1, 2, 3, 4]):
        build(lv)
