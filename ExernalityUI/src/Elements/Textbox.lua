local Textbox = {}
Textbox.__index = Textbox

function Textbox.new(theme, utility, section)
	local self = setmetatable({}, Textbox)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Callback = nil
	return self
end

function Textbox:Create(data)
	data = data or {}
	data.Name = data.Name or "Textbox"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or ""
	data.Placeholder = data.Placeholder or "Enter text..."
	data.ClearTextOnFocus = data.ClearTextOnFocus or false

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility

	local tbFrame = U:Create("Frame", {
		Name = "Textbox_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 32),
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(tbFrame)

	local nameLabel = U:Create("TextLabel", {
		Name = "Name",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 2,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(0.35, -4, 1, 0),
		Position = UDim2.new(0, 6, 0, 0),
		Parent = tbFrame,
	})

	local inputBox = U:Create("TextBox", {
		Name = "Input",
		BackgroundColor3 = scheme.bg,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Default,
		PlaceholderText = data.Placeholder,
		PlaceholderColor3 = scheme.PlaceholderText,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 2,
		Size = UDim2.new(0.6, -8, 0, 24),
		Position = UDim2.new(0.35, 0, 0.5, -12),
		ClearTextOnFocus = data.ClearTextOnFocus,
		Parent = tbFrame,
	})

	U:CreateCorner(inputBox)

	inputBox.FocusLost:Connect(function()
		data.Callback(inputBox.Text)
	end)

	self.Frame = tbFrame
	self.NameLabel = nameLabel
	self.InputBox = inputBox

	return self
end

return Textbox
