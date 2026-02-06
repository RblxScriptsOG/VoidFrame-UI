--[[

 __   __     ______     ______     ______     __         ______     ______     ______    
/\ \ / /    /\  ___\   /\  ___\   /\  == \   /\ \       /\  __ \   /\  ___\   /\  ___\   
\ \ \'/     \ \  __\   \ \ \____  \ \  __<   \ \ \____  \ \  __ \  \ \ \__ \  \ \  __\   
 \ \__|      \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\ 
  \/_/        \/_____/   \/_____/   \/_/ /_/   \/_____/   \/_/\/_/   \/_____/   \/_____/ 

                V O I D F R A M E   L I B R A R Y  [ENHANCED]
           Fully Customizable - Resizable - Dynamic Theming
           
--]]

local VoidFrame = {}
VoidFrame._version = "1.0"

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Safe CoreGui access
local GuiParent = CoreGui
if not GuiParent then
    local player = Players.LocalPlayer
    if player then
        GuiParent = player:WaitForChild("PlayerGui")
    end
end

-- Default Themes (Fully Customizable)
VoidFrame.Themes = {
    RetroGreen = {
        Name = "RetroGreen",
        Background = Color3.fromRGB(5, 5, 5),
        Surface = Color3.fromRGB(15, 15, 15),
        Header = Color3.fromRGB(0, 40, 0),
        Accent = Color3.fromRGB(0, 255, 70),
        AccentDark = Color3.fromRGB(0, 180, 50),
        AccentDarker = Color3.fromRGB(0, 100, 30),
        Text = Color3.fromRGB(0, 255, 100),
        TextDim = Color3.fromRGB(0, 180, 80),
        Border = Color3.fromRGB(0, 150, 50),
        BorderDark = Color3.fromRGB(0, 80, 30),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        BorderSize = 2,
        UseGradient = false
    },
    
    RetroAmber = {
        Name = "RetroAmber",
        Background = Color3.fromRGB(15, 10, 0),
        Surface = Color3.fromRGB(25, 18, 5),
        Header = Color3.fromRGB(40, 30, 0),
        Accent = Color3.fromRGB(255, 180, 0),
        AccentDark = Color3.fromRGB(200, 140, 0),
        AccentDarker = Color3.fromRGB(120, 90, 0),
        Text = Color3.fromRGB(255, 200, 50),
        TextDim = Color3.fromRGB(200, 160, 40),
        Border = Color3.fromRGB(180, 130, 0),
        BorderDark = Color3.fromRGB(100, 75, 0),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        BorderSize = 2,
        UseGradient = false
    },
    
    RetroBlue = {
        Name = "RetroBlue",
        Background = Color3.fromRGB(0, 5, 15),
        Surface = Color3.fromRGB(5, 10, 25),
        Header = Color3.fromRGB(0, 20, 50),
        Accent = Color3.fromRGB(0, 200, 255),
        AccentDark = Color3.fromRGB(0, 140, 200),
        AccentDarker = Color3.fromRGB(0, 80, 120),
        Text = Color3.fromRGB(100, 220, 255),
        TextDim = Color3.fromRGB(80, 170, 220),
        Border = Color3.fromRGB(0, 150, 200),
        BorderDark = Color3.fromRGB(0, 80, 120),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        BorderSize = 2,
        UseGradient = false
    },
    
    Matrix = {
        Name = "Matrix",
        Background = Color3.fromRGB(0, 8, 0),
        Surface = Color3.fromRGB(0, 15, 0),
        Header = Color3.fromRGB(0, 25, 0),
        Accent = Color3.fromRGB(0, 255, 80),
        AccentDark = Color3.fromRGB(0, 200, 60),
        AccentDarker = Color3.fromRGB(0, 120, 35),
        Text = Color3.fromRGB(0, 255, 90),
        TextDim = Color3.fromRGB(0, 200, 70),
        Border = Color3.fromRGB(0, 180, 50),
        BorderDark = Color3.fromRGB(0, 100, 30),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        BorderSize = 2,
        UseGradient = true
    },
    
    Blood = {
        Name = "Blood",
        Background = Color3.fromRGB(15, 0, 0),
        Surface = Color3.fromRGB(25, 5, 5),
        Header = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 30, 30),
        AccentDark = Color3.fromRGB(200, 20, 20),
        AccentDarker = Color3.fromRGB(120, 10, 10),
        Text = Color3.fromRGB(255, 80, 80),
        TextDim = Color3.fromRGB(200, 60, 60),
        Border = Color3.fromRGB(180, 20, 20),
        BorderDark = Color3.fromRGB(100, 10, 10),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        BorderSize = 2,
        UseGradient = false
    },
    
    PurpleHaze = {
        Name = "PurpleHaze",
        Background = Color3.fromRGB(10, 0, 15),
        Surface = Color3.fromRGB(18, 5, 25),
        Header = Color3.fromRGB(30, 0, 45),
        Accent = Color3.fromRGB(180, 50, 255),
        AccentDark = Color3.fromRGB(140, 35, 200),
        AccentDarker = Color3.fromRGB(90, 20, 130),
        Text = Color3.fromRGB(220, 100, 255),
        TextDim = Color3.fromRGB(180, 80, 220),
        Border = Color3.fromRGB(150, 40, 200),
        BorderDark = Color3.fromRGB(80, 20, 120),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        BorderSize = 2,
        UseGradient = true
    },
    
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 28),
        Header = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(100, 150, 255),
        AccentDark = Color3.fromRGB(80, 120, 220),
        AccentDarker = Color3.fromRGB(50, 80, 150),
        Text = Color3.fromRGB(200, 210, 255),
        TextDim = Color3.fromRGB(150, 160, 200),
        Border = Color3.fromRGB(70, 100, 180),
        BorderDark = Color3.fromRGB(40, 60, 120),
        Font = Enum.Font.GothamBold,
        MonoFont = Enum.Font.Code,
        BorderSize = 1,
        UseGradient = true
    }
}

VoidFrame.CurrentTheme = VoidFrame.Themes.RetroGreen
VoidFrame.ActiveWindows = {}

-- Utility
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" and v ~= nil then
            obj[k] = v
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function ApplyThemeToObject(obj, theme)
    if not obj or not theme then return end
    
    -- Apply colors based on object type and name
    if obj:IsA("Frame") or obj:IsA("TextButton") then
        if obj.Name == "Header" then
            obj.BackgroundColor3 = theme.Header
            obj.BorderColor3 = theme.Border
        elseif obj.Name == "Main" or obj.Name:find("Main") then
            obj.BackgroundColor3 = theme.Background
            obj.BorderColor3 = theme.Border
        elseif obj.Name:find("Surface") or obj.Name:find("Content") or obj.Name:find("Sidebar") then
            obj.BackgroundColor3 = theme.Surface
            obj.BorderColor3 = theme.BorderDark
        else
            obj.BackgroundColor3 = theme.Surface
            obj.BorderColor3 = theme.Border
        end
    end
    
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        if obj.TextColor3 ~= Color3.new(1, 1, 1) and obj.TextColor3 ~= Color3.new(0, 0, 0) then
            -- Only override if not default
            if obj.Font == Enum.Font.Arcade or obj.Font == Enum.Font.GothamBold then
                obj.TextColor3 = theme.Text
            else
                obj.TextColor3 = theme.TextDim
            end
        end
        obj.Font = theme.Font
    end
    
    if obj:IsA("TextButton") and obj.Name:find("Tab") or obj.Name:find("Button") then
        obj.BackgroundColor3 = theme.AccentDark
    end
end

-- Notification System
VoidFrame.NotificationSystem = {
    Screen = nil,
    Container = nil,
    Active = {},
    
    Init = function(self)
        if self.Screen then return end
        
        self.Screen = Create("ScreenGui", {
            Name = "VF_Notifs",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = GuiParent
        })
        
        self.Container = Create("Frame", {
            Size = UDim2.new(0, 400, 1, 0),
            Position = UDim2.new(1, -420, 0, 20),
            BackgroundTransparency = 1,
            Parent = self.Screen
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = self.Container
        })
    end,
    
    Notify = function(self, title, message, duration, type)
        duration = duration or 3
        type = type or "Info"
        local theme = VoidFrame.CurrentTheme
        
        self:Init()
        
        local colors = {
            Info = theme.Text,
            Success = Color3.fromRGB(0, 255, 100),
            Warning = Color3.fromRGB(255, 200, 0),
            Error = Color3.fromRGB(255, 50, 50)
        }
        
        local notif = Create("Frame", {
            Size = UDim2.new(0, 380, 0, 70),
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 2,
            BorderColor3 = theme.Border,
            Parent = self.Container
        })
        
        -- Glow effect (optional)
        if theme.UseGradient then
            local glow = Create("ImageLabel", {
                Size = UDim2.new(1, 20, 1, 20),
                Position = UDim2.new(0, -10, 0, -10),
                BackgroundTransparency = 1,
                Image = "rbxassetid://5028857084",
                ImageColor3 = colors[type],
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(24, 24, 276, 276),
                ZIndex = 0,
                Parent = notif
            })
        end
        
        local header = Create("Frame", {
            Name = "Header",
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = theme.Header,
            BorderSizePixel = 0,
            ZIndex = 2,
            Parent = notif
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = "► " .. (title or "INFO"),
            TextColor3 = colors[type],
            Font = theme.MonoFont,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = header
        })
        
        Create("TextButton", {
            Size = UDim2.new(0, 26, 0, 26),
            Position = UDim2.new(1, -26, 0, 0),
            BackgroundTransparency = 1,
            Text = "×",
            TextColor3 = theme.TextDim,
            Font = theme.MonoFont,
            TextSize = 18,
            ZIndex = 3,
            Parent = header
        }).MouseButton1Click:Connect(function()
            notif:Destroy()
        end)
        
        Create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 40),
            Position = UDim2.new(0, 8, 0, 28),
            BackgroundTransparency = 1,
            Text = message or "",
            TextColor3 = theme.Text,
            Font = theme.Font,
            TextSize = 12,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 2,
            Parent = notif
        })
        
        table.insert(self.Active, notif)
        
        -- Auto remove
        task.delay(duration, function()
            if notif and notif.Parent then
                notif:Destroy()
            end
        end)
        
        -- Limit notifications
        if #self.Active > 6 then
            local old = table.remove(self.Active, 1)
            if old and old.Parent then
                old:Destroy()
            end
        end
    end
}

-- Window Creation
function VoidFrame:CreateWindow(config)
    config = config or {}
    
    local title = config.Title or "VOID FRAME"
    local subtitle = config.Subtitle or ""
    local width = config.Width or 650
    local height = config.Height or 480
    local minWidth = config.MinWidth or 400
    local minHeight = config.MinHeight or 300
    local theme = config.Theme or self.CurrentTheme
    local keybind = config.Keybind or Enum.KeyCode.RightShift
    local canResize = config.CanResize ~= false
    local startMinimized = config.StartMinimized or false
    local showTitleBar = config.ShowTitleBar ~= false
    
    -- Main ScreenGui
    local screen = Create("ScreenGui", {
        Name = "VoidFrame_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = GuiParent
    })
    
    -- Main Container
    local main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 2,
        BorderColor3 = theme.Border,
        Active = true,
        Visible = not startMinimized,
        Parent = screen
    })
    
    -- Shadow/Glow
    if theme.UseGradient then
        local shadow = Create("ImageLabel", {
            Name = "Shadow",
            Size = UDim2.new(1, 60, 1, 60),
            Position = UDim2.new(0, -30, 0, -30),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5028857084",
            ImageColor3 = theme.Accent,
            ImageTransparency = 0.95,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0,
            Parent = main
        })
    end
    
    -- Title Bar
    local titleBar = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, -4, 0, 42),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = main
    })
    
    -- Title Text
    local titleText = Create("TextLabel", {
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = theme.Accent,
        Font = theme.MonoFont,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    if subtitle ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(1, -140, 0, 16),
            Position = UDim2.new(0, 12, 1, -18),
            BackgroundTransparency = 1,
            Text = subtitle,
            TextColor3 = theme.TextDim,
            Font = theme.MonoFont,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleBar
        })
    end
    
    -- Control Buttons Container
    local controls = Create("Frame", {
        Size = UDim2.new(0, 110, 0, 34),
        Position = UDim2.new(1, -115, 0, 4),
        BackgroundTransparency = 1,
        Parent = titleBar
    })
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        BackgroundColor3 = theme.AccentDark,
        Text = "─",
        TextColor3 = theme.Text,
        Font = theme.MonoFont,
        TextSize = 14,
        Parent = controls
    })
    
    -- Resize Toggle Button
    local resizeBtn = Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 36, 0, 0),
        BackgroundColor3 = theme.AccentDark,
        Text = "◰",
        TextColor3 = theme.Text,
        Font = theme.MonoFont,
        TextSize = 14,
        Visible = canResize,
        Parent = controls
    })
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 72, 0, 0),
        BackgroundColor3 = theme.AccentDarker,
        Text = "✕",
        TextColor3 = theme.Text,
        Font = theme.MonoFont,
        TextSize = 14,
        Parent = controls
    })
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 4, 0, 46),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 1,
        BorderColor3 = theme.BorderDark,
        Parent = main
    })
    
    local tabList = Create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar
    })
    
    local tabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = tabList
    })
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area
    local contentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -162, 1, -50),
        Position = UDim2.new(0, 158, 0, 46),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 1,
        BorderColor3 = theme.BorderDark,
        ClipsDescendants = true,
        Parent = main
    })
    
    -- Resize Handle
    local resizeHandle = Create("TextButton", {
        Name = "ResizeHandle",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -22, 1, -22),
        BackgroundColor3 = theme.AccentDark,
        Text = "◢",
        TextColor3 = theme.Text,
        Font = theme.MonoFont,
        TextSize = 10,
        Visible = canResize,
        Parent = main
    })
    
    -- Minimized Icon (System Tray style)
    local trayIcon = Create("TextButton", {
        Name = "TrayIcon",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 2,
        BorderColor3 = theme.Border,
        Text = string.sub(title, 1, 1):upper(),
        TextColor3 = theme.Accent,
        Font = theme.Font,
        TextSize = 24,
        Visible = startMinimized,
        Active = true,
        Draggable = true,
        Parent = screen
    })
    
    -- Glow for tray icon
    if theme.UseGradient then
        Create("ImageLabel", {
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0, -10, 0, -10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5028857084",
            ImageColor3 = theme.Accent,
            ImageTransparency = 0.85,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0,
            Parent = trayIcon
        })
    end
    
    -- Window Object
    local window = {
        Theme = theme,
        Screen = screen,
        Main = main,
        TrayIcon = trayIcon,
        ContentFrame = contentFrame,
        Sidebar = sidebar,
        TitleBar = titleBar,
        IsVisible = not startMinimized,
        IsMinimized = startMinimized,
        CanResize = canResize,
        IsResizing = false,
        MinWidth = minWidth,
        MinHeight = minHeight,
        Tabs = {},
        ActiveTab = nil,
        Elements = {},
        OnThemeChange = nil -- Callback for theme updates
    }
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Resizing Logic
    local resizing = false
    local resizeStart, startSize
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = main.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(minWidth, startSize.X.Offset + delta.X)
            local newHeight = math.max(minHeight, startSize.Y.Offset + delta.Y)
            
            main.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    -- Control Button Functions
    local function minimize()
        main.Visible = false
        trayIcon.Visible = true
        trayIcon.Position = UDim2.new(0, main.AbsolutePosition.X, 0, main.AbsolutePosition.Y)
        window.IsMinimized = true
        window.IsVisible = false
    end
    
    local function restore()
        trayIcon.Visible = false
        main.Visible = true
        window.IsMinimized = false
        window.IsVisible = true
    end
    
    local function toggle()
        if window.IsMinimized then
            restore()
        else
            minimize()
        end
    end
    
    minBtn.MouseButton1Click:Connect(minimize)
    trayIcon.MouseButton1Click:Connect(restore)
    
    resizeBtn.MouseButton1Click:Connect(function()
        -- Reset to default size
        TweenService:Create(main, TweenInfo.new(0.2), {
            Size = UDim2.new(0, width, 0, height)
        }):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
        for i, w in pairs(VoidFrame.ActiveWindows) do
            if w == window then
                table.remove(VoidFrame.ActiveWindows, i)
                break
            end
        end
    end)
    
    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keybind then
            toggle()
        end
    end)
    
    -- Tray icon effects
    trayIcon.MouseEnter:Connect(function()
        trayIcon.BackgroundColor3 = theme.AccentDark
    end)
    
    trayIcon.MouseLeave:Connect(function()
        trayIcon.BackgroundColor3 = theme.Header
    end)
    
    -- Hover effects for controls
    local function addHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = hoverColor
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = normalColor
        end)
    end
    
    addHover(minBtn, theme.AccentDark, theme.Accent)
    addHover(resizeBtn, theme.AccentDark, theme.Accent)
    addHover(closeBtn, theme.AccentDarker, Color3.fromRGB(200, 50, 50))
    
    -- Add Tab Function
    function window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local name = tabConfig.Name or "Tab"
        local icon = tabConfig.Icon or ""
        
        local btnText = icon ~= "" and (icon .. " " .. name) or name
        
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, -4, 0, 34),
            BackgroundColor3 = theme.Background,
            BorderSizePixel = 1,
            BorderColor3 = theme.BorderDark,
            Text = btnText,
            TextColor3 = theme.TextDim,
            Font = theme.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabList
        })
        
        local tabContent = Create("ScrollingFrame", {
            Name = name .. "_Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.Accent,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = contentFrame
        })
        
        local contentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = tabContent
        })
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local tab = {
            Name = name,
            Button = tabBtn,
            Content = tabContent,
            Elements = {}
        }
        
        -- Tab selection
        tabBtn.MouseButton1Click:Connect(function()
            if window.ActiveTab then
                window.ActiveTab.Content.Visible = false
                window.ActiveTab.Button.BackgroundColor3 = theme.Background
                window.ActiveTab.Button.TextColor3 = theme.TextDim
                window.ActiveTab.Button.BorderColor3 = theme.BorderDark
            end
            
            window.ActiveTab = tab
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = theme.AccentDark
            tabBtn.TextColor3 = theme.Text
            tabBtn.BorderColor3 = theme.Accent
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                tabBtn.BackgroundColor3 = theme.AccentDarker
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                tabBtn.BackgroundColor3 = theme.Background
            end
        end)
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            tabBtn.BackgroundColor3 = theme.AccentDark
            tabBtn.TextColor3 = theme.Text
            tabBtn.BorderColor3 = theme.Accent
            tabContent.Visible = true
            self.ActiveTab = tab
        end
        
        -- Tab API
        local api = {}
        
        function api:AddSection(text)
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 28),
                BackgroundColor3 = theme.AccentDarker,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = "◆ " .. text:upper(),
                TextColor3 = theme.Text,
                Font = theme.MonoFont,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            return frame
        end
        
        function api:AddLabel(text, style)
            style = style or "Normal"
            local color = style == "Dim" and theme.TextDim or (style == "Accent" and theme.Accent or theme.Text)
            
            local lbl = Create("TextLabel", {
                Size = UDim2.new(1, -12, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = color,
                Font = theme.Font,
                TextSize = 12,
                TextWrapped = true,
                Parent = tabContent
            })
            return lbl
        end
        
        function api:AddDivider(text)
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, text and 24 or 12),
                BackgroundTransparency = 1,
                Parent = tabContent
            })
            
            local lineLeft = Create("Frame", {
                Size = UDim2.new(text and 0.3 or 0.45, 0, 0, 1),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = theme.Border,
                BorderSizePixel = 0,
                Parent = frame
            })
            
            if text then
                Create("TextLabel", {
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Position = UDim2.new(0.3, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextDim,
                    Font = theme.MonoFont,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = frame
                })
            end
            
            local lineRight = Create("Frame", {
                Size = UDim2.new(text and 0.3 or 0.45, 0, 0, 1),
                Position = UDim2.new(text and 0.7 or 0.55, 0, 0.5, 0),
                BackgroundColor3 = theme.Border,
                BorderSizePixel = 0,
                Parent = frame
            })
        end
        
        function api:AddSpacer(height)
            Create("Frame", {
                Size = UDim2.new(1, 0, 0, height or 8),
                BackgroundTransparency = 1,
                Parent = tabContent
            })
        end
        
        function api:AddToggle(config, callback)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 36),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local toggleBg = Create("Frame", {
                Size = UDim2.new(0, 50, 0, 24),
                Position = UDim2.new(1, -62, 0.5, -12),
                BackgroundColor3 = default and theme.Accent or theme.AccentDarker,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = frame
            })
            
            local knob = Create("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                BackgroundColor3 = theme.Text,
                BorderSizePixel = 0,
                Parent = toggleBg
            })
            
            local value = default
            
            local function update(newVal)
                value = newVal
                toggleBg.BackgroundColor3 = value and theme.Accent or theme.AccentDarker
                knob.Position = value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                if callback then callback(value) end
            end
            
            local click = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = frame
            })
            
            click.MouseButton1Click:Connect(function()
                update(not value)
            end)
            
            return {
                Instance = frame,
                GetValue = function() return value end,
                SetValue = update
            }
        end
        
        function api:AddSlider(config, callback)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local suffix = config.Suffix or ""
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 56),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.5, 0, 0, 22),
                Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local valLbl = Create("TextLabel", {
                Size = UDim2.new(0.4, 0, 0, 22),
                Position = UDim2.new(0.5, 0, 0, 4),
                BackgroundTransparency = 1,
                Text = tostring(default) .. suffix,
                TextColor3 = theme.Accent,
                Font = theme.MonoFont,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = frame
            })
            
            local track = Create("Frame", {
                Size = UDim2.new(1, -24, 0, 10),
                Position = UDim2.new(0, 12, 0, 36),
                BackgroundColor3 = theme.AccentDarker,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = frame
            })
            
            local fill = Create("Frame", {
                Size = UDim2.new((default-min)/(max-min), 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Parent = track
            })
            
            local value = default
            local dragging = false
            
            local function update(inputX)
                if not track.Parent then return end
                local rel = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valLbl.Text = tostring(value) .. suffix
                if callback then callback(value) end
            end
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input.Position.X)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input.Position.X)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {
                Instance = frame,
                GetValue = function() return value end,
                SetValue = function(v)
                    value = math.clamp(v, min, max)
                    fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
                    valLbl.Text = tostring(value) .. suffix
                    if callback then callback(value) end
                end
            }
        end
        
        function api:AddButton(config, callback)
            config = config or {}
            local text = config.Text or "Button"
            local style = config.Style or "Default" -- Default, Accent, Danger
            
            local bgColor = style == "Danger" and Color3.fromRGB(120, 30, 30) or 
                           (style == "Accent" and theme.Accent or theme.AccentDark)
            
            local btn = Create("TextButton", {
                Size = UDim2.new(1, -12, 0, 38),
                BackgroundColor3 = bgColor,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Text = text,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 14,
                Parent = tabContent
            })
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = style == "Danger" and Color3.fromRGB(160, 40, 40) or theme.Accent
            end)
            
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = bgColor
            end)
            
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            return {
                Instance = btn,
                Click = function() if callback then callback() end end,
                SetText = function(t) btn.Text = t end
            }
        end
        
        function api:AddDropdown(config, callback)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1] or "Select..."
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 38),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local dropBtn = Create("TextButton", {
                Size = UDim2.new(0.52, 0, 0, 28),
                Position = UDim2.new(0.46, 0, 0.5, -14),
                BackgroundColor3 = theme.AccentDark,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Text = tostring(default),
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = frame
            })
            
            local current = default
            local idx = table.find(options, default) or 1
            
            local menuOpen = false
            local menu = nil
            
            local function closeMenu()
                menuOpen = false
                if menu then
                    menu:Destroy()
                    menu = nil
                end
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                if menuOpen then
                    closeMenu()
                    return
                end
                
                menuOpen = true
                menu = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150)),
                    Position = UDim2.new(0, 0, 1, 4),
                    BackgroundColor3 = theme.Surface,
                    BorderSizePixel = 2,
                    BorderColor3 = theme.Border,
                    ZIndex = 10,
                    Parent = dropBtn
                })
                
                local scroll = Create("ScrollingFrame", {
                    Size = UDim2.new(1, -4, 1, -4),
                    Position = UDim2.new(0, 2, 0, 2),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 2,
                    CanvasSize = UDim2.new(0, 0, 0, #options * 30),
                    Parent = menu
                })
                
                for i, opt in pairs(options) do
                    local optBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        Position = UDim2.new(0, 0, 0, (i-1)*30),
                        BackgroundColor3 = opt == current and theme.AccentDarker or theme.Background,
                        Text = tostring(opt),
                        TextColor3 = opt == current and theme.Accent or theme.Text,
                        Font = theme.Font,
                        TextSize = 12,
                        Parent = scroll
                    })
                    
                    optBtn.MouseButton1Click:Connect(function()
                        current = opt
                        dropBtn.Text = tostring(current)
                        closeMenu()
                        if callback then callback(current) end
                    end)
                end
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and menuOpen then
                    closeMenu()
                end
            end)
            
            return {
                Instance = frame,
                GetValue = function() return current end,
                SetValue = function(v)
                    if table.find(options, v) then
                        current = v
                        dropBtn.Text = tostring(current)
                        if callback then callback(v) end
                    end
                end,
                Refresh = function(newOpts)
                    options = newOpts
                    if not table.find(options, current) then
                        current = options[1] or "Select..."
                        dropBtn.Text = tostring(current)
                    end
                end
            }
        end
        
        function api:AddKeybind(config, callback)
            config = config or {}
            local name = config.Name or "Keybind"
            local default = config.Default or Enum.KeyCode.Unknown
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 36),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local keyBtn = Create("TextButton", {
                Size = UDim2.new(0, 90, 0, 26),
                Position = UDim2.new(1, -102, 0.5, -13),
                BackgroundColor3 = theme.AccentDark,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Text = default ~= Enum.KeyCode.Unknown and default.Name or "NONE",
                TextColor3 = theme.Text,
                Font = theme.MonoFont,
                TextSize = 12,
                Parent = frame
            })
            
            local listening = false
            local currentKey = default
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
                    if callback then callback(currentKey) end
                end
            end)
            
            return {
                Instance = frame,
                GetKey = function() return currentKey end,
                SetKey = function(k)
                    currentKey = k
                    keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
                end
            }
        end
        
        function api:AddTextBox(config, callback)
            config = config or {}
            local name = config.Name or "Input"
            local placeholder = config.Placeholder or "Enter text..."
            local default = config.Default or ""
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 36),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local box = Create("TextBox", {
                Size = UDim2.new(0.54, 0, 0, 26),
                Position = UDim2.new(0.44, 0, 0.5, -13),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Text = default,
                PlaceholderText = placeholder,
                PlaceholderColor3 = theme.TextDim,
                TextColor3 = theme.Text,
                Font = theme.MonoFont,
                TextSize = 12,
                Parent = frame
            })
            
            box.FocusLost:Connect(function(enter)
                if callback then callback(box.Text, enter) end
            end)
            
            return {
                Instance = frame,
                GetText = function() return box.Text end,
                SetText = function(t) box.Text = t end,
                Focus = function() box:CaptureFocus() end
            }
        end
        
        function api:AddColorPicker(config, callback)
            config = config or {}
            local name = config.Name or "Color"
            local default = config.Default or theme.Accent
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 38),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.BorderDark,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local preview = Create("TextButton", {
                Size = UDim2.new(0, 60, 0, 26),
                Position = UDim2.new(1, -72, 0.5, -13),
                BackgroundColor3 = default,
                BorderSizePixel = 2,
                BorderColor3 = theme.Border,
                Text = "",
                Parent = frame
            })
            
            local value = default
            local pickerOpen = false
            
            preview.MouseButton1Click:Connect(function()
                if pickerOpen then return end
                pickerOpen = true
                
                -- Simple color presets
                local colors = {
                    theme.Accent, Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0),
                    Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255),
                    Color3.fromRGB(0,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)
                }
                
                local picker = Create("Frame", {
                    Size = UDim2.new(0, 150, 0, 100),
                    Position = UDim2.new(0, -90, 1, 5),
                    BackgroundColor3 = theme.Surface,
                    BorderSizePixel = 2,
                    BorderColor3 = theme.Border,
                    ZIndex = 20,
                    Parent = preview
                })
                
                for i, col in pairs(colors) do
                    local x = ((i-1) % 3) * 48 + 4
                    local y = math.floor((i-1) / 3) * 32 + 4
                    
                    local btn = Create("TextButton", {
                        Size = UDim2.new(0, 44, 0, 28),
                        Position = UDim2.new(0, x, 0, y),
                        BackgroundColor3 = col,
                        BorderSizePixel = 1,
                        BorderColor3 = theme.Border,
                        Text = "",
                        ZIndex = 21,
                        Parent = picker
                    })
                    
                    btn.MouseButton1Click:Connect(function()
                        value = col
                        preview.BackgroundColor3 = value
                        picker:Destroy()
                        pickerOpen = false
                        if callback then callback(value) end
                    end)
                end
                
                -- Close when clicking outside
                task.delay(0.1, function()
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            picker:Destroy()
                            pickerOpen = false
                            conn:Disconnect()
                        end
                    end)
                end)
            end)
            
            return {
                Instance = frame,
                GetColor = function() return value end,
                SetColor = function(c)
                    value = c
                    preview.BackgroundColor3 = value
                    if callback then callback(value) end
                end
            }
        end
        
        return api
    end
    
    -- Window Methods
    function window:SelectTab(tab)
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
            t.Button.BackgroundColor3 = theme.Background
            t.Button.TextColor3 = theme.TextDim
            t.Button.BorderColor3 = theme.BorderDark
        end
        
        tab.Content.Visible = true
        tab.Button.BackgroundColor3 = theme.AccentDark
        tab.Button.TextColor3 = theme.Text
        tab.Button.BorderColor3 = theme.Accent
        self.ActiveTab = tab
    end
    
    function window:SetTheme(newTheme)
        theme = newTheme
        self.Theme = newTheme
        VoidFrame.CurrentTheme = newTheme
        
        -- Apply to main elements (simplified)
        main.BackgroundColor3 = theme.Background
        main.BorderColor3 = theme.Border
        titleBar.BackgroundColor3 = theme.Header
        sidebar.BackgroundColor3 = theme.Surface
        sidebar.BorderColor3 = theme.BorderDark
        contentFrame.BackgroundColor3 = theme.Surface
        contentFrame.BorderColor3 = theme.BorderDark
        
        -- Update tray icon
        trayIcon.BackgroundColor3 = theme.Header
        trayIcon.BorderColor3 = theme.Border
        trayIcon.TextColor3 = theme.Accent
        
        -- Update all tabs
        for _, tab in pairs(self.Tabs) do
            if tab == self.ActiveTab then
                tab.Button.BackgroundColor3 = theme.AccentDark
                tab.Button.TextColor3 = theme.Text
                tab.Button.BorderColor3 = theme.Accent
            else
                tab.Button.BackgroundColor3 = theme.Background
                tab.Button.TextColor3 = theme.TextDim
                tab.Button.BorderColor3 = theme.BorderDark
            end
        end
        
        -- Callback
        if self.OnThemeChange then
            self.OnThemeChange(newTheme)
        end
    end
    
    function window:Notify(title, msg, duration, type)
        VoidFrame.NotificationSystem:Notify(title, msg, duration, type)
    end
    
    function window:SetVisible(visible)
        if visible then
            if self.IsMinimized then
                trayIcon.Visible = false
                main.Visible = true
                self.IsMinimized = false
            else
                main.Visible = true
            end
        else
            main.Visible = false
        end
        self.IsVisible = visible
    end
    
    function window:Toggle()
        if self.IsMinimized or not main.Visible then
            trayIcon.Visible = false
            main.Visible = true
            self.IsMinimized = false
            self.IsVisible = true
        else
            main.Visible = false
            trayIcon.Visible = true
            trayIcon.Position = UDim2.new(0, main.AbsolutePosition.X, 0, main.AbsolutePosition.Y)
            self.IsMinimized = true
            self.IsVisible = false
        end
    end
    
    function window:SetTitle(newTitle)
        titleText.Text = newTitle:upper()
        trayIcon.Text = string.sub(newTitle, 1, 1):upper()
    end
    
    function window:SetSize(newWidth, newHeight)
        main.Size = UDim2.new(0, math.max(minWidth, newWidth), 0, math.max(minHeight, newHeight))
    end
    
    function window:Center()
        local viewport = workspace.CurrentCamera.ViewportSize
        main.Position = UDim2.new(0, (viewport.X - main.Size.X.Offset) / 2, 0, (viewport.Y - main.Size.Y.Offset) / 2)
    end
    
    function window:Destroy()
        screen:Destroy()
        for i, w in pairs(VoidFrame.ActiveWindows) do
            if w == self then
                table.remove(VoidFrame.ActiveWindows, i)
                break
            end
        end
    end
    
    table.insert(VoidFrame.ActiveWindows, window)
    return window
end

-- Global Methods
function VoidFrame:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = self.Themes[themeName]
        -- Update all windows
        for _, window in pairs(self.ActiveWindows) do
            if window.SetTheme then
                window:SetTheme(self.CurrentTheme)
            end
        end
        return true
    end
    return false
end

function VoidFrame:CreateTheme(name, baseTheme, modifications)
    baseTheme = baseTheme or "RetroGreen"
    local base = self.Themes[baseTheme]
    if not base then return nil end
    
    local newTheme = {}
    for k, v in pairs(base) do
        newTheme[k] = modifications[k] or v
    end
    newTheme.Name = name
    self.Themes[name] = newTheme
    return newTheme
end

function VoidFrame:Notify(title, message, duration, type)
    self.NotificationSystem:Notify(title, message, duration, type)
end

function VoidFrame:GetActiveWindows()
    return self.ActiveWindows
end

-- Cleanup
Players.PlayerRemoving:Connect(function(plr)
    if plr == Players.LocalPlayer then
        for _, window in pairs(VoidFrame.ActiveWindows) do
            if window.Screen then
                window.Screen:Destroy()
            end
        end
        VoidFrame.ActiveWindows = {}
    end
end)

return VoidFrame
