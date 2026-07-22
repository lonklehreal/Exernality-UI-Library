local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(theme, utility, section)
	local self = setmetatable({}, Toggle)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Value = false
	self.Callback = nil
	return self
end

function Toggle:Create(data)
	data = data or {}
	data.Name = data.Name or "Toggle"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or false

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility
	self.Value = data.Default

	local toggleFrame = U:Create("Frame", {
		Name = "Toggle_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 32),
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(toggleFrame)

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
		Parent = toggleFrame,
	})

	local toggleBg = U:Create("Frame", {
		Name = "ToggleBg",
		BackgroundColor3 = scheme.stroke,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 36, 0, 18),
		Position = UDim2.new(1, -42, 0.5, -9),
		Parent = toggleFrame,
	})

	U:CreateCorner(toggleBg, UDim.new(0, 9))

	local toggleCircle = U:Create("Frame", {
		Name = "Circle",
		BackgroundColor3 = scheme.textDim,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 2, 0.5, -7),
		Parent = toggleBg,
	})

	U:CreateCorner(toggleCircle, UDim.new(0, 7))

	local inputObj = Instance.new("TextButton")
	inputObj.Name = "Input"
	inputObj.BackgroundTransparency = 1
	inputObj.BorderSizePixel = 0
	inputObj.Size = UDim2.new(1, 0, 1, 0)
	inputObj.Text = ""
	inputObj.Parent = toggleFrame

	inputObj.MouseButton1Click:Connect(function()
		self.Value = not self.Value
		self:UpdateVisuals()
		data.Callback(self.Value)
	end)

	self.Frame = toggleFrame
	self.ToggleBg = toggleBg
	self.ToggleCircle = toggleCircle
	self.NameLabel = nameLabel
	self.InputObj = inputObj

	self:UpdateVisuals()

	return self
end

function Toggle:UpdateVisuals()
	local scheme = self.Theme:GetScheme()
	if self.Value then
		self.Utility:Tween(self.ToggleBg, {BackgroundColor3 = scheme.Accent}, 0.15)
		self.Utility:Tween(self.ToggleCircle, {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Position = UDim2.new(0, 20, 0.5, -7)
		}, 0.15)
	else
		self.Utility:Tween(self.ToggleBg, {BackgroundColor3 = scheme.stroke}, 0.15)
		self.Utility:Tween(self.ToggleCircle, {
			BackgroundColor3 = scheme.textDim,
			Position = UDim2.new(0, 2, 0.5, -7)
		}, 0.15)
	end
end

return Toggle
