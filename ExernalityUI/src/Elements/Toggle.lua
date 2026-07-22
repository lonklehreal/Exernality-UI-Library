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
	data.Description = data.Description or ""

	local scheme = self.Theme:GetScheme()
	self.Value = data.Default
	self.Callback = data.Callback

	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = "Toggle_" .. data.Name
	toggleFrame.BackgroundColor3 = scheme.ElementBackground
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Size = UDim2.new(1, 0, 0, 36)
	toggleFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(toggleFrame)

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "Toggle"
	toggleBtn.BackgroundTransparency = 1
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Size = UDim2.new(1, 0, 1, 0)
	toggleBtn.Text = ""
	toggleBtn.Parent = toggleFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name or "Toggle"
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(1, -60, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = toggleFrame

	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "Indicator"
	toggleIndicator.BackgroundColor3 = scheme.ElementBackground
	toggleIndicator.BorderSizePixel = 0
	toggleIndicator.Size = UDim2.new(0, 44, 0, 22)
	toggleIndicator.Position = UDim2.new(1, -52, 0.5, -11)
	toggleIndicator.Parent = toggleFrame

	self.Utility:CreateCorner(toggleIndicator, UDim.new(0, 11))

	local toggleCircle = Instance.new("Frame")
	toggleCircle.Name = "Circle"
	toggleCircle.BackgroundColor3 = scheme.ElementTextSecondary
	toggleCircle.BorderSizePixel = 0
	toggleCircle.Size = UDim2.new(0, 18, 0, 18)
	toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
	toggleCircle.Parent = toggleIndicator

	self.Utility:CreateCorner(toggleCircle, UDim.new(0, 9))

	toggleBtn.MouseButton1Click:Connect(function()
		self.Value = not self.Value
		self:UpdateVisuals()
		self.Callback(self.Value)
	end)

	self.Frame = toggleFrame
	self.ToggleBtn = toggleBtn
	self.ToggleIndicator = toggleIndicator
	self.ToggleCircle = toggleCircle
	self.NameLabel = nameLabel

	self:UpdateVisuals()

	return self
end

function Toggle:UpdateVisuals()
	local scheme = self.Theme:GetScheme()
	if self.Value then
		self.Utility:Tween(self.ToggleIndicator, {BackgroundColor3 = scheme.Accent}, 0.15)
		self.Utility:Tween(self.ToggleCircle, {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Position = UDim2.new(0, 24, 0.5, -9)
		}, 0.15)
	else
		self.Utility:Tween(self.ToggleIndicator, {BackgroundColor3 = scheme.ElementBackground}, 0.15)
		self.Utility:Tween(self.ToggleCircle, {
			BackgroundColor3 = scheme.ElementTextSecondary,
			Position = UDim2.new(0, 2, 0.5, -9)
		}, 0.15)
	end
end

return Toggle
