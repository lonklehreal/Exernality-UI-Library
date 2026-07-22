local Button = {}
Button.__index = Button

function Button.new(theme, utility, section)
	local self = setmetatable({}, Button)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Callback = nil
	return self
end

function Button:Create(data)
	data = data or {}
	data.Name = data.Name or "Button"
	data.Callback = data.Callback or function() end
	data.Description = data.Description or ""

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility

	local btnFrame = U:Create("Frame", {
		Name = "Button_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 32),
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(btnFrame)

	local nameLabel = U:Create("TextLabel", {
		Name = "Name",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(0.6, -4, 1, 0),
		Position = UDim2.new(0, 6, 0, 0),
		Parent = btnFrame,
	})

	local btn = U:Create("TextButton", {
		Name = "Button",
		BackgroundColor3 = scheme.Accent,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = "Activate",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = T.TextSize - 2,
		Size = UDim2.new(0, 0, 0, 24),
		Position = UDim2.new(1, -6, 0.5, -12),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = btnFrame,
	})

	U:CreateCorner(btn)

	btn.MouseButton1Click:Connect(data.Callback)
	btn.MouseEnter:Connect(function()
		U:Tween(btn, {BackgroundColor3 = scheme.AccentHover}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		U:Tween(btn, {BackgroundColor3 = scheme.Accent}, 0.15)
	end)

	self.Frame = btnFrame
	self.Button = btn
	self.NameLabel = nameLabel

	return self
end

return Button
