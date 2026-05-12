-- ============================================================================
-- •PIOP• ZENITH V18 - AESTHETIC ULTRA EDITION (STABİL SÜRÜM)
-- YENİ: BAĞIMSIZ KAPANIŞ EKRANI | TELEPORT KORUMASI | AUTOEXEC DOSYA SİSTEMİ
-- ============================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- [0. OTOMATİK BAŞLAMA VE DOSYA SİSTEMİ MANTIĞI]
local StateFileName = "ZenithClosed_State.txt"
local LoadstringURL = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/FPS-CAP-SCR-PT/refs/heads/main/Main.lua"))()'

-- Eğer kullanıcı scripti kapatma tuşuyla kapattıysa, autoexec klasöründen çalışmasını engellemek için kontrol
if isfile and isfile(StateFileName) then
    local state = readfile(StateFileName)
    if state == "CLOSED" then
        -- Durumu sıfırla ki kullanıcı manuel olarak tekrar çalıştırabilsin
        if delfile then delfile(StateFileName) end 
        return -- Scripti burada durdur
    end
end

-- Sunucu değiştirmelerde (Teleport) otomatik tekrar çalışması için sıraya al
if queue_on_teleport then
    queue_on_teleport(LoadstringURL)
end

-- [1. TEMA AYARLARI]
local Theme = {
    Main = Color3.fromRGB(11, 13, 19),
    Secondary = Color3.fromRGB(18, 20, 28),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(240, 240, 250),
    SubText = Color3.fromRGB(160, 165, 180),
    Red = Color3.fromRGB(255, 70, 70),
    Yellow = Color3.fromRGB(255, 200, 0),
    Green = Color3.fromRGB(0, 255, 130),
    Easing = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
}

-- [2. YENİ DONANIM TESPİTİ (120+ DESTEKLİ)]
local MaxHardwareHz = "60"
task.spawn(function()
    if setfpscap then
        setfpscap(999)
        local frameTimes = {}
        for i = 1, 30 do table.insert(frameTimes, RunService.RenderStepped:Wait()) end
        local avg = 0
        for _, t in pairs(frameTimes) do avg = avg + t end
        local detected = math.floor((1 / (avg / #frameTimes)) + 5)
        
        if detected >= 124 then
            MaxHardwareHz = "120+"
        elseif detected >= 63 then
            MaxHardwareHz = "120"
        else
            MaxHardwareHz = "60"
        end
        
        setfpscap(60)
    end
end)

-- [3. ANA GUI]
local Zenith = Instance.new("ScreenGui")
Zenith.Name = "•FPS-CAP-UNLOCKER• by ZENITH"
pcall(function() Zenith.Parent = CoreGui end)

local UI = {}
function UI:Smooth(obj, rad) Instance.new("UICorner", obj).CornerRadius = UDim.new(0, rad) end
function UI:Stroke(obj, color, trans)
    local s = Instance.new("UIStroke", obj)
    s.Thickness = 1.5; s.Color = color or Theme.Accent
    s.Transparency = trans or 0.4; s.ApplyStrokeMode = "Border"
end

-- Yüzer FPS HUD (Düzgün Sayıcı)
local FloatingHUD = Instance.new("Frame", Zenith)
FloatingHUD.Size = UDim2.new(0, 100, 0, 32)
FloatingHUD.Position = UDim2.new(1, -115, 0, 15)
FloatingHUD.BackgroundColor3 = Theme.Secondary
FloatingHUD.Visible = false
UI:Smooth(FloatingHUD, 8)
UI:Stroke(FloatingHUD, Theme.Accent, 0.4)

local HUDLabel = Instance.new("TextLabel", FloatingHUD)
HUDLabel.Size = UDim2.new(1, 0, 1, 0); HUDLabel.BackgroundTransparency = 1; HUDLabel.Font = "GothamBold"; HUDLabel.TextSize = 13; HUDLabel.TextColor3 = Theme.Green; HUDLabel.Text = "FPS: --"

-- [4. ANA PENCERE (CANVASGROUP)]
local Main = Instance.new("CanvasGroup", Zenith)
Main.Size = UDim2.new(0, 460, 0, 420)
Main.Position = UDim2.new(0.5, -230, 0.5, -210)
Main.BackgroundColor3 = Theme.Main
Main.BorderSizePixel = 0
Main.GroupTransparency = 1
UI:Smooth(Main, 18) 
UI:Stroke(Main, Theme.Accent, 0.3)

TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Quart), {GroupTransparency = 0}):Play()

-- [YENİLİK: BAĞIMSIZ KAPANIŞ YÜKLEME EKRANI (SEPARATE MENU)]
local LoadingOverlay = Instance.new("Frame", Zenith)
LoadingOverlay.Size = UDim2.new(1, 0, 1, 0)
LoadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingOverlay.BackgroundTransparency = 0.5
LoadingOverlay.Visible = false
LoadingOverlay.ZIndex = 9999
LoadingOverlay.Active = true -- Arkaya tıklanmayı engeller

local LoadingBox = Instance.new("Frame", LoadingOverlay)
LoadingBox.Size = UDim2.new(0, 320, 0, 80)
LoadingBox.Position = UDim2.new(0.5, -160, 0.5, -40)
LoadingBox.BackgroundColor3 = Theme.Main
UI:Smooth(LoadingBox, 14)
UI:Stroke(LoadingBox, Theme.Accent, 0.3)

local LoadingText = Instance.new("TextLabel", LoadingBox)
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Değişiklikler düzeltiliyor..."
LoadingText.TextColor3 = Theme.Accent
LoadingText.Font = "GothamBold"
LoadingText.TextSize = 16

-- [5. TOPBAR VE BUTONLAR]
local Topbar = Instance.new("Frame", Main)
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundColor3 = Theme.Secondary
Topbar.BorderSizePixel = 0
UI:Smooth(Topbar, 18) 

local TopbarHide = Instance.new("Frame", Topbar)
TopbarHide.Size = UDim2.new(1, 0, 0, 10); TopbarHide.Position = UDim2.new(0, 0, 1, -10); TopbarHide.BackgroundColor3 = Theme.Secondary; TopbarHide.BorderSizePixel = 0; TopbarHide.ZIndex = 0

local Title = Instance.new("TextLabel", Topbar)
Title.Text = "  • FCU • | ZENITH"
Title.Size = UDim2.new(1, -120, 1, 0); Title.TextColor3 = Theme.Text; Title.Font = "GothamBold"; Title.TextSize = 14; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

local Btns = Instance.new("Frame", Topbar)
Btns.Size = UDim2.new(0, 110, 1, 0); Btns.Position = UDim2.new(1, -120, 0, 0); Btns.BackgroundTransparency = 1
local UIList = Instance.new("UIListLayout", Btns)
UIList.FillDirection = "Horizontal"; UIList.HorizontalAlignment = "Right"; UIList.VerticalAlignment = "Center"; UIList.Padding = UDim.new(0, 10)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local MicroBtn = Instance.new("TextButton", Btns)
MicroBtn.LayoutOrder = 1
MicroBtn.Size = UDim2.new(0, 24, 0, 24); MicroBtn.BackgroundColor3 = Theme.Accent; MicroBtn.Text = "▶"; MicroBtn.TextColor3 = Color3.new(1,1,1); MicroBtn.Font = "GothamBold"; MicroBtn.TextSize = 14
MicroBtn.Visible = false; MicroBtn.BackgroundTransparency = 1; MicroBtn.TextTransparency = 1
UI:Smooth(MicroBtn, 12)

local MiniBtn = Instance.new("TextButton", Btns)
MiniBtn.LayoutOrder = 2
MiniBtn.Size = UDim2.new(0, 24, 0, 24); MiniBtn.BackgroundColor3 = Theme.Yellow; MiniBtn.Text = "-"; MiniBtn.TextColor3 = Color3.new(1,1,1); MiniBtn.Font = "GothamBold"; MiniBtn.TextSize = 18; UI:Smooth(MiniBtn, 12)

local CloseBtn = Instance.new("TextButton", Btns)
CloseBtn.LayoutOrder = 3
CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.BackgroundColor3 = Theme.Red; CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = "GothamBold"; CloseBtn.TextSize = 18; UI:Smooth(CloseBtn, 12)

-- KAPATMA TUŞU MANTIĞI EKLENDİ (Bağımsız Kapanış Ekranı)
CloseBtn.MouseButton1Click:Connect(function() 
    -- Ana menüyü gizle ve bağımsız yükleme ekranını göster
    Main.Visible = false
    FloatingHUD.Visible = false
    LoadingOverlay.Visible = true
    
    -- "CLOSED" durumunu kaydet (Autoexec'in diğer oyunda açılmasını engeller)
    if writefile then pcall(function() writefile(StateFileName, "CLOSED") end) end
    
    -- Yazıya hafif bir yanıp sönme efekti verelim
    TweenService:Create(LoadingText, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 0.5}):Play()
    
    task.wait(2) 
    
    if setfpscap then setfpscap(60) end 
    Zenith:Destroy() 
end)

local minimized = false
local isMicro = false

MicroBtn.MouseButton1Click:Connect(function()
    isMicro = not isMicro
    TweenService:Create(MicroBtn, Theme.Easing, {Rotation = isMicro and -180 or 0}):Play()
    TweenService:Create(Main, Theme.Easing, {Size = isMicro and UDim2.new(0, 120, 0, 45) or UDim2.new(0, 460, 0, 45)}):Play()
end)

MiniBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if not minimized and isMicro then
        isMicro = false
        MicroBtn.Rotation = 0
    end
    
    local targetSize = minimized and UDim2.new(0, 460, 0, 45) or UDim2.new(0, 460, 0, 420)
    TweenService:Create(Main, Theme.Easing, {Size = targetSize}):Play()
    
    if minimized then
        MicroBtn.Visible = true
        TweenService:Create(MicroBtn, TweenInfo.new(0.4), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    else
        local fadeOut = TweenService:Create(MicroBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() if not minimized then MicroBtn.Visible = false end end)
    end
end)

-- [İçerik Alanı ve Diğer Modüller...]
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -65); Content.Position = UDim2.new(0, 10, 0, 55); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 2; Content.AutomaticCanvasSize = "Y"; Content.CanvasSize = UDim2.new(0,0,0,0)
UI:Smooth(Content, 10)
local Layout = Instance.new("UIListLayout", Content); Layout.Padding = UDim.new(0, 10); Layout.HorizontalAlignment = "Center"

function UI:Paragraph(title, desc)
    local F = Instance.new("Frame", Content)
    F.Size = UDim2.new(1, -5, 0, 75); F.BackgroundColor3 = Theme.Secondary; UI:Smooth(F, 10); UI:Stroke(F, nil, 0.7)
    local T = Instance.new("TextLabel", F)
    T.Text = "   " .. title:upper(); T.Size = UDim2.new(1, 0, 0, 30); T.TextColor3 = Theme.Accent; T.Font = "GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    local D = Instance.new("TextLabel", F)
    D.Text = "   " .. desc; D.Size = UDim2.new(1, -10, 0, 40); D.Position = UDim2.new(0, 0, 0, 28); D.TextColor3 = Theme.SubText; D.Font = "Gotham"; D.TextSize = 11; D.TextXAlignment = "Left"; D.BackgroundTransparency = 1; D.TextWrapped = true
    return D
end

function UI:Toggle(name, default, callback)
    local B = Instance.new("TextButton", Content)
    B.Size = UDim2.new(1, -5, 0, 45); B.BackgroundColor3 = Theme.Secondary; B.Text = "   " .. name; B.TextColor3 = Theme.Text; B.Font = "GothamMedium"; B.TextSize = 13; B.TextXAlignment = "Left"; B.AutoButtonColor = false
    UI:Smooth(B, 10); UI:Stroke(B, nil, 0.7)
    local S = Instance.new("Frame", B)
    S.Size = UDim2.new(0, 36, 0, 18); S.Position = UDim2.new(1, -48, 0.5, -9); S.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(40,43,53); UI:Smooth(S, 10)
    local I = Instance.new("Frame", S)
    I.Size = UDim2.new(0, 14, 0, 14); I.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); I.BackgroundColor3 = Color3.new(1,1,1); UI:Smooth(I, 8)
    local active = default
    B.MouseButton1Click:Connect(function() active = not active TweenService:Create(I, Theme.Easing, {Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play() TweenService:Create(S, Theme.Easing, {BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(40,43,53)}):Play() callback(active) end)
end

function UI:Slider(name, min, max, default, callback)
    local F = Instance.new("Frame", Content)
    F.Size = UDim2.new(1, -5, 0, 65); F.BackgroundColor3 = Theme.Secondary; UI:Smooth(F, 10); UI:Stroke(F, nil, 0.7)
    local T = Instance.new("TextLabel", F)
    T.Text = "   " .. name; T.Size = UDim2.new(1, 0, 0, 35); T.TextColor3 = Theme.Text; T.Font = "GothamMedium"; T.TextSize = 13; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    local V = Instance.new("TextLabel", F)
    V.Text = tostring(default) .. " "; V.Size = UDim2.new(1, -15, 0, 35); V.TextColor3 = Theme.Accent; V.Font = "GothamBold"; V.TextSize = 13; V.TextXAlignment = "Right"; V.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", F)
    Bar.Size = UDim2.new(1, -30, 0, 6); Bar.Position = UDim2.new(0.5, 0, 0, 48); Bar.AnchorPoint = Vector2.new(0.5, 0); Bar.BackgroundColor3 = Color3.fromRGB(40,43,53); UI:Smooth(Bar, 3)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent; UI:Smooth(Fill, 3)
    local sliding = false; local finalValue = default
    local function Update() local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1) Fill.Size = UDim2.new(p, 0, 1, 0) finalValue = math.floor(min + (max-min)*p) V.Text = tostring(finalValue) .. " " end
    F.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true Content.ScrollingEnabled = false Update() end end)
    UserInputService.InputEnded:Connect(function(input) if sliding then sliding = false Content.ScrollingEnabled = true callback(finalValue) end end)
    UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update() end end)
end

-- ============================================================================
-- [7. SİSTEM MANTIĞI]
-- ============================================================================

local HW_Label = UI:Paragraph("Donanım Raporu", "Analiz ediliyor...")
task.spawn(function()
    while task.wait(1) do
        HW_Label.Text = "   Ekran Kapasitesi: " .. MaxHardwareHz .. " Hz\n   Stabilize Edilmiş Maksimum FPS: " .. MaxHardwareHz
    end
end)

local currentFPSLimit = 60
local isFPSApplyEnabled = false

UI:Toggle("Yüzer FPS Paneli (HUD)", false, function(s) FloatingHUD.Visible = s end)

UI:Toggle("FPS Limitini Uygula", false, function(s)
    isFPSApplyEnabled = s
    if s and setfpscap then
        setfpscap(currentFPSLimit)
    elseif not s and setfpscap then
        setfpscap(60)
    end
end)

UI:Slider("Hedef FPS Değeri", 3, 550, 60, function(val)
    currentFPSLimit = val
    if isFPSApplyEnabled and setfpscap then setfpscap(val) end
end)

-- SMOOTH FPS SAYACI (0.5s GÜNCELLEME)
task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - lastUpdate >= 0.5 then
            local fps = math.floor(frames / (now - lastUpdate))
            HUDLabel.Text = "FPS: " .. fps
            if fps > 55 then HUDLabel.TextColor3 = Theme.Green
            elseif fps > 28 then HUDLabel.TextColor3 = Theme.Yellow
            else HUDLabel.TextColor3 = Theme.Red end
            frames = 0; lastUpdate = now
        end
    end)
end)

-- Sürükleme Mantığı (OOB iptal edildiği için sadece basit sürükleme var)
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input) 
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
        dragging = true; dragStart = input.Position; startPos = Main.Position 
    end 
end)
UserInputService.InputChanged:Connect(function(input) 
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
        local delta = input.Position - dragStart 
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
    end 
end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- ============================================================================
-- [GELİŞTİRİLMİŞ AGRESİF DEV PANEL VE MOTOR OPTİMİZASYONLARI]
-- ============================================================================

-- 1. YENİ BİLEŞEN: Şifre Giriş Alanı
UI:Paragraph("Developer Access", "Panel açmak için şifreyi aşağıya girin.")
local DevTrigger = Instance.new("TextBox", Content)
DevTrigger.Size = UDim2.new(1, -10, 0, 45); DevTrigger.BackgroundColor3 = Theme.Secondary; DevTrigger.TextColor3 = Theme.Accent; DevTrigger.PlaceholderText = "Şifreyi Buraya Yaz..."; DevTrigger.Font = "GothamBold"; DevTrigger.Text = ""; UI:Smooth(DevTrigger, 10); UI:Stroke(DevTrigger, Theme.Accent, 0.6)

-- 2. DEV PANEL TASARIMI
local DevPanel = Instance.new("Frame", Zenith)
DevPanel.Name = "DevPanel"; DevPanel.Size = UDim2.new(0, 280, 0, 220); DevPanel.Position = UDim2.new(1, 50, 0.5, -110); DevPanel.BackgroundTransparency = 1; DevPanel.Visible = false
local DevStroke = UI:Stroke(DevPanel, Color3.new(1,1,1), 0.2); local DevGrad = Instance.new("UIGradient", DevStroke); DevGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,255))})
RunService.RenderStepped:Connect(function() DevGrad.Rotation = (tick() * 120) % 360 end)

local DevInner = Instance.new("Frame", DevPanel); DevInner.Size = UDim2.new(1, 0, 1, 0); DevInner.BackgroundColor3 = Theme.Main; DevInner.BackgroundTransparency = 0.2; UI:Smooth(DevInner, 14)
local PillHandle = Instance.new("TextButton", DevInner); PillHandle.Size = UDim2.new(0, 40, 0, 8); PillHandle.Position = UDim2.new(0.5, -20, 0, 8); PillHandle.BackgroundColor3 = Theme.SubText; PillHandle.Text = ""; UI:Smooth(PillHandle, 10)

-- Panel Sürükleme ve Küçültme (Pill)
local dragging, startPos, dragStart; PillHandle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = i.Position; startPos = DevPanel.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dragStart; DevPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- PARÇACIK EFEKTİ (Tıklama İçin)
local function CreateClickEffect(btn)
    for i = 1, 8 do
        local p = Instance.new("Frame", btn); p.Size = UDim2.new(0, 6, 0, 6); p.Position = UDim2.new(0.5, 0, 0.5, 0); p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1); UI:Smooth(p, 10); p.BorderSizePixel = 0
        local targetPos = UDim2.new(math.random(), 0, math.random(), 0)
        TweenService:Create(p, TweenInfo.new(0.6), {Position = targetPos, BackgroundTransparency = 1, Size = UDim2.new(0,0,0,0)}):Play()
        task.delay(0.6, function() p:Destroy() end)
    end
end

-- OPTİMİZASYON FONKSİYONU ŞABLONU
local function CreateOptButton(name, desc, overdriveMode)
    local B = Instance.new("TextButton", DevInner); B.Size = UDim2.new(1, -20, 0, 55); B.Position = overdriveMode and UDim2.new(0, 10, 0, 130) or UDim2.new(0, 10, 0, 60); B.BackgroundColor3 = Theme.Secondary; B.Text = ""; UI:Smooth(B, 10); UI:Stroke(B, Theme.Accent, 0.7); B.ClipsDescendants = true
    local T = Instance.new("TextLabel", B); T.Text = name; T.Size = UDim2.new(1, 0, 0.5, 0); T.TextColor3 = Theme.Accent; T.Font = "GothamBold"; T.TextSize = 13; T.BackgroundTransparency = 1
    local D = Instance.new("TextLabel", B); D.Text = desc; D.Size = UDim2.new(1, 0, 0.5, 0); D.Position = UDim2.new(0, 0, 0.5, 0); D.TextColor3 = Theme.SubText; D.Font = "Gotham"; D.TextSize = 10; D.BackgroundTransparency = 1
    
    local ProgressFrame = Instance.new("Frame", B); ProgressFrame.Size = UDim2.new(0, 0, 1, 0); ProgressFrame.Position = UDim2.new(0.5, 0, 0, 0); ProgressFrame.BackgroundColor3 = Theme.Green; ProgressFrame.BackgroundTransparency = 0.6; ProgressFrame.BorderSizePixel = 0; UI:Smooth(ProgressFrame, 10); ProgressFrame.ZIndex = 0
    local Perc = Instance.new("TextLabel", B); Perc.Size = UDim2.new(1, 0, 1, 0); Perc.TextColor3 = Color3.new(1,1,1); Perc.Font = "GothamBold"; Perc.TextSize = 18; Perc.Text = ""; Perc.BackgroundTransparency = 1; Perc.ZIndex = 2

    B.MouseButton1Click:Connect(function()
        Instance.new("Sound", B, {SoundId = "rbxassetid://12221967", Volume = 2}):Play(); CreateClickEffect(B)
        TweenService:Create(B, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 50)}):Play(); task.delay(0.1, function() TweenService:Create(B, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 55)}):Play() end)
        
        -- Merkezden iki yöne genişleme animasyonu
        local t = TweenService:Create(ProgressFrame, TweenInfo.new(2.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)})
        t:Play()
        
        task.spawn(function()
            for i = 0, 100, 2 do Perc.Text = "%"..i; task.wait(0.045) end
            Perc.Text = "TAMAMLANDI"; task.wait(1); TweenService:Create(Perc, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        end)

        t.Completed:Connect(function()
            if not overdriveMode then
                -- MOD 1: GÜVENLİ (MOTOR ODAKLI)
                settings().Physics.AllowSleep = true
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Enabled
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                task.spawn(function() while task.wait(10) do collectgarbage("collect") end end)
            else
                -- MOD 2: AGRESİF (LIMITLERİ ZORLA)
                setfpscap(120); settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
                game:GetService("NetworkSettings").IncomingReplicationLag = 0
                Lighting.GlobalShadows = false; Lighting.Brightness = 0
                for _, v in pairs(Workspace:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CastShadow = false; v.Material = Enum.Material.SmoothPlastic 
                    elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
                end
            end
        end)
    end)
end

CreateOptButton("MOTORU STABİLİZE ET", "Kullanıcı deneyimini bozmaz.", false)
CreateOptButton("OVERDRIVE: 120 FPS", "Agresif limit zorlama (Düşük Grafik)", true)

-- Şifre Kontrolü
DevTrigger:GetPropertyChangedSignal("Text"):Connect(function()
    if DevTrigger.Text == "dev-zenith" then
        DevPanel.Visible = true; DevTrigger.Text = "ERİŞİM BAŞARILI"; DevTrigger.TextColor3 = Theme.Green
        TweenService:Create(DevPanel, Theme.Easing, {Position = UDim2.new(1, -300, 0.5, -110)}):Play()
    end
end)

print("• ZENITH V18: AESTHETIC ULTRA LOADED. [Bağımsız Kapanış Ekranı & Otomatik Başlama Aktif]")
