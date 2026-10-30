#!/usr/bin/env python3
"""Экспортирует веб-версию Godot в cloudflare/public и делит index.wasm на две части.

Нужно: Godot 4.3 с шаблонами экспорта Web и пресет «Web» (есть в export_presets.cfg).
  python3 scripts/build_web.py --godot "путь/к/Godot"
Если указать --skip-export, скрипт только разделит уже лежащий в public/ index.wasm.
"""
import argparse
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
CF = os.path.dirname(HERE)
PROJECT = os.path.dirname(CF)
PUBLIC = os.path.join(CF, "public")
LIMIT = 25 * 1024 * 1024  # лимит Cloudflare на один файл статики
PARTS = 2


MARKER = "gone-done:web-app"


def make_web_app() -> None:
    """Превращает страницу в веб-приложение: запуск с экрана «Домой» без интерфейса браузера и без жестов-прокрутки.

    Godot каждый раз пересоздаёт index.html, поэтому вставку делаем здесь, после экспорта (scripts/web_head.html).
    """
    path = os.path.join(PUBLIC, "index.html")
    html = open(path, encoding="utf-8").read()
    if MARKER in html:
        return
    head = open(os.path.join(HERE, "web_head.html"), encoding="utf-8").read()
    html = re.sub(r"[ \t]*<meta name=\"viewport\"[^>]*>\n?", "", html)   # свой viewport — в web_head.html
    if "</head>" not in html:
        sys.exit("В index.html нет </head> — не удалось добавить настройки веб-приложения")
    html = html.replace("</head>", head + "</head>", 1)
    open(path, "w", encoding="utf-8").write(html)
    print("index.html: добавлены манифест, мета-теги веб-приложения и блокировка жестов")


def patch_audio_worklet() -> None:
    """В небезопасном контексте (http по IP) у AudioContext нет audioWorklet, и Godot падает с
    «Cannot read properties of undefined (reading 'addModule')». Без audioWorklet промис позиции звука просто не завершается."""
    path = os.path.join(PUBLIC, "index.js")
    js = open(path, encoding="utf-8").read()
    old = "GodotAudio.audioPositionWorkletPromise=ctx.audioWorklet.addModule(path)"
    new = "GodotAudio.audioPositionWorkletPromise=ctx.audioWorklet?ctx.audioWorklet.addModule(path):new Promise(function(){})"
    if new in js:
        return
    if old not in js:
        sys.exit("В index.js не найден вызов audioWorklet.addModule — формат экспорта Godot изменился")
    open(path, "w", encoding="utf-8").write(js.replace(old, new, 1))
    print("index.js: звук не требует audioWorklet (работа по http в локальной сети)")


def allow_insecure_context() -> None:
    """Godot отказывается стартовать не по HTTPS («Secure Context»). Для проверки с телефона по http://IP-компьютера
    эту проверку отключаем: одноплатформенной сборке (без потоков) она не нужна. По HTTPS поведение не меняется."""
    path = os.path.join(PUBLIC, "index.html")
    html = open(path, encoding="utf-8").read()
    old = "const missing = Engine.getMissingFeatures({\n\t\tthreads: GODOT_THREADS_ENABLED,\n\t});"
    new = old[:-1] + ".filter((m) => !/Secure Context/i.test(m));"
    if new in html:
        return
    if old not in html:
        sys.exit("В index.html не найдена проверка getMissingFeatures — формат экспорта Godot изменился")
    open(path, "w", encoding="utf-8").write(html.replace(old, new, 1))
    print("index.html: проверка Secure Context отключена (работа по http в локальной сети)")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--godot", help="путь к Godot 4.3")
    ap.add_argument("--skip-export", action="store_true")
    args = ap.parse_args()

    os.makedirs(PUBLIC, exist_ok=True)
    if not args.skip_export:
        if not args.godot:
            sys.exit("Укажите --godot или --skip-export")
        subprocess.run([args.godot, "--headless", "--path", PROJECT, "--export-release", "Web",
                        os.path.join(PUBLIC, "index.html")], check=True)

    make_web_app()
    allow_insecure_context()
    patch_audio_worklet()
    if not os.path.exists(os.path.join(PUBLIC, "manifest.webmanifest")):
        sys.exit("Нет public/manifest.webmanifest")

    wasm = os.path.join(PUBLIC, "index.wasm")
    if not os.path.exists(wasm):
        sys.exit("Нет public/index.wasm — сначала выполните экспорт")
    data = open(wasm, "rb").read()
    size = -(-len(data) // PARTS)
    if size >= LIMIT:
        sys.exit("Часть получилась больше 25 МиБ — увеличьте PARTS")
    for i in range(PARTS):
        with open(os.path.join(PUBLIC, "index.wasm.part%d" % i), "wb") as f:
            f.write(data[i * size:(i + 1) * size])
    os.remove(wasm)
    # служебные файлы Godot, которые не нужны на сервере
    for name in os.listdir(PUBLIC):
        if name.endswith(".import"):
            os.remove(os.path.join(PUBLIC, name))
    print("Готово: %d байт → %d частей по ≤ %d байт" % (len(data), PARTS, size))


if __name__ == "__main__":
    main()
