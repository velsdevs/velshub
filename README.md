# ⬡ VelsHub

---

## features

### visual
| feature | description |
|---|---|
| Box ESP | outline box per player, different color when behind wall |
| Name ESP | display name above the box |
| Skeleton ESP | 14-bone R15 skeleton lines |
| Health Bar | bar beside the box, color gradient based on hp |
| Wall Penetration | esp stays visible through walls, different color |
| Rainbow ESP | all esp colors rotate hue per frame |
| Chams | SelectionBox surface highlight per part |

### combat
| feature | description |
|---|---|
| Silent Aim | hooks `__index` + `__namecall`, intercepts `Raycast`, `FindPartOnRay` |
| Camera Lock | smooth tween camera to target, fallback for low executors |
| FOV Circle | circle visual with outline, color changes when locked |
| Tracer | line from bottom of screen to target |
| Prediction | `pos + vel*t` with gravity compensation |
| Wall Check | `GetPartsObscuringTarget` based, nil-safe |
| Toggle / Hold | two trigger modes via RMB (configurable) |
| Offset to Move | shift aim toward target movement direction for pre-aim |
| Smoothness | tween-based, adjustable 0–0.5s |

### world
| feature | description |
|---|---|
| Fullbright | max brightness, shadows off, white ambient |
| No Fog | sets FogEnd + FogStart to 100000 |

### anti-cheat
| feature | description |
|---|---|
| GC Anti-Kick | scans `getgc(true)`, patches closures holding a `kick` handler |
| Namecall Anti-Kick | intercepts `__namecall`, silently drops `LocalPlayer:Kick()` |
| Auto Re-Patch | re-scans every 5 seconds to catch runtime-injected kicks |
| Manual Re-Patch | button in the AntiCheat tab |

### auth
| feature | description |
|---|---|
| Supabase Login | REST GET to `accounts` table, matches username + password |
| Register | POST new account directly from the login screen |
| Admin Flag | `is_admin` column, visible in session |

---

## executor support

| executor | level | silent aim | anti-kick namecall | drawing |
|---|---|---|---|---|
| REAL | High | ✅ | ✅ | ✅ |
| MADIUM | High | ✅ | ✅ | ✅ |
| NEXOMIA | High | ✅ | ✅ | ✅ |
| Celery | High | ✅ | ✅ | ✅ |
| XENO | Low | ❌ (camera) | ❌ | ✅ |
| SOLARA | Low | ❌ (camera) | ❌ | depends |

> silent aim automatically falls back to camera method if the executor does not support `hookmetamethod` + `newcclosure` + `checkcaller`.

---
# changelog

all notable changes per version. format: `[version] — date`

---

## [3.1] — 2026

### added
- **Anti-Kick dual layer**
  - layer 1: `getgc(true)` scan — finds closures holding `indexInstance[1] == "kick"`, replaces `tvk` with `WaitForChild("", math.huge)`
  - layer 2: `__namecall` hook — intercepts `LocalPlayer:Kick()` directly and drops it silently
  - auto re-patch loop every 5 seconds to handle kicks injected at runtime
  - manual re-patch button in the new AntiCheat tab
- **AntiCheat tab** — shows GC patch count, executor hook status, toggle for auto re-patch
- **MinBtn logic** (fix carried from v3.0) — minimize now actually resizes the window and hides content via tween
- anti-kick and silent aim `__namecall` hooks merged into one closure to prevent conflict

### fixed
- **ChamsApplied flag** — replaced per-frame `GetDescendants` loop just to check existence. now O(1) per player per frame
- **AimWallCheck nil guard** — `pos` is validated before being passed to `GetPartsObscuringTarget`, wrapped in `pcall`
- **double `hookmetamethod` conflict** — anti-kick namecall and silent aim namecall now share one hook closure

---

## [3.0.1] — 2026

### fixed
- replaced `HttpService:RequestAsync` with `request` / `http.request` / `syn.request` for broader executor compatibility
- removed emoji from status text that caused some executors to crash during JSON encode
- executor detection made more robust — now checks for `hookmetamethod + newcclosure + getnamecallmethod + checkcaller` together instead of just the executor name

---

## [3.0] — 2026

### added
- **Supabase REST auth** — login and register via HTTP to the `accounts` table, replaces in-memory AccountDB
- **Dual-method aimbot**
  - `Camera` mode: smooth tween `Camera.CFrame`, safe on all executors
  - `Silent` mode: `hookmetamethod(game, "__index")` intercepts `Mouse.Hit` + `Mouse.UnitRay`, plus `__namecall` intercepts `workspace:Raycast`, `FindPartOnRay`, `FindPartOnRayWithIgnoreList`
- **Wall Penetration ESP** — box still renders through walls, switches to `WallPenColor`
- **FOV locked color** — FOV circle color changes to red when a target is locked
- **Tracer** — line from bottom-center of screen to target
- **Toggle mode aimbot** — RMB can be hold or toggle
- **Offset to Move** — shifts aim toward target's `MoveDirection`
- **Executor level detection** — auto-selects method based on executor capabilities
- **[K] keybind** — toggle gui hide/show with debounce
- **Collapsible sections** — each section in a tab can be collapsed
- **Register button** on the login screen

### changed
- GUI fully redesigned: sidebar navigation replaces horizontal tab bar
- login screen has entry animation, particle background, and spinning logo
- window is now `620x480` with a `150px` sidebar
- color palette updated to a deeper dark pink-purple

### removed
- Admin tab (in-memory) — replaced by Supabase
- `hookfunction` based silent aim — replaced by `hookmetamethod`

---

## [2.1] — 2026

### fixed
- **silent aim root cause** — replaced `hookfunction(Mouse.__index)` with `getrawmetatable(Mouse)` + `setreadonly` + manual `__index` swap. the old version literally did nothing
- **login gate double layer** — gate on tab button click (red flash feedback) and inside `SwitchTab()` (hard block), cannot be bypassed from either side
- **Z depth check** — all `WorldToViewportPoint` calls now check `s.Z > 0`. fixes ESP flickering and inverting when a player is behind the camera
- `GetPartsObscuringTarget` — replaced deprecated `FindPartOnRayWithIgnoreList`

### added
- version label in titlebar
- AntiCheat tab stub

---

## [2.0] — 2026

### added
- **ESP system** — Box, Name, Skeleton (14-bone R15), Health Bar, Chams (SelectionBox based)
- **FOV Circle** with outline layer
- **Rainbow Chams + Rainbow FOV** via per-frame hue rotation
- **Fullbright** — brightness 10, shadows off, white ambient
- **No Fog** — FogEnd + FogStart set to 100000
- **Gravity Compensation** in prediction — `pos - 0.5 * g * t^2`
- **Team Check** separate for ESP and Aimbot
- **Minimize button** (no logic yet, fixed in v2.1)
- **Close button** — destroys ScreenGui
- **Titlebar drag**
- Tab system: Login / Visual / Combat / Misc / World / Admin

### changed
- auth moved to in-memory `AccountDB` + Admin tab for account creation + license generation
- Discord webhook logging for login events + new account creation
- consistent dark pink-purple theme across all elements

### removed
- single flat script with no tabs from v1.x

---

## [1.1] — 2026

### added
- login system (in-memory, username + password)
- admin page — create accounts, generate licenses `VELS-XXXX-XXXX-XXXX-XXXX`
- Discord webhook — realtime log for successful/failed logins and new accounts

### fixed
- GUI could not be dragged while a TextBox was focused

---

## [1.0] — 2026

### added
- silent aim via `hookfunction(Mouse.__index)` (later found to be broken, fixed in v2.1)
- FOV Circle Drawing
- basic prediction `pos + vel * t`
- wall check via `workspace:Raycast`
- team check
- simple GUI: toggle, FOV slider, prediction slider
- initial pink-purple theme
