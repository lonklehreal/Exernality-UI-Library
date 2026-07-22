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
	self.Min = data.Min
	self.Max = data.Max
	self.Value = data.Default
	self.Callback = data.Callback
	self.Suffix = data.Suffix
	self.Decimal = data.Decimal

	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = "Slider_" .. data.Name
	sliderFrame.BackgroundColor3 = scheme.ElementBackground
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Size = UDim2.new(1, 0, 0, 48)
	sliderFrame.Parent = self.Section.ElementContainer

	self.Utility:CreateCorner(sliderFrame)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Font = self.Theme.Font
	nameLabel.Text = data.Name or "Slider"
	nameLabel.TextColor3 = scheme.ElementText
	nameLabel.TextSize = self.Theme.TextSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Size = UDim2.new(0.5, -10, 0, 18)
	nameLabel.Position = UDim2.new(0, 10, 0, 6)
	nameLabel.Parent = sliderFrame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.BackgroundTransparency = 1
	valueLabel.BorderSizePixel = 0
	valueLabel.Font = self.Theme.Font
	valueLabel.Text = tostring(data.Default) .. data.Suffix
	valueLabel.TextColor3 = scheme.Accent
	valueLabel.TextSize = self.Theme.TextSize
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0.5, -10, 0, 18)
	valueLabel.Position = UDim2.new(0.5, 0, 0, 6)
	valueLabel.Parent = sliderFrame

	local sliderBg = Instance.new("Frame")
	sliderBg.Name = "SliderBg"
	sliderBg.BackgroundColor3 = scheme.ElementBackgroundHover
	sliderBg.BorderSizePixel = 0
	sliderBg.Size = UDim2.new(1, -20, 0, 6)
	sliderBg.Position = UDim2.new(0, 10, 0, 32)
	sliderBg.Parent = sliderFrame

	self.Utility:CreateCorner(sliderBg, UDim.new(0, 3))

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.BackgroundColor3 = scheme.Accent
	sliderFill.BorderSizePixel = 0
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.Parent = sliderBg

	self.Utility:CreateCorner(sliderFill, UDim.new(0, 3))

	local sliderKnob = Instance.new("Frame")
	sliderKnob.Name = "Knob"
	sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderKnob.BorderSizePixel = 0
	sliderKnob.Size = UDim2.new(0, 14, 0, 14)
	sliderKnob.Position = UDim2.new(0, 0, 0.5, -7)
	sliderKnob.Parent = sliderFrame

	self.Utility:CreateCorner(sliderKnob, UDim.new(0, 7))

	local function updateSlider(inputPos)
		local absPos = sliderBg.AbsolutePosition
		local absSize = sliderBg.AbsoluteSize
		local relativeX = math.clamp(inputPos.X - absPos.X, 0, absSize.X)
		local percent = relativeX / absSize.X
		local value = self.Min + (self.Max - self.Min) * percent
		if self.Decimal > 0 then
			value = math.round(value * (10 ^ self.Decimal)) / (10 ^ self.Decimal)
		else
			value = math.floor(value)
		end
		value = math.clamp(value, self.Min, self.Max)
		self.Value = value
		self:UpdateVisuals()
		self.Callback(value)
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

	local moveConnection = UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

	local endConnection = UserInputService.InputEnded:Connect(function(input)
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
	local fillWidth = percent * (self.SliderBg.AbsoluteSize.X - 14)
	self.SliderFill.Size = UDim2.new(0, fillWidth, 1, 0)
	self.SliderKnob.Position = UDim2.new(0, fillWidth, 0.5, -7)
	local display = self.Value
	if self.Decimal > 0 then
		display = string.format("%." .. self.Decimal .. "f", self.Value)
	else
		display = tostring(math.floor(self.Value))
	end
	self.ValueLabel.Text = display .. self.Suffix
end

return Slider
