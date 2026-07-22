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
	return self
end

function Keybind:Create(data)
	data = data or {}
	data.Name = data.Name or "Keybind"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or Enum.KeyCode.F

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility
	self.Key = data.Default
	self.Callback = data.Callback

	local kbFrame = U:Create("Frame", {
		Name = "Keybind_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 32),
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(kbFrame)

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
		Parent = kbFrame,
	})

	local keyBtn = U:Create("TextButton", {
		Name = "Key",
		BackgroundColor3 = scheme.bg,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Default.Name,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 2,
		Size = UDim2.new(0, 60, 0, 24),
		Position = UDim2.new(1, -66, 0.5, -12),
		Parent = kbFrame,
	})

	U:CreateCorner(keyBtn)

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
				keyBtn.TextColor3 = scheme.text
				self.Listening = false
				conn:Disconnect()
			end
		end)
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed or self.Listening then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Key then
			self.Callback(self.Key)
		end
	end)

	self.Frame = kbFrame
	self.NameLabel = nameLabel
	self.KeyBtn = keyBtn

	return self
end

return Keybind
