local UserInputService = game:GetService('UserInputService')
local LocalPlayer = game:GetService('Players').LocalPlayer
local TweenService = game:GetService('TweenService')

local mouse = LocalPlayer:GetMouse()

local Slider = {}
Slider.asset = game:GetObjects('rbxassetid://17559874621')[1]
warn(Slider.asset)


function Slider:update()
    local result = nil

    if self.mouse then
        result = math.clamp((mouse.X - self.slider.Box.AbsolutePosition.X) / self.slider.Box.AbsoluteSize.X, 0, 1)
    else
        --result = math.clamp((self.value - ) / self.slider.Box.AbsolutePosition.X / self.slider.Box.AbsoluteSize.X, 0, 1)
    end

    if not result then
        return
    end

    local number = math.floor(((self.maximum_value - self.minimum_value) * result) + self.minimum_value)
    local slider_size = math.clamp(result, 0.001, 0.999)
    
    self.slider.Box.Fill.UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(slider_size, 0),
        NumberSequenceKeypoint.new(math.min(slider_size + 0.1, 1), 1),
        NumberSequenceKeypoint.new(1, 1)
    })

    TweenService:Create(self.slider_value, TweenInfo.new(0.5), {
        Value = number
    }):Play()

    self.Library.flags[self.flag] = number
    self.callback(number)
end


function Slider:loop()
    self.Library.slider_drag = true
			
    while self.Library.slider_drag do
        Slider.update(self)
        
        task.wait()
    end
end


function Slider:create()
    local slider = Slider.asset:Clone()
    slider.Parent = self.section.Modules
    slider.SliderName.Text = self.name
    slider.SliderValue.Text = self.value

    local slider_value = Instance.new('NumberValue', slider)
    slider_value.Name = 'slider_value'

    slider.Box.Hitbox.MouseButton1Down:Connect(function()
        if self.Library.slider_drag then
            return
        end

        Slider.loop({
            Library = self.Library,
            slider = slider,

            mouse = true,
            flag = self.flag,
            callback = self.callback,

            maximum_value = self.maximum_value,
            minimum_value = self.minimum_value,
            slider_value = slider_value
        })
    end)

    slider_value:GetPropertyChangedSignal('Value'):Connect(function()
        slider.SliderValue.Text = slider_value.Value
    end)
    
    UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Library.slider_drag = false
            Library.save_flags()
        end
    end)

    return toggle
end


return Slider