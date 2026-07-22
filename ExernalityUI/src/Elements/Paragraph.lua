local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(theme, utility, section)
	local self = setmetatable({}, Paragraph)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	return self
end

function Paragraph:Create(data)
	data = data or {}
	data.Title = data.Title or "Paragraph"
	data.Content = data.Content or ""

	local scheme = self.Theme:GetScheme()

	local paraFrame = Instance.new("Frame")
	paraFrame.Name = "Paragraph_" .. data.Title
	paraFrame.BackgroundColor3 = scheme.ElementBackground
	paraFrame.BorderSizePixel = 0
	paraFrame.Size = UDim2.new(1, 0, 0, 0)
	paraFrame.AutomaticSize = Enum.AutomaticSize.Y
	paraFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(paraFrame)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = self.Theme.Font
	titleLabel.Text = data.Title or "Paragraph"
	titleLabel.TextColor3 = scheme.ElementText
	titleLabel.TextSize = self.Theme.TextSize
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.Parent = paraFrame

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Name = "Content"
	contentLabel.BackgroundTransparency = 1
	contentLabel.BorderSizePixel = 0
	contentLabel.Font = self.Theme.Font
	contentLabel.Text = data.Content or ""
	contentLabel.TextColor3 = scheme.ElementTextSecondary
	contentLabel.TextSize = self.Theme.TextSize - 2
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.RichText = true
	contentLabel.Size = UDim2.new(1, -20, 0, 0)
	contentLabel.Position = UDim2.new(0, 10, 0, 30)
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Parent = paraFrame

	self.Frame = paraFrame
	self.TitleLabel = titleLabel
	self.ContentLabel = contentLabel

	return self
end

return Paragraph
