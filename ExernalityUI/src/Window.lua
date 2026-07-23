local Window = {}
Window.__index = Window

local Players = game:GetService("Players")

function Window.new(theme, utility, notification)
	local self = setmetatable({}, Window)
	self.Theme = theme
	self.Utility = utility
	self.Notification = notification
	self.Tabs = {}
	self.ActiveTab = nil
	self.Destroyed = false
	self.Visible = true
	return self
end

function Window:Create(data)
	data = data or {}
	data.Name = data.Name or "Exernality"
	data.Version = data.Version or "v1.0"

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local gui = U:Create("ScreenGui", {
		Name = "Exernality",
		ResetOnSpawn = true,
		ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
		ClipToDeviceSafeArea = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui,
	})

	-- Drag container: both outline and mainFrame live in here, dragged as one
	local dragContainer = U:Create("Frame", {
		Name = "DragContainer",
		Position = UDim2.new(0.19056724, 0, 0.20240964, 0),
		Size = UDim2.new(0, T.WindowWidth, 0, T.WindowHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = gui,
	})

	local outline = U:Create("Frame", {
		Name = "ExernalityOutline",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = scheme.bg,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 2,
		Parent = dragContainer,
	})

	U:CreateStroke(outline, Color3.fromRGB(138, 138, 138), 1, Enum.BorderStrokePosition.Outer)
	U:CreateCorner(outline)

	local mainFrame = U:Create("Frame", {
		Name = "Exernality",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = scheme.bg,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = dragContainer,
	})

	U:CreateShadow(mainFrame, 0.06, Color3.fromRGB(0, 0, 0), 25)
	U:CreateCorner(mainFrame)

	-- Logo
	local logo = U:Create("ImageLabel", {
		Name = "ImageLabel",
		Position = UDim2.new(0.010309278, 0, 0.0118577071, 0),
		Size = UDim2.new(0, 27, 0, 27),
		BackgroundColor3 = scheme.white,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Image = data.Logo or "rbxassetid://94904426200943",
		ImageColor3 = scheme.white,
		ScaleType = Enum.ScaleType.Stretch,
		ZIndex = 1,
		Parent = mainFrame,
	})

	U:CreateStroke(logo, scheme.strokeOuter, 1)

	-- Topbar Line (horizontal separator area)
	local lineH = U:Create("Frame", {
		Name = "Line",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, T.TopbarHeight),
		BackgroundTransparency = 1,
		BackgroundColor3 = scheme.white,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 15,
		Parent = mainFrame,
	})

	U:CreateStroke(lineH, Color3.fromRGB(52, 52, 53), 1)

	local lineHCorner = Instance.new("UICorner")
	lineHCorner.CornerRadius = UDim.new(0, 5)
	lineHCorner.TopLeftRadius = UDim.new(0, 5)
	lineHCorner.TopRightRadius = UDim.new(0, 5)
	lineHCorner.BottomLeftRadius = UDim.new(0, 0)
	lineHCorner.BottomRightRadius = UDim.new(0, 0)
	lineHCorner.Parent = lineH

	-- Title "Exernality"
	local titleLabel = U:Create("TextLabel", {
		Name = "Exernality",
		Position = UDim2.new(0.0525773205, 0, -0.00197628466, 0),
		Size = UDim2.new(0, 236, 0, T.TopbarHeight),
		BackgroundColor3 = scheme.bg,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextSize = T.TextSizeTitle,
		FontFace = T.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = false,
		ZIndex = 1,
		Parent = mainFrame,
	})

	-- Version
	local versionLabel = U:Create("TextLabel", {
		Name = "Version",
		Position = UDim2.new(0.165979385, 0, 0, 0),
		Size = UDim2.new(0, 236, 0, T.TopbarHeight),
		BackgroundColor3 = scheme.bg,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = data.Version or "v1.0",
		TextColor3 = scheme.textDim,
		TextSize = T.TextSizeTitle,
		FontFace = T.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = false,
		ZIndex = 1,
		Parent = mainFrame,
	})

	-- Line2 - Vertical separator (left sidebar background)
	local lineV = U:Create("Frame", {
		Name = "Line2",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, T.SidebarWidth, 0, T.WindowHeight),
		BackgroundTransparency = 1,
		BackgroundColor3 = scheme.white,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 15,
		Parent = mainFrame,
	})

	U:CreateStroke(lineV, scheme.stroke, 1)

	local lineVCorner = Instance.new("UICorner")
	lineVCorner.CornerRadius = UDim.new(0, 5)
	lineVCorner.TopLeftRadius = UDim.new(0, 5)
	lineVCorner.TopRightRadius = UDim.new(0, 0)
	lineVCorner.BottomLeftRadius = UDim.new(0, 5)
	lineVCorner.BottomRightRadius = UDim.new(0, 0)
	lineVCorner.Parent = lineV

	-- Tab_Buttons container
	local tabButtons = U:Create("Frame", {
		Name = "Tab_Buttons",
		Position = UDim2.new(0, 0, 0.154150203, 0),
		Size = UDim2.new(0, T.SidebarWidth, 0, T.WindowHeight - 78),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 1,
		Parent = mainFrame,
	})

	-- Tabs content frame
	local tabsFrame = U:Create("Frame", {
		Name = "Tabs",
		Position = UDim2.new(0.153608248, 0, 0.0770751014, 0),
		Size = UDim2.new(0, T.ContentWidth, 0, T.ContentHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = mainFrame,
	})

	self.Gui = gui
	self.DragContainer = dragContainer
	self.Outline = outline
	self.Main = mainFrame
	self.Logo = logo
	self.LineH = lineH
	self.LineV = lineV
	self.TabButtons = tabButtons
	self.TabsFrame = tabsFrame
	self.TitleLabel = titleLabel
	self.VersionLabel = versionLabel
	self.ContentArea = tabsFrame

	U:MakeDraggable(dragContainer, lineH)

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
	self.DragContainer.Visible = self.Visible
end

function Window:SetVisible(visible)
	self.Visible = visible
	self.DragContainer.Visible = visible
end

return Window
