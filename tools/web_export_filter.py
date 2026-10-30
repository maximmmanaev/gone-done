#!/usr/bin/env python3
"""Прописывает в export_presets.cfg (пресет Web) exclude_filter: из ассетов оригинала в веб-сборку идут только
используемые игрой спрайты (7 скинов из picker + блоки из BlockArt.MAP) и звук; текстуры, шрифты, тексты — нет.

  python3 -I tools/web_export_filter.py [--check]
"""
import json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG = os.path.join(ROOT, "export_presets.cfg")
STATIC = ["tests/*", "README.md", "cloudflare/*", "docs/*", "tools/*", "assets/textures/*", "assets/fonts/*", "assets/text/*"]
PICKER = 7   # main.gd: Catalog.INSECT_NAMES.size()


def used_sprite_files(manifest: dict) -> set:
    sprites = manifest["sprites"]
    anim_names = {g[len("Chicken_"):] for g in sprites if g.startswith("Chicken_")}
    by_skin: dict = {}
    for g in sprites:
        for i, c in enumerate(g):
            if c == "_" and g[i + 1:] in anim_names:
                by_skin.setdefault(g[:i], set()).add(g)
                break
    skins = [s for s, gs in by_skin.items() if all(f"{s}_{r}" in gs for r in ("Idle", "Run", "JumpGoingUp"))]
    skins.sort(key=lambda s: (s != "Chicken", s))
    groups = set()
    for s in skins[:PICKER]:
        groups |= by_skin[s]
    src = open(os.path.join(ROOT, "scripts/ported/blocks/block_art.gd"), encoding="utf-8").read()
    groups |= set(re.findall(r'\["([^"]+)", (?:true|false)\]', src))
    return {os.path.basename(p) for g in groups for p in sprites.get(g, [])}


def build_excludes() -> list:
    manifest = json.load(open(os.path.join(ROOT, "assets/manifest.json")))
    keep = used_sprite_files(manifest)
    drop = sorted(f for f in os.listdir(os.path.join(ROOT, "assets/sprites")) if f.endswith(".png") and f not in keep)
    return STATIC + [f"assets/sprites/{f}" for f in drop]


if __name__ == "__main__":
    ex = build_excludes()
    text = open(CFG, encoding="utf-8").read()
    line = 'exclude_filter="%s"' % ", ".join(ex)
    new = re.sub(r'^exclude_filter=.*$', lambda m: line, text, count=1, flags=re.M)
    if "--check" in sys.argv:
        sys.exit(0 if new == text else 1)
    open(CFG, "w", encoding="utf-8").write(new)
    print(f"excluded {len(ex)} patterns")
