--[[
	ExernalityUI v1.0
	A modern Roblox UI library
	https://github.com/YourName/ExernalityUI
]]

local ExernalityUI = {}
ExernalityUI.__index = ExernalityUI

-- Theme Module
local Theme = {
	Current = "Dark",
	Font = Enum.Font.GothamSemibold,
	TextSize = 14,
	CornerRadius = UDim.new(0, 6),
	Padding = UDim.new(0, 4),
	ElementPadding = UDim.new(0, 6),
	ScrollBarThickness = 4,
	NotificationDuration = 5,
	NotificationMax = 5,
	Schemes = {
		Dark = {
			Background = Color3.fromRGB(25, 25, 25),
			Topbar = Color3.fromRGB(30, 30, 30),
			TopbarText = Color3.fromRGB(240, 240, 240),
			TabBackground = Color3.fromRGB(20, 20, 20),
			TabText = Color3.fromRGB(160, 160, 160),
			TabTextActive = Color3.fromRGB(255, 255, 255),
			TabIndicator = Color3.fromRGB(100, 100, 255),
			SectionBackground = Color3.fromRGB(30, 30, 30),
			SectionTitle = Color3.fromRGB(200, 200, 200),
			ElementBackground = Color3.fromRGB(40, 40, 40),
			ElementBackgroundHover = Color3.fromRGB(50, 50, 50),
			ElementText = Color3.fromRGB(220, 220, 220),
			ElementTextSecondary = Color3.fromRGB(160, 160, 160),
			ElementBorder = Color3.fromRGB(50, 50, 50),
			Accent = Color3.fromRGB(100, 100, 255),
			AccentHover = Color3.fromRGB(120, 120, 255),
			AccentDim = Color3.fromRGB(60, 60, 180),
			Success = Color3.fromRGB(80, 200, 80),
			Danger = Color3.fromRGB(220, 60, 60),
			Warning = Color3.fromRGB(240, 180, 40),
			NotificationBackground = Color3.fromRGB(35, 35, 35),
			NotificationBorder = Color3.fromRGB(50, 50, 50),
			InputBackground = Color3.fromRGB(25, 25, 25),
			PlaceholderText = Color3.fromRGB(120, 120, 120),
			DropdownBackground = Color3.fromRGB(35, 35, 35),
			DropdownHover = Color3.fromRGB(50, 50, 50),
			ScrollBarBackground = Color3.fromRGB(40, 40, 40),
			ScrollBarHandle = Color3.fromRGB(80, 80, 80),
			Shadow = Color3.fromRGB(0, 0, 0),
			Overlay = Color3.fromRGB(0, 0, 0),
			Transparency = {
				Window = 0, Topbar = 0, Section = 0, Element = 0,
				Dropdown = 0.05, Overlay = 0.6, Shadow = 0.7,
			},
		},
		Light = {
			Background = Color3.fromRGB(235, 235, 235),
			Topbar = Color3.fromRGB(225, 225, 225),
			TopbarText = Color3.fromRGB(30, 30, 30),
			TabBackground = Color3.fromRGB(220, 220, 220),
			TabText = Color3.fromRGB(100, 100, 100),
			TabTextActive = Color3.fromRGB(20, 20, 20),
			TabIndicator = Color3.fromRGB(100, 100, 255),
			SectionBackground = Color3.fromRGB(240, 240, 240),
			SectionTitle = Color3.fromRGB(50, 50, 50),
			ElementBackground = Color3.fromRGB(230, 230, 230),
			ElementBackgroundHover = Color3.fromRGB(220, 220, 220),
			ElementText = Color3.fromRGB(30, 30, 30),
			ElementTextSecondary = Color3.fromRGB(100, 100, 100),
			ElementBorder = Color3.fromRGB(210, 210, 210),
			Accent = Color3.fromRGB(100, 100, 255),
			AccentHover = Color3.fromRGB(120, 120, 255),
			AccentDim = Color3.fromRGB(60, 60, 180),
			Success = Color3.fromRGB(60, 180, 60),
			Danger = Color3.fromRGB(200, 50, 50),
			Warning = Color3.fromRGB(220, 160, 30),
			NotificationBackground = Color3.fromRGB(230, 230, 230),
			NotificationBorder = Color3.fromRGB(210, 210, 210),
			InputBackground = Color3.fromRGB(215, 215, 215),
			PlaceholderText = Color3.fromRGB(140, 140, 140),
			DropdownBackground = Color3.fromRGB(220, 220, 220),
			DropdownHover = Color3.fromRGB(210, 210, 210),
			ScrollBarBackground = Color3.fromRGB(210, 210, 210),
			ScrollBarHandle = Color3.fromRGB(180, 180, 180),
			Shadow = Color3.fromRGB(0, 0, 0),
			Overlay = Color3.fromRGB(0, 0, 0),
			Transparency = {
				Window = 0, Topbar = 0, Section = 0, Element = 0,
				Dropdown = 0.05, Overlay = 0.4, Shadow = 0.5,
			},
		},
	},
}

function Theme:GetScheme()
	return self.Schemes[self.Current]
end

function Theme:SetTheme(name)
	if self.Schemes[name] then
		self.Current = name
	end
end

-- Utility Module
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utility = {}

function Utility:MakeDraggable(frame, dragHandle)
	dragHandle = dragHandle or frame
	local dragging, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	local inputConnection = dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end
	end)
	local endConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	return function()
		inputConnection:Disconnect()
		endConnection:Disconnect()
	end
end

function Utility:Tween(obj, props, duration, easing, direction)
	duration = duration or 0.2
	easing = easing or Enum.EasingStyle.Quad
	direction = direction or Enum.EasingDirection.Out
	local tween = TweenService:Create(obj, TweenInfo.new(duration, easing, direction), props)
	tween:Play()
	return tween
end

function Utility:Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Children" then obj[k] = v end
	end
	if props.Children then
		for _, child in ipairs(props.Children) do
			child.Parent = obj
		end
	end
	return obj
end

function Utility:CreateCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 6)
	corner.Parent = parent
	return corner
end

function Utility:CreateStroke(parent, color, thickness)
	thickness = thickness or 1
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(50, 50, 50)
	stroke.Thickness = thickness
	stroke.Parent = parent
	return stroke
end

function Utility:CreateListLayout(parent, padding, fillDirection)
	fillDirection = fillDirection or Enum.FillDirection.Vertical
	local layout = Instance.new("UIListLayout")
	layout.Padding = padding or UDim.new(0, 6)
	layout.FillDirection = fillDirection
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = parent
	return layout
end

function Utility:CreateScrollingFrame(parent)
	local sf = Instance.new("ScrollingFrame")
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.ScrollBarThickness = 4
	sf.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	sf.ScrollBarImageTransparency = 0.3
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.ScrollingDirection = Enum.ScrollingDirection.Y
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.Parent = parent
	return sf
end

function Utility:CreateShadow(parent, transparency, color)
	transparency = transparency or 0.7
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Image = "rbxassetid://6015897843"
	shadow.ImageColor3 = color or Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = transparency
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(23, 23, 23, 23)
	shadow.Size = UDim2.new(1, 12, 1, 12)
	shadow.Position = UDim2.new(0, -6, 0, -6)
	shadow.ZIndex = 0
	shadow.Parent = parent
	return shadow
end

-- Notification Module
local Notification = {}
Notification.__index = Notification

function Notification.new(theme, utility)
	return setmetatable({
		Theme = theme,
		Utility = utility,
		Queue = {},
		Processing = false,
	}, Notification)
end

function Notification:SetupContainer()
	if self.Container and self.Container.Parent then return end
	local scheme = self.Theme:GetScheme()
	local container = Instance.new("Frame")
	container.Name = "NotificationContainer"
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Size = UDim2.new(0, 350, 1, -20)
	container.Position = UDim2.new(1, -370, 0, 10)
	container.ZIndex = 100
	container.Parent = game:GetService("CoreGui")

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = container

	self.Container = container
end

function Notification:Notify(data)
	if not self.Container or not self.Container.Parent then self:SetupContainer() end
	data.Title = data.Title or "Notification"
	data.Content = data.Content or ""
	data.Duration = data.Duration or 5
	table.insert(self.Queue, data)
	if not self.Processing then self:ProcessQueue() end
end

function Notification:ProcessQueue()
	if #self.Queue == 0 then self.Processing = false return end
	self.Processing = true
	local data = table.remove(self.Queue, 1)
	self:ShowNotification(data)
end

function Notification:ShowNotification(data)
	local scheme = self.Theme:GetScheme()
	local notifFrame = Instance.new("Frame")
	notifFrame.Name = "Notification"
	notifFrame.BackgroundColor3 = scheme.NotificationBackground
	notifFrame.BackgroundTransparency = 1
	notifFrame.BorderSizePixel = 0
	notifFrame.Size = UDim2.new(1, 0, 0, 0)
	notifFrame.ClipsDescendants = true
	notifFrame.ZIndex = 100
	notifFrame.Parent = self.Container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = notifFrame

	local stroke = Instance.new("UIStroke")
	stroke.Color = scheme.NotificationBorder
	stroke.Thickness = 1
	stroke.Parent = notifFrame

	local innerFrame = Instance.new("Frame")
	innerFrame.Name = "Inner"
	innerFrame.BackgroundTransparency = 1
	innerFrame.BorderSizePixel = 0
	innerFrame.Size = UDim2.new(1, -16, 1, -16)
	innerFrame.Position = UDim2.new(0, 8, 0, 8)
	innerFrame.Parent = notifFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = Theme.Font
	titleLabel.Text = data.Title
	titleLabel.TextColor3 = scheme.ElementText
	titleLabel.TextSize = Theme.TextSize
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, 0, 0, 18)
	titleLabel.Parent = innerFrame

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Name = "Content"
	contentLabel.BackgroundTransparency = 1
	contentLabel.BorderSizePixel = 0
	contentLabel.Font = Theme.Font
	contentLabel.Text = data.Content
	contentLabel.TextColor3 = scheme.ElementTextSecondary
	contentLabel.TextSize = Theme.TextSize - 2
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.Size = UDim2.new(1, 0, 0, 0)
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Parent = innerFrame

	corner:Destroy()

	notifFrame.Size = UDim2.new(1, 0, 0, innerFrame.AbsoluteSize.Y + 16)

	TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	}):Play()

	task.delay(data.Duration, function()
		if not notifFrame or not notifFrame.Parent then return end
		local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 50, 0, 0)
		})
		tweenOut.Completed:Connect(function()
			notifFrame:Destroy()
			self:ProcessQueue()
		end)
		tweenOut:Play()
	end)
end

-- Window Module
local Window = {}
Window.__index = Window

function Window.new(theme, utility)
	return setmetatable({
		Theme = theme,
		Utility = utility,
		Tabs = {},
		Destroyed = false,
		Visible = true,
		TopbarHeight = 40,
		TabBarWidth = 180,
	}, Window)
end

function Window:Create(data)
	data = data or {}
	data.Name = data.Name or "Exernality"
	data.Version = data.Version or "v1.0"

	local scheme = self.Theme:GetScheme()

	local gui = Instance.new("ScreenGui")
	gui.Name = "ExernalityUI"
	gui.ResetOnSpawn = false
	gui.Parent = game:GetService("CoreGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.BackgroundColor3 = scheme.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
	mainFrame.Size = UDim2.new(0, 800, 0, 500)
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = gui

	self.Utility:CreateCorner(mainFrame)
	self.Utility:CreateShadow(mainFrame, scheme.Transparency.Shadow, scheme.Shadow)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.BackgroundColor3 = scheme.Topbar
	topbar.BorderSizePixel = 0
	topbar.Size = UDim2.new(1, 0, 0, self.TopbarHeight)
	topbar.Parent = mainFrame

	local topbarCorner = Instance.new("UICorner")
	topbarCorner.CornerRadius = UDim.new(0, 6)
	topbarCorner.Parent = topbar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = self.Theme.Font
	titleLabel.Text = data.Name
	titleLabel.TextColor3 = scheme.TopbarText
	titleLabel.TextSize = self.Theme.TextSize + 2
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(0.5, -20, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.Parent = topbar

	local versionLabel = Instance.new("TextLabel")
	versionLabel.Name = "Version"
	versionLabel.BackgroundTransparency = 1
	versionLabel.BorderSizePixel = 0
	versionLabel.Font = self.Theme.Font
	versionLabel.Text = data.Version
	versionLabel.TextColor3 = scheme.ElementTextSecondary
	versionLabel.TextSize = self.Theme.TextSize - 3
	versionLabel.TextXAlignment = Enum.TextXAlignment.Right
	versionLabel.Size = UDim2.new(0.5, -20, 1, 0)
	versionLabel.Position = UDim2.new(0.5, 0, 0, 0)
	versionLabel.Parent = topbar

	local closeBtn = Instance.new("ImageButton")
	closeBtn.Name = "Close"
	closeBtn.BackgroundTransparency = 1
	closeBtn.BorderSizePixel = 0
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -32, 0.5, -12)
	closeBtn.Image = "rbxassetid://6031094678"
	closeBtn.ImageColor3 = scheme.ElementTextSecondary
	closeBtn.Parent = topbar

	closeBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:Destroy()
		end
	end)

	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.BackgroundColor3 = scheme.TabBackground
	tabBar.BorderSizePixel = 0
	tabBar.Size = UDim2.new(0, self.TabBarWidth, 1, -self.TopbarHeight)
	tabBar.Position = UDim2.new(0, 0, 0, self.TopbarHeight)
	tabBar.Parent = mainFrame

	local tabBarCorner = Instance.new("UICorner")
	tabBarCorner.CornerRadius = UDim.new(0, 6)
	tabBarCorner.Parent = tabBar

	local tabList = Instance.new("ScrollingFrame")
	tabList.Name = "TabList"
	tabList.BackgroundTransparency = 1
	tabList.BorderSizePixel = 0
	tabList.ScrollBarThickness = 0
	tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabList.ScrollingDirection = Enum.ScrollingDirection.Y
	tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabList.Size = UDim2.new(1, 0, 1, 0)
	tabList.Parent = tabBar

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.Padding = UDim.new(0, 2)
	tabListLayout.FillDirection = Enum.FillDirection.Vertical
	tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Parent = tabList

	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.BackgroundTransparency = 1
	contentArea.BorderSizePixel = 0
	contentArea.Size = UDim2.new(1, -self.TabBarWidth, 1, -self.TopbarHeight)
	contentArea.Position = UDim2.new(0, self.TabBarWidth, 0, self.TopbarHeight)
	contentArea.Parent = mainFrame

	self.Gui = gui
	self.Main = mainFrame
	self.Topbar = topbar
	self.TabBar = tabBar
	self.TabList = tabList
	self.ContentArea = contentArea

	self.Utility:MakeDraggable(mainFrame, topbar)

	return self
end

function Window:CreateTab(data)
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
	tabButton.Parent = self.TabList

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
		iconLabel.ImageColor3 = scheme.TabText
		iconLabel.Parent = tabButton
	end

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.TabText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(1, -40, 1, 0)
	nameLabel.Position = UDim2.new(0, 40, 0, 0)
	nameLabel.Parent = tabButton

	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.BackgroundColor3 = scheme.TabIndicator
	indicator.BorderSizePixel = 0
	indicator.Size = UDim2.new(0, 3, 0, 0)
	indicator.Position = UDim2.new(0, 0, 0.5, 0)
	indicator.Visible = false
	indicator.Parent = tabButton

	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0, 2)
	indicatorCorner.Parent = indicator

	local tab = {
		Button = tabButton,
		IconLabel = iconLabel,
		NameLabel = nameLabel,
		Indicator = indicator,
		Sections = {},
		Active = false,
		Container = nil,
		Window = self,
		Theme = self.Theme,
		Utility = self.Utility,
		SetActive = function(self, active)
			self.Active = active
			if active then
				self.Container.Visible = true
				self.Indicator.Visible = true
				self.Utility:Tween(self.Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.2)
				self.Utility:Tween(self.Button, {BackgroundTransparency = 0.85}, 0.2)
				self.NameLabel.TextColor3 = scheme.TabTextActive
				if self.IconLabel then self.IconLabel.ImageColor3 = scheme.TabTextActive end
			else
				self.Container.Visible = false
				self.Indicator.Visible = false
				self.Utility:Tween(self.Button, {BackgroundTransparency = 1}, 0.2)
				self.NameLabel.TextColor3 = scheme.TabText
				if self.IconLabel then self.IconLabel.ImageColor3 = scheme.TabText end
			end
		end,
		CreateSection = function(self, data)
			data = data or {}
			data.Name = data.Name or "Section"

			local scheme = self.Theme:GetScheme()
			local Window = self.Window

			if not self.Container then
				local contentScrolling = self.Utility:CreateScrollingFrame(Window.ContentArea)
				self.Container = contentScrolling
				local layout = self.Utility:CreateListLayout(contentScrolling, UDim.new(0, 8))
				layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			end

			local sectionFrame = Instance.new("Frame")
			sectionFrame.Name = "Section_" .. data.Name
			sectionFrame.BackgroundColor3 = scheme.SectionBackground
			sectionFrame.BorderSizePixel = 0
			sectionFrame.Size = UDim2.new(1, -16, 0, 0)
			sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
			sectionFrame.Parent = self.Container

			self.Utility:CreateCorner(sectionFrame)
			self.Utility:CreateStroke(sectionFrame, scheme.ElementBorder, 1)

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Name = "Title"
			titleLabel.BackgroundTransparency = 1
			titleLabel.BorderSizePixel = 0
			titleLabel.Font = Theme.Font
			titleLabel.Text = data.Name
			titleLabel.TextColor3 = scheme.SectionTitle
			titleLabel.TextSize = Theme.TextSize + 1
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.Size = UDim2.new(1, -20, 0, 24)
			titleLabel.Position = UDim2.new(0, 10, 0, 8)
			titleLabel.Parent = sectionFrame

			local elementContainer = Instance.new("Frame")
			elementContainer.Name = "Elements"
			elementContainer.BackgroundTransparency = 1
			elementContainer.BorderSizePixel = 0
			elementContainer.Size = UDim2.new(1, -20, 0, 0)
			elementContainer.Position = UDim2.new(0, 10, 0, 36)
			elementContainer.AutomaticSize = Enum.AutomaticSize.Y
			elementContainer.Parent = sectionFrame

			local elementList = Instance.new("UIListLayout")
			elementList.Padding = UDim.new(0, 6)
			elementList.FillDirection = Enum.FillDirection.Vertical
			elementList.HorizontalAlignment = Enum.HorizontalAlignment.Left
			elementList.SortOrder = Enum.SortOrder.LayoutOrder
			elementList.Parent = elementContainer

			local section = {
				Frame = sectionFrame,
				ElementContainer = elementContainer,
				TitleLabel = titleLabel,
				Elements = {},
				Theme = self.Theme,
				Utility = self.Utility,
				CreateButton = function(s, d) return createElement("Button", s, d) end,
				CreateToggle = function(s, d) return createElement("Toggle", s, d) end,
				CreateSlider = function(s, d) return createElement("Slider", s, d) end,
				CreateDropdown = function(s, d) return createElement("Dropdown", s, d) end,
				CreateKeybind = function(s, d) return createElement("Keybind", s, d) end,
				CreateTextbox = function(s, d) return createElement("Textbox", s, d) end,
				CreateColorPicker = function(s, d) return createElement("ColorPicker", s, d) end,
				CreateParagraph = function(s, d) return createElement("Paragraph", s, d) end,
				CreateLabel = function(s, d) return createElement("Label", s, d) end,
			}

			table.insert(self.Sections, section)
			return section
		end,
	}

	tabButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:SelectTab(tab)
		end
	end)
	tabButton.MouseEnter:Connect(function()
		if not tab.Active then self.Utility:Tween(tabButton, {BackgroundTransparency = 0.9}, 0.15) end
	end)
	tabButton.MouseLeave:Connect(function()
		if not tab.Active then self.Utility:Tween(tabButton, {BackgroundTransparency = 1}, 0.15) end
	end)

	table.insert(self.Tabs, tab)
	if not self.ActiveTab then self:SelectTab(tab) end

	return tab
end

function Window:SelectTab(tab)
	if self.ActiveTab then self.ActiveTab:SetActive(false) end
	self.ActiveTab = tab
	tab:SetActive(true)
end

function Window:Notify(data)
	local notif = Notification.new(self.Theme, self.Utility)
	notif:SetupContainer()
	notif:Notify(data)
end

function Window:Destroy()
	if self.Gui then self.Gui:Destroy() end
	self.Destroyed = true
end

function Window:Toggle()
	self.Visible = not self.Visible
	self.Main.Visible = self.Visible
end

-- Element factory
local function createButton(section, data)
	data = data or {}
	data.Name = data.Name or "Button"
	data.Callback = data.Callback or function() end

	local scheme = section.Theme:GetScheme()

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "Button_" .. data.Name
	buttonFrame.BackgroundColor3 = scheme.ElementBackground
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Size = UDim2.new(1, 0, 0, 36)
	buttonFrame.Parent = section.ElementContainer

	Utility:CreateCorner(buttonFrame)

	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.BackgroundColor3 = scheme.Accent
	button.BorderSizePixel = 0
	button.Font = Theme.Font
	button.Text = data.Name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = Theme.TextSize
	button.Size = UDim2.new(0, 0, 0, 28)
	button.Position = UDim2.new(1, -8, 0.5, -14)
	button.AutomaticSize = Enum.AutomaticSize.X
	button.Parent = buttonFrame

	Utility:CreateCorner(button)
	Utility:CreateStroke(button, scheme.AccentDim, 1)

	button.MouseButton1Click:Connect(data.Callback)
	button.MouseEnter:Connect(function()
		Utility:Tween(button, {BackgroundColor3 = scheme.AccentHover}, 0.15)
	end)
	button.MouseLeave:Connect(function()
		Utility:Tween(button, {BackgroundColor3 = scheme.Accent}, 0.15)
	end)

	return buttonFrame
end

local function createToggle(section, data)
	data = data or {}
	data.Name = data.Name or "Toggle"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or false

	local scheme = section.Theme:GetScheme()
	local value = data.Default

	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = "Toggle_" .. data.Name
	toggleFrame.BackgroundColor3 = scheme.ElementBackground
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Size = UDim2.new(1, 0, 0, 36)
	toggleFrame.Parent = section.ElementContainer

	Utility:CreateCorner(toggleFrame)

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.BackgroundTransparency = 1
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Size = UDim2.new(1, 0, 1, 0)
	toggleBtn.Text = ""
	toggleBtn.Parent = toggleFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(1, -60, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = toggleFrame

	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "Indicator"
	toggleIndicator.BackgroundColor3 = scheme.ElementBackground
	toggleIndicator.BorderSizePixel = 0
	toggleIndicator.Size = UDim2.new(0, 44, 0, 22)
	toggleIndicator.Position = UDim2.new(1, -52, 0.5, -11)
	toggleIndicator.Parent = toggleFrame

	Utility:CreateCorner(toggleIndicator, UDim.new(0, 11))

	local toggleCircle = Instance.new("Frame")
	toggleCircle.Name = "Circle"
	toggleCircle.BackgroundColor3 = scheme.ElementTextSecondary
	toggleCircle.BorderSizePixel = 0
	toggleCircle.Size = UDim2.new(0, 18, 0, 18)
	toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
	toggleCircle.Parent = toggleIndicator

	Utility:CreateCorner(toggleCircle, UDim.new(0, 9))

	local function updateVisuals()
		if value then
			Utility:Tween(toggleIndicator, {BackgroundColor3 = scheme.Accent}, 0.15)
			Utility:Tween(toggleCircle, {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = UDim2.new(0, 24, 0.5, -9)
			}, 0.15)
		else
			Utility:Tween(toggleIndicator, {BackgroundColor3 = scheme.ElementBackground}, 0.15)
			Utility:Tween(toggleCircle, {
				BackgroundColor3 = scheme.ElementTextSecondary,
				Position = UDim2.new(0, 2, 0.5, -9)
			}, 0.15)
		end
	end

	toggleBtn.MouseButton1Click:Connect(function()
		value = not value
		updateVisuals()
		data.Callback(value)
	end)

	updateVisuals()
	return toggleFrame
end

local function createSlider(section, data)
	data = data or {}
	data.Name = data.Name or "Slider"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or 0
	data.Min = data.Min or 0
	data.Max = data.Max or 100
	data.Suffix = data.Suffix or ""
	data.Decimal = data.Decimal or 0

	local scheme = section.Theme:GetScheme()
	local min, max = data.Min, data.Max
	local value = data.Default
	local dragging = false

	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = "Slider_" .. data.Name
	sliderFrame.BackgroundColor3 = scheme.ElementBackground
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Size = UDim2.new(1, 0, 0, 48)
	sliderFrame.Parent = section.ElementContainer

	Utility:CreateCorner(sliderFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 0, 18)
	nameLabel.Position = UDim2.new(0, 10, 0, 6)
	nameLabel.Parent = sliderFrame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.BorderSizePixel = 0
	valueLabel.Font = Theme.Font
	valueLabel.Text = tostring(data.Default) .. data.Suffix
	valueLabel.TextColor3 = scheme.Accent
	valueLabel.TextSize = Theme.TextSize
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0.5, -10, 0, 18)
	valueLabel.Position = UDim2.new(0.5, 0, 0, 6)
	valueLabel.Parent = sliderFrame

	local sliderBg = Instance.new("Frame")
	sliderBg.BackgroundColor3 = scheme.ElementBackgroundHover
	sliderBg.BorderSizePixel = 0
	sliderBg.Size = UDim2.new(1, -20, 0, 6)
	sliderBg.Position = UDim2.new(0, 10, 0, 32)
	sliderBg.Parent = sliderFrame

	Utility:CreateCorner(sliderBg, UDim.new(0, 3))

	local sliderFill = Instance.new("Frame")
	sliderFill.BackgroundColor3 = scheme.Accent
	sliderFill.BorderSizePixel = 0
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.Parent = sliderBg

	Utility:CreateCorner(sliderFill, UDim.new(0, 3))

	local sliderKnob = Instance.new("Frame")
	sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderKnob.BorderSizePixel = 0
	sliderKnob.Size = UDim2.new(0, 14, 0, 14)
	sliderKnob.Position = UDim2.new(0, 0, 0.5, -7)
	sliderKnob.Parent = sliderFrame

	Utility:CreateCorner(sliderKnob, UDim.new(0, 7))

	local function updateValue(inputPos)
		local absPos = sliderBg.AbsolutePosition
		local absSize = sliderBg.AbsoluteSize
		local relX = math.clamp(inputPos.X - absPos.X, 0, absSize.X)
		local pct = relX / absSize.X
		value = min + (max - min) * pct
		if data.Decimal > 0 then
			value = math.round(value * (10 ^ data.Decimal)) / (10 ^ data.Decimal)
		else
			value = math.floor(value)
		end
		value = math.clamp(value, min, max)
		local fillW = pct * (absSize.X - 14)
		sliderFill.Size = UDim2.new(0, fillW, 1, 0)
		sliderKnob.Position = UDim2.new(0, fillW, 0.5, -7)
		local display = data.Decimal > 0 and string.format("%." .. data.Decimal .. "f", value) or tostring(math.floor(value))
		valueLabel.Text = display .. data.Suffix
		data.Callback(value)
	end

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateValue(input)
		end
	end)
	sliderBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateValue(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	return sliderFrame
end

local function createDropdown(section, data)
	data = data or {}
	data.Name = data.Name or "Dropdown"
	data.Callback = data.Callback or function() end
	data.Options = data.Options or {}
	data.Default = data.Default or ""

	local scheme = section.Theme:GetScheme()
	local selected = data.Default
	local open = false
	local dropdownList = nil

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = "Dropdown_" .. data.Name
	dropdownFrame.BackgroundColor3 = scheme.ElementBackground
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.Size = UDim2.new(1, 0, 0, 36)
	dropdownFrame.Parent = section.ElementContainer

	Utility:CreateCorner(dropdownFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = dropdownFrame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.BorderSizePixel = 0
	valueLabel.Font = Theme.Font
	valueLabel.Text = data.Default ~= "" and tostring(data.Default) or "Select..."
	valueLabel.TextColor3 = data.Default ~= "" and scheme.ElementText or scheme.PlaceholderText
	valueLabel.TextSize = Theme.TextSize - 1
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0.5, -40, 1, 0)
	valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
	valueLabel.Parent = dropdownFrame

	local dropdownBtn = Instance.new("TextButton")
	dropdownBtn.BackgroundTransparency = 1
	dropdownBtn.BorderSizePixel = 0
	dropdownBtn.Size = UDim2.new(1, 0, 1, 0)
	dropdownBtn.Text = ""
	dropdownBtn.Parent = dropdownFrame

	dropdownBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			dropdownList = Instance.new("Frame")
			dropdownList.Name = "DropdownList"
			dropdownList.BackgroundColor3 = scheme.DropdownBackground
			dropdownList.BorderSizePixel = 0
			dropdownList.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, 0)
			dropdownList.AutomaticSize = Enum.AutomaticSize.Y
			dropdownList.Position = UDim2.new(0, 8, 0, dropdownFrame.AbsoluteSize.Y + 2)
			dropdownList.ZIndex = 50
			dropdownList.Parent = section.ElementContainer

			Utility:CreateCorner(dropdownList)
			Utility:CreateStroke(dropdownList, scheme.ElementBorder, 1)

			local listLayout = Utility:CreateListLayout(dropdownList, UDim.new(0, 0))

			for _, opt in ipairs(data.Options) do
				local optBtn = Instance.new("TextButton")
				optBtn.BackgroundTransparency = 1
				optBtn.BorderSizePixel = 0
				optBtn.Font = Theme.Font
				optBtn.Text = tostring(opt)
				optBtn.TextColor3 = scheme.ElementText
				optBtn.TextSize = Theme.TextSize - 1
				optBtn.Size = UDim2.new(1, 0, 0, 30)
				optBtn.Parent = dropdownList

				optBtn.MouseEnter:Connect(function()
					Utility:Tween(optBtn, {BackgroundTransparency = 0.9}, 0.1)
				end)
				optBtn.MouseLeave:Connect(function()
					Utility:Tween(optBtn, {BackgroundTransparency = 1}, 0.1)
				end)
				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					valueLabel.Text = tostring(opt)
					valueLabel.TextColor3 = scheme.ElementText
					if dropdownList then dropdownList:Destroy() dropdownList = nil end
					open = false
					data.Callback(opt)
				end)
			end
		elseif dropdownList then
			dropdownList:Destroy()
			dropdownList = nil
		end
	end)

	return dropdownFrame
end

local function createKeybind(section, data)
	data = data or {}
	data.Name = data.Name or "Keybind"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or Enum.KeyCode.F

	local scheme = section.Theme:GetScheme()
	local key = data.Default
	local listening = false

	local keybindFrame = Instance.new("Frame")
	keybindFrame.Name = "Keybind_" .. data.Name
	keybindFrame.BackgroundColor3 = scheme.ElementBackground
	keybindFrame.BorderSizePixel = 0
	keybindFrame.Size = UDim2.new(1, 0, 0, 36)
	keybindFrame.Parent = section.ElementContainer

	Utility:CreateCorner(keybindFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = keybindFrame

	local keyBtn = Instance.new("TextButton")
	keyBtn.BackgroundColor3 = scheme.InputBackground
	keyBtn.BorderSizePixel = 0
	keyBtn.Font = Theme.Font
	keyBtn.Text = key.Name
	keyBtn.TextColor3 = scheme.ElementText
	keyBtn.TextSize = Theme.TextSize - 1
	keyBtn.Size = UDim2.new(0, 80, 0, 26)
	keyBtn.Position = UDim2.new(1, -88, 0.5, -13)
	keyBtn.Parent = keybindFrame

	Utility:CreateCorner(keyBtn)

	keyBtn.MouseButton1Click:Connect(function()
		listening = true
		keyBtn.Text = "..."
		keyBtn.TextColor3 = scheme.Accent
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				key = input.KeyCode
				keyBtn.Text = key.Name
				keyBtn.TextColor3 = scheme.ElementText
				listening = false
				conn:Disconnect()
			end
		end)
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed or listening then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
			data.Callback(key)
		end
	end)

	return keybindFrame
end

local function createTextbox(section, data)
	data = data or {}
	data.Name = data.Name or "Textbox"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or ""
	data.Placeholder = data.Placeholder or "Enter text..."
	data.ClearTextOnFocus = data.ClearTextOnFocus or false

	local scheme = section.Theme:GetScheme()

	local textboxFrame = Instance.new("Frame")
	textboxFrame.Name = "Textbox_" .. data.Name
	textboxFrame.BackgroundColor3 = scheme.ElementBackground
	textboxFrame.BorderSizePixel = 0
	textboxFrame.Size = UDim2.new(1, 0, 0, 36)
	textboxFrame.Parent = section.ElementContainer

	Utility:CreateCorner(textboxFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.35, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = textboxFrame

	local inputBox = Instance.new("TextBox")
	inputBox.BackgroundColor3 = scheme.InputBackground
	inputBox.BorderSizePixel = 0
	inputBox.Font = Theme.Font
	inputBox.Text = data.Default
	inputBox.PlaceholderText = data.Placeholder
	inputBox.PlaceholderColor3 = scheme.PlaceholderText
	inputBox.TextColor3 = scheme.ElementText
	inputBox.TextSize = Theme.TextSize - 1
	inputBox.Size = UDim2.new(0.6, -20, 0, 26)
	inputBox.Position = UDim2.new(0.35, 0, 0.5, -13)
	inputBox.ClearTextOnFocus = data.ClearTextOnFocus
	inputBox.Parent = textboxFrame

	Utility:CreateCorner(inputBox)

	inputBox.FocusLost:Connect(function()
		data.Callback(inputBox.Text)
	end)

	return textboxFrame
end

local function createColorPicker(section, data)
	data = data or {}
	data.Name = data.Name or "ColorPicker"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or Color3.fromRGB(255, 255, 255)

	local scheme = section.Theme:GetScheme()
	local colorVal = data.Default
	local open = false
	local pickerContainer = nil

	local cpFrame = Instance.new("Frame")
	cpFrame.Name = "ColorPicker_" .. data.Name
	cpFrame.BackgroundColor3 = scheme.ElementBackground
	cpFrame.BorderSizePixel = 0
	cpFrame.Size = UDim2.new(1, 0, 0, 36)
	cpFrame.Parent = section.ElementContainer

	Utility:CreateCorner(cpFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = Theme.Font
	nameLabel.Text = data.Name
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Parent = cpFrame

	local colorPreview = Instance.new("Frame")
	colorPreview.BackgroundColor3 = data.Default
	colorPreview.BorderSizePixel = 0
	colorPreview.Size = UDim2.new(0, 28, 0, 28)
	colorPreview.Position = UDim2.new(1, -36, 0.5, -14)
	colorPreview.Parent = cpFrame

	Utility:CreateCorner(colorPreview, UDim.new(0, 4))
	Utility:CreateStroke(colorPreview, scheme.ElementBorder, 1)

	local colorBtn = Instance.new("TextButton")
	colorBtn.BackgroundTransparency = 1
	colorBtn.BorderSizePixel = 0
	colorBtn.Size = UDim2.new(1, 0, 1, 0)
	colorBtn.Text = ""
	colorBtn.Parent = cpFrame

	colorBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			pickerContainer = Instance.new("Frame")
			pickerContainer.BackgroundColor3 = scheme.DropdownBackground
			pickerContainer.BorderSizePixel = 0
			pickerContainer.Size = UDim2.new(0, 200, 0, 160)
			pickerContainer.Position = UDim2.new(0, 0, 0, cpFrame.AbsoluteSize.Y + 2)
			pickerContainer.ZIndex = 50
			pickerContainer.Parent = section.ElementContainer

			Utility:CreateCorner(pickerContainer)
			Utility:CreateStroke(pickerContainer, scheme.ElementBorder, 1)

			local satImg = Instance.new("ImageLabel")
			satImg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			satImg.BorderSizePixel = 0
			satImg.Size = UDim2.new(1, -20, 1, -50)
			satImg.Position = UDim2.new(0, 10, 0, 10)
			satImg.Image = "rbxassetid://4155801252"
			satImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
			satImg.Parent = pickerContainer
			Utility:CreateCorner(satImg)

			local hueSlider = Instance.new("Frame")
			hueSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			hueSlider.BorderSizePixel = 0
			hueSlider.Size = UDim2.new(1, -20, 0, 16)
			hueSlider.Position = UDim2.new(0, 10, 0, 134)
			hueSlider.Parent = pickerContainer

			local hueGradient = Instance.new("UIGradient")
			hueGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			})
			hueGradient.Parent = hueSlider
		elseif pickerContainer then
			pickerContainer:Destroy()
			pickerContainer = nil
		end
	end)

	return cpFrame
end

local function createParagraph(section, data)
	data = data or {}
	data.Title = data.Title or "Paragraph"
	data.Content = data.Content or ""

	local scheme = section.Theme:GetScheme()

	local paraFrame = Instance.new("Frame")
	paraFrame.Name = "Paragraph_" .. data.Title
	paraFrame.BackgroundColor3 = scheme.ElementBackground
	paraFrame.BorderSizePixel = 0
	paraFrame.Size = UDim2.new(1, 0, 0, 0)
	paraFrame.AutomaticSize = Enum.AutomaticSize.Y
	paraFrame.Parent = section.ElementContainer

	Utility:CreateCorner(paraFrame)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = Theme.Font
	titleLabel.Text = data.Title
	titleLabel.TextColor3 = scheme.ElementText
	titleLabel.TextSize = Theme.TextSize
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.Parent = paraFrame

	local contentLabel = Instance.new("TextLabel")
	contentLabel.BackgroundTransparency = 1
	contentLabel.BorderSizePixel = 0
	contentLabel.Font = Theme.Font
	contentLabel.Text = data.Content
	contentLabel.TextColor3 = scheme.ElementTextSecondary
	contentLabel.TextSize = Theme.TextSize - 2
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.RichText = true
	contentLabel.Size = UDim2.new(1, -20, 0, 0)
	contentLabel.Position = UDim2.new(0, 10, 0, 30)
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Parent = paraFrame

	return paraFrame
end

local function createLabel(section, data)
	data = data or {}
	data.Text = data.Text or "Label"
	data.Color = data.Color or nil

	local scheme = section.Theme:GetScheme()

	local labelFrame = Instance.new("Frame")
	labelFrame.Name = "Label"
	labelFrame.BackgroundColor3 = scheme.ElementBackground
	labelFrame.BorderSizePixel = 0
	labelFrame.Size = UDim2.new(1, 0, 0, 28)
	labelFrame.Parent = section.ElementContainer

	Utility:CreateCorner(labelFrame)

	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Font = Theme.Font
	textLabel.Text = data.Text
	textLabel.TextColor3 = data.Color or scheme.ElementTextSecondary
	textLabel.TextSize = Theme.TextSize - 1
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Size = UDim2.new(1, -20, 1, 0)
	textLabel.Position = UDim2.new(0, 10, 0, 0)
	textLabel.Parent = labelFrame

	return labelFrame
end

local function createElement(elementType, section, data)
	if elementType == "Button" then return createButton(section, data)
	elseif elementType == "Toggle" then return createToggle(section, data)
	elseif elementType == "Slider" then return createSlider(section, data)
	elseif elementType == "Dropdown" then return createDropdown(section, data)
	elseif elementType == "Keybind" then return createKeybind(section, data)
	elseif elementType == "Textbox" then return createTextbox(section, data)
	elseif elementType == "ColorPicker" then return createColorPicker(section, data)
	elseif elementType == "Paragraph" then return createParagraph(section, data)
	elseif elementType == "Label" then return createLabel(section, data)
	end
end

-- Public API
function ExernalityUI:CreateWindow(data)
	local window = Window.new(Theme, Utility)
	window:Create(data)
	return window
end

function ExernalityUI:SetTheme(name)
	Theme:SetTheme(name)
end

function ExernalityUI:GetTheme()
	return Theme.Current
end

function ExernalityUI:GetThemes()
	local t = {}
	for k in pairs(Theme.Schemes) do
		table.insert(t, k)
	end
	return t
end

return ExernalityUI
