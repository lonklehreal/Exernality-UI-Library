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
	local T = self.Theme
	local U = self.Utility
	self.Value = data.Default
	self.Callback = data.Callback

	local cpBtn = U:Create("TextButton", {
		Name = "ColorPicker_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 32),
		FontFace = Enum.Font.SourceSans,
		Text = "",
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(cpBtn)

	local nameLabel = U:Create("TextLabel", {
		Name = "Name",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 2,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(0.5, -4, 1, 0),
		Position = UDim2.new(0, 6, 0, 0),
		Parent = cpBtn,
	})

	local colorPreview = U:Create("Frame", {
		Name = "Preview",
		BackgroundColor3 = data.Default,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(1, -28, 0.5, -11),
		Parent = cpBtn,
	})

	U:CreateCorner(colorPreview, UDim.new(0, 4))
	U:CreateStroke(colorPreview, scheme.stroke, 1)

	local pickerContainer

	cpBtn.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		if self.Open then
			pickerContainer = U:Create("Frame", {
				Name = "PickerContainer",
				BackgroundColor3 = scheme.DropdownBg,
				BorderSizePixel = 0,
				Size = UDim2.new(0, cpBtn.AbsoluteSize.X, 0, 140),
				Position = UDim2.new(0, 0, 0, cpBtn.AbsoluteSize.Y + 1),
				ZIndex = 50,
				Parent = self.Section.ElementContainer,
			})

			U:CreateCorner(pickerContainer)
			U:CreateStroke(pickerContainer, scheme.stroke, 1)

			local satImg = U:Create("ImageLabel", {
				Name = "Saturation",
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.new(1, -16, 1, -50),
				Position = UDim2.new(0, 8, 0, 8),
				Image = "rbxassetid://4155801252",
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Parent = pickerContainer,
			})

			U:CreateCorner(satImg)

			local hueBar = U:Create("Frame", {
				Name = "Hue",
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.new(1, -16, 0, 14),
				Position = UDim2.new(0, 8, 0, pickerContainer.AbsoluteSize.Y - 22),
				Parent = pickerContainer,
			})

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
			hueGradient.Parent = hueBar
		elseif pickerContainer then
			pickerContainer:Destroy()
			pickerContainer = nil
		end
	end)

	self.Frame = cpBtn
	self.NameLabel = nameLabel
	self.ColorPreview = colorPreview

	return self
end

return ColorPicker
