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
local DEFAULT_THEME = {
    Background = Color3.fromRGB(30, 30, 30),
    BackgroundTransparency = 0.15,
    Header = Color3.fromRGB(40, 40, 40),
    HeaderTransparency = 0,
    Accent = Color3.fromRGB(0, 200, 200),
    AccentDark = Color3.fromRGB(0, 150, 150),
    AccentDarker = Color3.fromRGB(0, 100, 100),
    AccentVeryDark = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(200, 200, 200),
    StrokeColor = Color3.fromRGB(255, 255, 255),
    StrokeThickness = 1,
    StrokeTransparency = 0.75,
    Font = Enum.Font.Gotham,
    ShadowColor = Color3.fromRGB(0, 0, 0),
    ShadowTransparency = 0.85,
    ShadowOffset = Vector2.new(4, 4),
    ShadowBlur = 8  -- Simulated, not real blur
}
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
    local notifShadow = Instance.new("Frame")
    notifShadow.BackgroundColor3 = DEFAULT_THEME.ShadowColor
    notifShadow.BackgroundTransparency = DEFAULT_THEME.ShadowTransparency
    notifShadow.Size = UDim2.new(0, 400 + DEFAULT_THEME.ShadowBlur * 2, 0, 0)
    notifShadow.Position = UDim2.new(0, -DEFAULT_THEME.ShadowBlur, 0, -DEFAULT_THEME.ShadowBlur)
    notifShadow.ZIndex = 999998
    notifShadow.Parent = notifContainer
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = notifShadow
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = DEFAULT_THEME.Background
    notif.BackgroundTransparency = DEFAULT_THEME.BackgroundTransparency
    notif.BorderSizePixel = 0
    notif.ZIndex = 999999
    notif.Parent = notifShadow
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    local stroke = Instance.new("UIStroke")
    stroke.Color = DEFAULT_THEME.StrokeColor
    stroke.Thickness = 1
    stroke.Transparency = DEFAULT_THEME.StrokeTransparency
    stroke.Parent = notif
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundColor3 = DEFAULT_THEME.Header
    header.BackgroundTransparency = DEFAULT_THEME.HeaderTransparency
    header.BorderSizePixel = 0
    header.Parent = notif
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = UDim.new(0, 8)
    hcorner.Parent = header
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "> " .. (title or "INFO"):upper()
    titleLbl.TextColor3 = DEFAULT_THEME.Text
    titleLbl.Font = DEFAULT_THEME.Font
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = header
    local content = Instance.new("TextLabel")
    content.Position = UDim2.new(0, 10, 0, 36)
    content.BackgroundTransparency = 1
    content.Text = message or ""
    content.TextColor3 = DEFAULT_THEME.Text
    content.Font = DEFAULT_THEME.Font
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.VerticalAlignment.Top
    content.TextWrapped = true
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Size = UDim2.new(1, -20, 0, 0)
    content.Parent = notif
    local textHeight = content.TextBounds.Y
    local notifHeight = 36 + textHeight + 10
    notif.Size = UDim2.new(0, 400, 0, notifHeight)
    notifShadow.Size = UDim2.new(0, 400 + DEFAULT_THEME.ShadowBlur * 2, 0, notifHeight + DEFAULT_THEME.ShadowBlur * 2)
    notif.Position = UDim2.new(0, DEFAULT_THEME.ShadowBlur, 0, DEFAULT_THEME.ShadowBlur)
    local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local goalsIn = {Position = UDim2.new(0, -DEFAULT_THEME.ShadowOffset.X, 0, -DEFAULT_THEME.ShadowOffset.Y)}
    TweenService:Create(notif, ti, goalsIn):Play()
    task.delay(duration, function()
        local out_ti = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local goalsOut = {Position = UDim2.new(0, DEFAULT_THEME.ShadowBlur, 0, DEFAULT_THEME.ShadowBlur)}
        local out = TweenService:Create(notif, out_ti, goalsOut)
        out:Play()
        out.Completed:Connect(function() notifShadow:Destroy() end)
    end)
end
function SmileUILib:CreateWindow(title, width, height)
    width = width or 580
    height = height or 420
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_" .. math.floor(tick()*1000)
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, width + DEFAULT_THEME.ShadowBlur * 2, 0, height + DEFAULT_THEME.ShadowBlur * 2)
    shadow.Position = UDim2.new(0.5, -(width + DEFAULT_THEME.ShadowBlur * 2)/2, 0.5, -(height + DEFAULT_THEME.ShadowBlur * 2)/2)
    shadow.BackgroundColor3 = DEFAULT_THEME.ShadowColor
    shadow.BackgroundTransparency = DEFAULT_THEME.ShadowTransparency
    shadow.ZIndex = 0
    shadow.Parent = screen
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 14)
    shadowCorner.Parent = shadow
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0, DEFAULT_THEME.ShadowBlur, 0, DEFAULT_THEME.ShadowBlur)
    main.BackgroundColor3 = DEFAULT_THEME.Background
    main.BackgroundTransparency = DEFAULT_THEME.BackgroundTransparency
    main.Active = true
    main.Draggable = true
    main.ZIndex = 1
    main.Parent = shadow
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main
    local stroke = Instance.new("UIStroke")
    stroke.Color = DEFAULT_THEME.StrokeColor
    stroke.Thickness = DEFAULT_THEME.StrokeThickness
    stroke.Transparency = DEFAULT_THEME.StrokeTransparency
    stroke.Parent = main
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = DEFAULT_THEME.Header
    header.BackgroundTransparency = DEFAULT_THEME.HeaderTransparency
    header.BorderSizePixel = 0
    header.Parent = main
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = UDim.new(0, 10)
    hcorner.Parent = header
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "SMILE UI"
    titleLabel.TextColor3 = DEFAULT_THEME.Text
    titleLabel.Font = DEFAULT_THEME.Font
    titleLabel.TextSize = 21
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = header
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 12, 0, 12)
    closeBtn.Position = UDim2.new(0, 12, 0.5, -6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 12, 0, 12)
    minBtn.Position = UDim2.new(0, 28, 0.5, -6)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 214, 10)
    minBtn.Text = ""
    minBtn.AutoButtonColor = false
    minBtn.Parent = header
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 56, 0, 56)
    icon.BackgroundColor3 = DEFAULT_THEME.Header
    icon.Visible = false
    icon.Draggable = true
    icon.Parent = screen
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon
    local iconText = Instance.new("TextButton")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "$"
    iconText.TextColor3 = DEFAULT_THEME.Text
    iconText.Font = DEFAULT_THEME.Font
    iconText.TextSize = 36
    iconText.Parent = icon
    minBtn.MouseButton1Click:Connect(function()
        main.Parent.Visible = false
        icon.Position = UDim2.new(0, shadow.AbsolutePosition.X + shadow.AbsoluteSize.X - 56 - DEFAULT_THEME.ShadowBlur, 0, shadow.AbsolutePosition.Y + DEFAULT_THEME.ShadowBlur)
        icon.Visible = true
    end)
    iconText.MouseButton1Click:Connect(function()
        icon.Visible = false
        main.Parent.Visible = true
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
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tabBtn.BackgroundTransparency = 0.9
        tabBtn.Text = tabName
        tabBtn.TextColor3 = DEFAULT_THEME.TextDim
        tabBtn.Font = DEFAULT_THEME.Font
        tabBtn.TextSize = 15
        tabBtn.AutoButtonColor = false
        tabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        tabBtn.Parent = tabs
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = DEFAULT_THEME.StrokeColor
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.85
        btnStroke.Parent = tabBtn
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = DEFAULT_THEME.AccentDark
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
                TweenService:Create(tabBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = DEFAULT_THEME.AccentVeryDark,
                    BackgroundTransparency = 0.7
                }):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0.9
                }):Play()
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            if activePage then
                TweenService:Create(activePage, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {CanvasPosition = Vector2.new(0, 0)}):Play()
                activePage.Visible = false
            end
            page.Visible = true
            activePage = page
            for _, b in tabs:GetChildren() do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                        BackgroundColor3 = (b == tabBtn) and DEFAULT_THEME.AccentDarker or Color3.fromRGB(0, 0, 0),
                        BackgroundTransparency = (b == tabBtn) and 0.5 or 0.9,
                        TextColor3 = (b == tabBtn) and DEFAULT_THEME.Text or DEFAULT_THEME.TextDim
                    }):Play()
                end
            end
        end)
        if not activePage then
            tabBtn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            tabBtn.BackgroundTransparency = 0.5
            tabBtn.TextColor3 = DEFAULT_THEME.Text
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
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
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
            spacer.Size = UDim2.new(1, 0, 0, height or 8)
            spacer.BackgroundTransparency = 1
            spacer.Parent = page
            return spacer
        end
        function tabAPI:AddToggle(name, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 36)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = 0.6
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = DEFAULT_THEME.StrokeColor
            stroke.Thickness = 1
            stroke.Transparency = 0.8
            stroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.68, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 50, 0, 24)
            track.Position = UDim2.new(1, -62, 0.5, -12)
            track.BackgroundColor3 = default and DEFAULT_THEME.Accent or DEFAULT_THEME.AccentDarker
            track.BackgroundTransparency = 0.4
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new(default and 1 or 0, -24, 0, 0)
            knob.BackgroundColor3 = DEFAULT_THEME.Text
            knob.Parent = track
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    default = not default
                    TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = UDim2.new(default and 1 or 0, -24, 0, 0)}):Play()
                    TweenService:Create(track, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = default and DEFAULT_THEME.Accent or DEFAULT_THEME.AccentDarker}):Play()
                    if callback then callback(default) end
                end
            end)
            return frame
        end
        function tabAPI:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 40)
            btn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            btn.BackgroundTransparency = 0.5
            btn.Text = text
            btn.TextColor3 = DEFAULT_THEME.Text
            btn.Font = DEFAULT_THEME.Font
            btn.TextSize = 15
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 7)
            c.Parent = btn
            local stroke = Instance.new("UIStroke")
            stroke.Color = DEFAULT_THEME.StrokeColor
            stroke.Thickness = 1
            stroke.Transparency = 0.8
            stroke.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = DEFAULT_THEME.Accent,
                    BackgroundTransparency = 0.3
                }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = DEFAULT_THEME.AccentDarker,
                    BackgroundTransparency = 0.5
                }):Play()
            end)
            return btn
        end
        function tabAPI:AddSlider(name, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 58)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = 0.6
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = DEFAULT_THEME.StrokeColor
            stroke.Thickness = 1
            stroke.Transparency = 0.8
            stroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 24)
            lbl.Position = UDim2.new(0, 12, 0, 6)
            lbl.BackgroundTransparency = 1
            lbl.Text = name .. ": " .. default
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 38)
            track.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            track.BackgroundTransparency = 0.5
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = DEFAULT_THEME.Accent
            fill.Parent = track
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(1, -8, 0.5, -8)
            knob.BackgroundColor3 = DEFAULT_THEME.Text
            knob.Parent = fill
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
                fill.Size = UDim2.new(rel, 0, 1, 0)
                local value = math.round(min + (max - min) * rel)
                lbl.Text = name .. ": " .. value
                if callback then callback(value) end
            end)
            return frame
        end
        function tabAPI:AddDropdown(name, options, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 40)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = 0.6
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = DEFAULT_THEME.StrokeColor
            stroke.Thickness = 1
            stroke.Transparency = 0.8
            stroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.48, 0, 0, 32)
            selected.Position = UDim2.new(0.5, 0, 0, 4)
            selected.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            selected.BackgroundTransparency = 0.5
            selected.Text = default or options[1]
            selected.TextColor3 = DEFAULT_THEME.Text
            selected.Font = DEFAULT_THEME.Font
            selected.TextSize = 14
            selected.TextTruncate = Enum.TextTruncate.AtEnd
            selected.Parent = frame
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0, 5)
            sc.Parent = selected
            local sstroke = Instance.new("UIStroke")
            sstroke.Color = DEFAULT_THEME.StrokeColor
            sstroke.Thickness = 1
            sstroke.Transparency = 0.8
            sstroke.Parent = selected
            local dropFrame = Instance.new("Frame")
            dropFrame.BackgroundColor3 = DEFAULT_THEME.Background
            dropFrame.BackgroundTransparency = DEFAULT_THEME.BackgroundTransparency
            dropFrame.Visible = false
            dropFrame.ZIndex = 2
            dropFrame.Parent = screen
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 5)
            dropCorner.Parent = dropFrame
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = DEFAULT_THEME.StrokeColor
            dropStroke.Thickness = 1
            dropStroke.Transparency = DEFAULT_THEME.StrokeTransparency
            dropStroke.Parent = dropFrame
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Padding = UDim.new(0, 4)
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropFrame
            for _, v in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
                optBtn.BackgroundTransparency = 0.5
                optBtn.Text = v
                optBtn.TextColor3 = DEFAULT_THEME.Text
                optBtn.Font = DEFAULT_THEME.Font
                optBtn.TextSize = 14
                optBtn.Parent = dropFrame
                local optC = Instance.new("UICorner")
                optC.CornerRadius = UDim.new(0, 5)
                optC.Parent = optBtn
                local optStroke = Instance.new("UIStroke")
                optStroke.Color = DEFAULT_THEME.StrokeColor
                optStroke.Thickness = 1
                optStroke.Transparency = 0.8
                optStroke.Parent = optBtn
                optBtn.MouseButton1Click:Connect(function()
                    selected.Text = v
                    dropFrame.Visible = false
                    if callback then callback(v) end
                end)
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {BackgroundColor3 = DEFAULT_THEME.Accent, BackgroundTransparency = 0.3}):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {BackgroundColor3 = DEFAULT_THEME.AccentDarker, BackgroundTransparency = 0.5}):Play()
                end)
            end
            dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, dropLayout.AbsoluteContentSize.Y + 8)
            end)
            selected:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                dropFrame.Position = UDim2.new(0, selected.AbsolutePosition.X, 0, selected.AbsolutePosition.Y + selected.AbsoluteSize.Y)
            end)
            dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, dropLayout.AbsoluteContentSize.Y + 8)
            dropFrame.Position = UDim2.new(0, selected.AbsolutePosition.X, 0, selected.AbsolutePosition.Y + selected.AbsoluteSize.Y)
            selected.MouseButton1Click:Connect(function()
                dropFrame.Visible = not dropFrame.Visible
            end)
            return frame
        end
        function tabAPI:AddKeybind(name, defaultKey, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = 0.6
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = DEFAULT_THEME.StrokeColor
            stroke.Thickness = 1
            stroke.Transparency = 0.8
            stroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.62, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 28)
            btn.Position = UDim2.new(1, -112, 0.5, -14)
            btn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            btn.BackgroundTransparency = 0.5
            btn.Text = defaultKey.Name
            btn.TextColor3 = DEFAULT_THEME.Text
            btn.Font = DEFAULT_THEME.Font
            btn.TextSize = 14
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = frame
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 5)
            bc.Parent = btn
            local bstroke = Instance.new("UIStroke")
            bstroke.Color = DEFAULT_THEME.StrokeColor
            bstroke.Thickness = 1
            bstroke.Transparency = 0.8
            bstroke.Parent = btn
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
    shadow.Size = UDim2.new(0, 0, 0, 0)
    shadow.BackgroundTransparency = 1
    TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, width + DEFAULT_THEME.ShadowBlur * 2, 0, height + DEFAULT_THEME.ShadowBlur * 2),
        BackgroundTransparency = DEFAULT_THEME.ShadowTransparency
    }):Play()
    return window
end
return SmileUILib
