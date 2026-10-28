#!/usr/bin/env python3
"""Il2Cpp dump (.cs, empty bodies) -> GDScript skeletons for Godot 4.3."""
import os, re, sys, shutil, collections

SRC = sys.argv[1]
OUT = sys.argv[2]
DRY = len(sys.argv) > 3 and sys.argv[3] == "dry"

EXCL = re.compile(r"^(Tablet|Twitch|Admin|Xbox|XBOne|X360|PS4|Switch|GameSparks|Gamesparks|RealGameSparks|Braincloud|BCGS|"
    r"Steam|Featured|Matchmak|UnityMatchmaker|Relay|RTData|MPSD|Noodle|Paid|Premium|Monetization|Price|Restore|Report|"
    r"ShareDialog|Reddit|Twitter|Credit|Analytic|Achievement|Google|GPGS|Wwise|BitSummit|Crypto|Debug|Logger|LogCatcher|"
    r"Cheat|Console|NetworkTester|NetworkUI|NetworkTerminal|NetworkDebug|NetworkConnectivity|RegionPinger|IPMan|"
    r"WordFilter|QuickSaver|RamFS|SaveFile|SaveGame|SaveRule|SaveSystem|XMLSaver|Stat[A-Z]|Treehouse|TreeHouse|Lobby|LocalLobby|"
    r"Online|MainMenu|Pickable(?!Block)|UI|Gamepad|MultiController|ControllerMonitor|ControllerDisconnect|PauseFade|"
    r"Preloader|Loading|Splash|CanvasSplash|Graphpaper|HoldableButton|Dropdown|Checkbox|Scrolly|ScrollArrow|ControlTip|"
    r"ControlDisplay|ControlScheme|controlScheme|Clipboard|CopyCode|GetCode|OpenURL|UserInfo|UserMessage|UserReports|"
    r"Comment|Chat|Connection|Thumbnail|Trial|Volume|Vote|Hotseat|HotSeat|AFK|Billing|Store|Unlock|UnLock|Key(Item|board)|"
    r"MouseMovement|Mouse|Hide(Window|Outside)|Spraypaint|SpriteFont|SpriteSheetTool|SpriteHue|ImageColor|Fade|"
    r"CanvasGroup|CanvasScaler|AspectRatio|SafeArea|ContentScaler|Localization|ZeroAnchored|AnchoredPosition|"
    r"DelayTweener|LocalScaleTweener|MultiTweener|SequenceTweener|TimedTweener|WaitForCondition|"
    r"Disable|Daily|Deletedialog|DeleteDialog|Favourite|Flag(?=Button)|Generic|AcceptButton|InControl|ServiceS|ServiceT|Rewired|"
    r"Platform|Encrypt|Thread|Worker|Coroutine|EditorCoroutine|AsyncCommand|Parsing|DataModel|IBackend|AttractMode|"
    r"Retry|SceneManager|NoRichPresence|RichPresence|Registered|RegisterListeners|StatusSlot|Mod(sDisplay)|HSVColor|"
    r"PreserveRelative|Handicap|handicap|buttonTypes|quicklevel|quickstart|mouseTest|walljumptest|characterCounter|"
    r"puck|cloud$|countDownStart|deleteSprite|emoteDirections|snapper|MessagingSystem|MessageComponent|NoItems|NoLocalize|"
    r"CharacterPortrait|CharacterCreator|CharacterSprite|CharacterSound|CharacterAudio|CharacterFalling|Outfit|SFR|"
    r"HighscoreDisplay|Score(Piece|card|board)|Scoreboard|BaseScoreboard|GraphScoreBoard|ChallengeScoreboard|TrackGraph|"
    r"ThreadJob|Timegate|Tip|Turn(Indicator)|Win(Message)|SuddenDeathMessage|LastTurnMessage|ReadyMessage|"
    r"PlacementEnding|FeaturedBatch|Pause|Credits|OutOfMatches|LevelThumbnail|LevelSelect|LevelPortal|CustomLevelPortal|"
    r"LevelUnlock|LevelStart|GameModeIndicator|GameModePortalLock|LivesDisplay|PlayerStatusDisplay|TextChanger|TextFlipper|"
    r"Util_(Image|RawImage|Text)|Inventory|ItemHelp|ItemPickup|PlayerJoin|playerJoin|Pointer|PointCounter|Ping|Blank|"
    r"EmoteAnimationEvent|MobileEmote|OnlineChat|Emote|Camera(MoveAnimator|Flipper)|HideOutside|GroupDebug|"
    r"CharacterOpacity|TagComparer|Sort|UniqueSprite|FindNetID|Network(Surrogate|PlayerTracker)|Stats|NoAch|Xb1|UCHOnline|ViewReports|UGC|Button|FreeplayFull|FreeplayMode|FreeplayPlay|DigitalClock|HoldB|ChallengeTime|ColorPick|AreaAudio|Becom|BeamParticle|SpriteSplash|ArtMatcher|ModeDependant|IPickable|DuckTape)", re.I)

# ---------- type mapping ----------
PRIM = {"int":"int","uint":"int","long":"int","ulong":"int","short":"int","ushort":"int","byte":"int","sbyte":"int",
        "float":"float","double":"float","bool":"bool","string":"String","char":"String",
        "Vector2":"Vector2","Vector3":"Vector3","Vector4":"Vector4","Vector2Int":"Vector2i","Vector3Int":"Vector3i",
        "Color":"Color","Color32":"Color","Quaternion":"Quaternion","Rect":"Rect2","Bounds":"AABB","Matrix4x4":"Projection",
        "GameObject":"Node2D","Transform":"Node2D","RectTransform":"Control","Component":"Node","MonoBehaviour":"Node2D",
        "Rigidbody2D":"RigidBody2D","Rigidbody":"RigidBody3D","Collider2D":"CollisionShape2D","BoxCollider2D":"CollisionShape2D",
        "CircleCollider2D":"CollisionShape2D","PolygonCollider2D":"CollisionPolygon2D","EdgeCollider2D":"CollisionShape2D",
        "CapsuleCollider2D":"CollisionShape2D","Animator":"AnimationPlayer","Animation":"AnimationPlayer","SpriteRenderer":"Sprite2D",
        "AudioSource":"AudioStreamPlayer","AudioClip":"AudioStream","Camera":"Camera2D","Sprite":"Texture2D","Texture2D":"Texture2D",
        "Texture":"Texture2D","Material":"Material","ParticleSystem":"GPUParticles2D","LineRenderer":"Line2D","Light":"Light2D",
        "AnimationCurve":"Curve","Canvas":"CanvasLayer","Text":"Label","Image":"TextureRect","RawImage":"TextureRect",
        "Action":"Callable","Func":"Callable","UnityAction":"Callable","Delegate":"Callable"}
EXPORTABLE = {"int","float","bool","String","Vector2","Vector3","Color","Quaternion","Rect2"}
EXPORT_NODE = {"Node2D","Node","Control","RigidBody2D","CollisionShape2D","CollisionPolygon2D","AnimationPlayer","Sprite2D",
        "AudioStreamPlayer","Camera2D","Texture2D","GPUParticles2D","Line2D","Light2D","Label","TextureRect","AudioStream"}
BASE_MAP = {"MonoBehaviour":"Node2D","NetworkBehaviour":"Node2D","ScriptableObject":"Resource","Exception":"RefCounted",
            "Selectable":"Control","Button":"Control","Graphic":"Control","MaskableGraphic":"Control","Text":"Label","Image":"TextureRect",
            "UIBehaviour":"Control","Slider":"Control","Toggle":"Control","MessageBase":"RefCounted","Object":"RefCounted",
            "Attribute":"RefCounted","PropertyAttribute":"RefCounted","StateMachineBehaviour":"Node"}
KW = set("""var func class extends signal const enum static match in is as self super pass return if elif else for while break
continue await yield assert breakpoint preload void true false null and or not when PI TAU INF NAN class_name""".split())
# members that would clash with Node/CanvasItem/Node2D/Control/RigidBody2D built-ins
NODE_PROPS = set("""name owner scene_file_path process_mode process_priority position rotation rotation_degrees scale skew transform
global_position global_rotation global_scale global_transform visible modulate self_modulate z_index z_as_relative material size
mass gravity_scale linear_velocity angular_velocity text color mouse_filter focus_mode theme texture offset flip_h flip_v frame
playing speed_scale pitch_scale volume_db stream autoplay current zoom enabled top_level light_mask lock_rotation freeze sleeping
inertia bounce friction physics_material_override constant_force can_sleep custom_integrator collision_layer collision_mask
disabled shape polygon points width antialiased lifetime emitting amount one_shot explosiveness energy range layout_mode
anchors_preset tooltip_text clip_contents pivot_offset script""".split())
NODE_FUNCS = set("""to_string get_name set_name get_parent add_child remove_child get_child get_children queue_free get_tree show hide
set_visible is_visible get_position set_position get_rotation set_rotation get_scale set_scale get_transform set_transform
translate rotate look_at get_owner set_owner find_child get_node duplicate free call emit_signal connect disconnect get set
notification get_meta set_meta has_meta get_viewport get_window get_index move_child reparent is_in_group add_to_group
set_process set_physics_process is_processing get_path get_class is_class get_instance_id get_script set_script apply_scale
apply_impulse apply_force add_force get_mass set_mass get_size set_size get_text set_text get_color set_color get_modulate
set_modulate get_rect get_angle_to move_local_x move_local_y global_translate to_local to_global get_global_position
set_global_position get_global_rotation set_global_rotation get_z_index set_z_index get_material set_material
get_texture set_texture play stop pause is_playing seek get_speed_scale set_speed_scale get_volume_db set_volume_db
get_stream set_stream grab_focus release_focus has_focus get_theme set_theme get_tooltip set_tooltip
set_process_mode get_process_mode set_physics_process_priority get_gravity_scale set_gravity_scale get_linear_velocity
set_linear_velocity get_angular_velocity set_angular_velocity sleep wake_up get_zoom set_zoom get_offset set_offset
is_enabled set_enabled get_shape set_shape get_frame set_frame is_flipped_h set_flip_h""".split())

_MEM = {m for m in open("/tmp/godot_members.txt").read().split() if not m.startswith("_")}
NODE_PROPS |= _MEM
NODE_FUNCS |= _MEM

def snake(n):
    n = re.sub(r"[^0-9A-Za-z_]", "_", n)
    n = re.sub(r"(?<=[a-z])(?=\d)", "_", n)
    s = re.sub(r"(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])", "_", n).lower()
    s = re.sub(r"(\d)_d(?=_|$)", r"\1d", s)
    s = re.sub(r"_+", "_", s).strip("_") or "x"
    if s[0].isdigit(): s = "_" + s
    return s

def safe_var(n, cls_props):
    s = snake(n)
    if s in KW: s += "_"
    if s in NODE_PROPS or s in NODE_FUNCS: s = "u_" + s
    return s

LIFECYCLE = {"Awake":"_enter_tree","Start":"_ready","Update":"_process","LateUpdate":"_process","FixedUpdate":"_physics_process",
             "OnDestroy":"_exit_tree"}

# ---------- parser ----------
TYPE_RE = re.compile(r"^(?:(?:public|private|protected|internal)\s+)?((?:(?:abstract|sealed|static|new|partial)\s+)*)(class|struct|enum|interface)\s+(\w+)(?:<[^>]*>)?(?:\s*:\s*(.+))?$")

class T:
    def __init__(s, kind, name, bases, mods):
        s.kind, s.name, s.bases, s.mods = kind, name, bases, mods
        s.members, s.nested, s.enum_vals = [], [], []

def skip_body(lines, i):
    # lines[i] == '{' ; return index after matching '}'
    d = 0
    while i < len(lines):
        d += lines[i].count("{") - lines[i].count("}")
        i += 1
        if d == 0: break
    return i

def split_generic(s):
    out, d, cur = [], 0, ""
    for ch in s:
        if ch == "<": d += 1
        if ch == ">": d -= 1
        if ch == "," and d == 0: out.append(cur.strip()); cur = ""
        else: cur += ch
    if cur.strip(): out.append(cur.strip())
    return out

def parse_block(lines, i, t):
    pending = []
    while i < len(lines):
        s = lines[i].strip()
        if not s: i += 1; continue
        if s == "}": return i + 1
        if s.startswith("["): pending.append(s); i += 1; continue
        m = TYPE_RE.match(s)
        if m:
            mods, kind, name, bases = m.groups()
            nt = T(kind, name, split_generic(bases) if bases else [], mods)
            nt.vis = s.split()[0]
            i += 1
            while lines[i].strip() != "{": i += 1
            i = parse_block(lines, i + 1, nt)
            if "_003C" not in name and "<" not in name: t.nested.append(nt)
            pending = []
            continue
        if t.kind == "enum":
            m2 = re.match(r"^(\w+)(?:\s*=\s*([^,]+))?,?$", s)
            if m2: t.enum_vals.append((m2.group(1), m2.group(2)))
            i += 1; pending = []; continue
        # member
        if s.endswith(";"):
            t.members.append(("field", s[:-1], pending)); i += 1
        else:
            hdr = s; i += 1
            if i < len(lines) and lines[i].strip() == "{":
                i = skip_body(lines, i)
            t.members.append(("prop" if "(" not in hdr else "method", hdr, pending))
        pending = []
    return i

def parse_file(path):
    lines = open(path, encoding="utf-8-sig").read().split("\n")
    root = T("file", "", [], "")
    parse_block(lines + ["}"], 0, root)
    return root.nested

# ---------- model ----------
files = {}  # file base -> list of top types
for f in sorted(os.listdir(SRC)):
    if f.endswith(".cs") and os.path.isfile(os.path.join(SRC, f)) and f not in ("Properties",):
        try: files[f[:-3]] = parse_file(os.path.join(SRC, f))
        except Exception as e: print("PARSE FAIL", f, e)

alltypes = {}
for fb, ts in files.items():
    for t in ts: alltypes[t.name] = (fb, t)

def base_class(t):
    for b in t.bases:
        b0 = re.sub(r"<.*", "", b)
        if re.match(r"^I[A-Z]", b0) and b0 not in alltypes: continue
        return b0
    return None

# inclusion
included = set()
for name, (fb, t) in alltypes.items():
    if fb != name: pass
    if not EXCL.match(name) and not EXCL.match(fb): included.add(name)
# closure over bases
changed = True
while changed:
    changed = False
    for n in list(included):
        b = base_class(alltypes[n][1])
        if b in alltypes and b not in included:
            included.add(b); changed = True

# drop Unity-only wrappers
for n in list(included):
    if n.startswith("_003C") or "k__" in n: included.discard(n)

def is_placeable(n, seen=()):
    if n == "Placeable": return True
    if n not in alltypes or n in seen: return False
    b = base_class(alltypes[n][1])
    return b is not None and is_placeable(b, seen + (n,))

def category(n):
    fb, t = alltypes[n]
    if t.kind == "enum": return "enums"
    if n.startswith("Msg") or n in ("NetMsgTypes",): return "net"
    if is_placeable(n): return "blocks"
    rules = [
        ("characters", r"^(Character|GamePlayer|Player|Spectator|NameTag|GhostData|GhostRecorder|Jetpack|KickTracker|Slowerer)"),
        ("input", r"^(Controller|InputEvent|InputMethod|InputReceiver|Cursor|PartyCursor|PickCursor|RulePickCursor|PiecePlacementCursor|LobbyCursor)"),
        ("camera", r"^(ZoomCamera|FollowCamera|MirrorCamera|CameraShaker|OriginManager|ScreenToWorld|FixedDepthFollow|RemoveCameraTarget)"),
        ("core", r"^(Game(Control|State|Settings|LimitType|RuleP|RuleProp)|Modifiers|ModSource|ModifierPair|StartGameState|WinState|VersusControl|FreePlayControl|ChallengeControl|CreateGameControl|TimeController|Timekeeper|Stopwatch|RunTimer|RespawnMode|PartyBox|DoublePartyBox|Level$|LevelPhysics|PhysicsModifier|ColliderMode|ViewDirection|SyncedRandom|WeightedBlockList|PlaceableMetadata|PlaceableOrder|ScoreKeeper|ScoreLine|PlayerScore|PlayerManager|Spawner|ObjPool|SmokePool)"),
        ("hazards", r"(Saw|Axe|Bomb|Kill|Spike|Ice|Fire|Lava|Meteor|Toxic|Water|Drown|Honey|Bee|Blackhole|Boulder|Kraken|Tentacle|Projectile|Cannon|Wind|Blower|Teleporter|Hockey|Scrap|Volcano|Doomsday|Punching|Treadmill|Wave|Hydrant|Fly$|Surfboard|Sphynx|Shooter|Airplane|Arrow)"),
        ("levels", r"(Raft|Metro|Roller|Ferris|Elevator|Vat|Crane|Dumb|Cloud|Grass|Light|Dance|Door|Barn|Underground|Metal|Moving|Platform|Background|Level|Surf|Coin|Goal|Flag|Lab|Party|Honey|Spawn|Collider|Collision|Check|Trigger|Attach|Block|Treadmill)"),
        ("util", r"^(Util_|Vector2Extension|Collider2DExtensions|LoopArrays|Easings|Tweener|Parsing|TagComparer|BitMask|Stopwatch|Surf|SmokeEffect|Slow|Spin|Offset|Flash|Rotate)"),
    ]
    for cat, rx in rules:
        if re.search(rx, n): return cat
    return "misc"

CLASSDIR = {n: category(n) for n in included}

# unique class_name handling
GODOT_CLASSES = set("""Tween Tweener Timer Logger Curve Light2D Label Control Node Resource Object Input Time OS Engine Marker2D Path2D Line2D
Skeleton2D Camera2D Area2D Sprite2D RayCast2D Window Viewport Shape2D Material Environment Image Texture2D Animation Thread Mutex
Semaphore Expression RegEx Crypto JSON Gradient Cursor PhysicsServer2D Projection Plane Basis Transform2D Callable Signal Range Button
Slider Panel Popup Tree Container Skeleton Timekeeper_ Teleporter_""".split())
GODOT_CLASSES |= set(open("/tmp/godot_classes.txt").read().split()) | {"Vector2","Vector3","Color","Rect2","Plane","Basis","AABB","Quaternion","Variant","Array","Dictionary","String","Callable","Signal","Projection","Transform2D","Transform3D","RID","Time","JSON","Tween"}
EXISTING = {"Player","Catalog","Art","Net","Game","Main"}
CNAME = {}
for n in included:
    cn = n
    if cn in GODOT_CLASSES or cn in EXISTING: cn = cn + "Unity"
    CNAME[n] = cn

ARITY = collections.defaultdict(set)
for _n in included:
    for _k, _h, _a in alltypes[_n][1].members:
        if _k == "method":
            _m = re.match(r"^(?:.+?\s+)?(\w+)(?:<[^>]*>)?\((.*)\)\s*$", _h.strip())
            if _m: ARITY[_m.group(1)].add(len(parse_params_early(_m.group(2))) if False else (0 if not _m.group(2).strip() else len(split_generic(_m.group(2)))))
MEMBERS = {}

def node_based(n):
    seen = set()
    while n in included and n not in seen:
        seen.add(n); b = base_class(alltypes[n][1])
        if b in included: n = b; continue
        return BASE_MAP.get(b, "Node2D" if b else "RefCounted") in ("Node2D","Node","Control","Label","TextureRect")
    return False

def inherited_names(t):
    out = set(); b = base_class(t); seen = set()
    while b in included and b not in seen:
        seen.add(b); out |= MEMBERS.get(b, set()); b = base_class(alltypes[b][1])
    return out

# ---------- emission ----------
def gd_type(t, known_enums=None):
    t = t.strip()
    t = re.sub(r"^(ref|out|in|params)\s+", "", t)
    if t.endswith("?"): return None
    if t.endswith("[]") or re.match(r"^(List|IList|IEnumerable|HashSet|Queue|Stack|ICollection|IReadOnlyList)<", t): return "Array"
    if t.startswith("Dictionary<") or t.startswith("IDictionary<"): return "Dictionary"
    if t.startswith(("Action", "Func<", "UnityAction", "Predicate")): return "Callable"
    base = re.sub(r"<.*", "", t).split(".")[-1]
    if base in PRIM: return PRIM[base]
    if base == "void": return "void"
    if base in included and alltypes[base][1].kind in ("class",):
        return CNAME[base]
    if base in alltypes and alltypes[base][1].kind == "enum": return "int"
    return None

def parse_params(ps):
    out = []
    if not ps.strip(): return out
    for p in split_generic(ps):
        p = p.split("=")[0].strip()
        p = re.sub(r"^\[.*?\]\s*", "", p)
        parts = p.rsplit(" ", 1)
        if len(parts) != 2: continue
        ty, nm = parts
        out.append((ty, nm))
    return out

LIT = re.compile(r'^-?\d+(\.\d+)?[fFdDuUlL]*$|^"[^"]*"$|^(true|false)$')

def clean_lit(v):
    v = v.strip()
    m = re.match(r"^(-?\d+(?:\.\d+)?)[fFdDuUlL]*$", v)
    if m: return m.group(1)
    return v if LIT.match(v) else None

def emit_members(t, ind, lines, local_cls):
    used = set(); n_over = collections.Counter()
    inh = inherited_names(t) if ind == "" else set()
    isnode = ind == "" and node_based(t.name)
    for kind, hdr, attrs in t.members:
        if "_003C" in hdr or "k__BackingField" in hdr or "op_" in hdr: continue
        h = re.sub(r"^\s*(public|private|protected|internal)\s+", "", hdr)
        vis = hdr.split()[0] if hdr.split()[0] in ("public","private","protected","internal") else "private"
        static = bool(re.search(r"\bstatic\b", h))
        h = re.sub(r"\b(static|readonly|override|virtual|abstract|sealed|new|unsafe|extern|volatile|internal|protected)\s+", "", h)
        if kind == "field":
            if h.startswith("event "):
                m = re.match(r"event\s+.+?\s+(\w+)$", h)
                if m:
                    nm = snake(m.group(1))
                    if nm in used or nm in inh: continue
                    used.add(nm); lines.append(f"{ind}signal {nm}  # C# event {m.group(1)}")
                continue
            if h.startswith("delegate "): continue
            const = h.startswith("const ")
            h = re.sub(r"^const\s+", "", h)
            val = None
            if "=" in h: h, val = h.split("=", 1)
            m = re.match(r"^(.+?)\s+(\w+)\s*$", h.strip())
            if not m: continue
            ty, nm = m.groups()
            gt = gd_type(ty); vn = safe_var(nm, used)
            if vn in used or vn in inh or vn.upper() in inh: continue
            used.add(vn)
            if const and val is not None and clean_lit(val) is not None:
                lines.append(f"{ind}const {vn.upper() if vn.lower()==vn else vn}{': '+gt if gt in ('int','float','bool','String') else ''} = {clean_lit(val)}")
                continue
            exp = isnode and vis == "public" and not static and not const and (gt in EXPORTABLE or gt in EXPORT_NODE)
            lines.append(f"{ind}{'@export ' if exp else ''}{'static ' if static else ''}var {vn}{': '+gt if gt and gt!='void' else ''}")
        elif kind == "prop":
            m = re.match(r"^(.+?)\s+(\w+)$", h.strip())
            if not m or "." in m.group(2) or "_002E" in h: continue
            gt = gd_type(m.group(1)); vn = safe_var(m.group(2), used)
            if vn in used or vn in inh: continue
            used.add(vn)
            lines.append(f"{ind}{'static ' if static else ''}var {vn}{': '+gt if gt and gt!='void' else ''}  # C# property")
        else:
            m = re.match(r"^(?:(.+?)\s+)?(\w+)(?:<[^>]*>)?\((.*)\)\s*$", h.strip())
            if not m: continue
            ret, nm, ps = m.groups()
            if ret is None or nm == t.name or nm.startswith("_003C") or "_002E" in nm: continue   # ctor / explicit iface impl
            if nm in ("Finalize", "Dispose", "GetEnumerator", "MoveNext", "Reset"): continue
            params = parse_params(ps)
            if nm in LIFECYCLE:
                gn = LIFECYCLE[nm]
                plist = "delta: float" if gn in ("_process", "_physics_process") else ""
                n_over[gn] += 1
                if n_over[gn] > 1 or gn in used: continue
                used.add(gn)
                lines.append(f"{ind}func {gn}({plist}) -> void:  # C# {nm}")
                lines.append(f"{ind}\tpass")
                continue
            gn = snake(nm)
            if gn in KW: gn += "_"
            if len(ARITY[nm]) > 1: gn += f"_{len(params)}"
            if gn in NODE_FUNCS: gn = "u_" + gn
            if gn in used:
                k = 2
                while f"{gn}_{k}" in used: k += 1
                gn = f"{gn}_{k}"
            used.add(gn)
            plist, pn = [], set()
            for ty, pnm in params:
                pv = snake(pnm)
                if pv in KW: pv += "_"
                while pv in pn: pv += "_"
                pn.add(pv)
                pt = gd_type(ty)
                plist.append(f"{pv}{': '+pt if pt and pt!='void' else ''}")
            rt = gd_type(ret)
            coro = ret.startswith("IEnumerator")
            r = f" -> {rt}" if rt else (" -> void" if ret.strip() == "void" else "")
            lines.append(f"{ind}{'static ' if static else ''}func {gn}({', '.join(plist)}){r}:  # C# {nm}{' (coroutine)' if coro else ''}")
            if rt and rt != "void":
                dv = {"int":"0","float":"0.0","bool":"false","String":'""',"Vector2":"Vector2.ZERO","Vector3":"Vector3.ZERO",
                      "Color":"Color.WHITE","Array":"[]","Dictionary":"{}","Callable":"Callable()","Quaternion":"Quaternion.IDENTITY",
                      "Vector4":"Vector4.ZERO","Vector2i":"Vector2i.ZERO","Vector3i":"Vector3i.ZERO","Rect2":"Rect2()","AABB":"AABB()",
                      "Projection":"Projection.IDENTITY"}.get(rt, "null")
                lines.append(f"{ind}\treturn {dv}")
            else:
                lines.append(f"{ind}\tpass")
        if lines and lines[-1] != "": lines.append("")

def gd_base(t, name, cat):
    b = base_class(t)
    if b in included: return CNAME[b]
    if b in BASE_MAP: return BASE_MAP[b]
    if b is None:
        return "RefCounted"
    if t.kind in ("struct", "interface"): return "RefCounted"
    if b in alltypes: return "Node2D"
    return "Node2D"

def emit_type(t, cname, cat, top, srcfile):
    L = []
    if top:
        L.append(f"# Ported from structur/{srcfile}.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)")
        L.append(f"class_name {cname}")
        if t.kind == "enum":
            L.append("extends RefCounted"); L.append("")
            L.append("enum {")
            for n, v in t.enum_vals: L.append(f"\t{n+'_' if (n in KW or n in GODOT_CLASSES) else n}{' = '+v.strip() if v else ''},")
            L.append("}")
            return L
        L.append(f"extends {gd_base(t, t.name, cat)}")
        if "abstract" in t.mods: L.append("# abstract in C#")
        L.append("")
    for nt in t.nested:
        if nt.kind == "enum":
            en = nt.name + "_" if nt.name in GODOT_CLASSES or nt.name in KW else nt.name
            L.append(f"enum {en} {{")
            for n, v in nt.enum_vals: L.append(f"\t{n+'_' if (n in KW or n in GODOT_CLASSES) else n}{' = '+v.strip() if v else ''},")
            L.append("}"); L.append("")
        elif nt.kind in ("struct", "class") and nt.vis != "private" or nt.kind == "struct":
            if nt.members:
                L.append(f"class {nt.name} extends RefCounted:")
                sub = []
                emit_members(nt, "\t", sub, nt)
                L.extend(sub or ["\tpass"]); L.append("")
    emit_members(t, "", L, t)
    MEMBERS[t.name] = {re.sub(r"^u_", "", x) for x in re.findall(r"^(?:@export )?(?:static )?(?:var|const|signal|func) (\w+)", "\n".join(L), re.M)} | {x for x in re.findall(r"^(?:@export )?(?:static )?(?:var|const|signal|func) (\w+)", "\n".join(L), re.M)}
    return L

# ---------- write ----------
count = collections.Counter(); written = []
order, _seen = [], set()
def _visit(n):
    if n in _seen: return
    _seen.add(n)
    b = base_class(alltypes[n][1])
    if b in included: _visit(b)
    order.append(n)
for n in sorted(included): _visit(n)
for n in order:
    fb, t = alltypes[n]
    cat = CLASSDIR[n]
    L = emit_type(t, CNAME[n], cat, True, fb)
    # collapse trailing blank lines
    out = []
    for ln in L:
        if ln == "" : continue
        if out and not ln.startswith(("\t", " ")):
            prev = next(p for p in reversed(out) if not p.startswith("\t"))
            isf = ln.startswith(("func", "static func")); pf = prev.startswith(("func", "static func"))
            hdr = ln.startswith(("# Ported", "class_name", "extends", "# abstract")) or prev.startswith(("# Ported", "class_name"))
            if (isf or pf != isf or ln.startswith(("enum", "class "))) and not hdr and out[-1] != "": out.append("")
            if prev.startswith("extends") and out[-1] != "": out.append("")
        out.append(ln)
    text = "\n".join(out).rstrip() + "\n"
    path = os.path.join(OUT, cat, snake(n) + ".gd")
    count[cat] += 1; written.append((cat, n))
    if not DRY and os.path.exists(path) and not open(path).read().startswith("# Ported from"):
        print("skip hand-written:", path); continue
    if not DRY:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        open(path, "w").write(text)
print(dict(count), "total", sum(count.values()), "of", len(alltypes))
if DRY:
    for c in sorted(set(c for c,_ in written)):
        print(c, ":", " ".join(n for cc,n in written if cc==c))
