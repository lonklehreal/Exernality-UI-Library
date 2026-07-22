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

	local labelFrame = Instance.new("Frame")
	labelFrame.Name = "Label"
	labelFrame.BackgroundColor3 = scheme.ElementBackground
	labelFrame.BorderSizePixel = 0
	labelFrame.Size = UDim2.new(1, 0, 0, 28)
	labelFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(labelFrame)

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Font = self.Theme.Font
	textLabel.Text = data.Text or "Label"
	textLabel.TextColor3 = data.Color or scheme.ElementTextSecondary
	textLabel.TextSize = data.TextSize or self.Theme.TextSize - 1
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Size = UDim2.new(1, -20, 1, 0)
	textLabel.Position = UDim2.new(0, 10, 0, 0)
	textLabel.Parent = labelFrame

	self.Frame = labelFrame
	self.TextLabel = textLabel

	return self
end

return Label
