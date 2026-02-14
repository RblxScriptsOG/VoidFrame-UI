--[[
  _________ .__.__ ___ ___ ___.
 /   _____/ _____ |__| |   ____   /   |   \   __ _\_ |__
 \_____  \  /     \|  | |  _/ __ \ /    ~    \  |  \ __ \
 /        \|  Y Y  \  | |_\  ___/ \    Y    /  |  / \_\ \
/_______  /|__|_|  /__|____/\___  > \___|_  /|____/|___  /
        \/       \/             \/        \/           \/
        LIQUID GLASS EDITION v3.0 - FLUID DYNAMICS
--]]

local SmileUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Advanced Liquid Glass Theme
local THEME = {
    -- Base Glass Colors (Multi-layered)
    Glass = {
        Base = Color3.fromRGB(15, 15, 15),
        Layer1 = Color3.fromRGB(25, 25, 25),
        Layer2 = Color3.fromRGB(35, 35, 35),
        Layer3 = Color3.fromRGB(45, 45, 45),
        Highlight = Color3.fromRGB(255, 255, 255),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    
    -- Fluid Accent Colors (Neon-infused)
    Accent = {
        Primary = Color3.fromRGB(0, 170, 255),
        Secondary = Color3.fromRGB(140, 100, 255),
        Tertiary = Color3.fromRGB(255, 50, 150),
        Glow = Color3.fromRGB(100, 200, 255),
        Pulse = Color3.fromRGB(0, 255, 200)
    },
    
    -- Traffic Lights (Liquid Style)
    Traffic = {
        Close = Color3.fromRGB(255, 85, 85),
        Minimize = Color3.fromRGB(255, 190, 60),
        Maximize = Color3.fromRGB(50, 220, 90),
        CloseGlow = Color3.fromRGB(255, 50, 50),
        MinGlow = Color3.fromRGB(255, 170, 40),
        MaxGlow = Color3.fromRGB(40, 200, 80)
    },
    
    -- Transparency Levels (Glass depth)
    Depth = {
        Surface = 0.05,
        Layer1 = 0.15,
        Layer2 = 0.25,
        Layer3 = 0.40,
        Background = 0.60
    },
    
    -- Animation Curves
    Easing = {
        Liquid = Enum.EasingStyle.Back,
        Smooth = Enum.EasingStyle.Quart,
        Bounce = Enum.EasingStyle.Bounce,
        Elastic = Enum.EasingStyle.Elastic
    },
    
    -- Typography
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham
}

-- Utility: Create multi-layered glass effect
local function createLiquidGlass(parent, intensity)
    intensity = intensity or 1
    
    -- Layer 1: Deep background blur simulation
    local base = Instance.new("Frame")
    base.Name = "GlassBase"
    base.Size = UDim2.new(1, 0, 1, 0)
    base.BackgroundColor3 = THEME.Glass.Base
    base.BackgroundTransparency = THEME.Depth.Background * intensity
    base.BorderSizePixel = 0
    base.ZIndex = 1
    base.Parent = parent
    
    -- Layer 2: Mid-depth frosted layer
    local frost = Instance.new("Frame")
    frost.Name = "FrostLayer"
    frost.Size = UDim2.new(1, 0, 1, 0)
    frost.BackgroundColor3 = THEME.Glass.Layer1
    frost.BackgroundTransparency = THEME.Depth.Layer2 * intensity
    frost.BorderSizePixel = 0
    frost.ZIndex = 2
    frost.Parent = parent
    
    -- Layer 3: Surface reflection
    local surface = Instance.new("Frame")
    surface.Name = "Surface"
    surface.Size = UDim2.new(1, 0, 0.5, 0)
    surface.BackgroundColor3 = THEME.Glass.Highlight
    surface.BackgroundTransparency = 0.95
    surface.BorderSizePixel = 0
    surface.ZIndex = 3
    surface.Parent = parent
    
    -- Gradient overlay for liquid effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 220, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(150, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.92),
        NumberSequenceKeypoint.new(0.3, 0.95),
        NumberSequenceKeypoint.new(0.6, 0.97),
        NumberSequenceKeypoint.new(1, 0.98)
    })
    gradient.Rotation = 90
    gradient.Parent = frost
    
    return base
end

-- Utility: Create dynamic shadow with depth
local function createDepthShadow(parent, offset, blur, transparency, color)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DepthShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, offset or 4)
    shadow.Size = UDim2.new(1, blur or 40, 1, blur or 40)
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = color or THEME.Glass.Shadow
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

-- Utility: Create glass stroke with gradient
local function createGlassStroke(parent, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Glass.Highlight
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = 0.8
    
    -- Gradient effect for stroke
    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 220, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    strokeGradient.Transparency = NumberSequence.new(0.7, 0.9, 0.7)
    strokeGradient.Parent = stroke
    
    stroke.Parent = parent
    return stroke
end

-- Advanced Notification System
local notifContainer
local function initNotifications()
    if notifContainer then return end
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_LiquidNotifications"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999999
    screen.Parent = CoreGui
    
    notifContainer = Instance.new("Frame")
    notifContainer.Size = UDim2.new(0, 400, 0.9, 0)
    notifContainer.Position = UDim2.new(1, -30, 0, 30)
    notifContainer.AnchorPoint = Vector2.new(1, 0)
    notifContainer.BackgroundTransparency = 1
    notifContainer.ClipsDescendants = false
    notifContainer.Parent = screen
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 16)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = notifContainer
end

function SmileUILib:Notify(title, message, notifyType, duration)
    initNotifications()
    duration = duration or 4
    notifyType = notifyType or "info"
    
    -- Color based on type
    local typeColors = {
        info = THEME.Accent.Primary,
        success = THEME.Accent.Pulse,
        warning = THEME.Accent.Tertiary,
        error = THEME.Traffic.Close
    }
    local accentColor = typeColors[notifyType] or THEME.Accent.Primary
    
    -- Main container
    local notif = Instance.new("Frame")
    notif.BackgroundTransparency = 1
    notif.BorderSizePixel = 0
    notif.ZIndex = 999999
    notif.Parent = notifContainer
    
    -- Multi-layer shadow
    createDepthShadow(notif, 8, 50, 0.4)
    createDepthShadow(notif, 12, 70, 0.6, accentColor)
    
    -- Glass layers
    createLiquidGlass(notif, 0.8)
    
    -- Accent glow border
    local glowBorder = Instance.new("Frame")
    glowBorder.Name = "GlowBorder"
    glowBorder.Size = UDim2.new(1, 4, 1, 4)
    glowBorder.Position = UDim2.new(0, -2, 0, -2)
    glowBorder.BackgroundColor3 = accentColor
    glowBorder.BackgroundTransparency = 0.9
    glowBorder.ZIndex = 0
    glowBorder.Parent = notif
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 16)
    glowCorner.Parent = glowBorder
    
    -- Main corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = notif
    
    -- Glass stroke
    createGlassStroke(notif, 2)
    
    -- Header with liquid effect
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = accentColor
    header.BackgroundTransparency = 0.85
    header.BorderSizePixel = 0
    header.ZIndex = 4
    header.Parent = notif
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 14)
    headerCorner.Parent = header
    
    -- Header gradient
    local headerGrad = Instance.new("UIGradient")
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    headerGrad.Transparency = NumberSequence.new(0.8, 0.95)
    headerGrad.Parent = header
    
    -- Fix header bottom
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = accentColor
    headerFix.BackgroundTransparency = 0.85
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 4
    headerFix.Parent = header
    
    -- Title with icon
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -60, 1, 0)
    titleLbl.Position = UDim2.new(0, 16, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "  " .. (title or "Notification")
    titleLbl.TextColor3 = THEME.Glass.Highlight
    titleLbl.Font = THEME.FontBold
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.ZIndex = 5
    titleLbl.Parent = header
    
    -- Animated close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
    closeBtn.BackgroundColor3 = THEME.Traffic.Close
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 6
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    -- Close icon
    local closeIcon = Instance.new("TextLabel")
    closeIcon.Size = UDim2.new(1, 0, 1, 0)
    closeIcon.BackgroundTransparency = 1
    closeIcon.Text = "×"
    closeIcon.TextColor3 = THEME.Glass.Highlight
    closeIcon.Font = THEME.FontBold
    closeIcon.TextSize = 18
    closeIcon.ZIndex = 7
    closeIcon.Parent = closeBtn
    
    -- Content
    local content = Instance.new("TextLabel")
    content.Position = UDim2.new(0, 16, 0, 50)
    content.Size = UDim2.new(1, -32, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Text = message or ""
    content.TextColor3 = Color3.fromRGB(220, 220, 220)
    content.Font = THEME.Font
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.VerticalAlignment.Top
    content.TextWrapped = true
    content.ZIndex = 4
    content.Parent = notif
    
    -- Calculate size
    local textHeight = content.TextBounds.Y
    local notifHeight = math.max(100, 55 + textHeight)
    notif.Size = UDim2.new(0, 380, 0, notifHeight)
    
    -- Initial animation state
    notif.Position = UDim2.new(0, 500, 0, 0)
    notif.BackgroundTransparency = 1
    header.BackgroundTransparency = 1
    titleLbl.TextTransparency = 1
    content.TextTransparency = 1
    glowBorder.BackgroundTransparency = 1
    
    -- LIQUID ENTRANCE ANIMATION
    local liquidSpring = TweenInfo.new(0.8, THEME.Easing.Liquid, Enum.EasingDirection.Out)
    local smoothFade = TweenInfo.new(0.4, THEME.Easing.Smooth, Enum.EasingDirection.Out)
    
    -- Slide in with elasticity
    TweenService:Create(notif, liquidSpring, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(glowBorder, smoothFade, {BackgroundTransparency = 0.9}):Play()
    TweenService:Create(header, smoothFade, {BackgroundTransparency = 0.85}):Play()
    TweenService:Create(titleLbl, smoothFade, {TextTransparency = 0}):Play()
    TweenService:Create(content, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    -- Pulsing glow effect
    local pulseTween = TweenService:Create(glowBorder, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.85
    })
    pulseTween:Play()
    
    -- Interactive close button
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -37, 0.5, -15)
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(1, -36, 0.5, -14)
        }):Play()
    end)
    
    local function dismiss()
        pulseTween:Cancel()
        local exitSpring = TweenInfo.new(0.6, THEME.Easing.Liquid, Enum.EasingDirection.In)
        local exitFade = TweenInfo.new(0.3, THEME.Easing.Smooth, Enum.EasingDirection.In)
        
        TweenService:Create(notif, exitSpring, {Position = UDim2.new(0, 500, 0, 0)}):Play()
        TweenService:Create(header, exitFade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLbl, exitFade, {TextTransparency = 1}):Play()
        TweenService:Create(content, exitFade, {TextTransparency = 1}):Play()
        TweenService:Create(glowBorder, exitFade, {BackgroundTransparency = 1}):Play()
        
        task.delay(0.6, function() notif:Destroy() end)
    end
    
    closeBtn.MouseButton1Click:Connect(dismiss)
    task.delay(duration, dismiss)
end

-- MAIN WINDOW WITH LIQUID GLASS
function SmileUILib:CreateWindow(title, width, height)
    width = width or 800
    height = height or 600
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_Liquid_" .. math.floor(tick()*1000)
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    
    -- Main container with depth
    local main = Instance.new("Frame")
    main.Name = "LiquidMain"
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = screen
    
    -- Multi-dimensional shadow system
    local shadow1 = createDepthShadow(main, 4, 30, 0.3)
    local shadow2 = createDepthShadow(main, 8, 50, 0.4)
    local shadow3 = createDepthShadow(main, 16, 80, 0.5, THEME.Accent.Primary)
    
    -- LIQUID GLASS BACKGROUND SYSTEM
    -- Layer 1: Ambient glow
    local ambientGlow = Instance.new("Frame")
    ambientGlow.Name = "AmbientGlow"
    ambientGlow.Size = UDim2.new(1, 40, 1, 40)
    ambientGlow.Position = UDim2.new(0, -20, 0, -20)
    ambientGlow.BackgroundColor3 = THEME.Accent.Primary
    ambientGlow.BackgroundTransparency = 0.95
    ambientGlow.ZIndex = 0
    ambientGlow.Parent = main
    
    local ambientCorner = Instance.new("UICorner")
    ambientCorner.CornerRadius = UDim.new(0, 24)
    ambientCorner.Parent = ambientGlow
    
    -- Layer 2: Main glass body
    createLiquidGlass(main, 1)
    
    -- Layer 3: Gradient overlay for liquid effect
    local liquidOverlay = Instance.new("Frame")
    liquidOverlay.Name = "LiquidOverlay"
    liquidOverlay.Size = UDim2.new(1, 0, 1, 0)
    liquidOverlay.BackgroundTransparency = 1
    liquidOverlay.ZIndex = 5
    liquidOverlay.Parent = main
    
    -- Animated gradient
    local liquidGradient = Instance.new("UIGradient")
    liquidGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.Accent.Primary),
        ColorSequenceKeypoint.new(0.5, THEME.Accent.Secondary),
        ColorSequenceKeypoint.new(1, THEME.Accent.Tertiary)
    })
    liquidGradient.Transparency = NumberSequence.new(0.97, 0.95, 0.97)
    liquidGradient.Rotation = 45
    liquidGradient.Parent = liquidOverlay
    
    -- Animate gradient
    spawn(function()
        while main and main.Parent do
            for i = 0, 360, 1 do
                if not liquidGradient then break end
                liquidGradient.Rotation = i
                RunService.RenderStepped:Wait()
            end
        end
    end)
    
    -- Main corners
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = main
    
    -- Glass border with glow
    local mainStroke = createGlassStroke(main, 2)
    
    -- LIQUID HEADER (macOS Style)
    local header = Instance.new("Frame")
    header.Name = "LiquidHeader"
    header.Size = UDim2.new(1, 0, 0, 58)
    header.BackgroundColor3 = THEME.Glass.Layer2
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.ZIndex = 10
    header.Parent = main
    
    -- Header liquid gradient
    local headerGrad = Instance.new("UIGradient")
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
    })
    headerGrad.Transparency = NumberSequence.new(0.9, 0.95)
    headerGrad.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    -- Fix header bottom
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 12)
    headerFix.Position = UDim2.new(0, 0, 1, -12)
    headerFix.BackgroundColor3 = THEME.Glass.Layer2
    headerFix.BackgroundTransparency = 0.1
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 10
    headerFix.Parent = header
    
    -- LIQUID TRAFFIC LIGHTS
    local trafficContainer = Instance.new("Frame")
    trafficContainer.Size = UDim2.new(0, 80, 0, 24)
    trafficContainer.Position = UDim2.new(0, 20, 0.5, -12)
    trafficContainer.BackgroundTransparency = 1
    trafficContainer.ZIndex = 11
    trafficContainer.Parent = header
    
    -- Close (Red with pulse)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 16, 0, 16)
    closeBtn.Position = UDim2.new(0, 0, 0.5, -8)
    closeBtn.BackgroundColor3 = THEME.Traffic.Close
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 12
    closeBtn.Parent = trafficContainer
    
    local closeGlow = Instance.new("Frame")
    closeGlow.Size = UDim2.new(1, 6, 1, 6)
    closeGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    closeGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    closeGlow.BackgroundColor3 = THEME.Traffic.CloseGlow
    closeGlow.BackgroundTransparency = 0.8
    closeGlow.ZIndex = 11
    closeGlow.Parent = closeBtn
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    local closeGlowCorner = Instance.new("UICorner")
    closeGlowCorner.CornerRadius = UDim.new(1, 0)
    closeGlowCorner.Parent = closeGlow
    
    -- Minimize (Yellow)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.Size = UDim2.new(0, 16, 0, 16)
    minBtn.Position = UDim2.new(0, 24, 0.5, -8)
    minBtn.BackgroundColor3 = THEME.Traffic.Minimize
    minBtn.Text = ""
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 12
    minBtn.Parent = trafficContainer
    
    local minGlow = Instance.new("Frame")
    minGlow.Size = UDim2.new(1, 6, 1, 6)
    minGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    minGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    minGlow.BackgroundColor3 = THEME.Traffic.MinGlow
    minGlow.BackgroundTransparency = 0.8
    minGlow.ZIndex = 11
    minGlow.Parent = minBtn
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn
    
    -- Maximize (Green)
    local maxBtn = Instance.new("TextButton")
    maxBtn.Name = "Maximize"
    maxBtn.Size = UDim2.new(0, 16, 0, 16)
    maxBtn.Position = UDim2.new(0, 48, 0.5, -8)
    maxBtn.BackgroundColor3 = THEME.Traffic.Maximize
    maxBtn.Text = ""
    maxBtn.AutoButtonColor = false
    maxBtn.ZIndex = 12
    maxBtn.Parent = trafficContainer
    
    local maxGlow = Instance.new("Frame")
    maxGlow.Size = UDim2.new(1, 6, 1, 6)
    maxGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    maxGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    maxGlow.BackgroundColor3 = THEME.Traffic.MaxGlow
    maxGlow.BackgroundTransparency = 0.8
    maxGlow.ZIndex = 11
    maxGlow.Parent = maxBtn
    
    local maxCorner = Instance.new("UICorner")
    maxCorner.CornerRadius = UDim.new(1, 0)
    maxCorner.Parent = maxBtn
    
    -- Title with liquid effect
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 400, 0, 30)
    titleLabel.Position = UDim2.new(0.5, -200, 0.5, -15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Liquid Glass UI"
    titleLabel.TextColor3 = THEME.Glass.Highlight
    titleLabel.Font = THEME.FontBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.ZIndex = 11
    titleLabel.Parent = header
    
    -- LIQUID DRAG PHYSICS
    local dragging = false
    local dragStart, startPos
    local velocity = Vector2.new(0, 0)
    local lastPos = main.Position
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            -- Lift effect with shadow expansion
            TweenService:Create(main, TweenInfo.new(0.3, THEME.Easing.Smooth), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, startPos.Y.Offset - 10)
            }):Play()
            TweenService:Create(shadow3, TweenInfo.new(0.3), {ImageTransparency = 0.3}):Play()
            TweenService:Create(ambientGlow, TweenInfo.new(0.3), {BackgroundTransparency = 0.9}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            main.Position = newPos
            
            -- Calculate velocity for momentum
            velocity = Vector2.new(delta.X, delta.Y)
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            
            -- Drop effect with bounce
            TweenService:Create(main, TweenInfo.new(0.5, THEME.Easing.Liquid), {
                Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset + 10)
            }):Play()
            TweenService:Create(shadow3, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
            TweenService:Create(ambientGlow, TweenInfo.new(0.3), {BackgroundTransparency = 0.95}):Play()
        end
    end)
    
    -- Traffic light interactions with liquid feedback
    local function setupTrafficLight(btn, glow, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
            TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
            TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
        end)
    end
    
    setupTrafficLight(closeBtn, closeGlow, THEME.Traffic.Close, THEME.Traffic.CloseGlow)
    setupTrafficLight(minBtn, minGlow, THEME.Traffic.Minimize, THEME.Traffic.MinGlow)
    setupTrafficLight(maxBtn, maxGlow, THEME.Traffic.Maximize, THEME.Traffic.MaxGlow)
    
    -- Close with liquid shrink
    closeBtn.MouseButton1Click:Connect(function()
        local shrinkTween = TweenService:Create(main, TweenInfo.new(0.5, THEME.Easing.Liquid, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset + width/2, main.Position.Y.Scale, main.Position.Y.Offset + height/2)
        })
        shrinkTween:Play()
        shrinkTween.Completed:Connect(function() screen:Destroy() end)
    end)
    
    -- Minimize with liquid collapse
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        if not minimized then
            minimized = true
            TweenService:Create(main, TweenInfo.new(0.5, THEME.Easing.Liquid, Enum.EasingDirection.In), {
                Size = UDim2.new(0, width, 0, 58)
            }):Play()
        else
            minimized = false
            TweenService:Create(main, TweenInfo.new(0.6, THEME.Easing.Liquid, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, width, 0, height)
            }):Play()
        end
    end)
    
    -- LIQUID SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Name = "LiquidSidebar"
    sidebar.Size = UDim2.new(0, 200, 1, -58)
    sidebar.Position = UDim2.new(0, 0, 0, 58)
    sidebar.BackgroundColor3 = THEME.Glass.Layer1
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 8
    sidebar.Parent = main
    
    -- Sidebar gradient
    local sideGrad = Instance.new("UIGradient")
    sideGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 210, 255))
    })
    sideGrad.Transparency = NumberSequence.new(0.92, 0.96)
    sideGrad.Parent = sidebar
    
    -- Content area
    local content = Instance.new("Frame")
    content.Name = "LiquidContent"
    content.Size = UDim2.new(1, -216, 1, -74)
    content.Position = UDim2.new(0, 208, 0, 66)
    content.BackgroundTransparency = 1
    content.ZIndex = 8
    content.Parent = main
    
    -- Window API
    local window = {}
    local activePage = nil
    local tabs = {}
    
    function window:AddTab(tabName, icon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "Tab"
        tabBtn.Size = UDim2.new(1, -16, 0, 48)
        tabBtn.Position = UDim2.new(0, 8, 0, 0)
        tabBtn.BackgroundColor3 = THEME.Accent.Primary
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = "  " .. tabName
        tabBtn.TextColor3 = THEME.Glass.Highlight
        tabBtn.Font = THEME.Font
        tabBtn.TextSize = 15
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.ZIndex = 9
        tabBtn.Parent = sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = tabBtn
        
        -- Liquid hover effect
        local hoverGlow = Instance.new("Frame")
        hoverGlow.Size = UDim2.new(1, 8, 1, 8)
        hoverGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        hoverGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        hoverGlow.BackgroundColor3 = THEME.Accent.Primary
        hoverGlow.BackgroundTransparency = 1
        hoverGlow.ZIndex = 8
        hoverGlow.Parent = tabBtn
        
        local hoverCorner = Instance.new("UICorner")
        hoverCorner.CornerRadius = UDim.new(0, 12)
        hoverCorner.Parent = hoverGlow
        
        -- Page with liquid scroll
        local page = Instance.new("ScrollingFrame")
        page.Name = tabName .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = THEME.Accent.Primary
        page.ScrollBarImageTransparency = 0.6
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.ZIndex = 8
        page.Parent = content
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 16)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = page
        
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 40)
        end)
        
        -- Liquid tab interactions
        tabBtn.MouseEnter:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.9,
                    TextColor3 = THEME.Accent.Glow
                }):Play()
                TweenService:Create(hoverGlow, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.95
                }):Play()
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(0.3), {
                    BackgroundTransparency = 1,
                    TextColor3 = THEME.Glass.Highlight
                }):Play()
                TweenService:Create(hoverGlow, TweenInfo.new(0.3), {
                    BackgroundTransparency = 1
                }):Play()
            end
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            if activePage == page then return end
            
            -- Deselect current with liquid fade
            if activePage then
                activePage.Visible = false
                for _, t in pairs(tabs) do
                    if t.page == activePage then
                        TweenService:Create(t.button, TweenInfo.new(0.3), {
                            BackgroundTransparency = 1,
                            TextColor3 = THEME.Glass.Highlight
                        }):Play()
                        TweenService:Create(t.hoverGlow, TweenInfo.new(0.3), {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end
            end
            
            -- Select new with liquid bloom
            page.Visible = true
            activePage = page
            
            TweenService:Create(tabBtn, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.7,
                TextColor3 = THEME.Glass.Highlight
            }):Play()
            TweenService:Create(hoverGlow, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.8
            }):Play()
            
            -- Page entrance with liquid slide
            page.Position = UDim2.new(0, 30, 0, 0)
            page.BackgroundTransparency = 0.5
            TweenService:Create(page, TweenInfo.new(0.5, THEME.Easing.Liquid), {
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
        end)
        
        table.insert(tabs, {button = tabBtn, page = page, hoverGlow = hoverGlow})
        
        if #tabs == 1 then
            tabBtn.BackgroundTransparency = 0.7
            tabBtn.TextColor3 = THEME.Glass.Highlight
            hoverGlow.BackgroundTransparency = 0.8
            page.Visible = true
            activePage = page
        end
        
        -- TAB API WITH LIQUID COMPONENTS
        local tabAPI = {}
        
        function tabAPI:AddSection(title)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, -16, 0, 40)
            section.BackgroundTransparency = 1
            section.Parent = page
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = title
            lbl.TextColor3 = THEME.Accent.Glow
            lbl.Font = THEME.FontBold
            lbl.TextSize = 18
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = section
            
            -- Underline effect
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, 0, 0, 2)
            line.Position = UDim2.new(0, 0, 1, -4)
            line.BackgroundColor3 = THEME.Accent.Primary
            line.BackgroundTransparency = 0.5
            line.Parent = section
            
            TweenService:Create(line, TweenInfo.new(0.8, THEME.Easing.Liquid), {Size = UDim2.new(0.3, 0, 0, 2)}):Play()
            
            return section
        end
        
        function tabAPI:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -16, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.Font = THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = page
            return lbl
        end
        
        function tabAPI:AddSpacer(height)
            local spacer = Instance.new("Frame")
            spacer.Size = UDim2.new(1, 0, 0, height or 12)
            spacer.BackgroundTransparency = 1
            spacer.Parent = page
            return spacer
        end
        
        -- LIQUID TOGGLE
        function tabAPI:AddToggle(name, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -16, 0, 56)
            frame.BackgroundColor3 = THEME.Glass.Layer1
            frame.BackgroundTransparency = 0.5
            frame.Parent = page
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = frame
            
            -- Glass stroke
            createGlassStroke(frame, 1.5)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.65, 0, 1, 0)
            lbl.Position = UDim2.new(0, 20, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = THEME.Glass.Highlight
            lbl.Font = THEME.Font
            lbl.TextSize = 15
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            
            -- Liquid track
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 56, 0, 30)
            track.Position = UDim2.new(1, -76, 0.5, -15)
            track.BackgroundColor3 = default and THEME.Accent.Primary or Color3.fromRGB(60, 60, 60)
            track.BackgroundTransparency = default and 0.3 or 0.6
            track.Parent = frame
            
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            
            -- Glow effect
            local glow = Instance.new("Frame")
            glow.Size = UDim2.new(1, 12, 1, 12)
            glow.Position = UDim2.new(0.5, 0, 0.5, 0)
            glow.AnchorPoint = Vector2.new(0.5, 0.5)
            glow.BackgroundColor3 = THEME.Accent.Glow
            glow.BackgroundTransparency = default and 0.7 or 1
            glow.ZIndex = 0
            glow.Parent = track
            
            local gc = Instance.new("UICorner")
            gc.CornerRadius = UDim.new(1, 0)
            gc.Parent = glow
            
            -- Liquid knob
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 26, 0, 26)
            knob.Position = UDim2.new(default and 1 or 0, default and -28 or 2, 0.5, -13)
            knob.BackgroundColor3 = THEME.Glass.Highlight
            knob.Parent = track
            
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            
            -- Knob shadow
            local knobShadow = createDepthShadow(knob, 2, 10, 0.6)
            knobShadow.ZIndex = 0
            
            -- Liquid interaction
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    default = not default
                    
                    local liquidMove = TweenInfo.new(0.4, THEME.Easing.Liquid)
                    local colorShift = TweenInfo.new(0.3, THEME.Easing.Smooth)
                    
                    TweenService:Create(knob, liquidMove, {
                        Position = UDim2.new(default and 1 or 0, default and -28 or 2, 0.5, -13)
                    }):Play()
                    
                    TweenService:Create(track, colorShift, {
                        BackgroundColor3 = default and THEME.Accent.Primary or Color3.fromRGB(60, 60, 60),
                        BackgroundTransparency = default and 0.3 or 0.6
                    }):Play()
                    
                    TweenService:Create(glow, colorShift, {
                        BackgroundTransparency = default and 0.7 or 1
                    }):Play()
                    
                    if callback then callback(default) end
                end
            end)
            
            -- Hover effects
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end)
            
            return frame
        end
        
        -- LIQUID BUTTON
        function tabAPI:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -16, 0, 50)
            btn.BackgroundColor3 = THEME.Accent.Primary
            btn.BackgroundTransparency = 0.2
            btn.Text = text
            btn.TextColor3 = THEME.Glass.Highlight
            btn.Font = THEME.FontBold
            btn.TextSize = 16
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.AutoButtonColor = false
            btn.Parent = page
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = btn
            
            -- Multi-layer glow
            local glow1 = Instance.new("Frame")
            glow1.Size = UDim2.new(1, 8, 1, 8)
            glow1.Position = UDim2.new(0.5, 0, 0.5, 0)
            glow1.AnchorPoint = Vector2.new(0.5, 0.5)
            glow1.BackgroundColor3 = THEME.Accent.Primary
            glow1.BackgroundTransparency = 1
            glow1.ZIndex = 0
            glow1.Parent = btn
            
            local g1c = Instance.new("UICorner")
            g1c.CornerRadius = UDim.new(0, 14)
            g1c.Parent = glow1
            
            local glow2 = Instance.new("Frame")
            glow2.Size = UDim2.new(1, 16, 1, 16)
            glow2.Position = UDim2.new(0.5, 0, 0.5, 0)
            glow2.AnchorPoint = Vector2.new(0.5, 0.5)
            glow2.BackgroundColor3 = THEME.Accent.Secondary
            glow2.BackgroundTransparency = 1
            glow2.ZIndex = -1
            glow2.Parent = btn
            
            local g2c = Instance.new("UICorner")
            g2c.CornerRadius = UDim.new(0, 18)
            g2c.Parent = glow2
            
            -- Glass stroke
            createGlassStroke(btn, 2)
            
            -- Liquid press effect
            btn.MouseButton1Click:Connect(function()
                -- Ripple effect
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 46)}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.4, THEME.Easing.Liquid), {Size = UDim2.new(1, -16, 0, 50)}):Play()
                
                if callback then callback() end
            end)
            
            -- Hover with liquid expansion
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.1,
                    Size = UDim2.new(1, -12, 0, 54)
                }):Play()
                TweenService:Create(glow1, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
                TweenService:Create(glow2, TweenInfo.new(0.3), {BackgroundTransparency = 0.9}):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.2,
                    Size = UDim2.new(1, -16, 0, 50)
                }):Play()
                TweenService:Create(glow1, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TweenService:Create(glow2, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end)
            
            return btn
        end
        
        -- LIQUID SLIDER
        function tabAPI:AddSlider(name, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -16, 0, 80)
            frame.BackgroundColor3 = THEME.Glass.Layer1
            frame.BackgroundTransparency = 0.5
            frame.Parent = page
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = frame
            
            createGlassStroke(frame, 1.5)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -24, 0, 28)
            lbl.Position = UDim2.new(0, 16, 0, 8)
            lbl.BackgroundTransparency = 1
            lbl.Text = name .. ": " .. default
            lbl.TextColor3 = THEME.Glass.Highlight
            lbl.Font = THEME.Font
            lbl.TextSize = 15
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            -- Track with liquid fill
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -32, 0, 10)
            track.Position = UDim2.new(0, 16, 0, 50)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            track.BackgroundTransparency = 0.5
            track.Parent = frame
            
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            
            -- Liquid fill
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = THEME.Accent.Primary
            fill.BackgroundTransparency = 0.2
            fill.Parent = track
            
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            
            -- Fill glow
            local fillGlow = Instance.new("Frame")
            fillGlow.Size = UDim2.new(1, 6, 1, 6)
            fillGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
            fillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
            fillGlow.BackgroundColor3 = THEME.Accent.Glow
            fillGlow.BackgroundTransparency = 0.6
            fillGlow.ZIndex = 0
            fillGlow.Parent = fill
            
            local fgc = Instance.new("UICorner")
            fgc.CornerRadius = UDim.new(1, 0)
            fgc.Parent = fillGlow
            
            -- Liquid knob
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 22, 0, 22)
            knob.Position = UDim2.new(1, -11, 0.5, -11)
            knob.BackgroundColor3 = THEME.Glass.Highlight
            knob.Parent = fill
            
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            
            local knobStroke = Instance.new("UIStroke")
            knobStroke.Color = THEME.Accent.Primary
            knobStroke.Thickness = 3
            knobStroke.Parent = knob
            
            -- Interaction
            local dragging = false
            
            local function updateSlider(input)
                local rel = math.clamp(
                    (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                    0, 1
                )
                
                -- Liquid fill animation
                TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
                
                local value = math.round(min + (max - min) * rel)
                lbl.Text = name .. ": " .. value
                
                if callback then callback(value) end
            end
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            -- Hover
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end)
            
            return frame
        end
        
        -- LIQUID DROPDOWN
        function tabAPI:AddDropdown(name, options, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -16, 0, 54)
            frame.BackgroundColor3 = THEME.Glass.Layer1
            frame.BackgroundTransparency = 0.5
            frame.Parent = page
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = frame
            
            createGlassStroke(frame, 1.5)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.4, 0, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = THEME.Glass.Highlight
            lbl.Font = THEME.Font
            lbl.TextSize = 15
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            -- Selected button
            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.55, -12, 0, 38)
            selected.Position = UDim2.new(0.45, 0, 0.5, -19)
            selected.BackgroundColor3 = THEME.Glass.Layer2
            selected.BackgroundTransparency = 0.3
            selected.Text = default or options[1]
            selected.TextColor3 = THEME.Glass.Highlight
            selected.Font = THEME.Font
            selected.TextSize = 14
            selected.TextTruncate = Enum.TextTruncate.AtEnd
            selected.AutoButtonColor = false
            selected.Parent = frame
            
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0, 10)
            sc.Parent = selected
            
            -- Arrow
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 20)
            arrow.Position = UDim2.new(1, -28, 0.5, -10)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = THEME.Accent.Primary
            arrow.Font = THEME.FontBold
            arrow.TextSize = 12
            arrow.Parent = selected
            
            -- Liquid dropdown menu
            local dropFrame = Instance.new("Frame")
            dropFrame.BackgroundColor3 = THEME.Glass.Layer1
            dropFrame.BackgroundTransparency = 0.05
            dropFrame.Visible = false
            dropFrame.ZIndex = 100
            dropFrame.Parent = screen
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 12)
            dropCorner.Parent = dropFrame
            
            createGlassStroke(dropFrame, 2)
            
            -- Drop shadow
            createDepthShadow(dropFrame, 6, 30, 0.4)
            
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Padding = UDim.new(0, 6)
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropFrame
            
            for _, v in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -12, 0, 36)
                optBtn.Position = UDim2.new(0, 6, 0, 0)
                optBtn.BackgroundColor3 = THEME.Accent.Primary
                optBtn.BackgroundTransparency = 1
                optBtn.Text = v
                optBtn.TextColor3 = THEME.Glass.Highlight
                optBtn.Font = THEME.Font
                optBtn.TextSize = 14
                optBtn.AutoButtonColor = false
                optBtn.ZIndex = 101
                optBtn.Parent = dropFrame
                
                local optC = Instance.new("UICorner")
                optC.CornerRadius = UDim.new(0, 8)
                optC.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    selected.Text = v
                    dropFrame.Visible = false
                    arrow.Text = "▼"
                    if callback then callback(v) end
                end)
                
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.8
                    }):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
            end
            
            dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, math.min(250, dropLayout.AbsoluteContentSize.Y + 12))
            end)
            
            local function updatePosition()
                local absPos = selected.AbsolutePosition
                dropFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + selected.AbsoluteSize.Y + 6)
            end
            
            selected.MouseButton1Click:Connect(function()
                dropFrame.Visible = not dropFrame.Visible
                arrow.Text = dropFrame.Visible and "▲" or "▼"
                if dropFrame.Visible then
                    updatePosition()
                    -- Liquid open animation
                    dropFrame.BackgroundTransparency = 1
                    dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, 0)
                    TweenService:Create(dropFrame, TweenInfo.new(0.3, THEME.Easing.Liquid), {
                        BackgroundTransparency = 0.05,
                        Size = UDim2.new(0, selected.AbsoluteSize.X, 0, math.min(250, dropLayout.AbsoluteContentSize.Y + 12))
                    }):Play()
                end
            end)
            
            -- Hover effects
            selected.MouseEnter:Connect(function()
                TweenService:Create(selected, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
            end)
            selected.MouseLeave:Connect(function()
                TweenService:Create(selected, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end)
            
            return frame
        end
        
        -- LIQUID KEYBIND
        function tabAPI:AddKeybind(name, defaultKey, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -16, 0, 54)
            frame.BackgroundColor3 = THEME.Glass.Layer1
            frame.BackgroundTransparency = 0.5
            frame.Parent = page
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = frame
            
            createGlassStroke(frame, 1.5)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = THEME.Glass.Highlight
            lbl.Font = THEME.Font
            lbl.TextSize = 15
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 140, 0, 36)
            btn.Position = UDim2.new(1, -156, 0.5, -18)
            btn.BackgroundColor3 = THEME.Glass.Layer2
            btn.BackgroundTransparency = 0.3
            btn.Text = defaultKey.Name
            btn.TextColor3 = THEME.Accent.Glow
            btn.Font = THEME.FontBold
            btn.TextSize = 14
            btn.AutoButtonColor = false
            btn.Parent = frame
            
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = btn
            
            -- Glow effect when listening
            local listenGlow = Instance.new("Frame")
            listenGlow.Size = UDim2.new(1, 8, 1, 8)
            listenGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
            listenGlow.AnchorPoint = Vector2.new(0.5, 0.5)
            listenGlow.BackgroundColor3 = THEME.Accent.Primary
            listenGlow.BackgroundTransparency = 1
            listenGlow.ZIndex = 0
            listenGlow.Parent = btn
            
            local lgc = Instance.new("UICorner")
            lgc.CornerRadius = UDim.new(0, 10)
            lgc.Parent = listenGlow
            
            local listening = false
            
            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "Press key..."
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = THEME.Accent.Primary,
                    BackgroundTransparency = 0.3
                }):Play()
                TweenService:Create(listenGlow, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    BackgroundTransparency = 0.7
                }):Play()
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    btn.Text = input.KeyCode.Name
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEME.Glass.Layer2,
                        BackgroundTransparency = 0.3
                    }):Play()
                    TweenService:Create(listenGlow, TweenInfo.new(0.1), {
                        BackgroundTransparency = 1
                    }):Play()
                    if callback then callback(input.KeyCode) end
                end
            end)
            
            -- Hover
            btn.MouseEnter:Connect(function()
                if not listening then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
                end
            end)
            btn.MouseLeave:Connect(function()
                if not listening then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
                end
            end)
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end)
            
            return frame
        end
        
        return tabAPI
    end
    
    -- LIQUID ENTRANCE ANIMATION
    main.Size = UDim2.new(0, 0, 0, 0)
    main.BackgroundTransparency = 1
    ambientGlow.BackgroundTransparency = 1
    
    local entranceSpring = TweenInfo.new(0.9, THEME.Easing.Liquid, Enum.EasingDirection.Out)
    
    TweenService:Create(main, entranceSpring, {
        Size = UDim2.new(0, width, 0, height),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(ambientGlow, TweenInfo.new(1), {BackgroundTransparency = 0.95}):Play()
    
    -- Staggered shadow animation
    task.delay(0.1, function()
        TweenService:Create(shadow1, TweenInfo.new(0.6), {ImageTransparency = 0.3}):Play()
    end)
    task.delay(0.2, function()
        TweenService:Create(shadow2, TweenInfo.new(0.6), {ImageTransparency = 0.4}):Play()
    end)
    task.delay(0.3, function()
        TweenService:Create(shadow3, TweenInfo.new(0.6), {ImageTransparency = 0.5}):Play()
    end)
    
    return window
end

return SmileUILib
