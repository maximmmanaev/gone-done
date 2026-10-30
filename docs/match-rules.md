# Правила матча: что известно из оригинала

Источник: `code/src/Assembly-CSharp/GameControl.cs`, `GameState.cs`, `ScoreKeeper.cs`, `VersusControl.cs`
(код восстановлен из ARM64: структура и имена сохранились, числовые константы и строки — нет).

## Фазы

Оригинал (`GameControl.GamePhase`): `NONE, START, PLAY, PLACE, SUDDENDEATH, END, WAIT`.

| Оригинал | Эта игра (`Catalog.Phase`) |
|---|---|
| `START` | `LOBBY` → `PICK` (выбор блока) |
| `PLACE` | `PLACE` (расстановка) |
| `PLAY` | `RUN` (забег) |
| `SUDDENDEATH` | решающий раунд при ничьей на цели (правило «ничья на финише» в README) |
| `END` | `RESULT` / `OVER` |
| `WAIT` | ожидание игроков в лобби |

Порядок фаз совпадает с оригиналом, механика матча уже работает в `scripts/game.gd` и на сервере (`cloudflare/`).

## Очки и цель

В `ScoreKeeper.cs`/`VersusControl.cs` значения очков за финиш, первое место, монету и ловушку не сохранились
(`object x = 0`), а `maxScore` настраивается в правилах (`GameSettings.minMaxScore .. maxMaxScore`, значения тоже потеряны).
Поэтому таблица очков в README — **GUESS**, и она не менялась. Если у вас есть данные о настоящих значениях
(скриншот правил, запись матча), их стоит занести в `Catalog` и в `cloudflare/src/catalog.js`.

## Режимы

В оригинале `GameMode`: `FREEPLAY, CREATIVE, PARTY, CHALLENGE`; уровней более 20 (`GameState.LevelName`:
`FARM, ROOFTOPS, OLDMANSION, WATERFALL, PYRAMID, WINDMILL, METALPLANT, ICEBERG, …`). Сейчас в игре четыре
картинки-уровня вместо оригинальных — вне объёма шагов 1–4.
