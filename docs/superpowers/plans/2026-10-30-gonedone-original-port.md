# GoneDone: порт оригинала (шаги 1–4) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Локально играбельная копия оригинальной GoneDone на Godot: оригинальные спрайты, звуки, персонажи, блоки и цикл матча (выбор блока → расстановка → забег → очки).

**Architecture:** Существующий проект `gone-done/` (Godot, GDScript) остаётся основой. Логика оригинала (`code/src/Assembly-CSharp/*.cs`, IL-восстановлена из ARM64: константы и строки частично потеряны) читается как справочник и переписывается в `scripts/ported/`. Ассеты из `code/assets` импортируются скриптами в `assets/` с манифестом; анимации собираются в `SpriteFrames` кодом.

**Tech Stack:** Godot 4.7.2 (проект на features 4.3, GL Compatibility), GDScript, Python 3 + Pillow, ffmpeg, vgmstream (для Wwise `.bnk`).

**Spec:** согласовано в чате 2026-10-30 (отдельного spec-файла нет): шаги 1–4 из плана порта; режимы, редактор уровней и онлайн — вне этого плана.

## Global Constraints

- Папку `opencode-work/` не читать, не листать, не искать в ней и не править.
- Источник логики — только `code/`; исходные ассеты — `code/assets/` (только чтение, не менять).
- Свой код начинается с заголовка `# Ported from <Class>.cs`; вручную написанные файлы скрипт `tools/il2cpp_to_gd.py` не перезаписывает — не запускать его поверх готовых файлов.
- Тесты — сцены `tests/*.tscn`, запуск: `godot --headless --path . res://tests/<name>.tscn`; все существующие тесты должны оставаться зелёными.
- Числа, потерянные в декомпиляции (`object x = 0`), подбираются по игре и помечаются комментарием `# GUESS`.
- Коммиты — в git-репозитории `gone-done/`.

## Review Focus

- Отсутствует спрайт для анимации персонажа: показывается `Idle`, ошибок в консоли нет.
- Скин занят/неизвестен: выбирается Chicken.
- Блок без оригинального спрайта: рисуется прежним кодом из `art.gd`.
- Звук без файла: `Audio.play("name")` молча ничего не делает.
- Зеркальные кадры (`*_Mirror`, `*Flip`) не дублируются как отдельные анимации.

---

### Task 1: Импорт спрайтов, шрифтов и текстов

**Files:**
- Create: `tools/import_assets.py`, `assets/sprites/**`, `assets/fonts/*.ttf`, `assets/text/*.txt`, `assets/manifest.json`
- Test: `tests/assetstest.tscn` + `tests/assetstest.gd`

**Interfaces:**
- Produces: `assets/manifest.json` вида `{"sprites": {"Chicken_Run": ["res://assets/sprites/Chicken_Run.000.png", ...]}, "fonts": [...], "text": {"ru": "res://assets/text/ru.txt"}}` — кадры отсортированы по номеру. Кадры `*_2.png` (дубликаты ×2) в группу не входят.

- [ ] **Step 1: Написать `tests/assetstest.gd`**: читает `manifest.json`; `assert` что `sprites["Chicken_Run"].size() >= 8`, у `Chicken_Idle` существует первый файл и `Image.load` даёт 95×164, в `text` есть ключ `ru`, в `fonts` ровно 9 записей.
- [ ] **Step 2: Запустить тест, убедиться что падает** (нет manifest).
- [ ] **Step 3: Реализовать `tools/import_assets.py`**: копирует PNG из `code/assets/sprites` (и `textures` в `assets/textures`), шрифты и тексты; группирует кадры по regex `^(.*?)\.(\d+)(_2)?\.png$`; одиночные PNG без номера — группа из одного кадра; пишет manifest. Запуск: `python3 -I tools/import_assets.py ../code/assets assets`.
- [ ] **Step 4: Запустить скрипт, затем `godot --headless --import --path .`, затем тест** — ожидается PASS.
- [ ] **Step 5: Коммит** `git add tools tests assets && git commit -m "feat: import original sprites, fonts, texts"`

### Task 2: Импорт звука из Wwise-банков

**Files:**
- Create: `tools/extract_audio.py`, `assets/audio/*.ogg`, `assets/audio/events.json`, `scripts/audio.gd` (autoload `Audio`)
- Test: `tests/audiotest.tscn` + `tests/audiotest.gd`

**Interfaces:**
- Produces: `Audio.play(name: String, pos := Vector2.ZERO) -> void` (молча игнорирует неизвестное имя); `Audio.has(name: String) -> bool`. `events.json` сопоставляет имя события (из банка/кода, например `Spring`) списку `.ogg`.

- [ ] **Step 1: Установить `vgmstream-cli`** (`brew install vgmstream`); убедиться `vgmstream-cli -h`. Если недоступен — извлечь WEM из секции `DIDX/DATA` своим парсером и конвертировать `ffmpeg`.
- [ ] **Step 2: Тест `audiotest.gd`**: `assert(Audio.has("Spring"))` (или первое найденное событие из `events.json`), `Audio.play("no_such_event")` не падает, хотя бы 100 `.ogg` в `assets/audio`.
- [ ] **Step 3: Реализовать `tools/extract_audio.py`**: разбор BKHD/DIDX/DATA/HIRC `New_SoundBank.bnk`, выгрузка WEM → `.ogg` (id файла в имени), событие → список звуков через цепочку HIRC (Event → Action → Sound). Если цепочка не разбирается, имена событий берутся из `AkSoundEngine.PostEvent` в `code/`, а сопоставление — вручную в `events.json` для блоков из Task 3.
- [ ] **Step 4: Реализовать `scripts/audio.gd`** и добавить в `[autoload]` проекта; пул `AudioStreamPlayer`, загрузка по `events.json`.
- [ ] **Step 5: Запустить тест — PASS; коммит** `feat: extract Wwise audio, Audio autoload`.

### Task 3: Оригинальные персонажи и анимации

**Files:**
- Create: `scripts/ported/characters/skin_library.gd`
- Modify: `scripts/ported/characters/character.gd` (`_update_anim`, визуал), `scripts/player.gd`, `scripts/main.gd` / `scripts/net.gd` (выбор скина: 7 насекомых → скины из manifest)
- Test: `tests/skintest.tscn` + `tests/skintest.gd`

**Interfaces:**
- Consumes: `assets/manifest.json` (Task 1), `Audio.play` (Task 2).
- Produces: `SkinLibrary.skins() -> PackedStringArray` (префиксы: `Chicken`, `BlackSheep`, `Arara`, `Hoodie`, `Mohawk`, `Football`, …, только те, у кого есть `Idle`, `Run`, `JumpGoingUp`); `SkinLibrary.frames(skin: String) -> SpriteFrames` (анимации `idle, run, walk, jump_up, jump_down, jump_top, land, crouch, wall_slide, dead, victory`, кадры из групп `<skin>_<Name>`; `*_Mirror`/`*Flip` пропускаются; отсутствующая анимация = копия `idle`); `Character.set_skin(skin: String) -> void`.

- [ ] **Step 1: Тест `skintest.gd`**: `skins()` содержит `Chicken`; `frames("Chicken").get_frame_count("run") >= 8`; для скина без `Victory` анимация `victory` существует (копия `idle`); `set_skin("no_such")` оставляет Chicken; в сцене персонаж после `feed_input(1, false)` и 10 шагов физики играет `run`.
- [ ] **Step 2: Запустить — FAIL.**
- [ ] **Step 3: Реализовать `SkinLibrary`** (кэш `SpriteFrames`, скорость кадров 12 fps `# GUESS`) и подключить `AnimatedSprite2D` в `character.gd` вместо рисования из `art.gd`; соответствие состояний `Character.cs` (`IDLE/RUN/WALK/JUMP/LAND/SLIDE/DIE/WIN`) → анимации; размер коллайдера подогнать к спрайту 95×164.
- [ ] **Step 4: Заменить выбор «7 насекомых» на выбор скина из `skins()`** (меню в `main.gd`, сохранение в `user://settings.cfg`, занятые скины скрываются как сейчас).
- [ ] **Step 5: Прогнать `skintest`, `charactertest`, `walktest` — все PASS; запустить игру и визуально проверить бег/прыжок/смерть/победу.** Коммит `feat: original character skins and animations`.

### Task 4: Оригинальные блоки и ловушки

**Files:**
- Modify: `scripts/ported/blocks/*.gd`, `scripts/ported/hazards/*.gd` (по очереди: `Spring`, `Coin`, `Bomb`, `Beehive`, `Blackhole`, `Boulder`, `AnimalCannon`, `CollapsingBlock`, `AutoDoor`, `Treadmill`, `Teleporter`, `SwingingAxe` …), `scripts/game.gd` (`_spawn_ported`, `_make_visual`), `scripts/catalog.gd`
- Create: `scripts/ported/blocks/block_art.gd`
- Test: `tests/blocktest.gd` (расширить), `tests/bombtest.gd`

**Interfaces:**
- Consumes: `manifest.json`, `Audio.play`, `Character.bounce/kill_character/apply_physics_modifier`.
- Produces: `BlockArt.sprite_for(block_class: String) -> Texture2D` (по префиксам `AS2-…`, имени класса; нет спрайта → `null`, вызывающий рисует через `Art`).

- [ ] **Step 1: Составить `docs/block-sprite-map.md`**: для каждого класса из `code/src/Assembly-CSharp/*.cs`, наследующего `Placeable`, — имя группы спрайтов в manifest и источник чисел (`Strength`, задержки). Блоки без спрайтов и без логики пометить, исключить из первой версии.
- [ ] **Step 2: Для каждого блока из списка выше (по одному, начиная с `Spring`)**: расширить тест `blocktest.gd` проверкой оригинального поведения (например, `Spring`: персонаж, коснувшийся сверху, получает вертикальную скорость ≥ `Strength`, повторный толчок ранее `0.2` с не происходит — из `pushDelay` в `Spring.cs`), убедиться что падает, реализовать тело по C#, подключить `BlockArt` и звук, тест PASS.
- [ ] **Step 3: Обновить `catalog.gd` и `_spawn_ported`** так, чтобы колода выбора блока брала реализованные блоки; гарантированно присутствует бомба.
- [ ] **Step 4: Запустить `blocktest`, `bombtest`, `portedgametest` — PASS.** Коммит после каждого блока: `feat(block): <Name> original logic`.

### Task 5: Цикл матча как в оригинале

**Files:**
- Modify: `scripts/ported/core/game_control.gd`, `versus_control.gd`, `score_keeper.gd`, `scripts/game.gd`, `scripts/main.gd`
- Test: `tests/gametest.gd`, `tests/portedgametest.gd`

**Interfaces:**
- Consumes: блоки (Task 4), персонажи (Task 3).
- Produces: фазы `START → PLACE → PLAY → SUDDENDEATH → END` (как в `GameControl.cs`); подсчёт очков и условия победы по `VersusControl.cs`/`ScoreKeeper.cs`; локальный хотсит-режим 2–4 игрока без сети.

- [ ] **Step 1: Выписать из `GameControl.cs`/`VersusControl.cs` в `docs/match-rules.md` таблицу очков, таймеры фаз и условия победы** (числа, потерянные в декомпиляции, пометить `GUESS`).
- [ ] **Step 2: Тест `portedgametest.gd`**: сценарий из 2 игроков — раунд с одним финишировавшим даёт очки по таблице из `match-rules.md`; смерть от ловушки хозяина начисляет очки хозяину; при равном счёте на цели включается `SUDDENDEATH`; фаза `END` объявляет победителя.
- [ ] **Step 3: Реализовать конечный автомат** в `game_control.gd`, заменить собственные правила `catalog.gd`/`game.gd` (очки, лимиты) на оригинальные; сетевой режим пока не ломать (оставить как есть, отключить при расхождении правил с пометкой в README).
- [ ] **Step 4: Все тесты PASS; ручной прогон локального матча на 2 игрока до победы.** Коммит `feat: original match flow`.
- [ ] **Step 5: Обновить `README.md`**: что порт оригинала, как запустить, что вне объёма (режимы, редактор, онлайн).
