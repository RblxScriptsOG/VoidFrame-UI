--[[
  _________ .__.__ ___ ___ ___.
 / _____/ _____ |__| | ____ / | \ __ _\_ |__
 \_____ \ / \| | | _/ __ \ / ~ \ | \ __ \
 / \ Y Y \ | |_\ ___/ \ Y / | / \_\ \
/_______ /__|_| /__|____/\___ > \___|_ /|____/|___ /
        \/ \/ \/ \/ \/
--]]
local SmileUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Updated theme for liquid glassmorphism inspired by macOS with fluid, vibrant effects
local LIQUID_GLASS_THEME = {
    Background = Color3.fromRGB(30, 30, 35), -- Slight blue tint for liquid feel
    GlassBackground = Color3.fromRGB(50, 50, 60), -- Semi-transparent with blue undertone
    GlassTransparency = 0.35, -- More opaque for visible blur simulation
    Header = Color3.fromRGB(40, 40, 50), -- Darker header with depth
    Accent = Color3.fromRGB(0, 150, 255), -- Brighter blue accent for liquid vibe
    AccentDark = Color3.fromRGB(0, 120, 200),
    AccentDarker = Color3.fromRGB(0, 90, 160),
    AccentVeryDark = Color3.fromRGB(20, 20, 30),
    Text = Color3.fromRGB(240, 240, 255), -- Softer white for readability
    TextDim = Color3.fromRGB(180, 180, 200),
    StrokeColor = Color3.fromRGB(90, 90, 110),
    CornerRadius = UDim.new(0, 14), -- Softer, more rounded like macOS
    StrokeThickness = 1.2,
    StrokeTransparency = 0.3, -- Subtle stroke for depth
    Font = Enum.Font.Gotham,
    BlurColor1 = Color3.fromRGB(80, 80, 100), -- Enhanced blur colors for liquid effect
    BlurColor2 = Color3.fromRGB(40, 40, 60),
    BlurColor3 = Color3.fromRGB(100, 100, 120),
    BlurColor4 = Color3.fromRGB(20, 20, 40), -- Extra keypoint for fluidity
    DotClose = Color3.fromRGB(255, 69, 58), -- macOS exact red
    DotMinimize = Color3.fromRGB(255, 189, 46), -- macOS exact yellow
    DotFullscreen = Color3.fromRGB(39, 201, 63) -- macOS exact green
}

-- Enhanced function for liquid glass gradient with more keypoints and wave-like feel
local function addLiquidGlassGradient(frame)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, LIQUID_GLASS_THEME.GlassBackground),
        ColorSequenceKeypoint.new(0.15, LIQUID_GLASS_THEME.BlurColor1),
        ColorSequenceKeypoint.new(0.4, LIQUID_GLASS_THEME.BlurColor2),
        ColorSequenceKeypoint.new(0.6, LIQUID_GLASS_THEME.BlurColor3),
        ColorSequenceKeypoint.new(0.85, LIQUID_GLASS_THEME.BlurColor4),
        ColorSequenceKeypoint.new(1, LIQUID_GLASS_THEME.GlassBackground)
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, LIQUID_GLASS_THEME.GlassTransparency),
        NumberSequenceKeypoint.new(0.5, LIQUID_GLASS_THEME.GlassTransparency - 0.05),
        NumberSequenceKeypoint.new(1, LIQUID_GLASS_THEME.GlassTransparency)
    })
    gradient.Rotation = 30 -- Adjusted for liquid flow
    gradient.Parent = frame
end

-- Function to add enhanced glow/shadow for liquid depth
local function addLiquidGlowEffect(frame)
    local glow = Instance.new("UIStroke")
    glow.Color = LIQUID_GLASS_THEME.Accent
    glow.Thickness = 2.5
    glow.Transparency = 0.7
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = frame
end

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
    notifContainer.Position = UDim2.new(1, 0, 0, 20)
    notifContainer.AnchorPoint = Vector2.new(1, 0)
    notifContainer.BackgroundTransparency = 1
    notifContainer.ClipsDescendants = true
    notifContainer.Parent = screen
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = notifContainer
end

function SmileUILib:Notify(title, message, duration)
    initNotifications()
    duration = duration or 3.7
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = LIQUID_GLASS_THEME.GlassBackground
    notif.BackgroundTransparency = 1
    notif.BorderSizePixel = 0
    notif.ZIndex = 999999
    notif.Parent = notifContainer
    addLiquidGlassGradient(notif) -- Liquid glass effect
    addLiquidGlowEffect(notif) -- Add glow for depth
    local corner = Instance.new("UICorner")
    corner.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
    corner.Parent = notif
    local stroke = Instance.new("UIStroke")
    stroke.Color = LIQUID_GLASS_THEME.StrokeColor
    stroke.Thickness = LIQUID_GLASS_THEME.StrokeThickness
    stroke.Transparency = 1
    stroke.Parent = notif
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundColor3 = LIQUID_GLASS_THEME.Header
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0
    header.Parent = notif
    addLiquidGlassGradient(header) -- Liquid glass header
    addLiquidGlowEffect(header)
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
    hcorner.Parent = header
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "> " .. (title or "INFO"):upper()
    titleLbl.TextTransparency = 1
    titleLbl.TextColor3 = LIQUID_GLASS_THEME.Text
    titleLbl.Font = LIQUID_GLASS_THEME.Font
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = header
    local content = Instance.new("TextLabel")
    content.Position = UDim2.new(0, 10, 0, 36)
    content.BackgroundTransparency = 1
    content.Text = message or ""
    content.TextTransparency = 1
    content.TextColor3 = LIQUID_GLASS_THEME.Text
    content.Font = LIQUID_GLASS_THEME.Font
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.VerticalAlignment.Top
    content.TextWrapped = true
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Size = UDim2.new(1, -20, 0, 0)
    content.Parent = notif
    local textHeight = content.TextBounds.Y
    local notifHeight = 36 + textHeight + 10
    notif.Size = UDim2.new(0, 0, 0, notifHeight) -- Start small for fluid animation
    local ti = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out) -- Elastic for liquid bounce
    TweenService:Create(notif, ti, {BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency, Size = UDim2.new(0, 400, 0, notifHeight)}):Play()
    TweenService:Create(header, ti, {BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency}):Play()
    TweenService:Create(titleLbl, ti, {TextTransparency = 0}):Play()
    TweenService:Create(content, ti, {TextTransparency = 0}):Play()
    TweenService:Create(stroke, ti, {Transparency = LIQUID_GLASS_THEME.StrokeTransparency}):Play()
    task.delay(duration, function()
        local out_ti = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)
        TweenService:Create(notif, out_ti, {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, notifHeight)}):Play()
        TweenService:Create(header, out_ti, {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLbl, out_ti, {TextTransparency = 1}):Play()
        TweenService:Create(content, out_ti, {TextTransparency = 1}):Play()
        local out = TweenService:Create(stroke, out_ti, {Transparency = 1})
        out:Play()
        out.Completed:Connect(function() notif:Destroy() end)
    end)
end

function SmileUILib:CreateWindow(title, width, height)
    width = width or 580
    height = height or 420
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_" .. math.floor(tick()*1000)
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 0, 0, 0) -- Start small for fluid open
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = LIQUID_GLASS_THEME.GlassBackground
    main.BackgroundTransparency = 1
    main.Active = true
    main.Draggable = true
    main.Parent = screen
    addLiquidGlassGradient(main)
    addLiquidGlowEffect(main)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
    corner.Parent = main
    local stroke = Instance.new("UIStroke")
    stroke.Color = LIQUID_GLASS_THEME.StrokeColor
    stroke.Thickness = LIQUID_GLASS_THEME.StrokeThickness
    stroke.Transparency = LIQUID_GLASS_THEME.StrokeTransparency
    stroke.Parent = main
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = LIQUID_GLASS_THEME.Header
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0
    header.Parent = main
    addLiquidGlassGradient(header)
    addLiquidGlowEffect(header)
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
    hcorner.Parent = header
    -- macOS exact dots with functionality
    local dotClose = Instance.new("TextButton")
    dotClose.Size = UDim2.new(0, 12, 0, 12)
    dotClose.Position = UDim2.new(0, 12, 0.5, -6)
    dotClose.BackgroundColor3 = LIQUID_GLASS_THEME.DotClose
    dotClose.Text = ""
    dotClose.Parent = header
    local dcCorner = Instance.new("UICorner")
    dcCorner.CornerRadius = UDim.new(1, 0)
    dcCorner.Parent = dotClose
    local dotMinimize = Instance.new("TextButton")
    dotMinimize.Size = UDim2.new(0, 12, 0, 12)
    dotMinimize.Position = UDim2.new(0, 28, 0.5, -6)
    dotMinimize.BackgroundColor3 = LIQUID_GLASS_THEME.DotMinimize
    dotMinimize.Text = ""
    dotMinimize.Parent = header
    local dmCorner = Instance.new("UICorner")
    dmCorner.CornerRadius = UDim.new(1, 0)
    dmCorner.Parent = dotMinimize
    local dotFullscreen = Instance.new("TextButton")
    dotFullscreen.Size = UDim2.new(0, 12, 0, 12)
    dotFullscreen.Position = UDim2.new(0, 44, 0.5, -6)
    dotFullscreen.BackgroundColor3 = LIQUID_GLASS_THEME.DotFullscreen
    dotFullscreen.Text = ""
    dotFullscreen.Parent = header
    local dfCorner = Instance.new("UICorner")
    dfCorner.CornerRadius = UDim.new(1, 0)
    dfCorner.Parent = dotFullscreen
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0.5, -titleLabel.AbsoluteSize.X / 2, 0, 0) -- Centered like macOS
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "SMILE UI"
    titleLabel.TextColor3 = LIQUID_GLASS_THEME.Text
    titleLabel.Font = LIQUID_GLASS_THEME.Font
    titleLabel.TextSize = 15 -- Smaller for macOS feel
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = header
    dotClose.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 56, 0, 56)
    icon.BackgroundColor3 = LIQUID_GLASS_THEME.Header
    icon.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
    icon.Visible = false
    icon.Draggable = true
    icon.Parent = screen
    addLiquidGlassGradient(icon)
    addLiquidGlowEffect(icon)
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon
    local iconText = Instance.new("TextButton")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "$"
    iconText.TextColor3 = LIQUID_GLASS_THEME.Text
    iconText.Font = LIQUID_GLASS_THEME.Font
    iconText.TextSize = 36
    iconText.Parent = icon
    dotMinimize.MouseButton1Click:Connect(function()
        main.Visible = false
        icon.Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X - 56, 0, main.AbsolutePosition.Y)
        icon.Visible = true
    end)
    iconText.MouseButton1Click:Connect(function()
        icon.Visible = false
        main.Visible = true
    end)
    dotFullscreen.MouseButton1Click:Connect(function()
        -- Fullscreen functionality - toggle full screen
        if main.Size == UDim2.new(0, width, 0, height) then
            main.Size = UDim2.new(1, 0, 1, 0)
            main.Position = UDim2.new(0, 0, 0, 0)
        else
            main.Size = UDim2.new(0, width, 0, height)
            main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
        end
    end)
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0, 152, 1, -52)
    tabs.Position = UDim2.new(0, 12, 0, 48)
    tabs.BackgroundTransparency = 1
    tabs.Parent = main
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 7)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabs
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -176, 1, -52)
    content.Position = UDim2.new(0, 164, 0, 48)
    content.BackgroundTransparency = 1
    content.Parent = main
    local window = {}
    local activePage = nil
    function window:AddTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -12, 0, 38)
        tabBtn.BackgroundColor3 = LIQUID_GLASS_THEME.AccentVeryDark
        tabBtn.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
        tabBtn.Text = tabName
        tabBtn.TextColor3 = LIQUID_GLASS_THEME.TextDim
        tabBtn.Font = LIQUID_GLASS_THEME.Font
        tabBtn.TextSize = 15
        tabBtn.AutoButtonColor = false
        tabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        tabBtn.Parent = tabs
        addLiquidGlassGradient(tabBtn)
        addLiquidGlowEffect(tabBtn)
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
        btnCorner.Parent = tabBtn
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = LIQUID_GLASS_THEME.AccentDark
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Parent = content
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = page
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30)
        end)
        tabBtn.MouseEnter:Connect(function()
            if activePage ~= page then
                local enter_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                TweenService:Create(tabBtn, enter_ti, {
                    BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.15,
                    Size = UDim2.new(1, -12, 0, 40)
                }):Play()
                tabBtn.UIGradient.Rotation = tabBtn.UIGradient.Rotation + 15 -- Fluid rotation
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activePage ~= page then
                local leave_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)
                TweenService:Create(tabBtn, leave_ti, {
                    BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency,
                    Size = UDim2.new(1, -12, 0, 38)
                }):Play()
                tabBtn.UIGradient.Rotation = tabBtn.UIGradient.Rotation - 15
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            if activePage then
                activePage.Visible = false
            end
            page.Visible = true
            activePage = page
            for _, b in tabs:GetChildren() do
                if b:IsA("TextButton") then
                    local click_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    TweenService:Create(b, click_ti, {
                        BackgroundColor3 = (b == tabBtn) and LIQUID_GLASS_THEME.AccentDarker or LIQUID_GLASS_THEME.AccentVeryDark,
                        TextColor3 = (b == tabBtn) and LIQUID_GLASS_THEME.Text or LIQUID_GLASS_THEME.TextDim,
                        BackgroundTransparency = (b == tabBtn) and LIQUID_GLASS_THEME.GlassTransparency - 0.2 or LIQUID_GLASS_THEME.GlassTransparency
                    }):Play()
                end
            end
        end)
        if not activePage then
            tabBtn.BackgroundColor3 = LIQUID_GLASS_THEME.AccentDarker
            tabBtn.TextColor3 = LIQUID_GLASS_THEME.Text
            tabBtn.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.2
            page.Visible = true
            activePage = page
        end
        local tabAPI = {}
        function tabAPI:AddSection(title)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = title
            lbl.TextColor3 = LIQUID_GLASS_THEME.Text
            lbl.Font = LIQUID_GLASS_THEME.Font
            lbl.TextSize = 16
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = page
            return lbl
        end
        function tabAPI:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = LIQUID_GLASS_THEME.TextDim
            lbl.Font = LIQUID_GLASS_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = page
            return lbl
        end
        function tabAPI:AddSpacer(height)
            local spacer = Instance.new("Frame")
            spacer.Size = UDim2.new(1, 0, 0, height or 8)
            spacer.BackgroundTransparency = 1
            spacer.Parent = page
            return spacer
        end
        function tabAPI:AddToggle(name, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 36)
            frame.BackgroundColor3 = LIQUID_GLASS_THEME.AccentVeryDark
            frame.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            frame.Parent = page
            addLiquidGlassGradient(frame)
            addLiquidGlowEffect(frame)
            local c = Instance.new("UICorner")
            c.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.68, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = LIQUID_GLASS_THEME.Text
            lbl.Font = LIQUID_GLASS_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 50, 0, 24)
            track.Position = UDim2.new(1, -62, 0.5, -12)
            track.BackgroundColor3 = default and LIQUID_GLASS_THEME.Accent or LIQUID_GLASS_THEME.AccentDarker
            track.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            track.Parent = frame
            addLiquidGlassGradient(track)
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new(default and 1 or 0, -24, 0, 0)
            knob.BackgroundColor3 = LIQUID_GLASS_THEME.Text
            knob.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.3
            knob.Parent = track
            addLiquidGlassGradient(knob)
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    default = not default
                    local toggle_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    TweenService:Create(knob, toggle_ti, {Position = UDim2.new(default and 1 or 0, -24, 0, 0)}):Play()
                    TweenService:Create(track, toggle_ti, {BackgroundColor3 = default and LIQUID_GLASS_THEME.Accent or LIQUID_GLASS_THEME.AccentDarker}):Play()
                    if callback then callback(default) end
                end
            end)
            return frame
        end
        function tabAPI:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 40)
            btn.BackgroundColor3 = LIQUID_GLASS_THEME.AccentDarker
            btn.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            btn.Text = text
            btn.TextColor3 = LIQUID_GLASS_THEME.Text
            btn.Font = LIQUID_GLASS_THEME.Font
            btn.TextSize = 15
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = page
            addLiquidGlassGradient(btn)
            addLiquidGlowEffect(btn)
            local c = Instance.new("UICorner")
            c.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            c.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            btn.MouseEnter:Connect(function()
                local enter_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                TweenService:Create(btn, enter_ti, {
                    BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.2,
                    Size = UDim2.new(1, -8, 0, 42)
                }):Play()
                btn.UIGradient.Rotation = btn.UIGradient.Rotation + 15
            end)
            btn.MouseLeave:Connect(function()
                local leave_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)
                TweenService:Create(btn, leave_ti, {
                    BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency,
                    Size = UDim2.new(1, -8, 0, 40)
                }):Play()
                btn.UIGradient.Rotation = btn.UIGradient.Rotation - 15
            end)
            return btn
        end
        function tabAPI:AddSlider(name, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 58)
            frame.BackgroundColor3 = LIQUID_GLASS_THEME.AccentVeryDark
            frame.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            frame.Parent = page
            addLiquidGlassGradient(frame)
            addLiquidGlowEffect(frame)
            local c = Instance.new("UICorner")
            c.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 24)
            lbl.Position = UDim2.new(0, 12, 0, 6)
            lbl.BackgroundTransparency = 1
            lbl.Text = name .. ": " .. default
            lbl.TextColor3 = LIQUID_GLASS_THEME.Text
            lbl.Font = LIQUID_GLASS_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 38)
            track.BackgroundColor3 = LIQUID_GLASS_THEME.AccentDarker
            track.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            track.Parent = frame
            addLiquidGlassGradient(track)
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = LIQUID_GLASS_THEME.Accent
            fill.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.1
            fill.Parent = track
            addLiquidGlassGradient(fill)
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(1, -8, 0.5, -8)
            knob.BackgroundColor3 = LIQUID_GLASS_THEME.Text
            knob.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.3
            knob.Parent = fill
            addLiquidGlassGradient(knob)
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            local dragging = false
            track.InputBegan:Connect(function(input)
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
                local rel = math.clamp(
                    (UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                    0, 1
                )
                local slide_ti = TweenInfo.new(0.1, Enum.EasingStyle.Sine)
                TweenService:Create(fill, slide_ti, {Size = UDim2.new(rel, 0, 1, 0)}):Play()
                local value = math.round(min + (max - min) * rel)
                lbl.Text = name .. ": " .. value
                if callback then callback(value) end
            end)
            return frame
        end
        function tabAPI:AddDropdown(name, options, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 40)
            frame.BackgroundColor3 = LIQUID_GLASS_THEME.AccentVeryDark
            frame.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            frame.Parent = page
            addLiquidGlassGradient(frame)
            addLiquidGlowEffect(frame)
            local c = Instance.new("UICorner")
            c.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = LIQUID_GLASS_THEME.Text
            lbl.Font = LIQUID_GLASS_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.48, 0, 0, 32)
            selected.Position = UDim2.new(0.5, 0, 0, 4)
            selected.BackgroundColor3 = LIQUID_GLASS_THEME.AccentDarker
            selected.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            selected.Text = default or options[1]
            selected.TextColor3 = LIQUID_GLASS_THEME.Text
            selected.Font = LIQUID_GLASS_THEME.Font
            selected.TextSize = 14
            selected.TextTruncate = Enum.TextTruncate.AtEnd
            selected.Parent = frame
            addLiquidGlassGradient(selected)
            local sc = Instance.new("UICorner")
            sc.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            sc.Parent = selected
            local dropFrame = Instance.new("Frame")
            dropFrame.BackgroundColor3 = LIQUID_GLASS_THEME.GlassBackground
            dropFrame.BackgroundTransparency = 1
            dropFrame.Visible = false
            dropFrame.ZIndex = 2
            dropFrame.Parent = screen
            addLiquidGlassGradient(dropFrame)
            addLiquidGlowEffect(dropFrame)
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            dropCorner.Parent = dropFrame
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = LIQUID_GLASS_THEME.StrokeColor
            dropStroke.Thickness = LIQUID_GLASS_THEME.StrokeThickness
            dropStroke.Transparency = LIQUID_GLASS_THEME.StrokeTransparency
            dropStroke.Parent = dropFrame
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Padding = UDim.new(0, 4)
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropFrame
            for _, v in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.BackgroundColor3 = LIQUID_GLASS_THEME.AccentDarker
                optBtn.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
                optBtn.Text = v
                optBtn.TextColor3 = LIQUID_GLASS_THEME.Text
                optBtn.Font = LIQUID_GLASS_THEME.Font
                optBtn.TextSize = 14
                optBtn.Parent = dropFrame
                addLiquidGlassGradient(optBtn)
                addLiquidGlowEffect(optBtn)
                local optC = Instance.new("UICorner")
                optC.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
                optC.Parent = optBtn
                optBtn.MouseButton1Click:Connect(function()
                    selected.Text = v
                    dropFrame.Visible = false
                    if callback then callback(v) end
                end)
                optBtn.MouseEnter:Connect(function()
                    local enter_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    TweenService:Create(optBtn, enter_ti, {BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency - 0.2}):Play()
                    optBtn.UIGradient.Rotation = optBtn.UIGradient.Rotation + 15
                end)
                optBtn.MouseLeave:Connect(function()
                    local leave_ti = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)
                    TweenService:Create(optBtn, leave_ti, {BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency}):Play()
                    optBtn.UIGradient.Rotation = optBtn.UIGradient.Rotation - 15
                end)
            end
            dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, dropLayout.AbsoluteContentSize.Y + 8)
            end)
            selected:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                dropFrame.Position = UDim2.new(0, selected.AbsolutePosition.X - main.AbsolutePosition.X, 0, selected.AbsolutePosition.Y - main.AbsolutePosition.Y + selected.AbsoluteSize.Y)
            end)
            dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, dropLayout.AbsoluteContentSize.Y + 8)
            dropFrame.Position = UDim2.new(0, selected.AbsolutePosition.X - main.AbsolutePosition.X, 0, selected.AbsolutePosition.Y - main.AbsolutePosition.Y + selected.AbsoluteSize.Y)
            selected.MouseButton1Click:Connect(function()
                dropFrame.Visible = not dropFrame.Visible
                if dropFrame.Visible then
                    local open_ti = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    TweenService:Create(dropFrame, open_ti, {BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency}):Play()
                else
                    local close_ti = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)
                    TweenService:Create(dropFrame, close_ti, {BackgroundTransparency = 1}):Play()
                end
            end)
            return frame
        end
        function tabAPI:AddKeybind(name, defaultKey, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundColor3 = LIQUID_GLASS_THEME.AccentVeryDark
            frame.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            frame.Parent = page
            addLiquidGlassGradient(frame)
            addLiquidGlowEffect(frame)
            local c = Instance.new("UICorner")
            c.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.62, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = LIQUID_GLASS_THEME.Text
            lbl.Font = LIQUID_GLASS_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 28)
            btn.Position = UDim2.new(1, -112, 0.5, -14)
            btn.BackgroundColor3 = LIQUID_GLASS_THEME.AccentDarker
            btn.BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
            btn.Text = defaultKey.Name
            btn.TextColor3 = LIQUID_GLASS_THEME.Text
            btn.Font = LIQUID_GLASS_THEME.Font
            btn.TextSize = 14
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = frame
            addLiquidGlassGradient(btn)
            local bc = Instance.new("UICorner")
            bc.CornerRadius = LIQUID_GLASS_THEME.CornerRadius
            bc.Parent = btn
            local listening = false
            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
            end)
            local conn = UserInputService.InputBegan:Connect(function(input)
                if not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    btn.Text = input.KeyCode.Name
                    if callback then callback(input.KeyCode) end
                end
            end)
            return frame
        end
        return tabAPI
    end
    -- Fluid window open animation
    local open_ti = TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    TweenService:Create(main, open_ti, {
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency
    }):Play()
    TweenService:Create(header, open_ti, {BackgroundTransparency = LIQUID_GLASS_THEME.GlassTransparency}):Play()
    return window
end
return SmileUILib
