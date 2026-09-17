-- ================================================
-- VelsHub v3.1 | Supabase Auth + Stealth ESP + User Panel
-- ================================================
-- Changelog:
--   v3.0.1: request fallback, no emoji
--   v3.1:   all features OFF by default, Highlight instead of
--           SelectionBox (anti instance-scanner), user info panel,
--           all English UI, admin tab for admin users

local CONFIG = {
    SupabaseURL = "https://glkrwegvlmowprdbobkc.supabase.co",
    SupabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsa3J3ZWd2bG1vd3ByZGJvYmtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk2NDEwOTgsImV4cCI6MjEwNTIxNzA5OH0.229jGLrrhuFJwp8GUpMzhTIhWqAdgCggYHB2SNF4BNc",

    ESP = {
        Enabled         = false,
        Box             = false,
        Name            = false,
        Skeleton        = false,
        HealthBar       = false,
        Highlight       = false,
        HighlightMode   = "Outline",
        WallPenetration = false,
        BoxColor        = Color3.fromRGB(220, 100, 180),
        NameColor       = Color3.fromRGB(255, 180, 230),
        SkeletonColor   = Color3.fromRGB(180, 80, 220),
        HighlightColor  = Color3.fromRGB(180, 60, 200),
        WallPenColor    = Color3.fromRGB(255, 100, 100),
        TeamCheck       = false,
    },

    Aimbot = {
        Enabled        = false,
        Method         = "Camera",
        TriggerKey     = Enum.UserInputType.MouseButton2,
        Toggle         = false,
        LockPart       = "Head",
        Smoothness     = 0.12,
        OffsetToMove   = false,
        OffsetAmount   = 15,

        TeamCheck      = false,
        AliveCheck     = true,
        WallCheck      = false,

        FOVEnabled     = false,
        FOV            = 180,
        FOVColor       = Color3.fromRGB(220, 100, 180),
        FOVLockedColor = Color3.fromRGB(255, 80, 120),
        FOVThickness   = 1.5,
        FOVTransparency = 0.3,
        FOVFilled      = false,

        TracerEnabled  = false,
        TracerColor    = Color3.fromRGB(220, 100, 180),
        TracerThickness = 1.5,

        SilentChance   = 100,
        Prediction     = 0.12,
        GravityComp    = true,
    },

    Misc = {
        RainbowESP = false,
    },

    World = {
        Fullbright = false,
        NoFog      = false,
    },
}

local Pal = {
    Window      = Color3.fromRGB(14, 10, 22),
    Sidebar     = Color3.fromRGB(18, 12, 28),
    TopBar      = Color3.fromRGB(22, 14, 35),
    Card        = Color3.fromRGB(28, 18, 42),
    CardHover   = Color3.fromRGB(36, 22, 54),
    CardActive  = Color3.fromRGB(48, 28, 72),
    Border      = Color3.fromRGB(60, 34, 88),
    BorderSoft  = Color3.fromRGB(40, 24, 60),
    Accent      = Color3.fromRGB(180, 60, 200),
    AccentAlt   = Color3.fromRGB(220, 80, 160),
    AccentSoft  = Color3.fromRGB(140, 50, 180),
    Text        = Color3.fromRGB(240, 210, 255),
    TextDim     = Color3.fromRGB(160, 130, 190),
    TextMute    = Color3.fromRGB(110, 90, 140),
    Input       = Color3.fromRGB(35, 22, 55),
    ToggleOff   = Color3.fromRGB(50, 32, 70),
    Success     = Color3.fromRGB(100, 220, 150),
    Error       = Color3.fromRGB(255, 80, 120),
    Shadow      = Color3.fromRGB(6, 3, 12),
    Gold        = Color3.fromRGB(255, 200, 90),
}

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")

local CoreGui
pcall(function() CoreGui = game:GetService("CoreGui") end)
if not CoreGui then
    CoreGui = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local Mouse       = LocalPlayer:GetMouse()

local ExecutorLevel = "Low"
local ExecutorName  = "Unknown"
do
    if syn then ExecutorName = "Synapse"; ExecutorLevel = "High"
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

local HasDrawing = (Drawing and Drawing.new) ~= nil

-- ================================================
-- AUTH - Supabase REST via request
-- ================================================

local CurrentUser = nil

local function SupabaseReq(method, path, body)
    local url = CONFIG.SupabaseURL .. "/rest/v1/" .. path
    local headers = {
        ["apikey"]        = CONFIG.SupabaseKey,
        ["Authorization"] = "Bearer " .. CONFIG.SupabaseKey,
        ["Content-Type"]  = "application/json",
        ["Prefer"]        = "return=representation",
    }

    local payload = { Url = url, Method = method, Headers = headers }
    if body then payload.Body = HttpService:JSONEncode(body) end

    local fn = nil
    if request then fn = request
    elseif http and http.request then fn = http.request
    elseif syn and syn.request then fn = syn.request
    end

    if not fn then return false, "No HTTP request function available" end

    local ok, res = pcall(fn, payload)
    if not ok then return false, "Request error: " .. tostring(res) end
    if type(res) ~= "table" then return false, "Invalid response" end
    if not res.Success then return false, "Server " .. tostring(res.StatusCode) .. ": " .. tostring(res.Body) end

    local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
    if not ok2 then return false, "Parse error: " .. tostring(res.Body) end

    return true, data
end

local function SupabaseLogin(u, p)
    if u == "" or p == "" then return false, "empty" end
    local path = string.format(
        "accounts?username=eq.%s&password=eq.%s&select=*",
        HttpService:UrlEncode(u), HttpService:UrlEncode(p)
    )
    local ok, data = SupabaseReq("GET", path)
    if not ok then return false, tostring(data) end
    if type(data) ~= "table" or #data == 0 then
        return false, "wrong username or password"
    end
    CurrentUser = {
        username = data[1].username,
        isAdmin  = data[1].is_admin == true,
        created  = data[1].created_at or "-",
    }
    return true, "Welcome, " .. CurrentUser.username
end

local function SupabaseRegister(u, p)
    if u == "" or p == "" then return false, "empty" end
    if #u < 3 then return false, "username min 3 chars" end
    if #p < 3 then return false, "password min 3 chars" end

    local ok, data = SupabaseReq("GET", string.format(
        "accounts?username=eq.%s&select=id", HttpService:UrlEncode(u)
    ))
    if ok and type(data) == "table" and #data > 0 then
        return false, "username already taken"
    end

    local ok2, res = SupabaseReq("POST", "accounts", {
        username = u,
        password = p,
        is_admin = false,
    })
    if not ok2 then return false, tostring(res) end
    return true, "account created"
end

-- admin only
local function SupabaseListUsers()
    local ok, data = SupabaseReq("GET", "accounts?select=username,is_admin,created_at&order=id.asc")
    if not ok then return false, tostring(data) end
    return true, data
end

local function SupabaseSetAdmin(u, v)
    local ok, res = SupabaseReq("PATCH",
        string.format("accounts?username=eq.%s", HttpService:UrlEncode(u)),
        { is_admin = v })
    if not ok then return false, tostring(res) end
    return true, "updated"
end

-- ================================================
-- GUI Helpers
-- ================================================

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function Stroke(p, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color or Pal.Accent
    s.Thickness    = thickness or 1
    s.Transparency = transparency or 0
    s.Parent       = p
    return s
end

local function Pad(p, t, r, b, l)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.Parent        = p
    return u
end

local function Frame(parent, size, pos, color, transparency)
    local f = Instance.new("Frame")
    f.Size                   = size
    f.Position               = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3       = color or Pal.Card
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel        = 0
    f.Parent                 = parent
    return f
end

local function Label(parent, text, pos, size, color, fs, xa)
    local l = Instance.new("TextLabel")
    l.Text                   = text
    l.Position               = pos or UDim2.new(0,0,0,0)
    l.Size                   = size or UDim2.new(1,0,0,20)
    l.BackgroundTransparency = 1
    l.TextColor3             = color or Pal.Text
    l.Font                   = Enum.Font.Gotham
    l.TextSize               = fs or 13
    l.TextXAlignment         = xa or Enum.TextXAlignment.Left
    l.Parent                 = parent
    return l
end

local function BoldLabel(parent, text, pos, size, color, fs, xa)
    local l = Label(parent, text, pos, size, color, fs, xa)
    l.Font = Enum.Font.GothamBold
    return l
end

local function TextBox(parent, placeholder, size)
    local tb = Instance.new("TextBox")
    tb.PlaceholderText   = placeholder or ""
    tb.Size              = size or UDim2.new(1,0,0,34)
    tb.BackgroundColor3  = Pal.Input
    tb.TextColor3        = Pal.Text
    tb.PlaceholderColor3 = Pal.TextMute
    tb.Font              = Enum.Font.Gotham
    tb.TextSize          = 13
    tb.BorderSizePixel   = 0
    tb.ClearTextOnFocus  = false
    tb.Parent            = parent
    Corner(tb, 6)
    Stroke(tb, Pal.BorderSoft, 1, 0.3)
    Pad(tb, 0, 0, 0, 10)
    tb.Focused:Connect(function()
        local s = tb:FindFirstChildOfClass("UIStroke")
        if s then TweenService:Create(s, TweenInfo.new(0.15), { Color = Pal.Accent, Transparency = 0 }):Play() end
    end)
    tb.FocusLost:Connect(function()
        local s = tb:FindFirstChildOfClass("UIStroke")
        if s then TweenService:Create(s, TweenInfo.new(0.15), { Color = Pal.BorderSoft, Transparency = 0.3 }):Play() end
    end)
    return tb
end

local function Button(parent, text, size, onClick)
    local btn = Instance.new("TextButton")
    btn.Text             = text
    btn.Size             = size or UDim2.new(1,0,0,36)
    btn.BackgroundColor3 = Pal.Accent
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 13
    btn.BorderSizePixel  = 0
    btn.AutoButtonColor  = false
    btn.Parent           = parent
    Corner(btn, 8)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.AccentAlt }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Accent }):Play()
    end)
    if onClick then btn.MouseButton1Click:Connect(onClick) end
    return btn
end

-- ================================================
-- LOGIN GUI
-- ================================================

local LoginGui = Instance.new("ScreenGui")
LoginGui.Name           = "VelsHub_Login"
LoginGui.ResetOnSpawn   = false
LoginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoginGui.IgnoreGuiInset = true
LoginGui.Parent         = CoreGui

local LoginBackdrop = Frame(LoginGui, UDim2.new(1,0,1,0), nil, Pal.Window, 0.15)
LoginBackdrop.ZIndex = 1

do
    local g = Instance.new("UIGradient")
    g.Rotation = 45
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(12, 6, 22)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 12, 48)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(12, 6, 22)),
    })
    g.Parent = LoginBackdrop
end

local Vignette = Frame(LoginBackdrop, UDim2.new(1,0,1,0), nil, Color3.fromRGB(0,0,0), 0.55)
Vignette.ZIndex = 2
do
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.3),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1,   0.3),
    })
    g.Rotation = 90
    g.Parent = Vignette
end

local ParticleLayer = Frame(LoginBackdrop, UDim2.new(1,0,1,0), nil, Color3.fromRGB(0,0,0), 1)
ParticleLayer.ZIndex = 3

local function SpawnParticle()
    local p = Frame(ParticleLayer, UDim2.new(0, math.random(2,5), 0, math.random(2,5)),
        UDim2.new(math.random(), 0, 1.05, 0),
        math.random() > 0.5 and Pal.Accent or Pal.AccentAlt, 0.4)
    p.ZIndex = 3
    Corner(p, 99)
    local dur = math.random(4, 9) + math.random()
    local target = UDim2.new(p.Position.X.Scale, math.random(-30,30), -0.1, 0)
    TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Position = target }):Play()
    task.spawn(function() task.wait(dur); p:Destroy() end)
end

task.spawn(function()
    while LoginGui.Parent do
        for _ = 1, math.random(1,3) do SpawnParticle() end
        task.wait(math.random(6,14) / 10)
    end
end)

local CardShadow = Frame(LoginBackdrop, UDim2.new(0,360,0,360),
    UDim2.new(0.5,-180,0.5,-160), Pal.Shadow, 0.55)
CardShadow.ZIndex = 4
Corner(CardShadow, 18)

local LoginCard = Frame(LoginBackdrop, UDim2.new(0,340,0,340),
    UDim2.new(0.5,-170,0.5,-150), Pal.Card, 0.05)
LoginCard.ZIndex = 5
Corner(LoginCard, 14)
local cardStroke = Stroke(LoginCard, Pal.Accent, 1.5)

LoginCard.Position = UDim2.new(0.5,-170,0.5,-100)
LoginCard.BackgroundTransparency = 1
CardShadow.Position = UDim2.new(0.5,-180,0.5,-110)
CardShadow.BackgroundTransparency = 1

task.spawn(function()
    task.wait(0.05)
    TweenService:Create(LoginCard, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5,-170,0.5,-150),
        BackgroundTransparency = 0.05,
    }):Play()
    TweenService:Create(CardShadow, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5,-180,0.5,-160),
        BackgroundTransparency = 0.55,
    }):Play()
end)

local LogoBtn = Label(LoginCard, "V", UDim2.new(0,0,0,18), UDim2.new(1,0,0,56), Pal.AccentAlt, 40, Enum.TextXAlignment.Center)
LogoBtn.Font = Enum.Font.GothamBold
LogoBtn.ZIndex = 6

local TitleLabel = BoldLabel(LoginCard, "VelsHub v3.1", UDim2.new(0,0,0,80), UDim2.new(1,0,0,26), Pal.Text, 20, Enum.TextXAlignment.Center)
TitleLabel.ZIndex = 6
local SubLabel = Label(LoginCard, "sign in to continue", UDim2.new(0,0,0,104), UDim2.new(1,0,0,16), Pal.TextDim, 11, Enum.TextXAlignment.Center)
SubLabel.ZIndex = 6

Label(LoginCard, "Username", UDim2.new(0,20,0,132), UDim2.new(1,-40,0,14), Pal.TextDim, 10).ZIndex = 6
local LoginUserBox = TextBox(LoginCard, "username", UDim2.new(1,-40,0,34))
LoginUserBox.Position = UDim2.new(0,20,0,148)
LoginUserBox.ZIndex = 6

Label(LoginCard, "Password", UDim2.new(0,20,0,190), UDim2.new(1,-40,0,14), Pal.TextDim, 10).ZIndex = 6
local LoginPassBox = TextBox(LoginCard, "password", UDim2.new(1,-40,0,34))
LoginPassBox.Position = UDim2.new(0,20,0,206)
LoginPassBox.ZIndex = 6

local LoginStatus = Label(LoginCard, "", UDim2.new(0,20,0,248), UDim2.new(1,-40,0,16), Pal.Error, 11, Enum.TextXAlignment.Center)
LoginStatus.ZIndex = 6

local HubLoader

local LoginBtn = Button(LoginCard, "Login", UDim2.new(1,-40,0,36), function()
    LoginStatus.TextColor3 = Pal.TextDim
    LoginStatus.Text = "checking..."
    task.spawn(function()
        local ok, msg = SupabaseLogin(LoginUserBox.Text, LoginPassBox.Text)
        LoginStatus.TextColor3 = ok and Pal.Success or Pal.Error
        LoginStatus.Text = (ok and "[OK] " or "[X] ") .. msg
        if ok then
            task.wait(0.4)
            TweenService:Create(LoginCard, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 0.5,
            }):Play()
            TweenService:Create(LoginBackdrop, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
            }):Play()
            task.wait(0.4)
            LoginGui:Destroy()
            if HubLoader then HubLoader() end
        end
    end)
end)
LoginBtn.Position = UDim2.new(0,20,0,272)
LoginBtn.ZIndex = 6

local RegisterBtn = Button(LoginCard, "Register", UDim2.new(1,-40,0,26), function()
    LoginStatus.TextColor3 = Pal.TextDim
    LoginStatus.Text = "creating..."
    task.spawn(function()
        local ok, msg = SupabaseRegister(LoginUserBox.Text, LoginPassBox.Text)
        LoginStatus.TextColor3 = ok and Pal.Success or Pal.Error
        LoginStatus.Text = (ok and "[OK] " or "[X] ") .. msg
    end)
end)
RegisterBtn.Position = UDim2.new(0,20,0,310)
RegisterBtn.ZIndex = 6
RegisterBtn.BackgroundColor3 = Pal.CardActive

-- ================================================
-- HUB
-- ================================================

HubLoader = function()
    if not CurrentUser then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "VelsHub"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent         = CoreGui

    -- main window
    local WIN_W, WIN_H = 780, 500

    local Shadow = Frame(ScreenGui, UDim2.new(0,WIN_W+12,0,WIN_H+12),
        UDim2.new(0.5,-(WIN_W+12)/2, 0.5,-(WIN_H+12)/2), Pal.Shadow, 0.35)
    Corner(Shadow, 16)
    Shadow.ZIndex = 0

    local Main = Frame(ScreenGui, UDim2.new(0,WIN_W,0,WIN_H),
        UDim2.new(0.5,-WIN_W/2, 0.5,-WIN_H/2), Pal.Window)
    Corner(Main, 14)
    Stroke(Main, Pal.Border, 1, 0.3)
    Main.ZIndex = 1

    local TitleBar = Frame(Main, UDim2.new(1,0,0,40), nil, Pal.TopBar, 0.3)
    Corner(TitleBar, 14)
    Frame(TitleBar, UDim2.new(1,0,0,14), UDim2.new(0,0,1,-14), Pal.TopBar, 0.3)

    do
        local al = Frame(TitleBar, UDim2.new(1,0,0,2), UDim2.new(0,0,1,-2), Pal.Accent)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Pal.Accent),
            ColorSequenceKeypoint.new(0.5, Pal.AccentAlt),
            ColorSequenceKeypoint.new(1, Pal.Accent),
        })
        g.Parent = al
    end

    BoldLabel(TitleBar, "VelsHub", UDim2.new(0,16,0,0), UDim2.new(0,100,1,0), Pal.Text, 14)
    Label(TitleBar, "v3.1", UDim2.new(0,80,0,0), UDim2.new(0,40,1,0), Pal.TextMute, 10)
    Label(TitleBar, "[K] toggle", UDim2.new(1,-140,0,0), UDim2.new(0,80,1,0), Pal.TextMute, 10, Enum.TextXAlignment.Center)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,28,0,28)
    MinBtn.Position = UDim2.new(1,-68,0.5,-14)
    MinBtn.BackgroundColor3 = Pal.Card
    MinBtn.TextColor3 = Pal.TextDim
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.Text = "-"
    MinBtn.BorderSizePixel = 0
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = TitleBar
    Corner(MinBtn, 6)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,28,0,28)
    CloseBtn.Position = UDim2.new(1,-36,0.5,-14)
    CloseBtn.BackgroundColor3 = Pal.Card
    CloseBtn.TextColor3 = Pal.TextDim
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Text = "x"
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TitleBar
    Corner(CloseBtn, 6)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    do
        local dragging, ds, sp, shs
        TitleBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; ds = i.Position; sp = Main.Position; shs = Shadow.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - ds
                Main.Position   = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
                Shadow.Position = UDim2.new(shs.X.Scale, shs.X.Offset + d.X, shs.Y.Scale, shs.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    -- ================================================
    -- USER INFO PANEL (right side)
    -- ================================================

    local PanelW = 180
    local InfoPanel = Frame(Main,
        UDim2.new(0, PanelW, 1, -60),
        UDim2.new(1, -PanelW - 10, 0, 40),
        Pal.Sidebar, 0.2)
    Corner(InfoPanel, 10)
    Pad(InfoPanel, 12, 12, 12, 12)

    local infoTitle = BoldLabel(InfoPanel, "USER INFO", UDim2.new(0,0,0,0), UDim2.new(1,0,0,16), Pal.Accent, 11)
    Frame(InfoPanel, UDim2.new(1,0,0,1), UDim2.new(0,0,0,22), Pal.BorderSoft, 0.3)

    local function InfoRow(y, key, val, valColor)
        Label(InfoPanel, key, UDim2.new(0,0,0,y), UDim2.new(1,0,0,14), Pal.TextMute, 10)
        local v = BoldLabel(InfoPanel, val, UDim2.new(0,0,0,y+14), UDim2.new(1,0,0,16), valColor or Pal.Text, 11)
        v.TextTruncate = Enum.TextTruncate.AtEnd
        return v
    end

    InfoRow(32, "Username", CurrentUser.username, Pal.Text)
    InfoRow(70, "License", CurrentUser.isAdmin and "ADMIN" or "MEMBER", CurrentUser.isAdmin and Pal.Gold or Pal.Success)
    InfoRow(108, "Executor", ExecutorName, Pal.Text)
    InfoRow(146, "Exec Level", ExecutorLevel, ExecutorLevel == "High" and Pal.Success or Pal.TextDim)

    -- status indicator
    local statusDot = Frame(InfoPanel, UDim2.new(0,8,0,8), UDim2.new(0,0,0,190), Pal.Success)
    Corner(statusDot, 4)
    Label(InfoPanel, "online", UDim2.new(0,14,0,187), UDim2.new(1,-14,0,14), Pal.TextDim, 10)

    -- logout
    local LogoutBtn = Instance.new("TextButton")
    LogoutBtn.Size = UDim2.new(1,0,0,28)
    LogoutBtn.Position = UDim2.new(0,0,1,-28)
    LogoutBtn.BackgroundColor3 = Pal.Card
    LogoutBtn.TextColor3 = Pal.TextDim
    LogoutBtn.Font = Enum.Font.GothamBold
    LogoutBtn.TextSize = 11
    LogoutBtn.Text = "Logout"
    LogoutBtn.BorderSizePixel = 0
    LogoutBtn.AutoButtonColor = false
    LogoutBtn.Parent = InfoPanel
    Corner(LogoutBtn, 6)
    LogoutBtn.MouseEnter:Connect(function()
        TweenService:Create(LogoutBtn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Error, TextColor3 = Color3.fromRGB(255,255,255) }):Play()
    end)
    LogoutBtn.MouseLeave:Connect(function()
        TweenService:Create(LogoutBtn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Card, TextColor3 = Pal.TextDim }):Play()
    end)
    LogoutBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        CurrentUser = nil
    end)

    -- ================================================
    -- SIDEBAR
    -- ================================================

    local SidebarW = 140
    local Sidebar = Frame(Main, UDim2.new(0,SidebarW, 1,-60), UDim2.new(0,0,0,40), Pal.Sidebar, 0.2)
    Corner(Sidebar, 10)
    Pad(Sidebar, 10, 8, 10, 8)
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0,4)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sl.Parent = Sidebar

    local ContentX = SidebarW + 20
    local ContentW = WIN_W - ContentX - PanelW - 30
    local Content = Frame(Main, UDim2.new(0,ContentW, 1,-60), UDim2.new(0,ContentX,0,40), Pal.Window, 1)

    local Pages, TabBtns = {}, {}

    local function MakePage(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1,0,1,0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = Pal.Accent
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = Content
        Pad(scroll, 4, 8, 12, 0)
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0,10)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Parent = scroll
        Pages[name] = scroll
    end

    local function SwitchTab(name)
        for n,p in pairs(Pages) do p.Visible = (n == name) end
        for n,b in pairs(TabBtns) do
            local a = (n == name)
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = a and Pal.CardActive or Pal.Card
            }):Play()
            local lbl = b:FindFirstChildOfClass("TextLabel")
            if lbl then
                TweenService:Create(lbl, TweenInfo.new(0.15), {
                    TextColor3 = a and Pal.Text or Pal.TextDim
                }):Play()
            end
            local bar = b:FindFirstChild("__bar")
            if bar then bar.Visible = a end
        end
    end

    local tabList = {"Visual","Combat","Misc","World"}
    if CurrentUser.isAdmin then
        table.insert(tabList, "Admin")
    end    for _, name in ipairs(tabList) do
        MakePage(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,32)
        btn.BackgroundColor3 = Pal.Card
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = Sidebar
        Corner(btn, 8)
        local bar = Frame(btn, UDim2.new(0,3,0,16), UDim2.new(0,4,0.5,-8), Pal.Accent)
        bar.Name = "__bar"
        bar.Visible = false
        Corner(bar, 2)
        BoldLabel(btn, name, UDim2.new(0,16,0,0), UDim2.new(1,-16,1,0), Pal.TextDim, 12)
        TabBtns[name] = btn
        btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    end

    -- widgets
    local function Section(parent, title)
        local s = Frame(parent, UDim2.new(1,0,0,0), nil, Pal.Card)
        Corner(s, 10)
        Stroke(s, Pal.BorderSoft, 1, 0.3)
        s.AutomaticSize = Enum.AutomaticSize.Y
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0,6)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Parent = s
        Pad(s, 10, 12, 10, 12)

        local head = Frame(s, UDim2.new(1,0,0,20), nil, Color3.fromRGB(0,0,0), 1)
        head.LayoutOrder = 0
        BoldLabel(head, string.upper(title), UDim2.new(0,0,0,0), UDim2.new(1,-20,1,0), Pal.Accent, 11)

        local arrow = Label(head, "v", UDim2.new(1,-14,0,0), UDim2.new(0,14,1,0), Pal.TextMute, 12, Enum.TextXAlignment.Center)
        arrow.Font = Enum.Font.GothamBold

        local holder = Frame(s, UDim2.new(1,0,0,0), nil, Color3.fromRGB(0,0,0), 1)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.LayoutOrder = 1
        local il = Instance.new("UIListLayout")
        il.Padding = UDim.new(0,6)
        il.SortOrder = Enum.SortOrder.LayoutOrder
        il.Parent = holder

        local open = true
        local hb = Instance.new("TextButton")
        hb.Size = UDim2.new(1,0,1,0)
        hb.BackgroundTransparency = 1
        hb.Text = ""
        hb.Parent = head
        hb.MouseButton1Click:Connect(function()
            open = not open
            holder.Visible = open
            arrow.Text = open and "v" or ">"
        end)

        return holder
    end

    local function Toggle(parent, label, default, cb)
        local row = Frame(parent, UDim2.new(1,0,0,30), nil, Color3.fromRGB(0,0,0), 1)
        Label(row, label, UDim2.new(0,0,0,0), UDim2.new(0.75,0,1,0), Pal.Text, 12)
        local track = Frame(row, UDim2.new(0,40,0,20), UDim2.new(1,-42,0.5,-10), default and Pal.AccentSoft or Pal.ToggleOff)
        Corner(track, 10)
        local knob = Frame(track, UDim2.new(0,14,0,14),
            default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            Color3.fromRGB(255,255,255))
        Corner(knob, 7)
        local state = default
        local hb = Instance.new("TextButton")
        hb.Size = UDim2.new(1,0,1,0)
        hb.BackgroundTransparency = 1
        hb.Text = ""
        hb.Parent = track
        hb.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = state and Pal.AccentSoft or Pal.ToggleOff }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) }):Play()
            if cb then cb(state) end
        end)
        return row
    end

    local function Slider(parent, label, min, max, default, cb)
        local w = Frame(parent, UDim2.new(1,0,0,46), nil, Color3.fromRGB(0,0,0), 1)
        local lbl = Label(w, label .. ": " .. default, UDim2.new(0,0,0,0), UDim2.new(1,0,0,16), Pal.TextDim, 11)
        local track = Frame(w, UDim2.new(1,0,0,6), UDim2.new(0,0,0,24), Pal.ToggleOff)
        Corner(track, 3)
        local fill = Frame(track, UDim2.new((default-min)/(max-min),0,1,0), nil, Pal.Accent)
        Corner(fill, 3)
        local knob = Frame(track, UDim2.new(0,12,0,12),
            UDim2.new((default-min)/(max-min),-6,0.5,-6), Color3.fromRGB(255,255,255))
        Corner(knob, 6)
        Stroke(knob, Pal.Accent, 1)
        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max-min) * rel)
                fill.Size = UDim2.new(rel,0,1,0)
                knob.Position = UDim2.new(rel,-6,0.5,-6)
                lbl.Text = label .. ": " .. v
                if cb then cb(v) end
            end
        end)
        return w
    end

    local function Dropdown(parent, label, options, default, cb)
        local w = Frame(parent, UDim2.new(1,0,0,56), nil, Color3.fromRGB(0,0,0), 1)
        Label(w, label, UDim2.new(0,0,0,0), UDim2.new(1,0,0,16), Pal.TextDim, 11)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,32)
        btn.Position = UDim2.new(0,0,0,20)
        btn.BackgroundColor3 = Pal.Input
        btn.TextColor3 = Pal.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Text = default
        btn.BorderSizePixel = 0
        btn.Parent = w
        Corner(btn, 6)
        Stroke(btn, Pal.BorderSoft, 1, 0.3)
        local idx = 1
        for i,v in ipairs(options) do if v == default then idx = i end end
        btn.MouseButton1Click:Connect(function()
            idx = idx % #options + 1
            btn.Text = options[idx]
            if cb then cb(options[idx]) end
        end)
        return w
    end

    -- K toggle
    local GuiVisible = true
    local function SetGuiVisible(state)
        GuiVisible = state
        if state then
            Main.Visible = true
            Shadow.Visible = true
            Main.BackgroundTransparency = 0
            Shadow.BackgroundTransparency = 0.35
            local cm, cs = Main.Position, Shadow.Position
            Main.Position = UDim2.new(cm.X.Scale, cm.X.Offset, cm.Y.Scale, cm.Y.Offset + 20)
            Shadow.Position = UDim2.new(cs.X.Scale, cs.X.Offset, cs.Y.Scale, cs.Y.Offset + 20)
            TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = cm }):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = cs }):Play()
        else
            local fm = TweenService:Create(Main, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
            local fs = TweenService:Create(Shadow, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
            fm:Play(); fs:Play()
            fm.Completed:Connect(function()
                if not GuiVisible then
                    Main.Visible = false
                    Shadow.Visible = false
                end
            end)
        end
    end
    local toggleDb = false
    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if i.KeyCode ~= Enum.KeyCode.K then return end
        if toggleDb then return end
        toggleDb = true
        task.delay(0.2, function() toggleDb = false end)
        SetGuiVisible(not GuiVisible)
    end)

    -- ================================================
    -- VISUAL
    -- ================================================

    local VP = Pages["Visual"]
    local espSec = Section(VP, "ESP")
    Toggle(espSec, "ESP Master",       CONFIG.ESP.Enabled,         function(v) CONFIG.ESP.Enabled = v end)
    Toggle(espSec, "Box",              CONFIG.ESP.Box,             function(v) CONFIG.ESP.Box = v end)
    Toggle(espSec, "Name",             CONFIG.ESP.Name,            function(v) CONFIG.ESP.Name = v end)
    Toggle(espSec, "Skeleton",         CONFIG.ESP.Skeleton,        function(v) CONFIG.ESP.Skeleton = v end)
    Toggle(espSec, "Health Bar",       CONFIG.ESP.HealthBar,       function(v) CONFIG.ESP.HealthBar = v end)
    Toggle(espSec, "Highlight (stealth)", CONFIG.ESP.Highlight,    function(v) CONFIG.ESP.Highlight = v end)
    Toggle(espSec, "Wall Penetration", CONFIG.ESP.WallPenetration, function(v) CONFIG.ESP.WallPenetration = v end)
    Toggle(espSec, "Team Check",       CONFIG.ESP.TeamCheck,       function(v) CONFIG.ESP.TeamCheck = v end)

    local hlSec = Section(VP, "Highlight Mode")
    Dropdown(hlSec, "Mode", {"Outline", "Fill", "Both"}, CONFIG.ESP.HighlightMode,
        function(v) CONFIG.ESP.HighlightMode = v end)

    -- ================================================
    -- COMBAT
    -- ================================================

    local CP = Pages["Combat"]

    local methodSec = Section(CP, "Aimbot Method")
    Label(methodSec, "High = silent aim (hook). Low = camera lock.",
        UDim2.new(0,0,0,0), UDim2.new(1,0,0,28), Pal.TextMute, 10).TextWrapped = true
    Dropdown(methodSec, "Method", {"Camera", "Silent"}, CONFIG.Aimbot.Method, function(v)
        CONFIG.Aimbot.Method = v
        if v == "Silent" and ExecutorLevel ~= "High" then
            CONFIG.Aimbot.Method = "Camera"
        end
    end)

    local aimSec = Section(CP, "Aimbot")
    Toggle(aimSec, "Aimbot Master", CONFIG.Aimbot.Enabled, function(v) CONFIG.Aimbot.Enabled = v end)
    Toggle(aimSec, "Toggle Mode (RMB)", CONFIG.Aimbot.Toggle, function(v) CONFIG.Aimbot.Toggle = v end)
    Toggle(aimSec, "Wall Check",    CONFIG.Aimbot.WallCheck, function(v) CONFIG.Aimbot.WallCheck = v end)
    Toggle(aimSec, "Team Check",    CONFIG.Aimbot.TeamCheck, function(v) CONFIG.Aimbot.TeamCheck = v end)
    Toggle(aimSec, "Offset to Move", CONFIG.Aimbot.OffsetToMove, function(v) CONFIG.Aimbot.OffsetToMove = v end)

    local fovSec = Section(CP, "FOV")
    Toggle(fovSec, "Show FOV Circle", CONFIG.Aimbot.FOVEnabled, function(v) CONFIG.Aimbot.FOVEnabled = v end)
    Slider(fovSec, "FOV Size", 10, 500, CONFIG.Aimbot.FOV, function(v) CONFIG.Aimbot.FOV = v end)

    local smoothSec = Section(CP, "Smoothness & Offset")
    Slider(smoothSec, "Smoothness x100", 0, 50, math.floor(CONFIG.Aimbot.Smoothness * 100),
        function(v) CONFIG.Aimbot.Smoothness = v / 100 end)
    Slider(smoothSec, "Offset Amount", 1, 30, CONFIG.Aimbot.OffsetAmount, function(v) CONFIG.Aimbot.OffsetAmount = v end)

    local silentSec = Section(CP, "Silent Aim Tuning")
    Slider(silentSec, "Chance %", 1, 100, CONFIG.Aimbot.SilentChance, function(v) CONFIG.Aimbot.SilentChance = v end)
    Slider(silentSec, "Prediction ms", 0, 500, math.floor(CONFIG.Aimbot.Prediction * 1000),
        function(v) CONFIG.Aimbot.Prediction = v / 1000 end)
    Toggle(silentSec, "Gravity Comp", CONFIG.Aimbot.GravityComp, function(v) CONFIG.Aimbot.GravityComp = v end)

    -- ================================================
    -- MISC
    -- ================================================

    local MP = Pages["Misc"]
    local miscSec = Section(MP, "Visual FX")
    Toggle(miscSec, "Rainbow ESP", CONFIG.Misc.RainbowESP, function(v) CONFIG.Misc.RainbowESP = v end)

    -- ================================================
    -- WORLD
    -- ================================================

    local WP = Pages["World"]
    local lightSec = Section(WP, "Lighting")
    Toggle(lightSec, "Fullbright", CONFIG.World.Fullbright, function(v)
        CONFIG.World.Fullbright = v
        if v then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255,255,255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(127,127,127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        end
    end)
    Toggle(lightSec, "No Fog", CONFIG.World.NoFog, function(v)
        CONFIG.World.NoFog = v
        Lighting.FogEnd = v and 100000 or 1000
        Lighting.FogStart = v and 100000 or 0
    end)

    -- ================================================
    -- ADMIN (admin only)
    -- ================================================

    if CurrentUser.isAdmin and Pages["Admin"] then
        local AP = Pages["Admin"]
        local adminSec = Section(AP, "User Manager")

        Label(adminSec, "Target Username", UDim2.new(0,0,0,0), UDim2.new(1,0,0,14), Pal.TextDim, 10)
        local targetBox = TextBox(adminSec, "username", UDim2.new(1,0,0,32))

        local statusLbl = Label(adminSec, "", UDim2.new(0,0,0,0), UDim2.new(1,0,0,14), Pal.TextMute, 10, Enum.TextXAlignment.Center)

        local btnRow = Frame(adminSec, UDim2.new(1,0,0,32), nil, Color3.fromRGB(0,0,0), 1)
        local function SmallBtn(text, xScale, cb)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.32, 0, 1, 0)
            b.Position = UDim2.new(xScale, 0, 0, 0)
            b.BackgroundColor3 = Pal.AccentSoft
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 11
            b.Text = text
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Parent = btnRow
            Corner(b, 6)
            b.MouseEnter:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Accent }):Play()
            end)
            b.MouseLeave:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = Pal.AccentSoft }):Play()
            end)
            b.MouseButton1Click:Connect(cb)
            return b
        end
        SmallBtn("Promote", 0.0, function()
            local u = targetBox.Text
            if u == "" then statusLbl.Text = "enter username"; return end
            local ok, msg = SupabaseSetAdmin(u, true)
            statusLbl.Text = (ok and "promoted: " or "error: ") .. tostring(msg)
            statusLbl.TextColor3 = ok and Pal.Success or Pal.Error
        end)
        SmallBtn("Demote", 0.34, function()
            local u = targetBox.Text
            if u == "" then statusLbl.Text = "enter username"; return end
            local ok, msg = SupabaseSetAdmin(u, false)
            statusLbl.Text = (ok and "demoted: " or "error: ") .. tostring(msg)
            statusLbl.TextColor3 = ok and Pal.Success or Pal.Error
        end)
        SmallBtn("Refresh", 0.68, function()
            local ok, data = SupabaseListUsers()
            if not ok then
                statusLbl.Text = "error: " .. tostring(data)
                statusLbl.TextColor3 = Pal.Error
                return
            end
            local lines = {}
            for i, u in ipairs(data) do
                lines[i] = string.format("%s%s", u.username, u.is_admin and " [ADMIN]" or "")
            end
            statusLbl.Text = table.concat(lines, "  |  ")
            statusLbl.TextColor3 = Pal.Text
        end)

        Label(adminSec, "User List", UDim2.new(0,0,0,0), UDim2.new(1,0,0,14), Pal.TextDim, 10)
        local listLbl = Label(adminSec, "(click refresh)", UDim2.new(0,0,0,0), UDim2.new(1,0,0,80), Pal.TextDim, 10)
        listLbl.TextWrapped = true
        listLbl.TextYAlignment = Enum.TextYAlignment.Top

        local btnRow2 = Frame(adminSec, UDim2.new(1,0,0,32), nil, Color3.fromRGB(0,0,0), 1)
        local refreshBig = Instance.new("TextButton")
        refreshBig.Size = UDim2.new(1,0,1,0)
        refreshBig.BackgroundColor3 = Pal.AccentSoft
        refreshBig.TextColor3 = Color3.fromRGB(255,255,255)
        refreshBig.Font = Enum.Font.GothamBold
        refreshBig.TextSize = 11
        refreshBig.Text = "Refresh User List"
        refreshBig.BorderSizePixel = 0
        refreshBig.AutoButtonColor = false
        refreshBig.Parent = btnRow2
        Corner(refreshBig, 6)
        refreshBig.MouseButton1Click:Connect(function()
            local ok, data = SupabaseListUsers()
            if not ok then
                listLbl.Text = "error: " .. tostring(data)
                return
            end
            local lines = {}
            for _, u in ipairs(data) do
                local tier = u.is_admin and " [ADMIN]" or " [MEMBER]"
                lines[#lines+1] = string.format("- %s%s", u.username, tier)
            end
            listLbl.Text = table.concat(lines, "\n")
        end)
    end

    -- ================================================
    -- ESP
    -- ================================================

    local ESPCache = {}
    local HighlightCache = {}

    local SkeletonBones = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }

    local function NewDraw(t, props)
        local d = Drawing.new(t)
        for k,v in pairs(props) do d[k] = v end
        return d
    end

    local function MakeESPObjects()
        return {
            Box        = NewDraw("Square", {Visible=false, Filled=false, Thickness=1.5, Color=CONFIG.ESP.BoxColor}),
            BoxOutline = NewDraw("Square", {Visible=false, Filled=false, Thickness=3, Color=Color3.fromRGB(0,0,0)}),
            HealthBG   = NewDraw("Square", {Visible=false, Filled=true, Thickness=1, Color=Color3.fromRGB(0,0,0)}),
            Health     = NewDraw("Square", {Visible=false, Filled=true, Thickness=1, Color=Color3.fromRGB(50,220,100)}),
            Name       = NewDraw("Text",   {Visible=false, Size=13, Center=true, Outline=true, Color=CONFIG.ESP.NameColor, Font=Drawing.Fonts.Plex}),
            Bones      = {},
        }
    end

    local function DestroyESP(obj)
        for _, b in ipairs(obj.Bones) do pcall(function() b:Remove() end) end
        for k, d in pairs(obj) do
            if k ~= "Bones" then pcall(function() d:Remove() end) end
        end
    end

    local function GetScreenBounds(char)
        local parts = {"Head","UpperTorso","LowerTorso","LeftHand","RightHand","LeftFoot","RightFoot"}
        local mnx, mny = math.huge, math.huge
        local mxx, mxy = -math.huge, -math.huge
        local found = false
        for _, n in ipairs(parts) do
            local p = char:FindFirstChild(n)
            if p then
                local s, on = Camera:WorldToViewportPoint(p.Position)
                if on and s.Z > 0 then
                    found = true
                    if s.X < mnx then mnx = s.X end
                    if s.Y < mny then mny = s.Y end
                    if s.X > mxx then mxx = s.X end
                    if s.Y > mxy then mxy = s.Y end
                end
            end
        end
        return found, mnx, mny, mxx, mxy
    end

    -- Highlight: parent di ScreenGui, adornee di character
    local function GetHighlight(player)
        local hl = HighlightCache[player]
        if hl and hl.Parent then return hl end
        hl = Instance.new("Highlight")
        hl.Name = "__VelsHL"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- wall pen
        hl.Parent = ScreenGui
        HighlightCache[player] = hl
        return hl
    end
    local function RemoveHighlight(player)
        local hl = HighlightCache[player]
        if hl then hl:Destroy(); HighlightCache[player] = nil end
    end

    local function IsESPTeammate(p)
        if not CONFIG.ESP.TeamCheck then return false end
        return p.Team and p.Team == LocalPlayer.Team
    end

    local function IsVisible(char, targetPos)
        if not char then return false end
        local dir = (targetPos - Camera.CFrame.Position)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { char, LocalPlayer.Character or {} }
        local hit = workspace:Raycast(Camera.CFrame.Position, dir, params)
        return hit == nil
    end

    local RainbowHue = 0
    local function Rainbow()
        RainbowHue = (RainbowHue + 0.003) % 1
        return Color3.fromHSV(RainbowHue, 0.8, 1)
    end

    if HasDrawing then
        RunService.RenderStepped:Connect(function()
            if not CurrentUser then return end
            local rb = Rainbow()

            for _, player in ipairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                if not ESPCache[player] then ESPCache[player] = MakeESPObjects() end

                local obj = ESPCache[player]
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local alive = hum and hum.Health > 0
                local show = CONFIG.ESP.Enabled and alive and not IsESPTeammate(player)

                if not show then
                    obj.Box.Visible = false; obj.BoxOutline.Visible = false
                    obj.Name.Visible = false; obj.Health.Visible = false; obj.HealthBG.Visible = false
                    for _, b in ipairs(obj.Bones) do b.Visible = false end
                    RemoveHighlight(player)
                    continue
                end

                -- highlight (stealth, parent di ScreenGui)
                if CONFIG.ESP.Highlight then
                    local hl = GetHighlight(player)
                    hl.Adornee = char
                    local c = CONFIG.Misc.RainbowESP and rb or CONFIG.ESP.HighlightColor
                    hl.FillColor = c
                    hl.OutlineColor = c
                    local m = CONFIG.ESP.HighlightMode
                    hl.FillTransparency = (m == "Outline") and 1 or 0.5
                    hl.OutlineTransparency = (m == "Fill") and 1 or 0
                    hl.DepthMode = CONFIG.ESP.WallPenetration
                        and Enum.HighlightDepthMode.AlwaysOnTop
                        or Enum.HighlightDepthMode.Occluded
                else
                    RemoveHighlight(player)
                end

                local on, mnx, mny, mxx, mxy = GetScreenBounds(char)
                if not on then
                    obj.Box.Visible = false; obj.BoxOutline.Visible = false
                    obj.Name.Visible = false; obj.Health.Visible = false; obj.HealthBG.Visible = false
                    for _, b in ipairs(obj.Bones) do b.Visible = false end
                    continue
                end

                local bx, by = mnx - 4, mny - 4
                local bw = math.max(mxx - mnx + 8, 1)
                local bh = math.max(mxy - mny + 8, 1)

                local targetPos = char:FindFirstChild("Head") and char.Head.Position or Vector3.zero
                local visible = IsVisible(char, targetPos)
                local useWallPen = CONFIG.ESP.WallPenetration

                if not useWallPen and not visible then
                    obj.Box.Visible = false; obj.BoxOutline.Visible = false
                    obj.Name.Visible = false; obj.Health.Visible = false; obj.HealthBG.Visible = false
                    for _, b in ipairs(obj.Bones) do b.Visible = false end
                    continue
                end

                local boxColor = CONFIG.ESP.BoxColor
                local nameColor = CONFIG.ESP.NameColor
                local skelColor = CONFIG.ESP.SkeletonColor
                if not visible then boxColor = CONFIG.ESP.WallPenColor end
                if CONFIG.Misc.RainbowESP then
                    boxColor = rb; nameColor = rb; skelColor = rb
                end

                obj.BoxOutline.Visible  = CONFIG.ESP.Box
                obj.BoxOutline.Position = Vector2.new(bx, by)
                obj.BoxOutline.Size     = Vector2.new(bw, bh)
                obj.Box.Visible         = CONFIG.ESP.Box
                obj.Box.Position        = Vector2.new(bx, by)
                obj.Box.Size            = Vector2.new(bw, bh)
                obj.Box.Color           = boxColor

                local hpRat = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                local barH = bh * hpRat

                obj.HealthBG.Visible  = CONFIG.ESP.HealthBar
                obj.HealthBG.Position = Vector2.new(bx - 7, by)
                obj.HealthBG.Size     = Vector2.new(4, bh)
                obj.Health.Visible    = CONFIG.ESP.HealthBar
                obj.Health.Position   = Vector2.new(bx - 7, by + (bh - barH))
                obj.Health.Size       = Vector2.new(4, barH)
                obj.Health.Color      = Color3.fromHSV(hpRat * 0.33, 1, 1)

                obj.Name.Visible  = CONFIG.ESP.Name
                obj.Name.Position = Vector2.new(bx + bw / 2, by - 16)
                obj.Name.Text     = player.DisplayName
                obj.Name.Color    = nameColor

                if CONFIG.ESP.Skeleton then
                    local bi = 1
                    for _, bone in ipairs(SkeletonBones) do
                        local p0 = char:FindFirstChild(bone[1])
                        local p1 = char:FindFirstChild(bone[2])
                        if p0 and p1 then
                            local s0, on0 = Camera:WorldToViewportPoint(p0.Position)
                            local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
                            if not obj.Bones[bi] then
                                obj.Bones[bi] = NewDraw("Line", { Thickness=1, Color=skelColor })
                            end
                            local line = obj.Bones[bi]
                            line.Visible = on0 and on1 and s0.Z > 0 and s1.Z > 0
                            line.From = Vector2.new(s0.X, s0.Y)
                            line.To   = Vector2.new(s1.X, s1.Y)
                            line.Color = skelColor
                            bi += 1
                        end
                    end
                    for i = bi, #obj.Bones do obj.Bones[i].Visible = false end
                else
                    for _, b in ipairs(obj.Bones) do b.Visible = false end
                end
            end
        end)

        Players.PlayerRemoving:Connect(function(p)
            if ESPCache[p] then DestroyESP(ESPCache[p]); ESPCache[p] = nil end
            RemoveHighlight(p)
        end)
    end

    -- ================================================
    -- AIMBOT
    -- ================================================

    local AimState = {
        Running = false,
        Locked  = nil,
        Anim    = nil,
        OrigSens = UserInputService.MouseDeltaSensitivity,
        SilentTarget = nil,
    }

    local FOVCircle, FOVOutline, Tracer

    if HasDrawing then
        FOVCircle = NewDraw("Circle", { Visible=false, NumSides=60, Filled=CONFIG.Aimbot.FOVFilled,
            Thickness=CONFIG.Aimbot.FOVThickness, Transparency=CONFIG.Aimbot.FOVTransparency, Color=CONFIG.Aimbot.FOVColor })
        FOVOutline = NewDraw("Circle", { Visible=false, NumSides=60, Filled=false,
            Thickness=CONFIG.Aimbot.FOVThickness+1, Transparency=CONFIG.Aimbot.FOVTransparency, Color=Color3.fromRGB(0,0,0) })
        Tracer = NewDraw("Line", { Visible=false, Thickness=CONFIG.Aimbot.TracerThickness,
            Transparency=0.3, Color=CONFIG.Aimbot.TracerColor })
    end

    local function GetMouseLoc() return UserInputService:GetMouseLocation() end

    local function IsAlive(char)
        if not char then return false end
        local h = char:FindFirstChildOfClass("Humanoid")
        return h and h.Health > 0
    end

    local function IsTeam(p)
        if not CONFIG.Aimbot.TeamCheck then return false end
        return p.Team and p.Team == LocalPlayer.Team
    end

    local function AimWallCheck(char, pos)
        if not CONFIG.Aimbot.WallCheck then return true end
        local part = char:FindFirstChild(CONFIG.Aimbot.LockPart)
        if not part then return false end
        local bl = {}
        if LocalPlayer.Character then
            for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do bl[#bl+1] = v end
        end
        for _, v in ipairs(char:GetDescendants()) do bl[#bl+1] = v end
        local obs = Camera:GetPartsObscuringTarget({ pos or part.Position }, bl)
        return #obs == 0
    end

    local function PredictPos(part)
        local vel = part.AssemblyLinearVelocity
        local t = CONFIG.Aimbot.Prediction
        local pos = part.Position + vel * t
        if CONFIG.Aimbot.GravityComp then
            pos = pos - Vector3.new(0, 0.5 * workspace.Gravity * t * t, 0)
        end
        return pos
    end

    local function GetClosestTarget()
        local closest, dist = nil, CONFIG.Aimbot.FOVEnabled and CONFIG.Aimbot.FOV or math.huge
        local m = GetMouseLoc()
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if IsTeam(p) then continue end
            local c = p.Character
            if not c then continue end
            if CONFIG.Aimbot.AliveCheck and not IsAlive(c) then continue end
            local part = c:FindFirstChild(CONFIG.Aimbot.LockPart)
            if not part then continue end
            local pos = PredictPos(part)
            local screen, on = Camera:WorldToViewportPoint(pos)
            if not on then continue end
            local sv = Vector2.new(screen.X, screen.Y)
            local d = (m - sv).Magnitude
            if d < dist and AimWallCheck(c, pos) then
                dist = d
                closest = { player = p, char = c, part = part, screenPos = sv, worldPos = pos }
            end
        end
        return closest
    end

    local function CancelLock()
        AimState.Locked = nil
        AimState.SilentTarget = nil
        UserInputService.MouseDeltaSensitivity = AimState.OrigSens
        if AimState.Anim then AimState.Anim:Cancel(); AimState.Anim = nil end
        if HasDrawing then
            FOVCircle.Color = CONFIG.Aimbot.FOVColor
            FOVOutline.Color = Color3.fromRGB(0,0,0)
            Tracer.Visible = false
        end
    end

    local function UpdateFOVVisual(m, visible, locked)
        if not HasDrawing then return end
        FOVCircle.Position = m
        FOVCircle.Radius = CONFIG.Aimbot.FOV
        FOVCircle.Thickness = CONFIG.Aimbot.FOVThickness
        FOVCircle.Filled = CONFIG.Aimbot.FOVFilled
        FOVCircle.Visible = visible
        FOVCircle.Color = locked or CONFIG.Aimbot.FOVColor
        FOVOutline.Position = m
        FOVOutline.Radius = CONFIG.Aimbot.FOV
        FOVOutline.Thickness = CONFIG.Aimbot.FOVThickness + 1
        FOVOutline.Visible = visible
        FOVOutline.Color = locked or Color3.fromRGB(0,0,0)
    end

    local InHook = false

    if ExecutorLevel == "High" and hookmetamethod and newcclosure and getnamecallmethod then
        RunService.RenderStepped:Connect(function()
            if CONFIG.Aimbot.Method == "Silent"
                and CONFIG.Aimbot.Enabled
                and AimState.Running then
                local t = GetClosestTarget()
                AimState.SilentTarget = t and t.worldPos or nil
            else
                AimState.SilentTarget = nil
            end
        end)

        local function ShouldSilent()
            return AimState.SilentTarget ~= nil
                and CONFIG.Aimbot.Enabled
                and CONFIG.Aimbot.Method == "Silent"
                and AimState.Running
                and (math.random() * 100) <= CONFIG.Aimbot.SilentChance
        end

        pcall(function()
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
                local fromSelf = checkcaller and checkcaller()
                if not InHook and not fromSelf and self == Mouse and ShouldSilent() then
                    InHook = true
                    local ok, res = pcall(function()
                        if key == "Hit" then return CFrame.new(AimState.SilentTarget)
                        elseif key == "UnitRay" then
                            local o = Camera.CFrame.Position
                            return Ray.new(o, (AimState.SilentTarget - o).Unit)
                        end
                        return nil
                    end)
                    InHook = false
                    if ok and res ~= nil then return res end
                end
                return oldIndex(self, key)
            end))
        end)

        pcall(function()
            local oldNC
            oldNC = hookmetamethod(game, "__namecall", newcclosure(function(...)
                local method = getnamecallmethod()
                local fromSelf = checkcaller and checkcaller()
                if not InHook and not fromSelf and ShouldSilent() then
                    local args = { ... }
                    local self = args[1]

                    if self == workspace and (method == "Raycast" or method == "raycast")
                        and #args >= 3 and typeof(args[2]) == "Vector3" and typeof(args[3]) == "Vector3" then
                        InHook = true
                        local o = args[2]
                        args[3] = AimState.SilentTarget - o
                        local ok, res = pcall(oldNC, table.unpack(args))
                        InHook = false
                        if ok then return res end
                    end

                    if self == workspace and (method == "FindPartOnRay" or method == "findPartOnRay")
                        and #args >= 2 and typeof(args[2]) == "Ray" then
                        InHook = true
                        local r = args[2]
                        args[2] = Ray.new(r.Origin, AimState.SilentTarget - r.Origin)
                        local ok, res = pcall(oldNC, table.unpack(args))
                        InHook = false
                        if ok then return res end
                    end
                end
                return oldNC(...)
            end))
        end)
    end

    local function OnAimbotUpdate()
        if not CONFIG.Aimbot.Enabled then
            UpdateFOVVisual(GetMouseLoc(), false, nil)
            return
        end

        local m = GetMouseLoc()
        UpdateFOVVisual(m, CONFIG.Aimbot.FOVEnabled, nil)

        if not AimState.Running then
            CancelLock()
            return
        end

        if HasDrawing and CONFIG.Aimbot.TracerEnabled and not AimState.Locked then
            local t = GetClosestTarget()
            if t then
                Tracer.Visible = true
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Tracer.To = t.screenPos
                Tracer.Color = CONFIG.Aimbot.TracerColor
            else
                Tracer.Visible = false
            end
        else
            if HasDrawing then Tracer.Visible = false end
        end

        if CONFIG.Aimbot.Method == "Silent" and ExecutorLevel == "High" then
            return
        end

        if not AimState.Locked then
            local t = GetClosestTarget()
            if t then AimState.Locked = t.player end
        else
            local c = AimState.Locked.Character
            if not c or not IsAlive(c) or not c:FindFirstChild(CONFIG.Aimbot.LockPart) then
                CancelLock()
            end
        end

        if AimState.Locked and AimState.Locked.Character then
            local c = AimState.Locked.Character
            local part = c:FindFirstChild(CONFIG.Aimbot.LockPart)
            local hum = c:FindFirstChildOfClass("Humanoid")
            if part and hum then
                local offset = Vector3.zero
                if CONFIG.Aimbot.OffsetToMove then
                    offset = hum.MoveDirection * (math.clamp(CONFIG.Aimbot.OffsetAmount, 1, 30) / 10)
                end
                local tp = part.Position + offset

                if CONFIG.Aimbot.Smoothness > 0 then
                    if AimState.Anim then AimState.Anim:Cancel() end
                    AimState.Anim = TweenService:Create(Camera,
                        TweenInfo.new(CONFIG.Aimbot.Smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                        { CFrame = CFrame.new(Camera.CFrame.Position, tp) })
                    AimState.Anim:Play()
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, tp)
                end
                UserInputService.MouseDeltaSensitivity = 0
                UpdateFOVVisual(m, CONFIG.Aimbot.FOVEnabled, CONFIG.Aimbot.FOVLockedColor)
            else
                CancelLock()
            end
        end
    end

    RunService.RenderStepped:Connect(OnAimbotUpdate)

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        local k = CONFIG.Aimbot.TriggerKey
        if (i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == k) or i.UserInputType == k then
            if CONFIG.Aimbot.Toggle then
                AimState.Running = not AimState.Running
                if not AimState.Running then CancelLock() end
            else
                AimState.Running = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        local k = CONFIG.Aimbot.TriggerKey
        if (i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == k) or i.UserInputType == k then
            if not CONFIG.Aimbot.Toggle then
                AimState.Running = false
                CancelLock()
            end
        end
    end)

    SwitchTab("Visual")
end
