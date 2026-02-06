--[[

 __   __     ______     ______     ______     __         ______     ______     ______    
/\ \ / /    /\  ___\   /\  ___\   /\  == \   /\ \       /\  __ \   /\  ___\   /\  ___\   
\ \ \'/     \ \  __\   \ \ \____  \ \  __<   \ \ \____  \ \  __ \  \ \ \__ \  \ \  __\   
 \ \__|      \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\ 
  \/_/        \/_____/   \/_____/   \/_/ /_/   \/_____/   \/_/\/_/   \/_____/   \/_____/ 

                V O I D F R A M E   L I B R A R Y  [STABLE]
           Zero Effects - Maximum Compatibility
           
--]]

local VoidFrame = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Fallback for CoreGui
local GuiParent = CoreGui
if not GuiParent then
    GuiParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Simple Theme
VoidFrame.Themes = {
    RetroGreen = {
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(0, 30, 0),
        Accent = Color3.fromRGB(0, 255, 0),
        AccentDark = Color3.fromRGB(0, 150, 0),
        Text = Color3.fromRGB(0, 255, 0),
        TextDim = Color3.fromRGB(0, 180, 0),
        Border = Color3.fromRGB(0, 100, 0),
        Font = Enum.Font.Arcade
    }
}

VoidFrame.CurrentTheme = VoidFrame.Themes.RetroGreen

-- Utility
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

-- Notification System
VoidFrame.NotificationSystem = {
    Screen = nil,
    Container = nil,
    
    Init = function(self, theme)
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
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = self.Container
        })
    end,
    
    Notify = function(self, title, message, duration)
        duration = duration or 3
        local theme = VoidFrame.CurrentTheme
        
        self:Init(theme)
        
        local notif = Create("Frame", {
            Size = UDim2.new(0, 380, 0, 60),
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 1,
            BorderColor3 = theme.Border,
            Parent = self.Container
        })
        
        local header = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundColor3 = theme.Header,
            BorderSizePixel = 0,
            Parent = notif
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = "> " .. (title or "INFO"),
            TextColor3 = theme.Accent,
            Font = theme.Font,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 30),
            Position = UDim2.new(0, 8, 0, 26),
            BackgroundTransparency = 1,
            Text = message or "",
            TextColor3 = theme.Text,
            Font = theme.Font,
            TextSize = 12,
            TextWrapped = true,
            Parent = notif
        })
        
        task.delay(duration, function()
            notif:Destroy()
        end)
    end
}

-- Main Window Creator
function VoidFrame:CreateWindow(config)
    config = config or {}
    
    local title = config.Title or "VOID FRAME"
    local width = config.Width or 600
    local height = config.Height or 450
    local theme = config.Theme or self.CurrentTheme
    local keybind = config.Keybind or Enum.KeyCode.RightShift
    
    -- ScreenGui
    local screen = Create("ScreenGui", {
        Name = "VoidFrame_" .. tostring(tick()),
        ResetOnSpawn = false,
        Parent = GuiParent
    })
    
    -- Main Frame
    local main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 1,
        BorderColor3 = theme.Border,
        Active = true,
        Draggable = true,
        Parent = screen
    })
    
    -- Header
    local header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 1,
        BorderColor3 = theme.Border,
        Parent = main
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = theme.Accent,
        Font = theme.Font,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = theme.Surface,
        Text = "X",
        TextColor3 = theme.Text,
        Font = theme.Font,
        TextSize = 14,
        Parent = header
    })
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = theme.Surface,
        Text = "_",
        TextColor3 = theme.Text,
        Font = theme.Font,
        TextSize = 14,
        Parent = header
    })
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Size = UDim2.new(0, 140, 1, -46),
        Position = UDim2.new(0, 6, 0, 43),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 1,
        BorderColor3 = theme.Border,
        Parent = main
    })
    
    local tabList = Create("ScrollingFrame", {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar
    })
    
    local tabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = tabList
    })
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area
    local contentArea = Create("Frame", {
        Size = UDim2.new(1, -156, 1, -46),
        Position = UDim2.new(0, 150, 0, 43),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 1,
        BorderColor3 = theme.Border,
        Parent = main
    })
    
    -- Minimized Icon
    local minIcon = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = theme.Header,
        Text = "V",
        TextColor3 = theme.Accent,
        Font = theme.Font,
        TextSize = 20,
        Visible = false,
        Draggable = true,
        Parent = screen
    })
    
    -- Window Table
    local window = {
        Theme = theme,
        Screen = screen,
        Main = main,
        ContentArea = contentArea,
        Tabs = {},
        ActiveTab = nil,
        Elements = {}
    }
    
    -- Button Functions
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        minIcon.Visible = true
    end)
    
    minIcon.MouseButton1Click:Connect(function()
        minIcon.Visible = false
        main.Visible = true
    end)
    
    -- Toggle Key
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == keybind then
            if minIcon.Visible then
                minIcon.Visible = false
                main.Visible = true
            else
                main.Visible = not main.Visible
            end
        end
    end)
    
    -- Add Tab Function
    function window:AddTab(tabName)
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, -6, 0, 32),
            BackgroundColor3 = theme.Background,
            Text = tabName,
            TextColor3 = theme.TextDim,
            Font = theme.Font,
            TextSize = 13,
            Parent = tabList
        })
        
        local tabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = contentArea
        })
        
        local contentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            Parent = tabContent
        })
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local tab = {
            Name = tabName,
            Button = tabBtn,
            Content = tabContent,
            Elements = {}
        }
        
        tabBtn.MouseButton1Click:Connect(function()
            if window.ActiveTab then
                window.ActiveTab.Content.Visible = false
                window.ActiveTab.Button.BackgroundColor3 = theme.Background
                window.ActiveTab.Button.TextColor3 = theme.TextDim
            end
            
            window.ActiveTab = tab
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = theme.AccentDark
            tabBtn.TextColor3 = theme.Text
        end)
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            tabBtn.BackgroundColor3 = theme.AccentDark
            tabBtn.TextColor3 = theme.Text
            tabContent.Visible = true
            self.ActiveTab = tab
        end
        
        -- Tab API
        local api = {}
        
        function api:AddSection(text)
            local lbl = Create("TextLabel", {
                Size = UDim2.new(1, -12, 0, 20),
                BackgroundTransparency = 1,
                Text = text:upper(),
                TextColor3 = theme.Accent,
                Font = theme.Font,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tabContent
            })
            return lbl
        end
        
        function api:AddLabel(text)
            local lbl = Create("TextLabel", {
                Size = UDim2.new(1, -12, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                TextWrapped = true,
                Parent = tabContent
            })
            return lbl
        end
        
        function api:AddToggle(config, callback)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 32),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local box = Create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = default and theme.Accent or theme.AccentDark,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = frame
            })
            
            local value = default
            
            local click = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = frame
            })
            
            click.MouseButton1Click:Connect(function()
                value = not value
                box.BackgroundColor3 = value and theme.Accent or theme.AccentDark
                if callback then callback(value) end
            end)
            
            return {
                GetValue = function() return value end,
                SetValue = function(v)
                    value = v
                    box.BackgroundColor3 = value and theme.Accent or theme.AccentDark
                    if callback then callback(v) end
                end
            }
        end
        
        function api:AddSlider(config, callback)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 50),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.5, 0, 0, 20),
                Position = UDim2.new(0, 10, 0, 4),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local valLbl = Create("TextLabel", {
                Size = UDim2.new(0.4, 0, 0, 20),
                Position = UDim2.new(0.5, 0, 0, 4),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = theme.Accent,
                Font = theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = frame
            })
            
            local track = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 8),
                Position = UDim2.new(0, 10, 0, 32),
                BackgroundColor3 = theme.AccentDark,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
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
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    valLbl.Text = tostring(value)
                    if callback then callback(value) end
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    valLbl.Text = tostring(value)
                    if callback then callback(value) end
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {
                GetValue = function() return value end,
                SetValue = function(v)
                    value = math.clamp(v, min, max)
                    fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
                    valLbl.Text = tostring(value)
                    if callback then callback(value) end
                end
            }
        end
        
        function api:AddButton(config, callback)
            config = config or {}
            local text = config.Text or "Button"
            
            local btn = Create("TextButton", {
                Size = UDim2.new(1, -12, 0, 34),
                BackgroundColor3 = theme.AccentDark,
                Text = text,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 13,
                Parent = tabContent
            })
            
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            return btn
        end
        
        function api:AddDropdown(config, callback)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1] or "None"
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 34),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local selected = Create("TextButton", {
                Size = UDim2.new(0.5, 0, 0, 24),
                Position = UDim2.new(0.45, 0, 0.5, -12),
                BackgroundColor3 = theme.AccentDark,
                Text = tostring(default),
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                Parent = frame
            })
            
            local current = default
            local idx = 1
            
            for i, v in pairs(options) do
                if v == default then idx = i break end
            end
            
            selected.MouseButton1Click:Connect(function()
                idx = idx % #options + 1
                current = options[idx]
                selected.Text = tostring(current)
                if callback then callback(current) end
            end)
            
            return {
                GetValue = function() return current end,
                SetValue = function(v)
                    if table.find(options, v) then
                        current = v
                        selected.Text = tostring(current)
                        if callback then callback(v) end
                    end
                end
            }
        end
        
        function api:AddKeybind(config, callback)
            config = config or {}
            local name = config.Name or "Keybind"
            local default = config.Default or Enum.KeyCode.Unknown
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, -12, 0, 34),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 1,
                BorderColor3 = theme.Border,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local keyBtn = Create("TextButton", {
                Size = UDim2.new(0, 80, 0, 24),
                Position = UDim2.new(1, -90, 0.5, -12),
                BackgroundColor3 = theme.AccentDark,
                Text = default ~= Enum.KeyCode.Unknown and default.Name or "NONE",
                TextColor3 = theme.Text,
                Font = theme.Font,
                TextSize = 11,
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
                GetKey = function() return currentKey end,
                SetKey = function(k)
                    currentKey = k
                    keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "NONE"
                end
            }
        end
        
        return api
    end
    
    function window:Notify(title, message, duration)
        VoidFrame.NotificationSystem:Notify(title, message, duration)
    end
    
    return window
end

function VoidFrame:Notify(title, message, duration)
    self.NotificationSystem:Notify(title, message, duration)
end

return VoidFrame
