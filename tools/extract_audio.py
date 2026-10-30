#!/usr/bin/env python3
"""Достаёт звуки из Wwise-банка (v150) в .ogg и строит assets/audio/events.json.

  python3 -I tools/extract_audio.py ../code/assets/audio_banks/New_SoundBank.bnk assets/audio ../code/src/Assembly-CSharp

Имена событий в банке — только FNV-хеши, а строки в декомпилированном коде потеряны,
поэтому имена подбираются перебором (имена классов × префиксы); остальные события
остаются как `ev_<hex>`.
"""
import json, os, re, struct, subprocess, sys, tempfile
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor

BNK, OUT, CODE = sys.argv[1], sys.argv[2], sys.argv[3]
os.makedirs(OUT, exist_ok=True)
d = open(BNK, "rb").read()

secs, p = {}, 0
while p + 8 <= len(d):
    tag, n = d[p:p + 4], struct.unpack("<I", d[p + 4:p + 8])[0]
    secs[tag] = (p + 8, n)
    p += 8 + n

# --- WEM из DIDX/DATA ---
o, n = secs[b"DIDX"]
data_off = secs[b"DATA"][0]
wems = {}
for i in range(n // 12):
    wid, off, ln = struct.unpack("<III", d[o + i * 12:o + i * 12 + 12])
    wems[wid] = d[data_off + off:data_off + off + ln]

tmp = tempfile.mkdtemp(prefix="wem_")
for wid, blob in wems.items():
    open(os.path.join(tmp, f"{wid}.wem"), "wb").write(blob)

# vgmstream → wav → ogg, параллельно
def convert(wid: int) -> None:
    ogg = os.path.join(OUT, f"{wid}.ogg")
    if os.path.exists(ogg):
        return
    wav = os.path.join(tmp, f"{wid}.wav")
    r = subprocess.run(["vgmstream-cli", "-o", wav, os.path.join(tmp, f"{wid}.wem")], capture_output=True)
    if r.returncode == 0:
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", wav, "-c:a", "vorbis", "-strict", "-2",
                        "-q:a", "4", ogg])
    if os.path.exists(wav):
        os.remove(wav)


with ThreadPoolExecutor(8) as ex:
    list(ex.map(convert, wems))

# --- HIRC: событие → действия → узлы → звуки ---
o, n = secs[b"HIRC"]
cnt = struct.unpack("<I", d[o:o + 4])[0]
q = o + 4
objs = {}
for _ in range(cnt):
    t, ln = d[q], struct.unpack("<I", d[q + 1:q + 5])[0]
    objs[struct.unpack("<I", d[q + 5:q + 9])[0]] = (t, d[q + 5:q + 5 + ln])
    q += 5 + ln

children = defaultdict(list)
sound_wem = {}
for oid, (t, b) in objs.items():
    if t == 2:  # Sound: id, plugin(4), streamType(1), sourceId(4), [inMem(4) если не стрим], sourceBits(1), NodeBaseParams
        stream = b[8]
        sound_wem[oid] = struct.unpack("<I", b[9:13])[0]
        k = 13 + (0 if stream == 1 else 4) + 1
    elif t in (5, 6, 7, 9):  # Random/Sequence, Switch, ActorMixer, Blend: NodeBaseParams сразу после id
        k = 4
    else:
        continue
    if b[k + 1] != 0:  # есть эффекты — разбирать не стали, узел остаётся без родителя
        continue
    parent = struct.unpack("<I", b[k + 8:k + 12])[0]
    children[parent].append(oid)


def sounds_under(node, seen=None):
    seen = seen or set()
    if node in seen:
        return []
    seen.add(node)
    if node in sound_wem:
        return [sound_wem[node]]
    return [w for c in children.get(node, []) for w in sounds_under(c, seen)]


events = {}
for oid, (t, b) in objs.items():
    if t != 4:
        continue
    na = b[4]
    wl = []
    for i in range(na):
        act = objs.get(struct.unpack("<I", b[5 + i * 4:9 + i * 4])[0])
        if act and struct.unpack("<H", act[1][4:6])[0] >> 8 == 4:  # Play
            wl += sounds_under(struct.unpack("<I", act[1][6:10])[0])
    wl = [w for w in dict.fromkeys(wl) if os.path.exists(os.path.join(OUT, f"{w}.ogg"))]
    if wl:
        events[oid] = wl


def fnv(s: str) -> int:
    h = 2166136261
    for c in s.lower().encode():
        h = (h * 16777619) & 0xFFFFFFFF
        h ^= c
    return h


names = set()
for f in os.listdir(CODE):
    if f.endswith(".cs"):
        names.add(f[:-3])
animals, actions = set(), {"Jump", "Land", "Walk", "Run", "Die", "Death", "Victory", "Crouch", "LookUp", "WallSlide",
                           "Footstep", "Hit", "Dance", "Idle", "Slide", "Spawn", "Kick", "Fall", "Flip"}
manifest = json.load(open(os.path.join(os.path.dirname(OUT.rstrip("/")), "manifest.json")))
for g in manifest["sprites"]:
    if "_" in g:
        a, rest = g.split("_", 1)
        animals.add(a)
        actions.add(rest.split("_")[0])
cands = {}


def add(s):
    cands[fnv(s)] = s


for nme in names:
    for pre in ("", "Play_", "play_", "Play", "SFX_", "sfx_", "Stop_"):
        for suf in ("", "_Play", "_Hit", "_Trigger", "_Stop", "_Loop"):
            add(pre + nme + suf)
for an in animals:
    for ac in actions:
        for suf in ("", "_Stop", "_Loop"):
            add(f"SFX_{an}_{ac}{suf}")

out = {}
for eid, wl in events.items():
    out[cands.get(eid, f"ev_{eid:08x}")] = wl
json.dump(out, open(os.path.join(OUT, "events.json"), "w"), indent=0)
named = sum(1 for k in out if not k.startswith("ev_"))
print(f"wems={len(wems)} ogg={len([x for x in os.listdir(OUT) if x.endswith('.ogg')])} events={len(out)} named={named}")
