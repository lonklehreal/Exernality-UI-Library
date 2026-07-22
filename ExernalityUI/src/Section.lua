local Section = {}
Section.__index = Section

function Section.new(theme, utility, tab)
	local self = setmetatable({}, Section)
	self.Theme = theme
	self.Utility = utility
	self.Tab = tab
	self.Window = tab.Window
	self.Elements = {}
	self.Frame = nil
	self.ElementContainer = nil
	return self
end

function Section:Create(data)
	data = data or {}
	data.Name = data.Name or "Section"

	local scheme = self.Theme:GetScheme()

	if not self.Tab.Container then
		local contentScrolling = self.Utility:CreateScrollingFrame(self.Window.ContentArea)
		self.Tab.Container = contentScrolling
		local layout = self.Utility:CreateListLayout(contentScrolling, UDim.new(0, 8))
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	end

	local sectionFrame = Instance.new("Frame")
	sectionFrame.Name = "Section_" .. data.Name
	sectionFrame.BackgroundColor3 = scheme.SectionBackground
	sectionFrame.BorderSizePixel = 0
	sectionFrame.Size = UDim2.new(1, -16, 0, 0)
	sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
	sectionFrame.Parent = self.Tab.Container

	self.Utility:CreateCorner(sectionFrame)
	self.Utility:CreateStroke(sectionFrame, scheme.ElementBorder, 1)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Font = self.Theme.Font
	titleLabel.Text = data.Name
	titleLabel.TextColor3 = scheme.SectionTitle
	titleLabel.TextSize = self.Theme.TextSize + 1
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

	self.Frame = sectionFrame
	self.ElementContainer = elementContainer
	self.TitleLabel = titleLabel

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
