local Textbox = {}
Textbox.__index = Textbox

function Textbox.new(theme, utility, section)
	local self = setmetatable({}, Textbox)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Callback = nil
	self.Focused = false
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

	local textboxFrame = Instance.new("Frame")
	textboxFrame.Name = "Textbox_" .. data.Name
	textboxFrame.BackgroundColor3 = scheme.ElementBackground
	textboxFrame.BorderSizePixel = 0
	textboxFrame.Size = UDim2.new(1, 0, 0, 36)
	textboxFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(textboxFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name or "Textbox"
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.35, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = textboxFrame

	local inputBox = Instance.new("TextBox")
	inputBox.Name = "Input"
	inputBox.BackgroundColor3 = scheme.InputBackground
	inputBox.BorderSizePixel = 0
	inputBox.Font = self.Theme.Font
	inputBox.Text = data.Default or ""
	inputBox.PlaceholderText = data.Placeholder or "Enter text..."
	inputBox.PlaceholderColor3 = scheme.PlaceholderText
	inputBox.TextColor3 = scheme.ElementText
	inputBox.TextSize = self.Theme.TextSize - 1
	inputBox.Size = UDim2.new(0.6, -20, 0, 26)
	inputBox.Position = UDim2.new(0.35, 0, 0.5, -13)
	inputBox.ClearTextOnFocus = data.ClearTextOnFocus
	inputBox.Parent = textboxFrame

	self.Utility:CreateCorner(inputBox)

	inputBox.FocusLost:Connect(function(enterPressed)
		self.Callback(inputBox.Text)
	end)

	self.Frame = textboxFrame
	self.NameLabel = nameLabel
	self.InputBox = inputBox

	return self
end

return Textbox
