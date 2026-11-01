# AGENTS.md — GoneDone (Godot-порт)

Руководство для ИИ-агентов и разработчиков. Проект — копия игры GoneDone (раньше на Unity), переписанная на Godot 4.7 (GDScript, рендер GL Compatibility). Игра — онлайн-платформер про насекомых: фазы выбора блока, расстановки и забега; комнаты по 4-символьному коду.

## Запрещено

- **Не читайте, не листайте и не ищите в папке `opencode-work/` рядом с репозиторием (если она есть у вас локально).** Там дубли кода и старые попытки восстановления, они путают. При поиске по родительской папке исключайте её (`--exclude-dir=opencode-work`).
- Не коммитьте бинарные ассеты оригинала (`assets/sprites`, `textures`, `fonts`, `text`, `audio`) — они в `.gitignore`, это чужие материалы.
- Не меняйте сетевой протокол: скин — целое 0..6, правила комнаты зеркалятся клиентом и сервером.

## Источники правды

| Что | Где |
|---|---|
| Исходники Unity-игры (декомпилят C#) | папка `code/` рядом с репозиторием (вне него), ассеты — `code/assets` |
| Текущий проект | эта папка (`gone-done/`), ветка `feature/original-port` |

Декомпилят из IL2CPP: структура классов и имена полей сохранились, **числовые константы и строки потеряны**. Любое число, придуманное вручную, помечайте комментарием `# GUESS`. Подлинные очки и цель матча восстановить нельзя, правила в `docs/match-rules.md` — собственные.

## Структура

```
scripts/
  game.gd            игра: фазы, спавн блоков (_spawn_block, _spawn_ported, _make_visual), забег
  catalog.gd         каталог блоков, карты, сетка 80×40, клетка 16 px (зеркало: cloudflare/src/catalog.js)
  player.gd          локальный игрок на базе Character
  net.gd, main.gd    сеть и меню (в вебе — подсказка «На экран Домой» для iPhone)
  audio.gd           автозагрузка Audio (play(event, pos); тихо молчит на неизвестных событиях)
  art.gd             запасные рисунки блоков кодом (BlockDraw и др.)
  ported/
    blocks/          логика блоков (ActiveBlock и наследники), block_art.gd — спрайты оригинала
    characters/      Character, skin_library.gd (скины из manifest.json)
    hazards/         снаряды и рои (шайба, пчёлы)
assets/
  manifest.json      группы спрайтов (коммитится); сами файлы импортируются и в git не попадают
  audio/events.json  имена событий Wwise (коммитится)
tools/
  import_assets.py   копирует code/assets → assets/ и пишет manifest.json
  extract_audio.py   разбор Wwise soundbank (WEM → ogg), events.json
  web_export_filter.py  exclude_filter для веб-экспорта (--check — проверка)
cloudflare/          Worker: статика public/ и WebSocket-комнаты (Durable Objects)
tests/               headless-тесты (.tscn)
docs/                match-rules.md, планы в docs/superpowers/
```

## Как работать с блоками

Блок добавляется в **четыре** места, иначе клиент и сервер разойдутся:

1. `scripts/catalog.gd` → `BLOCKS` (`name`, `size`, `kind`, `color`; для составных форм ещё `cells` — прямоугольники в клетках). Если логику ведёт класс из `scripts/ported`, добавьте `kind` в `PORTED_KINDS`.
2. `cloudflare/src/catalog.js` → `BLOCKS` (только размеры `[ширина, высота]`). Проверка: `cd cloudflare && npm test` (запускает `check_catalog.mjs`, он сверяет оба файла).
3. `scripts/game.gd` → `_spawn_ported` (ветка `match kind`), если блок с логикой.
4. Картинка: `BlockArt.MAP` в `scripts/ported/blocks/block_art.gd` (`тип: [группа спрайта, растянуть?]`); нет спрайта — рисует `Art.make_block` / `make_ported`.

Не вошедшие в инвентарь оригинала блоки скрыты из выбора через `OFFER_EXCLUDED` (в `catalog.gd` и `catalog.js`, оба списка должны совпадать). Сам блок остаётся в `BLOCKS`: размеры нужны для проверки расстановки.

Паттерн логики: класс наследует `ActiveBlock`; `act(delta)` вызывается, пока блок активен, не на паузе и `is_live()`. `setup_zone(size, offset)` создаёт `Area2D` и ведёт `zone_characters`. Общие часы забега — `play_clock()`. `reset_play_state()` вызывается при старте забега из `game.gd`.

API персонажа: `add_impulse`, `bounce`, `kill_character(cause, source)`, `freeze/unfreeze`, `lock_input_temporarily`, `velocity`, флаги `dead`, `dying`, `is_ghost`, `success`.

Файлы с шапкой «Каркас … + логика, написанная вручную» конвертер каркасов пропускает — не удаляйте эту шапку.

Составные формы: сервер занимает на сетке весь прямоугольник блока, клиент делает твёрдыми только клетки из `cells` (`Catalog.cells_of(type, rot)` учитывает поворот).

## Тесты

Тесты — сцены `tests/*.tscn`, запускаются так:

```
godot --headless --path . res://tests/<имя>.tscn
```

Успех — строка `<имя>: OK` (или отсутствие `FAIL:`). После добавления новых `class_name` один раз выполните `godot --headless --path . --import`, иначе тесты их не увидят.

Основные: `blocktest`, `newblocktest`, `newblock2test`, `newblock3test` (блоки по партиям), `shapetest` (составные формы и повороты), `blockarttest`, `portedgametest`, `charactertest`, `skintest`, `assetstest`, `audiotest`. Серверные: `cd cloudflare && npm test` (52 теста).

Известные падения до моих правок: `gametest` (ждёт в каталоге 26 блоков, их больше), `contracttest`.

Советы: зависшие процессы замедляют тесты — `pkill -f 'godot --headless'`. На macOS нет `timeout`, BSD `sed` требует `-i ''`. Трансформ `AnimatableBody2D` после сброса виден через несколько кадров.

## Веб-версия и деплой

```
python3 tools/web_export_filter.py                       # фильтр экспорта (обновляет export_presets.cfg)
godot --headless --path . --export-release Web cloudflare/public/index.html
python3 cloudflare/scripts/build_web.py --skip-export    # патчи + разрезание wasm на 2 части (лимит 25 МиБ)
cd cloudflare
npx wrangler dev --ip 0.0.0.0 --port 8788                # локально: http://localhost:8788, в сети — http://<IP>:8788
npx wrangler deploy                                      # продакшен: https://gone-done.<аккаунт>.workers.dev
```

Нюансы:
- Godot-веб требует Secure Context; для http по IP `build_web.py` его отключает и обходит `audioWorklet` (по HTTPS поведение не меняется).
- `build_web.py` вставляет мета-теги веб-приложения из `cloudflare/scripts/web_head.html` (полноэкранный режим из «Домой» на iPhone; на iOS в обычной вкладке полноэкранный режим недоступен).
- Фильтр экспорта и `cloudflare/public/*` — генерируемые файлы, не коммитьте их изменения без нужды.
- Деплой — исходящее действие: выкладывайте только по просьбе пользователя.

## Ассеты и звук

- Спрайты: `tools/import_assets.py` → `assets/manifest.json`. Группы называются `<Skin>_<Anim>` у персонажей и `<Block>-<Part>` у блоков.
- Звук: Wwise soundbank v150, имена событий — хэши FNV-1 (строчные). `tools/extract_audio.py` извлекает WEM, vgmstream-cli → wav, ffmpeg → ogg. События блоков пока не подключены к `Audio.play`.
- Скины: `SkinLibrary.skin_for_kind(0..6)`; нет файлов — запасной вариант `Art.make_insect`.

## Что не сделано

- Блоки с отдельной логикой: реактивный ранец (нужны правки `Character`), секундомер (замедление времени), ракеты, робот-самолётик, светофор/шлагбаум, шестерёнка; около 90 блоков-каркасов.
- Звуки блоков, анимации смерти/приседа/победы у чужих игроков, подписи скинов (внутренние имена вроде `Armadillo_Turtle`), проверка разворота спрайтов и точки привязки у ног.

## Стиль

Пишите код так, как окружающий: комментарии на русском, плотность и именование как в соседних файлах, табы. Числа, которых нет в оригинале, — с `# GUESS`. Коммиты заканчивайте строкой `Co-Authored-By: ...` по соглашению сессии.
