local TweenService = game:GetService('TweenService')

local Toggle = {}


function Toggle:enable()
    TweenService:Create(self.Box.Fill, TweenInfo.new(0.4), {
        ImageTransparency = 0
    }):Play()

    TweenService:Create(self.Box.Circle, TweenInfo.new(0.4), {
        BackgroundColor3 = Color3.fromRGB(123, 121, 218),
        Position = UDim2.new(0.7, 0, 0.5, 0)
    }):Play()
end


function Toggle:disable()
    TweenService:Create(self.Box.Fill, TweenInfo.new(0.4), {
        ImageTransparency = 1
    }):Play()

    TweenService:Create(self.Box.Circle, TweenInfo.new(0.4), {
        BackgroundColor3 = Color3.fromRGB(26, 26, 34),
        Position = UDim2.new(0.25, 0, 0.5, 0)
    }):Play()
end


function Toggle:create()
    local toggle = game:GetObjects('rbxassetid://17449386522')[1]
    toggle.Parent = self.section.Modules
    toggle.ToggleName.Text = self.name

    toggle.MouseButton1Click:Connect(function()
        self.library.flags[self.flag] = not self.library.flags[self.flag]
        self.callback(self.library.flags[self.flag])

        if self.library.flags[self.flag] then
            Toggle.enable(toggle)
        else
            Toggle.disable(toggle)
        end
    end)

    return toggle
end


return Toggle