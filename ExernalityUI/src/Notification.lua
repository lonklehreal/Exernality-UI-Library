local Notification = {}
Notification.__index = Notification

local TweenService = game:GetService("TweenService")

function Notification.new(theme, utility)
	local self = setmetatable({}, Notification)
	self.Theme = theme
	self.Utility = utility
	self.Queue = {}
	self.Processing = false
	self.Container = nil
	return self
end

function Notification:SetupContainer()
	if self.Container and self.Container.Parent then return end

	local container = Instance.new("Frame")
	container.Name = "NotificationContainer"
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Size = UDim2.new(0, 320, 1, -20)
	container.Position = UDim2.new(1, -340, 0, 60)
	container.ZIndex = 100
	container.Parent = game:GetService("CoreGui")

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 6)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = container

	self.Container = container
end

function Notification:Notify(data)
	if not self.Container or not self.Container.Parent then self:SetupContainer() end
	data.Title = data.Title or "Notification"
	data.Content = data.Content or ""
	data.Duration = data.Duration or 5
	table.insert(self.Queue, data)
	if not self.Processing then self:ProcessQueue() end
end

function Notification:ProcessQueue()
	if #self.Queue == 0 then self.Processing = false return end
	self.Processing = true
	local data = table.remove(self.Queue, 1)
	self:ShowNotification(data)
end

function Notification:ShowNotification(data)
	local scheme = self.Theme:GetScheme()
	local T = self.Theme

	local notifFrame = Instance.new("Frame")
	notifFrame.Name = "Notification"
	notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	notifFrame.BackgroundTransparency = 0.1
	notifFrame.BorderSizePixel = 0
	notifFrame.Size = UDim2.new(1, 0, 0, 0)
	notifFrame.AutomaticSize = Enum.AutomaticSize.Y
	notifFrame.ClipsDescendants = true
	notifFrame.ZIndex = 100
	notifFrame.Parent = self.Container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = notifFrame

	local stroke = Instance.new("UIStroke")
	stroke.Color = scheme.stroke
	stroke.Thickness = 1
	stroke.Parent = notifFrame

	local innerFrame = Instance.new("Frame")
	innerFrame.Name = "Inner"
	innerFrame.BackgroundTransparency = 1
	innerFrame.BorderSizePixel = 0
	innerFrame.Size = UDim2.new(1, -12, 1, -12)
	innerFrame.Position = UDim2.new(0, 6, 0, 6)
	innerFrame.AutomaticSize = Enum.AutomaticSize.Y
	innerFrame.Parent = notifFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.FontFace = T.Font
	titleLabel.Text = data.Title
	titleLabel.TextColor3 = scheme.text
	titleLabel.TextSize = T.TextSize - 1
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, 0, 0, 18)
	titleLabel.Parent = innerFrame

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Name = "Content"
	contentLabel.BackgroundTransparency = 1
	contentLabel.BorderSizePixel = 0
	contentLabel.FontFace = T.Font
	contentLabel.Text = data.Content
	contentLabel.TextColor3 = scheme.textDim
	contentLabel.TextSize = T.TextSize - 3
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.Size = UDim2.new(1, 0, 0, 0)
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Parent = innerFrame

	notifFrame.Size = UDim2.new(1, 0, 0, 0)

	local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	})
	tweenIn:Play()

	task.delay(data.Duration, function()
		if not notifFrame or not notifFrame.Parent then return end
		local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 50, 0, 0)
		})
		tweenOut.Completed:Connect(function()
			notifFrame:Destroy()
			self:ProcessQueue()
		end)
		tweenOut:Play()
	end)
end

return Notification
