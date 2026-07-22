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
	data.Searchable = data.Searchable or false

	local scheme = self.Theme:GetScheme()
	self.Options = data.Options
	self.Selected = data.Default
	self.Callback = data.Callback

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = "Dropdown_" .. data.Name
	dropdownFrame.BackgroundColor3 = scheme.ElementBackground
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.Size = UDim2.new(1, 0, 0, 36)
	dropdownFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(dropdownFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name or "Dropdown"
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = dropdownFrame

	local arrow = Instance.new("ImageLabel")
	arrow.Name = "Arrow"
	arrow.BackgroundTransparency = 1
	arrow.BorderSizePixel = 0
	arrow.Size = UDim2.new(0, 12, 0, 12)
	arrow.Position = UDim2.new(1, -24, 0.5, -6)
	arrow.Image = "rbxassetid://6031094678"
	arrow.ImageColor3 = scheme.ElementTextSecondary
	arrow.Rotation = 90
	arrow.Parent = dropdownFrame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.BackgroundTransparency = 1
	valueLabel.BorderSizePixel = 0
	valueLabel.Font = self.Theme.Font
	valueLabel.Text = data.Default ~= "" and tostring(data.Default) or "Select..."
	valueLabel.TextColor3 = data.Default ~= "" and scheme.ElementText or scheme.PlaceholderText
	valueLabel.TextSize = self.Theme.TextSize - 1
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0.5, -40, 1, 0)
	valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
	valueLabel.Parent = dropdownFrame

	local dropdownBtn = Instance.new("TextButton")
	dropdownBtn.Name = "DropdownBtn"
	dropdownBtn.BackgroundTransparency = 1
	dropdownBtn.BorderSizePixel = 0
	dropdownBtn.Size = UDim2.new(1, 0, 1, 0)
	dropdownBtn.Text = ""
	dropdownBtn.Parent = dropdownFrame

	local dropdownContainer
	dropdownBtn.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		if self.Open then
			self:OpenDropdown(dropdownFrame, scheme, data)
		else
			self:CloseDropdown()
		end
	end)

	self.Frame = dropdownFrame
	self.NameLabel = nameLabel
	self.ValueLabel = valueLabel
	self.Arrow = arrow
	self.DropdownBtn = dropdownBtn

	return self
end

function Dropdown:OpenDropdown(parentFrame, scheme, data)
	if self.DropdownList then
		self:CloseDropdown()
		return
	end

	local dropdownList = Instance.new("Frame")
	dropdownList.Name = "DropdownList"
	dropdownList.BackgroundColor3 = scheme.DropdownBackground
	dropdownList.BorderSizePixel = 0
	dropdownList.Size = UDim2.new(0, parentFrame.AbsoluteSize.X, 0, 0)
	dropdownList.AutomaticSize = Enum.AutomaticSize.Y
	dropdownList.Position = UDim2.new(0, 8, 0, parentFrame.AbsoluteSize.Y + 2)
	dropdownList.ZIndex = 50
	dropdownList.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(dropdownList)
	self.Utility:CreateStroke(dropdownList, scheme.ElementBorder, 1)

	local listLayout = self.Utility:CreateListLayout(dropdownList, UDim.new(0, 0))

	local searchBox
	if data.Searchable then
		searchBox = Instance.new("TextBox")
		searchBox.Name = "Search"
		searchBox.BackgroundColor3 = scheme.InputBackground
		searchBox.BorderSizePixel = 0
		searchBox.Font = self.Theme.Font
		searchBox.Text = ""
		searchBox.PlaceholderText = "Search..."
		searchBox.PlaceholderColor3 = scheme.PlaceholderText
		searchBox.TextColor3 = scheme.ElementText
		searchBox.TextSize = self.Theme.TextSize - 1
		searchBox.Size = UDim2.new(1, -8, 0, 28)
		searchBox.Position = UDim2.new(0, 4, 0, 4)
		searchBox.Parent = dropdownList
		self.Utility:CreateCorner(searchBox)
	end

	for _, option in ipairs(self.Options) do
		local optionBtn = Instance.new("TextButton")
		optionBtn.Name = "Option_" .. tostring(option)
		optionBtn.BackgroundTransparency = 1
		optionBtn.BorderSizePixel = 0
		optionBtn.Font = self.Theme.Font
		optionBtn.Text = tostring(option)
		optionBtn.TextColor3 = scheme.ElementText
		optionBtn.TextSize = self.Theme.TextSize - 1
		optionBtn.Size = UDim2.new(1, 0, 0, 30)
		optionBtn.Parent = dropdownList

		optionBtn.MouseEnter:Connect(function()
			self.Utility:Tween(optionBtn, {BackgroundTransparency = 0.9}, 0.1)
		end)

		optionBtn.MouseLeave:Connect(function()
			self.Utility:Tween(optionBtn, {BackgroundTransparency = 1}, 0.1)
		end)

		optionBtn.MouseButton1Click:Connect(function()
			self.Selected = option
			self.ValueLabel.Text = tostring(option)
			self.ValueLabel.TextColor3 = scheme.ElementText
			self:CloseDropdown()
			self.Callback(option)
		end)
	end

	self.DropdownList = dropdownList
	self.Arrow.Rotation = 270

	self.Utility:Tween(dropdownList, {
		Size = UDim2.new(0, parentFrame.AbsoluteSize.X - 16, 0, dropdownList.AutomaticSize),
	}, 0.2)
end

function Dropdown:CloseDropdown()
	if self.DropdownList then
		self.DropdownList:Destroy()
		self.DropdownList = nil
	end
	if self.Arrow then
		self.Arrow.Rotation = 90
	end
	self.Open = false
end

return Dropdown
