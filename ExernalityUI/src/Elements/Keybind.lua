local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")

function Keybind.new(theme, utility, section)
	local self = setmetatable({}, Keybind)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Key = Enum.KeyCode.F
	self.Callback = nil
	self.Listening = false
	self.OnKeyDown = nil
	return self
end

function Keybind:Create(data)
	data = data or {}
	data.Name = data.Name or "Keybind"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or Enum.KeyCode.F
	data.UseMouse = data.UseMouse or false
	data.MouseButton = data.MouseButton or Enum.UserInputType.MouseButton1

	local scheme = self.Theme:GetScheme()
	self.Key = data.Default
	self.Callback = data.Callback

	local keybindFrame = Instance.new("Frame")
	keybindFrame.Name = "Keybind_" .. data.Name
	keybindFrame.BackgroundColor3 = scheme.ElementBackground
	keybindFrame.BorderSizePixel = 0
	keybindFrame.Size = UDim2.new(1, 0, 0, 36)
	keybindFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(keybindFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name or "Keybind"
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = keybindFrame

	local keyBtn = Instance.new("TextButton")
	keyBtn.Name = "Key"
	keyBtn.BackgroundColor3 = scheme.InputBackground
	keyBtn.BorderSizePixel = 0
	keyBtn.Font = self.Theme.Font
	keyBtn.Text = self.Key.Name
	keyBtn.TextColor3 = scheme.ElementText
	keyBtn.TextSize = self.Theme.TextSize - 1
	keyBtn.Size = UDim2.new(0, 80, 0, 26)
	keyBtn.Position = UDim2.new(1, -88, 0.5, -13)
	keyBtn.Parent = keybindFrame

	self.Utility:CreateCorner(keyBtn)

	keyBtn.MouseButton1Click:Connect(function()
		self.Listening = true
		keyBtn.Text = "..."
		keyBtn.TextColor3 = scheme.Accent

		local conn
		conn = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				self.Key = input.KeyCode
				keyBtn.Text = self.Key.Name
				keyBtn.TextColor3 = scheme.ElementText
				self.Listening = false
				conn:Disconnect()
			elseif data.UseMouse and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3) then
				self.Key = input.UserInputType
				keyBtn.Text = input.UserInputType.Name
				keyBtn.TextColor3 = scheme.ElementText
				self.Listening = false
				conn:Disconnect()
			end
		end)
	end)

	self.Frame = keybindFrame
	self.NameLabel = nameLabel
	self.KeyBtn = keyBtn

	self.OnKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if not self.Listening then
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Key then
				self.Callback(self.Key)
			elseif data.UseMouse and input.UserInputType == self.Key then
				self.Callback(self.Key)
			end
		end
	end)

	return self
end

return Keybind
