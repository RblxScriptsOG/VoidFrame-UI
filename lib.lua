--[[
  _________ .__.__ ___ ___ ___.
 /   _____// ____ |__| |   ____ / |   \  __ _\_ |__
 \_____  \ <   |  |   |  _/ __ \ / ~    \ |  \ __ \
 /        \___  |  |  |_\  ___/ \  Y   / |  / \_\ \
/_______  / ____/|__|____/\___  > \___|_  /|____/|___  /
        \/ \/                \/        \/            \/
        
        GLASSMORPHISM EDITION - macOS STYLE
--]]

local SmileUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Enhanced Glassmorphism Theme
local DEFAULT_THEME = {
    -- Glass colors with transparency
    GlassBackground = Color3.fromRGB(255, 255, 255),
    GlassBackgroundDark = Color3.fromRGB(28, 28, 30),
    GlassTransparency = 0.15,
    GlassBlur = 24,
    
    -- Header glass effect
    HeaderGlass = Color3.fromRGB(255, 255, 255),
    HeaderTransparency = 0.25,
    HeaderBlur = 32,
    
    -- macOS Traffic Light Colors
    CloseRed = Color3.fromRGB(255, 95, 87),
    CloseRedHover = Color3.fromRGB(255, 70, 60),
    MinimizeYellow = Color3.fromRGB(255, 189, 46),
    MinimizeYellowHover = Color3.fromRGB(230, 170, 35),
    MaximizeGreen = Color3.fromRGB(40, 201, 64),
    MaximizeGreenHover = Color3.fromRGB(35, 180, 55),
    
    -- Accent colors (iOS/macOS blue)
    Accent = Color3.fromRGB(0, 122, 255),
    AccentLight = Color3.fromRGB(10, 132, 255),
    AccentDark = Color3.fromRGB(0, 100, 220),
    AccentGlow = Color3.fromRGB(100, 180, 255),
    
    -- Text colors
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(0, 0, 0),
    TextDim = Color3.fromRGB(235, 235, 235),
    TextDimDark = Color3.fromRGB(120, 120, 120),
    
    -- Glass borders
    StrokeColor = Color3.fromRGB(255, 255, 255),
    StrokeTransparency = 0.7,
    StrokeThickness = 1.2,
    
    -- Shadow
    ShadowColor = Color3.fromRGB(0, 0, 0),
    ShadowTransparency = 0.4,
    
    -- Geometry
    CornerRadius = UDim.new(0, 12),
    HeaderCorner = UDim.new(0, 12),
    Font = Enum.Font.Gotham,
    FontSemibold = Enum.Font.GothamSemibold
}

-- Utility: Create Blur Effect
local function createBlur(parent, size)
    local blur = Instance.new("BlurEffect")
    blur.Size = size or DEFAULT_THEME.GlassBlur
    blur.Parent = parent
    return blur
end

-- Utility: Create Glass Frame with depth
local function createGlassFrame(properties)
    local frame = Instance.new("Frame")
    for k, v in pairs(properties) do
        frame[k] = v
    end
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = properties.CornerRadius or DEFAULT_THEME.CornerRadius
    corner.Parent = frame
    
    -- Glass stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = DEFAULT_THEME.StrokeColor
    stroke.Thickness = DEFAULT_THEME.StrokeThickness
    stroke.Transparency = DEFAULT_THEME.StrokeTransparency
    stroke.Parent = frame
    
    -- Gradient overlay for glass depth
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 210))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0.95)
    })
    gradient.Rotation = 90
    gradient.Parent = frame
    
    return frame
end

-- Notification Container with Glass Effect
local notifContainer
local function initNotifications()
    if notifContainer then return end
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileNotifications"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999999
    screen.Parent = CoreGui
    
    notifContainer = Instance.new("Frame")
    notifContainer.Size = UDim2.new(0, 420, 0.8, 0)
    notifContainer.Position = UDim2.new(1, -20, 0, 20)
    notifContainer.AnchorPoint = Vector2.new(1, 0)
    notifContainer.BackgroundTransparency = 1
    notifContainer.ClipsDescendants = false
    notifContainer.Parent = screen
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = notifContainer
end

-- Enhanced Notification with Glassmorphism
function SmileUILib:Notify(title, message, duration, type)
    initNotifications()
    duration = duration or 4
    
    -- Determine color based on type
    local accentColor = DEFAULT_THEME.Accent
    local iconText = "!"
    if type == "success" then
        accentColor = DEFAULT_THEME.MaximizeGreen
        iconText = "✓"
    elseif type == "error" then
        accentColor = DEFAULT_THEME.CloseRed
        iconText = "✕"
    elseif type == "warning" then
        accentColor = DEFAULT_THEME.MinimizeYellow
        iconText = "!"
    end
    
    -- Glass notification container
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = DEFAULT_THEME.GlassBackgroundDark
    notif.BackgroundTransparency = 0.2
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 400, 0, 0)
    notif.ClipsDescendants = true
    notif.Parent = notifContainer
    
    -- Blur effect
    createBlur(notif, 20)
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = notif
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.8
    stroke.Parent = notif
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = DEFAULT_THEME.ShadowColor
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = notif
    
    -- Accent bar (left side)
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notif
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = accentBar
    
    -- Icon circle
    local iconCircle = Instance.new("Frame")
    iconCircle.Size = UDim2.new(0, 36, 0, 36)
    iconCircle.Position = UDim2.new(0, 20, 0, 16)
    iconCircle.BackgroundColor3 = accentColor
    iconCircle.BackgroundTransparency = 0.2
    iconCircle.Parent = notif
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconCircle
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = iconText
    iconLabel.TextColor3 = DEFAULT_THEME.Text
    iconLabel.Font = DEFAULT_THEME.FontSemibold
    iconLabel.TextSize = 20
    iconLabel.Parent = iconCircle
    
    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 0, 24)
    titleLbl.Position = UDim2.new(0, 68, 0, 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title or "Notification"
    titleLbl.TextColor3 = DEFAULT_THEME.Text
    titleLbl.Font = DEFAULT_THEME.FontSemibold
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notif
    
    -- Message
    local content = Instance.new("TextLabel")
    content.Position = UDim2.new(0, 68, 0, 40)
    content.Size = UDim2.new(1, -80, 0, 0)
    content.BackgroundTransparency = 1
    content.Text = message or ""
    content.TextColor3 = DEFAULT_THEME.TextDim
    content.Font = DEFAULT_THEME.Font
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.VerticalAlignment.Top
    content.TextWrapped = true
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Parent = notif
    
    -- Calculate height
    local contentHeight = math.max(70, 40 + content.TextBounds.Y + 20)
    notif.Size = UDim2.new(0, 400, 0, contentHeight)
    
    -- Animation: Slide in with bounce
    notif.Position = UDim2.new(0, 100, 0, 0)
    notif.BackgroundTransparency = 1
    stroke.Transparency = 1
    accentBar.BackgroundTransparency = 1
    iconCircle.BackgroundTransparency = 1
    iconLabel.TextTransparency = 1
    titleLbl.TextTransparency = 1
    content.TextTransparency = 1
    shadow.ImageTransparency = 1
    
    local ti = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local fadeTi = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Entrance animations
    TweenService:Create(notif, ti, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.2}):Play()
    TweenService:Create(shadow, fadeTi, {ImageTransparency = 0.5}):Play()
    TweenService:Create(stroke, fadeTi, {Transparency = 0.8}):Play()
    TweenService:Create(accentBar, fadeTi, {BackgroundTransparency = 0}):Play()
    TweenService:Create(iconCircle, fadeTi, {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(iconLabel, fadeTi, {TextTransparency = 0}):Play()
    TweenService:Create(titleLbl, fadeTi, {TextTransparency = 0}):Play()
    TweenService:Create(content, fadeTi, {TextTransparency = 0}):Play()
    
    -- Auto close
    task.delay(duration, function()
        local outTi = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local slideOutTi = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        
        TweenService:Create(notif, slideOutTi, {Position = UDim2.new(0, 450, 0, 0)}):Play()
        TweenService:Create(notif, outTi, {BackgroundTransparency = 1}):Play()
        TweenService:Create(shadow, outTi, {ImageTransparency = 1}):Play()
        TweenService:Create(stroke, outTi, {Transparency = 1}):Play()
        
        task.delay(0.4, function()
            notif:Destroy()
        end)
    end)
end

-- Main Window Creation with macOS Glass Style
function SmileUILib:CreateWindow(title, width, height)
    width = width or 700
    height = height or 500
    
    -- ScreenGui with blur support
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_Glass_" .. math.floor(tick()*1000)
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    
    -- Shadow container
    local shadowContainer = Instance.new("ImageLabel")
    shadowContainer.Name = "Shadow"
    shadowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    shadowContainer.BackgroundTransparency = 1
    shadowContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadowContainer.Size = UDim2.new(0, width + 60, 0, height + 60)
    shadowContainer.ZIndex = -1
    shadowContainer.Image = "rbxassetid://6014261993"
    shadowContainer.ImageColor3 = DEFAULT_THEME.ShadowColor
    shadowContainer.ImageTransparency = 0.6
    shadowContainer.ScaleType = Enum.ScaleType.Slice
    shadowContainer.SliceCenter = Rect.new(49, 49, 450, 450)
    shadowContainer.Parent = screen
    
    -- Main glass window
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    main.BackgroundColor3 = DEFAULT_THEME.GlassBackgroundDark
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = screen
    
    -- Blur effect
    createBlur(main, 30)
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = DEFAULT_THEME.CornerRadius
    corner.Parent = main
    
    -- Glass stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = DEFAULT_THEME.StrokeColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.6
    stroke.Parent = main
    
    -- Header with glass effect
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 52)
    header.BackgroundColor3 = DEFAULT_THEME.HeaderGlass
    header.BackgroundTransparency = 0.4
    header.BorderSizePixel = 0
    header.Parent = main
    
    -- Header blur (stronger)
    createBlur(header, 40)
    
    -- Header gradient overlay
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 240, 245))
    })
    headerGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    headerGradient.Rotation = 180
    headerGradient.Parent = header
    
    -- macOS Traffic Light Buttons Container
    local trafficLights = Instance.new("Frame")
    trafficLights.Size = UDim2.new(0, 70, 0, 12)
    trafficLights.Position = UDim2.new(0, 20, 0, 20)
    trafficLights.BackgroundTransparency = 1
    trafficLights.Parent = header
    
    -- Close Button (Red)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 12, 0, 12)
    closeBtn.Position = UDim2.new(0, 0, 0, 0)
    closeBtn.BackgroundColor3 = DEFAULT_THEME.CloseRed
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = trafficLights
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    -- Minimize Button (Yellow)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.Size = UDim2.new(0, 12, 0, 12)
    minBtn.Position = UDim2.new(0, 20, 0, 0)
    minBtn.BackgroundColor3 = DEFAULT_THEME.MinimizeYellow
    minBtn.Text = ""
    minBtn.AutoButtonColor = false
    minBtn.Parent = trafficLights
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn
    
    -- Maximize/Restore Button (Green)
    local maxBtn = Instance.new("TextButton")
    maxBtn.Name = "Maximize"
    maxBtn.Size = UDim2.new(0, 12, 0, 12)
    maxBtn.Position = UDim2.new(0, 40, 0, 0)
    maxBtn.BackgroundColor3 = DEFAULT_THEME.MaximizeGreen
    maxBtn.Text = ""
    maxBtn.AutoButtonColor = false
    maxBtn.Parent = trafficLights
    
    local maxCorner = Instance.new("UICorner")
    maxCorner.CornerRadius = UDim.new(1, 0)
    maxCorner.Parent = maxBtn
    
    -- Button hover effects
    local function setupTrafficLightHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    setupTrafficLightHover(closeBtn, DEFAULT_THEME.CloseRed, DEFAULT_THEME.CloseRedHover)
    setupTrafficLightHover(minBtn, DEFAULT_THEME.MinimizeYellow, DEFAULT_THEME.MinimizeYellowHover)
    setupTrafficLightHover(maxBtn, DEFAULT_THEME.MaximizeGreen, DEFAULT_THEME.MaximizeGreenHover)
    
    -- Title in header (centered like macOS)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -200, 1, 0)
    titleLabel.Position = UDim2.new(0.5, -((1 - 200)/2), 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Smile UI"
    titleLabel.TextColor3 = DEFAULT_THEME.Text
    titleLabel.Font = DEFAULT_THEME.FontSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = header
    
    -- Draggable functionality
    local dragging = false
    local dragStart, startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            -- Scale effect on drag start
            TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, width * 0.98, 0, height * 0.98)}):Play()
            TweenService:Create(shadowContainer, TweenInfo.new(0.2), {ImageTransparency = 0.4}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            shadowContainer.Position = main.Position
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            -- Restore scale
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, width, 0, height)}):Play()
            TweenService:Create(shadowContainer, TweenInfo.new(0.3), {ImageTransparency = 0.6}):Play()
        end
    end)
    
    -- Sidebar (Glass effect)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, -52)
    sidebar.Position = UDim2.new(0, 0, 0, 52)
    sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
    sidebar.BackgroundTransparency = 0.5
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    
    -- Sidebar gradient
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 65)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 42))
    })
    sidebarGradient.Rotation = 90
    sidebarGradient.Parent = sidebar
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 0)
    sidebarCorner.Parent = sidebar
    
    -- Fix corners for sidebar
    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size = UDim2.new(1, 0, 0, 20)
    sidebarFix.Position = UDim2.new(0, 0, 1, -20)
    sidebarFix.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Parent = sidebar
    
    -- Tab container
    local tabs = Instance.new("ScrollingFrame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(1, -20, 1, -40)
    tabs.Position = UDim2.new(0, 10, 0, 20)
    tabs.BackgroundTransparency = 1
    tabs.ScrollBarThickness = 0
    tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabs.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabs
    
    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -196, 1, -68)
    content.Position = UDim2.new(0, 188, 0, 60)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    content.Parent = main
    
    -- Minimized icon (floating glass orb)
    local icon = Instance.new("Frame")
    icon.Name = "MinimizedIcon"
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.BackgroundColor3 = DEFAULT_THEME.GlassBackgroundDark
    icon.BackgroundTransparency = 0.2
    icon.Visible = false
    icon.Active = true
    icon.Parent = screen
    
    createBlur(icon, 20)
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = DEFAULT_THEME.StrokeColor
    iconStroke.Thickness = 2
    iconStroke.Transparency = 0.5
    iconStroke.Parent = icon
    
    local iconShadow = Instance.new("ImageLabel")
    iconShadow.Name = "Shadow"
    iconShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    iconShadow.BackgroundTransparency = 1
    iconShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    iconShadow.Size = UDim2.new(1, 20, 1, 20)
    iconShadow.ZIndex = -1
    iconShadow.Image = "rbxassetid://6014261993"
    iconShadow.ImageColor3 = DEFAULT_THEME.ShadowColor
    iconShadow.ImageTransparency = 0.5
    iconShadow.ScaleType = Enum.ScaleType.Slice
    iconShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    iconShadow.Parent = icon
    
    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "S"
    iconText.TextColor3 = DEFAULT_THEME.Accent
    iconText.Font = DEFAULT_THEME.FontSemibold
    iconText.TextSize = 28
    iconText.Parent = icon
    
    -- Button connections
    closeBtn.MouseButton1Click:Connect(function()
        local closeTi = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(main, closeTi, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset + width/2, main.Position.Y.Scale, main.Position.Y.Offset + height/2)}):Play()
        TweenService:Create(shadowContainer, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
        task.delay(0.3, function()
            screen:Destroy()
        end)
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        -- Minimize animation
        local minimizeTi = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(main, minimizeTi, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset + width/2, main.Position.Y.Scale, main.Position.Y.Offset + height/2)}):Play()
        TweenService:Create(shadowContainer, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        
        task.delay(0.4, function()
            main.Visible = false
            icon.Position = UDim2.new(0, main.AbsolutePosition.X + width - 80, 0, main.AbsolutePosition.Y + height - 80)
            icon.Visible = true
            
            -- Pop in animation for icon
            icon.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(icon, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        end)
    end)
    
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Pop out animation
            TweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            
            task.delay(0.3, function()
                icon.Visible = false
                main.Visible = true
                main.Size = UDim2.new(0, 0, 0, 0)
                
                -- Restore animation
                TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, width, 0, height)}):Play()
                TweenService:Create(shadowContainer, TweenInfo.new(0.4), {ImageTransparency = 0.6}):Play()
            end)
        end
    end)
    
    -- Window API
    local window = {}
    local activePage = nil
    local tabsList = {}
    
    function window:AddTab(tabName, icon)
        -- Glass tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 42)
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tabBtn.BackgroundTransparency = 0.7
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabs
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = tabBtn
        
        -- Icon (if provided)
        local iconLabel
        if icon then
            iconLabel = Instance.new("TextLabel")
            iconLabel.Size = UDim2.new(0, 24, 0, 24)
            iconLabel.Position = UDim2.new(0, 12, 0.5, -12)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Text = icon
            iconLabel.TextColor3 = DEFAULT_THEME.TextDim
            iconLabel.Font = DEFAULT_THEME.Font
            iconLabel.TextSize = 18
            iconLabel.Parent = tabBtn
        end
        
        -- Tab text
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, icon and -50 or -24, 1, 0)
        textLabel.Position = UDim2.new(0, icon and 44 or 16, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = tabName
        textLabel.TextColor3 = DEFAULT_THEME.TextDim
        textLabel.Font = DEFAULT_THEME.FontSemibold
        textLabel.TextSize = 14
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = tabBtn
        
        -- Selection indicator (glass pill)
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0, 0)
        indicator.Position = UDim2.new(0, 0, 0.5, 0)
        indicator.AnchorPoint = Vector2.new(0, 0.5)
        indicator.BackgroundColor3 = DEFAULT_THEME.Accent
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.Parent = tabBtn
        
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(0, 2)
        indCorner.Parent = indicator
        
        -- Content page
        local page = Instance.new("ScrollingFrame")
        page.Name = tabName .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = DEFAULT_THEME.Accent
        page.ScrollBarImageTransparency = 0.7
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Parent = content
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 12)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = page
        
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Hover effects
        tabBtn.MouseEnter:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
                if iconLabel then
                    TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = DEFAULT_THEME.Text}):Play()
                end
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
                if iconLabel then
                    TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = DEFAULT_THEME.TextDim}):Play()
                end
            end
        end)
        
        -- Click handler
        tabBtn.MouseButton1Click:Connect(function()
            if activePage == page then return end
            
            -- Hide current page with fade
            if activePage then
                TweenService:Create(activePage, TweenInfo.new(0.2), {ScrollBarImageTransparency = 1}):Play()
                task.delay(0.1, function()
                    activePage.Visible = false
                end)
            end
            
            -- Show new page
            page.Visible = true
            page.ScrollBarImageTransparency = 1
            TweenService:Create(page, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0.7}):Play()
            activePage = page
            
            -- Update all tabs
            for _, tabData in ipairs(tabsList) do
                local isActive = tabData.page == page
                TweenService:Create(tabData.button, TweenInfo.new(0.25), {
                    BackgroundTransparency = isActive and 0.3 or 0.7,
                    BackgroundColor3 = isActive and DEFAULT_THEME.AccentDark or Color3.fromRGB(0, 0, 0)
                }):Play()
                TweenService:Create(tabData.text, TweenInfo.new(0.2), {
                    TextColor3 = isActive and DEFAULT_THEME.Text or DEFAULT_THEME.TextDim
                }):Play()
                tabData.indicator.Visible = isActive
                if isActive then
                    TweenService:Create(tabData.indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 20)}):Play()
                else
                    TweenService:Create(tabData.indicator, TweenInfo.new( 0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                end
                if tabData.icon then
                    TweenService:Create(tabData.icon, TweenInfo.new(0.2), {
                        TextColor3 = isActive and DEFAULT_THEME.Accent or DEFAULT_THEME.TextDim
                    }):Play()
                end
            end
        end)
        
        table.insert(tabsList, {
            button = tabBtn,
            text = textLabel,
            icon = iconLabel,
            indicator = indicator,
            page = page
        })
        
        -- Activate first tab
        if not activePage then
            tabBtn.BackgroundTransparency = 0.3
            tabBtn.BackgroundColor3 = DEFAULT_THEME.AccentDark
            textLabel.TextColor3 = DEFAULT_THEME.Text
            indicator.Visible = true
            indicator.Size = UDim2.new(0, 3, 0, 20)
            if iconLabel then
                iconLabel.TextColor3 = DEFAULT_THEME.Accent
            end
            page.Visible = true
            activePage = page
        end
        
        -- Tab API
        local tabAPI = {}
        
        function tabAPI:AddSection(title)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, -16, 0, 0)
            section.AutomaticSize = Enum.AutomaticSize.Y
            section.BackgroundTransparency = 1
            section.Parent = page
            
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, 0, 0, 24)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = title
            titleLbl.TextColor3 = DEFAULT_THEME.Text
            titleLbl.Font = DEFAULT_THEME.FontSemibold
            titleLbl.TextSize = 18
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = section
            
            local underline = Instance.new("Frame")
            underline.Size = UDim2.new(0, 40, 0, 2)
            underline.Position = UDim2.new(0, 0, 0, 26)
            underline.BackgroundColor3 = DEFAULT_THEME.Accent
            underline.BorderSizePixel = 0
            underline.Parent = section
            
            local contentPad = Instance.new("Frame")
            contentPad.Size = UDim2.new(1, 0, 0, 8)
            contentPad.BackgroundTransparency = 1
            contentPad.Parent = section
            
            return section
        end
        
        function tabAPI:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -16, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = DEFAULT_THEME.TextDim
            lbl.Font = DEFAULT_THEME.Font
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
        
        -- Glass Toggle Switch
        function tabAPI:AddToggle(name, default, callback)
            local frame = createGlassFrame({
                Size = UDim2.new(1, -16, 0, 48),
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                BackgroundTransparency = 0.6,
                Parent = page
            })
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.65, 0, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.FontSemibold
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            
            -- iOS style toggle track
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 52, 0, 28)
            track.Position = UDim2.new(1, -68, 0.5, -14)
            track.BackgroundColor3 = default and DEFAULT_THEME.Accent or Color3.fromRGB(120, 120, 128)
            track.BorderSizePixel = 0
            track.Parent = frame
            
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            
            -- Knob with shadow
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new(default and 1 or 0, default and -26 or 2, 0.5, -12)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.Parent = track
            
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            
            -- Knob shadow
            local knobShadow = Instance.new("ImageLabel")
            knobShadow.BackgroundTransparency = 1
            knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
            knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            knobShadow.Size = UDim2.new(1, 6, 1, 6)
            knobShadow.ZIndex = -1
            knobShadow.Image = "rbxassetid://6014261993"
            knobShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            knobShadow.ImageTransparency = 0.6
            knobShadow.ScaleType = Enum.ScaleType.Slice
            knobShadow.SliceCenter = Rect.new(10, 10, 118, 118)
            knobShadow.Parent = knob
            
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    default = not default
                    
                    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    TweenService:Create(knob, ti, {Position = UDim2.new(default and 1 or 0, default and -26 or 2, 0.5, -12)}):Play()
                    TweenService:Create(track, ti, {BackgroundColor3 = default and DEFAULT_THEME.Accent or Color3.fromRGB(120, 120, 128)}):Play()
                    
                    if callback then callback(default) end
                end
            end)
            
            return frame
        end
        
        -- Glass Button
        function tabAPI:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -16, 0, 46)
            btn.BackgroundColor3 = DEFAULT_THEME.Accent
            btn.BackgroundTransparency = 0.2
            btn.Text = text
            btn.TextColor3 = DEFAULT_THEME.Text
            btn.Font = DEFAULT_THEME.FontSemibold
            btn.TextSize = 15
            btn.AutoButtonColor = false
            btn.Parent = page
            
            createBlur(btn, 10)
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 10)
            c.Parent = btn
            
            local stroke = Instance.new("UIStroke")
            stroke.Color = DEFAULT_THEME.AccentLight
            stroke.Thickness = 1.5
            stroke.Transparency = 0.5
            stroke.Parent = btn
            
            -- Gradient overlay
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
            })
            gradient.Transparency = NumberSequence.new(0.8, 0.9)
            gradient.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                -- Ripple effect
                local ripple = Instance.new("Frame")
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.7
                ripple.BorderSizePixel = 0
                ripple.Position = UDim2.new(0, UserInputService:GetMouseLocation().X - btn.AbsolutePosition.X, 0, UserInputService:GetMouseLocation().Y - btn.AbsolutePosition.Y)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.Parent = btn
                
                local rc = Instance.new("UICorner")
                rc.CornerRadius = UDim.new(1, 0)
                rc.Parent = ripple
                
                TweenService:Create(ripple, TweenInfo.new(0.5), {Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0, UserInputService:GetMouseLocation().X - btn.AbsolutePosition.X - 100, 0, UserInputService:GetMouseLocation().Y - btn.AbsolutePosition.Y - 100), BackgroundTransparency = 1}):Play()
                task.delay(0.5, function() ripple:Destroy() end)
                
                if callback then callback() end
            end)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
            end)
            
            return btn
        end
        
        -- Glass Slider
        function tabAPI:AddSlider(name, min, max, default, callback)
            local frame = createGlassFrame({
                Size = UDim2.new(1, -16, 0, 70),
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                BackgroundTransparency = 0.6,
                Parent = page
            })
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -24, 0, 28)
            lbl.Position = UDim2.new(0, 14, 0, 8)
            lbl.BackgroundTransparency = 1
            lbl.Text = name .. ": " .. default
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.FontSemibold
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            -- Track background
            local trackBg = Instance.new("Frame")
            trackBg.Size = UDim2.new(1, -28, 0, 6)
            trackBg.Position = UDim2.new(0, 14, 0, 46)
            trackBg.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
            trackBg.BorderSizePixel = 0
            trackBg.Parent = frame
            
            local tbgc = Instance.new("UICorner")
            tbgc.CornerRadius = UDim.new(1, 0)
            tbgc.Parent = trackBg
            
            -- Fill
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = DEFAULT_THEME.Accent
            fill.BorderSizePixel = 0
            fill.Parent = trackBg
            
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            
            -- Glow effect
            local glow = Instance.new("Frame")
            glow.Size = UDim2.new(1, 0, 1, 0)
            glow.BackgroundColor3 = DEFAULT_THEME.AccentGlow
            glow.BackgroundTransparency = 0.6
            glow.BorderSizePixel = 0
            glow.Parent = fill
            
            local gc = Instance.new("UICorner")
            gc.CornerRadius = UDim.new(1, 0)
            gc.Parent = glow
            
            -- Knob
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 20, 0, 20)
            knob.Position = UDim2.new(1, -10, 0.5, -10)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.Parent = fill
            
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            
            -- Knob shadow
            local knobShadow = Instance.new("ImageLabel")
            knobShadow.BackgroundTransparency = 1
            knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
            knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            knobShadow.Size = UDim2.new(1, 8, 1, 8)
            knobShadow.ZIndex = -1
            knobShadow.Image = "rbxassetid://6014261993"
            knobShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            knobShadow.ImageTransparency = 0.5
            knobShadow.ScaleType = Enum.ScaleType.Slice
            knobShadow.SliceCenter = Rect.new(10, 10, 118, 118)
            knobShadow.Parent = knob
            
            local dragging = false
            
            trackBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                local rel = math.clamp((UserInputService:GetMouseLocation().X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                local value = math.round(min + (max - min) * rel)
                lbl.Text = name .. ": " .. value
                if callback then callback(value) end
            end)
            
            return frame
        end
        
        -- Glass Dropdown
        function tabAPI:AddDropdown(name, options, default, callback)
            local frame = createGlassFrame({
                Size = UDim2.new(1, -16, 0, 48),
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                BackgroundTransparency = 0.6,
                Parent = page
            })
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.4, 0, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.FontSemibold
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.52, 0, 0, 36)
            selected.Position = UDim2.new(0.46, 0, 0.5, -18)
            selected.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
            selected.BackgroundTransparency = 0.4
            selected.Text = default or options[1]
            selected.TextColor3 = DEFAULT_THEME.Text
            selected.Font = DEFAULT_THEME.Font
            selected.TextSize = 14
            selected.TextTruncate = Enum.TextTruncate.AtEnd
            selected.AutoButtonColor = false
            selected.Parent = frame
            
            createBlur(selected, 8)
            
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0, 8)
            sc.Parent = selected
            
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 20)
            arrow.Position = UDim2.new(1, -24, 0.5, -10)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = DEFAULT_THEME.TextDim
            arrow.Font = DEFAULT_THEME.Font
            arrow.TextSize = 10
            arrow.Parent = selected
            
            -- Dropdown menu (glass)
            local dropFrame = Instance.new("Frame")
            dropFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            dropFrame.BackgroundTransparency = 0.15
            dropFrame.BorderSizePixel = 0
            dropFrame.Visible = false
            dropFrame.ZIndex = 10
            dropFrame.Parent = screen
            
            createBlur(dropFrame, 25)
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 12)
            dropCorner.Parent = dropFrame
            
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = DEFAULT_THEME.StrokeColor
            dropStroke.Thickness = 1.5
            dropStroke.Transparency = 0.5
            dropStroke.Parent = dropFrame
            
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Padding = UDim.new(0, 4)
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropFrame
            
            for _, v in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -16, 0, 34)
                optBtn.Position = UDim2.new(0, 8, 0, 0)
                optBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
                optBtn.BackgroundTransparency = 1
                optBtn.Text = v
                optBtn.TextColor3 = DEFAULT_THEME.Text
                optBtn.Font = DEFAULT_THEME.Font
                optBtn.TextSize = 14
                optBtn.AutoButtonColor = false
                optBtn.Parent = dropFrame
                
                local optC = Instance.new("UICorner")
                optC.CornerRadius = UDim.new(0, 6)
                optC.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    selected.Text = v
                    dropFrame.Visible = false
                    arrow.Text = "▼"
                    if callback then callback(v) end
                end)
                
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
                end)
                
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                end)
            end
            
            dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X + 20, 0, math.min(dropLayout.AbsoluteContentSize.Y + 16, 200))
            end)
            
            local function updatePosition()
                local absPos = selected.AbsolutePosition
                local mainPos = main.AbsolutePosition
                dropFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + selected.AbsoluteSize.Y + 4)
            end
            
            selected.MouseButton1Click:Connect(function()
                dropFrame.Visible = not dropFrame.Visible
                arrow.Text = dropFrame.Visible and "▲" or "▼"
                if dropFrame.Visible then
                    updatePosition()
                    dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X + 20, 0, 0)
                    TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, selected.AbsoluteSize.X + 20, 0, math.min(dropLayout.AbsoluteContentSize.Y + 16, 200))}):Play()
                end
            end)
            
            -- Close when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dropFrame.Visible then
                    local pos = UserInputService:GetMouseLocation()
                    if pos.X < dropFrame.AbsolutePosition.X or pos.X > dropFrame.AbsolutePosition.X + dropFrame.AbsoluteSize.X or
                       pos.Y < dropFrame.AbsolutePosition.Y or pos.Y > dropFrame.AbsolutePosition.Y + dropFrame.AbsoluteSize.Y then
                        dropFrame.Visible = false
                        arrow.Text = "▼"
                    end
                end
            end)
            
            return frame
        end
        
        -- Glass Keybind
        function tabAPI:AddKeybind(name, defaultKey, callback)
            local frame = createGlassFrame({
                Size = UDim2.new(1, -16, 0, 48),
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                BackgroundTransparency = 0.6,
                Parent = page
            })
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.FontSemibold
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 32)
            btn.Position = UDim2.new(1, -116, 0.5, -16)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
            btn.BackgroundTransparency = 0.4
            btn.Text = defaultKey and defaultKey.Name or "None"
            btn.TextColor3 = DEFAULT_THEME.Text
            btn.Font = DEFAULT_THEME.FontSemibold
            btn.TextSize = 13
            btn.AutoButtonColor = false
            btn.Parent = frame
            
            createBlur(btn, 8)
            
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = btn
            
            local listening = false
            
            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = DEFAULT_THEME.Accent}):Play()
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    btn.Text = input.KeyCode.Name
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 75)}):Play()
                    if callback then callback(input.KeyCode) end
                end
            end)
            
            return frame
        end
        
        return tabAPI
    end
    
    -- Initial entrance animation
    main.Size = UDim2.new(0, width * 0.8, 0, height * 0.8)
    main.BackgroundTransparency = 1
    main.Position = UDim2.new(0.5, -width * 0.4, 0.5, -height * 0.4)
    stroke.Transparency = 1
    shadowContainer.ImageTransparency = 1
    
    local entranceTi = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(main, entranceTi, {
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundTransparency = 0.15
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 0.6}):Play()
    TweenService:Create(shadowContainer, TweenInfo.new(0.5), {ImageTransparency = 0.6}):Play()
    
    return window
end

return SmileUILib
