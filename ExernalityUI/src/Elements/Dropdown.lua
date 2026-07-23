local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(theme, utility, section)
	local self = setmetatable({}, Dropdown)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Open = false
	self.Selected = nil
	self.Options = {}
	self.Callback = nil
	self.DropdownList = nil
	return self
end

function Dropdown:Create(data)
	data = data or {}
	data.Name = data.Name or "Dropdown"
	data.Callback = data.Callback or function() end
	data.Options = data.Options or {}
	data.Default = data.Default or ""

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility
	self.Options = data.Options
	self.Selected = data.Default
	self.Callback = data.Callback

	local dropBtn = U:Create("TextButton", {
		Name = "Dropdown_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 32),
		FontFace = Enum.Font.SourceSans,
		Text = "",
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(dropBtn)

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
		Parent = dropBtn,
	})

	local valueLabel = U:Create("TextLabel", {
		Name = "Value",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Default ~= "" and tostring(data.Default) or "Select...",
		TextColor3 = data.Default ~= "" and scheme.text or scheme.PlaceholderText,
		TextSize = T.TextSize - 2,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(0.5, -10, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Parent = dropBtn,
	})

	dropBtn.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		if self.Open then
			self:OpenDropdown(dropBtn, scheme, data)
		else
			self:CloseDropdown()
		end
	end)

	self.Frame = dropBtn
	self.NameLabel = nameLabel
	self.ValueLabel = valueLabel

	return self
end

function Dropdown:OpenDropdown(parentFrame, scheme, data)
	if self.DropdownList then self:CloseDropdown() return end

	local listFrame = self.Utility:Create("Frame", {
		Name = "DropdownList",
		BackgroundColor3 = scheme.DropdownBg,
		BorderSizePixel = 0,
		Size = UDim2.new(0, parentFrame.AbsoluteSize.X, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, parentFrame.AbsoluteSize.Y + 1),
		ZIndex = 50,
		Parent = self.Section.ElementContainer,
	})

	self.Utility:CreateCorner(listFrame)
	self.Utility:CreateStroke(listFrame, scheme.stroke, 1)

	local layout = self.Utility:CreateListLayout(listFrame, UDim.new(0, 0))

	for _, option in ipairs(self.Options) do
		local optBtn = self.Utility:Create("TextButton", {
			BackgroundTransparency = 0.8,
			BorderSizePixel = 0,
			FontFace = self.Theme.Font,
			Text = tostring(option),
			TextColor3 = scheme.text,
			TextSize = self.Theme.TextSize - 2,
			Size = UDim2.new(1, 0, 0, 26),
			Parent = listFrame,
		})

		optBtn.MouseEnter:Connect(function()
			self.Utility:Tween(optBtn, {BackgroundTransparency = 0.6}, 0.1)
		end)

		optBtn.MouseLeave:Connect(function()
			self.Utility:Tween(optBtn, {BackgroundTransparency = 0.8}, 0.1)
		end)

		optBtn.MouseButton1Click:Connect(function()
			self.Selected = option
			self.ValueLabel.Text = tostring(option)
			self.ValueLabel.TextColor3 = scheme.text
			self:CloseDropdown()
			data.Callback(option)
		end)
	end

	self.DropdownList = listFrame
end

function Dropdown:CloseDropdown()
	if self.DropdownList then
		self.DropdownList:Destroy()
		self.DropdownList = nil
	end
	self.Open = false
end

return Dropdown
