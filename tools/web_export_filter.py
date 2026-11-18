#!/usr/bin/env python3
"""Прописывает в export_presets.cfg (пресет Web) exclude_filter: из ассетов оригинала в веб-сборку идут только
используемые игрой спрайты (скины из SkinLibrary.MATCH_SKINS и блоки из BlockArt.MAP), звуки и музыка.

  python3 -I tools/web_export_filter.py [--check]
"""
import json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG = os.path.join(ROOT, "export_presets.cfg")
STATIC = ["tests/*", "README.md", "cloudflare/*", "docs/*", "tools/*", "assets/textures/*", "assets/fonts/*", "assets/text/*"]


def used_sprite_files(manifest: dict) -> set:
    sprites = manifest["sprites"]
    anim_names = {g[len("Chicken_"):] for g in sprites if g.startswith("Chicken_")}
    with open(os.path.join(ROOT, "scripts/ported/characters/skin_library.gd"), encoding="utf-8") as f:
        skins = json.loads(re.search(r"^const MATCH_SKINS := (\[.*\])$", f.read(), re.M).group(1))
    groups = {f"{skin}_{anim}" for skin in skins for anim in anim_names}
    src = open(os.path.join(ROOT, "scripts/ported/blocks/block_art.gd"), encoding="utf-8").read()
    groups |= set(re.findall(r'\["([^"]+)", (?:true|false)\]', src))
    return {os.path.basename(p) for g in groups for p in sprites.get(g, [])}


def unused_files(folder: str, extension: str, keep: set) -> list:
    directory = os.path.join(ROOT, "assets", folder)
    if not os.path.isdir(directory):
        return []
    return [
        f"assets/{folder}/{file}"
        for file in sorted(os.listdir(directory))
        if file.endswith(extension) and file not in keep
    ]


def build_excludes() -> list:
    with open(os.path.join(ROOT, "assets/manifest.json"), encoding="utf-8") as f:
        manifest = json.load(f)
    with open(os.path.join(ROOT, "assets/audio/events.json"), encoding="utf-8") as f:
        events = json.load(f)
    with open(os.path.join(ROOT, "assets/audio_cues.json"), encoding="utf-8") as f:
        cues = json.load(f)
    movement_sounds = {
        f"{wid}.ogg"
        for event, ids in events.items()
        if event.startswith("SFX_") and event.endswith(("_Jump", "_Land"))
        for wid in ids
    }
    music_sounds = {f"{cue['source']}.ogg" for cue in cues["music"].values()}
    effect_sounds = {f"{wid}.ogg" for ids in cues["effects"].values() for wid in ids}
    keep_audio = movement_sounds | music_sounds | effect_sounds
    return (
        STATIC
        + unused_files("sprites", ".png", used_sprite_files(manifest))
        + unused_files("audio", ".ogg", keep_audio)
    )


if __name__ == "__main__":
    ex = build_excludes()
    text = open(CFG, encoding="utf-8").read()
    line = 'exclude_filter="%s"' % ", ".join(ex)
    new = re.sub(r'^exclude_filter=.*$', lambda m: line, text, count=1, flags=re.M)
    if "--check" in sys.argv:
        sys.exit(0 if new == text else 1)
    open(CFG, "w", encoding="utf-8").write(new)
    print(f"excluded {len(ex)} patterns")
