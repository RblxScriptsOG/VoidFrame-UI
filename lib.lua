--[[

  _________       .__.__             ___ ___      ___.     
 /   _____/ _____ |__|  |   ____    /   |   \ __ _\_ |__   
 \_____  \ /     \|  |  | _/ __ \  /    ~    \  |  \ __ \  
 /        \  Y Y  \  |  |_\  ___/  \    Y    /  |  / \_\ \ 
/_______  /__|_|  /__|____/\___  >  \___|_  /|____/|___  / 
        \/      \/             \/         \/           \/  

--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local FS = {}
FS.folder = "VoidFrame"
FS.configFolder = FS.folder.."/configs"

function FS.exists(path)
    return isfile and isfile(path)
end

function FS.write(path, data)
    if writefile then writefile(path, data) end
end

function FS.read(path)
    if readfile then return readfile(path) end
end

function FS.make(path)
    if makefolder then makefolder(path) end
end

--// Init folders
if makefolder then
    if not isfolder(FS.folder) then FS.make(FS.folder) end
    if not isfolder(FS.configFolder) then FS.make(FS.configFolder) end
end

--// Library
local VoidFrame = {}
VoidFrame.Flags = {}
VoidFrame.Elements = {}
VoidFrame.ConfigName = "default"
VoidFrame.AutoLoad = true

--// Theme
VoidFrame.Theme = {
    Background = Color3.fromRGB(20,20,20),
    Border = Color3.fromRGB(80,80,80),
    Accent = Color3.fromRGB(0,255,120),
    Text = Color3.fromRGB(230,230,230),
    Muted = Color3.fromRGB(140,140,140)
}

--// Utils
local function create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function round(n)
    return math.floor(n + 0.5)
end

--// Config System
function VoidFrame:SaveConfig(name)
    name = name or self.ConfigName
    local data = HttpService:JSONEncode(self.Flags)
    FS.write(FS.configFolder.."/"..name..".json", data)
end

function VoidFrame:LoadConfig(name)
    name = name or self.ConfigName
    local path = FS.configFolder.."/"..name..".json"
    if not FS.exists(path) then return end

    local decoded = HttpService:JSONDecode(FS.read(path))
    for flag, value in pairs(decoded) do
        if self.Elements[flag] then
            self.Elements[flag]:Set(value)
        end
    end
end

--// Window
function VoidFrame:CreateWindow(title)
    local ScreenGui = create("ScreenGui", {Parent = game.CoreGui, ResetOnSpawn = false})

    local Main = create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.fromOffset(520, 420),
        Position = UDim2.fromScale(0.5,0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = self.Theme.Background,
        BorderColor3 = self.Theme.Border
    })

    local Title = create("TextLabel", {
        Parent = Main,
        Size = UDim2.new(1,0,0,32),
        BackgroundTransparency = 1,
        Text = title or "VoidFrame",
        Font = Enum.Font.Code,
        TextSize = 16,
        TextColor3 = self.Theme.Accent
    })

    local TabsHolder = create("Frame", {
        Parent = Main,
        Position = UDim2.fromOffset(0,32),
        Size = UDim2.fromOffset(120,388),
        BackgroundColor3 = self.Theme.Background,
        BorderColor3 = self.Theme.Border
    })

    local Pages = create("Frame", {
        Parent = Main,
        Position = UDim2.fromOffset(120,32),
        Size = UDim2.fromOffset(400,388),
        BackgroundTransparency = 1
    })

    local UIList = create("UIListLayout", {Parent = TabsHolder, Padding = UDim.new(0,4)})

    local Window = {}

    function Window:CreateTab(name)
        local Button = create("TextButton", {
            Parent = TabsHolder,
            Size = UDim2.new(1,-8,0,28),
            BackgroundColor3 = VoidFrame.Theme.Background,
            BorderColor3 = VoidFrame.Theme.Border,
            Text = name,
            Font = Enum.Font.Code,
            TextSize = 14,
            TextColor3 = VoidFrame.Theme.Text
        })

        local Page = create("ScrollingFrame", {
            Parent = Pages,
            Size = UDim2.new(1,0,1,0),
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarImageTransparency = 1,
            Visible = false
        })

        local Layout = create("UIListLayout", {Parent = Page, Padding = UDim.new(0,6)})

        Button.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
        end)

        local Tab = {}

        function Tab:CreateSection(text)
            local Section = create("Frame", {
                Parent = Page,
                Size = UDim2.new(1,-12,0,30),
                BackgroundColor3 = VoidFrame.Theme.Background,
                BorderColor3 = VoidFrame.Theme.Border
            })

            local Label = create("TextLabel", {
                Parent = Section,
                Size = UDim2.new(1,0,0,24),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.Code,
                TextSize = 14,
                TextColor3 = VoidFrame.Theme.Accent
            })

            local UIList = create("UIListLayout", {Parent = Section, Padding = UDim.new(0,4)})
            UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1,-12,0,UIList.AbsoluteContentSize.Y+6)
                Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
            end)

            local SectionAPI = {}

            -- LABEL
            function SectionAPI:Label(text)
                create("TextLabel", {
                    Parent = Section,
                    Size = UDim2.new(1,-8,0,20),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Enum.Font.Code,
                    TextSize = 13,
                    TextColor3 = VoidFrame.Theme.Muted,
                    TextXAlignment = Left
                })
            end

            -- BUTTON
            function SectionAPI:Button(text, callback)
                local Btn = create("TextButton", {
                    Parent = Section,
                    Size = UDim2.new(1,-8,0,26),
                    BackgroundColor3 = VoidFrame.Theme.Background,
                    BorderColor3 = VoidFrame.Theme.Border,
                    Text = text,
                    Font = Enum.Font.Code,
                    TextSize = 14,
                    TextColor3 = VoidFrame.Theme.Text
                })
                Btn.MouseButton1Click:Connect(callback or function() end)
            end

            -- TOGGLE
            function SectionAPI:Toggle(text, flag, default, callback)
                VoidFrame.Flags[flag] = default

                local Btn = create("TextButton", {
                    Parent = Section,
                    Size = UDim2.new(1,-8,0,26),
                    BackgroundColor3 = VoidFrame.Theme.Background,
                    BorderColor3 = VoidFrame.Theme.Border,
                    Text = text.." : "..tostring(default),
                    Font = Enum.Font.Code,
                    TextSize = 14,
                    TextColor3 = VoidFrame.Theme.Text
                })

                local ToggleAPI = {}
                function ToggleAPI:Set(v)
                    VoidFrame.Flags[flag] = v
                    Btn.Text = text.." : "..tostring(v)
                    if callback then callback(v) end
                end

                Btn.MouseButton1Click:Connect(function()
                    ToggleAPI:Set(not VoidFrame.Flags[flag])
                    VoidFrame:SaveConfig()
                end)

                VoidFrame.Elements[flag] = ToggleAPI
            end

            -- SLIDER
            function SectionAPI:Slider(text, flag, min, max, default, callback)
                VoidFrame.Flags[flag] = default

                local Btn = create("TextButton", {
                    Parent = Section,
                    Size = UDim2.new(1,-8,0,26),
                    BackgroundColor3 = VoidFrame.Theme.Background,
                    BorderColor3 = VoidFrame.Theme.Border,
                    Text = text.." : "..default,
                    Font = Enum.Font.Code,
                    TextSize = 14,
                    TextColor3 = VoidFrame.Theme.Text
                })

                local SliderAPI = {}
                function SliderAPI:Set(v)
                    v = math.clamp(round(v), min, max)
                    VoidFrame.Flags[flag] = v
                    Btn.Text = text.." : "..v
                    if callback then callback(v) end
                end

                Btn.MouseButton1Click:Connect(function()
                    SliderAPI:Set(VoidFrame.Flags[flag] + 1)
                    VoidFrame:SaveConfig()
                end)

                VoidFrame.Elements[flag] = SliderAPI
            end

            -- DROPDOWN
            function SectionAPI:Dropdown(text, flag, options, default, callback)
                VoidFrame.Flags[flag] = default

                local Btn = create("TextButton", {
                    Parent = Section,
                    Size = UDim2.new(1,-8,0,26),
                    BackgroundColor3 = VoidFrame.Theme.Background,
                    BorderColor3 = VoidFrame.Theme.Border,
                    Text = text.." : "..tostring(default),
                    Font = Enum.Font.Code,
                    TextSize = 14,
                    TextColor3 = VoidFrame.Theme.Text
                })

                local index = table.find(options, default) or 1

                local DropAPI = {}
                function DropAPI:Set(v)
                    VoidFrame.Flags[flag] = v
                    Btn.Text = text.." : "..v
                    if callback then callback(v) end
                end

                Btn.MouseButton1Click:Connect(function()
                    index = index % #options + 1
                    DropAPI:Set(options[index])
                    VoidFrame:SaveConfig()
                end)

                VoidFrame.Elements[flag] = DropAPI
            end

            return SectionAPI
        end

        Page.Visible = true
        return Tab
    end

    if self.AutoLoad then
        task.delay(0.2, function()
            self:LoadConfig()
        end)
    end

    return Window
end

--// Return
return VoidFrame
