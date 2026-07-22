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

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "Button_" .. data.Name
	buttonFrame.BackgroundColor3 = scheme.ElementBackground
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Size = UDim2.new(1, 0, 0, 36)
	buttonFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(buttonFrame)

	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.BackgroundColor3 = scheme.Accent
	button.BorderSizePixel = 0
	button.Font = self.Theme.Font
	button.Text = data.Name or "Button"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = self.Theme.TextSize
	button.Size = UDim2.new(0, 0, 0, 28)
	button.Position = UDim2.new(1, -8, 0.5, -14)
	button.AutomaticSize = Enum.AutomaticSize.X
	button.Parent = buttonFrame

	self.Utility:CreateCorner(button)
	self.Utility:CreateStroke(button, scheme.AccentDim, 1)

	local descriptionLabel
	if data.Description and data.Description ~= "" then
		descriptionLabel = Instance.new("TextLabel")
		descriptionLabel.Name = "Description"
		descriptionLabel.BackgroundTransparency = 1
		descriptionLabel.BorderSizePixel = 0
		descriptionLabel.Font = self.Theme.Font
		descriptionLabel.Text = data.Description
		descriptionLabel.TextColor3 = scheme.ElementTextSecondary
		descriptionLabel.TextSize = self.Theme.TextSize - 2
		descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
		descriptionLabel.TextWrapped = true
		descriptionLabel.Size = UDim2.new(1, -140, 0, 0)
		descriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
		descriptionLabel.Position = UDim2.new(0, 0, 0, 0)
		descriptionLabel.Parent = buttonFrame
	end

	button.MouseButton1Click:Connect(function()
		data.Callback()
	end)

	button.MouseEnter:Connect(function()
		self.Utility:Tween(button, {BackgroundColor3 = scheme.AccentHover}, 0.15)
	end)

	button.MouseLeave:Connect(function()
		self.Utility:Tween(button, {BackgroundColor3 = scheme.Accent}, 0.15)
	end)

	self.Frame = buttonFrame
	self.Button = button
	self.DescriptionLabel = descriptionLabel

	return self
end

return Button
