local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

-- Internal state
local STATE = {
    windows = {},
    elements = {},
    themes = {},
    currentTheme = "Voidframe",
    keybinds = {},
    connections = {},
    inputLocked = false,
    typing = false,
    fpsLimit = nil,
    notifications = {},
    watermark = nil,
}

local DEFAULT_THEME = {
    Accent = Color3.fromRGB(110, 120, 255),
    AccentSoft = Color3.fromRGB(90, 98, 220),
    Bg = Color3.fromRGB(18, 18, 22),
    BgSoft = Color3.fromRGB(24, 24, 30),
    Panel = Color3.fromRGB(28, 28, 36),
    PanelSoft = Color3.fromRGB(32, 32, 42),
    Text = Color3.fromRGB(235, 235, 245),
    TextDim = Color3.fromRGB(160, 160, 175),
    Border = Color3.fromRGB(50, 50, 64),
    Danger = Color3.fromRGB(255, 90, 90),
    Warning = Color3.fromRGB(255, 200, 80),
    Success = Color3.fromRGB(90, 220, 140),
}

STATE.themes["Voidframe"] = DEFAULT_THEME

local function deepCopy(tbl)
    local out = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            out[k] = deepCopy(v)
        else
            out[k] = v
        end
    end
    return out
end

local function applyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

local function applyStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
end

local function makeShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

local function tween(instance, info, props)
    local t = TweenService:Create(instance, info, props)
    t:Play()
    return t
end

local function makeText(parent, text, size, dim, align)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextSize = size or 14
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = dim or Color3.new(1, 1, 1)
    label.TextXAlignment = align or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Size = UDim2.new(1, 0, 0, size + 6)
    label.Parent = parent
    return label
end

local function uniqueId()
    return "vf_" .. tostring(math.random(100000, 999999)) .. "_" .. tostring(tick() * 1000)
end

local function addConn(conn)
    table.insert(STATE.connections, conn)
end

local function isTyping()
    return STATE.typing
end

local function clamp(n, min, max)
    return math.max(min, math.min(max, n))
end

local function setVisible(obj, state)
    if obj and obj.Parent then
        obj.Visible = state
    end
end

local function createClickArea(parent)
    local btn = Instance.new("TextButton")
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Parent = parent
    return btn
end

local function hoverTween(frame, toColor, theme)
    local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    tween(frame, info, { BackgroundColor3 = toColor })
end

local function baseButtonStyle(frame, theme)
    frame.BackgroundColor3 = theme.PanelSoft
    frame.BorderSizePixel = 0
    applyCorner(frame, 8)
    applyStroke(frame, theme.Border, 1, 0.3)
end

local function createScroller(parent)
    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(140, 140, 150)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    return scroll, layout
end

local function createNotificationContainer(screenGui)
    local container = Instance.new("Frame")
    container.Name = "Notifications"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 320, 1, 0)
    container.Position = UDim2.new(1, -340, 0, 20)
    container.Parent = screenGui

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = container

    return container
end

-- Window class
local Window = {}
Window.__index = Window

-- Tab class
local Tab = {}
Tab.__index = Tab

-- Section class
local Section = {}
Section.__index = Section

-- Generic element class
local Element = {}
Element.__index = Element

-- Theme helpers
local function getTheme()
    return STATE.themes[STATE.currentTheme] or DEFAULT_THEME
end

local function syncTheme(window)
    local theme = getTheme()
    if window and window._root then
        window._root.BackgroundColor3 = theme.Bg
        window._title.TextColor3 = theme.Text
        window._subtitle.TextColor3 = theme.TextDim
        window._sidebar.BackgroundColor3 = theme.Panel
        window._content.BackgroundColor3 = theme.BgSoft
    end
end

local function makeDrag(frame, handle)
    local dragging = false
    local dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    addConn(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end))

    addConn(UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end))
end

-- Library core
function Library:CreateWindow(options)
    options = options or {}
    local theme = getTheme()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VoidframeGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    local root = Instance.new("Frame")
    root.Name = "Window"
    root.Size = options.Size or UDim2.new(0, 680, 0, 440)
    root.Position = options.Position or UDim2.new(0.5, -340, 0.5, -220)
    root.BackgroundColor3 = theme.Bg
    root.BorderSizePixel = 0
    root.AnchorPoint = Vector2.new(0, 0)
    root.Parent = screenGui
    applyCorner(root, 12)
    applyStroke(root, theme.Border, 1, 0.2)
    makeShadow(root)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundTransparency = 1
    header.Parent = root

    local title = makeText(header, options.Title or "Voidframe", 18, theme.Text, Enum.TextXAlignment.Left)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.Size = UDim2.new(1, -40, 0, 22)

    local subtitle = makeText(header, options.Subtitle or "Modern UI Library", 12, theme.TextDim, Enum.TextXAlignment.Left)
    subtitle.Position = UDim2.new(0, 20, 0, 30)
    subtitle.Size = UDim2.new(1, -40, 0, 16)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, -60)
    sidebar.Position = UDim2.new(0, 0, 0, 60)
    sidebar.BackgroundColor3 = theme.Panel
    sidebar.BorderSizePixel = 0
    sidebar.Parent = root
    applyCorner(sidebar, 12)

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 8)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar

    local sidePad = Instance.new("UIPadding")
    sidePad.PaddingTop = UDim.new(0, 12)
    sidePad.PaddingLeft = UDim.new(0, 10)
    sidePad.PaddingRight = UDim.new(0, 10)
    sidePad.Parent = sidebar

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -180, 1, -60)
    content.Position = UDim2.new(0, 180, 0, 60)
    content.BackgroundColor3 = theme.BgSoft
    content.BorderSizePixel = 0
    content.Parent = root
    applyCorner(content, 12)

    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingTop = UDim.new(0, 16)
    contentPad.PaddingLeft = UDim.new(0, 16)
    contentPad.PaddingRight = UDim.new(0, 16)
    contentPad.PaddingBottom = UDim.new(0, 16)
    contentPad.Parent = content

    local tabsContainer, tabLayout = createScroller(content)

    local window = setmetatable({
        _screen = screenGui,
        _root = root,
        _header = header,
        _title = title,
        _subtitle = subtitle,
        _sidebar = sidebar,
        _content = content,
        _tabsContainer = tabsContainer,
        _tabLayout = tabLayout,
        _tabs = {},
        _selected = nil,
        _visible = true,
        _options = options,
    }, Window)

    if options.Draggable ~= false then
        makeDrag(root, header)
    end

    if options.Scale then
        local scale = Instance.new("UIScale")
        scale.Scale = options.Scale
        scale.Parent = root
    end

    -- Notification container
    window._notifyContainer = createNotificationContainer(screenGui)

    table.insert(STATE.windows, window)
    syncTheme(window)

    if STATE.autoLoad and STATE.autoLoadName then
        pcall(function()
            self:LoadConfig(STATE.autoLoadName)
        end)
    end

    return window
end

function Library:Destroy()
    for _, w in ipairs(STATE.windows) do
        if w._screen then
            w._screen:Destroy()
        end
    end
    STATE.windows = {}
    self:DestroyConnections()
end

function Library:ToggleVisibility(state)
    for _, w in ipairs(STATE.windows) do
        if w._root then
            w._root.Visible = state
        end
    end
end

function Library:SetKeybind(key)
    STATE.masterKey = key
end

function Library:GetWindow()
    return STATE.windows[#STATE.windows]
end

-- Window methods
function Window:Show()
    self._root.Visible = true
    self._visible = true
end

function Window:Hide()
    self._root.Visible = false
    self._visible = false
end

function Window:Toggle()
    self._visible = not self._visible
    self._root.Visible = self._visible
end

function Window:Destroy()
    if self._screen then
        self._screen:Destroy()
    end
end

function Window:SetTitle(text)
    self._title.Text = text
end

function Window:SetSubtitle(text)
    self._subtitle.Text = text
end

function Window:SetIcon(icon)
    -- Placeholder for icon support; you can insert ImageLabel near header if desired
    self._options.Icon = icon
end

function Window:SetSize(size)
    self._root.Size = size
end

function Window:SetPosition(pos)
    self._root.Position = pos
end

function Window:SetZIndex(index)
    self._root.ZIndex = index
end

function Window:SetTransparency(alpha)
    self._root.BackgroundTransparency = alpha
end

-- Tabs
function Window:AddTab(name, icon)
    local theme = getTheme()

    local tabButton = Instance.new("Frame")
    tabButton.Name = name or "Tab"
    tabButton.Size = UDim2.new(1, -2, 0, 36)
    tabButton.BackgroundColor3 = theme.PanelSoft
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self._sidebar
    applyCorner(tabButton, 8)
    applyStroke(tabButton, theme.Border, 1, 0.6)

    local label = makeText(tabButton, name or "Tab", 13, theme.Text, Enum.TextXAlignment.Left)
    label.Position = UDim2.new(0, 10, 0, 6)
    label.Size = UDim2.new(1, -20, 1, -12)

    local click = createClickArea(tabButton)

    local tabPage = Instance.new("Frame")
    tabPage.Name = "Page"
    tabPage.BackgroundTransparency = 1
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.Visible = false
    tabPage.Parent = self._tabsContainer

    local sectionsLayout = Instance.new("UIListLayout")
    sectionsLayout.Padding = UDim.new(0, 12)
    sectionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionsLayout.Parent = tabPage

    local tab = setmetatable({
        _button = tabButton,
        _label = label,
        _page = tabPage,
        _window = self,
        _sections = {},
        _icon = icon,
    }, Tab)

    addConn(click.MouseEnter:Connect(function()
        hoverTween(tabButton, theme.Panel, theme)
    end))
    addConn(click.MouseLeave:Connect(function()
        if self._selected ~= tab then
            hoverTween(tabButton, theme.PanelSoft, theme)
        end
    end))

    addConn(click.MouseButton1Click:Connect(function()
        tab:Select()
    end))

    table.insert(self._tabs, tab)
    if not self._selected then
        tab:Select()
    end

    return tab
end

function Tab:Select()
    local theme = getTheme()
    if self._window._selected then
        local prev = self._window._selected
        prev._page.Visible = false
        hoverTween(prev._button, theme.PanelSoft, theme)
    end
    self._page.Visible = true
    hoverTween(self._button, theme.Panel, theme)
    self._window._selected = self
end

function Tab:Destroy()
    if self._button then self._button:Destroy() end
    if self._page then self._page:Destroy() end
end

function Tab:SetVisible(state)
    setVisible(self._button, state)
end

function Tab:SetIcon(icon)
    self._icon = icon
end

function Tab:SetTitle(text)
    self._label.Text = text
end

-- Sections
function Tab:AddSection(title)
    local theme = getTheme()
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "Section"
    sectionFrame.BackgroundColor3 = theme.Panel
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Size = UDim2.new(1, 0, 0, 40)
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.Parent = self._page
    applyCorner(sectionFrame, 10)
    applyStroke(sectionFrame, theme.Border, 1, 0.4)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, -20, 0, 32)
    header.Position = UDim2.new(0, 10, 0, 8)
    header.Parent = sectionFrame

    local titleLabel = makeText(header, title or "Section", 13, theme.Text, Enum.TextXAlignment.Left)
    titleLabel.Size = UDim2.new(1, -20, 1, 0)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Text = "–"
    toggleBtn.TextSize = 16
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextColor3 = theme.TextDim
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Size = UDim2.new(0, 20, 0, 20)
    toggleBtn.Position = UDim2.new(1, -20, 0, 6)
    toggleBtn.Parent = header

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.BackgroundTransparency = 1
    body.Size = UDim2.new(1, -20, 0, 0)
    body.Position = UDim2.new(0, 10, 0, 38)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Parent = sectionFrame

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.Padding = UDim.new(0, 8)
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Parent = body

    local section = setmetatable({
        _frame = sectionFrame,
        _title = titleLabel,
        _body = body,
        _collapsed = false,
        _toggleBtn = toggleBtn,
    }, Section)

    addConn(toggleBtn.MouseButton1Click:Connect(function()
        section:ToggleCollapse()
    end))

    table.insert(self._sections, section)
    return section
end

function Section:SetTitle(text)
    self._title.Text = text
end

function Section:Collapse()
    if self._collapsed then return end
    self._collapsed = true
    self._toggleBtn.Text = "+"
    self._body.Visible = false
end

function Section:Expand()
    if not self._collapsed then return end
    self._collapsed = false
    self._toggleBtn.Text = "–"
    self._body.Visible = true
end

function Section:ToggleCollapse()
    if self._collapsed then
        self:Expand()
    else
        self:Collapse()
    end
end

function Section:Destroy()
    if self._frame then self._frame:Destroy() end
end

-- Element constructors
local function createElementBase(parent, height)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, height or 32)
    frame.Parent = parent
    return frame
end

local function registerElement(options, element)
    local id = nil
    if type(options) == "table" then
        id = options.Id or options.ID or options.Name
    end
    if not id then
        id = uniqueId()
    end
    element._id = id
    STATE.elements[id] = element
    return element
end

function Section:AddButton(options)
    options = options or {}
    local theme = getTheme()

    local holder = createElementBase(self._body, 36)

    local btn = Instance.new("Frame")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Parent = holder
    baseButtonStyle(btn, theme)

    local label = makeText(btn, options.Name or "Button", 13, theme.Text, Enum.TextXAlignment.Center)
    label.Size = UDim2.new(1, 0, 1, 0)

    local click = createClickArea(btn)
    local callback = options.Callback or function() end

    addConn(click.MouseEnter:Connect(function()
        hoverTween(btn, theme.Panel, theme)
    end))
    addConn(click.MouseLeave:Connect(function()
        hoverTween(btn, theme.PanelSoft, theme)
    end))
    addConn(click.MouseButton1Click:Connect(function()
        callback()
    end))

    local element = setmetatable({
        _frame = holder,
        _button = btn,
        _label = label,
        _callback = callback,
        _enabled = true,
    }, Element)

    function element:Click()
        if self._enabled then
            self._callback()
        end
    end
    function element:SetText(text)
        self._label.Text = text
    end
    function element:SetEnabled(state)
        self._enabled = state
        self._button.BackgroundTransparency = state and 0 or 0.5
    end
    function element:SetCallback(fn)
        self._callback = fn
    end
    function element:Destroy()
        if self._frame then self._frame:Destroy() end
    end

    return registerElement(options, element)
end

function Section:AddToggle(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 32)

    local label = makeText(holder, options.Name or "Toggle", 13, theme.Text, Enum.TextXAlignment.Left)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -50, 1, 0)

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 38, 0, 20)
    box.Position = UDim2.new(1, -38, 0.5, -10)
    box.BackgroundColor3 = theme.PanelSoft
    box.BorderSizePixel = 0
    box.Parent = holder
    applyCorner(box, 10)
    applyStroke(box, theme.Border, 1, 0.4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = theme.Text
    knob.BorderSizePixel = 0
    knob.Parent = box
    applyCorner(knob, 8)

    local click = createClickArea(holder)
    local value = options.Default == true
    local callback = options.Callback or function() end

    local function render()
        if value then
            box.BackgroundColor3 = theme.Accent
            knob.Position = UDim2.new(1, -18, 0, 2)
        else
            box.BackgroundColor3 = theme.PanelSoft
            knob.Position = UDim2.new(0, 2, 0, 2)
        end
    end
    render()

    addConn(click.MouseButton1Click:Connect(function()
        value = not value
        render()
        callback(value)
    end))

    local element = setmetatable({
        _frame = holder,
        _value = value,
        _callback = callback,
        _enabled = true,
    }, Element)

    function element:Set(state)
        self._value = state
        render()
        self._callback(self._value)
    end
    function element:Get()
        return self._value
    end
    function element:Toggle()
        self:Set(not self._value)
    end
    function element:SetEnabled(state)
        self._enabled = state
        holder.BackgroundTransparency = state and 1 or 0.4
    end
    function element:SetCallback(fn)
        self._callback = fn
    end
    function element:Destroy()
        if self._frame then self._frame:Destroy() end
    end

    return registerElement(options, element)
end

function Section:AddSlider(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 50)

    local name = makeText(holder, options.Name or "Slider", 13, theme.Text, Enum.TextXAlignment.Left)
    name.Position = UDim2.new(0, 0, 0, 0)
    name.Size = UDim2.new(1, -60, 0, 18)

    local valueLabel = makeText(holder, tostring(options.Default or 0), 12, theme.TextDim, Enum.TextXAlignment.Right)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.Size = UDim2.new(0, 60, 0, 18)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 26)
    bar.BackgroundColor3 = theme.PanelSoft
    bar.BorderSizePixel = 0
    bar.Parent = holder
    applyCorner(bar, 6)
    applyStroke(bar, theme.Border, 1, 0.4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    applyCorner(fill, 6)

    local min = options.Min or 0
    local max = options.Max or 100
    local step = options.Step or 1
    local value = options.Default or min
    local callback = options.Callback or function() end

    local function setValue(v)
        v = clamp(v, min, max)
        v = math.floor((v - min) / step + 0.5) * step + min
        value = clamp(v, min, max)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valueLabel.Text = tostring(value)
        callback(value)
    end

    setValue(value)

    local dragging = false
    addConn(bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - bar.AbsolutePosition.X
            local pct = pos / bar.AbsoluteSize.X
            setValue(min + (max - min) * pct)
        end
    end))
    addConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))
    addConn(UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - bar.AbsolutePosition.X
            local pct = pos / bar.AbsoluteSize.X
            setValue(min + (max - min) * pct)
        end
    end))

    local element = setmetatable({
        _frame = holder,
        _value = value,
        _callback = callback,
        _min = min,
        _max = max,
        _step = step,
    }, Element)

    function element:Set(v) setValue(v) end
    function element:Get() return self._value end
    function element:SetMin(v) self._min = v end
    function element:SetMax(v) self._max = v end
    function element:SetStep(v) self._step = v end
    function element:SetCallback(fn) self._callback = fn end
    function element:Destroy() if self._frame then self._frame:Destroy() end end

    return registerElement(options, element)
end

function Section:AddDropdown(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 36)

    local label = makeText(holder, options.Name or "Dropdown", 13, theme.Text, Enum.TextXAlignment.Left)
    label.Size = UDim2.new(1, -90, 1, 0)

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 140, 0, 28)
    box.Position = UDim2.new(1, -140, 0.5, -14)
    box.BackgroundColor3 = theme.PanelSoft
    box.BorderSizePixel = 0
    box.Parent = holder
    applyCorner(box, 8)
    applyStroke(box, theme.Border, 1, 0.4)

    local valueLabel = makeText(box, options.Default or "Select", 12, theme.TextDim, Enum.TextXAlignment.Left)
    valueLabel.Position = UDim2.new(0, 8, 0, 3)
    valueLabel.Size = UDim2.new(1, -16, 1, -6)

    local click = createClickArea(box)

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0, 140, 0, 0)
    listFrame.Position = UDim2.new(1, -140, 1, 4)
    listFrame.BackgroundColor3 = theme.Panel
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.Parent = holder
    applyCorner(listFrame, 8)
    applyStroke(listFrame, theme.Border, 1, 0.4)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 6)
    listPad.PaddingLeft = UDim.new(0, 6)
    listPad.PaddingRight = UDim.new(0, 6)
    listPad.PaddingBottom = UDim.new(0, 6)
    listPad.Parent = listFrame

    local values = options.Values or {}
    local value = options.Default
    local callback = options.Callback or function() end
    local multi = options.Multi or false
    local selected = {}

    local function refresh()
        for _, c in ipairs(listFrame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local count = 0
        for _, item in ipairs(values) do
            count += 1
            local itemBtn = Instance.new("TextButton")
            itemBtn.Text = tostring(item)
            itemBtn.TextSize = 12
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.TextColor3 = theme.Text
            itemBtn.BackgroundColor3 = theme.PanelSoft
            itemBtn.Size = UDim2.new(1, 0, 0, 24)
            itemBtn.AutoButtonColor = false
            itemBtn.Parent = listFrame
            applyCorner(itemBtn, 6)

            addConn(itemBtn.MouseButton1Click:Connect(function()
                if multi then
                    if selected[item] then
                        selected[item] = nil
                    else
                        selected[item] = true
                    end
                    local list = {}
                    for k in pairs(selected) do table.insert(list, k) end
                    valueLabel.Text = #list > 0 and table.concat(list, ", ") or "Select"
                    callback(list)
                else
                    value = item
                    valueLabel.Text = tostring(item)
                    listFrame.Visible = false
                    callback(item)
                end
            end))
        end
        listFrame.Size = UDim2.new(0, 140, 0, count * 28 + 12)
    end

    refresh()

    addConn(click.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
    end))

    local element = setmetatable({
        _frame = holder,
        _values = values,
        _value = value,
        _multi = multi,
        _selected = selected,
        _callback = callback,
        _list = listFrame,
        _label = valueLabel,
    }, Element)

    function element:Add(item)
        table.insert(self._values, item)
        refresh()
    end
    function element:Remove(item)
        for i, v in ipairs(self._values) do
            if v == item then
                table.remove(self._values, i)
                break
            end
        end
        refresh()
    end
    function element:Clear()
        self._values = {}
        refresh()
    end
    function element:Refresh(list)
        self._values = list or {}
        refresh()
    end
    function element:Set(v)
        self._value = v
        self._label.Text = tostring(v)
        self._callback(v)
    end
    function element:Get()
        return self._value
    end
    function element:SetMulti(state)
        self._multi = state
    end
    function element:SetCallback(fn)
        self._callback = fn
    end
    function element:Destroy()
        if self._frame then self._frame:Destroy() end
    end

    return registerElement(options, element)
end

function Section:AddTextbox(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 36)

    local label = makeText(holder, options.Name or "Textbox", 13, theme.Text, Enum.TextXAlignment.Left)
    label.Size = UDim2.new(1, -140, 1, 0)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 140, 0, 28)
    box.Position = UDim2.new(1, -140, 0.5, -14)
    box.BackgroundColor3 = theme.PanelSoft
    box.TextColor3 = theme.Text
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.Text = options.Default or ""
    box.PlaceholderText = options.Placeholder or ""
    box.BorderSizePixel = 0
    box.Parent = holder
    applyCorner(box, 8)
    applyStroke(box, theme.Border, 1, 0.4)

    local numericOnly = options.NumericOnly or false
    local callback = options.Callback or function() end

    addConn(box.Focused:Connect(function()
        STATE.typing = true
    end))
    addConn(box.FocusLost:Connect(function()
        STATE.typing = false
        callback(box.Text)
    end))

    if numericOnly then
        addConn(box:GetPropertyChangedSignal("Text"):Connect(function()
            box.Text = box.Text:gsub("[^%d%.%-]", "")
        end))
    end

    local element = setmetatable({
        _frame = holder,
        _box = box,
        _callback = callback,
    }, Element)

    function element:Set(text) self._box.Text = text end
    function element:Get() return self._box.Text end
    function element:Clear() self._box.Text = "" end
    function element:SetPlaceholder(text) self._box.PlaceholderText = text end
    function element:SetNumericOnly(state) numericOnly = state end
    function element:SetCallback(fn) self._callback = fn end
    function element:Destroy() if self._frame then self._frame:Destroy() end end

    return registerElement(options, element)
end

function Section:AddLabel(text)
    local theme = getTheme()
    local holder = createElementBase(self._body, 22)
    local label = makeText(holder, text or "Label", 12, theme.TextDim, Enum.TextXAlignment.Left)
    label.Size = UDim2.new(1, 0, 1, 0)

    local element = setmetatable({
        _frame = holder,
        _label = label,
    }, Element)

    function element:Set(t) self._label.Text = t end
    function element:Get() return self._label.Text end
    function element:Destroy() if self._frame then self._frame:Destroy() end end
    return registerElement(nil, element)
end

function Section:AddDivider()
    local theme = getTheme()
    local holder = createElementBase(self._body, 10)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = theme.Border
    line.BorderSizePixel = 0
    line.Parent = holder

    local element = setmetatable({
        _frame = holder,
    }, Element)
    function element:Destroy() if self._frame then self._frame:Destroy() end end
    return registerElement(nil, element)
end

-- Advanced elements
function Section:AddKeybind(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 36)

    local label = makeText(holder, options.Name or "Keybind", 13, theme.Text, Enum.TextXAlignment.Left)
    label.Size = UDim2.new(1, -120, 1, 0)

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 120, 0, 28)
    box.Position = UDim2.new(1, -120, 0.5, -14)
    box.BackgroundColor3 = theme.PanelSoft
    box.TextColor3 = theme.TextDim
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.Text = options.Default and options.Default.Name or "None"
    box.BorderSizePixel = 0
    box.Parent = holder
    applyCorner(box, 8)
    applyStroke(box, theme.Border, 1, 0.4)

    local key = options.Default
    local mode = options.Mode or "Toggle"
    local callback = options.Callback or function() end
    local listening = false

    addConn(box.MouseButton1Click:Connect(function()
        box.Text = "Press..."
        listening = true
    end))

    addConn(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                box.Text = key.Name
                listening = false
            end
            return
        end
        if key and input.KeyCode == key then
            callback(mode == "Hold" and true or "Toggle")
        end
    end))

    local element = setmetatable({
        _frame = holder,
        _key = key,
        _mode = mode,
        _callback = callback,
    }, Element)

    function element:Set(k) self._key = k box.Text = k.Name end
    function element:Get() return self._key end
    function element:SetMode(m) self._mode = m end
    function element:SetCallback(fn) self._callback = fn end
    function element:Destroy() if self._frame then self._frame:Destroy() end end

    return registerElement(options, element)
end

function Section:AddColorPicker(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 36)

    local label = makeText(holder, options.Name or "Color", 13, theme.Text, Enum.TextXAlignment.Left)
    label.Size = UDim2.new(1, -60, 1, 0)

    local swatch = Instance.new("Frame")
    swatch.Size = UDim2.new(0, 42, 0, 22)
    swatch.Position = UDim2.new(1, -42, 0.5, -11)
    swatch.BackgroundColor3 = options.Default or theme.Accent
    swatch.BorderSizePixel = 0
    swatch.Parent = holder
    applyCorner(swatch, 6)
    applyStroke(swatch, theme.Border, 1, 0.4)

    local click = createClickArea(swatch)
    local color = swatch.BackgroundColor3
    local alpha = 0
    local callback = options.Callback or function() end

    addConn(click.MouseButton1Click:Connect(function()
        -- Simple cycle palette for now (you can replace with full picker UI)
        local palette = {
            theme.Accent,
            theme.Success,
            theme.Warning,
            theme.Danger,
            Color3.fromRGB(255, 255, 255),
        }
        local idx = 1
        for i, c in ipairs(palette) do
            if c == color then idx = i break end
        end
        idx = (idx % #palette) + 1
        color = palette[idx]
        swatch.BackgroundColor3 = color
        callback(color)
    end))

    local element = setmetatable({
        _frame = holder,
        _color = color,
        _alpha = alpha,
        _callback = callback,
    }, Element)

    function element:Set(c) self._color = c swatch.BackgroundColor3 = c end
    function element:Get() return self._color end
    function element:SetAlpha(a) self._alpha = a end
    function element:SetCallback(fn) self._callback = fn end
    function element:Destroy() if self._frame then self._frame:Destroy() end end
    return registerElement(options, element)
end

function Section:AddMultiDropdown(options)
    options = options or {}
    options.Multi = true
    return self:AddDropdown(options)
end

function Section:AddProgressBar(options)
    options = options or {}
    local theme = getTheme()
    local holder = createElementBase(self._body, 30)

    local label = makeText(holder, options.Name or "Progress", 12, theme.TextDim, Enum.TextXAlignment.Left)
    label.Size = UDim2.new(1, -60, 1, 0)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 120, 0, 8)
    bar.Position = UDim2.new(1, -120, 0.5, -4)
    bar.BackgroundColor3 = theme.PanelSoft
    bar.BorderSizePixel = 0
    bar.Parent = holder
    applyCorner(bar, 6)
    applyStroke(bar, theme.Border, 1, 0.4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    applyCorner(fill, 6)

    local max = options.Max or 100
    local value = options.Default or 0

    local function setValue(v)
        value = clamp(v, 0, max)
        local pct = value / max
        fill.Size = UDim2.new(pct, 0, 1, 0)
    end
    setValue(value)

    local element = setmetatable({
        _frame = holder,
        _value = value,
        _max = max,
    }, Element)

    function element:Set(v) setValue(v) end
    function element:Get() return self._value end
    function element:SetMax(v) self._max = v end
    function element:Destroy() if self._frame then self._frame:Destroy() end end
    return registerElement(options, element)
end

-- Notifications
function Library:Notify(options)
    options = options or {}
    local theme = getTheme()
    local window = self:GetWindow()
    if not window or not window._notifyContainer then return end

    local card = Instance.new("Frame")
    card.BackgroundColor3 = theme.Panel
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, 60)
    card.Parent = window._notifyContainer
    applyCorner(card, 10)
    applyStroke(card, theme.Border, 1, 0.4)

    local title = makeText(card, options.Title or "Notification", 13, theme.Text, Enum.TextXAlignment.Left)
    title.Position = UDim2.new(0, 10, 0, 6)
    title.Size = UDim2.new(1, -20, 0, 16)

    local body = makeText(card, options.Text or "", 12, theme.TextDim, Enum.TextXAlignment.Left)
    body.Position = UDim2.new(0, 10, 0, 24)
    body.Size = UDim2.new(1, -20, 0, 16)

    local duration = options.Duration or 3
    task.delay(duration, function()
        if card then card:Destroy() end
    end)
end

function Library:Success(text) self:Notify({ Title = "Success", Text = text }) end
function Library:Warning(text) self:Notify({ Title = "Warning", Text = text }) end
function Library:Error(text) self:Notify({ Title = "Error", Text = text }) end
function Library:ClearNotifications()
    local window = self:GetWindow()
    if not window or not window._notifyContainer then return end
    for _, c in ipairs(window._notifyContainer:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end

-- Theme system
function Library:SetTheme(theme)
    if type(theme) == "table" then
        STATE.themes["Custom"] = theme
        STATE.currentTheme = "Custom"
    elseif STATE.themes[theme] then
        STATE.currentTheme = theme
    end
    for _, w in ipairs(STATE.windows) do
        syncTheme(w)
    end
end

function Library:GetTheme()
    return STATE.themes[STATE.currentTheme]
end

function Library:AddTheme(name, themeTable)
    STATE.themes[name] = themeTable
end

function Library:RemoveTheme(name)
    if name ~= "Voidframe" then
        STATE.themes[name] = nil
    end
end

function Library:ApplyTheme(name)
    if STATE.themes[name] then
        STATE.currentTheme = name
        for _, w in ipairs(STATE.windows) do
            syncTheme(w)
        end
    end
end

function Library:ListThemes()
    local list = {}
    for k in pairs(STATE.themes) do table.insert(list, k) end
    return list
end

-- Config system (file I/O if available)
local CONFIG_DIR = "voidframe/configs"

local function hasFileIO()
    return type(writefile) == "function" and type(readfile) == "function"
end

local function ensureConfigDir()
    if type(makefolder) == "function" and type(isfolder) == "function" then
        if not isfolder(CONFIG_DIR) then
            pcall(makefolder, CONFIG_DIR)
        end
    end
end

local function configPath(name)
    return CONFIG_DIR .. "/" .. tostring(name) .. ".json"
end

local function encodeConfig(data)
    return HttpService:JSONEncode(data or {})
end

local function decodeConfig(data)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(data)
    end)
    return ok and decoded or {}
end

function Library:SaveConfig(name)
    local snapshot = self:GetState()
    STATE.configs = STATE.configs or {}
    STATE.configs[name] = snapshot

    if hasFileIO() then
        ensureConfigDir()
        local ok = pcall(function()
            writefile(configPath(name), encodeConfig(snapshot))
        end)
        return ok
    end
    return false
end

function Library:LoadConfig(name)
    if hasFileIO() and type(isfile) == "function" and isfile(configPath(name)) then
        local ok, data = pcall(function()
            return readfile(configPath(name))
        end)
        if ok then
            local decoded = decodeConfig(data)
            self:SetState(decoded)
            return true
        end
    end
    if STATE.configs and STATE.configs[name] then
        self:SetState(STATE.configs[name])
        return true
    end
    return false
end

function Library:DeleteConfig(name)
    if STATE.configs then
        STATE.configs[name] = nil
    end
    if type(delfile) == "function" and type(isfile) == "function" then
        local path = configPath(name)
        if isfile(path) then
            pcall(delfile, path)
        end
    end
end

function Library:ListConfigs()
    local list = {}
    if STATE.configs then
        for k in pairs(STATE.configs) do table.insert(list, k) end
    end
    if hasFileIO() and type(listfiles) == "function" then
        ensureConfigDir()
        local ok, files = pcall(listfiles, CONFIG_DIR)
        if ok and type(files) == "table" then
            for _, f in ipairs(files) do
                local name = f:match("([^/\\]+)%.json$")
                if name then table.insert(list, name) end
            end
        end
    end
    return list
end

function Library:ExportConfig()
    return encodeConfig(self:GetState())
end

function Library:ImportConfig(data)
    if type(data) == "string" then
        self:SetState(decodeConfig(data))
    elseif type(data) == "table" then
        self:SetState(data)
    end
end

function Library:AutoLoadConfig(state)
    if type(state) == "string" then
        STATE.autoLoad = true
        STATE.autoLoadName = state
    else
        STATE.autoLoad = state
    end
end

function Library:ResetConfig()
    self:SetState({})
end

-- Input handling
function Library:BindKey(key, fn)
    STATE.keybinds[key] = fn
end

function Library:UnbindKey(key)
    STATE.keybinds[key] = nil
end

function Library:LockInput(state)
    STATE.inputLocked = state
end

function Library:IsTyping()
    return isTyping()
end

function Library:GetMousePosition()
    return UserInputService:GetMouseLocation()
end

-- Runtime / State
function Library:GetState()
    local state = {}
    for id, el in pairs(STATE.elements) do
        if el.Get then
            state[id] = el:Get()
        end
    end
    return state
end

function Library:SetState(tbl)
    for id, val in pairs(tbl or {}) do
        local el = STATE.elements[id]
        if el and el.Set then
            el:Set(val)
        end
    end
end

function Library:GetElement(id)
    return STATE.elements[id]
end

function Library:DestroyElement(id)
    local el = STATE.elements[id]
    if el and el.Destroy then
        el:Destroy()
    end
    STATE.elements[id] = nil
end

function Library:ClearElements()
    for id, el in pairs(STATE.elements) do
        if el.Destroy then el:Destroy() end
    end
    STATE.elements = {}
end

-- Performance & Lifecycle
function Library:Cleanup()
    self:ClearElements()
    self:ClearNotifications()
end

function Library:DestroyConnections()
    for _, c in ipairs(STATE.connections) do
        if c.Connected then c:Disconnect() end
    end
    STATE.connections = {}
end

function Library:Optimize()
    -- Placeholder: could disable shadows, reduce effects, etc.
end

function Library:SetFPSLimit(limit)
    STATE.fpsLimit = limit
end

-- Utility / Extras
function Library:SetWatermark(text)
    local window = self:GetWindow()
    if not window then return end
    if not STATE.watermark then
        local mark = Instance.new("TextLabel")
        mark.BackgroundTransparency = 1
        mark.TextSize = 12
        mark.Font = Enum.Font.GothamSemibold
        mark.TextColor3 = getTheme().TextDim
        mark.Position = UDim2.new(1, -200, 0, 8)
        mark.Size = UDim2.new(0, 180, 0, 16)
        mark.TextXAlignment = Enum.TextXAlignment.Right
        mark.Parent = window._root
        STATE.watermark = mark
    end
    STATE.watermark.Text = text
end

function Library:ToggleWatermark(state)
    if STATE.watermark then
        STATE.watermark.Visible = state
    end
end

function Library:SetAccentColor(color)
    local theme = getTheme()
    theme.Accent = color
    self:SetTheme(theme)
end

function Library:SetUIScale(scale)
    local window = self:GetWindow()
    if not window then return end
    local s = window._root:FindFirstChildOfClass("UIScale")
    if not s then
        s = Instance.new("UIScale")
        s.Parent = window._root
    end
    s.Scale = scale
end

function Library:EnableSounds(state)
    STATE.soundsEnabled = state
end

function Library:SetSoundVolume(volume)
    STATE.soundVolume = volume
end

function Library:SetLanguage(lang)
    STATE.language = lang
end

-- Executor / Script Hub (optional stubs)
function Library:QueueOnTeleport(script) STATE.queueOnTeleport = script end
function Library:DetectExecutor() return "Roblox Studio" end
function Library:AutoRejoin(state) STATE.autoRejoin = state end
function Library:AntiAFK(state) STATE.antiAfk = state end
function Library:LoadScript(url) return nil end

-- Hook keybinds
addConn(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if STATE.inputLocked then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode
        if STATE.masterKey and key == STATE.masterKey then
            local w = Library:GetWindow()
            if w then w:Toggle() end
        end
        if STATE.keybinds[key] then
            STATE.keybinds[key]()
        end
    end
end))

return Library
