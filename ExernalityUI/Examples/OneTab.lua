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

local Section = Main:CreateSection("Test")

Section:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Clicked!")
    end,
})
