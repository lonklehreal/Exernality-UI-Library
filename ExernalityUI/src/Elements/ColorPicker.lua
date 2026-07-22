local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(theme, utility, section)
	local self = setmetatable({}, ColorPicker)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Value = Color3.fromRGB(255, 255, 255)
	self.Callback = nil
	self.Open = false
	return self
end

function ColorPicker:Create(data)
	data = data or {}
	data.Name = data.Name or "ColorPicker"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or Color3.fromRGB(255, 255, 255)

	local scheme = self.Theme:GetScheme()
	self.Value = data.Default
	self.Callback = data.Callback

	local cpFrame = Instance.new("Frame")
	cpFrame.Name = "ColorPicker_" .. data.Name
	cpFrame.BackgroundColor3 = scheme.ElementBackground
	cpFrame.BorderSizePixel = 0
	cpFrame.Size = UDim2.new(1, 0, 0, 36)
	cpFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(cpFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name or "ColorPicker"
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = cpFrame

	local colorPreview = Instance.new("Frame")
	colorPreview.Name = "Preview"
	colorPreview.BackgroundColor3 = data.Default
	colorPreview.BorderSizePixel = 0
	colorPreview.Size = UDim2.new(0, 28, 0, 28)
	colorPreview.Position = UDim2.new(1, -36, 0.5, -14)
	colorPreview.Parent = cpFrame

	self.Utility:CreateCorner(colorPreview, UDim.new(0, 4))
	self.Utility:CreateStroke(colorPreview, scheme.ElementBorder, 1)

	local colorBtn = Instance.new("TextButton")
	colorBtn.Name = "ColorBtn"
	colorBtn.BackgroundTransparency = 1
	colorBtn.BorderSizePixel = 0
	colorBtn.Size = UDim2.new(1, 0, 1, 0)
	colorBtn.Text = ""
	colorBtn.Parent = cpFrame

	local pickerContainer

	colorBtn.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		if self.Open then
			pickerContainer = self:CreatePicker(cpFrame, scheme)
		elseif pickerContainer then
			pickerContainer:Destroy()
			pickerContainer = nil
		end
	end)

	self.Frame = cpFrame
	self.NameLabel = nameLabel
	self.ColorPreview = colorPreview
	self.ColorBtn = colorBtn

	return self
end

function ColorPicker:CreatePicker(parentFrame, scheme)
	local container = Instance.new("Frame")
	container.Name = "PickerContainer"
	container.BackgroundColor3 = scheme.DropdownBackground
	container.BorderSizePixel = 0
	container.Size = UDim2.new(0, 200, 0, 160)
	container.Position = UDim2.new(0, 0, 0, parentFrame.AbsoluteSize.Y + 2)
	container.ZIndex = 50
	container.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(container)
	self.Utility:CreateStroke(container, scheme.ElementBorder, 1)

	local colorSaturation = Instance.new("ImageLabel")
	colorSaturation.Name = "Saturation"
	colorSaturation.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	colorSaturation.BorderSizePixel = 0
	colorSaturation.Size = UDim2.new(1, -20, 1, -50)
	colorSaturation.Position = UDim2.new(0, 10, 0, 10)
	colorSaturation.Image = "rbxassetid://4155801252"
	colorSaturation.ImageColor3 = Color3.fromRGB(255, 255, 255)
	colorSaturation.Parent = container

	self.Utility:CreateCorner(colorSaturation)

	local hueSlider = Instance.new("Frame")
	hueSlider.Name = "HueSlider"
	hueSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	hueSlider.BorderSizePixel = 0
	hueSlider.Size = UDim2.new(1, -20, 0, 16)
	hueSlider.Position = UDim2.new(0, 10, 0, container.AbsoluteSize.Y - 40)
	hueSlider.Parent = container

	local hueGradient = Instance.new("UIGradient")
	hueGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
	})
	hueGradient.Parent = hueSlider

	return container
end

return ColorPicker
