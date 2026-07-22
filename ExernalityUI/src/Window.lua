local Window = {}
Window.__index = Window

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Window.new(theme, utility, notification)
	local self = setmetatable({}, Window)
	self.Theme = theme
	self.Utility = utility
	self.Notification = notification
	self.Tabs = {}
	self.ActiveTab = nil
	self.Destroyed = false
	self.Visible = true
	self.Draggable = true
	self.TopbarHeight = 40
	self.TabBarWidth = 180
	self.MinSize = UDim2.new(0, 600, 0, 400)
	return self
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

	local topbarGradient = Instance.new("UIGradient")
	topbarGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, scheme.Topbar),
		ColorSequenceKeypoint.new(1, scheme.Topbar:Lerp(Color3.fromRGB(255, 255, 255), 0.02)),
	})
	topbarGradient.Parent = topbar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = self.Theme.Font
	titleLabel.Text = data.Name or "Exernality"
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
	versionLabel.Text = data.Version or ""
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

	local tabBarPadding = Instance.new("UIPadding")
	tabBarPadding.PaddingTop = UDim.new(0, 8)
	tabBarPadding.PaddingBottom = UDim.new(0, 8)
	tabBarPadding.PaddingLeft = UDim.new(0, 4)
	tabBarPadding.PaddingRight = UDim.new(0, 4)
	tabBarPadding.Parent = tabBar

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
	self.CloseBtn = closeBtn
	self.TitleLabel = titleLabel

	self.Utility:MakeDraggable(mainFrame, topbar)

	return self
end

function Window:CreateTab(data)
	data = data or {}
	data.Name = data.Name or "Tab"
	data.Icon = data.Icon or ""

	local Tab = require(script.Parent.Tab)
	local tab = Tab.new(self.Theme, self.Utility, self)
	tab:Create(data)
	table.insert(self.Tabs, tab)

	if not self.ActiveTab then
		self:SelectTab(tab)
	end

	return tab
end

function Window:SelectTab(tab)
	if self.ActiveTab then
		self.ActiveTab:SetActive(false)
	end
	self.ActiveTab = tab
	tab:SetActive(true)
end

function Window:Notify(data)
	self.Notification:Notify(data)
end

function Window:Destroy()
	if self.Gui then
		self.Gui:Destroy()
	end
	self.Destroyed = true
end

function Window:Toggle()
	self.Visible = not self.Visible
	self.Main.Visible = self.Visible
end

function Window:SetVisible(visible)
	self.Visible = visible
	self.Main.Visible = visible
end

return Window
