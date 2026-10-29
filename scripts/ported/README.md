# ported/ — Unity-код на GDScript

Каркас сгенерирован из `structur/*.cs` (дамп Il2Cpp: есть классы, поля, enum и сигнатуры методов, **тел методов нет**).
Скрипт: `tools/il2cpp_to_gd.py` (`python3 tools/il2cpp_to_gd.py ../structur scripts/ported`). Файлы без заголовка
`# Ported from` (написанные вручную) он пропускает, остальные перезаписывает.

Перенесено 343 класса из 832 корневых: игровое ядро. Не переносились сторонние SDK (BrainCloud, GameSparks, Rewired,
MLAPI, I2), консольная/Steam/Twitch-обвязка, планшетное меню и прочий UI.

| Папка | Что внутри |
|---|---|
| `core/` | GameControl, GameState, GameSettings, Modifiers, VersusControl, ScoreKeeper, Level, … |
| `characters/` | Character, GamePlayer, Player, Spectator, GhostRecorder, … |
| `blocks/` | Placeable и все наследники: Spring, Treadmill, Teleporter, SwingingAxe, … |
| `hazards/` | пилы, лёд, проджектайлы, Doomsday, Kraken, вода, ветер |
| `levels/` | триггеры, коллайдеры, освещение, логика отдельных уровней |
| `camera/`, `input/`, `util/`, `misc/` | камера, курсоры/контроллер, утилиты, остальное |
| `net/` | сетевые сообщения `Msg*` и `NetMsgTypes` |
| `enums/` | отдельные enum (в GDScript — безымянный `enum {}`, доступ `RespawnMode.Off`) |

## Что уже с логикой (написано вручную)

Проверяется тестами `tests/charactertest.tscn` и `tests/blocktest.tscn`. Такие файлы начинаются с «# Каркас … + логика».

- `characters/character.gd` — полноценный персонаж на `CharacterBody2D`; `scripts/player.gd` теперь наследует его.
- `blocks/placeable.gd`, `blocks/active_block.gd` — жизненный цикл блока, зона `Area2D`, физические модификаторы, масса, прикрепление, разрушение.
- Блоки: `spring`, `ice`, `honey`, `goal_block`, `coin`, `toxic_waste`, `linear_saw`, `swinging_axe`, `moving_platform`, `horizontal_moving_platform`.
- Опасности: `hazards/saw_spin`, `hazards/saw_spin_and_move`, `hazards/wind_area` (ветер и чёрная дыра).

Остальные файлы — по-прежнему каркасы с `pass`.

## Подключено к игре

В `game.gd` (`_spawn_ported`) все эти блоки ведут классы из `ported/`; старый код ловушек, листков и шестерёнок удалён:

| Блок в игре | Класс |
|---|---|
| Пружинка, Монета, Флаг | `Spring`, `Coin`, `GoalBlock` |
| Листок (горизонтальный и лифт) | `HorizontalMovingPlatform`, `MovingPlatform` (возит физика: `move_target` — `AnimatableBody2D`) |
| Шестерёнка, Пила-бегунок | `SawSpin`, `SawSpinAndMove` |
| Арбалет, Огнемёт, Маятник | `ProjectileLauncher` + `Projectile`, `Lighter`, `SwingingAxe` |
| Лёд, Мёд, Яд, Пила на рельсе, Ветер | `Ice`, `Honey`, `ToxicWaste`, `LinearSaw`, `WindArea` |
| Телепорт, Дорожка, Вентилятор, Валун, Чёрная дыра | `Teleporter`, `Treadmill`, `UpBlower`, `Boulder`, `Blackhole` |

Блоки работают только в забеге. Стрелы, огонь, маятник и листки считаются по общим часам забега (`Placeable.sync_clock`), поэтому у всех игроков
картина совпадает. Игрок — `Player extends Character`; смерть идёт через `Character.died` и `last_killer`, поэтому очки получает хозяин блока.
Тесты: `tests/portedgametest.tscn`, `tests/bombtest.tscn`, `tests/blocktest.tscn`.

## Правила перевода

- `MonoBehaviour` → `Node2D`, `ScriptableObject` → `Resource`, обычный класс/struct → `RefCounted`.
- `Awake/Start/Update/FixedUpdate/OnDestroy` → `_enter_tree/_ready/_process/_physics_process/_exit_tree`; остальные методы — snake_case, исходное имя в комментарии `# C# ...`.
- Перегруженные методы получают суффикс по числу параметров (`place_1`, `place_3`).
- Типы: `Rigidbody2D`→`RigidBody2D`, `Animator`→`AnimationPlayer`, `SpriteRenderer`→`Sprite2D`, `List<T>`/`T[]`→`Array`, enum-типы → `int`, неизвестные Unity-типы — без аннотации.
- Публичные поля простых типов и узлов — `@export`; свойства — обычные `var`; события — `signal`.
- Имена, совпадающие с членами Node/Object или классами Godot, получают префикс `u_` / суффикс `Unity`.
