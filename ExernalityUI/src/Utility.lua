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
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
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
		if k ~= "Children" then
			obj[k] = v
		end
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

function Utility:CreatePadding(parent, padding)
	padding = padding or UDim.new(0, 4)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = padding
	pad.PaddingBottom = padding
	pad.PaddingLeft = padding
	pad.PaddingRight = padding
	pad.Parent = parent
	return pad
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

function Utility:CreateGradient(parent, color, reverse)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color or Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, (color or Color3.fromRGB(0, 0, 0)):Lerp(Color3.fromRGB(255, 255, 255), 0.05)),
	})
	if reverse then
		gradient.Rotation = 180
	end
	gradient.Parent = parent
	return gradient
end

function Utility:CreateOverlay(parent)
	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.6
	overlay.BorderSizePixel = 0
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.new(0, 0, 0, 0)
	overlay.ZIndex = 10
	overlay.Active = true
	overlay.Parent = parent
	return overlay
end

function Utility:CreateImageLabel(props)
	return self:Create("ImageLabel", props)
end

function Utility:CreateTextLabel(props)
	return self:Create("TextLabel", props)
end

function Utility:CreateImageButton(props)
	return self:Create("ImageButton", props)
end

function Utility:CreateTextBox(props)
	return self:Create("TextBox", props)
end

function Utility:CreateFrame(props)
	return self:Create("Frame", props)
end

return Utility
