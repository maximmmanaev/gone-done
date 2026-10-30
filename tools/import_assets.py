#!/usr/bin/env python3
"""Копирует оригинальные ассеты (code/assets) в проект и пишет assets/manifest.json.

  python3 -I tools/import_assets.py ../code/assets assets
"""
import json, os, re, shutil, sys

SRC, DST = sys.argv[1], sys.argv[2]
FRAME = re.compile(r"^(.*?)(?:\.(\d+))?(_2)?\.png$")


def group_pngs(src_dir: str, dst_dir: str) -> dict:
    os.makedirs(dst_dir, exist_ok=True)
    names = sorted(os.listdir(src_dir))
    have = set(names)
    groups: dict = {}
    for n in names:
        m = FRAME.match(n)
        if not m:
            continue
        base, num, dup = m.group(1), m.group(2), m.group(3)
        # «X_2.png» — копия «X.png» в другом разрешении: берём её, только если оригинала нет
        if dup and (f"{base}.{num}.png" if num is not None else f"{base}.png") in have:
            continue
        shutil.copyfile(os.path.join(src_dir, n), os.path.join(dst_dir, n))
        groups.setdefault(base, []).append((int(num) if num is not None else 0, n))
    rel = os.path.relpath(dst_dir, DST)
    return {k: [f"res://assets/{rel}/{n}" for _, n in sorted(v)] for k, v in groups.items()}


def copy_all(src_dir: str, dst_dir: str, ext: str) -> list:
    os.makedirs(dst_dir, exist_ok=True)
    out = []
    for n in sorted(os.listdir(src_dir)):
        if n.endswith(ext):
            shutil.copyfile(os.path.join(src_dir, n), os.path.join(dst_dir, n))
            out.append(f"res://assets/{os.path.basename(dst_dir)}/{n}")
    return out


manifest = {
    "sprites": group_pngs(os.path.join(SRC, "sprites"), os.path.join(DST, "sprites")),
    "textures": group_pngs(os.path.join(SRC, "textures"), os.path.join(DST, "textures")),
    "fonts": copy_all(os.path.join(SRC, "fonts"), os.path.join(DST, "fonts"), ".ttf"),
    "text": {os.path.splitext(os.path.basename(p))[0]: p
             for p in copy_all(os.path.join(SRC, "text"), os.path.join(DST, "text"), ".txt")},
}
with open(os.path.join(DST, "manifest.json"), "w") as f:
    json.dump(manifest, f, ensure_ascii=False, indent=0)
print({k: len(v) for k, v in manifest.items()})
