local Tab = {}
Tab.__index = Tab

local TweenService = game:GetService("TweenService")

function Tab.new(theme, utility, window)
	local self = setmetatable({}, Tab)
	self.Theme = theme
	self.Utility = utility
	self.Window = window
	self.Sections = {}
	self.Active = false
	self.Button = nil
	self.Container = nil
	return self
end

function Tab:Create(data)
	data = data or {}
	data.Name = data.Name or "Tab"
	data.Icon = data.Icon or ""

	local scheme = self.Theme:GetScheme()

	local tabButton = Instance.new("ImageButton")
	tabButton.Name = "Tab_" .. data.Name
	tabButton.BackgroundColor3 = scheme.TabBackground
	tabButton.BackgroundTransparency = 1
	tabButton.BorderSizePixel = 0
	tabButton.Size = UDim2.new(1, -8, 0, 36)
	tabButton.Parent = self.Window.TabList

	local tabButtonCorner = Instance.new("UICorner")
	tabButtonCorner.CornerRadius = UDim.new(0, 4)
	tabButtonCorner.Parent = tabButton

	local iconLabel
	if data.Icon and data.Icon ~= "" then
		iconLabel = Instance.new("ImageLabel")
		iconLabel.Name = "Icon"
		iconLabel.BackgroundTransparency = 1
		iconLabel.BorderSizePixel = 0
		iconLabel.Size = UDim2.new(0, 20, 0, 20)
		iconLabel.Position = UDim2.new(0, 10, 0.5, -10)
		iconLabel.Image = data.Icon
		iconLabel.ImageColor3 = self.Theme:GetScheme().TabText
		iconLabel.Parent = tabButton
	end

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = self.Theme:GetScheme().TabText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(1, -40, 1, 0)
	nameLabel.Position = UDim2.new(0, 40, 0, 0)
	nameLabel.Parent = tabButton

	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.BackgroundColor3 = self.Theme:GetScheme().TabIndicator
	indicator.BorderSizePixel = 0
	indicator.Size = UDim2.new(0, 3, 0, 0)
	indicator.Position = UDim2.new(0, 0, 0.5, 0)
	indicator.Visible = false
	indicator.Parent = tabButton

	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0, 2)
	indicatorCorner.Parent = indicator

	tabButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Window:SelectTab(self)
		end
	end)

	tabButton.MouseEnter:Connect(function()
		if not self.Active then
			self.Utility:Tween(tabButton, {BackgroundTransparency = 0.9}, 0.15)
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if not self.Active then
			self.Utility:Tween(tabButton, {BackgroundTransparency = 1}, 0.15)
		end
	end)

	self.Button = tabButton
	self.IconLabel = iconLabel
	self.NameLabel = nameLabel
	self.Indicator = indicator

	return self
end

function Tab:SetActive(active)
	self.Active = active
	if active then
		self.Container.Visible = true
		self.Indicator.Visible = true
		self.Utility:Tween(self.Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.2)
		self.Utility:Tween(self.Button, {BackgroundTransparency = 0.85}, 0.2)
		self.NameLabel.TextColor3 = self.Theme:GetScheme().TabTextActive
		if self.IconLabel then
			self.IconLabel.ImageColor3 = self.Theme:GetScheme().TabTextActive
		end
	else
		self.Container.Visible = false
		self.Indicator.Visible = false
		self.Utility:Tween(self.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
		self.Utility:Tween(self.Button, {BackgroundTransparency = 1}, 0.2)
		self.NameLabel.TextColor3 = self.Theme:GetScheme().TabText
		if self.IconLabel then
			self.IconLabel.ImageColor3 = self.Theme:GetScheme().TabText
		end
	end
end

function Tab:CreateSection(data)
	data = data or {}
	data.Name = data.Name or "Section"

	local Section = require(script.Parent.Section)
	local section = Section.new(self.Theme, self.Utility, self)
	section:Create(data)
	table.insert(self.Sections, section)
	return section
end

return Tab
