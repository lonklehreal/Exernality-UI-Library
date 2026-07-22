local Label = {}
Label.__index = Label

function Label.new(theme, utility, section)
	local self = setmetatable({}, Label)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	return self
end

function Label:Create(data)
	data = data or {}
	data.Text = data.Text or "Label"
	data.Color = data.Color or nil
	data.TextSize = data.TextSize or nil

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility

	local labelFrame = U:Create("Frame", {
		Name = "Label",
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 24),
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(labelFrame)

	local textLabel = U:Create("TextLabel", {
		Name = "Text",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Text,
		TextColor3 = data.Color or scheme.textDim,
		TextSize = data.TextSize or T.TextSize - 2,
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = true,
		Size = UDim2.new(1, -12, 1, 0),
		Position = UDim2.new(0, 6, 0, 0),
		Parent = labelFrame,
	})

	self.Frame = labelFrame
	self.TextLabel = textLabel

	return self
end

return Label
