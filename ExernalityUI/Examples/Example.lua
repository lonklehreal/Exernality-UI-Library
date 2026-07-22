--[[
	ExernalityUI Example Script
	Run this script in Roblox Studio or an executor
]]

local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/YourName/ExernalityUI/main/build/ExernalityUI.lua"
))()

local Window = Library:CreateWindow({
	Name = "Exernality",
	Version = "v1.0"
})

Window:Notify({
	Title = "Welcome",
	Content = "ExernalityUI loaded successfully!",
	Duration = 3
})

-- Client Tab
local Client = Window:CreateTab({
	Name = "Client",
	Icon = "rbxassetid://72206152389196"
})

local Player = Client:CreateSection("Player")

Player:CreateButton({
	Name = "Fly",
	Description = "Toggle flight mode",
	Callback = function()
		print("Fly toggled")
	end
})

Player:CreateToggle({
	Name = "NoClip",
	Description = "Walk through walls",
	Default = false,
	Callback = function(state)
		print("NoClip:", state)
	end
})

Player:CreateSlider({
	Name = "Speed",
	Description = "Walkspeed multiplier",
	Default = 16,
	Min = 0,
	Max = 100,
	Suffix = "x",
	Decimal = 1,
	Callback = function(value)
		print("Speed set to:", value)
	end
})

local Visuals = Client:CreateSection("Visuals")

Visuals:CreateDropdown({
	Name = "ESP",
	Options = {"Off", "Box", "Tracer", "Name"},
	Default = "Off",
	Callback = function(option)
		print("ESP:", option)
	end
})

Visuals:CreateColorPicker({
	Name = "ESP Color",
	Default = Color3.fromRGB(255, 50, 50),
	Callback = function(color)
		print("ESP Color:", color)
	end
})

Visuals:CreateKeybind({
	Name = "Menu Toggle",
	Default = Enum.KeyCode.RightShift,
	Callback = function(key)
		Window:Toggle()
	end
})

Visuals:CreateSlider({
	Name = "FOV",
	Default = 90,
	Min = 30,
	Max = 120,
	Suffix = "",
	Decimal = 0,
	Callback = function(value)
		print("FOV:", value)
	end
})

-- Settings Tab
local Settings = Window:CreateTab({
	Name = "Settings",
	Icon = "rbxassetid://6031094678"
})

local Info = Settings:CreateSection("Information")

Info:CreateParagraph({
	Title = "About",
	Content = "ExernalityUI v1.0\nA modern Roblox UI library inspired by Rayfield.\n\nBuilt with Lua and Roblox UI components."
})

Info:CreateLabel({
	Text = "You can use <b>RichText</b> in labels and paragraphs!",
	Color = Color3.fromRGB(150, 200, 255)
})

local Configuration = Settings:CreateSection("Configuration")

Configuration:CreateToggle({
	Name = "Auto-Execute",
	Default = true,
	Callback = function(state)
		print("Auto-Execute:", state)
	end
})

Configuration:CreateTextbox({
	Name = "Prefix",
	Default = ";",
	Placeholder = "Enter command prefix...",
	ClearTextOnFocus = true,
	Callback = function(text)
		print("Prefix set to:", text)
	end
})

Configuration:CreateDropdown({
	Name = "Theme",
	Options = Library:GetThemes(),
	Default = Library:GetTheme(),
	Callback = function(option)
		Library:SetTheme(option)
		print("Theme changed to:", option)
	end
})
