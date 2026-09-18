-- ================================================
-- VelsHub v3.2.1 | + Invisible + Fly + Info Sidebar
-- Synapse X | Full UNC
-- ================================================

local CONFIG = {
    SupabaseURL = "https://glkrwegvlmowprdbobkc.supabase.co",
    SupabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsa3J3ZWd2bG1vd3ByZGJvYmtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk2NDEwOTgsImV4cCI6MjEwNTIxNzA5OH0.229jGLrrhuFJwp8GUpMzhTIhWqAdgCggYHB2SNF4BNc",

    ESP = {
        Enabled           = true,
        Box               = true,
        BoxStyle          = "Corner",
        BoxThickness      = 1.5,
        Name              = true,
        Skeleton          = true,
        HealthBar         = true,
        Chams             = true,
        WallPenetration   = true,
        TeamCheck         = false,
        MaxDistance       = 1000,
        RefreshRate       = 1/60,
        BoxColor          = Color3.fromRGB(220, 100, 180),
        NameColor         = Color3.fromRGB(255, 180, 230),
        SkeletonColor     = Color3.fromRGB(180, 80, 220),
        SkeletonThickness = 1.5,
        WallPenColor      = Color3.fromRGB(255, 100, 100),
        ChamsColor             = Color3.fromRGB(160, 50, 200),
        ChamsOccludedColor     = Color3.fromRGB(100, 20, 140),
        ChamsOutlineColor      = Color3.fromRGB(220, 100, 180),
        ChamsTransparency      = 0.5,
        ChamsOutlineTransparency = 0,
        Tracer            = false,
        TracerOrigin      = "Bottom",
        TracerThickness   = 1,
        TracerColor       = Color3.fromRGB(220, 100, 180),
        Snaplines         = false,
    },

    Aimbot = {
        Enabled         = true,
        Method          = "Camera",
        TriggerKey      = Enum.UserInputType.MouseButton2,
        Toggle          = false,
        LockPart        = "Head",
        Smoothness      = 0.12,
        OffsetToMove    = true,
        OffsetAmount    = 15,
        TeamCheck       = false,
        AliveCheck      = true,
        WallCheck       = true,
        FOVEnabled      = true,
        FOV             = 180,
        FOVColor        = Color3.fromRGB(220, 100, 180),
        FOVLockedColor  = Color3.fromRGB(255, 80, 120),
        FOVThickness    = 1.5,
        FOVTransparency = 0.3,
        FOVFilled       = false,
        TracerEnabled   = true,
        TracerColor     = Color3.fromRGB(220, 100, 180),
        TracerThickness = 1.5,
        SilentChance    = 100,
        Prediction      = 0.12,
        GravityComp     = true,
    },

    Misc = {
        RainbowESP   = false,
        RainbowSpeed = 1,
        Invisible    = false,
        FlyEnabled   = false,
        FlyMethod    = "Basic",   -- "Basic" | "Ragdoll"
        FlySpeed     = 50,
    },

    World = {
        Fullbright = false,
        NoFog      = false,
    },
}

local CHANGELOG = {
    { ver = "v3.2.1", date = "2026", lines = {
        "Added: Invisible (character sunk below map, lying pose, movement preserved)",
        "Added: Fly Basic (velocity-based noclip flight, works everywhere)",
        "Added: Fly Ragdoll (ragdoll state flight, game-specific)",
        "Added: Info sidebar panel (executor, username, license tier)",
        "Added: Changelog sidebar panel",
        "Added: Fly speed slider in Misc tab",
        "Fixed: RainbowSpeed slider now reflects immediately",
    }},
    { ver = "v3.2", date = "2026", lines = {
        "Merged ESP rewrite (v3.1.1) into main hub",
        "Box pre-alloc 12 lines — no Drawing.new in render loop",
        "CharSizeCache — replaces GetExtentsSize() per frame",
        "Highlight-based chams with occluded color support",
        "Rainbow hue via dt accumulator (drift-free)",
        "ESP refresh rate slider added",
        "Tracer + Snapline added to ESP",
        "Box style dropdown: Corner / Full / ThreeD",
    }},
    { ver = "v3.1.1", date = "2026", lines = {
        "ESP full rewrite for performance",
        "Removed per-frame GetExtentsSize() — cached on spawn",
        "3D box connector lines pre-allocated (was spawn/destroy each frame)",
        "DrawBone simplified — onScreen check only",
        "Removed invalid Drawing.Line Transparency field",
        "DisableESP fires once on state change, not every frame",
    }},
    { ver = "v3.1", date = "2026", lines = {
        "Added: Anti-Kick dual layer (GC scan + namecall hook)",
        "Added: AntiCheat tab with manual re-patch button",
        "Fixed: MinBtn logic (was stub, now resizes window)",
        "Fixed: ChamsApplied O(1) flag replaces per-frame GetDescendants",
        "Fixed: AimWallCheck nil guard on pos",
        "Anti-kick + silent aim merged into one __namecall hook",
    }},
    { ver = "v3.0.1", date = "2026", lines = {
        "Fixed: HttpService:RequestAsync -> request/syn.request",
        "Fixed: Emoji removed from status text (executor crash)",
        "Improved executor detection robustness",
    }},
    { ver = "v3.0", date = "2026", lines = {
        "Supabase REST auth (login + register)",
        "Dual-method aimbot: Camera + Silent",
        "Silent aim: __index + __namecall hook (Raycast, FindPartOnRay)",
        "Wall Penetration ESP with different color",
        "FOV locked color indicator",
        "Tracer from screen bottom to target",
        "Toggle / Hold aimbot trigger modes",
        "Executor level auto-detection",
        "Collapsible sections",
        "[K] keybind to hide/show GUI",
    }},
    { ver = "v2.1", date = "2026", lines = {
        "Fixed: silent aim root cause (hookfunction -> getrawmetatable)",
        "Fixed: login gate double layer",
        "Fixed: Z depth check in WorldToViewportPoint",
        "Replaced FindPartOnRayWithIgnoreList with workspace:Raycast",
    }},
    { ver = "v2.0", date = "2026", lines = {
        "ESP: Box, Name, Skeleton (14-bone R15), Health Bar, Chams",
        "FOV Circle with outline layer",
        "Rainbow Chams + Rainbow FOV",
        "Fullbright + No Fog",
        "Gravity compensation in prediction",
        "Team Check separate for ESP and Aimbot",
        "Tab system: Visual / Combat / Misc / World / Admin",
        "Discord webhook login logging",
    }},
    { ver = "v1.1", date = "2026", lines = {
        "In-memory login system",
        "Admin panel: create accounts, generate licenses",
        "Discord webhook realtime logging",
    }},
    { ver = "v1.0", date = "2026", lines = {
        "Initial release",
        "Silent aim via hookfunction (later found broken)",
        "FOV Circle, basic prediction, wall check",
        "Pink-purple theme",
    }},
}

local Pal = {
    Window     = Color3.fromRGB(14, 10, 22),
    Sidebar    = Color3.fromRGB(18, 12, 28),
    TopBar     = Color3.fromRGB(22, 14, 35),
    Card       = Color3.fromRGB(28, 18, 42),
    CardActive = Color3.fromRGB(48, 28, 72),
    Border     = Color3.fromRGB(60, 34, 88),
    BorderSoft = Color3.fromRGB(40, 24, 60),
    Accent     = Color3.fromRGB(180, 60, 200),
    AccentAlt  = Color3.fromRGB(220, 80, 160),
    AccentSoft = Color3.fromRGB(140, 50, 180),
    Text       = Color3.fromRGB(240, 210, 255),
    TextDim    = Color3.fromRGB(160, 130, 190),
    TextMute   = Color3.fromRGB(110, 90, 140),
    Input      = Color3.fromRGB(35, 22, 55),
    ToggleOff  = Color3.fromRGB(50, 32, 70),
    Success    = Color3.fromRGB(100, 220, 150),
    Error      = Color3.fromRGB(255, 80, 120),
    Shadow     = Color3.fromRGB(6, 3, 12),
}

-- ================================================
-- Services
-- ================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")

local CoreGui
pcall(function() CoreGui = game:GetService("CoreGui") end)
if not CoreGui then CoreGui = Players.LocalPlayer:WaitForChild("PlayerGui") end

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local Mouse       = LocalPlayer:GetMouse()

-- ================================================
-- Executor Detection
-- ================================================

local ExecutorLevel = "Low"
local ExecutorName  = "Unknown"
do
    if syn then ExecutorName = "Synapse X"; ExecutorLevel = "High"
    elseif KRNL_LOADED then ExecutorName = "KRNL"; ExecutorLevel = "High"
    elseif is_sirhurt_closure then ExecutorName = "SirHurt"; ExecutorLevel = "High"
    elseif getexecutorname then
        local ok, n = pcall(getexecutorname)
        if ok then ExecutorName = n or "Unknown" end
    end
    if hookmetamethod and newcclosure and getnamecallmethod and checkcaller then
        ExecutorLevel = "High"
    end
end

local HasDrawing = Drawing ~= nil and Drawing.new ~= nil

-- ================================================
-- Anti-Kick
-- ================================================

local AntiKickActive = true

local function PatchAntiKick()
    if not getgc then return 0 end
    local ok, gc = pcall(getgc, true)
    if not ok or type(gc) ~= "table" then return 0 end
    local patched = 0
    for _, v in pairs(gc) do
        if type(v) == "table" then
            local ok2, idx = pcall(rawget, v, "indexInstance")
            if ok2 and type(idx) == "table" and idx[1] == "kick" then
                rawset(v, "tvk", { "kick", function()
                    return game.Workspace:WaitForChild("", math.huge)
                end })
                patched += 1
            end
        end
    end
    return patched
end

PatchAntiKick()
task.spawn(function()
    while AntiKickActive do task.wait(5); PatchAntiKick() end
end)

-- ================================================
-- Auth
-- ================================================

local CurrentUser = nil

local function SupabaseReq(method, path, body)
    local url     = CONFIG.SupabaseURL .. "/rest/v1/" .. path
    local headers = {
        ["apikey"]        = CONFIG.SupabaseKey,
        ["Authorization"] = "Bearer " .. CONFIG.SupabaseKey,
        ["Content-Type"]  = "application/json",
        ["Prefer"]        = "return=representation",
    }
    local payload = { Url = url, Method = method, Headers = headers }
    if body then payload.Body = HttpService:JSONEncode(body) end
    local fn = request or (http and http.request) or (syn and syn.request)
    if not fn then return false, "no HTTP fn" end
    local ok, res = pcall(fn, payload)
    if not ok then return false, tostring(res) end
    if type(res) ~= "table" or not res.Success then
        return false, "HTTP " .. tostring(res and res.StatusCode or "?")
    end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
    if not ok2 then return false, "parse error" end
    return true, data
end

local function SupabaseLogin(u, p)
    if u == "" or p == "" then return false, "fields empty" end
    local ok, data = SupabaseReq("GET", string.format(
        "accounts?username=eq.%s&password=eq.%s&select=*",
        HttpService:UrlEncode(u), HttpService:UrlEncode(p)
    ))
    if not ok then return false, tostring(data) end
    if type(data) ~= "table" or #data == 0 then return false, "wrong user/pass" end
    CurrentUser = {
        username = data[1].username,
        isAdmin  = data[1].is_admin == true,
        license  = data[1].is_admin and "Developer" or "Member",
    }
    return true, "Welcome, " .. CurrentUser.username
end

local function SupabaseRegister(u, p)
    if u == "" or p == "" then return false, "fields empty" end
    if #u < 3 then return false, "username min 3 chars" end
    if #p < 3 then return false, "password min 3 chars" end
    local ok, data = SupabaseReq("GET", string.format(
        "accounts?username=eq.%s&select=id", HttpService:UrlEncode(u)
    ))
    if ok and type(data) == "table" and #data > 0 then return false, "username taken" end
    local ok2, res = SupabaseReq("POST", "accounts", { username = u, password = p, is_admin = false })
    if not ok2 then return false, tostring(res) end
    return true, "account created, please login"
end

-- ================================================
-- GUI Helpers
-- ================================================

local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end
local function Stroke(p, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Pal.Accent; s.Thickness = thickness or 1
    s.Transparency = transparency or 0; s.Parent = p; return s
end
local function Pad(p, t, r, b, l)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0,t or 0); u.PaddingRight = UDim.new(0,r or 0)
    u.PaddingBottom = UDim.new(0,b or 0); u.PaddingLeft = UDim.new(0,l or 0)
    u.Parent = p; return u
end
local function Frame(parent, size, pos, color, transparency)
    local f = Instance.new("Frame")
    f.Size = size; f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or Pal.Card
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel = 0; f.Parent = parent; return f
end
local function Label(parent, text, pos, size, color, fs, xa)
    local l = Instance.new("TextLabel")
    l.Text = text; l.Position = pos or UDim2.new(0,0,0,0)
    l.Size = size or UDim2.new(1,0,0,20)
    l.BackgroundTransparency = 1; l.TextColor3 = color or Pal.Text
    l.Font = Enum.Font.Gotham; l.TextSize = fs or 13
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.Parent = parent; return l
end
local function BoldLabel(parent, text, pos, size, color, fs, xa)
    local l = Label(parent, text, pos, size, color, fs, xa)
    l.Font = Enum.Font.GothamBold; return l
end
local function TextBox(parent, placeholder, size)
    local tb = Instance.new("TextBox")
    tb.PlaceholderText = placeholder or ""; tb.Size = size or UDim2.new(1,0,0,34)
    tb.BackgroundColor3 = Pal.Input; tb.TextColor3 = Pal.Text
    tb.PlaceholderColor3 = Pal.TextMute; tb.Font = Enum.Font.Gotham
    tb.TextSize = 13; tb.BorderSizePixel = 0; tb.ClearTextOnFocus = false
    tb.Parent = parent; Corner(tb,6); Stroke(tb,Pal.BorderSoft,1,0.3); Pad(tb,0,0,0,10)
    tb.Focused:Connect(function()
        local s = tb:FindFirstChildOfClass("UIStroke")
        if s then TweenService:Create(s,TweenInfo.new(0.15),{Color=Pal.Accent,Transparency=0}):Play() end
    end)
    tb.FocusLost:Connect(function()
        local s = tb:FindFirstChildOfClass("UIStroke")
        if s then TweenService:Create(s,TweenInfo.new(0.15),{Color=Pal.BorderSoft,Transparency=0.3}):Play() end
    end)
    return tb
end
local function Button(parent, text, size, onClick)
    local btn = Instance.new("TextButton")
    btn.Text = text; btn.Size = size or UDim2.new(1,0,0,36)
    btn.BackgroundColor3 = Pal.Accent; btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Parent = parent
    Corner(btn,8)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Pal.AccentAlt}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Pal.Accent}):Play() end)
    if onClick then btn.MouseButton1Click:Connect(onClick) end
    return btn
end

-- ================================================
-- Login GUI
-- ================================================

local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "VelsHub_Login"; LoginGui.ResetOnSpawn = false
LoginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoginGui.IgnoreGuiInset = true; LoginGui.Parent = CoreGui

local LoginBackdrop = Frame(LoginGui, UDim2.new(1,0,1,0), nil, Pal.Window, 0.15)
LoginBackdrop.ZIndex = 1
do
    local g = Instance.new("UIGradient"); g.Rotation = 45
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(12,6,22)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30,12,48)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(12,6,22)),
    }); g.Parent = LoginBackdrop
end

local Vignette = Frame(LoginBackdrop, UDim2.new(1,0,1,0), nil, Color3.fromRGB(0,0,0), 0.55)
Vignette.ZIndex = 2
do
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.3), NumberSequenceKeypoint.new(0.5,1), NumberSequenceKeypoint.new(1,0.3),
    }); g.Rotation = 90; g.Parent = Vignette
end

local ParticleLayer = Frame(LoginBackdrop, UDim2.new(1,0,1,0), nil, Color3.fromRGB(0,0,0), 1)
ParticleLayer.ZIndex = 3

local function SpawnParticle()
    local p = Frame(ParticleLayer, UDim2.new(0,math.random(2,5),0,math.random(2,5)),
        UDim2.new(math.random(),0,1.05,0), math.random()>0.5 and Pal.Accent or Pal.AccentAlt, 0.4)
    p.ZIndex = 3; Corner(p,99)
    local dur = math.random(4,9)+math.random()
    TweenService:Create(p,TweenInfo.new(dur,Enum.EasingStyle.Linear),{
        Position=UDim2.new(p.Position.X.Scale,math.random(-30,30),-0.1,0)
    }):Play()
    task.spawn(function() task.wait(dur); p:Destroy() end)
end
task.spawn(function()
    while LoginGui.Parent do
        for _ = 1, math.random(1,3) do SpawnParticle() end
        task.wait(math.random(6,14)/10)
    end
end)

local CardShadow = Frame(LoginBackdrop, UDim2.new(0,360,0,380), UDim2.new(0.5,-180,0.5,-180), Pal.Shadow, 0.55)
CardShadow.ZIndex = 4; Corner(CardShadow, 18)

local LoginCard = Frame(LoginBackdrop, UDim2.new(0,340,0,360), UDim2.new(0.5,-170,0.5,-160), Pal.Card, 0.05)
LoginCard.ZIndex = 5; Corner(LoginCard,14); Stroke(LoginCard,Pal.Accent,1.5)
LoginCard.Position = UDim2.new(0.5,-170,0.5,-130); LoginCard.BackgroundTransparency = 1
CardShadow.BackgroundTransparency = 1

task.spawn(function()
    task.wait(0.05)
    TweenService:Create(LoginCard,TweenInfo.new(0.6,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        Position=UDim2.new(0.5,-170,0.5,-160), BackgroundTransparency=0.05,
    }):Play()
    TweenService:Create(CardShadow,TweenInfo.new(0.6,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        BackgroundTransparency=0.55,
    }):Play()
end)

local LogoLbl = Label(LoginCard,"⬡",UDim2.new(0,0,0,14),UDim2.new(1,0,0,52),Pal.AccentAlt,44,Enum.TextXAlignment.Center)
LogoLbl.ZIndex = 6
task.spawn(function()
    local rot = 0
    while LoginGui.Parent do rot=(rot+0.8)%360; LogoLbl.Rotation=rot; task.wait(0.016) end
end)

BoldLabel(LoginCard,"VelsHub v3.2.1",UDim2.new(0,0,0,72),UDim2.new(1,0,0,26),Pal.Text,20,Enum.TextXAlignment.Center).ZIndex=6
Label(LoginCard,"fly • invisible • supabase auth",UDim2.new(0,0,0,96),UDim2.new(1,0,0,16),Pal.TextDim,11,Enum.TextXAlignment.Center).ZIndex=6

Label(LoginCard,"Username",UDim2.new(0,20,0,124),UDim2.new(1,-40,0,14),Pal.TextDim,10).ZIndex=6
local LoginUserBox = TextBox(LoginCard,"",UDim2.new(1,-40,0,34))
LoginUserBox.Position=UDim2.new(0,20,0,140); LoginUserBox.ZIndex=6

Label(LoginCard,"Password",UDim2.new(0,20,0,182),UDim2.new(1,-40,0,14),Pal.TextDim,10).ZIndex=6
local LoginPassBox = TextBox(LoginCard,"",UDim2.new(1,-40,0,34))
LoginPassBox.Position=UDim2.new(0,20,0,198); LoginPassBox.ZIndex=6

local LoginStatus = Label(LoginCard,"",UDim2.new(0,20,0,240),UDim2.new(1,-40,0,16),Pal.Error,11,Enum.TextXAlignment.Center)
LoginStatus.ZIndex=6

local HubLoader

local LoginBtn = Button(LoginCard,"Login",UDim2.new(1,-40,0,36),function()
    LoginStatus.TextColor3=Pal.TextDim; LoginStatus.Text="connecting..."
    task.spawn(function()
        local ok,msg = SupabaseLogin(LoginUserBox.Text,LoginPassBox.Text)
        LoginStatus.TextColor3 = ok and Pal.Success or Pal.Error
        LoginStatus.Text = (ok and "[OK] " or "[X] ")..msg
        if ok then
            task.wait(0.4)
            TweenService:Create(LoginCard,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{BackgroundTransparency=0.5}):Play()
            TweenService:Create(LoginBackdrop,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
            task.wait(0.4); LoginGui:Destroy()
            if HubLoader then HubLoader() end
        end
    end)
end)
LoginBtn.Position=UDim2.new(0,20,0,264); LoginBtn.ZIndex=6

local RegisterBtn = Button(LoginCard,"Register",UDim2.new(1,-40,0,28),function()
    LoginStatus.TextColor3=Pal.TextDim; LoginStatus.Text="creating..."
    task.spawn(function()
        local ok,msg = SupabaseRegister(LoginUserBox.Text,LoginPassBox.Text)
        LoginStatus.TextColor3 = ok and Pal.Success or Pal.Error
        LoginStatus.Text = (ok and "[OK] " or "[X] ")..msg
    end)
end)
RegisterBtn.Position=UDim2.new(0,20,0,300); RegisterBtn.ZIndex=6
RegisterBtn.BackgroundColor3=Pal.CardActive

-- ================================================
-- Hub
-- ================================================

HubLoader = function()
    if not CurrentUser then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name="VelsHub"; ScreenGui.ResetOnSpawn=false
    ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; ScreenGui.Parent=CoreGui

    local WIN_W, WIN_H = 760, 520

    local Shadow = Frame(ScreenGui,UDim2.new(0,WIN_W+12,0,WIN_H+12),
        UDim2.new(0.5,-(WIN_W+12)/2,0.5,-(WIN_H+12)/2),Pal.Shadow,0.35)
    Corner(Shadow,16); Shadow.ZIndex=0

    local Main = Frame(ScreenGui,UDim2.new(0,WIN_W,0,WIN_H),
        UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2),Pal.Window)
    Corner(Main,14); Stroke(Main,Pal.Border,1,0.3); Main.ZIndex=1

    -- Titlebar
    local TitleBar = Frame(Main,UDim2.new(1,0,0,40),nil,Pal.TopBar,0.3)
    Corner(TitleBar,14)
    Frame(TitleBar,UDim2.new(1,0,0,14),UDim2.new(0,0,1,-14),Pal.TopBar,0.3)
    do
        local al=Frame(TitleBar,UDim2.new(1,0,0,2),UDim2.new(0,0,1,-2),Pal.Accent)
        local g=Instance.new("UIGradient")
        g.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Pal.Accent),
            ColorSequenceKeypoint.new(0.5,Pal.AccentAlt),
            ColorSequenceKeypoint.new(1,Pal.Accent),
        }); g.Parent=al
    end

    BoldLabel(TitleBar,"VelsHub",UDim2.new(0,16,0,0),UDim2.new(0,120,1,0),Pal.Text,14)
    Label(TitleBar,"v3.2.1 | "..ExecutorName.." | Anti-Kick ON",UDim2.new(0,90,0,0),UDim2.new(0,300,1,0),Pal.TextMute,10)
    Label(TitleBar,"[K] toggle",UDim2.new(1,-110,0,0),UDim2.new(0,90,1,0),Pal.TextMute,10,Enum.TextXAlignment.Center)

    local minimized = false
    local function MakeWinBtn(text, xOffset, onClick)
        local b = Instance.new("TextButton")
        b.Size=UDim2.new(0,28,0,28); b.Position=UDim2.new(1,xOffset,0.5,-14)
        b.BackgroundColor3=Pal.Card; b.TextColor3=Pal.TextDim
        b.Font=Enum.Font.GothamBold; b.TextSize=14; b.Text=text
        b.BorderSizePixel=0; b.AutoButtonColor=false; b.Parent=TitleBar
        Corner(b,6); b.MouseButton1Click:Connect(onClick); return b
    end
    MakeWinBtn("x",-36,function() ScreenGui:Destroy() end)
    local MinBtn = MakeWinBtn("-",-68,function() end)

    -- Layout
    -- Left sidebar (nav tabs): 150px
    -- Right area: split into content (flexible) + info panel (160px) + changelog panel (180px)
    local SidebarW   = 150
    local InfoW      = 160
    local ChangelogW = 180
    local ContentW   = WIN_W - SidebarW - InfoW - ChangelogW - 20

    local Sidebar = Frame(Main,UDim2.new(0,SidebarW,1,-60),UDim2.new(0,0,0,40),Pal.Sidebar,0.2)
    Corner(Sidebar,10); Pad(Sidebar,10,8,10,8)
    local sl=Instance.new("UIListLayout")
    sl.Padding=UDim.new(0,4); sl.SortOrder=Enum.SortOrder.LayoutOrder
    sl.HorizontalAlignment=Enum.HorizontalAlignment.Center; sl.Parent=Sidebar

    -- Content area
    local ContentX = SidebarW + 10
    local Content  = Frame(Main,UDim2.new(0,ContentW,1,-60),UDim2.new(0,ContentX,0,40),Pal.Window,1)

    -- Info sidebar (player info)
    local InfoPanel = Frame(Main,UDim2.new(0,InfoW,1,-60),UDim2.new(0,ContentX+ContentW+5,0,40),Pal.Sidebar,0.2)
    Corner(InfoPanel,10); Stroke(InfoPanel,Pal.BorderSoft,1,0.4)
    Pad(InfoPanel,10,8,10,8)
    do
        BoldLabel(InfoPanel,"PLAYER INFO",UDim2.new(0,0,0,0),UDim2.new(1,0,0,16),Pal.Accent,10)
        Frame(InfoPanel,UDim2.new(1,0,0,1),UDim2.new(0,0,0,20),Pal.AccentSoft,0.5)

        local infoLayout=Instance.new("UIListLayout")
        infoLayout.Padding=UDim.new(0,6); infoLayout.SortOrder=Enum.SortOrder.LayoutOrder; infoLayout.Parent=InfoPanel

        local function InfoRow(icon, key, val)
            local row=Frame(InfoPanel,UDim2.new(1,0,0,0),nil,Color3.fromRGB(0,0,0),1)
            row.AutomaticSize=Enum.AutomaticSize.Y
            local l=Label(row,icon.." "..key,UDim2.new(0,0,0,0),UDim2.new(1,0,0,14),Pal.TextMute,9)
            local v=Label(row,val,UDim2.new(0,0,0,14),UDim2.new(1,0,0,14),Pal.Text,10)
            v.Font=Enum.Font.GothamBold; v.TextWrapped=true
            return row, v
        end

        local _,execVal  = InfoRow("◈","Executor",ExecutorName)
        local _,usnVal   = InfoRow("◈","Username", CurrentUser.username)
        local _,licVal   = InfoRow("◈","License",  CurrentUser.license)
        local _,lvlVal   = InfoRow("◈","Level",    ExecutorLevel)
        local _,gameVal  = InfoRow("◈","Game",     game.Name:sub(1,18))

        -- separator
        Frame(InfoPanel,UDim2.new(1,0,0,1),nil,Pal.BorderSoft,0.5)

        BoldLabel(InfoPanel,"SCRIPT INFO",UDim2.new(0,0,0,0),UDim2.new(1,0,0,14),Pal.Accent,9)
        InfoRow("◈","Version","v3.2.1")
        InfoRow("◈","Anti-Kick","Active")
        InfoRow("◈","Hook Level",ExecutorLevel=="High" and "Full" or "Basic")

        -- live fps counter
        local _,fpsVal = InfoRow("◈","FPS","--")
        local fpsT = 0; local fpsC = 0
        RunService.RenderStepped:Connect(function(dt)
            fpsC+=1; fpsT+=dt
            if fpsT >= 0.5 then
                fpsVal.Text = tostring(math.round(fpsC/fpsT))
                fpsC=0; fpsT=0
            end
        end)
    end

    -- Changelog sidebar
    local CLPanel = Frame(Main,UDim2.new(0,ChangelogW,1,-60),UDim2.new(0,ContentX+ContentW+InfoW+10,0,40),Pal.Sidebar,0.2)
    Corner(CLPanel,10); Stroke(CLPanel,Pal.BorderSoft,1,0.4)
    Pad(CLPanel,10,6,10,6)
    do
        BoldLabel(CLPanel,"CHANGELOG",UDim2.new(0,0,0,0),UDim2.new(1,0,0,16),Pal.Accent,10)
        Frame(CLPanel,UDim2.new(1,0,0,1),UDim2.new(0,0,0,20),Pal.AccentSoft,0.5)

        local clScroll = Instance.new("ScrollingFrame")
        clScroll.Size=UDim2.new(1,0,1,-28); clScroll.Position=UDim2.new(0,0,0,28)
        clScroll.BackgroundTransparency=1; clScroll.BorderSizePixel=0
        clScroll.ScrollBarThickness=2; clScroll.ScrollBarImageColor3=Pal.Accent
        clScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; clScroll.Parent=CLPanel
        local clLayout=Instance.new("UIListLayout")
        clLayout.Padding=UDim.new(0,8); clLayout.SortOrder=Enum.SortOrder.LayoutOrder; clLayout.Parent=clScroll

        for _, entry in ipairs(CHANGELOG) do
            local block=Frame(clScroll,UDim2.new(1,0,0,0),nil,Color3.fromRGB(0,0,0),1)
            block.AutomaticSize=Enum.AutomaticSize.Y
            local bl=Instance.new("UIListLayout"); bl.Padding=UDim.new(0,2); bl.Parent=block

            local verRow=Frame(block,UDim2.new(1,0,0,16),nil,Color3.fromRGB(0,0,0),1)
            BoldLabel(verRow,entry.ver,UDim2.new(0,0,0,0),UDim2.new(0.6,0,1,0),Pal.AccentAlt,10)
            Label(verRow,entry.date,UDim2.new(0.6,0,0,0),UDim2.new(0.4,0,1,0),Pal.TextMute,9,Enum.TextXAlignment.Right)

            for _, line in ipairs(entry.lines) do
                local lbl=Label(block,"• "..line,UDim2.new(0,0,0,0),UDim2.new(1,0,0,0),Pal.TextDim,8)
                lbl.TextWrapped=true; lbl.AutomaticSize=Enum.AutomaticSize.Y
            end

            -- divider
            Frame(block,UDim2.new(1,0,0,1),nil,Pal.BorderSoft,0.6)
        end
    end

    -- Minimize
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Sidebar.Visible=false; Content.Visible=false
            InfoPanel.Visible=false; CLPanel.Visible=false
            TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{Size=UDim2.new(0,WIN_W,0,40)}):Play()
            MinBtn.Text="+"
        else
            TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{Size=UDim2.new(0,WIN_W,0,WIN_H)}):Play()
            task.delay(0.2,function()
                Sidebar.Visible=true; Content.Visible=true
                InfoPanel.Visible=true; CLPanel.Visible=true
            end)
            MinBtn.Text="-"
        end
    end)

    -- Drag
    do
        local dragging,ds,sp,shs
        TitleBar.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=true; ds=i.Position; sp=Main.Position; shs=Shadow.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                local d=i.Position-ds
                Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
                Shadow.Position=UDim2.new(shs.X.Scale,shs.X.Offset+d.X,shs.Y.Scale,shs.Y.Offset+d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
        end)
    end

    -- ================================================
    -- Tab System
    -- ================================================

    local Pages,TabBtns = {},{}

    local function MakePage(name)
        local scroll=Instance.new("ScrollingFrame")
        scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1
        scroll.BorderSizePixel=0; scroll.ScrollBarThickness=3
        scroll.ScrollBarImageColor3=Pal.Accent; scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
        scroll.Visible=false; scroll.Parent=Content
        Pad(scroll,4,8,12,0)
        local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,10)
        l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=scroll
        Pages[name]=scroll
    end

    local function SwitchTab(name)
        for n,p in pairs(Pages) do p.Visible=(n==name) end
        for n,b in pairs(TabBtns) do
            local a=(n==name)
            TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=a and Pal.CardActive or Pal.Card}):Play()
            local lbl=b:FindFirstChildOfClass("TextLabel")
            if lbl then TweenService:Create(lbl,TweenInfo.new(0.15),{TextColor3=a and Pal.Text or Pal.TextDim}):Play() end
            local bar=b:FindFirstChild("__bar"); if bar then bar.Visible=a end
        end
    end

    for _,name in ipairs({"Visual","Combat","Misc","World","AntiCheat"}) do
        MakePage(name)
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(1,0,0,32); btn.BackgroundColor3=Pal.Card
        btn.Text=""; btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.Parent=Sidebar
        Corner(btn,8)
        local bar=Frame(btn,UDim2.new(0,3,0,16),UDim2.new(0,4,0.5,-8),Pal.Accent)
        bar.Name="__bar"; bar.Visible=false; Corner(bar,2)
        BoldLabel(btn,name,UDim2.new(0,16,0,0),UDim2.new(1,-16,1,0),Pal.TextDim,12)
        TabBtns[name]=btn; btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    end

    local GuiVisible=true
    local function SetGuiVisible(state)
        GuiVisible=state
        if state then
            Main.Visible=true; Shadow.Visible=true
            TweenService:Create(Main,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
            TweenService:Create(Shadow,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0.35}):Play()
        else
            local fm=TweenService:Create(Main,TweenInfo.new(0.2),{BackgroundTransparency=1})
            local fs=TweenService:Create(Shadow,TweenInfo.new(0.2),{BackgroundTransparency=1})
            fm:Play(); fs:Play()
            fm.Completed:Connect(function()
                if not GuiVisible then Main.Visible=false; Shadow.Visible=false end
            end)
        end
    end

    local toggleDb=false
    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if i.KeyCode~=Enum.KeyCode.K then return end
        if toggleDb then return end
        toggleDb=true; task.delay(0.2,function() toggleDb=false end)
        SetGuiVisible(not GuiVisible)
    end)

    -- ================================================
    -- Widget Helpers
    -- ================================================

    local function Section(parent, title)
        local s=Frame(parent,UDim2.new(1,0,0,0),nil,Pal.Card)
        Corner(s,10); Stroke(s,Pal.BorderSoft,1,0.3); s.AutomaticSize=Enum.AutomaticSize.Y
        local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,6)
        l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=s; Pad(s,10,12,10,12)
        local head=Frame(s,UDim2.new(1,0,0,20),nil,Color3.fromRGB(0,0,0),1); head.LayoutOrder=0
        BoldLabel(head,title:upper(),UDim2.new(0,0,0,0),UDim2.new(1,-20,1,0),Pal.Accent,11)
        local arrow=Label(head,"v",UDim2.new(1,-14,0,0),UDim2.new(0,14,1,0),Pal.TextMute,12,Enum.TextXAlignment.Center)
        arrow.Font=Enum.Font.GothamBold
        local holder=Frame(s,UDim2.new(1,0,0,0),nil,Color3.fromRGB(0,0,0),1)
        holder.AutomaticSize=Enum.AutomaticSize.Y; holder.LayoutOrder=1
        local il=Instance.new("UIListLayout"); il.Padding=UDim.new(0,6)
        il.SortOrder=Enum.SortOrder.LayoutOrder; il.Parent=holder
        local open=true
        local hb=Instance.new("TextButton"); hb.Size=UDim2.new(1,0,1,0)
        hb.BackgroundTransparency=1; hb.Text=""; hb.Parent=head
        hb.MouseButton1Click:Connect(function()
            open=not open; holder.Visible=open; arrow.Text=open and "v" or ">"
        end)
        return holder
    end

    local function Toggle(parent, label, default, cb)
        local row=Frame(parent,UDim2.new(1,0,0,30),nil,Color3.fromRGB(0,0,0),1)
        Label(row,label,UDim2.new(0,0,0,0),UDim2.new(0.75,0,1,0),Pal.Text,12)
        local track=Frame(row,UDim2.new(0,40,0,20),UDim2.new(1,-42,0.5,-10),default and Pal.AccentSoft or Pal.ToggleOff)
        Corner(track,10)
        local knob=Frame(track,UDim2.new(0,14,0,14),default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),Color3.fromRGB(255,255,255))
        Corner(knob,7); local state=default
        local hb=Instance.new("TextButton"); hb.Size=UDim2.new(1,0,1,0)
        hb.BackgroundTransparency=1; hb.Text=""; hb.Parent=track
        hb.MouseButton1Click:Connect(function()
            state=not state
            TweenService:Create(track,TweenInfo.new(0.15),{BackgroundColor3=state and Pal.AccentSoft or Pal.ToggleOff}):Play()
            TweenService:Create(knob,TweenInfo.new(0.15),{Position=state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
            if cb then cb(state) end
        end)
        return row
    end

    local function Slider(parent, label, min, max, default, cb)
        local w=Frame(parent,UDim2.new(1,0,0,46),nil,Color3.fromRGB(0,0,0),1)
        local lbl=Label(w,label..": "..default,UDim2.new(0,0,0,0),UDim2.new(1,0,0,16),Pal.TextDim,11)
        local track=Frame(w,UDim2.new(1,0,0,6),UDim2.new(0,0,0,24),Pal.ToggleOff); Corner(track,3)
        local fill=Frame(track,UDim2.new((default-min)/(max-min),0,1,0),nil,Pal.Accent); Corner(fill,3)
        local knob=Frame(track,UDim2.new(0,12,0,12),UDim2.new((default-min)/(max-min),-6,0.5,-6),Color3.fromRGB(255,255,255))
        Corner(knob,6); Stroke(knob,Pal.Accent,1)
        local sliding=false
        track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then
                local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                local v=math.floor(min+(max-min)*rel)
                fill.Size=UDim2.new(rel,0,1,0); knob.Position=UDim2.new(rel,-6,0.5,-6)
                lbl.Text=label..": "..v; if cb then cb(v) end
            end
        end)
        return w
    end

    local function Dropdown(parent, label, options, default, cb)
        local w=Frame(parent,UDim2.new(1,0,0,56),nil,Color3.fromRGB(0,0,0),1)
        Label(w,label,UDim2.new(0,0,0,0),UDim2.new(1,0,0,16),Pal.TextDim,11)
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(1,0,0,32); btn.Position=UDim2.new(0,0,0,20)
        btn.BackgroundColor3=Pal.Input; btn.TextColor3=Pal.Text
        btn.Font=Enum.Font.Gotham; btn.TextSize=12; btn.Text=default
        btn.BorderSizePixel=0; btn.Parent=w; Corner(btn,6); Stroke(btn,Pal.BorderSoft,1,0.3)
        local idx=1
        for i,v in ipairs(options) do if v==default then idx=i end end
        btn.MouseButton1Click:Connect(function()
            idx=idx%#options+1; btn.Text=options[idx]; if cb then cb(options[idx]) end
        end)
        return w
    end

    -- ================================================
    -- Invisible System
    -- ================================================

    local InvisibleConn = nil
    local InvisOrigCFrame = nil
    local InvisActive = false

    local function EnableInvisible()
        if InvisActive then return end
        InvisActive = true
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        InvisOrigCFrame = hrp.CFrame

        -- *sink HRP ke bawah map — server hanya tau posisi HRP, bukan kamera*
        -- karakter rebahan: CFrame diputar 90 derajat di sumbu X
        -- offset Y = -500 biar jelas di bawah map, ga kena ground collision
        local function SinkChar()
            local char2 = LocalPlayer.Character
            if not char2 then return end
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            if not hrp2 then return end
            -- posisi rebahan: 500 stud di bawah, rotasi tidur
            local lyingCF = CFrame.new(hrp2.Position.X, -500, hrp2.Position.Z)
                * CFrame.Angles(math.rad(90), 0, 0)
            hrp2.CFrame = lyingCF
        end

        -- *lock HRP tiap frame biar physics ga ngembaliin ke atas*
        InvisibleConn = RunService.Heartbeat:Connect(function()
            if not InvisActive then return end
            local char2 = LocalPlayer.Character
            if not char2 then return end
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            local hum2 = char2:FindFirstChildOfClass("Humanoid")
            if not hrp2 or not hum2 then return end

            -- preserve X/Z dari movement, tapi lock Y di -500 dan rotasi rebahan
            local curPos = hrp2.Position
            hrp2.CFrame = CFrame.new(curPos.X, -500, curPos.Z)
                * CFrame.Angles(math.rad(90), 0, 0)

            -- humanoid tetap bisa MoveDirection, cuma posisinya disink
            -- WalkSpeed tetap normal, ga dikurangi
        end)

        SinkChar()
    end

    local function DisableInvisible()
        if not InvisActive then return end
        InvisActive = false
        if InvisibleConn then InvisibleConn:Disconnect(); InvisibleConn = nil end

        local char = LocalPlayer.Character
        if not char then return end
        local hrp  = char:FindFirstChild("HumanoidRootPart")
        if hrp and InvisOrigCFrame then
            -- kembaliin ke posisi sebelum invisible
            hrp.CFrame = CFrame.new(InvisOrigCFrame.Position + Vector3.new(0,5,0))
        end
        InvisOrigCFrame = nil
    end

    -- ================================================
    -- Fly System
    -- ================================================

    local FlyConn      = nil
    local FlyBodyVel   = nil
    local FlyBodyGyro  = nil
    local FlyActive    = false

    -- Ragdoll fly state
    local RagdollAnimTrack = nil
    local RagdollConn      = nil

    local function DisableFly()
        if not FlyActive then return end
        FlyActive = false

        if FlyConn then FlyConn:Disconnect(); FlyConn = nil end
        if RagdollConn then RagdollConn:Disconnect(); RagdollConn = nil end

        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        -- cleanup BodyVelocity + BodyGyro
        if FlyBodyVel then FlyBodyVel:Destroy(); FlyBodyVel = nil end
        if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end

        -- restore humanoid state
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum.PlatformStand = false
        end

        -- restore Animate script
        local animate = char:FindFirstChild("Animate")
        if animate then animate.Disabled = false end

        if RagdollAnimTrack then
            pcall(function() RagdollAnimTrack:Stop() end)
            RagdollAnimTrack = nil
        end
    end

    local function EnableFlyBasic()
        if FlyActive then DisableFly() end
        FlyActive = true

        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        -- BodyVelocity + BodyGyro: method standar, works di semua game
        FlyBodyVel = Instance.new("BodyVelocity")
        FlyBodyVel.Velocity       = Vector3.zero
        FlyBodyVel.MaxForce       = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyVel.P              = 1e4
        FlyBodyVel.Parent         = hrp

        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.MaxTorque     = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyGyro.P             = 1e4
        FlyBodyGyro.D             = 100
        FlyBodyGyro.CFrame        = hrp.CFrame
        FlyBodyGyro.Parent        = hrp

        hum.PlatformStand = true

        local keys = {}
        local inputBegan = UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            keys[i.KeyCode] = true
        end)
        local inputEnded = UserInputService.InputEnded:Connect(function(i)
            keys[i.KeyCode] = false
        end)

        -- *direction dari Camera CFrame — bukan HRP — biar fly sesuai arah pandang*
        FlyConn = RunService.RenderStepped:Connect(function(dt)
            if not FlyActive then return end
            local char2 = LocalPlayer.Character
            if not char2 then return end
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            if not hrp2 then return end

            local camCF  = Camera.CFrame
            local speed  = CONFIG.Misc.FlySpeed
            local dir    = Vector3.zero

            if keys[Enum.KeyCode.W] then dir = dir + camCF.LookVector end
            if keys[Enum.KeyCode.S] then dir = dir - camCF.LookVector end
            if keys[Enum.KeyCode.A] then dir = dir - camCF.RightVector end
            if keys[Enum.KeyCode.D] then dir = dir + camCF.RightVector end
            if keys[Enum.KeyCode.Space] or keys[Enum.KeyCode.E] then dir = dir + Vector3.new(0,1,0) end
            if keys[Enum.KeyCode.LeftShift] or keys[Enum.KeyCode.Q] then dir = dir - Vector3.new(0,1,0) end

            if dir.Magnitude > 0 then
                dir = dir.Unit * speed
            end

            if FlyBodyVel then FlyBodyVel.Velocity = dir end
            if FlyBodyGyro then FlyBodyGyro.CFrame = camCF end
        end)

        -- cleanup input connections kalau fly dimatiin
        local origConn = FlyConn
        local cleanupConn
        cleanupConn = RunService.Heartbeat:Connect(function()
            if not FlyActive then
                inputBegan:Disconnect()
                inputEnded:Disconnect()
                cleanupConn:Disconnect()
            end
        end)
    end

    local function EnableFlyRagdoll()
        -- *ragdoll fly: disable Animate + set Ragdoll state + BodyVelocity*
        -- *hanya works di game yang ga override humanoid state atau punya custom ragdoll*
        if FlyActive then DisableFly() end
        FlyActive = true

        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        -- disable Animate script biar ga fight sama ragdoll state
        local animate = char:FindFirstChild("Animate")
        if animate then animate.Disabled = true end

        -- set ragdoll state
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        hum.PlatformStand = true

        FlyBodyVel = Instance.new("BodyVelocity")
        FlyBodyVel.Velocity = Vector3.zero
        FlyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyVel.P        = 1e4
        FlyBodyVel.Parent   = hrp

        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyGyro.P         = 1e4
        FlyBodyGyro.D         = 100
        FlyBodyGyro.CFrame    = hrp.CFrame
        FlyBodyGyro.Parent    = hrp

        local keys = {}
        local inputBegan = UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end; keys[i.KeyCode] = true
        end)
        local inputEnded = UserInputService.InputEnded:Connect(function(i)
            keys[i.KeyCode] = false
        end)

        FlyConn = RunService.RenderStepped:Connect(function()
            if not FlyActive then return end
            local char2 = LocalPlayer.Character
            if not char2 then return end
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            if not hrp2 then return end

            -- *di ragdoll mode, game mungkin force-reset HumanoidState tiap frame*
            -- keep forcing Physics state biar ga auto-getup
            local hum2 = char2:FindFirstChildOfClass("Humanoid")
            if hum2 then hum2:ChangeState(Enum.HumanoidStateType.Physics) end

            local camCF = Camera.CFrame
            local speed = CONFIG.Misc.FlySpeed
            local dir   = Vector3.zero

            if keys[Enum.KeyCode.W] then dir = dir + camCF.LookVector end
            if keys[Enum.KeyCode.S] then dir = dir - camCF.LookVector end
            if keys[Enum.KeyCode.A] then dir = dir - camCF.RightVector end
            if keys[Enum.KeyCode.D] then dir = dir + camCF.RightVector end
            if keys[Enum.KeyCode.Space] or keys[Enum.KeyCode.E] then dir = dir + Vector3.new(0,1,0) end
            if keys[Enum.KeyCode.LeftShift] or keys[Enum.KeyCode.Q] then dir = dir - Vector3.new(0,1,0) end

            if dir.Magnitude > 0 then dir = dir.Unit * speed end

            if FlyBodyVel then FlyBodyVel.Velocity = dir end
            if FlyBodyGyro then FlyBodyGyro.CFrame = camCF end
        end)

        local cleanupConn
        cleanupConn = RunService.Heartbeat:Connect(function()
            if not FlyActive then
                inputBegan:Disconnect(); inputEnded:Disconnect(); cleanupConn:Disconnect()
            end
        end)
    end

    local function ToggleFly(enabled, method)
        if enabled then
            if method == "Ragdoll" then EnableFlyRagdoll()
            else EnableFlyBasic() end
        else
            DisableFly()
        end
    end

    -- cleanup on respawn
    LocalPlayer.CharacterAdded:Connect(function()
        if InvisActive then
            task.wait(0.5); EnableInvisible()
        end
        if FlyActive then
            FlyActive = false
            if FlyBodyVel then FlyBodyVel:Destroy(); FlyBodyVel = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
            task.wait(0.5)
            ToggleFly(true, CONFIG.Misc.FlyMethod)
        end
    end)

    -- ================================================
    -- ESP Core
    -- ================================================

    local CharSizeCache = {}
    local ESPObjects    = {}
    local RainbowHue    = 0

    local SkeletonBonePairs = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }

    local function NewDraw(t, props)
        local d=Drawing.new(t); for k,v in pairs(props) do d[k]=v end; return d
    end

    local function CacheCharSize(char)
        if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        if hrp and head then
            local h=(head.Position.Y+head.Size.Y/2)-(hrp.Position.Y-hrp.Size.Y/2)
            CharSizeCache[char]=Vector3.new(hrp.Size.X*1.8,math.max(h,4),hrp.Size.Z*1.8)
        end
    end

    local function MakeESPObjects()
        local box={}
        for i=1,12 do box[i]=NewDraw("Line",{Visible=false,Color=CONFIG.ESP.BoxColor,Thickness=CONFIG.ESP.BoxThickness}) end
        local bones={}
        for i=1,#SkeletonBonePairs do bones[i]=NewDraw("Line",{Visible=false,Color=CONFIG.ESP.SkeletonColor,Thickness=CONFIG.ESP.SkeletonThickness}) end
        return {
            Box       = box,
            HPOutline = NewDraw("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(0,0,0)}),
            HPFill    = NewDraw("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(50,220,100)}),
            HPText    = NewDraw("Text",  {Visible=false,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),Font=Drawing.Fonts.Plex}),
            Name      = NewDraw("Text",  {Visible=false,Size=13,Center=true,Outline=true,Color=CONFIG.ESP.NameColor,Font=Drawing.Fonts.Plex}),
            Tracer    = NewDraw("Line",  {Visible=false,Color=CONFIG.ESP.TracerColor,Thickness=CONFIG.ESP.TracerThickness}),
            Snapline  = NewDraw("Line",  {Visible=false,Color=CONFIG.ESP.BoxColor,Thickness=1}),
            Bones     = bones,
            Highlight = (function()
                local hl=Instance.new("Highlight")
                hl.FillColor=CONFIG.ESP.ChamsColor; hl.OutlineColor=CONFIG.ESP.ChamsOutlineColor
                hl.FillTransparency=CONFIG.ESP.ChamsTransparency
                hl.OutlineTransparency=CONFIG.ESP.ChamsOutlineTransparency
                hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Enabled=false
                return hl
            end)(),
        }
    end

    local function DestroyESPObjects(obj)
        for _,l in ipairs(obj.Box) do pcall(l.Remove,l) end
        for _,b in ipairs(obj.Bones) do pcall(b.Remove,b) end
        for _,k in ipairs({"HPOutline","HPFill","HPText","Name","Tracer","Snapline"}) do
            pcall(obj[k].Remove, obj[k])
        end
        pcall(function() obj.Highlight:Destroy() end)
    end

    local function HideESP(obj)
        for _,l in ipairs(obj.Box) do l.Visible=false end
        for _,b in ipairs(obj.Bones) do b.Visible=false end
        obj.HPOutline.Visible=false; obj.HPFill.Visible=false; obj.HPText.Visible=false
        obj.Name.Visible=false; obj.Tracer.Visible=false; obj.Snapline.Visible=false
        obj.Highlight.Enabled=false
    end

    local function InitESP(player)
        if player==LocalPlayer or ESPObjects[player] then return end
        ESPObjects[player]=MakeESPObjects()
        if player.Character then CacheCharSize(player.Character) end
        player.CharacterAdded:Connect(function(char)
            CharSizeCache[char]=nil
            if ESPObjects[player] then ESPObjects[player].Highlight.Parent=nil end
            task.wait(0.1); CacheCharSize(char)
        end)
    end

    local function RemoveESP(player)
        local obj=ESPObjects[player]; if not obj then return end
        DestroyESPObjects(obj)
        if player.Character then CharSizeCache[player.Character]=nil end
        ESPObjects[player]=nil
    end

    local function DrawBox(box, bx, by, bw, bh, color, thick, cf, size)
        for _,l in ipairs(box) do l.Visible=false end
        local style=CONFIG.ESP.BoxStyle
        if style=="Full" then
            local edges={{Vector2.new(bx,by),Vector2.new(bx+bw,by)},{Vector2.new(bx+bw,by),Vector2.new(bx+bw,by+bh)},{Vector2.new(bx+bw,by+bh),Vector2.new(bx,by+bh)},{Vector2.new(bx,by+bh),Vector2.new(bx,by)}}
            for i,e in ipairs(edges) do box[i].From=e[1]; box[i].To=e[2]; box[i].Color=color; box[i].Thickness=thick; box[i].Visible=true end
        elseif style=="Corner" then
            local cx,cy=bw*0.22,bh*0.22
            local pts={
                {Vector2.new(bx,by),Vector2.new(bx+cx,by)},{Vector2.new(bx+bw-cx,by),Vector2.new(bx+bw,by)},
                {Vector2.new(bx,by+bh),Vector2.new(bx+cx,by+bh)},{Vector2.new(bx+bw-cx,by+bh),Vector2.new(bx+bw,by+bh)},
                {Vector2.new(bx,by),Vector2.new(bx,by+cy)},{Vector2.new(bx+bw,by),Vector2.new(bx+bw,by+cy)},
                {Vector2.new(bx,by+bh-cy),Vector2.new(bx,by+bh)},{Vector2.new(bx+bw,by+bh-cy),Vector2.new(bx+bw,by+bh)},
            }
            for i,p in ipairs(pts) do box[i].From=p[1]; box[i].To=p[2]; box[i].Color=color; box[i].Thickness=thick; box[i].Visible=true end
        elseif style=="ThreeD" then
            if not cf or not size then return end
            local half=size/2
            local c3d={cf*Vector3.new(-half.X,half.Y,-half.Z),cf*Vector3.new(half.X,half.Y,-half.Z),cf*Vector3.new(half.X,-half.Y,-half.Z),cf*Vector3.new(-half.X,-half.Y,-half.Z),cf*Vector3.new(-half.X,half.Y,half.Z),cf*Vector3.new(half.X,half.Y,half.Z),cf*Vector3.new(half.X,-half.Y,half.Z),cf*Vector3.new(-half.X,-half.Y,half.Z)}
            local s2d={}
            for i,v in ipairs(c3d) do local sp,on=Camera:WorldToViewportPoint(v); if not on or sp.Z<=0 then return end; s2d[i]=Vector2.new(sp.X,sp.Y) end
            local edges={{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
            for i,e in ipairs(edges) do box[i].From=s2d[e[1]]; box[i].To=s2d[e[2]]; box[i].Color=color; box[i].Thickness=thick; box[i].Visible=true end
        end
    end

    local function DrawSkeleton(bones, char, color, thick)
        for i,pair in ipairs(SkeletonBonePairs) do
            local line=bones[i]; local p0=char:FindFirstChild(pair[1]); local p1=char:FindFirstChild(pair[2])
            if not p0 or not p1 then line.Visible=false; continue end
            local s0,on0=Camera:WorldToViewportPoint(p0.Position)
            local s1,on1=Camera:WorldToViewportPoint(p1.Position)
            if not on0 or not on1 or s0.Z<=0 or s1.Z<=0 then line.Visible=false; continue end
            line.From=Vector2.new(s0.X,s0.Y); line.To=Vector2.new(s1.X,s1.Y)
            line.Color=color; line.Thickness=thick; line.Visible=true
        end
    end

    local function GetTracerOrigin()
        local vp=Camera.ViewportSize; local o=CONFIG.ESP.TracerOrigin
        if o=="Top" then return Vector2.new(vp.X/2,0) end
        if o=="Mouse" then return UserInputService:GetMouseLocation() end
        if o=="Center" then return Vector2.new(vp.X/2,vp.Y/2) end
        return Vector2.new(vp.X/2,vp.Y)
    end

    local function IsVisible(char, pos)
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances={char,LocalPlayer.Character or {}}
        return workspace:Raycast(Camera.CFrame.Position,pos-Camera.CFrame.Position,params)==nil
    end

    local lastESPUpdate=0
    if HasDrawing then
        RunService.RenderStepped:Connect(function(dt)
            RainbowHue=(RainbowHue+dt*CONFIG.Misc.RainbowSpeed*0.5)%1
            local rb=Color3.fromHSV(RainbowHue,0.8,1)
            local now=tick()
            if now-lastESPUpdate<CONFIG.ESP.RefreshRate then return end
            lastESPUpdate=now

            for _,player in ipairs(Players:GetPlayers()) do
                if player==LocalPlayer then continue end
                if not ESPObjects[player] then InitESP(player) end
                local obj=ESPObjects[player]
                local char=player.Character
                local hrp=char and char:FindFirstChild("HumanoidRootPart")
                local hum=char and char:FindFirstChildOfClass("Humanoid")
                local alive=hum and hum.Health>0
                local isTeam=CONFIG.ESP.TeamCheck and player.Team==LocalPlayer.Team
                if not char or not hrp or not alive or isTeam then HideESP(obj); continue end

                local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
                if not onScreen or pos.Z<=0 then HideESP(obj); continue end

                local dist=(hrp.Position-Camera.CFrame.Position).Magnitude
                if dist>CONFIG.ESP.MaxDistance then HideESP(obj); continue end

                local size=CharSizeCache[char] or Vector3.new(3,5,3)
                local topW=hrp.CFrame*Vector3.new(0,size.Y/2,0)
                local bottomW=hrp.CFrame*Vector3.new(0,-size.Y/2,0)
                local topSP,topOn=Camera:WorldToViewportPoint(topW)
                local bottomSP,bottomOn=Camera:WorldToViewportPoint(bottomW)
                if not topOn or not bottomOn then HideESP(obj); continue end

                local sh=math.max(bottomSP.Y-topSP.Y,1)
                local sw=sh*0.55
                local bx=topSP.X-sw/2; local by=topSP.Y; local bw=sw; local bh=sh

                local head=char:FindFirstChild("Head")
                local targetPos=head and head.Position or hrp.Position
                local visible=IsVisible(char,targetPos)
                if not CONFIG.ESP.WallPenetration and not visible then HideESP(obj); continue end

                local boxColor=CONFIG.Misc.RainbowESP and rb or (visible and CONFIG.ESP.BoxColor or CONFIG.ESP.WallPenColor)
                local nameColor=CONFIG.Misc.RainbowESP and rb or CONFIG.ESP.NameColor
                local skelColor=CONFIG.Misc.RainbowESP and rb or CONFIG.ESP.SkeletonColor

                if CONFIG.ESP.Box then DrawBox(obj.Box,bx,by,bw,bh,boxColor,CONFIG.ESP.BoxThickness,hrp.CFrame,size)
                else for _,l in ipairs(obj.Box) do l.Visible=false end end

                if CONFIG.ESP.HealthBar then
                    local hpRat=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
                    local barX=bx-7; local barY=by
                    obj.HPOutline.Position=Vector2.new(barX-1,barY-1); obj.HPOutline.Size=Vector2.new(6,bh+2); obj.HPOutline.Visible=true
                    obj.HPFill.Position=Vector2.new(barX,barY+bh*(1-hpRat)); obj.HPFill.Size=Vector2.new(4,bh*hpRat)
                    obj.HPFill.Color=Color3.fromHSV(hpRat*0.33,1,1); obj.HPFill.Visible=true; obj.HPText.Visible=false
                else obj.HPOutline.Visible=false; obj.HPFill.Visible=false; obj.HPText.Visible=false end

                if CONFIG.ESP.Name then
                    obj.Name.Text=player.DisplayName; obj.Name.Position=Vector2.new(bx+bw/2,by-16)
                    obj.Name.Color=nameColor; obj.Name.Visible=true
                else obj.Name.Visible=false end

                if CONFIG.ESP.Tracer then
                    obj.Tracer.From=GetTracerOrigin(); obj.Tracer.To=Vector2.new(pos.X,pos.Y)
                    obj.Tracer.Color=CONFIG.Misc.RainbowESP and rb or CONFIG.ESP.TracerColor
                    obj.Tracer.Thickness=CONFIG.ESP.TracerThickness; obj.Tracer.Visible=true
                else obj.Tracer.Visible=false end

                if CONFIG.ESP.Snaplines then
                    obj.Snapline.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                    obj.Snapline.To=Vector2.new(pos.X,pos.Y); obj.Snapline.Color=boxColor; obj.Snapline.Visible=true
                else obj.Snapline.Visible=false end

                if CONFIG.ESP.Skeleton then DrawSkeleton(obj.Bones,char,skelColor,CONFIG.ESP.SkeletonThickness)
                else for _,b in ipairs(obj.Bones) do b.Visible=false end end

                if CONFIG.ESP.Chams then
                    obj.Highlight.Parent=char
                    obj.Highlight.FillColor=CONFIG.Misc.RainbowESP and rb or (visible and CONFIG.ESP.ChamsColor or CONFIG.ESP.ChamsOccludedColor)
                    obj.Highlight.OutlineColor=CONFIG.ESP.ChamsOutlineColor
                    obj.Highlight.FillTransparency=CONFIG.ESP.ChamsTransparency
                    obj.Highlight.OutlineTransparency=CONFIG.ESP.ChamsOutlineTransparency
                    obj.Highlight.Enabled=true
                else obj.Highlight.Enabled=false end
            end
        end)

        Players.PlayerRemoving:Connect(RemoveESP)
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then InitESP(p) end end
        Players.PlayerAdded:Connect(InitESP)
    end

    -- ================================================
    -- Aimbot Core
    -- ================================================

    local AimState={Running=false,Locked=nil,Anim=nil,OrigSens=UserInputService.MouseDeltaSensitivity,SilentTarget=nil}
    local FOVCircle,FOVOutline,AimTracer

    if HasDrawing then
        FOVCircle=NewDraw("Circle",{Visible=false,NumSides=60,Filled=CONFIG.Aimbot.FOVFilled,Thickness=CONFIG.Aimbot.FOVThickness,Transparency=CONFIG.Aimbot.FOVTransparency,Color=CONFIG.Aimbot.FOVColor})
        FOVOutline=NewDraw("Circle",{Visible=false,NumSides=60,Filled=false,Thickness=CONFIG.Aimbot.FOVThickness+1,Transparency=CONFIG.Aimbot.FOVTransparency,Color=Color3.fromRGB(0,0,0)})
        AimTracer=NewDraw("Line",{Visible=false,Thickness=CONFIG.Aimbot.TracerThickness,Transparency=0.3,Color=CONFIG.Aimbot.TracerColor})
    end

    local function GetMouseLoc() return UserInputService:GetMouseLocation() end
    local function IsAlive(char) if not char then return false end; local h=char:FindFirstChildOfClass("Humanoid"); return h and h.Health>0 end
    local function IsAimTeam(p) if not CONFIG.Aimbot.TeamCheck then return false end; return p.Team and p.Team==LocalPlayer.Team end

    local function AimWallCheck(char,pos)
        if not CONFIG.Aimbot.WallCheck or not pos then return not CONFIG.Aimbot.WallCheck end
        local bl={}
        if LocalPlayer.Character then for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do bl[#bl+1]=v end end
        for _,v in ipairs(char:GetDescendants()) do bl[#bl+1]=v end
        local ok,obs=pcall(Camera.GetPartsObscuringTarget,Camera,{pos},bl)
        if not ok then return false end; return #obs==0
    end

    local function PredictPos(part)
        local vel=part.AssemblyLinearVelocity; local t=CONFIG.Aimbot.Prediction
        local pos=part.Position+vel*t
        if CONFIG.Aimbot.GravityComp then pos=pos-Vector3.new(0,0.5*workspace.Gravity*t*t,0) end
        return pos
    end

    local function GetClosestTarget()
        local closest,dist=nil,CONFIG.Aimbot.FOVEnabled and CONFIG.Aimbot.FOV or math.huge
        local m=GetMouseLoc()
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer then continue end; if IsAimTeam(p) then continue end
            local c=p.Character; if not c then continue end
            if CONFIG.Aimbot.AliveCheck and not IsAlive(c) then continue end
            local part=c:FindFirstChild(CONFIG.Aimbot.LockPart); if not part then continue end
            local pos=PredictPos(part); local screen,on=Camera:WorldToViewportPoint(pos)
            if not on or screen.Z<=0 then continue end
            local sv=Vector2.new(screen.X,screen.Y); local d=(m-sv).Magnitude
            if d<dist and AimWallCheck(c,pos) then dist=d; closest={player=p,char=c,part=part,screenPos=sv,worldPos=pos} end
        end
        return closest
    end

    local function CancelLock()
        AimState.Locked=nil; AimState.SilentTarget=nil
        UserInputService.MouseDeltaSensitivity=AimState.OrigSens
        if AimState.Anim then AimState.Anim:Cancel(); AimState.Anim=nil end
        if HasDrawing then FOVCircle.Color=CONFIG.Aimbot.FOVColor; AimTracer.Visible=false end
    end

    local function UpdateFOV(m,visible,lockedColor)
        if not HasDrawing then return end
        FOVCircle.Position=m; FOVCircle.Radius=CONFIG.Aimbot.FOV; FOVCircle.Filled=CONFIG.Aimbot.FOVFilled
        FOVCircle.Visible=visible; FOVCircle.Color=lockedColor or CONFIG.Aimbot.FOVColor
        FOVOutline.Position=m; FOVOutline.Radius=CONFIG.Aimbot.FOV; FOVOutline.Visible=visible
    end

    local InHook=false
    local ShouldSilent

    if ExecutorLevel=="High" and hookmetamethod and newcclosure and getnamecallmethod then
        RunService.RenderStepped:Connect(function()
            if CONFIG.Aimbot.Method=="Silent" and CONFIG.Aimbot.Enabled and AimState.Running then
                local t=GetClosestTarget(); AimState.SilentTarget=t and t.worldPos or nil
            else AimState.SilentTarget=nil end
        end)

        ShouldSilent=function()
            return AimState.SilentTarget~=nil and CONFIG.Aimbot.Enabled
                and CONFIG.Aimbot.Method=="Silent" and AimState.Running
                and (math.random()*100)<=CONFIG.Aimbot.SilentChance
        end

        pcall(function()
            local oldIdx; oldIdx=hookmetamethod(game,"__index",newcclosure(function(self,key)
                local fromSelf=checkcaller and checkcaller()
                if not InHook and not fromSelf and self==Mouse and ShouldSilent() then
                    InHook=true
                    local ok,res=pcall(function()
                        if key=="Hit" then return CFrame.new(AimState.SilentTarget)
                        elseif key=="UnitRay" then local o=Camera.CFrame.Position; return Ray.new(o,(AimState.SilentTarget-o).Unit) end
                    end)
                    InHook=false; if ok and res~=nil then return res end
                end
                return oldIdx(self,key)
            end))
        end)

        pcall(function()
            local oldNC; oldNC=hookmetamethod(game,"__namecall",newcclosure(function(...)
                local method=getnamecallmethod(); local fromSelf=checkcaller and checkcaller()
                if not fromSelf then
                    local args={...}; local self=args[1]
                    if (method=="Kick" or method=="kick") and self==LocalPlayer then return end
                    if ShouldSilent and ShouldSilent() then
                        if self==workspace and (method=="Raycast" or method=="raycast") and #args>=3 and typeof(args[2])=="Vector3" then
                            InHook=true; args[3]=AimState.SilentTarget-args[2]
                            local ok,res=pcall(oldNC,table.unpack(args)); InHook=false; if ok then return res end
                        end
                        if self==workspace and (method=="FindPartOnRay" or method=="findPartOnRay") and #args>=2 and typeof(args[2])=="Ray" then
                            InHook=true; args[2]=Ray.new(args[2].Origin,AimState.SilentTarget-args[2].Origin)
                            local ok,res=pcall(oldNC,table.unpack(args)); InHook=false; if ok then return res end
                        end
                    end
                end
                return oldNC(...)
            end))
        end)
    end

    local function OnAimbotUpdate()
        if not CONFIG.Aimbot.Enabled then UpdateFOV(GetMouseLoc(),false,nil); return end
        local m=GetMouseLoc(); UpdateFOV(m,CONFIG.Aimbot.FOVEnabled,nil)
        if not AimState.Running then CancelLock(); return end

        if HasDrawing and CONFIG.Aimbot.TracerEnabled and not AimState.Locked then
            local t=GetClosestTarget()
            if t then AimTracer.Visible=true; AimTracer.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); AimTracer.To=t.screenPos; AimTracer.Color=CONFIG.Aimbot.TracerColor
            else AimTracer.Visible=false end
        elseif HasDrawing then AimTracer.Visible=false end

        if CONFIG.Aimbot.Method=="Silent" and ExecutorLevel=="High" then return end

        if not AimState.Locked then
            local t=GetClosestTarget(); if t then AimState.Locked=t.player end
        else
            local c=AimState.Locked.Character
            if not c or not IsAlive(c) or not c:FindFirstChild(CONFIG.Aimbot.LockPart) then CancelLock() end
        end

        if AimState.Locked and AimState.Locked.Character then
            local c=AimState.Locked.Character; local part=c:FindFirstChild(CONFIG.Aimbot.LockPart); local hum=c:FindFirstChildOfClass("Humanoid")
            if part and hum then
                local offset=Vector3.zero
                if CONFIG.Aimbot.OffsetToMove then offset=hum.MoveDirection*math.clamp(CONFIG.Aimbot.OffsetAmount,1,30)/10 end
                local tp=part.Position+offset
                if CONFIG.Aimbot.Smoothness>0 then
                    if AimState.Anim then AimState.Anim:Cancel() end
                    AimState.Anim=TweenService:Create(Camera,TweenInfo.new(CONFIG.Aimbot.Smoothness,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{CFrame=CFrame.new(Camera.CFrame.Position,tp)})
                    AimState.Anim:Play()
                else Camera.CFrame=CFrame.new(Camera.CFrame.Position,tp) end
                UserInputService.MouseDeltaSensitivity=0
                UpdateFOV(m,CONFIG.Aimbot.FOVEnabled,CONFIG.Aimbot.FOVLockedColor)
            else CancelLock() end
        end
    end

    RunService.RenderStepped:Connect(OnAimbotUpdate)

    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end; if UserInputService:GetFocusedTextBox() then return end
        local k=CONFIG.Aimbot.TriggerKey
        if (i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==k) or i.UserInputType==k then
            if CONFIG.Aimbot.Toggle then AimState.Running=not AimState.Running; if not AimState.Running then CancelLock() end
            else AimState.Running=true end
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        local k=CONFIG.Aimbot.TriggerKey
        if (i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==k) or i.UserInputType==k then
            if not CONFIG.Aimbot.Toggle then AimState.Running=false; CancelLock() end
        end
    end)

    -- ================================================
    -- GUI Tabs
    -- ================================================

    -- Visual
    local VP=Pages["Visual"]
    local espSec=Section(VP,"ESP")
    Toggle(espSec,"ESP Master",CONFIG.ESP.Enabled,function(v) CONFIG.ESP.Enabled=v end)
    Toggle(espSec,"Box",CONFIG.ESP.Box,function(v) CONFIG.ESP.Box=v end)
    Dropdown(espSec,"Box Style",{"Corner","Full","ThreeD"},CONFIG.ESP.BoxStyle,function(v) CONFIG.ESP.BoxStyle=v end)
    Toggle(espSec,"Name",CONFIG.ESP.Name,function(v) CONFIG.ESP.Name=v end)
    Toggle(espSec,"Skeleton",CONFIG.ESP.Skeleton,function(v) CONFIG.ESP.Skeleton=v end)
    Toggle(espSec,"Health Bar",CONFIG.ESP.HealthBar,function(v) CONFIG.ESP.HealthBar=v end)
    Toggle(espSec,"Chams",CONFIG.ESP.Chams,function(v) CONFIG.ESP.Chams=v end)
    Toggle(espSec,"Tracer",CONFIG.ESP.Tracer,function(v) CONFIG.ESP.Tracer=v end)
    Dropdown(espSec,"Tracer Origin",{"Bottom","Top","Mouse","Center"},CONFIG.ESP.TracerOrigin,function(v) CONFIG.ESP.TracerOrigin=v end)
    Toggle(espSec,"Snaplines",CONFIG.ESP.Snaplines,function(v) CONFIG.ESP.Snaplines=v end)
    Toggle(espSec,"Wall Penetration",CONFIG.ESP.WallPenetration,function(v) CONFIG.ESP.WallPenetration=v end)
    Toggle(espSec,"Team Check",CONFIG.ESP.TeamCheck,function(v) CONFIG.ESP.TeamCheck=v end)
    Slider(espSec,"Max Distance",100,5000,CONFIG.ESP.MaxDistance,function(v) CONFIG.ESP.MaxDistance=v end)
    Slider(espSec,"Refresh Rate (fps)",10,144,60,function(v) CONFIG.ESP.RefreshRate=1/v end)

    -- Combat
    local CP=Pages["Combat"]
    local methodSec=Section(CP,"Aimbot Method")
    Label(methodSec,"Camera = safe. Silent = High executor only.",UDim2.new(0,0,0,0),UDim2.new(1,0,0,28),Pal.TextMute,10).TextWrapped=true
    Dropdown(methodSec,"Method",{"Camera","Silent"},CONFIG.Aimbot.Method,function(v)
        CONFIG.Aimbot.Method=(v=="Silent" and ExecutorLevel~="High") and "Camera" or v
    end)
    local aimSec=Section(CP,"Aimbot")
    Toggle(aimSec,"Aimbot Master",CONFIG.Aimbot.Enabled,function(v) CONFIG.Aimbot.Enabled=v end)
    Toggle(aimSec,"Toggle Mode (RMB)",CONFIG.Aimbot.Toggle,function(v) CONFIG.Aimbot.Toggle=v end)
    Toggle(aimSec,"Wall Check",CONFIG.Aimbot.WallCheck,function(v) CONFIG.Aimbot.WallCheck=v end)
    Toggle(aimSec,"Team Check",CONFIG.Aimbot.TeamCheck,function(v) CONFIG.Aimbot.TeamCheck=v end)
    Toggle(aimSec,"Offset to Move",CONFIG.Aimbot.OffsetToMove,function(v) CONFIG.Aimbot.OffsetToMove=v end)
    local fovSec=Section(CP,"FOV")
    Toggle(fovSec,"Show FOV Circle",CONFIG.Aimbot.FOVEnabled,function(v) CONFIG.Aimbot.FOVEnabled=v end)
    Slider(fovSec,"FOV Size",10,500,CONFIG.Aimbot.FOV,function(v) CONFIG.Aimbot.FOV=v end)
    local smoothSec=Section(CP,"Smoothness & Offset")
    Slider(smoothSec,"Smoothness x100",0,50,math.floor(CONFIG.Aimbot.Smoothness*100),function(v) CONFIG.Aimbot.Smoothness=v/100 end)
    Slider(smoothSec,"Offset Amount",1,30,CONFIG.Aimbot.OffsetAmount,function(v) CONFIG.Aimbot.OffsetAmount=v end)
    local silentSec=Section(CP,"Silent Aim Tuning")
    Slider(silentSec,"Chance %",1,100,CONFIG.Aimbot.SilentChance,function(v) CONFIG.Aimbot.SilentChance=v end)
    Slider(silentSec,"Prediction ms",0,500,math.floor(CONFIG.Aimbot.Prediction*1000),function(v) CONFIG.Aimbot.Prediction=v/1000 end)
    Toggle(silentSec,"Gravity Comp",CONFIG.Aimbot.GravityComp,function(v) CONFIG.Aimbot.GravityComp=v end)

    -- Misc
    local MP=Pages["Misc"]
    local fxSec=Section(MP,"Visual FX")
    Toggle(fxSec,"Rainbow ESP",CONFIG.Misc.RainbowESP,function(v) CONFIG.Misc.RainbowESP=v end)
    Slider(fxSec,"Rainbow Speed",1,10,math.floor(CONFIG.Misc.RainbowSpeed),function(v) CONFIG.Misc.RainbowSpeed=v end)

    local invSec=Section(MP,"Invisible")
    Label(invSec,"Sinks character below map in lying pose. Movement is preserved server-side.",
        UDim2.new(0,0,0,0),UDim2.new(1,0,0,32),Pal.TextMute,10).TextWrapped=true
    Toggle(invSec,"Invisible",false,function(v)
        CONFIG.Misc.Invisible=v
        if v then EnableInvisible() else DisableInvisible() end
    end)

    local flySec=Section(MP,"Fly")
    Label(flySec,"WASD + E/Space = up, Q/Shift = down. Ragdoll method is game-specific.",
        UDim2.new(0,0,0,0),UDim2.new(1,0,0,32),Pal.TextMute,10).TextWrapped=true
    Dropdown(flySec,"Fly Method",{"Basic","Ragdoll"},CONFIG.Misc.FlyMethod,function(v)
        CONFIG.Misc.FlyMethod=v
        if FlyActive then ToggleFly(true,v) end
    end)
    Toggle(flySec,"Fly",false,function(v)
        CONFIG.Misc.FlyEnabled=v
        ToggleFly(v,CONFIG.Misc.FlyMethod)
    end)
    Slider(flySec,"Fly Speed",10,300,CONFIG.Misc.FlySpeed,function(v) CONFIG.Misc.FlySpeed=v end)

    -- World
    local WP=Pages["World"]
    local lightSec=Section(WP,"Lighting")
    Toggle(lightSec,"Fullbright",CONFIG.World.Fullbright,function(v)
        CONFIG.World.Fullbright=v
        if v then Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=100000; Lighting.GlobalShadows=false; Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
        else Lighting.Brightness=1; Lighting.GlobalShadows=true; Lighting.Ambient=Color3.fromRGB(127,127,127); Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127) end
    end)
    Toggle(lightSec,"No Fog",CONFIG.World.NoFog,function(v)
        CONFIG.World.NoFog=v; Lighting.FogEnd=v and 100000 or 1000; Lighting.FogStart=v and 100000 or 0
    end)

    -- AntiCheat
    local ACP=Pages["AntiCheat"]
    local acSec=Section(ACP,"Anti-Kick Status")
    local akStatus=Label(acSec,"GC Patch: active | Namecall Hook: "..(ExecutorLevel=="High" and "active" or "skip (Low executor)"),
        UDim2.new(0,0,0,0),UDim2.new(1,0,0,32),Pal.Success,11)
    akStatus.TextWrapped=true
    local patchCount=Label(acSec,"patches applied: counting...",UDim2.new(0,0,0,0),UDim2.new(1,0,0,20),Pal.TextDim,11)
    Button(acSec,"Re-Patch Now",UDim2.new(1,0,0,32),function()
        local n=PatchAntiKick(); patchCount.Text="patches applied: "..tostring(n or 0)
    end)
    Toggle(acSec,"Auto Re-Patch (5s)",true,function(v) AntiKickActive=v end)
    task.spawn(function()
        task.wait(0.5); local n=PatchAntiKick(); patchCount.Text="patches applied: "..tostring(n or 0)
    end)

    SwitchTab("Visual")
end
