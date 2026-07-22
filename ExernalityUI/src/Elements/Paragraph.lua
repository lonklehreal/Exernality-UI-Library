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
	local T = self.Theme
	local U = self.Utility

	local paraFrame = U:Create("Frame", {
		Name = "Paragraph_" .. data.Title,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(paraFrame)

	local titleLabel = U:Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Title,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -12, 0, 18),
		Position = UDim2.new(0, 6, 0, 4),
		Parent = paraFrame,
	})

	local contentLabel = U:Create("TextLabel", {
		Name = "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Content,
		TextColor3 = scheme.textDim,
		TextSize = T.TextSize - 3,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		RichText = true,
		Size = UDim2.new(1, -12, 0, 0),
		Position = UDim2.new(0, 6, 0, 24),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = paraFrame,
	})

	self.Frame = paraFrame
	self.TitleLabel = titleLabel
	self.ContentLabel = contentLabel

	return self
end

return Paragraph
