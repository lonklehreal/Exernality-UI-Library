local ExernalityUI = {}
ExernalityUI.__index = ExernalityUI

local Theme = require(script.Theme)
local Utility = require(script.Utility)
local Notification = require(script.Notification)

function ExernalityUI:CreateWindow(data)
	data = data or {}

	local notification = Notification.new(Theme, Utility)
	notification:SetupContainer()

	local Window = require(script.Window)
	local window = Window.new(Theme, Utility, notification)
	window:Create(data)

	return window
end

function ExernalityUI:SetTheme(name)
	Theme:SetTheme(name)
end

function ExernalityUI:GetTheme()
	return Theme.Current
end

function ExernalityUI:GetThemes()
	local themes = {}
	for k in pairs(Theme.Schemes) do
		table.insert(themes, k)
	end
	return themes
end

return ExernalityUI
