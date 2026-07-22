local Section = {}
Section.__index = Section

local SECTION_X_OFFSET = 0.0199999046
local SECTION_X_STEP = 0.28125
local SECTION_Y_OFFSET = 0.0342612416
local SECTION_Y_STEP = 0.468

function Section.new(theme, utility, tab)
	local self = setmetatable({}, Section)
	self.Theme = theme
	self.Utility = utility
	self.Tab = tab
	self.Window = tab.Window
	self.Elements = {}
	self.Frame = nil
	self.ElementContainer = nil
	self.Index = #tab.Sections + 1
	return self
end

function Section:Create(data)
	data = data or {}
	data.Name = data.Name or "Section"

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility

	local col = (self.Index - 1) % 3
	local row = math.floor((self.Index - 1) / 3)

	local section = U:Create("Frame", {
		Name = data.Name,
		Position = UDim2.new(SECTION_X_OFFSET + col * SECTION_X_STEP, 0, SECTION_Y_OFFSET + row * SECTION_Y_STEP, 0),
		Size = UDim2.new(0, T.SectionWidth, 0, T.SectionHeight),
		BackgroundColor3 = scheme.SectionBg,
		BackgroundTransparency = scheme.SectionBgTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 1,
		Parent = self.Tab.Container,
	})

	U:CreateStroke(section, scheme.stroke, 1)

	-- Section header
	local headerLabel = U:Create("TextLabel", {
		Name = "TextLabel",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, T.SectionWidth, 0, 23),
		BackgroundColor3 = scheme.SectionBg,
		BackgroundTransparency = 0.9599999785423279,
		BorderSizePixel = 0,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextTransparency = 0,
		TextSize = T.TextSizeSection,
		FontFace = T.Font,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		RichText = false,
		ZIndex = 1,
		Parent = section,
	})

	U:CreateStroke(headerLabel, scheme.stroke, 1, Enum.BorderStrokePosition.Outer)

	-- Buttons container (element holder)
	local buttonsContainer = U:Create("Frame", {
		Name = "Buttons",
		Position = UDim2.new(-0.000690646702, 0, 0.052873563, 0),
		Size = UDim2.new(0, T.SectionWidth, 0, 412),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 1,
		Parent = section,
	})

	local scrollingFrame = U:CreateScrollingFrame(buttonsContainer)

	local layout = U:CreateListLayout(scrollingFrame, UDim.new(0, 4))
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)
	pad.Parent = scrollingFrame

	self.Frame = section
	self.HeaderLabel = headerLabel
	self.ElementContainer = scrollingFrame

	return self
end

function Section:CreateButton(data)
	local Button = require(script.Parent.Elements.Button)
	local btn = Button.new(self.Theme, self.Utility, self)
	btn:Create(data)
	table.insert(self.Elements, btn)
	return btn
end

function Section:CreateToggle(data)
	local Toggle = require(script.Parent.Elements.Toggle)
	local toggle = Toggle.new(self.Theme, self.Utility, self)
	toggle:Create(data)
	table.insert(self.Elements, toggle)
	return toggle
end

function Section:CreateSlider(data)
	local Slider = require(script.Parent.Elements.Slider)
	local slider = Slider.new(self.Theme, self.Utility, self)
	slider:Create(data)
	table.insert(self.Elements, slider)
	return slider
end

function Section:CreateDropdown(data)
	local Dropdown = require(script.Parent.Elements.Dropdown)
	local dropdown = Dropdown.new(self.Theme, self.Utility, self)
	dropdown:Create(data)
	table.insert(self.Elements, dropdown)
	return dropdown
end

function Section:CreateKeybind(data)
	local Keybind = require(script.Parent.Elements.Keybind)
	local keybind = Keybind.new(self.Theme, self.Utility, self)
	keybind:Create(data)
	table.insert(self.Elements, keybind)
	return keybind
end

function Section:CreateTextbox(data)
	local Textbox = require(script.Parent.Elements.Textbox)
	local textbox = Textbox.new(self.Theme, self.Utility, self)
	textbox:Create(data)
	table.insert(self.Elements, textbox)
	return textbox
end

function Section:CreateColorPicker(data)
	local ColorPicker = require(script.Parent.Elements.ColorPicker)
	local cp = ColorPicker.new(self.Theme, self.Utility, self)
	cp:Create(data)
	table.insert(self.Elements, cp)
	return cp
end

function Section:CreateParagraph(data)
	local Paragraph = require(script.Parent.Elements.Paragraph)
	local para = Paragraph.new(self.Theme, self.Utility, self)
	para:Create(data)
	table.insert(self.Elements, para)
	return para
end

function Section:CreateLabel(data)
	local Label = require(script.Parent.Elements.Label)
	local label = Label.new(self.Theme, self.Utility, self)
	label:Create(data)
	table.insert(self.Elements, label)
	return label
end

return Section
