local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lonklehreal/Exernality-UI-Library/main/ExernalityUI/build/ExernalityUI.lua"
))()

local Window = Library:CreateWindow({
    Name = "Exernality",
    Version = "v1.0",
    Logo = "rbxassetid://94904426200943",
})

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://76345558138451",
})

local Player = Main:CreateSection("Player")

Player:CreateButton({
    Name = "Fly",
    Callback = function() print("Fly clicked") end,
})

Player:CreateToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(s) print("NoClip:", s) end,
})

Player:CreateSlider({
    Name = "Speed",
    Default = 16,
    Min = 0,
    Max = 100,
    Callback = function(v) print("Speed:", v) end,
})

local Visuals = Main:CreateSection("Visuals")

Visuals:CreateDropdown({
    Name = "ESP",
    Options = {"Off", "Box", "Tracer"},
    Default = "Off",
    Callback = function(o) print("ESP:", o) end,
})

Visuals:CreateColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(c) print("Color:", c) end,
})

Visuals:CreateKeybind({
    Name = "Toggle",
    Default = Enum.KeyCode.RightShift,
    Callback = function(k) Window:Toggle() end,
})
