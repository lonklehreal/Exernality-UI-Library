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

function Theme:GetScheme()
	return self.Schemes[self.Current]
end

function Theme:SetTheme(name)
	if self.Schemes[name] then
		self.Current = name
	end
end

return Theme
