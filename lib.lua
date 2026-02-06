--[[

  _________       .__.__             ___ ___      ___.     
 /   _____/ _____ |__|  |   ____    /   |   \ __ _\_ |__   
 \_____  \ /     \|  |  | _/ __ \  /    ~    \  |  \ __ \  
 /        \  Y Y  \  |  |_\  ___/  \    Y    /  |  / \_\ \ 
/_______  /__|_|  /__|____/\___  >  \___|_  /|____/|___  / 
        \/      \/             \/         \/           \/  

--]]

local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)

local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

--// Asset System for Pixel Textures \\--
local PixelAssets = {
    Scanlines = "rbxassetid://9186554800",
    PixelGrid = "rbxassetid://8659460302",
    CornerPixel = "rbxassetid://12152736228",
    CheckboxEmpty = "rbxassetid://11294917501",
    CheckboxFill = "rbxassetid://11294918800",
    ArrowDown = "rbxassetid://10709791437",
    ArrowRight = "rbxassetid://10709791523",
    SoundBeep = "rbxassetid://6895079853",
    SoundSelect = "rbxassetid://6895080847",
    SoundError = "rbxassetid://6895078492"
}

--// Retro Color Schemes \\--
local RetroSchemes = {
    Default = {
        Background = Color3.fromRGB(20, 12, 28),      -- Deep purple-black
        Primary = Color3.fromRGB(48, 44, 46),         -- Dark gray-brown
        Secondary = Color3.fromRGB(78, 74, 78),       -- Medium gray
        Accent = Color3.fromRGB(210, 125, 44),        -- Retro orange
        AccentAlt = Color3.fromRGB(75, 185, 145),     -- Mint green
        Text = Color3.fromRGB(255, 241, 232),         -- Warm white
        TextDim = Color3.fromRGB(189, 176, 168),      -- Dimmed text
        Border = Color3.fromRGB(131, 118, 156),       -- Purple-gray border
        BorderLight = Color3.fromRGB(189, 176, 168),  -- Light border
        Shadow = Color3.fromRGB(10, 6, 14),           -- Deep shadow
        Error = Color3.fromRGB(255, 0, 77),           -- Neon red
        Success = Color3.fromRGB(0, 255, 128),        -- Neon green
        Warning = Color3.fromRGB(255, 236, 39),       -- Yellow
        Cyan = Color3.fromRGB(41, 173, 255),          -- Cyan
        Pink = Color3.fromRGB(255, 119, 168)          -- Pink
    },
    GreenPhosphor = {
        Background = Color3.fromRGB(0, 15, 0),
        Primary = Color3.fromRGB(0, 25, 0),
        Secondary = Color3.fromRGB(0, 35, 0),
        Accent = Color3.fromRGB(51, 255, 51),
        AccentAlt = Color3.fromRGB(0, 200, 0),
        Text = Color3.fromRGB(200, 255, 200),
        TextDim = Color3.fromRGB(100, 180, 100),
        Border = Color3.fromRGB(0, 100, 0),
        BorderLight = Color3.fromRGB(100, 255, 100),
        Shadow = Color3.fromRGB(0, 5, 0),
        Error = Color3.fromRGB(255, 100, 100),
        Success = Color3.fromRGB(100, 255, 100),
        Warning = Color3.fromRGB(255, 255, 100),
        Cyan = Color3.fromRGB(100, 255, 255),
        Pink = Color3.fromRGB(255, 150, 200)
    },
    Amber = {
        Background = Color3.fromRGB(25, 15, 0),
        Primary = Color3.fromRGB(45, 25, 0),
        Secondary = Color3.fromRGB(65, 35, 0),
        Accent = Color3.fromRGB(255, 176, 0),
        AccentAlt = Color3.fromRGB(255, 140, 0),
        Text = Color3.fromRGB(255, 220, 180),
        TextDim = Color3.fromRGB(200, 160, 120),
        Border = Color3.fromRGB(150, 90, 0),
        BorderLight = Color3.fromRGB(255, 200, 100),
        Shadow = Color3.fromRGB(15, 8, 0),
        Error = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(255, 200, 100),
        Warning = Color3.fromRGB(255, 255, 150),
        Cyan = Color3.fromRGB(180, 230, 255),
        Pink = Color3.fromRGB(255, 180, 200)
    },
    CyanPink = {
        Background = Color3.fromRGB(20, 20, 40),
        Primary = Color3.fromRGB(40, 30, 60),
        Secondary = Color3.fromRGB(60, 50, 90),
        Accent = Color3.fromRGB(255, 0, 255),
        AccentAlt = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(240, 240, 255),
        TextDim = Color3.fromRGB(180, 180, 220),
        Border = Color3.fromRGB(100, 80, 150),
        BorderLight = Color3.fromRGB(200, 180, 255),
        Shadow = Color3.fromRGB(10, 10, 25),
        Error = Color3.fromRGB(255, 80, 120),
        Success = Color3.fromRGB(80, 255, 200),
        Warning = Color3.fromRGB(255, 255, 100),
        Cyan = Color3.fromRGB(0, 255, 255),
        Pink = Color3.fromRGB(255, 0, 255)
    }
}

--// Retro Pixel Fonts (using available fonts) \\--
local RetroFonts = {
    Pixel = Font.new("rbxasset://fonts/families/PressStart2P.json"),  -- Closest to pixel
    Arcade = Font.new("rbxasset://fonts/families/Bangers.json"),       -- Arcade style
    Blocky = Font.new("rbxasset://fonts/families/Oswald.json"),        -- Blocky
    Mono = Font.new("rbxasset://fonts/families/Inconsolata.json"),     -- Retro mono
    Tiny = Font.new("rbxasset://fonts/families/ComingSoon.json")       -- Hand-drawn feel
}

--// Main Library Table \\--
local VoidFrame = {
    Version = "1.0.0",
    LocalPlayer = LocalPlayer,
    ScreenGui = nil,
    
    -- State
    Toggled = true,
    Unloaded = false,
    IsMobile = false,
    DPIScale = 1,
    
    -- Configuration
    Theme = "Default",
    Scheme = RetroSchemes.Default,
    Font = RetroFonts.Pixel,
    FontSize = 12,
    PixelScale = 1,
    
    -- Visual Effects
    ScanlinesEnabled = true,
    CRTDistortion = false,
    PixelSnapping = true,
    
    -- Storage
    Windows = {},
    Tabs = {},
    Options = {},
    Toggles = {},
    Sliders = {},
    Dropdowns = {},
    Notifications = {},
    Signals = {},
    
    -- Audio
    SoundEnabled = true,
    BeepPitch = 1,
    
    -- Templates
    Templates = {
        Window = {
            Title = "VoidFrame",
            Size = UDim2.fromOffset(800, 600),
            Position = UDim2.fromOffset(100, 100),
            MinSize = Vector2.new(400, 300),
            Resizable = true,
            Draggable = true,
            Icon = nil,
            Footer = "F1: Help | ESC: Close",
            AutoShow = true
        },
        
        Tab = {
            Name = "Tab",
            Icon = nil,
            Color = nil
        },
        
        Button = {
            Text = "Button",
            Callback = function() end,
            Dangerous = false,
            Disabled = false,
            DoubleClick = false
        },
        
        Toggle = {
            Text = "Toggle",
            Default = false,
            Callback = function() end,
            Keybind = nil
        },
        
        Slider = {
            Text = "Slider",
            Default = 0,
            Min = 0,
            Max = 100,
            Rounding = 0,
            Suffix = "",
            Callback = function() end
        },
        
        Dropdown = {
            Text = "Dropdown",
            Values = {},
            Default = nil,
            Multi = false,
            Searchable = false,
            Callback = function() end
        },
        
        Input = {
            Text = "Input",
            Default = "",
            Placeholder = "Type here...",
            Numeric = false,
            Finished = true,
            Callback = function() end
        },
        
        ColorPicker = {
            Text = "Color",
            Default = Color3.fromRGB(255, 255, 255),
            Transparency = false,
            Callback = function() end
        },
        
        Keybind = {
            Text = "Keybind",
            Default = "None",
            Mode = "Toggle", -- "Toggle", "Hold", "Always"
            Callback = function() end
        },
        
        Label = {
            Text = "Label",
            Centered = false,
            Color = nil,
            Size = 12
        },
        
        Divider = {
            Text = nil,
            Thick = false
        },
        
        Image = {
            Image = "",
            Color = Color3.new(1, 1, 1),
            Size = UDim2.fromOffset(64, 64),
            Tile = false
        }
    }
}

--// Mobile Detection \\--
do
    local success, platform = pcall(function()
        return UserInputService:GetPlatform()
    end)
    VoidFrame.IsMobile = success and (platform == Enum.Platform.Android or platform == Enum.Platform.IOS)
end

--// Utility Functions \\--
local function Round(value)
    if VoidFrame.PixelSnapping then
        return math.floor(value / VoidFrame.PixelScale) * VoidFrame.PixelScale
    end
    return value
end

local function PlaySound(soundType)
    if not VoidFrame.SoundEnabled then return end
    
    local soundId = PixelAssets.SoundBeep
    local pitch = VoidFrame.BeepPitch
    
    if soundType == "select" then
        soundId = PixelAssets.SoundSelect
        pitch = pitch * 1.2
    elseif soundType == "error" then
        soundId = PixelAssets.SoundError
        pitch = pitch * 0.8
    elseif soundType == "hover" then
        pitch = pitch * 1.5
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.3
    sound.PlaybackSpeed = pitch
    sound.Parent = SoundService
    sound:Play()
    
    task.delay(0.5, function()
        sound:Destroy()
    end)
end

local function SafeCallback(func, ...)
    if type(func) ~= "function" then return end
    local success, err = pcall(func, ...)
    if not success then
        warn("VoidFrame Error: " .. tostring(err))
        PlaySound("error")
    end
    return success
end

--// Instance Creation with Retro Styling \\--
local function Create(className, properties)
    local instance = Instance.new(className)
    
    -- Apply retro pixel snapping to position/size
    if properties.Size and VoidFrame.PixelSnapping then
        local size = properties.Size
        if typeof(size) == "UDim2" then
            properties.Size = UDim2.new(
                size.X.Scale, Round(size.X.Offset),
                size.Y.Scale, Round(size.Y.Offset)
            )
        end
    end
    
    if properties.Position and VoidFrame.PixelSnapping then
        local pos = properties.Position
        if typeof(pos) == "UDim2" then
            properties.Position = UDim2.new(
                pos.X.Scale, Round(pos.X.Offset),
                pos.Y.Scale, Round(pos.Y.Offset)
            )
        end
    end
    
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

--// Pixel Border System \\--
local function AddPixelBorder(parent, thickness, color, shadow)
    thickness = thickness or 2
    color = color or VoidFrame.Scheme.Border
    shadow = shadow ~= false
    
    local frame = Create("Frame", {
        Name = "PixelBorder",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = parent
    })
    
    -- Main border lines
    local top = Create("Frame", {
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, thickness),
        Parent = frame
    })
    
    local bottom = Create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, thickness),
        Parent = frame
    })
    
    local left = Create("Frame", {
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Size = UDim2.new(0, thickness, 1, 0),
        Parent = frame
    })
    
    local right = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, thickness, 1, 0),
        Parent = frame
    })
    
    -- 3D shadow effect
    if shadow then
        local shadowColor = VoidFrame.Scheme.Shadow
        
        Create("Frame", {
            BackgroundColor3 = shadowColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, thickness, 1, 0),
            Size = UDim2.new(1, 0, 0, thickness),
            Parent = frame
        })
        
        Create("Frame", {
            BackgroundColor3 = shadowColor,
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0, thickness),
            Size = UDim2.new(0, thickness, 1, 0),
            Parent = frame
        })
    end
    
    return frame
end

--// Beveled Button Effect \\--
local function AddBevelEffect(button, pressed)
    pressed = pressed or false
    
    local bevel = Create("Frame", {
        Name = "Bevel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = button
    })
    
    local lightColor = pressed and VoidFrame.Scheme.Shadow or VoidFrame.Scheme.BorderLight
    local darkColor = pressed and VoidFrame.Scheme.BorderLight or VoidFrame.Scheme.Shadow
    
    -- Top highlight
    Create("Frame", {
        BackgroundColor3 = lightColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Parent = bevel
    })
    
    -- Left highlight
    Create("Frame", {
        BackgroundColor3 = lightColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 2, 1, 0),
        Parent = bevel
    })
    
    -- Bottom shadow
    Create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = darkColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = bevel
    })
    
    -- Right shadow
    Create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = darkColor,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 2, 1, 0),
        Parent = bevel
    })
    
    return bevel
end

--// CRT Scanline Effect \\--
local function AddScanlines(parent)
    if not VoidFrame.ScanlinesEnabled then return end
    
    local scanlines = Create("ImageLabel", {
        Name = "Scanlines",
        BackgroundTransparency = 1,
        Image = PixelAssets.Scanlines,
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Tile,
        Size = UDim2.new(1, 0, 1, 0),
        TileSize = UDim2.fromOffset(4, 4),
        ZIndex = 100,
        Parent = parent
    })
    
    return scanlines
end

--// Screen Setup \\--
local function SetupScreen()
    local screenGui = Create("ScreenGui", {
        Name = "VoidFrame_" .. HttpService:GenerateGUID(false),
        DisplayOrder = 999,
        ResetOnSpawn = false,
        Parent = CoreGui
    })
    
    pcall(protectgui, screenGui)
    
    VoidFrame.ScreenGui = screenGui
    
    -- Global cursor replacement
    local cursor = Create("Frame", {
        Name = "RetroCursor",
        BackgroundColor3 = VoidFrame.Scheme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(12, 16),
        Visible = false,
        ZIndex = 1000,
        Parent = screenGui
    })
    
    -- Cursor inner detail
    Create("Frame", {
        BackgroundColor3 = VoidFrame.Scheme.Text,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(4, 4),
        Parent = cursor
    })
    
    Create("Frame", {
        BackgroundColor3 = VoidFrame.Scheme.Text,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 8),
        Size = UDim2.fromOffset(6, 2),
        Parent = cursor
    })
    
    VoidFrame.Cursor = cursor
    
    -- Cursor update
    RunService.RenderStepped:Connect(function()
        if VoidFrame.Toggled and cursor.Parent then
            cursor.Position = UDim2.fromOffset(Mouse.X - 2, Mouse.Y)
            cursor.Visible = true
            UserInputService.MouseIconEnabled = false
        else
            cursor.Visible = false
            UserInputService.MouseIconEnabled = true
        end
    end)
    
    return screenGui
end

--// Notification System \\--
function VoidFrame:Notify(title, message, duration, type)
    duration = duration or 3
    type = type or "info"
    
    local notifContainer = self.NotificationContainer
    if not notifContainer then
        notifContainer = Create("Frame", {
            Name = "Notifications",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -320, 0, 20),
            Size = UDim2.new(0, 300, 1, -40),
            Parent = self.ScreenGui
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = notifContainer
        })
        
        self.NotificationContainer = notifContainer
    end
    
    -- Color based on type
    local accent = self.Scheme.Accent
    if type == "error" then accent = self.Scheme.Error
    elseif type == "success" then accent = self.Scheme.Success
    elseif type == "warning" then accent = self.Scheme.Warning end
    
    local notif = Create("Frame", {
        BackgroundColor3 = self.Scheme.Primary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 60),
        Parent = notifContainer
    })
    
    AddPixelBorder(notif, 2, accent, true)
    AddScanlines(notif)
    
    -- Title bar
    Create("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = notif
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = self.Font,
        Text = string.upper(title),
        TextColor3 = self.Scheme.Background,
        TextSize = 10,
        Position = UDim2.fromOffset(6, 2),
        Size = UDim2.new(1, -12, 0, 14),
        Parent = notif
    })
    
    -- Message
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = self.Font,
        Text = message,
        TextColor3 = self.Scheme.Text,
        TextSize = 10,
        TextWrapped = true,
        Position = UDim2.fromOffset(6, 24),
        Size = UDim2.new(1, -12, 1, -30),
        Parent = notif
    })
    
    PlaySound(type == "error" and "error" or "select")
    
    -- Animate in
    notif.Position = UDim2.new(1, 20, 0, 0)
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- Auto remove
    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 20, 0, 0)
        }):Play()
        
        task.wait(0.3)
        notif:Destroy()
    end)
    
    return notif
end

--// Window Creation \\--
function VoidFrame:CreateWindow(info)
    info = info or {}
    local template = self.Templates.Window
    
    for k, v in pairs(template) do
        if info[k] == nil then
            info[k] = v
        end
    end
    
    if not self.ScreenGui then
        SetupScreen()
    end
    
    local window = {
        Tabs = {},
        ActiveTab = nil,
        IsMinimized = false,
        IsMaximized = false,
        OriginalSize = info.Size,
        OriginalPos = info.Position
    }
    
    -- Main window frame
    local mainFrame = Create("Frame", {
        Name = "Window",
        BackgroundColor3 = self.Scheme.Background,
        BorderSizePixel = 0,
        Position = info.Position,
        Size = info.Size,
        Parent = self.ScreenGui
    })
    
    window.Frame = mainFrame
    
    -- Pixel border
    AddPixelBorder(mainFrame, 3, self.Scheme.Border, true)
    AddScanlines(mainFrame)
    
    -- Title bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Scheme.Primary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 32),
        Parent = mainFrame
    })
    
    AddPixelBorder(titleBar, 2, self.Scheme.Border, false)
    
    -- Title text
    local titleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = self.Font,
        Text = string.upper(info.Title),
        TextColor3 = self.Scheme.Accent,
        TextSize = 12,
        Position = UDim2.fromOffset(10, 8),
        Size = UDim2.new(1, -100, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    -- Window buttons container
    local buttonContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 4),
        Size = UDim2.fromOffset(76, 24),
        Parent = titleBar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        Parent = buttonContainer
    })
    
    -- Minimize button
    local minimizeBtn = Create("TextButton", {
        BackgroundColor3 = self.Scheme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(20, 20),
        Text = "-",
        Font = self.Font,
        TextColor3 = self.Scheme.Text,
        TextSize = 12,
        Parent = buttonContainer
    })
    AddBevelEffect(minimizeBtn)
    
    -- Maximize button
    local maximizeBtn = Create("TextButton", {
        BackgroundColor3 = self.Scheme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(20, 20),
        Text = "□",
        Font = self.Font,
        TextColor3 = self.Scheme.Text,
        TextSize = 10,
        Parent = buttonContainer
    })
    AddBevelEffect(maximizeBtn)
    
    -- Close button
    local closeBtn = Create("TextButton", {
        BackgroundColor3 = self.Scheme.Error,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(20, 20),
        Text = "×",
        Font = self.Font,
        TextColor3 = self.Scheme.Text,
        TextSize = 12,
        Parent = buttonContainer
    })
    AddBevelEffect(closeBtn)
    
    -- Content area
    local contentFrame = Create("Frame", {
        Name = "Content",
        BackgroundColor3 = self.Scheme.Background,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(4, 36),
        Size = UDim2.new(1, -8, 1, -44),
        Parent = mainFrame
    })
    
    AddPixelBorder(contentFrame, 2, self.Scheme.Border, false)
    
    -- Sidebar for tabs
    local sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        BackgroundColor3 = self.Scheme.Primary,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Position = UDim2.fromOffset(4, 4),
        Size = UDim2.new(0, 140, 1, -32),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Scheme.Accent,
        Parent = contentFrame
    })
    
    AddPixelBorder(sidebar, 2, self.Scheme.Border, false)
    
    local sidebarList = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = sidebar
    })
    
    Create("UIPadding", {
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4),
        Parent = sidebar
    })
    
    -- Tab container
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.Scheme.Background,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(152, 4),
        Size = UDim2.new(1, -160, 1, -32),
        Parent = contentFrame
    })
    
    AddPixelBorder(tabContainer, 2, self.Scheme.Border, false)
    
    -- Footer
    local footer = Create("Frame", {
        Name = "Footer",
        BackgroundColor3 = self.Scheme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(4, -24),
        Size = UDim2.new(1, -8, 0, 20),
        Parent = contentFrame
    })
    
    AddPixelBorder(footer, 2, self.Scheme.Border, false)
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = self.Font,
        Text = info.Footer,
        TextColor3 = self.Scheme.TextDim,
        TextSize = 9,
        Position = UDim2.fromOffset(6, 3),
        Size = UDim2.new(1, -12, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = footer
    })
    
    -- Resize handle
    if info.Resizable then
        local resizeHandle = Create("TextButton", {
            Name = "Resize",
            BackgroundColor3 = self.Scheme.Secondary,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.fromOffset(16, 16),
            Text = "",
            Parent = mainFrame
        })
        
        -- Visual indicator
        Create("Frame", {
            BackgroundColor3 = self.Scheme.BorderLight,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(4, 12),
            Size = UDim2.fromOffset(8, 2),
            Parent = resizeHandle
        })
        
        Create("Frame", {
            BackgroundColor3 = self.Scheme.BorderLight,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(8, 8),
            Size = UDim2.fromOffset(4, 2),
            Parent = resizeHandle
        })
        
        Create("Frame", {
            BackgroundColor3 = self.Scheme.BorderLight,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(12, 4),
            Size = UDim2.fromOffset(2, 2),
            Parent = resizeHandle
        })
        
        -- Resize logic
        local resizing = false
        local startPos, startSize
        
        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                startPos = input.Position
                startSize = mainFrame.Size
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startPos
                local newSize = UDim2.fromOffset(
                    math.max(info.MinSize.X, startSize.X.Offset + delta.X),
                    math.max(info.MinSize.Y, startSize.Y.Offset + delta.Y)
                )
                mainFrame.Size = newSize
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
    end
    
    -- Dragging logic
    if info.Draggable then
        local dragging = false
        local dragStart, startPos
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(
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
    end
    
    -- Button functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        PlaySound("beep")
        window.IsMinimized = not window.IsMinimized
        contentFrame.Visible = not window.IsMinimized
        minimizeBtn.Text = window.IsMinimized and "+" or "-"
    end)
    
    maximizeBtn.MouseButton1Click:Connect(function()
        PlaySound("beep")
        if window.IsMaximized then
            mainFrame.Size = window.OriginalSize
            mainFrame.Position = window.OriginalPos
        else
            window.OriginalSize = mainFrame.Size
            window.OriginalPos = mainFrame.Position
            mainFrame.Size = UDim2.new(1, -40, 1, -40)
            mainFrame.Position = UDim2.fromOffset(20, 20)
        end
        window.IsMaximized = not window.IsMaximized
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        PlaySound("error")
        mainFrame:Destroy()
    end)
    
    -- Hover effects
    local function addHover(button, hoverColor)
        button.MouseEnter:Connect(function()
            PlaySound("hover")
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = hoverColor
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = button:IsA("TextButton") and self.Scheme.Secondary or button.BackgroundColor3
            }):Play()
        end)
    end
    
    addHover(minimizeBtn, self.Scheme.AccentAlt)
    addHover(maximizeBtn, self.Scheme.AccentAlt)
    addHover(closeBtn, Color3.fromRGB(200, 50, 50))
    
    -- Window Methods
    function window:AddTab(tabInfo)
        tabInfo = tabInfo or {}
        local template = VoidFrame.Templates.Tab
        
        for k, v in pairs(template) do
            if tabInfo[k] == nil then
                tabInfo[k] = v
            end
        end
        
        local tab = {
            Elements = {},
            Groups = {}
        }
        
        -- Tab button
        local tabBtn = Create("TextButton", {
            BackgroundColor3 = VoidFrame.Scheme.Primary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 28),
            Text = "",
            Parent = sidebar
        })
        
        AddBevelEffect(tabBtn)
        
        local iconLabel
        if tabInfo.Icon then
            iconLabel = Create("ImageLabel", {
                BackgroundTransparency = 1,
                Image = tabInfo.Icon,
                ImageColor3 = VoidFrame.Scheme.TextDim,
                Position = UDim2.fromOffset(6, 6),
                Size = UDim2.fromOffset(16, 16),
                Parent = tabBtn
            })
        end
        
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = VoidFrame.Font,
            Text = string.upper(tabInfo.Name),
            TextColor3 = VoidFrame.Scheme.TextDim,
            TextSize = 10,
            Position = UDim2.fromOffset(tabInfo.Icon and 28 or 8, 6),
            Size = UDim2.new(1, tabInfo.Icon and -36 or -16, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        -- Tab content
        local tabContent = Create("ScrollingFrame", {
            Name = tabInfo.Name,
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = VoidFrame.Scheme.Accent,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = tabContainer
        })
        
        local contentList = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            Parent = tabContent
        })
        
        Create("UIPadding", {
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            Parent = tabContent
        })
        
        tab.Content = tabContent
        
        -- Tab switching
        tabBtn.MouseButton1Click:Connect(function()
            PlaySound("select")
            
            if window.ActiveTab then
                window.ActiveTab.Content.Visible = false
                TweenService:Create(window.ActiveTab.Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = VoidFrame.Scheme.Primary
                }):Play()
            end
            
            tabContent.Visible = true
            TweenService:Create(tabBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = VoidFrame.Scheme.Secondary
            }):Play()
            
            if iconLabel then
                iconLabel.ImageColor3 = VoidFrame.Scheme.Accent
            end
            
            window.ActiveTab = tab
        end)
        
        tab.Button = tabBtn
        
        -- Auto select first tab
        if not window.ActiveTab then
            tabBtn.MouseButton1Click:Fire()
        end
        
        -- Element creation methods
        function tab:AddGroup(name, side)
            side = side or "left"
            
            local group = {
                Elements = {}
            }
            
            local groupFrame = Create("Frame", {
                BackgroundColor3 = VoidFrame.Scheme.Primary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = tabContent
            })
            
            AddPixelBorder(groupFrame, 2, VoidFrame.Scheme.Border, true)
            
            -- Group header
            local header = Create("Frame", {
                BackgroundColor3 = VoidFrame.Scheme.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 24),
                Parent = groupFrame
            })
            
            Create("Frame", {
                BackgroundColor3 = VoidFrame.Scheme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 4, 1, 0),
                Parent = header
            })
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = VoidFrame.Font,
                Text = string.upper(name),
                TextColor3 = VoidFrame.Scheme.Text,
                TextSize = 10,
                Position = UDim2.fromOffset(12, 4),
                Size = UDim2.new(1, -20, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = header
            })
            
            -- Container for elements
            local container = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(4, 28),
                Size = UDim2.new(1, -8, 1, -32),
                Parent = groupFrame
            })
            
            local containerList = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = container
            })
            
            group.Frame = groupFrame
            group.Container = container
            
            -- Auto resize
            containerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                groupFrame.Size = UDim2.new(1, 0, 0, containerList.AbsoluteContentSize.Y + 40)
                tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
            end)
            
            -- Element methods
            function group:AddLabel(text, color)
                local label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = text,
                    TextColor3 = color or VoidFrame.Scheme.Text,
                    TextSize = 10,
                    TextWrapped = true,
                    Size = UDim2.new(1, 0, 0, 16),
                    Parent = container
                })
                
                -- Auto height
                local function updateHeight()
                    local bounds = TextService:GetTextSize(text, 10, VoidFrame.Font, Vector2.new(container.AbsoluteSize.X - 8, math.huge))
                    label.Size = UDim2.new(1, 0, 0, math.max(16, bounds.Y))
                end
                
                updateHeight()
                container:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHeight)
                
                return label
            end
            
            function group:AddButton(config)
                config = config or {}
                local template = VoidFrame.Templates.Button
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local btn = Create("TextButton", {
                    BackgroundColor3 = config.Dangerous and VoidFrame.Scheme.Error or VoidFrame.Scheme.Secondary,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 28),
                    Text = string.upper(config.Text),
                    Font = VoidFrame.Font,
                    TextColor3 = VoidFrame.Scheme.Text,
                    TextSize = 10,
                    Parent = container
                })
                
                AddBevelEffect(btn)
                
                btn.MouseButton1Click:Connect(function()
                    PlaySound("select")
                    SafeCallback(config.Callback)
                end)
                
                addHover(btn, config.Dangerous and Color3.fromRGB(200, 50, 50) or VoidFrame.Scheme.Accent)
                
                return btn
            end
            
            function group:AddToggle(idx, config)
                config = config or {}
                local template = VoidFrame.Templates.Toggle
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local toggleObj = {
                    Value = config.Default,
                    Callback = config.Callback
                }
                
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24),
                    Parent = container
                })
                
                local checkbox = Create("Frame", {
                    BackgroundColor3 = VoidFrame.Scheme.Secondary,
                    BorderSizePixel = 0,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.fromOffset(0, 4),
                    Parent = holder
                })
                
                AddPixelBorder(checkbox, 2, VoidFrame.Scheme.Border, false)
                
                local checkmark = Create("Frame", {
                    BackgroundColor3 = VoidFrame.Scheme.Accent,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(4, 4),
                    Size = UDim2.fromOffset(8, 8),
                    Visible = config.Default,
                    Parent = checkbox
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = string.upper(config.Text),
                    TextColor3 = VoidFrame.Scheme.Text,
                    TextSize = 10,
                    Position = UDim2.fromOffset(24, 4),
                    Size = UDim2.new(1, -24, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder
                })
                
                local function setValue(val)
                    toggleObj.Value = val
                    checkmark.Visible = val
                    SafeCallback(config.Callback, val)
                    
                    if VoidFrame.Toggles[idx] then
                        VoidFrame.Toggles[idx] = toggleObj
                    end
                end
                
                holder.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        PlaySound("select")
                        setValue(not toggleObj.Value)
                    end
                end)
                
                toggleObj.Set = setValue
                toggleObj.Get = function() return toggleObj.Value end
                
                VoidFrame.Toggles[idx] = toggleObj
                
                return toggleObj
            end
            
            function group:AddSlider(idx, config)
                config = config or {}
                local template = VoidFrame.Templates.Slider
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local sliderObj = {
                    Value = config.Default,
                    Min = config.Min,
                    Max = config.Max,
                    Callback = config.Callback
                }
                
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = container
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = string.upper(config.Text),
                    TextColor3 = VoidFrame.Scheme.Text,
                    TextSize = 10,
                    Size = UDim2.new(1, 0, 0, 14),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder
                })
                
                local valueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = tostring(config.Default) .. config.Suffix,
                    TextColor3 = VoidFrame.Scheme.Accent,
                    TextSize = 10,
                    Position = UDim2.new(1, -50, 0, 0),
                    Size = UDim2.fromOffset(50, 14),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = holder
                })
                
                local track = Create("Frame", {
                    BackgroundColor3 = VoidFrame.Scheme.Secondary,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(0, 20),
                    Size = UDim2.new(1, 0, 0, 12),
                    Parent = holder
                })
                
                AddPixelBorder(track, 2, VoidFrame.Scheme.Border, true)
                
                local fill = Create("Frame", {
                    BackgroundColor3 = VoidFrame.Scheme.Accent,
                    BorderSizePixel = 0,
                    Size = UDim2.fromScale((config.Default - config.Min) / (config.Max - config.Min), 1),
                    Parent = track
                })
                
                local knob = Create("Frame", {
                    BackgroundColor3 = VoidFrame.Scheme.Text,
                    BorderSizePixel = 0,
                    Position = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), -4, 0, -2),
                    Size = UDim2.fromOffset(8, 16),
                    Parent = track
                })
                
                local dragging = false
                
                local function updateValue(input)
                    local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local val = config.Min + (pos * (config.Max - config.Min))
                    val = math.floor(val * (10 ^ config.Rounding)) / (10 ^ config.Rounding)
                    
                    sliderObj.Value = val
                    fill.Size = UDim2.fromScale(pos, 1)
                    knob.Position = UDim2.new(pos, -4, 0, -2)
                    valueLabel.Text = tostring(val) .. config.Suffix
                    
                    SafeCallback(config.Callback, val)
                end
                
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateValue(input)
                        PlaySound("beep")
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateValue(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                sliderObj.Set = function(val)
                    val = math.clamp(val, config.Min, config.Max)
                    local pos = (val - config.Min) / (config.Max - config.Min)
                    fill.Size = UDim2.fromScale(pos, 1)
                    knob.Position = UDim2.new(pos, -4, 0, -2)
                    valueLabel.Text = tostring(val) .. config.Suffix
                    sliderObj.Value = val
                    SafeCallback(config.Callback, val)
                end
                
                VoidFrame.Sliders[idx] = sliderObj
                
                return sliderObj
            end
            
            function group:AddDropdown(idx, config)
                config = config or {}
                local template = VoidFrame.Templates.Dropdown
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local dropdownObj = {
                    Value = config.Multi and {} or config.Default,
                    Values = config.Values,
                    Callback = config.Callback
                }
                
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, config.Text and 44 or 28),
                    Parent = container
                })
                
                if config.Text then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = VoidFrame.Font,
                        Text = string.upper(config.Text),
                        TextColor3 = VoidFrame.Scheme.Text,
                        TextSize = 10,
                        Size = UDim2.new(1, 0, 0, 14),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = holder
                    })
                end
                
                local dropdownBtn = Create("TextButton", {
                    BackgroundColor3 = VoidFrame.Scheme.Secondary,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(0, config.Text and 20 or 0),
                    Size = UDim2.new(1, 0, 0, 24),
                    Text = "",
                    Parent = holder
                })
                
                AddPixelBorder(dropdownBtn, 2, VoidFrame.Scheme.Border, true)
                AddBevelEffect(dropdownBtn)
                
                local displayLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = config.Default or (config.Multi and "SELECT..." or "NONE"),
                    TextColor3 = VoidFrame.Scheme.Text,
                    TextSize = 10,
                    Position = UDim2.fromOffset(8, 4),
                    Size = UDim2.new(1, -32, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dropdownBtn
                })
                
                local arrow = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = PixelAssets.ArrowDown,
                    ImageColor3 = VoidFrame.Scheme.TextDim,
                    Position = UDim2.new(1, -20, 0, 4),
                    Size = UDim2.fromOffset(16, 16),
                    Parent = dropdownBtn
                })
                
                -- Dropdown menu
                local menu = Create("Frame", {
                    BackgroundColor3 = VoidFrame.Scheme.Primary,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(0, 26),
                    Size = UDim2.new(1, 0, 0, math.min(#config.Values * 24, 200)),
                    Visible = false,
                    ZIndex = 10,
                    Parent = dropdownBtn
                })
                
                AddPixelBorder(menu, 2, VoidFrame.Scheme.Border, true)
                
                local menuScroll = Create("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 0, #config.Values * 24),
                    ScrollBarThickness = 4,
                    ScrollBarImageColor3 = VoidFrame.Scheme.Accent,
                    Size = UDim2.new(1, -4, 1, -4),
                    Position = UDim2.fromOffset(2, 2),
                    ZIndex = 10,
                    Parent = menu
                })
                
                local menuList = Create("UIListLayout", {
                    Parent = menuScroll
                })
                
                -- Populate options
                for i, value in ipairs(config.Values) do
                    local optionBtn = Create("TextButton", {
                        BackgroundColor3 = VoidFrame.Scheme.Secondary,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 24),
                        Text = string.upper(tostring(value)),
                        Font = VoidFrame.Font,
                        TextColor3 = VoidFrame.Scheme.Text,
                        TextSize = 10,
                        ZIndex = 10,
                        Parent = menuScroll
                    })
                    
                    local selected = config.Multi and (dropdownObj.Value[value] or false) or (dropdownObj.Value == value)
                    
                    if selected then
                        optionBtn.BackgroundColor3 = VoidFrame.Scheme.Accent
                    end
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        PlaySound("select")
                        
                        if config.Multi then
                            dropdownObj.Value[value] = not dropdownObj.Value[value]
                            optionBtn.BackgroundColor3 = dropdownObj.Value[value] and VoidFrame.Scheme.Accent or VoidFrame.Scheme.Secondary
                            
                            -- Build display string
                            local selected = {}
                            for k, v in pairs(dropdownObj.Value) do
                                if v then table.insert(selected, k) end
                            end
                            displayLabel.Text = #selected > 0 and table.concat(selected, ", ") or "SELECT..."
                        else
                            dropdownObj.Value = value
                            displayLabel.Text = string.upper(tostring(value))
                            
                            -- Reset all colors
                            for _, child in ipairs(menuScroll:GetChildren()) do
                                if child:IsA("TextButton") then
                                    child.BackgroundColor3 = VoidFrame.Scheme.Secondary
                                end
                            end
                            optionBtn.BackgroundColor3 = VoidFrame.Scheme.Accent
                            menu.Visible = false
                            arrow.Rotation = 0
                        end
                        
                        SafeCallback(config.Callback, dropdownObj.Value)
                    end)
                    
                    addHover(optionBtn, VoidFrame.Scheme.AccentAlt)
                end
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    PlaySound("beep")
                    menu.Visible = not menu.Visible
                    arrow.Rotation = menu.Visible and 180 or 0
                end)
                
                dropdownObj.Set = function(val)
                    if config.Multi then
                        dropdownObj.Value = val
                        local selected = {}
                        for k, v in pairs(val) do
                            if v then table.insert(selected, k) end
                        end
                        displayLabel.Text = #selected > 0 and table.concat(selected, ", ") or "SELECT..."
                    else
                        dropdownObj.Value = val
                        displayLabel.Text = string.upper(tostring(val))
                    end
                    SafeCallback(config.Callback, val)
                end
                
                VoidFrame.Dropdowns[idx] = dropdownObj
                
                return dropdownObj
            end
            
            function group:AddInput(idx, config)
                config = config or {}
                local template = VoidFrame.Templates.Input
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local inputObj = {
                    Value = config.Default,
                    Callback = config.Callback
                }
                
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, config.Text and 48 or 28),
                    Parent = container
                })
                
                if config.Text then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = VoidFrame.Font,
                        Text = string.upper(config.Text),
                        TextColor3 = VoidFrame.Scheme.Text,
                        TextSize = 10,
                        Size = UDim2.new(1, 0, 0, 14),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = holder
                    })
                end
                
                local box = Create("TextBox", {
                    BackgroundColor3 = VoidFrame.Scheme.Secondary,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(0, config.Text and 20 or 0),
                    Size = UDim2.new(1, 0, 0, 28),
                    Text = config.Default,
                    PlaceholderText = config.Placeholder,
                    Font = VoidFrame.Font,
                    TextColor3 = VoidFrame.Scheme.Text,
                    PlaceholderColor3 = VoidFrame.Scheme.TextDim,
                    TextSize = 10,
                    ClearTextOnFocus = false,
                    Parent = holder
                })
                
                AddPixelBorder(box, 2, VoidFrame.Scheme.Border, true)
                AddBevelEffect(box)
                
                if config.Numeric then
                    box:GetPropertyChangedSignal("Text"):Connect(function()
                        local text = box.Text
                        if text ~= "" and not tonumber(text) then
                            box.Text = text:gsub("[^0-9.-]", "")
                        end
                    end)
                end
                
                local function submit()
                    PlaySound("beep")
                    inputObj.Value = box.Text
                    SafeCallback(config.Callback, box.Text)
                end
                
                if config.Finished then
                    box.FocusLost:Connect(function(enterPressed)
                        if enterPressed then
                            submit()
                        end
                    end)
                else
                    box:GetPropertyChangedSignal("Text"):Connect(submit)
                end
                
                inputObj.Set = function(text)
                    box.Text = text
                    inputObj.Value = text
                    SafeCallback(config.Callback, text)
                end
                
                inputObj.Get = function() return inputObj.Value end
                
                VoidFrame.Options[idx] = inputObj
                
                return inputObj
            end
            
            function group:AddColorPicker(idx, config)
                config = config or {}
                local template = VoidFrame.Templates.ColorPicker
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local colorObj = {
                    Value = config.Default,
                    Callback = config.Callback
                }
                
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, config.Text and 48 or 28),
                    Parent = container
                })
                
                if config.Text then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = VoidFrame.Font,
                        Text = string.upper(config.Text),
                        TextColor3 = VoidFrame.Scheme.Text,
                        TextSize = 10,
                        Size = UDim2.new(1, 0, 0, 14),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = holder
                    })
                end
                
                local preview = Create("TextButton", {
                    BackgroundColor3 = config.Default,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(0, config.Text and 20 or 0),
                    Size = UDim2.new(1, 0, 0, 28),
                    Text = "",
                    Parent = holder
                })
                
                AddPixelBorder(preview, 2, VoidFrame.Scheme.Border, true)
                
                -- Color display hex
                local hexLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = "#" .. config.Default:ToHex(),
                    TextColor3 = Color3.new(1, 1, 1), -- Will be dynamic based on brightness
                    TextSize = 10,
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = preview
                })
                
                -- Simple picker popup
                local pickerOpen = false
                local pickerFrame
                
                local function updateTextColor()
                    local brightness = (config.Default.R * 0.299 + config.Default.G * 0.587 + config.Default.B * 0.114)
                    hexLabel.TextColor3 = brightness > 0.5 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
                end
                
                preview.MouseButton1Click:Connect(function()
                    PlaySound("select")
                    
                    if pickerOpen then return end
                    pickerOpen = true
                    
                    pickerFrame = Create("Frame", {
                        BackgroundColor3 = VoidFrame.Scheme.Primary,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 1, 4),
                        Size = UDim2.fromOffset(200, 120),
                        ZIndex = 20,
                        Parent = preview
                    })
                    
                    AddPixelBorder(pickerFrame, 2, VoidFrame.Scheme.Border, true)
                    
                    -- Hue slider
                    local hue = 0
                    local sat = 1
                    local val = 1
                    
                    local h, s, v = config.Default:ToHSV()
                    hue, sat, val = h, s, v
                    
                    local colorDisplay = Create("Frame", {
                        BackgroundColor3 = config.Default,
                        BorderSizePixel = 0,
                        Position = UDim2.fromOffset(8, 8),
                        Size = UDim2.fromOffset(60, 60),
                        ZIndex = 20,
                        Parent = pickerFrame
                    })
                    
                    AddPixelBorder(colorDisplay, 2, VoidFrame.Scheme.Border, false)
                    
                    -- R, G, B inputs
                    local function createChannelInput(name, pos, default)
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = VoidFrame.Font,
                            Text = name,
                            TextColor3 = VoidFrame.Scheme.Text,
                            TextSize = 10,
                            Position = UDim2.fromOffset(76, pos),
                            Size = UDim2.fromOffset(20, 20),
                            ZIndex = 20,
                            Parent = pickerFrame
                        })
                        
                        local input = Create("TextBox", {
                            BackgroundColor3 = VoidFrame.Scheme.Secondary,
                            BorderSizePixel = 0,
                            Position = UDim2.fromOffset(100, pos),
                            Size = UDim2.fromOffset(40, 20),
                            Text = tostring(math.floor(default * 255)),
                            Font = VoidFrame.Font,
                            TextColor3 = VoidFrame.Scheme.Text,
                            TextSize = 10,
                            ZIndex = 20,
                            Parent = pickerFrame
                        })
                        
                        AddPixelBorder(input, 1, VoidFrame.Scheme.Border, false)
                        
                        return input
                    end
                    
                    local rInput = createChannelInput("R", 8, config.Default.R)
                    local gInput = createChannelInput("G", 32, config.Default.G)
                    local bInput = createChannelInput("B", 56, config.Default.B)
                    
                    local function updateFromRGB()
                        local r = math.clamp(tonumber(rInput.Text) or 0, 0, 255) / 255
                        local g = math.clamp(tonumber(gInput.Text) or 0, 0, 255) / 255
                        local b = math.clamp(tonumber(bInput.Text) or 0, 0, 255) / 255
                        
                        local newColor = Color3.new(r, g, b)
                        colorObj.Value = newColor
                        preview.BackgroundColor3 = newColor
                        colorDisplay.BackgroundColor3 = newColor
                        hexLabel.Text = "#" .. newColor:ToHex()
                        updateTextColor()
                        
                        SafeCallback(config.Callback, newColor)
                    end
                    
                    rInput.FocusLost:Connect(updateFromRGB)
                    gInput.FocusLost:Connect(updateFromRGB)
                    bInput.FocusLost:Connect(updateFromRGB)
                    
                    -- Close button
                    local close = Create("TextButton", {
                        BackgroundColor3 = VoidFrame.Scheme.Error,
                        BorderSizePixel = 0,
                        Position = UDim2.fromOffset(148, 8),
                        Size = UDim2.fromOffset(44, 20),
                        Text = "X",
                        Font = VoidFrame.Font,
                        TextColor3 = VoidFrame.Scheme.Text,
                        TextSize = 10,
                        ZIndex = 20,
                        Parent = pickerFrame
                    })
                    
                    close.MouseButton1Click:Connect(function()
                        PlaySound("beep")
                        pickerFrame:Destroy()
                        pickerOpen = false
                    end)
                    
                    -- Preset colors
                    local presets = {
                        Color3.fromRGB(255, 0, 77),   -- Red
                        Color3.fromRGB(0, 255, 128),  -- Green
                        Color3.fromRGB(41, 173, 255), -- Blue
                        Color3.fromRGB(255, 236, 39), -- Yellow
                        Color3.fromRGB(255, 119, 168),-- Pink
                        Color3.fromRGB(255, 255, 255),-- White
                        Color3.fromRGB(0, 0, 0),      -- Black
                        Color3.fromRGB(128, 128, 128) -- Gray
                    }
                    
                    for i, preset in ipairs(presets) do
                        local x = 8 + ((i - 1) % 4) * 22
                        local y = 76 + math.floor((i - 1) / 4) * 22
                        
                        local presetBtn = Create("TextButton", {
                            BackgroundColor3 = preset,
                            BorderSizePixel = 0,
                            Position = UDim2.fromOffset(x, y),
                            Size = UDim2.fromOffset(18, 18),
                            Text = "",
                            ZIndex = 20,
                            Parent = pickerFrame
                        })
                        
                        presetBtn.MouseButton1Click:Connect(function()
                            PlaySound("select")
                            local r, g, b = math.floor(preset.R * 255), math.floor(preset.G * 255), math.floor(preset.B * 255)
                            rInput.Text = r
                            gInput.Text = g
                            bInput.Text = b
                            updateFromRGB()
                        end)
                    end
                end)
                
                updateTextColor()
                
                colorObj.Set = function(color)
                    colorObj.Value = color
                    preview.BackgroundColor3 = color
                    hexLabel.Text = "#" .. color:ToHex()
                    updateTextColor()
                    SafeCallback(config.Callback, color)
                end
                
                VoidFrame.Options[idx] = colorObj
                
                return colorObj
            end
            
            function group:AddKeybind(idx, config)
                config = config or {}
                local template = VoidFrame.Templates.Keybind
                
                for k, v in pairs(template) do
                    if config[k] == nil then
                        config[k] = v
                    end
                end
                
                local keybindObj = {
                    Value = config.Default,
                    Mode = config.Mode,
                    Callback = config.Callback,
                    Toggled = false
                }
                
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24),
                    Parent = container
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = VoidFrame.Font,
                    Text = string.upper(config.Text),
                    TextColor3 = VoidFrame.Scheme.Text,
                    TextSize = 10,
                    Size = UDim2.new(1, -80, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder
                })
                
                local bindBtn = Create("TextButton", {
                    BackgroundColor3 = VoidFrame.Scheme.Secondary,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -76, 0, 0),
                    Size = UDim2.fromOffset(76, 24),
                    Text = string.upper(config.Default),
                    Font = VoidFrame.Font,
                    TextColor3 = VoidFrame.Scheme.Accent,
                    TextSize = 10,
                    Parent = holder
                })
                
                AddPixelBorder(bindBtn, 2, VoidFrame.Scheme.Border, false)
                
                local listening = false
                
                bindBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    PlaySound("select")
                    listening = true
                    bindBtn.Text = "..."
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            local keyName = input.KeyCode.Name
                            keybindObj.Value = keyName
                            bindBtn.Text = string.upper(keyName)
                            listening = false
                            connection:Disconnect()
                            PlaySound("beep")
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            keybindObj.Value = "MB1"
                            bindBtn.Text = "MB1"
                            listening = false
                            connection:Disconnect()
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            keybindObj.Value = "MB2"
                            bindBtn.Text = "MB2"
                            listening = false
                            connection:Disconnect()
                        end
                    end)
                end)
                
                -- Input handling
                table.insert(VoidFrame.Signals, UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode.Name == keybindObj.Value or 
                       (keybindObj.Value == "MB1" and input.UserInputType == Enum.UserInputType.MouseButton1) or
                       (keybindObj.Value == "MB2" and input.UserInputType == Enum.UserInputType.MouseButton2) then
                        
                        if keybindObj.Mode == "Toggle" then
                            keybindObj.Toggled = not keybindObj.Toggled
                            SafeCallback(config.Callback, keybindObj.Toggled)
                        elseif keybindObj.Mode == "Hold" then
                            keybindObj.Toggled = true
                            SafeCallback(config.Callback, true)
                        end
                    end
                end))
                
                if keybindObj.Mode == "Hold" then
                    table.insert(VoidFrame.Signals, UserInputService.InputEnded:Connect(function(input)
                        if input.KeyCode.Name == keybindObj.Value then
                            keybindObj.Toggled = false
                            SafeCallback(config.Callback, false)
                        end
                    end))
                end
                
                keybindObj.Set = function(key)
                    keybindObj.Value = key
                    bindBtn.Text = string.upper(key)
                end
                
                VoidFrame.Options[idx] = keybindObj
                
                return keybindObj
            end
            
            function group:AddDivider(text, thick)
                local height = thick and 6 or 2
                local holder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, text and 20 or height + 8),
                    Parent = container
                })
                
                if text then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = VoidFrame.Font,
                        Text = string.upper(text),
                        TextColor3 = VoidFrame.Scheme.TextDim,
                        TextSize = 9,
                        Size = UDim2.new(1, 0, 0, 14),
                        Parent = holder
                    })
                    
                    Create("Frame", {
                        BackgroundColor3 = VoidFrame.Scheme.Border,
                        BorderSizePixel = 0,
                        Position = UDim2.fromOffset(0, 16),
                        Size = UDim2.new(1, 0, 0, thick and 4 or 2),
                        Parent = holder
                    })
                else
                    Create("Frame", {
                        BackgroundColor3 = VoidFrame.Scheme.Border,
                        BorderSizePixel = 0,
                        Position = UDim2.fromOffset(0, 4),
                        Size = UDim2.new(1, 0, 0, height),
                        Parent = holder
                    })
                end
                
                return holder
            end
            
            table.insert(self.Groups, group)
            return group
        end
        
        function tab:AddLeftGroup(name)
            return self:AddGroup(name, "left")
        end
        
        function tab:AddRightGroup(name)
            return self:AddGroup(name, "right")
        end
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    table.insert(self.Windows, window)
    return window
end

--// Theme Management \\--
function VoidFrame:SetTheme(themeName)
    if RetroSchemes[themeName] then
        self.Theme = themeName
        self.Scheme = RetroSchemes[themeName]
        
        -- Update all existing elements would go here
        -- For now, just notify
        self:Notify("THEME CHANGED", "Switched to " .. themeName .. " theme", 2, "success")
        return true
    end
    return false
end

function VoidFrame:ListThemes()
    local list = {}
    for name, _ in pairs(RetroSchemes) do
        table.insert(list, name)
    end
    return list
end

--// Font Management \\--
function VoidFrame:SetFont(fontName)
    if RetroFonts[fontName] then
        self.Font = RetroFonts[fontName]
        return true
    end
    return false
end

--// Utility Methods \\--
function VoidFrame:GetToggle(idx)
    return self.Toggles[idx]
end

function VoidFrame:GetSlider(idx)
    return self.Sliders[idx]
end

function VoidFrame:GetDropdown(idx)
    return self.Dropdowns[idx]
end

function VoidFrame:GetOption(idx)
    return self.Options[idx]
end

function VoidFrame:SetSoundEnabled(enabled)
    self.SoundEnabled = enabled
end

function VoidFrame:SetScanlines(enabled)
    self.ScanlinesEnabled = enabled
    -- Update all windows
    for _, window in ipairs(self.Windows) do
        local scan = window.Frame:FindFirstChild("Scanlines")
        if scan then
            scan.Visible = enabled
        end
    end
end

--// Cleanup \\--
function VoidFrame:Unload()
    self.Unloaded = true
    
    -- Disconnect signals
    for _, signal in ipairs(self.Signals) do
        if typeof(signal) == "RBXScriptConnection" then
            signal:Disconnect()
        end
    end
    
    -- Destroy GUI
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- Clear references
    getgenv().VoidFrame = nil
end

--// Export \\--
getgenv().VoidFrame = VoidFrame
return VoidFrame

return VoidFrame
