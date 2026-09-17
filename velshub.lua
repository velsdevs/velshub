-- ================================================
-- VelsHub v2.9 | Animated Login + Fluent UI + Auto-Lock Aimbot
-- ================================================
-- Changelog:
--   v2.8: auto-lock aimbot (pattern Exunys), ga pake hook
--   v2.9: toggle GUI pake K, login textbox tanpa placeholder

local Config = {
    WebhookURL = "WEBHOOK_LO_DISINI",

    ESP = {
        Enabled       = true,
        Box           = true,
        Name          = true,
        Skeleton      = true,
        Chams         = true,
        BoxColor      = Color3.fromRGB(220, 100, 180),
        NameColor     = Color3.fromRGB(255, 180, 230),
        SkeletonColor = Color3.fromRGB(180, 80, 220),
        ChamsColor    = Color3.fromRGB(160, 50, 200),
        ChamsTransparency = 0.5,
        TeamCheck     = false,
    },

    Aimbot = {
        Enabled        = true,
        TriggerKey     = Enum.UserInputType.MouseButton2,
        Toggle         = false,
        LockPart       = "Head",
        Smoothness     = 0.12,
        OffsetToMove   = true,
        OffsetAmount   = 15,

        TeamCheck      = false,
        AliveCheck     = true,
        WallCheck      = true,

        FOVEnabled     = true,
        FOV            = 180,
        FOVColor       = Color3.fromRGB(220, 100, 180),
        FOVLockedColor = Color3.fromRGB(255, 80, 120),
        FOVThickness   = 1.5,
        FOVTransparency = 0.3,
        FOVFilled      = false,

        TracerEnabled  = true,
        TracerColor    = Color3.fromRGB(220, 100, 180),
        TracerThickness = 1.5,
    },

    Misc = {
        RainbowChams = false,
        RainbowFOV   = false,
    },

    World = {
        Fullbright = false,
        NoFog      = false,
    },
}

local Theme = {
    BG          = Color3.fromRGB(18, 12, 28),
    Panel       = Color3.fromRGB(28, 18, 42),
    TabBar      = Color3.fromRGB(22, 14, 35),
    TabActive   = Color3.fromRGB(140, 50, 180),
    TabInactive = Color3.fromRGB(38, 24, 58),
    Accent      = Color3.fromRGB(180, 60, 200),
    AccentAlt   = Color3.fromRGB(220, 80, 160),
    Text        = Color3.fromRGB(240, 210, 255),
    TextDim     = Color3.fromRGB(160, 130, 190),
    Input       = Color3.fromRGB(35, 22, 55),
    Toggle      = Color3.fromRGB(100, 40, 140),
    Slider      = Color3.fromRGB(140, 50, 180),
    Shadow      = Color3.fromRGB(8, 4, 16),
    Success     = Color3.fromRGB(100, 220, 150),
    Error       = Color3.fromRGB(255, 80, 120),
}

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local Mouse       = LocalPlayer:GetMouse()

-- ================================================
-- Auth DB
-- ================================================

local AccountDB = {
    { username = "lappy", password = "123", isAdmin = true },
}
local LicenseDB   = {}
local CurrentUser = nil

local function SendWebhook(title, desc, color)
    pcall(function()
        syn.request({
            Url     = Config.WebhookURL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode({
                embeds = {{
                    title       = title,
                    description = desc,
                    color       = color or 9699539,
                    timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    footer      = { text = "VelsHub" },
                }}
            }),
        })
    end)
end

local function FindAccount(u)
    for _, a in ipairs(AccountDB) do
        if a.username:lower() == u:lower() then return a end
    end
end

local function TryLogin(u, p)
    local acc = FindAccount(u)
    if not acc then
        SendWebhook("❌ Login Gagal", string.format("`%s` tidak ditemukan\nGame: **%s**", u, game.Name), 15158332)
        return false, "User tidak ditemukan"
    end
    if acc.password ~= p then
        SendWebhook("❌ Login Gagal", string.format("Password salah untuk `%s`\nGame: **%s**", u, game.Name), 15158332)
        return false, "Password salah"
    end
    CurrentUser = acc
    SendWebhook("✅ Login", string.format("`%s` login\nAdmin: %s\nGame: **%s**", acc.username, tostring(acc.isAdmin), game.Name), 3066993)
    return true, "Welcome, " .. acc.username
end

local function GenerateLicense()
    local function hex() return string.format("%04X", math.random(0, 65535)) end
    return string.format("VELS-%s-%s-%s-%s", hex(), hex(), hex(), hex())
end

local function CreateAccount(u, p)
    if FindAccount(u) then return false, "Username sudah ada" end
    table.insert(AccountDB, { username = u, password = p, isAdmin = false })
    local key = GenerateLicense()
    table.insert(LicenseDB, { key = key, username = u })
    SendWebhook("🔑 Akun Baru", string.format("Admin `%s` buat akun `%s`\nLisensi: `%s`", CurrentUser.username, u, key), 10181046)
    return true, key
end

-- ================================================
-- GUI Utilities
-- ================================================

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function Stroke(p, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or Theme.Accent
    s.Thickness = thickness or 1
    s.Parent    = p
    return s
end

local function MakeFrame(parent, size, pos, color, transparency)
    local f = Instance.new("Frame")
    f.Size                   = size
    f.Position               = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3       = color or Theme.Panel
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel        = 0
    f.Parent                 = parent
    return f
end

local function MakeLabel(parent, text, pos, size, color, fs, xa)
    local l = Instance.new("TextLabel")
    l.Text                   = text
    l.Position               = pos or UDim2.new(0,0,0,0)
    l.Size                   = size or UDim2.new(1,0,0,20)
    l.BackgroundTransparency = 1
    l.TextColor3             = color or Theme.Text
    l.Font                   = Enum.Font.GothamBold
    l.TextSize               = fs or 13
    l.TextXAlignment         = xa or Enum.TextXAlignment.Left
    l.Parent                 = parent
    return l
end

local function MakeTextBox(parent, placeholder, size)
    local tb = Instance.new("TextBox")
    tb.PlaceholderText   = placeholder or ""
    tb.Size              = size or UDim2.new(1,-20,0,34)
    tb.BackgroundColor3  = Theme.Input
    tb.TextColor3        = Theme.Text
    tb.PlaceholderColor3 = Theme.TextDim
    tb.Font              = Enum.Font.Gotham
    tb.TextSize          = 13
    tb.BorderSizePixel   = 0
    tb.ClearTextOnFocus  = false
    tb.Parent            = parent
    Corner(tb, 6)
    Stroke(tb, Theme.Accent, 1)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.Parent = tb
    return tb
end

local function MakeButton(parent, text, size, onClick)
    local btn = Instance.new("TextButton")
    btn.Text             = text
    btn.Size             = size or UDim2.new(1,-20,0,36)
    btn.BackgroundColor3 = Theme.Accent
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 13
    btn.BorderSizePixel  = 0
    btn.AutoButtonColor  = false
    btn.Parent           = parent
    Corner(btn, 8)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.AccentAlt }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.Accent }):Play()
    end)
    if onClick then btn.MouseButton1Click:Connect(onClick) end
    return btn
end

-- ================================================
-- LOGIN GUI — Animated + Transparent
-- ================================================

local LoginGui = Instance.new("ScreenGui")
LoginGui.Name           = "VelsHub_Login"
LoginGui.ResetOnSpawn   = false
LoginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoginGui.IgnoreGuiInset = true
LoginGui.Parent         = CoreGui

local LoginBackdrop = Instance.new("Frame")
LoginBackdrop.Size                   = UDim2.new(1,0,1,0)
LoginBackdrop.BackgroundColor3       = Theme.BG
LoginBackdrop.BackgroundTransparency = 0.15
LoginBackdrop.BorderSizePixel        = 0
LoginBackdrop.ZIndex                 = 1
LoginBackdrop.Parent                 = LoginGui

local backdropGrad = Instance.new("UIGradient")
backdropGrad.Rotation = 45
backdropGrad.Color    = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(12, 6, 22)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 12, 48)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(12, 6, 22)),
})
backdropGrad.Parent = LoginBackdrop

local Vignette = Instance.new("Frame")
Vignette.Size                   = UDim2.new(1,0,1,0)
Vignette.BackgroundColor3       = Color3.fromRGB(0,0,0)
Vignette.BackgroundTransparency = 0.55
Vignette.BorderSizePixel        = 0
Vignette.ZIndex                 = 2
Vignette.Parent                 = LoginBackdrop
local vigGrad = Instance.new("UIGradient")
vigGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,   0.3),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(1,   0.3),
})
vigGrad.Rotation = 90
vigGrad.Parent   = Vignette

local ParticleLayer = Instance.new("Frame")
ParticleLayer.Size                   = UDim2.new(1,0,1,0)
ParticleLayer.BackgroundTransparency = 1
ParticleLayer.ZIndex                 = 3
ParticleLayer.Parent                 = LoginBackdrop

local function SpawnParticle()
    local p = Instance.new("Frame")
    p.Size             = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    p.Position         = UDim2.new(math.random(), 0, 1.05, 0)
    p.BackgroundColor3 = math.random() > 0.5 and Theme.Accent or Theme.AccentAlt
    p.BackgroundTransparency = 0.4
    p.BorderSizePixel  = 0
    p.ZIndex           = 3
    p.Parent           = ParticleLayer
    Corner(p, 99)

    local driftX = math.random(-30, 30)
    local dur    = math.random(4, 9) + math.random()
    local target = UDim2.new(p.Position.X.Scale, driftX, -0.1, 0)

    TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Position = target }):Play()
    task.spawn(function() task.wait(dur); p:Destroy() end)
end

task.spawn(function()
    while LoginGui.Parent do
        for _ = 1, math.random(1, 3) do SpawnParticle() end
        task.wait(math.random(6, 14) / 10)
    end
end)

local CardShadow = Instance.new("Frame")
CardShadow.Size                   = UDim2.new(0,360,0,350)
CardShadow.Position               = UDim2.new(0.5,-180,0.5,-155)
CardShadow.BackgroundColor3       = Theme.Shadow
CardShadow.BackgroundTransparency = 0.55
CardShadow.BorderSizePixel        = 0
CardShadow.ZIndex                 = 4
CardShadow.Parent                 = LoginBackdrop
Corner(CardShadow, 18)

local LoginCard = Instance.new("Frame")
LoginCard.Size                   = UDim2.new(0,340,0,330)
LoginCard.Position               = UDim2.new(0.5,-170,0.5,-145)
LoginCard.BackgroundColor3       = Theme.Panel
LoginCard.BackgroundTransparency = 0.05
LoginCard.BorderSizePixel        = 0
LoginCard.ZIndex                 = 5
LoginCard.Parent                 = LoginBackdrop
Corner(LoginCard, 14)
local cardStroke = Stroke(LoginCard, Theme.Accent, 1.5)

LoginCard.Position = UDim2.new(0.5,-170,0.5,-95)
LoginCard.BackgroundTransparency = 1
CardShadow.Position = UDim2.new(0.5,-180,0.5,-105)
CardShadow.BackgroundTransparency = 1

task.spawn(function()
    task.wait(0.05)
    TweenService:Create(LoginCard, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5,-170,0.5,-145),
        BackgroundTransparency = 0.05,
    }):Play()
    TweenService:Create(CardShadow, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5,-180,0.5,-155),
        BackgroundTransparency = 0.55,
    }):Play()
end)

local LogoHolder = Instance.new("Frame")
LogoHolder.Size                   = UDim2.new(0,56,0,56)
LogoHolder.Position               = UDim2.new(0.5,-28,0,18)
LogoHolder.BackgroundTransparency = 1
LogoHolder.ZIndex                 = 6
LogoHolder.Parent                 = LoginCard

local LogoBtn = Instance.new("TextLabel")
LogoBtn.Size                   = UDim2.new(1,0,1,0)
LogoBtn.BackgroundTransparency = 1
LogoBtn.Text                   = "⬡"
LogoBtn.TextColor3             = Theme.AccentAlt
LogoBtn.TextScaled             = true
LogoBtn.Font                   = Enum.Font.GothamBold
LogoBtn.ZIndex                 = 6
LogoBtn.Parent                 = LogoHolder

task.spawn(function()
    local rot = 0
    while LoginGui.Parent do
        rot = (rot + 0.8) % 360
        LogoBtn.Rotation = rot
        task.wait(0.016)
    end
end)

task.spawn(function()
    while LoginGui.Parent do
        TweenService:Create(LogoBtn, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Theme.Accent,
        }):Play()
        task.wait(0.9)
        TweenService:Create(LogoBtn, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(255, 200, 255),
        }):Play()
        task.wait(0.9)
    end
end)

local TitleLabel = MakeLabel(LoginCard, "VelsHub", UDim2.new(0,0,0,78), UDim2.new(1,0,0,26), Theme.Text, 20, Enum.TextXAlignment.Center)
TitleLabel.ZIndex = 6
TitleLabel.TextTransparency = 1

task.spawn(function()
    task.wait(0.3)
    for i = 1, 20 do
        TitleLabel.TextTransparency = 1 - (i / 20)
        task.wait(0.02)
    end
end)

local SubLabel = MakeLabel(LoginCard, "masuk dulu bos", UDim2.new(0,0,0,102), UDim2.new(1,0,0,16), Theme.TextDim, 11, Enum.TextXAlignment.Center)
SubLabel.ZIndex = 6
SubLabel.TextTransparency = 1

task.spawn(function()
    task.wait(0.6)
    for i = 1, 20 do
        SubLabel.TextTransparency = 1 - (i / 20)
        task.wait(0.02)
    end
end)

-- login inputs (tanpa placeholder text)
local userLbl = MakeLabel(LoginCard, "Username", UDim2.new(0,20,0,128), UDim2.new(1,-40,0,16), Theme.TextDim, 11)
userLbl.ZIndex = 6
local LoginUserBox = MakeTextBox(LoginCard, "", UDim2.new(1,-40,0,36))
LoginUserBox.Position = UDim2.new(0,20,0,148)
LoginUserBox.ZIndex   = 6
LoginUserBox.BackgroundTransparency = 0.15

local passLbl = MakeLabel(LoginCard, "Password", UDim2.new(0,20,0,192), UDim2.new(1,-40,0,16), Theme.TextDim, 11)
passLbl.ZIndex = 6
local LoginPassBox = MakeTextBox(LoginCard, "", UDim2.new(1,-40,0,36))
LoginPassBox.Position = UDim2.new(0,20,0,212)
LoginPassBox.ZIndex   = 6
LoginPassBox.BackgroundTransparency = 0.15

local function HookInputGlow(box)
    local boxStroke = box:FindFirstChildOfClass("UIStroke")
    box.Focused:Connect(function()
        if boxStroke then
            TweenService:Create(boxStroke, TweenInfo.new(0.2), { Color = Theme.AccentAlt, Thickness = 2 }):Play()
        end
        TweenService:Create(box, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
    end)
    box.FocusLost:Connect(function()
        if boxStroke then
            TweenService:Create(boxStroke, TweenInfo.new(0.2), { Color = Theme.Accent, Thickness = 1 }):Play()
        end
        TweenService:Create(box, TweenInfo.new(0.2), { BackgroundTransparency = 0.15 }):Play()
    end)
end

HookInputGlow(LoginUserBox)
HookInputGlow(LoginPassBox)

local LoginStatus = MakeLabel(LoginCard, "", UDim2.new(0,20,0,254), UDim2.new(1,-40,0,16), Theme.Error, 11, Enum.TextXAlignment.Center)
LoginStatus.ZIndex = 6

local LoginBtn = MakeButton(LoginCard, "🔓  Login", UDim2.new(1,-40,0,38), nil)
LoginBtn.Position = UDim2.new(0,20,0,278)
LoginBtn.ZIndex   = 6
LoginBtn.ClipsDescendants = true

local Shimmer = Instance.new("Frame")
Shimmer.Size                   = UDim2.new(0,40,1,0)
Shimmer.Position               = UDim2.new(-0.3,0,0,0)
Shimmer.BackgroundColor3       = Color3.fromRGB(255,255,255)
Shimmer.BackgroundTransparency = 0.7
Shimmer.BorderSizePixel        = 0
Shimmer.ZIndex                 = 7
Shimmer.Parent                 = LoginBtn
Corner(Shimmer, 8)
local shimmerGrad = Instance.new("UIGradient")
shimmerGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.3),
    NumberSequenceKeypoint.new(1, 1),
})
shimmerGrad.Parent = Shimmer

task.spawn(function()
    while LoginGui.Parent do
        Shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
        TweenService:Create(Shimmer, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1.1, 0, 0, 0),
        }):Play()
        task.wait(2.5)
    end
end)

local function ShakeCard()
    local orig = LoginCard.Position
    local origShadow = CardShadow.Position
    for i = 1, 6 do
        local dx = (i % 2 == 0) and 8 or -8
        LoginCard.Position  = UDim2.new(orig.X.Scale, orig.X.Offset + dx, orig.Y.Scale, orig.Y.Offset)
        CardShadow.Position = UDim2.new(origShadow.X.Scale, origShadow.X.Offset + dx, origShadow.Y.Scale, origShadow.Y.Offset)
        task.wait(0.04)
    end
    LoginCard.Position  = orig
    CardShadow.Position = origShadow
end

local CloseLogin = Instance.new("TextButton")
CloseLogin.Size             = UDim2.new(0,26,0,26)
CloseLogin.Position         = UDim2.new(1,-34,0,8)
CloseLogin.BackgroundColor3 = Theme.TabInactive
CloseLogin.TextColor3       = Theme.TextDim
CloseLogin.Font             = Enum.Font.GothamBold
CloseLogin.TextSize         = 14
CloseLogin.Text             = "✕"
CloseLogin.BorderSizePixel  = 0
CloseLogin.AutoButtonColor  = false
CloseLogin.ZIndex           = 7
CloseLogin.Parent           = LoginCard
Corner(CloseLogin, 6)
Stroke(CloseLogin, Theme.Accent, 1)

CloseLogin.MouseEnter:Connect(function()
    TweenService:Create(CloseLogin, TweenInfo.new(0.15), { BackgroundColor3 = Theme.Error, TextColor3 = Color3.fromRGB(255,255,255) }):Play()
end)
CloseLogin.MouseLeave:Connect(function()
    TweenService:Create(CloseLogin, TweenInfo.new(0.15), { BackgroundColor3 = Theme.TabInactive, TextColor3 = Theme.TextDim }):Play()
end)
CloseLogin.MouseButton1Click:Connect(function()
    LoginGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Escape and LoginGui.Parent then
        LoginGui:Destroy()
    end
end)

local HubLoader

LoginBtn.MouseButton1Click:Connect(function()
    local ok, msg = TryLogin(LoginUserBox.Text, LoginPassBox.Text)
    LoginStatus.TextColor3 = ok and Theme.Success or Theme.Error
    LoginStatus.Text = (ok and "✓ " or "✗ ") .. msg

    if ok then
        TweenService:Create(LoginCard, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0,360,0,350),
            Position = UDim2.new(0.5,-180,0.5,-175),
            BackgroundTransparency = 0.4,
        }):Play()
        TweenService:Create(LoginBackdrop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
        }):Play()
        Vignette.Visible = false
        ParticleLayer.Visible = false

        task.wait(0.5)
        LoginGui:Destroy()
        if HubLoader then HubLoader() end
    else
        ShakeCard()
        TweenService:Create(cardStroke, TweenInfo.new(0.1), { Color = Theme.Error, Thickness = 2 }):Play()
        task.delay(0.3, function()
            TweenService:Create(cardStroke, TweenInfo.new(0.3), { Color = Theme.Accent, Thickness = 1.5 }):Play()
        end)
    end
end)

-- ================================================
-- HUB LOADER
-- ================================================

HubLoader = function()
    if not CurrentUser then
        warn("[VelsHub] HubLoader dipanggil tanpa login")
        return
    end

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
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "VelsHub"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent         = CoreGui

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

    -- window
    local WIN_W, WIN_H = 620, 480

    local Shadow = Frame(ScreenGui,
        UDim2.new(0, WIN_W + 12, 0, WIN_H + 12),
        UDim2.new(0.5, -(WIN_W + 12)/2, 0.5, -(WIN_H + 12)/2),
        Pal.Shadow, 0.35)
    Corner(Shadow, 16)
    Shadow.ZIndex = 0

    local Main = Frame(ScreenGui,
        UDim2.new(0, WIN_W, 0, WIN_H),
        UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
        Pal.Window, 0)
    Corner(Main, 14)
    Stroke(Main, Pal.Border, 1, 0.3)
    Main.ZIndex = 1

    do
        local bgGrad = Instance.new("UIGradient")
        bgGrad.Rotation = 135
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Pal.Window),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 28)),
            ColorSequenceKeypoint.new(1,   Pal.Window),
        })
        bgGrad.Parent = Main
    end

    -- title bar
    local TitleBar = Frame(Main,
        UDim2.new(1, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        Pal.TopBar, 0.3)
    Corner(TitleBar, 14)

    local titleCover = Frame(TitleBar,
        UDim2.new(1, 0, 0, 14),
        UDim2.new(0, 0, 1, -14),
        Pal.TopBar, 0.3)

    local AccentLine = Frame(TitleBar,
        UDim2.new(1, 0, 0, 2),
        UDim2.new(0, 0, 1, -2),
        Pal.Accent, 0)
    do
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Pal.Accent),
            ColorSequenceKeypoint.new(0.5, Pal.AccentAlt),
            ColorSequenceKeypoint.new(1,   Pal.Accent),
        })
        g.Parent = AccentLine
    end

    BoldLabel(TitleBar, "⬡  VelsHub", UDim2.new(0, 16, 0, 0), UDim2.new(0, 200, 1, 0), Pal.Text, 14)
    Label(TitleBar, "v2.9", UDim2.new(0, 120, 0, 0), UDim2.new(0, 40, 1, 0), Pal.TextMute, 10)
    Label(TitleBar, "[K]", UDim2.new(1, -100, 0, 0), UDim2.new(0, 30, 1, 0), Pal.TextMute, 10, Enum.TextXAlignment.Center)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size             = UDim2.new(0, 28, 0, 28)
    MinBtn.Position         = UDim2.new(1, -68, 0.5, -14)
    MinBtn.BackgroundColor3 = Pal.Card
    MinBtn.TextColor3       = Pal.TextDim
    MinBtn.Font             = Enum.Font.GothamBold
    MinBtn.TextSize         = 14
    MinBtn.Text             = "−"
    MinBtn.BorderSizePixel  = 0
    MinBtn.AutoButtonColor  = false
    MinBtn.Parent           = TitleBar
    Corner(MinBtn, 6)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size             = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position         = UDim2.new(1, -36, 0.5, -14)
    CloseBtn.BackgroundColor3 = Pal.Card
    CloseBtn.TextColor3       = Pal.TextDim
    CloseBtn.Font             = Enum.Font.GothamBold
    CloseBtn.TextSize         = 14
    CloseBtn.Text             = "✕"
    CloseBtn.BorderSizePixel  = 0
    CloseBtn.AutoButtonColor  = false
    CloseBtn.Parent           = TitleBar
    Corner(CloseBtn, 6)

    MinBtn.MouseEnter:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.CardHover, TextColor3 = Pal.Text }):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Card, TextColor3 = Pal.TextDim }):Play()
    end)
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Error, TextColor3 = Color3.fromRGB(255,255,255) }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Card, TextColor3 = Pal.TextDim }):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    do
        local dragging, dragStart, startPos, shadowStart
        TitleBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging    = true
                dragStart   = i.Position
                startPos    = Main.Position
                shadowStart = Shadow.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - dragStart
                Main.Position   = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                Shadow.Position = UDim2.new(shadowStart.X.Scale, shadowStart.X.Offset + d.X, shadowStart.Y.Scale, shadowStart.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    -- sidebar
    local SidebarW = 150
    local Sidebar = Frame(Main,
        UDim2.new(0, SidebarW, 1, -40 - 20),
        UDim2.new(0, 0, 0, 40),
        Pal.Sidebar, 0.2)
    Corner(Sidebar, 10)
    Pad(Sidebar, 10, 8, 10, 8)

    local sideList = Instance.new("UIListLayout")
    sideList.Padding             = UDim.new(0, 4)
    sideList.SortOrder           = Enum.SortOrder.LayoutOrder
    sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideList.Parent              = Sidebar

    -- content
    local ContentX = SidebarW + 20
    local Content = Frame(Main,
        UDim2.new(1, -ContentX - 20, 1, -40 - 20),
        UDim2.new(0, ContentX, 0, 40),
        Pal.Window, 1)

    local Pages   = {}
    local TabBtns = {}

    local function MakePage(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size                   = UDim2.new(1, 0, 1, 0)
        scroll.Position               = UDim2.new(0, 0, 0, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel        = 0
        scroll.ScrollBarThickness     = 3
        scroll.ScrollBarImageColor3   = Pal.Accent
        scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
        scroll.Visible                = false
        scroll.Parent                 = Content

        local pad = Instance.new("UIPadding")
        pad.PaddingTop    = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingRight  = UDim.new(0, 8)
        pad.Parent        = scroll

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent  = scroll

        Pages[name] = scroll
        return scroll
    end

    local function SwitchTab(name)
        for n, p in pairs(Pages) do p.Visible = (n == name) end
        for n, b in pairs(TabBtns) do
            local active = (n == name)
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = active and Pal.CardActive or Pal.Card,
            }):Play()
            local lbl = b:FindFirstChildOfClass("TextLabel")
            if lbl then
                TweenService:Create(lbl, TweenInfo.new(0.15), {
                    TextColor3 = active and Pal.Text or Pal.TextDim,
                }):Play()
            end
            local bar = b:FindFirstChild("__activebar")
            if bar then bar.Visible = active end
        end
    end

    local tabNames = { "Visual", "Combat", "Misc", "World", "Admin" }

    for _, name in ipairs(tabNames) do
        MakePage(name)

        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Pal.Card
        btn.TextColor3       = Pal.TextDim
        btn.Text             = ""
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Parent           = Sidebar
        Corner(btn, 8)

        local bar = Instance.new("Frame")
        bar.Name             = "__activebar"
        bar.Size             = UDim2.new(0, 3, 0, 16)
        bar.Position         = UDim2.new(0, 4, 0.5, -8)
        bar.BackgroundColor3 = Pal.Accent
        bar.BorderSizePixel  = 0
        bar.Visible          = false
        bar.Parent           = btn
        Corner(bar, 2)

        local lbl = Label(btn, name, UDim2.new(0, 16, 0, 0), UDim2.new(1, -16, 1, 0), Pal.TextDim, 12)
        lbl.Font = Enum.Font.GothamBold

        TabBtns[name] = btn

        btn.MouseEnter:Connect(function()
            if not Pages[name].Visible then
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.CardHover }):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not Pages[name].Visible then
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Card }):Play()
            end
        end)
        btn.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)
    end

    TabBtns["Admin"].Visible = CurrentUser.isAdmin

    -- widget builders
    local function MakeSection(parent, title, collapsible)
        local section = Frame(parent, UDim2.new(1, 0, 0, 0), nil, Pal.Card, 0)
        Corner(section, 10)
        Stroke(section, Pal.BorderSoft, 1, 0.3)
        section.AutomaticSize = Enum.AutomaticSize.Y

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent  = section

        Pad(section, 10, 12, 10, 12)

        local headerRow = Frame(section, UDim2.new(1, 0, 0, 20), nil, Color3.fromRGB(0,0,0), 1)
        headerRow.LayoutOrder = 0

        BoldLabel(headerRow, title:upper(), UDim2.new(0, 0, 0, 0), UDim2.new(1, -20, 1, 0), Pal.Accent, 11)

        if collapsible then
            local arrow = Label(headerRow, "▾", UDim2.new(1, -14, 0, 0), UDim2.new(0, 14, 1, 0), Pal.TextMute, 12, Enum.TextXAlignment.Center)
            arrow.Font = Enum.Font.GothamBold

            local contentHolder = Frame(section, UDim2.new(1, 0, 0, 0), nil, Color3.fromRGB(0,0,0), 1)
            contentHolder.AutomaticSize = Enum.AutomaticSize.Y
            contentHolder.LayoutOrder   = 1

            local innerLayout = Instance.new("UIListLayout")
            innerLayout.Padding = UDim.new(0, 6)
            innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            innerLayout.Parent = contentHolder

            local open = true
            local hb = Instance.new("TextButton")
            hb.Size = UDim2.new(1, 0, 1, 0)
            hb.BackgroundTransparency = 1
            hb.Text = ""
            hb.Parent = headerRow

            hb.MouseButton1Click:Connect(function()
                open = not open
                contentHolder.Visible = open
                arrow.Text = open and "▾" or "▸"
            end)

            return contentHolder, section
        end

        return section, section
    end

    local function MakeToggle(parent, label, default, onChange)
        local row = Frame(parent, UDim2.new(1, 0, 0, 30), nil, Color3.fromRGB(0,0,0), 1)
        Label(row, label, UDim2.new(0, 0, 0, 0), UDim2.new(0.75, 0, 1, 0), Pal.Text, 12)

        local track = Frame(row, UDim2.new(0, 40, 0, 20), UDim2.new(1, -42, 0.5, -10),
            default and Pal.AccentSoft or Pal.ToggleOff)
        Corner(track, 10)

        local knob = Frame(track, UDim2.new(0, 14, 0, 14),
            default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            Color3.fromRGB(255,255,255))
        Corner(knob, 7)

        local state = default
        local hb = Instance.new("TextButton")
        hb.Size = UDim2.new(1, 0, 1, 0)
        hb.BackgroundTransparency = 1
        hb.Text = ""
        hb.Parent = track

        hb.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(track, TweenInfo.new(0.15), {
                BackgroundColor3 = state and Pal.AccentSoft or Pal.ToggleOff
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            }):Play()
            if onChange then onChange(state) end
        end)

        return row
    end

    local function MakeSlider(parent, label, min, max, default, onChange)
        local wrap = Frame(parent, UDim2.new(1, 0, 0, 46), nil, Color3.fromRGB(0,0,0), 1)
        local lbl = Label(wrap, label .. ": " .. default,
            UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 16), Pal.TextDim, 11)

        local track = Frame(wrap, UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 24), Pal.ToggleOff)
        Corner(track, 3)

        local fill = Frame(track, UDim2.new((default - min) / (max - min), 0, 1, 0), nil, Pal.Accent)
        Corner(fill, 3)

        local knob = Frame(track, UDim2.new(0, 12, 0, 12),
            UDim2.new((default - min) / (max - min), -6, 0.5, -6),
            Color3.fromRGB(255,255,255))
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
                local val = math.floor(min + (max - min) * rel)
                fill.Size     = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -6, 0.5, -6)
                lbl.Text      = label .. ": " .. val
                if onChange then onChange(val) end
            end
        end)

        return wrap
    end

    local function MakeInput(parent, placeholder, onFinish)
        local box = Instance.new("TextBox")
        box.PlaceholderText   = placeholder
        box.Size              = UDim2.new(1, 0, 0, 32)
        box.BackgroundColor3  = Pal.Input
        box.TextColor3        = Pal.Text
        box.PlaceholderColor3 = Pal.TextMute
        box.Font              = Enum.Font.Gotham
        box.TextSize          = 12
        box.BorderSizePixel   = 0
        box.ClearTextOnFocus  = false
        box.Parent            = parent
        Corner(box, 6)
        local s = Stroke(box, Pal.BorderSoft, 1, 0.3)
        Pad(box, 0, 0, 0, 10)

        box.Focused:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), { Color = Pal.Accent, Transparency = 0 }):Play()
        end)
        box.FocusLost:Connect(function(enter)
            TweenService:Create(s, TweenInfo.new(0.2), { Color = Pal.BorderSoft, Transparency = 0.3 }):Play()
            if enter and onFinish then onFinish(box.Text) end
        end)

        return box
    end

    local function MakeActionButton(parent, text, onClick)
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Pal.AccentSoft
        btn.TextColor3       = Color3.fromRGB(255,255,255)
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 12
        btn.Text             = text
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Parent           = parent
        Corner(btn, 6)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.Accent }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Pal.AccentSoft }):Play()
        end)
        btn.MouseButton1Click:Connect(onClick)

        return btn
    end

    -- ================================================
    -- GUI TOGGLE — keybind K
    -- ================================================

    local GuiVisible = true

    local function SetGuiVisible(state)
        GuiVisible = state

        if state then
            Main.Visible   = true
            Shadow.Visible = true
            Main.BackgroundTransparency   = 0
            Shadow.BackgroundTransparency = 0.35

            local curMain   = Main.Position
            local curShadow = Shadow.Position

            Main.Position   = UDim2.new(curMain.X.Scale, curMain.X.Offset, curMain.Y.Scale, curMain.Y.Offset + 20)
            Shadow.Position = UDim2.new(curShadow.X.Scale, curShadow.X.Offset, curShadow.Y.Scale, curShadow.Y.Offset + 20)

            TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = curMain,
            }):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = curShadow,
            }):Play()
        else
            local fadeMain = TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
            })
            local fadeShadow = TweenService:Create(Shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
            })
            fadeMain:Play()
            fadeShadow:Play()

            fadeMain.Completed:Connect(function()
                if not GuiVisible then
                    Main.Visible   = false
                    Shadow.Visible = false
                end
            end)
        end
    end

    local toggleDebounce = false

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode ~= Enum.KeyCode.K then return end

        if toggleDebounce then return end
        toggleDebounce = true
        task.delay(0.2, function() toggleDebounce = false end)

        SetGuiVisible(not GuiVisible)
    end)

    -- ================================================
    -- AIMBOT CORE (auto-lock) — pattern Exunys
    -- ================================================

    local AimbotState = {
        Running   = false,
        Locked    = nil,
        Animation = nil,
        OriginalSensitivity = UserInputService.MouseDeltaSensitivity,
    }

    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible      = false
    FOVCircle.NumSides     = 60
    FOVCircle.Filled       = Config.Aimbot.FOVFilled
    FOVCircle.Thickness    = Config.Aimbot.FOVThickness
    FOVCircle.Transparency = Config.Aimbot.FOVTransparency
    FOVCircle.Color        = Config.Aimbot.FOVColor

    local FOVOutline = Drawing.new("Circle")
    FOVOutline.Visible      = false
    FOVOutline.NumSides     = 60
    FOVOutline.Filled       = false
    FOVOutline.Thickness    = Config.Aimbot.FOVThickness + 1
    FOVOutline.Transparency = Config.Aimbot.FOVTransparency
    FOVOutline.Color        = Color3.fromRGB(0, 0, 0)

    local Tracer = Drawing.new("Line")
    Tracer.Visible      = false
    Tracer.Thickness    = Config.Aimbot.TracerThickness
    Tracer.Transparency = 0.3
    Tracer.Color        = Config.Aimbot.TracerColor

    local function GetMouseLocation()
        return UserInputService:GetMouseLocation()
    end

    local function IsAlive(char)
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
    end

    local function IsTeammate(player)
        if not Config.Aimbot.TeamCheck then return false end
        return player.Team and player.Team == LocalPlayer.Team
    end

    local function AimWallCheck(char)
        if not Config.Aimbot.WallCheck then return true end
        local targetPart = char:FindFirstChild(Config.Aimbot.LockPart)
        if not targetPart then return false end

        local blacklist = {}
        if LocalPlayer.Character then
            for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
                blacklist[#blacklist + 1] = v
            end
        end
        for _, v in ipairs(char:GetDescendants()) do
            blacklist[#blacklist + 1] = v
        end

        local obscuring = Camera:GetPartsObscuringTarget({ targetPart.Position }, blacklist)
        return #obscuring == 0
    end

    local function GetClosestTarget()
        local closest, closestDist = nil, Config.Aimbot.FOVEnabled and Config.Aimbot.FOV or math.huge
        local mouseLoc = GetMouseLocation()

        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if IsTeammate(player) then continue end

            local char = player.Character
            if not char then continue end
            if Config.Aimbot.AliveCheck and not IsAlive(char) then continue end

            local part = char:FindFirstChild(Config.Aimbot.LockPart)
            if not part then continue end

            local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local screenVec = Vector2.new(screen.X, screen.Y)
            local dist = (mouseLoc - screenVec).Magnitude

            if dist < closestDist and AimWallCheck(char) then
                closestDist = dist
                closest     = { player = player, char = char, part = part, screenPos = screenVec }
            end
        end

        return closest
    end

    local function CancelLock()
        AimbotState.Locked = nil
        FOVCircle.Color  = Config.Aimbot.FOVColor
        FOVOutline.Color = Color3.fromRGB(0, 0, 0)
        UserInputService.MouseDeltaSensitivity = AimbotState.OriginalSensitivity

        if AimbotState.Animation then
            AimbotState.Animation:Cancel()
            AimbotState.Animation = nil
        end
        Tracer.Visible = false
    end

    local function OnAimbotUpdate()
        if not Config.Aimbot.Enabled then
            FOVCircle.Visible  = false
            FOVOutline.Visible = false
            Tracer.Visible     = false
            return
        end

        local mouseLoc = GetMouseLocation()
        FOVCircle.Position     = mouseLoc
        FOVCircle.Radius       = Config.Aimbot.FOV
        FOVCircle.Thickness    = Config.Aimbot.FOVThickness
        FOVCircle.Transparency = Config.Aimbot.FOVTransparency
        FOVCircle.Filled       = Config.Aimbot.FOVFilled

        FOVOutline.Position     = mouseLoc
        FOVOutline.Radius       = Config.Aimbot.FOV
        FOVOutline.Thickness    = Config.Aimbot.FOVThickness + 1
        FOVOutline.Transparency = Config.Aimbot.FOVTransparency

        FOVCircle.Visible  = Config.Aimbot.FOVEnabled
        FOVOutline.Visible = Config.Aimbot.FOVEnabled

        if not AimbotState.Running then
            CancelLock()
            return
        end

        if not AimbotState.Locked then
            local t = GetClosestTarget()
            if t then AimbotState.Locked = t.player end
        else
            local char = AimbotState.Locked.Character
            if not char or not IsAlive(char) or not char:FindFirstChild(Config.Aimbot.LockPart) then
                CancelLock()
            end
        end

        if Config.Aimbot.TracerEnabled and not AimbotState.Locked then
            local t = GetClosestTarget()
            if t then
                Tracer.Visible = true
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Tracer.To   = t.screenPos
                Tracer.Color = Config.Aimbot.TracerColor
            else
                Tracer.Visible = false
            end
        else
            Tracer.Visible = false
        end

        if AimbotState.Locked and AimbotState.Locked.Character then
            local char = AimbotState.Locked.Character
            local part = char:FindFirstChild(Config.Aimbot.LockPart)
            local hum  = char:FindFirstChildOfClass("Humanoid")

            if part and hum then
                local offset = Vector3.zero
                if Config.Aimbot.OffsetToMove then
                    offset = hum.MoveDirection * (math.clamp(Config.Aimbot.OffsetAmount, 1, 30) / 10)
                end

                local targetPos = part.Position + offset

                if Config.Aimbot.Smoothness > 0 then
                    if AimbotState.Animation then AimbotState.Animation:Cancel() end
                    AimbotState.Animation = TweenService:Create(Camera,
                        TweenInfo.new(Config.Aimbot.Smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                        { CFrame = CFrame.new(Camera.CFrame.Position, targetPos) })
                    AimbotState.Animation:Play()
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                end

                UserInputService.MouseDeltaSensitivity = 0

                FOVCircle.Color  = Config.Aimbot.FOVLockedColor
                FOVOutline.Color = Config.Aimbot.FOVLockedColor
            else
                CancelLock()
            end
        end
    end

    local function OnAimbotInputBegan(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end

        local key = Config.Aimbot.TriggerKey
        if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key)
            or input.UserInputType == key then
            if Config.Aimbot.Toggle then
                AimbotState.Running = not AimbotState.Running
                if not AimbotState.Running then CancelLock() end
            else
                AimbotState.Running = true
            end
        end
    end

    local function OnAimbotInputEnded(input)
        local key = Config.Aimbot.TriggerKey
        if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key)
            or input.UserInputType == key then
            if not Config.Aimbot.Toggle then
                AimbotState.Running = false
                CancelLock()
            end
        end
    end

    RunService.RenderStepped:Connect(OnAimbotUpdate)
    UserInputService.InputBegan:Connect(OnAimbotInputBegan)
    UserInputService.InputEnded:Connect(OnAimbotInputEnded)

    -- ================================================
    -- ESP internals
    -- ================================================

    local ESPCache = {}

    local SkeletonBones = {
        {"Head","UpperTorso"},
        {"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},
        {"LeftUpperArm","LeftLowerArm"},
        {"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},
        {"RightUpperArm","RightLowerArm"},
        {"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},
        {"LeftUpperLeg","LeftLowerLeg"},
        {"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},
        {"RightUpperLeg","RightLowerLeg"},
        {"RightLowerLeg","RightFoot"},
    }

    local function NewDrawing(t, props)
        local d = Drawing.new(t)
        for k, v in pairs(props) do d[k] = v end
        return d
    end

    local function CreateESPObjects()
        return {
            Box        = NewDrawing("Square", { Visible=false, Filled=false, Thickness=1.5, Color=Config.ESP.BoxColor }),
            BoxOutline = NewDrawing("Square", { Visible=false, Filled=false, Thickness=3,   Color=Color3.fromRGB(0,0,0) }),
            HealthBG   = NewDrawing("Square", { Visible=false, Filled=true,  Thickness=1,   Color=Color3.fromRGB(0,0,0) }),
            Health     = NewDrawing("Square", { Visible=false, Filled=true,  Thickness=1,   Color=Color3.fromRGB(50,220,100) }),
            Name       = NewDrawing("Text",   { Visible=false, Size=13, Center=true, Outline=true, Color=Config.ESP.NameColor, Font=Drawing.Fonts.Plex }),
            Bones      = {},
        }
    end

    local function DestroyESPObjects(obj)
        for _, bone in ipairs(obj.Bones) do pcall(function() bone:Remove() end) end
        for k, d in pairs(obj) do
            if k ~= "Bones" then pcall(function() d:Remove() end) end
        end
    end

    local function GetScreenBounds(character)
        local parts = {"Head","UpperTorso","LowerTorso","LeftHand","RightHand","LeftFoot","RightFoot"}
        local minX, minY =  math.huge,  math.huge
        local maxX, maxY = -math.huge, -math.huge
        local found = false

        for _, name in ipairs(parts) do
            local part = character:FindFirstChild(name)
            if part then
                local s, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen and s.Z > 0 then
                    found = true
                    if s.X < minX then minX = s.X end
                    if s.Y < minY then minY = s.Y end
                    if s.X > maxX then maxX = s.X end
                    if s.Y > maxY then maxY = s.Y end
                end
            end
        end
        return found, minX, minY, maxX, maxY
    end

    local function ApplyChams(character, color)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and not part:FindFirstChild("__VelsChams") then
                local sel = Instance.new("SelectionBox")
                sel.Name                = "__VelsChams"
                sel.Adornee             = part
                sel.Color3              = color
                sel.LineThickness       = 0.05
                sel.SurfaceTransparency = Config.ESP.ChamsTransparency
                sel.SurfaceColor3       = color
                sel.Parent              = part
            end
        end
    end

    local function UpdateChamsColor(character, color)
        for _, part in ipairs(character:GetDescendants()) do
            local sel = part:FindFirstChild("__VelsChams")
            if sel then
                sel.Color3        = color
                sel.SurfaceColor3 = color
            end
        end
    end

    local function RemoveChams(character)
        for _, part in ipairs(character:GetDescendants()) do
            local sel = part:FindFirstChild("__VelsChams")
            if sel then sel:Destroy() end
        end
    end

    local function FindFirstDescendantManual(parent, name)
        for _, d in ipairs(parent:GetDescendants()) do
            if d.Name == name then return d end
        end
        return nil
    end

    local function IsESPTeammate(p)
        if not Config.ESP.TeamCheck then return false end
        return p.Team and p.Team == LocalPlayer.Team
    end

    local RainbowHue = 0
    local function GetRainbow()
        RainbowHue = (RainbowHue + 0.003) % 1
        return Color3.fromHSV(RainbowHue, 0.8, 1)
    end

    RunService.RenderStepped:Connect(function()
        if not CurrentUser then return end

        local rainbow = GetRainbow()

        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end

            if not ESPCache[player] then
                ESPCache[player] = CreateESPObjects()
            end

            local obj   = ESPCache[player]
            local char  = player.Character
            local hum   = char and char:FindFirstChildOfClass("Humanoid")
            local alive = hum and hum.Health > 0
            local show  = Config.ESP.Enabled and alive and not IsESPTeammate(player)

            if not show then
                obj.Box.Visible        = false
                obj.BoxOutline.Visible = false
                obj.Name.Visible       = false
                obj.Health.Visible     = false
                obj.HealthBG.Visible   = false
                for _, b in ipairs(obj.Bones) do b.Visible = false end
                if char then RemoveChams(char) end
                continue
            end

            local onScreen, minX, minY, maxX, maxY = GetScreenBounds(char)

            if not onScreen then
                obj.Box.Visible        = false
                obj.BoxOutline.Visible = false
                obj.Name.Visible       = false
                obj.Health.Visible     = false
                obj.HealthBG.Visible   = false
                for _, b in ipairs(obj.Bones) do b.Visible = false end
                continue
            end

            local bx = minX - 4
            local by = minY - 4
            local bw = math.max(maxX - minX + 8, 1)
            local bh = math.max(maxY - minY + 8, 1)

            obj.BoxOutline.Visible  = Config.ESP.Box
            obj.BoxOutline.Position = Vector2.new(bx, by)
            obj.BoxOutline.Size     = Vector2.new(bw, bh)

            obj.Box.Visible  = Config.ESP.Box
            obj.Box.Position = Vector2.new(bx, by)
            obj.Box.Size     = Vector2.new(bw, bh)
            obj.Box.Color    = Config.ESP.BoxColor

            local hpRat = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            local barH  = bh * hpRat

            obj.HealthBG.Visible  = Config.ESP.Box
            obj.HealthBG.Position = Vector2.new(bx - 7, by)
            obj.HealthBG.Size     = Vector2.new(4, bh)

            obj.Health.Visible  = Config.ESP.Box
            obj.Health.Position = Vector2.new(bx - 7, by + (bh - barH))
            obj.Health.Size     = Vector2.new(4, barH)
            obj.Health.Color    = Color3.fromHSV(hpRat * 0.33, 1, 1)

            obj.Name.Visible  = Config.ESP.Name
            obj.Name.Position = Vector2.new(bx + bw / 2, by - 16)
            obj.Name.Text     = player.DisplayName
            obj.Name.Color    = Config.ESP.NameColor

            if Config.ESP.Skeleton then
                local boneIdx = 1
                for _, bone in ipairs(SkeletonBones) do
                    local p0 = char:FindFirstChild(bone[1])
                    local p1 = char:FindFirstChild(bone[2])
                    if p0 and p1 then
                        local s0, on0 = Camera:WorldToViewportPoint(p0.Position)
                        local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
                        if not obj.Bones[boneIdx] then
                            obj.Bones[boneIdx] = NewDrawing("Line", { Thickness=1, Color=Config.ESP.SkeletonColor })
                        end
                        local line   = obj.Bones[boneIdx]
                        line.Visible = on0 and on1 and s0.Z > 0 and s1.Z > 0
                        line.From    = Vector2.new(s0.X, s0.Y)
                        line.To      = Vector2.new(s1.X, s1.Y)
                        line.Color   = Config.ESP.SkeletonColor
                        boneIdx     += 1
                    end
                end
                for i = boneIdx, #obj.Bones do obj.Bones[i].Visible = false end
            else
                for _, b in ipairs(obj.Bones) do b.Visible = false end
            end

            if Config.ESP.Chams then
                local chamsColor = Config.Misc.RainbowChams and rainbow or Config.ESP.ChamsColor
                local existing   = FindFirstDescendantManual(char, "__VelsChams")
                if existing then
                    UpdateChamsColor(char, chamsColor)
                else
                    ApplyChams(char, chamsColor)
                end
            else
                RemoveChams(char)
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESPCache[player] then
            DestroyESPObjects(ESPCache[player])
            ESPCache[player] = nil
        end
    end)

    -- ================================================
    -- Tab: Visual
    -- ================================================

    local VP = Pages["Visual"]
    local espSec = MakeSection(VP, "ESP", true)
    MakeToggle(espSec, "ESP Master",    Config.ESP.Enabled,  function(v) Config.ESP.Enabled  = v end)
    MakeToggle(espSec, "Box ESP",       Config.ESP.Box,      function(v) Config.ESP.Box      = v end)
    MakeToggle(espSec, "Name ESP",      Config.ESP.Name,     function(v) Config.ESP.Name     = v end)
    MakeToggle(espSec, "Skeleton ESP",  Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
    MakeToggle(espSec, "Chams",         Config.ESP.Chams,    function(v)
        Config.ESP.Chams = v
        if not v then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in ipairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local sel = part:FindFirstChild("__VelsChams")
                            if sel then sel:Destroy() end
                        end
                    end
                end
            end
        end
    end)

    local teamSec = MakeSection(VP, "Team", true)
    MakeToggle(teamSec, "Team Check (ESP)", Config.ESP.TeamCheck, function(v) Config.ESP.TeamCheck = v end)

    -- ================================================
    -- Tab: Combat
    -- ================================================

    local CP = Pages["Combat"]

    local aimSec = MakeSection(CP, "Aimbot", true)
    MakeToggle(aimSec, "Aimbot Master", Config.Aimbot.Enabled, function(v)
        Config.Aimbot.Enabled = v
        if not v then CancelLock() end
    end)
    MakeToggle(aimSec, "Toggle Mode (RMB)", Config.Aimbot.Toggle, function(v) Config.Aimbot.Toggle = v end)
    MakeToggle(aimSec, "Wall Check", Config.Aimbot.WallCheck, function(v) Config.Aimbot.WallCheck = v end)
    MakeToggle(aimSec, "Team Check", Config.Aimbot.TeamCheck, function(v) Config.Aimbot.TeamCheck = v end)
    MakeToggle(aimSec, "Offset to Move Direction", Config.Aimbot.OffsetToMove, function(v) Config.Aimbot.OffsetToMove = v end)

    local fovSec = MakeSection(CP, "FOV", true)
    MakeToggle(fovSec, "Show FOV Circle", Config.Aimbot.FOVEnabled, function(v) Config.Aimbot.FOVEnabled = v end)
    MakeSlider(fovSec, "FOV Size", 10, 500, Config.Aimbot.FOV, function(v) Config.Aimbot.FOV = v end)

    local smoothSec = MakeSection(CP, "Smoothness & Offset", true)
    MakeSlider(smoothSec, "Smoothness x100", 0, 50, math.floor(Config.Aimbot.Smoothness * 100), function(v) Config.Aimbot.Smoothness = v / 100 end)
    MakeSlider(smoothSec, "Offset Amount", 1, 30, Config.Aimbot.OffsetAmount, function(v) Config.Aimbot.OffsetAmount = v end)

    -- ================================================
    -- Tab: Misc
    -- ================================================

    local MP = Pages["Misc"]
    local miscSec = MakeSection(MP, "Visual FX", true)
    MakeToggle(miscSec, "Rainbow Chams", Config.Misc.RainbowChams, function(v) Config.Misc.RainbowChams = v end)

    -- ================================================
    -- Tab: World
    -- ================================================

    local WP = Pages["World"]
    local lightSec = MakeSection(WP, "Lighting", true)

    MakeToggle(lightSec, "Fullbright", Config.World.Fullbright, function(v)
        Config.World.Fullbright = v
        if v then
            Lighting.Brightness     = 10
            Lighting.ClockTime      = 14
            Lighting.FogEnd         = 100000
            Lighting.GlobalShadows  = false
            Lighting.Ambient        = Color3.fromRGB(255,255,255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        else
            Lighting.Brightness     = 1
            Lighting.GlobalShadows  = true
            Lighting.Ambient        = Color3.fromRGB(127,127,127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        end
    end)

    MakeToggle(lightSec, "No Fog", Config.World.NoFog, function(v)
        Config.World.NoFog = v
        Lighting.FogEnd   = v and 100000 or 1000
        Lighting.FogStart = v and 100000 or 0
    end)

    -- ================================================
    -- Tab: Admin
    -- ================================================

    local AP = Pages["Admin"]
    local adminSec = MakeSection(AP, "Account Manager", true)
    Label(adminSec, "Username baru", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 16), Pal.TextDim, 11)
    local NewUserBox = MakeInput(adminSec, "", nil)
    Label(adminSec, "Password baru", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 16), Pal.TextDim, 11)
    local NewPassBox = MakeInput(adminSec, "", nil)

    local AdminStatus = Label(adminSec, "", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 16), Pal.Error, 11, Enum.TextXAlignment.Center)

    local LicenseOut = MakeInput(adminSec, "", nil)
    LicenseOut.TextEditable = false
    LicenseOut.TextColor3   = Pal.Success

    MakeActionButton(adminSec, "➕  Buat Akun + Generate Lisensi", function()
        local u, p = NewUserBox.Text, NewPassBox.Text
        if u == "" or p == "" then
            AdminStatus.TextColor3 = Pal.Error
            AdminStatus.Text = "✗ Username/password kosong"
            return
        end
        local ok, result = CreateAccount(u, p)
        AdminStatus.TextColor3 = ok and Pal.Success or Pal.Error
        AdminStatus.Text = ok and "✓ Akun dibuat" or ("✗ " .. result)
        if ok then LicenseOut.Text = result end
    end)

    local listSec = MakeSection(AP, "Account List", true)
    local AccListLabel = Label(listSec, "", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 80), Pal.TextDim, 11)
    AccListLabel.TextWrapped = true
    AccListLabel.TextYAlignment = Enum.TextYAlignment.Top

    local function RefreshAccList()
        local lines = {}
        for _, a in ipairs(AccountDB) do
            table.insert(lines, string.format("• %s%s", a.username, a.isAdmin and "  [ADMIN]" or ""))
        end
        AccListLabel.Text = table.concat(lines, "\n")
    end
    RefreshAccList()

    SwitchTab("Combat")
end

-- ================================================
-- Init
-- ================================================
