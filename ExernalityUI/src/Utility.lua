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
	local inst = Instance.new(class)
	for k, v in props do
		if k ~= "Parent" and k ~= "Children" then
			inst[k] = v
		end
	end
	if props.Children then
		for _, child in ipairs(props.Children) do
			child.Parent = inst
		end
	end
	if props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

function Utility:CreateCorner(parent, radius)
	radius = radius or UDim.new(0, 5)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius
	corner.Parent = parent
	return corner
end

function Utility:CreateStroke(parent, color, thickness, position)
	thickness = thickness or 1
	position = position or Enum.BorderStrokePosition.Outer
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(52, 52, 52)
	stroke.Thickness = thickness
	stroke.BorderStrokePosition = position
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Parent = parent
	return stroke
end

function Utility:CreateShadow(parent, transparency, color, blur)
	transparency = transparency or 0.06
	blur = blur or 25
	local shadow = Instance.new("UIShadow")
	shadow.Name = "UIShadow"
	shadow.BlurRadius = UDim.new(0, blur)
	shadow.Transparency = transparency
	shadow.Color = color or Color3.fromRGB(0, 0, 0)
	shadow.Offset = UDim2.new(0, 0, 0, 0)
	shadow.Spread = UDim2.new(0, 0, 0, 0)
	shadow.Parent = parent
	return shadow
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
	sf.ScrollBarImageTransparency = 0.5
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.ScrollingDirection = Enum.ScrollingDirection.Y
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.Parent = parent
	return sf
end

return Utility
