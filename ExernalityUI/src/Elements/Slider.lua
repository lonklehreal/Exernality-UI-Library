local Slider = {}
Slider.__index = Slider

local UserInputService = game:GetService("UserInputService")

function Slider.new(theme, utility, section)
	local self = setmetatable({}, Slider)
	self.Theme = theme
	self.Utility = utility
	self.Section = section
	self.Frame = nil
	self.Value = 0
	self.Min = 0
	self.Max = 100
	self.Callback = nil
	self.Dragging = false
	return self
end

function Slider:Create(data)
	data = data or {}
	data.Name = data.Name or "Slider"
	data.Callback = data.Callback or function() end
	data.Default = data.Default or 0
	data.Min = data.Min or 0
	data.Max = data.Max or 100
	data.Suffix = data.Suffix or ""
	data.Decimal = data.Decimal or 0

	local scheme = self.Theme:GetScheme()
	local T = self.Theme
	local U = self.Utility
	self.Min = data.Min
	self.Max = data.Max
	self.Value = data.Default
	self.Callback = data.Callback
	self.Suffix = data.Suffix
	self.Decimal = data.Decimal

	local sliderFrame = U:Create("Frame", {
		Name = "Slider_" .. data.Name,
		BackgroundColor3 = scheme.ElementBg,
		BackgroundTransparency = scheme.ElementBgTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -8, 0, 40),
		Parent = self.Section.ElementContainer,
	})

	U:CreateCorner(sliderFrame)

	local nameLabel = U:Create("TextLabel", {
		Name = "Name",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = data.Name,
		TextColor3 = scheme.text,
		TextSize = T.TextSize - 2,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(0.6, -4, 0, 16),
		Position = UDim2.new(0, 6, 0, 3),
		Parent = sliderFrame,
	})

	local valueLabel = U:Create("TextLabel", {
		Name = "Value",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = T.Font,
		Text = tostring(data.Default) .. data.Suffix,
		TextColor3 = scheme.Accent,
		TextSize = T.TextSize - 2,
		TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.new(0.4, -4, 0, 16),
		Position = UDim2.new(0.6, 0, 0, 3),
		Parent = sliderFrame,
	})

	local sliderBg = U:Create("Frame", {
		Name = "SliderBg",
		BackgroundColor3 = scheme.stroke,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -12, 0, 4),
		Position = UDim2.new(0, 6, 0, 24),
		Parent = sliderFrame,
	})

	U:CreateCorner(sliderBg, UDim.new(0, 2))

	local sliderFill = U:Create("Frame", {
		Name = "Fill",
		BackgroundColor3 = scheme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = sliderBg,
	})

	U:CreateCorner(sliderFill, UDim.new(0, 2))

	local sliderKnob = U:Create("Frame", {
		Name = "Knob",
		BackgroundColor3 = scheme.white,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(0, 0, 0.5, -6),
		Parent = sliderFrame,
	})

	U:CreateCorner(sliderKnob, UDim.new(0, 6))
	U:CreateStroke(sliderKnob, scheme.stroke, 1)

	local function updateSlider(inputPos)
		local absPos = sliderBg.AbsolutePosition
		local absSize = sliderBg.AbsoluteSize
		local relX = math.clamp(inputPos.X - absPos.X, 0, absSize.X)
		local pct = absSize.X > 0 and relX / absSize.X or 0
		local value = self.Min + (self.Max - self.Min) * pct
		if self.Decimal > 0 then
			value = math.round(value * (10 ^ self.Decimal)) / (10 ^ self.Decimal)
		else
			value = math.floor(value)
		end
		value = math.clamp(value, self.Min, self.Max)
		self.Value = value
		self:UpdateVisuals()
		data.Callback(value)
	end

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			updateSlider(input)
		end
	end)

	sliderBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)

	self.Frame = sliderFrame
	self.NameLabel = nameLabel
	self.ValueLabel = valueLabel
	self.SliderBg = sliderBg
	self.SliderFill = sliderFill
	self.SliderKnob = sliderKnob

	self:UpdateVisuals()

	return self
end

function Slider:UpdateVisuals()
	local percent = (self.Value - self.Min) / (self.Max - self.Min)
	local absW = self.SliderBg.AbsoluteSize.X
	local fillW = absW > 0 and percent * absW or 0
	self.SliderFill.Size = UDim2.new(0, fillW, 1, 0)
	self.SliderKnob.Position = UDim2.new(0, fillW - 6, 0.5, -6)
	local display = self.Decimal > 0 and string.format("%." .. self.Decimal .. "f", self.Value) or tostring(math.floor(self.Value))
	self.ValueLabel.Text = display .. self.Suffix
end

return Slider
