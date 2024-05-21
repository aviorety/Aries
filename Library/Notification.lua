local TweenService = game:GetService('TweenService')

local Notification = {}
Notification.assets = {
    neutral = game:GetObjects('rbxassetid://17570163098')[1],
    warning = game:GetObjects('rbxassetid://17570166913')[1],
    danger = game:GetObjects('rbxassetid://17570168982')[1]
}


function Notification:create()
    if not Notification.assets[self.__type] then
        return
    end

    local notification = Notification.assets[self.__type]:Clone()
    notification.Parent = self.container.Notifications
    notification.UIScale.Scale = 0

    TweenService:Create(notification.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
        Scale = 1
    }):Play()

    local notification_time = Instance.new('NumberValue', notification)
    notification_time.Value = 1
    notification_time.Name = 'notification_time'

    TweenService:Create(notification_time, TweenInfo.new(self.__time), {
        Value = 0
    }):Play()

    notification_time.Changed:Connect(function()
        notification.Fill.UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(notification_time.Value, 0),
            NumberSequenceKeypoint.new(math.min(notification_time.Value + 0.01, 1), 1),
            NumberSequenceKeypoint.new(1, 1)
        })
    end)

    task.delay(self.__time, function()
        TweenService:Create(notification.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Scale = 0
        }):Play()
    end)
end


return Notification