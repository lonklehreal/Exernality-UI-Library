local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lonklehreal/Exernality-UI-Library/main/ExernalityUI/build/ExernalityUI.lua"
))()

local Window = Library:CreateWindow({
    Name = "Exernality",
    Version = "v1.0",
})

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://76345558138451",
})

local Player = Main:CreateSection("Player")

Player:CreateSlider({
    Name = "Walkspeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Suffix = "",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})

Player:CreateSlider({
    Name = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 500,
    Suffix = "",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
})

local Settings = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://100754279686102",
})

local Misc = Settings:CreateSection("Misc")

Misc:CreateButton({
    Name = "Reset Speed",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
            char.Humanoid.JumpPower = 50
        end
    end,
})
