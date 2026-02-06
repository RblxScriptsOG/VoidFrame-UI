--[[

 __   __     ______     ______     ______     __         ______     ______     ______    
/\ \ / /    /\  ___\   /\  ___\   /\  == \   /\ \       /\  __ \   /\  ___\   /\  ___\   
\ \ \'/     \ \  __\   \ \ \____  \ \  __<   \ \ \____  \ \  __ \  \ \ \__ \  \ \  __\   
 \ \__|      \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\ 
  \/_/        \/_____/   \/_____/   \/_/ /_/   \/_____/   \/_/\/_/   \/_____/   \/_____/ 

                V O I D F R A M E   L I B R A R Y  [COMPAT]
           Universal Executor Support Version
           
--]]

local VoidFrame = {}
VoidFrame.__index = VoidFrame

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Executor Compatibility Layer
local function GetCoreGui()
    -- Try multiple methods for different executors
    local success, result = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success and result then
        return result
    end
    
    -- Fallback to PlayerGui
    local player = Players.LocalPlayer
    if player then
        return player:WaitForChild("PlayerGui")
    end
    
    return nil
end

local CoreGui = GetCoreGui()
if not CoreGui then
    warn("VoidFrame: Could not find valid GUI container")
    return {}
end

-- Check if we have required functions
local hasFileFunctions = (writefile ~= nil and readfile ~= nil and isfile ~= nil)
local hasHttpService = pcall(function() HttpService:JSONEncode({}) end)

-- Configuration System
VoidFrame.Config = {
    AutoSave = false, -- Disabled by default for compatibility
    SaveInterval = 30,
    ConfigFolder = "VoidFrame_Configs",
    DefaultConfigName = "Default"
}

-- Retro Theme System
VoidFrame.Themes = {
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
        CornerRadius = 0,
        BorderSize = 2,
        BorderStyle = "Block",
        Shadow = false,
        CRT = true,
        Scanlines = true
    },
    
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

VoidFrame.CurrentTheme = VoidFrame.Themes.RetroGreen

-- Global Storage
local Windows = {}
local ConnectionBin = {}

-- Utility Functions
local function Create(className, properties)
    local success, obj = pcall(function()
        return Instance.new(className)
    end)
    
    if not success or not obj then
        warn("VoidFrame: Failed to create " .. className)
        return nil
    end
    
    properties = properties or {}
    for k, v in pairs(properties) do
        if k ~= "Parent" then
            pcall(function()
                obj[k] = v
            end)
        end
    end
    
    if properties.Parent then
        pcall(function()
            obj.Parent = properties.Parent
        end)
    end
    
    return obj
end

local function MakeDraggable(obj, handle)
    handle = handle or obj
    local dragging = false
    local dragInput, dragStart, startPos
    
    local success = pcall(function()
        local inputBegan = handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = obj.Position
            end
        end)
        
        local inputChanged = handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or
               input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        local globalChanged = UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        local inputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        table.insert(ConnectionBin, inputBegan)
        table.insert(ConnectionBin, inputChanged)
        table.insert(ConnectionBin, globalChanged)
        table.insert(ConnectionBin, inputEnded)
    end)
    
    return success
end

local function ApplyBorder(obj, theme, customColor)
    if not obj or not theme then return end
    
    local color = customColor or theme.StrokeColor
    local size = theme.BorderSize or 2
    
    -- Remove existing borders
    for _, child in pairs(obj:GetChildren()) do
        if child.Name:sub(1, 7) == "Border_" or child:IsA("UIStroke") then
            child:Destroy()
        end
    end
    
    pcall(function()
        if theme.BorderStyle == "Block" or theme.BorderStyle == "Thick" then
            local sides = {"Top", "Bottom", "Left", "Right"}
            for _, side in pairs(sides) do
                local border = Create("Frame", {
                    Name = "Border_" .. side,
                    BackgroundColor3 = color,
                    BorderSizePixel = 0,
                    Parent = obj
                })
                
                if border then
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
            end
        else
            local stroke = Create("UIStroke", {
                Color = color,
                Thickness = size,
                Transparency = 0.2,
                Parent = obj
            })
        end
    end)
end

-- Config Manager (Memory-only for compatibility)
VoidFrame.ConfigManager = {
    LoadedConfigs = {},
    
    SaveConfig = function(self, name, data)
        if not hasFileFunctions or not hasHttpService then
            warn("VoidFrame: File functions not available. Config not saved.")
            return false
        end
        
        local success = pcall(function()
            local configName = name or VoidFrame.Config.DefaultConfigName
            local encoded = HttpService:JSONEncode(data)
            
            if not isfile(VoidFrame.Config.ConfigFolder) then
                -- Try to create folder (may fail on some executors)
                pcall(makefolder, VoidFrame.Config.ConfigFolder)
            end
            
            local path = VoidFrame.Config.ConfigFolder .. "/" .. configName .. ".json"
            writefile(path, encoded)
            
            if VoidFrame.NotificationSystem then
                VoidFrame.NotificationSystem:Notify("CONFIG", "Saved: " .. configName, 2)
            end
        end)
        
        return success
    end,
    
    LoadConfig = function(self, name)
        if not hasFileFunctions or not hasHttpService then
            return nil
        end
        
        local success, result = pcall(function()
            local configName = name or VoidFrame.Config.DefaultConfigName
            local path = VoidFrame.Config.ConfigFolder .. "/" .. configName .. ".json"
            
            if isfile(path) then
                local encoded = readfile(path)
                return HttpService:JSONDecode(encoded)
            end
            return nil
        end)
        
        return success and result or nil
    end,
    
    ListConfigs = function(self)
        if not hasFileFunctions then return {} end
        
        local success, result = pcall(function()
            local files = listfiles(VoidFrame.Config.ConfigFolder)
            local configs = {}
            for _, file in pairs(files) do
                if file:match("%.json$") then
                    local name = file:match("([^/\\]+)%.json$")
                    if name then table.insert(configs, name) end
                end
            end
            return configs
        end)
        
        return success and result or {}
    end
}

-- Notification System
VoidFrame.NotificationSystem = {
    ActiveNotifications = {},
    MaxNotifications = 5,
    Container = nil,
    Screen = nil,
    Theme = nil,
    
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
        
        if not self.Screen then return end
        
        self.Container = Create("Frame", {
            Size = UDim2.new(0, 420, 1, 0),
            Position = UDim2.new(1, -440, 0, 20),
            BackgroundTransparency = 1,
            Parent = self.Screen
        })
        
        local layout = Create("UIListLayout", {
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
        
        if not self.Container then
            self:Init(theme)
        end
        
        if not self.Container then
            warn("VoidFrame: Notification container failed to initialize")
            return nil
        end
        
        local notif = Create("Frame", {
            Size = UDim2.new(0, 400, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 0,
            LayoutOrder = -(#self.ActiveNotifications),
            Parent = self.Container
        })
        
        if not notif then return nil end
        
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
            Text = "> " .. (title or "VOID"):upper(),
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
        
        local msgHeight = msgLbl and msgLbl.TextBounds and msgLbl.TextBounds.Y or 20
        notif.Size = UDim2.new(0, 400, 0, 36 + msgHeight + 10)
        
        local function close()
            if notif and notif.Parent then
                notif:Destroy()
                for i, n in pairs(self.ActiveNotifications) do
                    if n == notif then
                        table.remove(self.ActiveNotifications, i)
                        break
                    end
                end
            end
        end
        
        if closeBtn then
            closeBtn.MouseButton1Click:Connect(close)
        end
        
        task.delay(duration, close)
        table.insert(self.ActiveNotifications, 1, notif)
        
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

-- Component Registry
local ComponentRegistry = {}

ComponentRegistry.Toggle = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Toggle"
        local default = config.Default or false
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 34),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        if not frame then return nil end
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
            if switch then
                switch.BackgroundColor3 = value and theme.Accent or theme.AccentDarker
            end
            if knob then
                knob.Position = value and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            end
            if callback then callback(value) end
            return value
        end
        
        local clickArea = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = frame
        })
        
        if clickArea then
            clickArea.MouseButton1Click:Connect(function()
                update(not value)
            end)
        end
        
        return {
            Instance = frame,
            GetValue = function() return value end,
            SetValue = update,
            Flag = flag
        }
    end
}

ComponentRegistry.Slider = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Slider"
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local suffix = config.Suffix or ""
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local decimals = config.Decimals or 0
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 54),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        if not frame then return nil end
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
        local dragging = false
        
        local function update(inputX)
            if not track then return end
            local relX = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * relX
            
            if decimals == 0 then
                newValue = math.floor(newValue)
            else
                newValue = math.floor(newValue * (10 ^ decimals)) / (10 ^ decimals)
            end
            
            value = newValue
            if fill then
                fill.Size = UDim2.new(relX, 0, 1, 0)
            end
            if valueLabel then
                valueLabel.Text = tostring(value) .. suffix
            end
            if callback then callback(value) end
        end
        
        if track then
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or
                   input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input.Position.X)
                end
            end)
            
            track.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                                input.UserInputType == Enum.UserInputType.Touch) then
                    update(input.Position.X)
                end
            end)
        end
        
        local inputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        table.insert(ConnectionBin, inputEnded)
        
        return {
            Instance = frame,
            GetValue = function() return value end,
            SetValue = function(v)
                value = math.clamp(v, min, max)
                if fill then
                    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                end
                if valueLabel then
                    valueLabel.Text = tostring(value) .. suffix
                end
                if callback then callback(value) end
            end,
            Flag = flag
        }
    end
}

ComponentRegistry.Dropdown = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Dropdown"
        local options = config.Options or {}
        local default = config.Default or options[1] or "None"
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 38),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        if not frame then return nil end
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
            if arrow then arrow.Text = "▼" end
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
            if arrow then arrow.Text = "▲" end
            
            optionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, math.min(#options * 28, 200)),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 100,
                Parent = btn
            })
            
            if not optionFrame then return end
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
                
                if optBtn then
                    optBtn.MouseButton1Click:Connect(function()
                        selectedValue = option
                        if btn then btn.Text = " " .. tostring(selectedValue) .. " " end
                        closeDropdown()
                        if callback then callback(selectedValue) end
                    end)
                end
            end
        end
        
        if btn then
            btn.MouseButton1Click:Connect(openDropdown)
        end
        
        return {
            Instance = frame,
            GetValue = function() return selectedValue end,
            SetValue = function(v)
                if table.find(options, v) then
                    selectedValue = v
                    if btn then btn.Text = " " .. tostring(selectedValue) .. " " end
                    if callback then callback(v) end
                end
            end,
            Refresh = function(newOptions, keepSelected)
                options = newOptions
                if not keepSelected or not table.find(options, selectedValue) then
                    selectedValue = options[1] or "None"
                end
                if btn then btn.Text = " " .. tostring(selectedValue) .. " " end
                closeDropdown()
            end,
            Flag = flag
        }
    end
}

ComponentRegistry.Button = {
    Create = function(parent, config, theme, callback)
        local text = config.Text or "Button"
        local style = config.Style or "Default"
        local flag = config.Flag or text:gsub("%s+", "_"):lower()
        
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
        
        if not btn then return nil end
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
        
        return {
            Instance = btn,
            Click = function() if callback then callback() end end,
            SetText = function(t) btn.Text = t end,
            Flag = flag
        }
    end
}

ComponentRegistry.Keybind = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "Keybind"
        local default = config.Default or Enum.KeyCode.Unknown
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local onPressed = config.OnPressed
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        if not frame then return nil end
        ApplyBorder(frame, theme)
        
        local label = Create("TextLabel", {
            Size = UDim2.new(0.62, 0, 1, 0),
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
            Size = UDim2.new(0, 100, 0, 26),
            Position = UDim2.new(1, -112, 0.5, -13),
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
        
        if keyBtn then
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                keyBtn.BackgroundColor3 = theme.Accent
            end)
        end
        
        local inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                currentKey = input.KeyCode
                if keyBtn then
                    keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
                    keyBtn.BackgroundColor3 = theme.AccentDarker
                end
                if callback then callback(currentKey) end
            elseif not gameProcessed and input.KeyCode == currentKey and onPressed then
                onPressed()
            end
        end)
        
        table.insert(ConnectionBin, inputBegan)
        
        return {
            Instance = frame,
            GetKey = function() return currentKey end,
            SetKey = function(key)
                currentKey = key
                if keyBtn then
                    keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
                end
            end,
            Flag = flag
        }
    end
}

ComponentRegistry.TextBox = {
    Create = function(parent, config, theme, callback)
        local name = config.Name or "TextBox"
        local placeholder = config.Placeholder or "Enter text..."
        local default = config.Default or ""
        local flag = config.Flag or name:gsub("%s+", "_"):lower()
        local clearOnFocus = config.ClearOnFocus or false
        local numOnly = config.NumbersOnly or false
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            BorderSizePixel = 0,
            Parent = parent
        })
        
        if not frame then return nil end
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
        
        if box and numOnly then
            box:GetPropertyChangedSignal("Text"):Connect(function()
                box.Text = box.Text:gsub("[^%d%.%-]", "")
            end)
        end
        
        if box then
            box.FocusLost:Connect(function(enterPressed)
                if callback then callback(box.Text, enterPressed) end
            end)
        end
        
        return {
            Instance = frame,
            GetText = function() return box and box.Text or "" end,
            SetText = function(t) if box then box.Text = t end end,
            Focus = function() if box then box:CaptureFocus() end end,
            Flag = flag
        }
    end
}

ComponentRegistry.Label = {
    Create = function(parent, config, theme)
        local text = config.Text or "Label"
        local style = config.Style or "Default"
        
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
            SetText = function(t) if lbl then lbl.Text = t end end,
            SetColor = function(c) if lbl then lbl.TextColor3 = c end end
        }
    end
}

ComponentRegistry.Divider = {
    Create = function(parent, theme, config)
        config = config or {}
        local text = config.Text
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -16, 0, text and 24 or 10),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        if not frame then return nil end
        
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
        
        if not frame then return nil end
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
        local pickerOpen = false
        local pickerFrame = nil
        
        local presets = {
            theme.Accent, theme.ErrorColor, theme.WarningColor, 
            theme.InfoColor, theme.SuccessColor, Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(128, 128, 128), Color3.fromRGB(0, 0, 0)
        }
        
        if preview then
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
                
                if not pickerFrame then return end
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
                    
                    if btn then
                        ApplyBorder(btn, theme, theme.TextDim)
                        btn.MouseButton1Click:Connect(function()
                            value = color
                            preview.BackgroundColor3 = value
                            if pickerFrame then pickerFrame:Destroy() end
                            pickerOpen = false
                            if callback then callback(value) end
                        end)
                    end
                end
            end)
        end
        
        return {
            Instance = frame,
            GetColor = function() return value end,
            SetColor = function(c)
                value = c
                if preview then preview.BackgroundColor3 = value end
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
    local icon = config.Icon
    
    self.NotificationSystem:Init(theme)
    
    local screen = Create("ScreenGui", {
        Name = "VoidFrame_" .. tostring(math.floor(tick() * 1000)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    if not screen then
        warn("VoidFrame: Failed to create ScreenGui")
        return nil
    end
    
    local main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = screen
    })
    
    if not main then
        screen:Destroy()
        return nil
    end
    
    ApplyBorder(main, theme)
    MakeDraggable(main)
    
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = main
    })
    
    ApplyBorder(header, theme)
    
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
    
    if tabLayout then
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if tabList then
                tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 8)
            end
        end)
    end
    
    local contentArea = Create("Frame", {
        Size = UDim2.new(1, -196, 1, -52),
        Position = UDim2.new(0, 188, 0, 52),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = main
    })
    
    ApplyBorder(contentArea, theme)
    
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
    
    if minimizeBtn then
        minimizeBtn.MouseButton1Click:Connect(function()
            main.Visible = false
            minimizedIcon.Visible = true
            window.IsMinimized = true
            window.IsVisible = false
        end)
    end
    
    if minimizedIcon then
        minimizedIcon.MouseButton1Click:Connect(function()
            minimizedIcon.Visible = false
            main.Visible = true
            window.IsMinimized = false
            window.IsVisible = true
        end)
    end
    
    if closeBtn then
        closeBtn.MouseButton1Click:Connect(function()
            screen:Destroy()
            for i, w in pairs(Windows) do
                if w == window then
                    table.remove(Windows, i)
                    break
                end
            end
        end)
    end
    
    local keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
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
    
    table.insert(ConnectionBin, keybindConnection)
    
    function window:AddTab(config)
        config = config or {}
        local name = config.Name or "Tab"
        local tabIcon = config.Icon
        
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, -4, 0, 36),
            BackgroundColor3 = theme.AccentVeryDark,
            Text = (tabIcon and tabIcon .. " " or "") .. name,
            TextColor3 = theme.TextDim,
            Font = theme.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabList
        })
        
        if not tabBtn then return nil end
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
        
        if contentLayout then
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if tabContent then
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
                end
            end)
        end
        
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
        
        if #self.Tabs == 1 then
            self:SelectTab(tab)
        end
        
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
            if comp then
                table.insert(tab.Elements, comp)
                self.ConfigData[comp.Flag] = comp.GetValue
            end
            return comp
        end
        
        function tabAPI:AddSlider(config, callback)
            local comp = ComponentRegistry.Slider.Create(tabContent, config, theme, callback)
            if comp then
                table.insert(tab.Elements, comp)
                self.ConfigData[comp.Flag] = comp.GetValue
            end
            return comp
        end
        
        function tabAPI:AddDropdown(config, callback)
            local comp = ComponentRegistry.Dropdown.Create(tabContent, config, theme, callback)
            if comp then
                table.insert(tab.Elements, comp)
                self.ConfigData[comp.Flag] = comp.GetValue
            end
            return comp
        end
        
        function tabAPI:AddButton(config, callback)
            local comp = ComponentRegistry.Button.Create(tabContent, config, theme, callback)
            if comp then
                table.insert(tab.Elements, comp)
            end
            return comp
        end
        
        function tabAPI:AddKeybind(config, callback)
            local comp = ComponentRegistry.Keybind.Create(tabContent, config, theme, callback)
            if comp then
                table.insert(tab.Elements, comp)
                self.ConfigData[comp.Flag] = comp.GetKey
            end
            return comp
        end
        
        function tabAPI:AddTextBox(config, callback)
            local comp = ComponentRegistry.TextBox.Create(tabContent, config, theme, callback)
            if comp then
                table.insert(tab.Elements, comp)
                self.ConfigData[comp.Flag] = comp.GetText
            end
            return comp
        end
        
        function tabAPI:AddColorPicker(config, callback)
            local comp = ComponentRegistry.ColorPicker.Create(tabContent, config, theme, callback)
            if comp then
                table.insert(tab.Elements, comp)
                self.ConfigData[comp.Flag] = comp.GetColor
            end
            return comp
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
        self:Notify("THEME", "Theme updated to " .. newTheme.Name, 2)
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
local player = Players.LocalPlayer
if player then
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
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
end

return VoidFrame
