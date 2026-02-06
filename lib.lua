--[[

 __   __     ______     ______     ______     __         ______     ______     ______    
/\ \ / /    /\  ___\   /\  ___\   /\  == \   /\ \       /\  __ \   /\  ___\   /\  ___\   
\ \ \'/     \ \  __\   \ \ \____  \ \  __<   \ \ \____  \ \  __ \  \ \ \__ \  \ \  __\   
 \ \__|      \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\ 
  \/_/        \/_____/   \/_____/   \/_/ /_/   \/_____/   \/_/\/_/   \/_____/   \/_____/ 

                V O I D F R A M E   L I B R A R Y
           A Complete Retro UI Framework for Roblox
           
--]]

local VoidFrame = {}
VoidFrame.__index = VoidFrame

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Configuration System
VoidFrame.Config = {
    AutoSave = true,
    SaveInterval = 30,
    ConfigFolder = "VoidFrame_Configs",
    DefaultConfigName = "Default"
}

-- Retro Theme System - Fully Customizable
VoidFrame.Themes = {
    -- Classic Terminal Green (Default)
    RetroGreen = {
        Name = "RetroGreen",
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(0, 20, 0),
        Accent = Color3.fromRGB(0, 255, 0),
        AccentDark = Color3.fromRGB(0, 180, 0),
        AccentDarker = Color3.fromRGB(0, 100, 0),
        AccentVeryDark = Color3.fromRGB(0, 40, 0),
        Text = Color3.fromRGB(0, 255, 0),
        TextDim = Color3.fromRGB(0, 180, 0),
        TextDark = Color3.fromRGB(0, 100, 0),
        StrokeColor = Color3.fromRGB(0, 120, 0),
        ErrorColor = Color3.fromRGB(255, 50, 50),
        WarningColor = Color3.fromRGB(255, 200, 0),
        InfoColor = Color3.fromRGB(0, 200, 255),
        SuccessColor = Color3.fromRGB(0, 255, 100),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        PixelFont = Enum.Font.Gotham,
        CornerRadius = 0, -- Sharp corners for retro feel
        BorderSize = 2,
        BorderStyle = "Block", -- Block, Line, Double, Thick
        Shadow = false,
        CRT = true,
        Scanlines = true
    },
    
    -- Amber Monitor
    RetroAmber = {
        Name = "RetroAmber",
        Background = Color3.fromRGB(10, 8, 0),
        Surface = Color3.fromRGB(20, 15, 0),
        Header = Color3.fromRGB(30, 20, 0),
        Accent = Color3.fromRGB(255, 176, 0),
        AccentDark = Color3.fromRGB(200, 140, 0),
        AccentDarker = Color3.fromRGB(120, 80, 0),
        AccentVeryDark = Color3.fromRGB(40, 25, 0),
        Text = Color3.fromRGB(255, 200, 50),
        TextDim = Color3.fromRGB(200, 150, 40),
        TextDark = Color3.fromRGB(100, 75, 20),
        StrokeColor = Color3.fromRGB(180, 120, 0),
        ErrorColor = Color3.fromRGB(255, 80, 80),
        WarningColor = Color3.fromRGB(255, 220, 80),
        InfoColor = Color3.fromRGB(255, 255, 150),
        SuccessColor = Color3.fromRGB(200, 255, 100),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        PixelFont = Enum.Font.Gotham,
        CornerRadius = 0,
        BorderSize = 2,
        BorderStyle = "Block",
        Shadow = false,
        CRT = true,
        Scanlines = true
    },
    
    -- Phosphor Blue
    RetroBlue = {
        Name = "RetroBlue",
        Background = Color3.fromRGB(0, 0, 10),
        Surface = Color3.fromRGB(0, 0, 20),
        Header = Color3.fromRGB(0, 0, 40),
        Accent = Color3.fromRGB(0, 150, 255),
        AccentDark = Color3.fromRGB(0, 100, 200),
        AccentDarker = Color3.fromRGB(0, 50, 120),
        AccentVeryDark = Color3.fromRGB(0, 10, 40),
        Text = Color3.fromRGB(100, 200, 255),
        TextDim = Color3.fromRGB(80, 150, 200),
        TextDark = Color3.fromRGB(40, 80, 100),
        StrokeColor = Color3.fromRGB(0, 100, 180),
        ErrorColor = Color3.fromRGB(255, 100, 100),
        WarningColor = Color3.fromRGB(255, 200, 100),
        InfoColor = Color3.fromRGB(150, 255, 255),
        SuccessColor = Color3.fromRGB(100, 255, 150),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        PixelFont = Enum.Font.Gotham,
        CornerRadius = 0,
        BorderSize = 2,
        BorderStyle = "Line",
        Shadow = false,
        CRT = true,
        Scanlines = true
    },
    
    -- Monochrome (B&W)
    RetroMono = {
        Name = "RetroMono",
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(20, 20, 20),
        Header = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentDark = Color3.fromRGB(180, 180, 180),
        AccentDarker = Color3.fromRGB(100, 100, 100),
        AccentVeryDark = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(220, 220, 220),
        TextDim = Color3.fromRGB(150, 150, 150),
        TextDark = Color3.fromRGB(80, 80, 80),
        StrokeColor = Color3.fromRGB(120, 120, 120),
        ErrorColor = Color3.fromRGB(255, 255, 255),
        WarningColor = Color3.fromRGB(200, 200, 200),
        InfoColor = Color3.fromRGB(180, 180, 180),
        SuccessColor = Color3.fromRGB(240, 240, 240),
        Font = Enum.Font.Code,
        MonoFont = Enum.Font.Code,
        PixelFont = Enum.Font.Code,
        CornerRadius = 0,
        BorderSize = 1,
        BorderStyle = "Line",
        Shadow = false,
        CRT = false,
        Scanlines = false
    },
    
    -- Matrix/Deep Green
    Matrix = {
        Name = "Matrix",
        Background = Color3.fromRGB(0, 5, 0),
        Surface = Color3.fromRGB(0, 10, 0),
        Header = Color3.fromRGB(0, 15, 0),
        Accent = Color3.fromRGB(0, 255, 65),
        AccentDark = Color3.fromRGB(0, 200, 50),
        AccentDarker = Color3.fromRGB(0, 120, 30),
        AccentVeryDark = Color3.fromRGB(0, 40, 10),
        Text = Color3.fromRGB(0, 255, 70),
        TextDim = Color3.fromRGB(0, 180, 50),
        TextDark = Color3.fromRGB(0, 80, 25),
        StrokeColor = Color3.fromRGB(0, 150, 40),
        ErrorColor = Color3.fromRGB(255, 0, 80),
        WarningColor = Color3.fromRGB(255, 200, 0),
        InfoColor = Color3.fromRGB(0, 255, 255),
        SuccessColor = Color3.fromRGB(0, 255, 128),
        Font = Enum.Font.Arcade,
        MonoFont = Enum.Font.Code,
        PixelFont = Enum.Font.GothamBold,
        CornerRadius = 0,
        BorderSize = 2,
        BorderStyle = "Double",
        Shadow = false,
        CRT = true,
        Scanlines = true
    }
}

-- Current Theme
VoidFrame.CurrentTheme = VoidFrame.Themes.RetroGreen

-- Global Storage
local Windows = {}
local Notifications = {}
local Configs = {}
local Draggables = {}
local ConnectionBin = {}

-- Utility Functions
local function Create(className, properties)
    local obj = Instance.new(className)
    for k, v in pairs(properties or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if properties and properties.Parent then
        obj.Parent = properties.Parent
    end
    return obj
end

local function MakeDraggable(obj, handle)
    handle = handle or obj
    local dragging = false
    local dragInput, dragStart, startPos
    
    local connections = {}
    
    table.insert(connections, handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end))
    
    table.insert(connections, handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end))
    
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
    
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))
    
    Draggables[obj] = connections
    return connections
end

local function CleanupDraggable(obj)
    if Draggables[obj] then
        for _, conn in pairs(Draggables[obj]) do
            if conn then conn:Disconnect() end
        end
        Draggables[obj] = nil
    end
end

local function ApplyBorder(obj, theme, customColor)
    local color = customColor or theme.StrokeColor
    local size = theme.BorderSize or 2
    
    if theme.BorderStyle == "Block" or theme.BorderStyle == "Thick" then
        -- Blocky pixel border
        for _, side in pairs({"Top", "Bottom", "Left", "Right"}) do
            local border = Create("Frame", {
                Name = "Border_" .. side,
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                Parent = obj
            })
            
            if side == "Top" then
                border.Size = UDim2.new(1, 0, 0, size)
                border.Position = UDim2.new(0, 0, 0, 0)
            elseif side == "Bottom" then
                border.Size = UDim2.new(1, 0, 0, size)
                border.Position = UDim2.new(0, 0, 1, -size)
            elseif side == "Left" then
                border.Size = UDim2.new(0, size, 1, -size * 2)
                border.Position = UDim2.new(0, 0, 0, size)
            elseif side == "Right" then
                border.Size = UDim2.new(0, size, 1, -size * 2)
                border.Position = UDim2.new(1, -size, 0, size)
            end
        end
    else
        -- Standard UIStroke for line styles
        local stroke = Create("UIStroke", {
            Color = color,
            Thickness = size,
            Transparency = 0.2,
            Parent = obj
        })
    end
end

local function ApplyPixelStyle(obj, theme)
    -- Sharp corners only
    if obj:IsA("GuiObject") and theme.CornerRadius == 0 then
        -- No corner radius for true pixel look
        local existing = obj:FindFirstChildOfClass("UICorner")
        if existing then existing:Destroy() end
    end
    
    -- Apply border
    ApplyBorder(obj, theme)
end

local function CreateShadow(obj, depth)
    depth = depth or 4
    local shadow = Create("Frame", {
        Name = "Shadow",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, depth, 0, depth),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex = obj.ZIndex - 1,
        Parent = obj.Parent
    })
    shadow.LayoutOrder = obj.LayoutOrder - 1
    return shadow
end

local function AddTooltip(obj, text, theme)
    local tooltip = nil
    local connection = nil
    
    obj.MouseEnter:Connect(function()
        if not tooltip then
            tooltip = Create("Frame", {
                Name = "Tooltip",
                Size = UDim2.new(0, 0, 0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 999999,
                Parent = CoreGui
            })
            
            ApplyBorder(tooltip, theme, theme.TextDim)
            
            local lbl = Create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text = " " .. text .. " ",
                TextColor3 = theme.Text,
                Font = theme.MonoFont,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = tooltip
            })
            
            local absPos = obj.AbsolutePosition
            tooltip.Position = UDim2.new(0, absPos.X, 0, absPos.Y - 28)
        end
        tooltip.Visible = true
    end)
    
    obj.MouseLeave:Connect(function()
        if tooltip then
            tooltip:Destroy()
            tooltip = nil
        end
    end)
    
    obj.Destroying:Connect(function()
        if tooltip then tooltip:Destroy() end
    end)
end

-- Config Management System
VoidFrame.ConfigManager = {
    LoadedConfigs = {},
    
    SaveConfig = function(self, name, data)
        local configName = name or VoidFrame.Config.DefaultConfigName
        local encoded = HttpService:JSONEncode(data)
        
        -- Save to workspace folder or local storage
        local folder = VoidFrame.Config.ConfigFolder
        -- In real implementation, would use writefile/readfile
        -- For now, store in memory
        self.LoadedConfigs[configName] = encoded
        
        -- Notification
        if VoidFrame.NotificationSystem then
            VoidFrame.NotificationSystem:Notify("CONFIG", "Saved config: " .. configName, 2)
        end
        
        return true
    end,
    
    LoadConfig = function(self, name)
        local configName = name or VoidFrame.Config.DefaultConfigName
        local encoded = self.LoadedConfigs[configName]
        
        if encoded then
            local success, data = pcall(function()
                return HttpService:JSONDecode(encoded)
            end)
            
            if success then
                return data
            end
        end
        return nil
    end,
    
    DeleteConfig = function(self, name)
        self.LoadedConfigs[name] = nil
        return true
    end,
    
    ListConfigs = function(self)
        local list = {}
        for name, _ in pairs(self.LoadedConfigs) do
            table.insert(list, name)
        end
        return list
    end,
    
    AutoSaveLoop = function(self, windowData)
        while VoidFrame.Config.AutoSave do
            task.wait(VoidFrame.Config.SaveInterval)
            if windowData and windowData.GetConfigData then
                self:SaveConfig(nil, windowData:GetConfigData())
            end
        end
    end
}

-- Notification System
VoidFrame.NotificationSystem = {
    ActiveNotifications = {},
    MaxNotifications = 5,
    
    Init = function(self, theme)
        if self.Container then return end
        
        self.Theme = theme or VoidFrame.CurrentTheme
        
        self.Screen = Create("ScreenGui", {
            Name = "VoidFrame_Notifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            DisplayOrder = 999999,
            Parent = CoreGui
        })
        
        self.Container = Create("Frame", {
            Size = UDim2.new(0, 420, 1, 0),
            Position = UDim2.new(1, -440, 0, 20),
            BackgroundTransparency = 1,
            Parent = self.Screen
        })
        
        self.Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = self.Container
        })
    end,
    
    Notify = function(self, title, message, duration, notifType)
        notifType = notifType or "Info"
        duration = duration or 4
        local theme = self.Theme or VoidFrame.CurrentTheme
        
        -- Sound effect (optional retro beep)
        -- local sound = Create("Sound", {SoundId = "rbxassetid://...", Parent = CoreGui})
        
        local notif = Create("Frame", {
            Size = UDim2.new(0, 400, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 0,
            LayoutOrder = -(#self.ActiveNotifications),
            Parent = self.Container
        })
        
        ApplyBorder(notif, theme)
        
        local header = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = theme.Header,
            BorderSizePixel = 0,
            Parent = notif
        })
        
        local typeColors = {
            Info = theme.InfoColor,
            Success = theme.SuccessColor,
            Warning = theme.WarningColor,
            Error = theme.ErrorColor
        }
        
        local indicator = Create("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = typeColors[notifType] or theme.Accent,
            BorderSizePixel = 0,
            Parent = header
        })
        
        local titleLbl = Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = "► " .. (title or "VOID"):upper(),
            TextColor3 = theme.Text,
            Font = theme.MonoFont,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header
        })
        
        local closeBtn = Create("TextButton", {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -24, 0, 1),
            BackgroundTransparency = 1,
            Text = "×",
            TextColor3 = theme.TextDim,
            Font = theme.MonoFont,
            TextSize = 18,
            Parent = header
        })
        
        local msgContainer = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.new(0, 10, 0, 30),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = notif
        })
        
        local msgLbl = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = message or "",
            TextColor3 = theme.TextDim,
            Font = theme.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = msgContainer
        })
        
        -- Calculate final size
        local msgHeight = msgLbl.TextBounds.Y
        notif.Size = UDim2.new(0, 400, 0, 36 + msgHeight + 10)
        
        -- Close functionality
        local function close()
            if notif.Parent then
                notif:Destroy()
                for i, n in pairs(self.ActiveNotifications) do
                    if n == notif then
                        table.remove(self.ActiveNotifications, i)
                        break
                    end
                end
            end
        end
        
        closeBtn.MouseButton1Click:Connect(close)
        
        -- Auto close
        task.delay(duration, close)
        
        table.insert(self.ActiveNotifications, 1, notif)
        
        -- Remove old notifications if too many
        while #self.ActiveNotifications > self.MaxNotifications do
            local old = self.ActiveNotifications[#self.ActiveNotifications]
            if old and old.Parent then
                old:Destroy()
            end
            table.remove(self.ActiveNotifications)
        end
        
        return notif
    end,
    
    ClearAll = function(self)
        for _, notif in pairs(self.ActiveNotifications) do
            if notif and notif.Parent then
                notif:Destroy()
            end
        end
        self.ActiveNotifications = {}
    end
}

-- Advanced Components
local ComponentRegistry = {}

-- Toggle Component
ComponentRegistry.Toggle = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Toggle"
        local default = config.Default or false
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local tooltip = config.Tooltip
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 34),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
            Size = UDim2.new(0.65, 0, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = theme.Text,
            Font = theme.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
        
        local switch = Create("Frame", {
            Size = UDim2.new(0, 44, 0, 22),
            Position = UDim2.new(1, -56, 0.5, -11),
            BackgroundColor3 = default and theme.Accent or theme.AccentDarker,
            BorderSizePixel = 0,
            Parent = frame
        })
        
        ApplyBorder(switch, theme, default and theme.Accent or theme.AccentDarker)
        
        local knob = Create("Frame", {
            Size = UDim2.new(0, 18, 1, -4),
            Position = default and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = theme.Background,
            BorderSizePixel = 0,
            Parent = switch
        })
        
        local value = default
        
        local function update(newValue)
            value = newValue
            switch.BackgroundColor3 = value and theme.Accent or theme.AccentDarker
            knob.Position = value and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            if callback then callback(value) end
            return value
        end
        
        local clickArea = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = frame
        })
        
        clickArea.MouseButton1Click:Connect(function()
            update(not value)
        end)
        
        if tooltip then AddTooltip(frame, tooltip, theme) end
        
        return {
            Instance = frame,
            GetValue = function() return value end,
            SetValue = update,
            Flag = flag
        }
    end
}

-- Slider Component
ComponentRegistry.Slider = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Slider"
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local suffix = config.Suffix or ""
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local tooltip = config.Tooltip
        local decimals = config.Decimals or 0
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 54),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 24),
            Position = UDim2.new(0, 12, 0, 4),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = theme.Text,
            Font = theme.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
        
        local valueLabel = Create("TextLabel", {
            Size = UDim2.new(0.4, 0, 0, 24),
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
            Size = UDim2.new(1, -24, 0, 8),
            Position = UDim2.new(0, 12, 0, 36),
            BackgroundColor3 = theme.AccentDarker,
            BorderSizePixel = 0,
            Parent = frame
        })
        
        ApplyBorder(track, theme, theme.AccentDark)
        
        local fill = Create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
            Parent = track
        })
        
        local value = default
        
        local function update(inputX)
            local relX = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * relX
            
            if decimals == 0 then
                newValue = math.floor(newValue)
            else
                newValue = math.floor(newValue * (10 ^ decimals)) / (10 ^ decimals)
            end
            
            value = newValue
            fill.Size = UDim2.new(relX, 0, 1, 0)
            valueLabel.Text = tostring(value) .. suffix
            
            if callback then callback(value) end
            return value
        end
        
        local dragging = false
        
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(input.Position.X)
            end
        end)
        
        track.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input.Position.X)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        if tooltip then AddTooltip(frame, tooltip, theme) end
        
        return {
            Instance = frame,
            GetValue = function() return value end,
            SetValue = function(v)
                value = math.clamp(v, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                valueLabel.Text = tostring(value) .. suffix
                if callback then callback(value) end
            end,
            Flag = flag
        }
    end
}

-- Dropdown Component
ComponentRegistry.Dropdown = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Dropdown"
        local options = config.Options or {}
        local default = config.Default or options[1] or "None"
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local tooltip = config.Tooltip
        local multi = config.Multi or false
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 38),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
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
        
        local btn = Create("TextButton", {
            Size = UDim2.new(0.52, 0, 0, 28),
            Position = UDim2.new(0.46, 0, 0.5, -14),
            BackgroundColor3 = theme.AccentDarker,
            Text = " " .. tostring(default) .. " ",
            TextColor3 = theme.Text,
            Font = theme.Font,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = frame
        })
        
        ApplyBorder(btn, theme, theme.AccentDark)
        
        local arrow = Create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -20, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = theme.TextDim,
            Font = theme.MonoFont,
            TextSize = 10,
            Parent = btn
        })
        
        local selectedValue = default
        local dropdownOpen = false
        local optionFrame = nil
        
        local function closeDropdown()
            dropdownOpen = false
            arrow.Text = "▼"
            if optionFrame then
                optionFrame:Destroy()
                optionFrame = nil
            end
        end
        
        local function openDropdown()
            if dropdownOpen then
                closeDropdown()
                return
            end
            
            dropdownOpen = true
            arrow.Text = "▲"
            
            optionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, math.min(#options * 28, 200)),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 100,
                Parent = btn
            })
            
            ApplyBorder(optionFrame, theme)
            
            local scroll = Create("ScrollingFrame", {
                Size = UDim2.new(1, -4, 1, -4),
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = theme.Accent,
                CanvasSize = UDim2.new(0, 0, 0, #options * 28),
                Parent = optionFrame
            })
            
            for i, option in pairs(options) do
                local optBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26),
                    Position = UDim2.new(0, 0, 0, (i - 1) * 28),
                    BackgroundColor3 = (option == selectedValue) and theme.AccentVeryDark or theme.Background,
                    Text = " " .. tostring(option),
                    TextColor3 = (option == selectedValue) and theme.Accent or theme.Text,
                    Font = theme.Font,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = scroll
                })
                
                optBtn.MouseButton1Click:Connect(function()
                    selectedValue = option
                    btn.Text = " " .. tostring(selectedValue) .. " "
                    closeDropdown()
                    if callback then callback(selectedValue) end
                end)
            end
        end
        
        btn.MouseButton1Click:Connect(openDropdown)
        
        -- Close when clicking elsewhere
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownOpen then
                local pos = UserInputService:GetMouseLocation()
                local absPos = optionFrame and optionFrame.AbsolutePosition
                local absSize = optionFrame and optionFrame.AbsoluteSize
                
                if absPos and (pos.X < absPos.X or pos.X > absPos.X + absSize.X or 
                              pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y) then
                    if not (pos.X >= btn.AbsolutePosition.X and pos.X <= btn.AbsolutePosition.X + btn.AbsoluteSize.X and
                            pos.Y >= btn.AbsolutePosition.Y and pos.Y <= btn.AbsolutePosition.Y + btn.AbsoluteSize.Y) then
                        closeDropdown()
                    end
                end
            end
        end)
        
        if tooltip then AddTooltip(frame, tooltip, theme) end
        
        return {
            Instance = frame,
            GetValue = function() return selectedValue end,
            SetValue = function(v)
                if table.find(options, v) then
                    selectedValue = v
                    btn.Text = " " .. tostring(selectedValue) .. " "
                    if callback then callback(v) end
                end
            end,
            Refresh = function(newOptions, keepSelected)
                options = newOptions
                if not keepSelected or not table.find(options, selectedValue) then
                    selectedValue = options[1] or "None"
                end
                btn.Text = " " .. tostring(selectedValue) .. " "
                closeDropdown()
            end,
            Flag = flag
        }
    end
}

-- Button Component
ComponentRegistry.Button = {
    Create = function(parent, config, theme, callback)
        local text = config.Text or "Button"
        local style = config.Style or "Default" -- Default, Danger, Success
        local flag = config.Flag or text:gsub("%s+", "_"):lower()
        local tooltip = config.Tooltip
        
        local colors = {
            Default = theme.AccentDarker,
            Danger = Color3.fromRGB(80, 20, 20),
            Success = Color3.fromRGB(20, 80, 20)
        }
        
        local hoverColors = {
            Default = theme.Accent,
            Danger = Color3.fromRGB(120, 30, 30),
            Success = Color3.fromRGB(30, 120, 30)
        }
        
        local btn = Create("TextButton", {
            Size = UDim2.new(1, -16, 0, 36),
            BackgroundColor3 = colors[style],
            Text = text,
            TextColor3 = theme.Text,
            Font = theme.Font,
            TextSize = 14,
            Parent = parent
        })
        
        ApplyBorder(btn, theme)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = hoverColors[style]
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = colors[style]
        end)
        
        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        
        if tooltip then AddTooltip(btn, tooltip, theme) end
        
        return {
            Instance = btn,
            Click = function() if callback then callback() end end,
            SetText = function(t) btn.Text = t end,
            Flag = flag
        }
    end
}

-- Keybind Component
ComponentRegistry.Keybind = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Keybind"
        local default = config.Default or Enum.KeyCode.Unknown
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local tooltip = config.Tooltip
        local onPressed = config.OnPressed
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
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
        
        local keyBtn = Create("TextButton", {
            Size = UDim2.new(0, 90, 0, 26),
            Position = UDim2.new(1, -102, 0.5, -13),
            BackgroundColor3 = theme.AccentDarker,
            Text = default ~= Enum.KeyCode.Unknown and default.Name or "NONE",
            TextColor3 = theme.Text,
            Font = theme.MonoFont,
            TextSize = 12,
            Parent = frame
        })
        
        ApplyBorder(keyBtn, theme)
        
        local listening = false
        local currentKey = default
        
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
            keyBtn.BackgroundColor3 = theme.Accent
        end)
        
        local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                currentKey = input.KeyCode
                keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
                keyBtn.BackgroundColor3 = theme.AccentDarker
                if callback then callback(currentKey) end
            elseif not gameProcessed and input.KeyCode == currentKey and onPressed then
                onPressed()
            end
        end)
        
        table.insert(ConnectionBin, connection)
        
        if tooltip then AddTooltip(frame, tooltip, theme) end
        
        return {
            Instance = frame,
            GetKey = function() return currentKey end,
            SetKey = function(key)
                currentKey = key
                keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
            end,
            Flag = flag,
            Connection = connection
        }
    end
}

-- TextBox Component
ComponentRegistry.TextBox = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "TextBox"
        local placeholder = config.Placeholder or "Enter text..."
        local default = config.Default or ""
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local tooltip = config.Tooltip
        local clearOnFocus = config.ClearOnFocus or false
        local numOnly = config.NumbersOnly or false
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
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
        
        local boxFrame = Create("Frame", {
            Size = UDim2.new(0.54, 0, 0, 26),
            Position = UDim2.new(0.44, 0, 0.5, -13),
            BackgroundColor3 = theme.Background,
            BorderSizePixel = 0,
            Parent = frame
        })
        
        ApplyBorder(boxFrame, theme, theme.AccentDarker)
        
        local box = Create("TextBox", {
            Size = UDim2.new(1, -8, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = default,
            PlaceholderText = placeholder,
            TextColor3 = theme.Text,
            PlaceholderColor3 = theme.TextDark,
            Font = theme.MonoFont,
            TextSize = 12,
            ClearTextOnFocus = clearOnFocus,
            Parent = boxFrame
        })
        
        if numOnly then
            box:GetPropertyChangedSignal("Text"):Connect(function()
                box.Text = box.Text:gsub("[^%d%.%-]", "")
            end)
        end
        
        box.FocusLost:Connect(function(enterPressed)
            if callback then callback(box.Text, enterPressed) end
        end)
        
        if tooltip then AddTooltip(frame, tooltip, theme) end
        
        return {
            Instance = frame,
            GetText = function() return box.Text end,
            SetText = function(t) box.Text = t end,
            Focus = function() box:CaptureFocus() end,
            Flag = flag
        }
    end
}

-- Label Component
ComponentRegistry.Label = {
    Create = function(parent, config, theme)
        local text = config.Text or "Label"
        local style = config.Style or "Default" -- Default, Header, Dim, Accent
        
        local colors = {
            Default = theme.Text,
            Header = theme.Accent,
            Dim = theme.TextDim,
            Accent = theme.Accent,
            Error = theme.ErrorColor,
            Warning = theme.WarningColor,
            Success = theme.SuccessColor
        }
        
        local lbl = Create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = colors[style] or theme.Text,
            Font = style == "Header" and theme.MonoFont or theme.Font,
            TextSize = style == "Header" and 14 or 13,
            TextXAlignment = config.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = parent
        })
        
        return {
            Instance = lbl,
            SetText = function(t) lbl.Text = t end,
            SetColor = function(c) lbl.TextColor3 = c end
        }
    end
}

-- Divider Component
ComponentRegistry.Divider = {
    Create = function(parent, theme, config)
        config = config or {}
        local text = config.Text
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, text and 24 or 10),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local line1 = Create("Frame", {
            Size = UDim2.new(text and 0.3 or 0.45, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = theme.AccentDarker,
            BorderSizePixel = 0,
            Parent = frame
        })
        
        if text then
            local lbl = Create("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0.3, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = " " .. text .. " ",
                TextColor3 = theme.TextDim,
                Font = theme.MonoFont,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = frame
            })
        end
        
        local line2 = Create("Frame", {
            Size = UDim2.new(text and 0.3 or 0.45, 0, 0, 1),
            Position = UDim2.new(text and 0.7 or 0.55, 0, 0.5, 0),
            BackgroundColor3 = theme.AccentDarker,
            BorderSizePixel = 0,
            Parent = frame
        })
        
        return {Instance = frame}
    end
}

-- ColorPicker Component (Simplified Retro)
ComponentRegistry.ColorPicker = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Color"
        local default = config.Default or theme.Accent
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
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
            Size = UDim2.new(0, 60, 0, 24),
            Position = UDim2.new(1, -72, 0.5, -12),
            BackgroundColor3 = default,
            Text = "",
            Parent = frame
        })
        
        ApplyBorder(preview, theme)
        
        local value = default
        
        -- Simple preset colors for retro feel
        local presets = {
            theme.Accent, theme.ErrorColor, theme.WarningColor, 
            theme.InfoColor, theme.SuccessColor, Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(128, 128, 128), Color3.fromRGB(0, 0, 0)
        }
        
        local pickerOpen = false
        local pickerFrame = nil
        
        preview.MouseButton1Click:Connect(function()
            if pickerOpen then
                if pickerFrame then pickerFrame:Destroy() end
                pickerOpen = false
                return
            end
            
            pickerOpen = true
            pickerFrame = Create("Frame", {
                Size = UDim2.new(0, 160, 0, 80),
                Position = UDim2.new(0, -100, 1, 4),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 100,
                Parent = preview
            })
            
            ApplyBorder(pickerFrame, theme)
            
            for i, color in pairs(presets) do
                local x = ((i - 1) % 4) * 38 + 4
                local y = math.floor((i - 1) / 4) * 38 + 4
                
                local btn = Create("TextButton", {
                    Size = UDim2.new(0, 34, 0, 34),
                    Position = UDim2.new(0, x, 0, y),
                    BackgroundColor3 = color,
                    Text = "",
                    Parent = pickerFrame
                })
                
                ApplyBorder(btn, theme, theme.TextDim)
                
                btn.MouseButton1Click:Connect(function()
                    value = color
                    preview.BackgroundColor3 = value
                    if pickerFrame then pickerFrame:Destroy() end
                    pickerOpen = false
                    if callback then callback(value) end
                end)
            end
        end)
        
        return {
            Instance = frame,
            GetColor = function() return value end,
            SetColor = function(c)
                value = c
                preview.BackgroundColor3 = value
                if callback then callback(value) end
            end,
            Flag = flag
        }
    end
}

-- Main Window Creator
function VoidFrame:CreateWindow(config)
    config = config or {}
    
    local title = config.Title or "VOID FRAME"
    local subtitle = config.Subtitle or ""
    local width = config.Width or 700
    local height = config.Height or 500
    local theme = config.Theme or self.CurrentTheme
    local keybind = config.Keybind or Enum.KeyCode.RightShift
    local canResize = config.CanResize ~= false
    local icon = config.Icon -- Image ID or text
    
    -- Initialize notification system
    self.NotificationSystem:Init(theme)
    
    -- Create main GUI
    local screen = Create("ScreenGui", {
        Name = "VoidFrame_" .. math.floor(tick() * 1000),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Main container
    local main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = screen
    })
    
    ApplyBorder(main, theme)
    MakeDraggable(main)
    
    -- Header
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = main
    })
    
    ApplyBorder(header, theme)
    
    -- Title area
    local titleContainer = Create("Frame", {
        Size = UDim2.new(1, -120, 1, 0),
        BackgroundTransparency = 1,
        Parent = header
    })
    
    if icon then
        local iconLbl = Create("TextLabel", {
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = theme.Accent,
            Font = theme.Font,
            TextSize = 24,
            Parent = titleContainer
        })
    end
    
    local titleLbl = Create("TextLabel", {
        Size = UDim2.new(1, icon and -40 or -20, 0, 24),
        Position = UDim2.new(0, icon and 40 or 14, 0, 4),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = theme.Accent,
        Font = theme.MonoFont,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleContainer
    })
    
    if subtitle and subtitle ~= "" then
        local subLbl = Create("TextLabel", {
            Size = UDim2.new(1, icon and -40 or -20, 0, 16),
            Position = UDim2.new(0, icon and 40 or 14, 0, 26),
            BackgroundTransparency = 1,
            Text = subtitle,
            TextColor3 = theme.TextDim,
            Font = theme.MonoFont,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleContainer
        })
    end
    
    -- Window controls
    local minimizeBtn = Create("TextButton", {
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(1, -74, 0, 6),
        BackgroundColor3 = theme.AccentVeryDark,
        Text = "_",
        TextColor3 = theme.Text,
        Font = theme.MonoFont,
        TextSize = 18,
        Parent = header
    })
    
    ApplyBorder(minimizeBtn, theme)
    
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(1, -36, 0, 6),
        BackgroundColor3 = theme.AccentVeryDark,
        Text = "X",
        TextColor3 = theme.ErrorColor or theme.Text,
        Font = theme.MonoFont,
        TextSize = 16,
        Parent = header
    })
    
    ApplyBorder(closeBtn, theme)
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Size = UDim2.new(0, 180, 1, -52),
        Position = UDim2.new(0, 8, 0, 52),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = main
    })
    
    ApplyBorder(sidebar, theme)
    
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
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList
    })
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 8)
    end)
    
    -- Content area
    local contentArea = Create("Frame", {
        Size = UDim2.new(1, -196, 1, -52),
        Position = UDim2.new(0, 188, 0, 52),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = main
    })
    
    ApplyBorder(contentArea, theme)
    
    -- Minimized icon
    local minimizedIcon = Create("TextButton", {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = theme.Header,
        Text = icon or "V",
        TextColor3 = theme.Accent,
        Font = theme.Font,
        TextSize = 24,
        Visible = false,
        Parent = screen
    })
    
    ApplyBorder(minimizedIcon, theme)
    MakeDraggable(minimizedIcon)
    
    -- Window API
    local window = {
        Theme = theme,
        Screen = screen,
        Main = main,
        ContentArea = contentArea,
        Tabs = {},
        ActiveTab = nil,
        Elements = {},
        ConfigData = {},
        IsVisible = true,
        IsMinimized = false
    }
    
    -- Control functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        minimizedIcon.Visible = true
        window.IsMinimized = true
        window.IsVisible = false
    end)
    
    minimizedIcon.MouseButton1Click:Connect(function()
        minimizedIcon.Visible = false
        main.Visible = true
        window.IsMinimized = false
        window.IsVisible = true
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
        for i, w in pairs(Windows) do
            if w == window then
                table.remove(Windows, i)
                break
            end
        end
    end)
    
    -- Toggle with keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keybind then
            if window.IsMinimized then
                minimizedIcon.Visible = false
                main.Visible = true
                window.IsMinimized = false
                window.IsVisible = true
            else
                main.Visible = not main.Visible
                window.IsVisible = main.Visible
            end
        end
    end)
    
    -- Tab Creation
    function window:AddTab(config)
        config = config or {}
        local name = config.Name or "Tab"
        local icon = config.Icon
        
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, -4, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            Text = (icon and icon .. " " or "") .. name,
            TextColor3 = theme.TextDim,
            Font = theme.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabList
        })
        
        ApplyBorder(tabBtn, theme)
        
        local tabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.AccentDark,
            Visible = false,
            Parent = contentArea
        })
        
        local contentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
        end)
        
        local tab = {
            Name = name,
            Button = tabBtn,
            Content = tabContent,
            Elements = {},
            Layout = contentLayout
        }
        
        tabBtn.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                tabBtn.BackgroundColor3 = theme.AccentDarker
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                tabBtn.BackgroundColor3 = theme.AccentVeryDark
            end
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            window:SelectTab(tab)
        end)
        
        table.insert(self.Tabs, tab)
        
        -- Auto-select first tab
        if #self.Tabs == 1 then
            self:SelectTab(tab)
        end
        
        -- Tab API
        local tabAPI = {}
        
        function tabAPI:AddSection(text)
            return ComponentRegistry.Label.Create(tabContent, {
                Text = text,
                Style = "Header"
            }, theme)
        end
        
        function tabAPI:AddLabel(text, style)
            return ComponentRegistry.Label.Create(tabContent, {
                Text = text,
                Style = style or "Default"
            }, theme)
        end
        
        function tabAPI:AddDivider(text)
            return ComponentRegistry.Divider.Create(tabContent, theme, {Text = text})
        end
        
        function tabAPI:AddSpacer(height)
            local spacer = Create("Frame", {
                Size = UDim2.new(1, 0, 0, height or 8),
                BackgroundTransparency = 1,
                Parent = tabContent
            })
            return {Instance = spacer}
        end
        
        function tabAPI:AddToggle(config, callback)
            local comp = ComponentRegistry.Toggle.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            window.ConfigData[comp.Flag] = comp.GetValue
            return comp
        end
        
        function tabAPI:AddSlider(config, callback)
            local comp = ComponentRegistry.Slider.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            window.ConfigData[comp.Flag] = comp.GetValue
            return comp
        end
        
        function tabAPI:AddDropdown(config, callback)
            local comp = ComponentRegistry.Dropdown.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            window.ConfigData[comp.Flag] = comp.GetValue
            return comp
        end
        
        function tabAPI:AddButton(config, callback)
            local comp = ComponentRegistry.Button.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            return comp
        end
        
        function tabAPI:AddKeybind(config, callback)
            local comp = ComponentRegistry.Keybind.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            window.ConfigData[comp.Flag] = comp.GetKey
            return comp
        end
        
        function tabAPI:AddTextBox(config, callback)
            local comp = ComponentRegistry.TextBox.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            window.ConfigData[comp.Flag] = comp.GetText
            return comp
        end
        
        function tabAPI:AddColorPicker(config, callback)
            local comp = ComponentRegistry.ColorPicker.Create(tabContent, config, theme, callback)
            table.insert(tab.Elements, comp)
            window.ConfigData[comp.Flag] = comp.GetColor
            return comp
        end
        
        -- Group/Container
        function tabAPI:AddGroup(title)
            local groupFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Parent = tabContent
            })
            
            ApplyBorder(groupFrame, theme)
            
            local header = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = theme.AccentVeryDark,
                BorderSizePixel = 0,
                Parent = groupFrame
            })
            
            local titleLbl = Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = "◆ " .. title,
                TextColor3 = theme.Accent,
                Font = theme.MonoFont,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = header
            })
            
            local container = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 0),
                Position = UDim2.new(0, 4, 0, 32),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = groupFrame
            })
            
            local listLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = container
            })
            
            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                container.Size = UDim2.new(1, -8, 0, listLayout.AbsoluteContentSize.Y + 8)
                groupFrame.Size = UDim2.new(1, 0, 0, 32 + listLayout.AbsoluteContentSize.Y + 12)
            end)
            
            local groupAPI = {}
            
            function groupAPI:AddToggle(config, callback)
                return tabAPI.AddToggle(config, callback).Instance.Parent = container
            end
            -- Mirror other methods to container...
            
            return groupAPI
        end
        
        return tabAPI
    end
    
    function window:SelectTab(tab)
        if self.ActiveTab then
            self.ActiveTab.Content.Visible = false
            self.ActiveTab.Button.BackgroundColor3 = theme.AccentVeryDark
            self.ActiveTab.Button.TextColor3 = theme.TextDim
        end
        
        self.ActiveTab = tab
        tab.Content.Visible = true
        tab.Button.BackgroundColor3 = theme.AccentDarker
        tab.Button.TextColor3 = theme.Text
    end
    
    function window:Notify(title, message, duration, notifType)
        return VoidFrame.NotificationSystem:Notify(title, message, duration, notifType)
    end
    
    function window:GetConfigData()
        local data = {}
        for flag, getter in pairs(self.ConfigData) do
            if type(getter) == "function" then
                data[flag] = getter()
            end
        end
        return data
    end
    
    function window:LoadConfigData(data)
        for flag, value in pairs(data) do
            -- Find element with this flag and set value
            for _, tab in pairs(self.Tabs) do
                for _, element in pairs(tab.Elements) do
                    if element.Flag == flag then
                        if element.SetValue then
                            element.SetValue(value)
                        elseif element.SetKey then
                            element.SetKey(value)
                        elseif element.SetText then
                            element.SetText(value)
                        elseif element.SetColor then
                            element.SetColor(value)
                        end
                    end
                end
            end
        end
    end
    
    function window:SaveConfig(name)
        return VoidFrame.ConfigManager:SaveConfig(name, self:GetConfigData())
    end
    
    function window:LoadConfig(name)
        local data = VoidFrame.ConfigManager:LoadConfig(name)
        if data then
            self:LoadConfigData(data)
            return true
        end
        return false
    end
    
    function window:SetTheme(newTheme)
        self.Theme = newTheme
        VoidFrame.CurrentTheme = newTheme
        -- Would need to recursively update all elements...
        self.Notify("THEME", "Theme updated to " .. newTheme.Name, 2)
    end
    
    function window:Destroy()
        screen:Destroy()
        for i, w in pairs(Windows) do
            if w == self then
                table.remove(Windows, i)
                break
            end
        end
    end
    
    table.insert(Windows, window)
    return window
end

-- Global API Shortcuts
function VoidFrame:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = self.Themes[themeName]
        return true
    end
    return false
end

function VoidFrame:GetTheme()
    return self.CurrentTheme
end

function VoidFrame:Notify(title, message, duration, notifType)
    self.NotificationSystem:Init(self.CurrentTheme)
    return self.NotificationSystem:Notify(title, message, duration, notifType)
end

function VoidFrame:CreateCustomTheme(name, properties)
    local base = properties.Base and self.Themes[properties.Base] or self.Themes.RetroGreen
    local newTheme = {}
    
    for k, v in pairs(base) do
        newTheme[k] = properties[k] or v
    end
    
    newTheme.Name = name
    self.Themes[name] = newTheme
    return newTheme
end

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Players.LocalPlayer then
        for _, window in pairs(Windows) do
            if window.Screen then
                window.Screen:Destroy()
            end
        end
        for _, conn in pairs(ConnectionBin) do
            if conn then conn:Disconnect() end
        end
    end
end)

return VoidFrame
