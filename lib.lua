--[[

  _________       .__.__             ___ ___      ___.     
 /   _____/ _____ |__|  |   ____    /   |   \ __ _\_ |__   
 \_____  \ /     \|  |  | _/ __ \  /    ~    \  |  \ __ \  
 /        \  Y Y  \  |  |_\  ___/  \    Y    /  |  / \_\ \ 
/_______  /__|_|  /__|____/\___  >  \___|_  /|____/|___  / 
        \/      \/             \/         \/           \/  

--]]

local VoidFrame = {}
VoidFrame.__index = VoidFrame

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility Functions
local function ProtectGUI(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    elseif protectgui then
        protectgui(gui)
    end
end

local function GetHiddenUI()
    if gethui then
        return gethui()
    end
    return CoreGui
end

local function LightenColor(color, amount)
    amount = amount or 0.1
    local h, s, v = color:ToHSV()
    return Color3.fromHSV(h, s, math.clamp(v + amount, 0, 1))
end

local function DarkenColor(color, amount)
    amount = amount or 0.1
    local h, s, v = color:ToHSV()
    return Color3.fromHSV(h, s, math.clamp(v - amount, 0, 1))
end

-- Theme Configuration
VoidFrame.Theme = {
    -- Background colors
    Background = Color3.fromRGB(13, 13, 15),
    Surface = Color3.fromRGB(23, 23, 28),
    Elevated = Color3.fromRGB(33, 33, 40),
    
    -- Accent colors
    Primary = Color3.fromRGB(124, 58, 237), -- Violet
    PrimaryLight = Color3.fromRGB(167, 139, 250),
    Secondary = Color3.fromRGB(236, 72, 153), -- Pink
    
    -- Text colors
    TextPrimary = Color3.fromRGB(250, 250, 252),
    TextSecondary = Color3.fromRGB(160, 160, 170),
    TextMuted = Color3.fromRGB(100, 100, 110),
    
    -- Status colors
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(234, 179, 8),
    Error = Color3.fromRGB(239, 68, 68),
    Info = Color3.fromRGB(59, 130, 246),
    
    -- Utility
    Border = Color3.fromRGB(45, 45, 55),
    Highlight = Color3.fromRGB(60, 60, 75)
}

-- Animation Configuration
VoidFrame.Animation = {
    TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    FastTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SpringTween = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    SmoothTween = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
}

-- Initialize Library
function VoidFrame:Init()
    local self = setmetatable({}, VoidFrame)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "VoidFrame_" .. HttpService:GenerateGUID(false)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.DisplayOrder = 999
    
    ProtectGUI(self.ScreenGui)
    self.ScreenGui.Parent = GetHiddenUI()
    
    -- Global State
    self.Windows = {}
    self.ActiveWindow = nil
    self.IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    self.Notifications = {}
    self.Dragging = nil
    self.Resizing = nil
    self.Tooltips = {}
    
    -- Setup input handling
    self:SetupInput()
    
    return self
end

-- Input Handling
function VoidFrame:SetupInput()
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if self.Dragging then
                local delta = input.Position - self.DragStart
                local newPos = UDim2.new(
                    self.DragStartPos.X.Scale,
                    self.DragStartPos.X.Offset + delta.X,
                    self.DragStartPos.Y.Scale,
                    self.DragStartPos.Y.Offset + delta.Y
                )
                self.Dragging.Window.Position = newPos
            elseif self.Resizing then
                local delta = input.Position - self.ResizeStart
                local newWidth = math.max(self.Resizing.MinSize.X, self.ResizeStartSize.X.Offset + delta.X)
                local newHeight = math.max(self.Resizing.MinSize.Y, self.ResizeStartSize.Y.Offset + delta.Y)
                self.Resizing.Window.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.Dragging = nil
            self.Resizing = nil
        end
    end)
end

-- Notification System
function VoidFrame:Notify(data)
    data = data or {}
    local title = data.Title or "Notification"
    local message = data.Message or ""
    local duration = data.Duration or 5
    local notifType = data.Type or "Info"
    local soundId = data.SoundId
    
    -- Sound effect
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = typeof(soundId) == "number" and "rbxassetid://" .. soundId or soundId
        sound.Volume = 0.5
        sound.Parent = self.ScreenGui
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.BackgroundColor3 = self.Theme.Surface
    notifFrame.BorderSizePixel = 0
    notifFrame.Size = UDim2.new(0, 340, 0, 0)
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notifFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Theme.Border
    stroke.Thickness = 1
    stroke.Parent = notifFrame
    
    local iconColors = {
        Success = self.Theme.Success,
        Error = self.Theme.Error,
        Warning = self.Theme.Warning,
        Info = self.Theme.Info
    }
    
    local accentBar = Instance.new("Frame")
    accentBar.BackgroundColor3 = iconColors[notifType] or self.Theme.Info
    accentBar.BorderSizePixel = 0
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 16, 0, 12)
    titleLabel.Size = UDim2.new(1, -32, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.TextPrimary
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.BackgroundTransparency = 1
    msgLabel.Position = UDim2.new(0, 16, 0, 36)
    msgLabel.Size = UDim2.new(1, -32, 0, 0)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Text = message
    msgLabel.TextColor3 = self.Theme.TextSecondary
    msgLabel.TextSize = 14
    msgLabel.TextWrapped = true
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = notifFrame
    
    local textBounds = TextService:GetTextSize(message, 14, Enum.Font.Gotham, Vector2.new(308, 9999))
    local height = math.max(85, 60 + textBounds.Y)
    
    msgLabel.Size = UDim2.new(1, -32, 0, textBounds.Y)
    
    local progressBar = Instance.new("Frame")
    progressBar.BackgroundColor3 = iconColors[notifType] or self.Theme.Info
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Parent = notifFrame
    
    local cornerProgress = Instance.new("UICorner")
    cornerProgress.CornerRadius = UDim.new(0, 2)
    cornerProgress.Parent = progressBar
    
    local offset = 0
    for _, notif in pairs(self.Notifications) do
        if notif.Frame and notif.Frame.Parent then
            offset = offset + notif.Frame.AbsoluteSize.Y + 12
        end
    end
    
    notifFrame.Position = UDim2.new(1, 20, 1, -20 - height - offset)
    notifFrame.Size = UDim2.new(0, 340, 0, height)
    
    table.insert(self.Notifications, {Frame = notifFrame, StartTime = tick()})
    
    TweenService:Create(notifFrame, self.Animation.TweenInfo, {
        Position = UDim2.new(1, -360, 1, -20 - height - offset)
    }):Play()
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    progressTween:Play()
    
    local function close()
        if not notifFrame.Parent then return end
        
        local closeTween = TweenService:Create(notifFrame, self.Animation.TweenInfo, {
            Position = UDim2.new(1, 20, notifFrame.Position.Y.Scale, notifFrame.Position.Y.Offset),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        
        for _, child in pairs(notifFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                if child:IsA("TextLabel") then
                    TweenService:Create(child, self.Animation.FastTween, {TextTransparency = 1}):Play()
                elseif child:IsA("Frame") then
                    TweenService:Create(child, self.Animation.FastTween, {BackgroundTransparency = 1}):Play()
                end
            end
        end
        
        closeTween.Completed:Wait()
        notifFrame:Destroy()
        
        for i, notif in pairs(self.Notifications) do
            if notif.Frame == notifFrame then
                table.remove(self.Notifications, i)
                break
            end
        end
        
        local newOffset = 0
        for _, notif in pairs(self.Notifications) do
            if notif.Frame and notif.Frame.Parent then
                TweenService:Create(notif.Frame, self.Animation.TweenInfo, {
                    Position = UDim2.new(1, -360, 1, -20 - notif.Frame.AbsoluteSize.Y - newOffset)
                }):Play()
                newOffset = newOffset + notif.Frame.AbsoluteSize.Y + 12
            end
        end
    end
    
    task.delay(duration, close)
    
    notifFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            close()
        end
    end)
    
    return notifFrame
end

-- Create Window
function VoidFrame:CreateWindow(config)
    config = config or {}
    local title = config.Title or "VoidFrame"
    local subtitle = config.Subtitle or ""
    local size = config.Size or UDim2.new(0, 750, 0, 520)
    local position = config.Position or UDim2.new(0.5, -375, 0.5, -260)
    local minSize = config.MinSize or Vector2.new(450, 350)
    local accentColor = config.AccentColor or self.Theme.Primary
    
    -- Main Window
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.BackgroundColor3 = self.Theme.Background
    window.BorderSizePixel = 0
    window.Size = size
    window.Position = position
    window.ClipsDescendants = true
    window.Parent = self.ScreenGui
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 16)
    windowCorner.Parent = window
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = -1
    shadow.Parent = window
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = self.Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 60)
    titleBar.Parent = window
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.BackgroundColor3 = self.Theme.Surface
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleFix.Parent = titleBar
    
    -- Accent line
    local accentLine = Instance.new("Frame")
    accentLine.BackgroundColor3 = accentColor
    accentLine.BorderSizePixel = 0
    accentLine.Position = UDim2.new(0, 20, 0, 16)
    accentLine.Size = UDim2.new(0, 4, 0, 28)
    accentLine.Parent = titleBar
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accentLine
    
    -- Title group
    local titleGroup = Instance.new("Frame")
    titleGroup.BackgroundTransparency = 1
    titleGroup.Position = UDim2.new(0, 35, 0, 12)
    titleGroup.Size = UDim2.new(0, 300, 0, 36)
    titleGroup.Parent = titleBar
    
    local mainTitle = Instance.new("TextLabel")
    mainTitle.BackgroundTransparency = 1
    mainTitle.Size = UDim2.new(1, 0, 0, 20)
    mainTitle.Font = Enum.Font.GothamBold
    mainTitle.Text = title
    mainTitle.TextColor3 = self.Theme.TextPrimary
    mainTitle.TextSize = 18
    mainTitle.TextXAlignment = Enum.TextXAlignment.Left
    mainTitle.Parent = titleGroup
    
    if subtitle ~= "" then
        mainTitle.Size = UDim2.new(1, 0, 0.5, 0)
        local subTitle = Instance.new("TextLabel")
        subTitle.BackgroundTransparency = 1
        subTitle.Position = UDim2.new(0, 0, 0.5, 0)
        subTitle.Size = UDim2.new(1, 0, 0.5, 0)
        subTitle.Font = Enum.Font.Gotham
        subTitle.Text = subtitle
        subTitle.TextColor3 = self.Theme.TextMuted
        subTitle.TextSize = 12
        subTitle.TextXAlignment = Enum.TextXAlignment.Left
        subTitle.Parent = titleGroup
    end
    
    -- Window Controls
    local controls = Instance.new("Frame")
    controls.BackgroundTransparency = 1
    controls.Position = UDim2.new(1, -110, 0, 15)
    controls.Size = UDim2.new(0, 90, 0, 30)
    controls.Parent = titleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.Padding = UDim.new(0, 10)
    controlsLayout.Parent = controls
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.BackgroundColor3 = self.Theme.Warning
    minBtn.BorderSizePixel = 0
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.TextSize = 18
    minBtn.Parent = controls
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.BackgroundColor3 = self.Theme.Error
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 20
    closeBtn.Parent = controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(window, self.Animation.TweenInfo, {
            Size = UDim2.new(0, window.AbsoluteSize.X, 0, 0),
            Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, window.Position.Y.Scale, window.Position.Y.Offset + window.AbsoluteSize.Y/2)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        window:Destroy()
    end)
    
    -- Content Container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 0, 0, 60)
    content.Size = UDim2.new(1, 0, 1, -60)
    content.Parent = window
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = self.Theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Size = UDim2.new(0, 210, 1, 0)
    sidebar.Parent = content
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 0)
    sidebarCorner.Parent = sidebar
    
    -- Tab Container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 12, 0, 12)
    tabContainer.Size = UDim2.new(1, -24, 1, -24)
    tabContainer.ScrollBarThickness = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.Parent = sidebar
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 8)
    tabList.Parent = tabContainer
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 20)
    end)
    
    -- Main Content Area
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.BackgroundTransparency = 1
    mainContent.Position = UDim2.new(0, 220, 0, 10)
    mainContent.Size = UDim2.new(1, -230, 1, -20)
    mainContent.Parent = content
    
    -- Drag Functionality
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = {
                Window = window
            }
            self.DragStart = input.Position
            self.DragStartPos = window.Position
        end
    end)
    
    -- Resize Handle
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "Resize"
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Position = UDim2.new(1, -25, 1, -25)
    resizeHandle.Size = UDim2.new(0, 25, 0, 25)
    resizeHandle.Text = ""
    resizeHandle.Parent = window
    
    local resizeIcon = Instance.new("ImageLabel")
    resizeIcon.BackgroundTransparency = 1
    resizeIcon.Position = UDim2.new(0, 8, 0, 8)
    resizeIcon.Size = UDim2.new(0, 12, 0, 12)
    resizeIcon.Image = "rbxassetid://6764432408"
    resizeIcon.ImageColor3 = self.Theme.TextMuted
    resizeIcon.Rotation = 180
    resizeIcon.Parent = resizeHandle
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Resizing = {
                Window = window,
                MinSize = minSize
            }
            self.ResizeStart = input.Position
            self.ResizeStartSize = window.Size
        end
    end)
    
    -- Hover effects for controls
    local function setupControlHover(btn, defaultColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, self.Animation.FastTween, {
                BackgroundColor3 = LightenColor(defaultColor, 0.15)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, self.Animation.FastTween, {
                BackgroundColor3 = defaultColor
            }):Play()
        end)
    end
    
    setupControlHover(minBtn, self.Theme.Warning)
    setupControlHover(closeBtn, self.Theme.Error)
    
    -- Window Object
    local windowObj = {
        Window = window,
        Content = mainContent,
        Sidebar = sidebar,
        TabContainer = tabContainer,
        Tabs = {},
        ActiveTab = nil,
        AccentColor = accentColor,
        Minimized = false
    }
    
    minBtn.MouseButton1Click:Connect(function()
        windowObj.Minimized = not windowObj.Minimized
        if windowObj.Minimized then
            TweenService:Create(content, self.Animation.TweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(window, self.Animation.TweenInfo, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, 60)}):Play()
            minBtn.Text = "+"
        else
            TweenService:Create(content, self.Animation.TweenInfo, {Size = UDim2.new(1, 0, 1, -60)}):Play()
            TweenService:Create(window, self.Animation.TweenInfo, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, 520)}):Play()
            minBtn.Text = "−"
        end
    end)
    
    function windowObj:AddTab(name, iconId)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name .. "Tab"
        tabBtn.BackgroundColor3 = self.Theme.Elevated
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, 0, 0, 42)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = "  " .. name
        tabBtn.TextColor3 = self.Theme.TextSecondary
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabBtn
        
        -- Icon
        if iconId then
            tabBtn.Text = "      " .. name
            local icon = Instance.new("ImageLabel")
            icon.BackgroundTransparency = 1
            icon.Position = UDim2.new(0, 12, 0.5, -10)
            icon.Size = UDim2.new(0, 20, 0, 20)
            icon.Image = typeof(iconId) == "number" and "rbxassetid://" .. iconId or iconId
            icon.ImageColor3 = self.Theme.TextSecondary
            icon.Parent = tabBtn
        end
        
        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = self.Theme.Border
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = mainContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.PaddingTop = UDim.new(0, 5)
        contentPadding.Parent = tabContent
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 15)
        contentLayout.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local tabObj = {
            Button = tabBtn,
            Content = tabContent,
            Name = name,
            Sections = {}
        }
        
        tabBtn.MouseButton1Click:Connect(function()
            if self.ActiveTab == tabObj then return end
            
            if self.ActiveTab then
                TweenService:Create(self.ActiveTab.Button, self.Animation.FastTween, {
                    BackgroundTransparency = 1,
                    TextColor3 = self.Theme.TextSecondary
                }):Play()
                if self.ActiveTab.Button:FindFirstChild("ImageLabel") then
                    TweenService:Create(self.ActiveTab.Button:FindFirstChild("ImageLabel"), self.Animation.FastTween, {
                        ImageColor3 = self.Theme.TextSecondary
                    }):Play()
                end
                self.ActiveTab.Content.Visible = false
            end
            
            TweenService:Create(tabBtn, self.Animation.FastTween, {
                BackgroundTransparency = 0,
                TextColor3 = self.Theme.TextPrimary
            }):Play()
            if tabBtn:FindFirstChild("ImageLabel") then
                TweenService:Create(tabBtn:FindFirstChild("ImageLabel"), self.Animation.FastTween, {
                    ImageColor3 = self.Theme.TextPrimary
                }):Play()
            end
            
            tabContent.Visible = true
            self.ActiveTab = tabObj
        end)
        
        if not self.ActiveTab then
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = self.Theme.TextPrimary
            if tabBtn:FindFirstChild("ImageLabel") then
                tabBtn:FindFirstChild("ImageLabel").ImageColor3 = self.Theme.TextPrimary
            end
            tabContent.Visible = true
            self.ActiveTab = tabObj
        end
        
        table.insert(self.Tabs, tabObj)
        return tabObj
    end
    
    function windowObj:AddSection(tab, title)
        local section = Instance.new("Frame")
        section.Name = title .. "Section"
        section.BackgroundColor3 = self.Theme.Surface
        section.BorderSizePixel = 0
        section.Size = UDim2.new(1, -10, 0, 0)
        section.AutomaticSize = Enum.AutomaticSize.Y
        section.Parent = tab.Content
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 12)
        sectionCorner.Parent = section
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = self.Theme.Border
        sectionStroke.Thickness = 1
        sectionStroke.Parent = section
        
        -- Header
        local header = Instance.new("Frame")
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 44)
        header.Parent = section
        
        local headerText = Instance.new("TextLabel")
        headerText.BackgroundTransparency = 1
        headerText.Position = UDim2.new(0, 16, 0, 0)
        headerText.Size = UDim2.new(1, -32, 1, 0)
        headerText.Font = Enum.Font.GothamBold
        headerText.Text = title
        headerText.TextColor3 = self.Theme.TextPrimary
        headerText.TextSize = 15
        headerText.TextXAlignment = Enum.TextXAlignment.Left
        headerText.Parent = header
        
        -- Divider
        local divider = Instance.new("Frame")
        divider.BackgroundColor3 = self.Theme.Border
        divider.BorderSizePixel = 0
        divider.Position = UDim2.new(0, 16, 0, 43)
        divider.Size = UDim2.new(1, -32, 0, 1)
        divider.Parent = section
        
        -- Container
        local container = Instance.new("Frame")
        container.BackgroundTransparency = 1
        container.Position = UDim2.new(0, 16, 0, 52)
        container.Size = UDim2.new(1, -32, 0, 0)
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.Parent = section
        
        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Padding = UDim.new(0, 12)
        containerLayout.Parent = container
        
        containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            section.Size = UDim2.new(1, -10, 0, 52 + containerLayout.AbsoluteContentSize.Y + 16)
        end)
        
        local sectionObj = {
            Container = container,
            Elements = {}
        }
        
        table.insert(tab.Sections, sectionObj)
        return sectionObj
    end
    
    function windowObj:AddToggle(section, config)
        config = config or {}
        local text = config.Text or "Toggle"
        local default = config.Default or false
        local callback = config.Callback or function() end
        
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 32)
        holder.Parent = section.Container
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = self.Theme.TextSecondary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "Toggle"
        toggleBtn.AnchorPoint = Vector2.new(1, 0.5)
        toggleBtn.BackgroundColor3 = default and self.AccentColor or self.Theme.Border
        toggleBtn.Position = UDim2.new(1, 0, 0.5, 0)
        toggleBtn.Size = UDim2.new(0, 48, 0, 26)
        toggleBtn.Text = ""
        toggleBtn.Parent = holder
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBtn
        
        local circle = Instance.new("Frame")
        circle.Name = "Circle"
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.BackgroundColor3 = Color3.new(1, 1, 1)
        circle.Position = default and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 13, 0.5, 0)
        circle.Size = UDim2.new(0, 20, 0, 20)
        circle.Parent = toggleBtn
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = circle
        
        local enabled = default
        
        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            callback(enabled)
            
            TweenService:Create(toggleBtn, self.Animation.TweenInfo, {
                BackgroundColor3 = enabled and self.AccentColor or self.Theme.Border
            }):Play()
            TweenService:Create(circle, self.Animation.SpringTween, {
                Position = enabled and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 13, 0.5, 0)
            }):Play()
        end)
        
        return {
            SetValue = function(value)
                enabled = value
                toggleBtn.BackgroundColor3 = enabled and self.AccentColor or self.Theme.Border
                circle.Position = enabled and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 13, 0.5, 0)
                callback(enabled)
            end,
            GetValue = function() return enabled end
        }
    end
    
    function windowObj:AddSlider(section, config)
        config = config or {}
        local text = config.Text or "Slider"
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local suffix = config.Suffix or ""
        local callback = config.Callback or function() end
        
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 50)
        holder.Parent = section.Container
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -60, 0, 20)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = self.Theme.TextSecondary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(1, -60, 0, 0)
        valueLabel.Size = UDim2.new(0, 60, 0, 20)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = tostring(default) .. suffix
        valueLabel.TextColor3 = self.AccentColor
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = holder
        
        local sliderBg = Instance.new("Frame")
        sliderBg.BackgroundColor3 = self.Theme.Elevated
        sliderBg.BorderSizePixel = 0
        sliderBg.Position = UDim2.new(0, 0, 0, 30)
        sliderBg.Size = UDim2.new(1, 0, 0, 8)
        sliderBg.Parent = holder
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.BackgroundColor3 = self.AccentColor
        sliderFill.BorderSizePixel = 0
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.Parent = sliderBg
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill
        
        local handle = Instance.new("Frame")
        handle.AnchorPoint = Vector2.new(0.5, 0.5)
        handle.BackgroundColor3 = Color3.new(1, 1, 1)
        handle.Position = UDim2.new(1, 0, 0.5, 0)
        handle.Size = UDim2.new(0, 16, 0, 16)
        handle.Parent = sliderFill
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(1, 0)
        handleCorner.Parent = handle
        
        local handleStroke = Instance.new("UIStroke")
        handleStroke.Color = self.AccentColor
        handleStroke.Thickness = 2
        handleStroke.Parent = handle
        
        local dragging = false
        
        local function update(input)
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            valueLabel.Text = tostring(value) .. suffix
            callback(value)
        end
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(input)
            end
        end)
        
        sliderBg.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return {
            SetValue = function(value)
                value = math.clamp(value, min, max)
                local pos = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                valueLabel.Text = tostring(value) .. suffix
                callback(value)
            end
        }
    end
    
    function windowObj:AddButton(section, config)
        config = config or {}
        local text = config.Text or "Button"
        local callback = config.Callback or function() end
        local style = config.Style or "Primary"
        
        local colors = {
            Primary = self.AccentColor,
            Secondary = self.Theme.Secondary,
            Danger = self.Theme.Error
        }
        
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = colors[style] or self.AccentColor
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.Parent = section.Container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, self.Animation.FastTween, {
                BackgroundColor3 = LightenColor(colors[style] or self.AccentColor, 0.1)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, self.Animation.FastTween, {
                BackgroundColor3 = colors[style] or self.AccentColor
            }):Play()
        end)
        
        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, self.Animation.FastTween, {
                Size = UDim2.new(0.98, 0, 0, 36),
                Position = UDim2.new(0.01, 0, 0, 1)
            }):Play()
        end)
        
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, self.Animation.SpringTween, {
                Size = UDim2.new(1, 0, 0, 38),
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end)
        
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    function windowObj:AddInput(section, config)
        config = config or {}
        local placeholder = config.Placeholder or "Enter text..."
        local callback = config.Callback or function() end
        local numeric = config.Numeric or false
        
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 44)
        holder.Parent = section.Container
        
        local box = Instance.new("TextBox")
        box.BackgroundColor3 = self.Theme.Elevated
        box.BorderSizePixel = 0
        box.ClearTextOnFocus = false
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = self.Theme.TextMuted
        box.Size = UDim2.new(1, 0, 1, 0)
        box.Font = Enum.Font.Gotham
        box.Text = ""
        box.TextColor3 = self.Theme.TextPrimary
        box.TextSize = 14
        box.Parent = holder
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 10)
        boxCorner.Parent = box
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 14)
        padding.PaddingRight = UDim.new(0, 14)
        padding.Parent = box
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = self.Theme.Border
        stroke.Thickness = 1
        stroke.Parent = box
        
        box.Focused:Connect(function()
            TweenService:Create(box, self.Animation.FastTween, {
                BackgroundColor3 = LightenColor(self.Theme.Elevated, 0.03)
            }):Play()
            TweenService:Create(stroke, self.Animation.FastTween, {
                Color = self.AccentColor
            }):Play()
        end)
        
        box.FocusLost:Connect(function(enterPressed)
            TweenService:Create(box, self.Animation.FastTween, {
                BackgroundColor3 = self.Theme.Elevated
            }):Play()
            TweenService:Create(stroke, self.Animation.FastTween, {
                Color = self.Theme.Border
            }):Play()
            
            if numeric and box.Text ~= "" then
                local num = tonumber(box.Text)
                if num then
                    callback(num)
                end
            elseif enterPressed then
                callback(box.Text)
            end
        end)
        
        return {
            GetText = function() return box.Text end,
            SetText = function(text) box.Text = text end
        }
    end
    
    function windowObj:AddDropdown(section, config)
        config = config or {}
        local text = config.Text or "Dropdown"
        local options = config.Options or {}
        local default = config.Default
        local callback = config.Callback or function() end
        
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 68)
        holder.Parent = section.Container
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = self.Theme.TextSecondary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder
        
        local dropBtn = Instance.new("TextButton")
        dropBtn.BackgroundColor3 = self.Theme.Elevated
        dropBtn.BorderSizePixel = 0
        dropBtn.Position = UDim2.new(0, 0, 0, 26)
        dropBtn.Size = UDim2.new(1, 0, 0, 42)
        dropBtn.Font = Enum.Font.Gotham
        dropBtn.Text = default or options[1] or "Select..."
        dropBtn.TextColor3 = self.Theme.TextPrimary
        dropBtn.TextSize = 14
        dropBtn.Parent = holder
        
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 10)
        dropCorner.Parent = dropBtn
        
        local dropStroke = Instance.new("UIStroke")
        dropStroke.Color = self.Theme.Border
        dropStroke.Thickness = 1
        dropStroke.Parent = dropBtn
        
        local arrow = Instance.new("ImageLabel")
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -35, 0, 11)
        arrow.Size = UDim2.new(0, 20, 0, 20)
        arrow.Image = "rbxassetid://6031091004"
        arrow.ImageColor3 = self.Theme.TextMuted
        arrow.Parent = dropBtn
        
        local menu = Instance.new("Frame")
        menu.BackgroundColor3 = self.Theme.Surface
        menu.BorderSizePixel = 0
        menu.Position = UDim2.new(0, 0, 1, 8)
        menu.Size = UDim2.new(1, 0, 0, 0)
        menu.Visible = false
        menu.ZIndex = 10
        menu.Parent = dropBtn
        
        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 10)
        menuCorner.Parent = menu
        
        local menuStroke = Instance.new("UIStroke")
        menuStroke.Color = self.Theme.Border
        menuStroke.Thickness = 1
        menuStroke.Parent = menu
        
        local menuContainer = Instance.new("ScrollingFrame")
        menuContainer.BackgroundTransparency = 1
        menuContainer.Size = UDim2.new(1, 0, 1, -16)
        menuContainer.Position = UDim2.new(0, 0, 0, 8)
        menuContainer.ScrollBarThickness = 2
        menuContainer.ScrollBarImageColor3 = self.Theme.Border
        menuContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        menuContainer.ZIndex = 10
        menuContainer.Parent = menu
        
        local menuList = Instance.new("UIListLayout")
        menuList.Padding = UDim.new(0, 4)
        menuList.Parent = menuContainer
        
        menuList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            menuContainer.CanvasSize = UDim2.new(0, 0, 0, menuList.AbsoluteContentSize.Y + 10)
        end)
        
        local open = false
        
        local function buildMenu()
            for _, child in pairs(menuContainer:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            
            for _, option in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3 = self.Theme.Elevated
                optBtn.BackgroundTransparency = 1
                optBtn.Size = UDim2.new(1, -16, 0, 34)
                optBtn.Position = UDim2.new(0, 8, 0, 0)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = option
                optBtn.TextColor3 = self.Theme.TextSecondary
                optBtn.TextSize = 14
                optBtn.ZIndex = 10
                optBtn.Parent = menuContainer
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 8)
                optCorner.Parent = optBtn
                
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, self.Animation.FastTween, {
                        BackgroundTransparency = 0,
                        TextColor3 = self.Theme.TextPrimary
                    }):Play()
                end)
                
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, self.Animation.FastTween, {
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextSecondary
                    }):Play()
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    dropBtn.Text = option
                    callback(option)
                    open = false
                    menu.Visible = false
                    arrow.Rotation = 0
                end)
            end
        end
        
        dropBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                buildMenu()
                menu.Visible = true
                TweenService:Create(menu, self.Animation.TweenInfo, {
                    Size = UDim2.new(1, 0, 0, math.min(200, #options * 38 + 16))
                }):Play()
                TweenService:Create(arrow, self.Animation.TweenInfo, {Rotation = 180}):Play()
                TweenService:Create(dropStroke, self.Animation.FastTween, {Color = self.AccentColor}):Play()
            else
                menu.Visible = false
                arrow.Rotation = 0
                dropStroke.Color = self.Theme.Border
            end
        end)
        
        return {
            SetOptions = function(newOptions)
                options = newOptions
                dropBtn.Text = options[1] or "Select..."
            end
        }
    end
    
    function windowObj:AddKeybind(section, config)
        config = config or {}
        local text = config.Text or "Keybind"
        local default = config.Default
        local callback = config.Callback or function() end
        
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 32)
        holder.Parent = section.Container
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -90, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = self.Theme.TextSecondary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.BackgroundColor3 = self.Theme.Elevated
        keyBtn.BorderSizePixel = 0
        keyBtn.AnchorPoint = Vector2.new(1, 0.5)
        keyBtn.Position = UDim2.new(1, 0, 0.5, 0)
        keyBtn.Size = UDim2.new(0, 80, 0, 28)
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.Text = default and default.Name or "None"
        keyBtn.TextColor3 = self.Theme.TextPrimary
        keyBtn.TextSize = 12
        keyBtn.Parent = holder
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 6)
        keyCorner.Parent = keyBtn
        
        local listening = false
        
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode ~= Enum.KeyCode.Escape then
                        keyBtn.Text = input.KeyCode.Name
                        callback(input.KeyCode)
                    else
                        keyBtn.Text = "None"
                        callback(nil)
                    end
                    listening = false
                    connection:Disconnect()
                end
            end)
        end)
        
        return {
            GetKey = function()
                local keyText = keyBtn.Text
                return keyText ~= "None" and Enum.KeyCode[keyText] or nil
            end
        }
    end
    
    function windowObj:AddColorPicker(section, config)
        config = config or {}
        local text = config.Text or "Color"
        local default = config.Default or Color3.fromRGB(255, 255, 255)
        local callback = config.Callback or function() end
        
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 32)
        holder.Parent = section.Container
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = self.Theme.TextSecondary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = holder
        
        local colorBtn = Instance.new("TextButton")
        colorBtn.BackgroundColor3 = default
        colorBtn.BorderSizePixel = 0
        colorBtn.AnchorPoint = Vector2.new(1, 0.5)
        colorBtn.Position = UDim2.new(1, 0, 0.5, 0)
        colorBtn.Size = UDim2.new(0, 40, 0, 24)
        colorBtn.Text = ""
        colorBtn.Parent = holder
        
        local colorCorner = Instance.new("UICorner")
        colorCorner.CornerRadius = UDim.new(0, 6)
        colorCorner.Parent = colorBtn
        
        local colorStroke = Instance.new("UIStroke")
        colorStroke.Color = self.Theme.Border
        colorStroke.Thickness = 2
        colorStroke.Parent = colorBtn
        
        colorBtn.MouseButton1Click:Connect(function()
            -- Simple color picker toggle
            callback(colorBtn.BackgroundColor3)
        end)
        
        return {
            SetColor = function(color)
                colorBtn.BackgroundColor3 = color
                callback(color)
            end
        }
    end
    
    table.insert(self.Windows, windowObj)
    return windowObj
end

-- Global API
function VoidFrame:SetTheme(theme)
    for key, value in pairs(theme) do
        if self.Theme[key] then
            self.Theme[key] = value
        end
    end
end

function VoidFrame:GetTheme()
    return self.Theme
end

return VoidFrame
