local Tab = {}
Tab.__index = Tab

local tabButtonData = {
	{ strokePosition = Enum.BorderStrokePosition.Inner },
	{ strokePosition = Enum.BorderStrokePosition.Outer },
	{ strokePosition = Enum.BorderStrokePosition.Inner },
	{ strokePosition = Enum.BorderStrokePosition.Outer },
	{ strokePosition = Enum.BorderStrokePosition.Inner },
	{ strokePosition = Enum.BorderStrokePosition.Outer },
	{ strokePosition = Enum.BorderStrokePosition.Inner },
	{ strokePosition = Enum.BorderStrokePosition.Outer },
}

local tabIndex = 0

function Tab.new(theme, utility, window)
	local self = setmetatable({}, Tab)
	self.Theme = theme
	self.Utility = utility
	self.Window = window
	self.Sections = {}
	self.Active = false
	self.Button = nil
	self.Container = nil
	self.Index = tabIndex + 1
	tabIndex = self.Index
	return self
end

function Tab:Create(data)
	data = data or {}
	data.Name = data.Name or "Tab"
	data.Icon = data.Icon or ""

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility

	local btnData = tabButtonData[(self.Index - 1) % #tabButtonData + 1]

	local btn = U:Create("Frame", {
		Name = data.Name,
		Position = UDim2.new(0, 0, 0, (self.Index - 1) * 39),
		Size = UDim2.new(0, T.SidebarWidth, 0, 39),
		BackgroundColor3 = scheme.bg,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 1,
		Parent = self.Window.TabButtons,
	})

	U:CreateStroke(btn, scheme.stroke, 1, btnData.strokePosition)

	local icon = U:Create("ImageLabel", {
		Name = "ImageLabel",
		Position = UDim2.new(0.0738255009, 0, 0.179487184, 0),
		Size = UDim2.new(0, 25, 0, 25),
		BackgroundColor3 = scheme.bg,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Image = data.Icon,
		ImageColor3 = scheme.text,
		ImageTransparency = 0,
		ScaleType = Enum.ScaleType.Stretch,
		ZIndex = 1,
		Parent = btn,
	})

	local nameLabel = U:Create("TextLabel", {
		Name = "Exernality",
		Position = UDim2.new(0.341167688, 0, -0.00197660015, 0),
		Size = UDim2.new(0, 97, 0, 39),
		BackgroundColor3 = scheme.bg,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextTransparency = 0,
		TextSize = T.TextSizeTitle,
		FontFace = T.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		RichText = false,
		ZIndex = 1,
		Parent = btn,
	})

	-- Tab content container
	local tabFrame = U:Create("Frame", {
		Name = data.Name,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, T.ContentWidth, 0, T.ContentHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Visible = false,
		ZIndex = 1,
		Parent = self.Window.TabsFrame,
	})

	-- Click handling
	local inputObj = Instance.new("TextButton")
	inputObj.Name = "Input"
	inputObj.BackgroundTransparency = 1
	inputObj.BorderSizePixel = 0
	inputObj.Size = UDim2.new(1, 0, 1, 0)
	inputObj.Text = ""
	inputObj.Parent = btn

	inputObj.MouseButton1Click:Connect(function()
		self.Window:SelectTab(self)
	end)

	self.Button = btn
	self.Icon = icon
	self.NameLabel = nameLabel
	self.Container = tabFrame
	self.InputObj = inputObj

	return self
end

function Tab:SetActive(active)
	self.Active = active
	if self.Container then
		self.Container.Visible = active
	end
	if self.Icon then
		self.Icon.ImageColor3 = active and self.Theme:GetScheme().text or self.Theme:GetScheme().textDim
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
