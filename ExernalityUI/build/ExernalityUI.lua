--[[
	ExernalityUI v1.0
	A modern Roblox UI library
	https://github.com/lonklehreal/Exernality-UI-Library
]]

local ExernalityUI = {}

-- Theme
local Theme = {
	Current = "Dark",
	Font = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	TextSize = 14,
	TextSizeTitle = 20,
	TextSizeSection = 14,
	CornerRadius = UDim.new(0, 5),
	WindowWidth = 970,
	WindowHeight = 506,
	TopbarHeight = 39,
	SidebarWidth = 148,
	SectionWidth = 225,
	SectionHeight = 435,
	ContentWidth = 821,
	ContentHeight = 467,
	ScrollBarThickness = 4,
	NotificationDuration = 5,
	NotificationMax = 5,
	Schemes = {
		Dark = {
			bg = Color3.fromRGB(12, 12, 12),
			text = Color3.fromRGB(211, 211, 211),
			textDim = Color3.fromRGB(106, 106, 106),
			stroke = Color3.fromRGB(52, 52, 52),
			strokeOuter = Color3.fromRGB(39, 39, 39),
			white = Color3.fromRGB(255, 255, 255),
			SectionBg = Color3.fromRGB(255, 255, 255),
			SectionBgTransparency = 0.97,
			Accent = Color3.fromRGB(100, 100, 255),
			AccentHover = Color3.fromRGB(130, 130, 255),
			Success = Color3.fromRGB(80, 200, 80),
			Danger = Color3.fromRGB(220, 60, 60),
			Warning = Color3.fromRGB(240, 180, 40),
			ElementBg = Color3.fromRGB(255, 255, 255),
			ElementBgTransparency = 0.94,
			InputBg = Color3.fromRGB(255, 255, 255),
			InputBgTransparency = 0.94,
			PlaceholderText = Color3.fromRGB(140, 140, 140),
			DropdownBg = Color3.fromRGB(30, 30, 30),
			DropdownHover = Color3.fromRGB(50, 50, 50),
			ScrollBarBg = Color3.fromRGB(40, 40, 40),
			ScrollBarHandle = Color3.fromRGB(80, 80, 80),
		},
	},
}
function Theme:GetScheme() return self.Schemes[self.Current] end
function Theme:SetTheme(n) if self.Schemes[n] then self.Current = n end end

-- Utility
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Utility = {}
function Utility:MakeDraggable(frame, dragHandle)
	dragHandle = dragHandle or frame
	local dragging, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = frame.Position
		end
	end)
	local ic = UserInputService.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			local d = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	local ec = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	return function() ic:Disconnect(); ec:Disconnect() end
end
function Utility:Tween(o, p, d, e, dir)
	return TweenService:Create(o, TweenInfo.new(d or 0.2, e or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), p):Play()
end
function Utility:Create(c, p)
	local i = Instance.new(c)
	for k, v in p do if k ~= "Parent" and k ~= "Children" then i[k] = v end end
	if p.Children then for _, c in ipairs(p.Children) do c.Parent = i end end
	if p.Parent then i.Parent = p.Parent end
	return i
end
function Utility:CreateCorner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = r or UDim.new(0, 5); c.Parent = p; return c
end
function Utility:CreateStroke(p, c, t, pos)
	local s = Instance.new("UIStroke"); s.Color = c or Color3.fromRGB(52, 52, 52); s.Thickness = t or 1; s.BorderStrokePosition = pos or Enum.BorderStrokePosition.Outer; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual; s.Parent = p; return s
end
function Utility:CreateShadow(p, t, c, b)
	local s = Instance.new("UIShadow"); s.Name = "UIShadow"; s.BlurRadius = UDim.new(0, b or 25); s.Transparency = t or 0.06; s.Color = c or Color3.fromRGB(0, 0, 0); s.Parent = p; return s
end
function Utility:CreateListLayout(p, pad, dir)
	local l = Instance.new("UIListLayout"); l.Padding = pad or UDim.new(0, 6); l.FillDirection = dir or Enum.FillDirection.Vertical; l.HorizontalAlignment = Enum.HorizontalAlignment.Center; l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = p; return l
end
function Utility:CreateScrollingFrame(p)
	local sf = Instance.new("ScrollingFrame"); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0; sf.ScrollBarThickness = 4; sf.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80); sf.ScrollBarImageTransparency = 0.5; sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.ScrollingDirection = Enum.ScrollingDirection.Y; sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.Parent = p; return sf
end

-- Notification
local Notification = {}
Notification.__index = Notification
function Notification.new(theme, utility)
	return setmetatable({Theme = theme, Utility = utility, Queue = {}, Processing = false}, Notification)
end
function Notification:SetupContainer()
	if self.Container and self.Container.Parent then return end
	local container = Instance.new("Frame"); container.Name = "NotificationContainer"; container.BackgroundTransparency = 1; container.BorderSizePixel = 0; container.Size = UDim2.new(0, 320, 1, -20); container.Position = UDim2.new(1, -340, 0, 60); container.ZIndex = 100; container.Parent = game:GetService("CoreGui")
	local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 6); ll.FillDirection = Enum.FillDirection.Vertical; ll.HorizontalAlignment = Enum.HorizontalAlignment.Right; ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = container
	self.Container = container
end
function Notification:Notify(data)
	if not self.Container or not self.Container.Parent then self:SetupContainer() end
	data.Title = data.Title or "Notification"; data.Content = data.Content or ""; data.Duration = data.Duration or 5
	table.insert(self.Queue, data); if not self.Processing then self:ProcessQueue() end
end
function Notification:ProcessQueue()
	if #self.Queue == 0 then self.Processing = false return end
	self.Processing = true; local data = table.remove(self.Queue, 1); self:ShowNotification(data)
end
function Notification:ShowNotification(data)
	local scheme = self.Theme:GetScheme(); local T = self.Theme
	local nf = Instance.new("Frame"); nf.Name = "Notification"; nf.BackgroundColor3 = Color3.fromRGB(20, 20, 20); nf.BackgroundTransparency = 0.1; nf.BorderSizePixel = 0; nf.Size = UDim2.new(1, 0, 0, 0); nf.AutomaticSize = Enum.AutomaticSize.Y; nf.ClipsDescendants = true; nf.ZIndex = 100; nf.Parent = self.Container
	local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 5); corner.Parent = nf
	local stroke = Instance.new("UIStroke"); stroke.Color = scheme.stroke; stroke.Thickness = 1; stroke.Parent = nf
	local inf = Instance.new("Frame"); inf.Name = "Inner"; inf.BackgroundTransparency = 1; inf.BorderSizePixel = 0; inf.Size = UDim2.new(1, -12, 1, -12); inf.Position = UDim2.new(0, 6, 0, 6); inf.AutomaticSize = Enum.AutomaticSize.Y; inf.Parent = nf
	local tl = Instance.new("TextLabel"); tl.Name = "Title"; tl.BackgroundTransparency = 1; tl.BorderSizePixel = 0; tl.FontFace = T.Font; tl.Text = data.Title; tl.TextColor3 = scheme.text; tl.TextSize = T.TextSize - 1; tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Size = UDim2.new(1, 0, 0, 18); tl.Parent = inf
	local cl = Instance.new("TextLabel"); cl.Name = "Content"; cl.BackgroundTransparency = 1; cl.BorderSizePixel = 0; cl.FontFace = T.Font; cl.Text = data.Content; cl.TextColor3 = scheme.textDim; cl.TextSize = T.TextSize - 3; cl.TextXAlignment = Enum.TextXAlignment.Left; cl.TextWrapped = true; cl.Size = UDim2.new(1, 0, 0, 0); cl.AutomaticSize = Enum.AutomaticSize.Y; cl.Parent = inf
	nf.Size = UDim2.new(1, 0, 0, 0)
	TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
	task.delay(data.Duration, function()
		if not nf or not nf.Parent then return end
		local to = TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, Position = UDim2.new(1, 50, 0, 0)})
		to.Completed:Connect(function() nf:Destroy(); self:ProcessQueue() end); to:Play()
	end)
end

-- Window
local Window = {}; Window.__index = Window
local Players = game:GetService("Players")
function Window.new(theme, utility, notification)
	return setmetatable({Theme = theme, Utility = utility, Notification = notification, Tabs = {}, ActiveTab = nil, Destroyed = false, Visible = true}, Window)
end
function Window:Create(data)
	data = data or {}; data.Name = data.Name or "Exernality"; data.Version = data.Version or "v1.0"
	local scheme = self.Theme:GetScheme(); local T = self.Theme; local U = self.Utility
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local gui = U:Create("ScreenGui", {Name = "Exernality", ResetOnSpawn = true, ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets, ClipToDeviceSafeArea = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = playerGui})
	local dragContainer = U:Create("Frame", {Name = "DragContainer", Position = UDim2.new(0.19056724, 0, 0.20240964, 0), Size = UDim2.new(0, T.WindowWidth, 0, T.WindowHeight), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = gui})
	local outline = U:Create("Frame", {Name = "ExernalityOutline", Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BackgroundColor3 = scheme.bg, BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 2, Parent = dragContainer})
	U:CreateStroke(outline, Color3.fromRGB(138, 138, 138), 1, Enum.BorderStrokePosition.Outer); U:CreateCorner(outline)
	local mainFrame = U:Create("Frame", {Name = "Exernality", Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = scheme.bg, BackgroundTransparency = 0, BorderSizePixel = 0, 	ClipsDescendants = false, ZIndex = 1, Parent = dragContainer})
	U:CreateShadow(mainFrame, 0.06, Color3.fromRGB(0, 0, 0), 25); U:CreateCorner(mainFrame)
	local logo = U:Create("ImageLabel", {Name = "ImageLabel", Position = UDim2.new(0.010309278, 0, 0.0118577071, 0), Size = UDim2.new(0, 27, 0, 27), BackgroundColor3 = scheme.white, BackgroundTransparency = 0, BorderSizePixel = 0, Image = data.Logo or "rbxassetid://94904426200943", ImageColor3 = scheme.white, ScaleType = Enum.ScaleType.Stretch, Parent = mainFrame})
	U:CreateStroke(logo, scheme.strokeOuter, 1)
	local lineH = U:Create("Frame", {Name = "Line", Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, T.TopbarHeight), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 15, Parent = mainFrame})
	U:CreateStroke(lineH, Color3.fromRGB(52, 52, 53), 1)
	local lhc = Instance.new("UICorner"); lhc.CornerRadius = UDim.new(0, 5); lhc.TopLeftRadius = UDim.new(0, 5); lhc.TopRightRadius = UDim.new(0, 5); lhc.BottomLeftRadius = UDim.new(0, 0); lhc.BottomRightRadius = UDim.new(0, 0); lhc.Parent = lineH
	local titleLabel = U:Create("TextLabel", {Name = "Exernality", Position = UDim2.new(0.0525773205, 0, -0.00197628466, 0), Size = UDim2.new(0, 236, 0, T.TopbarHeight), BackgroundColor3 = scheme.bg, BackgroundTransparency = 0, BorderSizePixel = 0, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSizeTitle, FontFace = T.Font, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, Parent = mainFrame})
	local versionLabel = U:Create("TextLabel", {Name = "Version", Position = UDim2.new(0.165979385, 0, 0, 0), Size = UDim2.new(0, 236, 0, T.TopbarHeight), BackgroundColor3 = scheme.bg, BackgroundTransparency = 0, BorderSizePixel = 0, Text = data.Version, TextColor3 = scheme.textDim, TextSize = T.TextSizeTitle, FontFace = T.Font, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, Parent = mainFrame})
	local lineV = U:Create("Frame", {Name = "Line2", Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, T.SidebarWidth, 0, T.WindowHeight), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 15, Parent = mainFrame})
	U:CreateStroke(lineV, scheme.stroke, 1)
	local lvc = Instance.new("UICorner"); lvc.CornerRadius = UDim.new(0, 5); lvc.TopLeftRadius = UDim.new(0, 5); lvc.TopRightRadius = UDim.new(0, 0); lvc.BottomLeftRadius = UDim.new(0, 5); lvc.BottomRightRadius = UDim.new(0, 0); lvc.Parent = lineV
	local tabButtons = U:Create("Frame", {Name = "Tab_Buttons", Position = UDim2.new(0, 0, 0.154150203, 0), Size = UDim2.new(0, T.SidebarWidth, 0, T.WindowHeight - 78), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = false, Parent = mainFrame})
	local tabsFrame = U:Create("Frame", {Name = "Tabs", Position = UDim2.new(0.153608248, 0, 0.0770751014, 0), Size = UDim2.new(0, T.ContentWidth, 0, T.ContentHeight), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Parent = mainFrame})
	self.Gui = gui; self.DragContainer = dragContainer; self.Outline = outline; self.Main = mainFrame; self.Logo = logo; self.LineH = lineH; self.LineV = lineV; self.TabButtons = tabButtons; self.TabsFrame = tabsFrame; self.TitleLabel = titleLabel; self.VersionLabel = versionLabel; self.ContentArea = tabsFrame
	U:MakeDraggable(dragContainer, lineH)
	return self
end
function Window:CreateTab(data)
	data = data or {}; data.Name = data.Name or "Tab"; data.Icon = data.Icon or ""
	local scheme = self.Theme:GetScheme(); local T = self.Theme; local U = self.Utility
	local tabIndex = #self.Tabs + 1
	local strokePos = tabIndex % 2 == 1 and Enum.BorderStrokePosition.Inner or Enum.BorderStrokePosition.Outer
	local btn = U:Create("ImageButton", {Name = data.Name, Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 39), Size = UDim2.new(0, T.SidebarWidth, 0, 39), BackgroundColor3 = scheme.bg, BorderSizePixel = 0, Image = data.Icon, ImageColor3 = scheme.text, ClipsDescendants = false, Parent = self.TabButtons})
	U:CreateStroke(btn, scheme.stroke, 1, strokePos)
	local icon
	if data.Icon and data.Icon ~= "" then
		icon = U:Create("ImageLabel", {Name = "ImageLabel", Position = UDim2.new(0.0738255009, 0, 0.179487184, 0), Size = UDim2.new(0, 25, 0, 25), BackgroundTransparency = 1, BorderSizePixel = 0, Image = data.Icon, ImageColor3 = scheme.text, ScaleType = Enum.ScaleType.Stretch, ZIndex = 2, Parent = btn})
	end
	local nml = U:Create("TextLabel", {Name = "Exernality", Position = UDim2.new(0.341167688, 0, -0.00197660015, 0), Size = UDim2.new(0, 97, 0, 39), BackgroundTransparency = 1, BorderSizePixel = 0, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSizeTitle, FontFace = T.Font, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 2, Parent = btn})
	local tabFrame = U:Create("Frame", {Name = data.Name, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, T.ContentWidth, 0, T.ContentHeight), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = false, Visible = false, Parent = self.TabsFrame})
	local tab = {Button = btn, Icon = icon, NameLabel = nml, Container = tabFrame, Sections = {}, Active = false, Window = self, Theme = self.Theme, Utility = self.Utility}
	tab.SetActive = function(self, active)
		self.Active = active
		if self.Container then self.Container.Visible = active end
		if self.Icon then self.Icon.ImageColor3 = active and scheme.text or scheme.textDim end
	end
	tab.CreateSection = function(self, data)
		data = data or {}; data.Name = data.Name or "Section"
		local secScheme = self.Theme:GetScheme(); local secT = self.Theme; local secU = self.Utility
		local col = #self.Sections % 3; local row = math.floor(#self.Sections / 3)
		local section = secU:Create("Frame", {Name = data.Name, Position = UDim2.new(0.0199999046 + col * 0.28125, 0, 0.0342612416 + row * 0.468, 0), Size = UDim2.new(0, secT.SectionWidth, 0, secT.SectionHeight), BackgroundColor3 = secScheme.SectionBg, BackgroundTransparency = secScheme.SectionBgTransparency, BorderSizePixel = 0, Parent = self.Container})
		secU:CreateStroke(section, secScheme.stroke, 1)
		local hl = secU:Create("TextLabel", {Name = "TextLabel", Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, secT.SectionWidth, 0, 23), BackgroundColor3 = secScheme.SectionBg, BackgroundTransparency = 0.9599999785423279, BorderSizePixel = 0, Text = data.Name, TextColor3 = secScheme.text, TextSize = secT.TextSizeSection, FontFace = secT.Font, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, Parent = section})
		secU:CreateStroke(hl, secScheme.stroke, 1)
		local bc = secU:Create("Frame", {Name = "Buttons", Position = UDim2.new(-0.000690646702, 0, 0.052873563, 0), Size = UDim2.new(0, secT.SectionWidth, 0, 412), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = section})
		local sf = secU:CreateScrollingFrame(bc)
		local lay = secU:CreateListLayout(sf, UDim.new(0, 4)); lay.HorizontalAlignment = Enum.HorizontalAlignment.Left
		local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 4); pad.PaddingLeft = UDim.new(0, 4); pad.PaddingRight = UDim.new(0, 4); pad.Parent = sf
		local s = {Frame = section, HeaderLabel = hl, ElementContainer = sf, Elements = {}, Theme = self.Theme, Utility = self.Utility}
		local elementTypes = {"Button","Toggle","Slider","Dropdown","Keybind","Textbox","ColorPicker","Paragraph","Label"}
		for _, methodName in ipairs(elementTypes) do
			local name = methodName
			s["Create" .. name] = function(_, d) return createElement(name, s, d) end
		end
		table.insert(self.Sections, s); return s
	end
	btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
	table.insert(self.Tabs, tab)
	if not self.ActiveTab then self:SelectTab(tab) end
	return tab
end
function Window:SelectTab(tab)
	if self.ActiveTab then self.ActiveTab:SetActive(false) end
	self.ActiveTab = tab; tab:SetActive(true)
end
function Window:Notify(data)
	local n = Notification.new(self.Theme, self.Utility); n:SetupContainer(); n:Notify(data)
end
function Window:Destroy()
	if self.Gui then self.Gui:Destroy() end; self.Destroyed = true
end
function Window:Toggle()
	self.Visible = not self.Visible; self.DragContainer.Visible = self.Visible
end

-- Element factory functions
local function createButton(section, data)
	data = data or {}; data.Name = data.Name or "Button"; data.Callback = data.Callback or function() end
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local f = U:Create("Frame", {Name = "Button_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 32), Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 1, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.6, -4, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	local btn = U:Create("TextButton", {Name = "Button", BackgroundColor3 = scheme.Accent, BorderSizePixel = 0, FontFace = T.Font, Text = "Activate", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = T.TextSize - 2, Size = UDim2.new(0, 0, 0, 24), Position = UDim2.new(1, -6, 0.5, -12), AutomaticSize = Enum.AutomaticSize.X, Parent = f})
	U:CreateCorner(btn)
	btn.MouseButton1Click:Connect(data.Callback)
	btn.MouseEnter:Connect(function() U:Tween(btn, {BackgroundColor3 = scheme.AccentHover}, 0.15) end)
	btn.MouseLeave:Connect(function() U:Tween(btn, {BackgroundColor3 = scheme.Accent}, 0.15) end)
	return f
end
local function createToggle(section, data)
	data = data or {}; data.Name = data.Name or "Toggle"; data.Callback = data.Callback or function() end; data.Default = data.Default or false
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local value = data.Default
	local f = U:Create("TextButton", {Name = "Toggle_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 32), FontFace = Enum.Font.SourceSans, Text = "", Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 1, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.6, -4, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	local bg = U:Create("Frame", {Name = "ToggleBg", BackgroundColor3 = scheme.stroke, BorderSizePixel = 0, Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -42, 0.5, -9), Parent = f})
	U:CreateCorner(bg, UDim.new(0, 9))
	local circle = U:Create("Frame", {Name = "Circle", BackgroundColor3 = scheme.textDim, BorderSizePixel = 0, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), Parent = bg})
	U:CreateCorner(circle, UDim.new(0, 7))
	local function update()
		if value then
			U:Tween(bg, {BackgroundColor3 = scheme.Accent}, 0.15); U:Tween(circle, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 20, 0.5, -7)}, 0.15)
		else
			U:Tween(bg, {BackgroundColor3 = scheme.stroke}, 0.15); U:Tween(circle, {BackgroundColor3 = scheme.textDim, Position = UDim2.new(0, 2, 0.5, -7)}, 0.15)
		end
	end
	f.MouseButton1Click:Connect(function() value = not value; update(); data.Callback(value) end)
	update(); return f
end
local function createSlider(section, data)
	data = data or {}; data.Name = data.Name or "Slider"; data.Callback = data.Callback or function() end; data.Default = data.Default or 0; data.Min = data.Min or 0; data.Max = data.Max or 100; data.Suffix = data.Suffix or ""; data.Decimal = data.Decimal or 0
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local min, max, value, dragging = data.Min, data.Max, data.Default, false
	local f = U:Create("Frame", {Name = "Slider_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 40), Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.6, -4, 0, 16), Position = UDim2.new(0, 6, 0, 3), Parent = f})
	local vl = U:Create("TextLabel", {Name = "Value", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = tostring(data.Default) .. data.Suffix, TextColor3 = scheme.Accent, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Right, Size = UDim2.new(0.4, -4, 0, 16), Position = UDim2.new(0.6, 0, 0, 3), Parent = f})
	local sbg = U:Create("Frame", {Name = "SliderBg", BackgroundColor3 = scheme.stroke, BorderSizePixel = 0, Size = UDim2.new(1, -12, 0, 4), Position = UDim2.new(0, 6, 0, 24), Parent = f})
	U:CreateCorner(sbg, UDim.new(0, 2))
	local sfill = U:Create("Frame", {Name = "Fill", BackgroundColor3 = scheme.Accent, BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0), Parent = sbg})
	U:CreateCorner(sfill, UDim.new(0, 2))
	local sknob = U:Create("Frame", {Name = "Knob", BackgroundColor3 = scheme.white, BorderSizePixel = 0, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 0, 0.5, -6), Parent = f})
	U:CreateCorner(sknob, UDim.new(0, 6)); U:CreateStroke(sknob, scheme.stroke, 1)
	local function upd(pos)
		local ax = sbg.AbsolutePosition; local as = sbg.AbsoluteSize; local rx = math.clamp(pos.X - ax.X, 0, as.X); local pct = as.X > 0 and rx / as.X or 0
		value = min + (max - min) * pct; if data.Decimal > 0 then value = math.round(value * (10^data.Decimal)) / (10^data.Decimal) else value = math.floor(value) end; value = math.clamp(value, min, max)
		local fw = pct * (as.X - 12); sfill.Size = UDim2.new(0, fw, 1, 0); sknob.Position = UDim2.new(0, fw - 6, 0.5, -6)
		vl.Text = (data.Decimal > 0 and string.format("%."..data.Decimal.."f", value) or tostring(math.floor(value))) .. data.Suffix; data.Callback(value)
	end
	sbg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; upd(i) end end)
	sbg.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	return f
end
local function createDropdown(section, data)
	data = data or {}; data.Name = data.Name or "Dropdown"; data.Callback = data.Callback or function() end; data.Options = data.Options or {}; data.Default = data.Default or ""
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local selected, open, dl = data.Default, false, nil
	local f = U:Create("TextButton", {Name = "Dropdown_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 32), FontFace = Enum.Font.SourceSans, Text = "", Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	local vl = U:Create("TextLabel", {Name = "Value", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Default ~= "" and tostring(data.Default) or "Select...", TextColor3 = data.Default ~= "" and scheme.text or scheme.PlaceholderText, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Right, Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Parent = f})
	f.MouseButton1Click:Connect(function()
		open = not open
		if open then
			dl = U:Create("Frame", {Name = "DropdownList", BackgroundColor3 = scheme.DropdownBg, BorderSizePixel = 0, Size = UDim2.new(0, f.AbsoluteSize.X - 8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 4, 0, f.AbsoluteSize.Y + 1), ZIndex = 50, Parent = section.ElementContainer})
			U:CreateCorner(dl); U:CreateStroke(dl, scheme.stroke, 1)
			local lay = U:CreateListLayout(dl, UDim.new(0, 0))
			for _, opt in ipairs(data.Options) do
				local ob = U:Create("TextButton", {BackgroundTransparency = 0.8, BorderSizePixel = 0, FontFace = T.Font, Text = tostring(opt), TextColor3 = scheme.text, TextSize = T.TextSize - 2, Size = UDim2.new(1, 0, 0, 26), Parent = dl})
				ob.MouseEnter:Connect(function() U:Tween(ob, {BackgroundTransparency = 0.6}, 0.1) end)
				ob.MouseLeave:Connect(function() U:Tween(ob, {BackgroundTransparency = 0.8}, 0.1) end)
				ob.MouseButton1Click:Connect(function() selected = opt; vl.Text = tostring(opt); vl.TextColor3 = scheme.text; if dl then dl:Destroy() dl = nil end; open = false; data.Callback(opt) end)
			end
		elseif dl then dl:Destroy(); dl = nil end
	end)
	return f
end
local function createKeybind(section, data)
	data = data or {}; data.Name = data.Name or "Keybind"; data.Callback = data.Callback or function() end; data.Default = data.Default or Enum.KeyCode.F
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local key, listening = data.Default, false
	local f = U:Create("Frame", {Name = "Keybind_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 32), Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	local kb = U:Create("TextButton", {Name = "Key", BackgroundColor3 = scheme.bg, BorderSizePixel = 0, FontFace = T.Font, Text = data.Default.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 2, Size = UDim2.new(0, 60, 0, 24), Position = UDim2.new(1, -66, 0.5, -12), Parent = f})
	U:CreateCorner(kb)
	kb.MouseButton1Click:Connect(function()
		listening = true; kb.Text = "..."; kb.TextColor3 = scheme.Accent
		local conn; conn = UserInputService.InputBegan:Connect(function(input, proc)
			if proc then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then key = input.KeyCode; kb.Text = key.Name; kb.TextColor3 = scheme.text; listening = false; conn:Disconnect() end
		end)
	end)
	UserInputService.InputBegan:Connect(function(input, proc)
		if proc or listening then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then data.Callback(key) end
	end)
	return f
end
local function createTextbox(section, data)
	data = data or {}; data.Name = data.Name or "Textbox"; data.Callback = data.Callback or function() end; data.Default = data.Default or ""; data.Placeholder = data.Placeholder or "Enter text..."; data.ClearTextOnFocus = data.ClearTextOnFocus or false
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local f = U:Create("Frame", {Name = "Textbox_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 32), Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.35, -4, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	local ib = U:Create("TextBox", {Name = "Input", BackgroundColor3 = scheme.bg, BorderSizePixel = 0, FontFace = T.Font, Text = data.Default, PlaceholderText = data.Placeholder, PlaceholderColor3 = scheme.PlaceholderText, TextColor3 = scheme.text, TextSize = T.TextSize - 2, Size = UDim2.new(0.6, -8, 0, 24), Position = UDim2.new(0.35, 0, 0.5, -12), ClearTextOnFocus = data.ClearTextOnFocus, Parent = f})
	U:CreateCorner(ib)
	ib.FocusLost:Connect(function() data.Callback(ib.Text) end)
	return f
end
local function createColorPicker(section, data)
	data = data or {}; data.Name = data.Name or "ColorPicker"; data.Callback = data.Callback or function() end; data.Default = data.Default or Color3.fromRGB(255, 255, 255)
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local colorVal, open, pc = data.Default, false, nil
	local f = U:Create("TextButton", {Name = "ColorPicker_" .. data.Name, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 32), FontFace = Enum.Font.SourceSans, Text = "", Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Name", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Name, TextColor3 = scheme.text, TextSize = T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	local preview = U:Create("Frame", {Name = "Preview", BackgroundColor3 = data.Default, BorderSizePixel = 0, Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -28, 0.5, -11), Parent = f})
	U:CreateCorner(preview, UDim.new(0, 4)); U:CreateStroke(preview, scheme.stroke, 1)
	f.MouseButton1Click:Connect(function()
		open = not open
		if open then
			pc = U:Create("Frame", {Name = "PickerContainer", BackgroundColor3 = scheme.DropdownBg, BorderSizePixel = 0, Size = UDim2.new(0, f.AbsoluteSize.X, 0, 140), Position = UDim2.new(0, 4, 0, f.AbsoluteSize.Y + 1), ZIndex = 50, Parent = section.ElementContainer})
			U:CreateCorner(pc); U:CreateStroke(pc, scheme.stroke, 1)
			local si = U:Create("ImageLabel", {Name = "Saturation", BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0, Size = UDim2.new(1, -16, 1, -50), Position = UDim2.new(0, 8, 0, 8), Image = "rbxassetid://4155801252", ImageColor3 = Color3.fromRGB(255, 255, 255), Parent = pc})
			U:CreateCorner(si)
			local hb = U:Create("Frame", {Name = "Hue", BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0, Size = UDim2.new(1, -16, 0, 14), Position = UDim2.new(0, 8, 0, pc.AbsoluteSize.Y - 22), Parent = pc})
			local hg = Instance.new("UIGradient"); hg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}); hg.Parent = hb
		elseif pc then pc:Destroy(); pc = nil end
	end)
	return f
end
local function createParagraph(section, data)
	data = data or {}; data.Title = data.Title or "Paragraph"; data.Content = data.Content or ""
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local f = U:Create("Frame", {Name = "Paragraph_" .. data.Title, BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Title", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Title, TextColor3 = scheme.text, TextSize = T.TextSize - 1, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, -12, 0, 18), Position = UDim2.new(0, 6, 0, 4), Parent = f})
	U:Create("TextLabel", {Name = "Content", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Content, TextColor3 = scheme.textDim, TextSize = T.TextSize - 3, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, RichText = true, Size = UDim2.new(1, -12, 0, 0), Position = UDim2.new(0, 6, 0, 24), AutomaticSize = Enum.AutomaticSize.Y, Parent = f})
	return f
end
local function createLabel(section, data)
	data = data or {}; data.Text = data.Text or "Label"; data.Color = data.Color or nil; data.TextSize = data.TextSize or nil
	local scheme = section.Theme:GetScheme(); local T = section.Theme; local U = section.Utility
	local f = U:Create("Frame", {Name = "Label", BackgroundColor3 = scheme.ElementBg, BackgroundTransparency = scheme.ElementBgTransparency, BorderSizePixel = 0, Size = UDim2.new(1, -8, 0, 24), Parent = section.ElementContainer})
	U:CreateCorner(f)
	U:Create("TextLabel", {Name = "Text", BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = T.Font, Text = data.Text, TextColor3 = data.Color or scheme.textDim, TextSize = data.TextSize or T.TextSize - 2, TextXAlignment = Enum.TextXAlignment.Left, RichText = true, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = f})
	return f
end
local function createElement(type, section, data)
	if type == "Button" then return createButton(section, data)
	elseif type == "Toggle" then return createToggle(section, data)
	elseif type == "Slider" then return createSlider(section, data)
	elseif type == "Dropdown" then return createDropdown(section, data)
	elseif type == "Keybind" then return createKeybind(section, data)
	elseif type == "Textbox" then return createTextbox(section, data)
	elseif type == "ColorPicker" then return createColorPicker(section, data)
	elseif type == "Paragraph" then return createParagraph(section, data)
	elseif type == "Label" then return createLabel(section, data) end
end

-- Public API
function ExernalityUI:CreateWindow(data)
	local n = Notification.new(Theme, Utility); n:SetupContainer()
	local w = Window.new(Theme, Utility, n); w:Create(data); return w
end
function ExernalityUI:SetTheme(n) Theme:SetTheme(n) end
function ExernalityUI:GetTheme() return Theme.Current end
function ExernalityUI:GetThemes()
	local t = {}; for k in pairs(Theme.Schemes) do table.insert(t, k) end; return t
end

return ExernalityUI
