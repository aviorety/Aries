local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')

local Config = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Config.lua'))()

local Toggle = {}
Toggle.asset = game:GetObjects('rbxassetid://17517820043')[1]


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
    local toggle = Toggle.asset:Clone()
    toggle.Parent = self.section.Modules
    toggle.ToggleName.Text = self.name

    if self.keycode then
        toggle.Keybind.Key.Text = UserInputService:GetStringForKeyCode(self.keycode)

        UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
            if process then
                return
            end
    
            if not self.Library.container.Parent then
                return
            end
    
            if input.KeyCode == self.keycode then
                self.Library.flags[self.flag] = not self.Library.flags[self.flag]
                self.callback(self.Library.flags[self.flag])
                
                Config.save_flags(self.Library)
        
                if self.Library.flags[self.flag] then
                    Toggle.enable(toggle)
                else
                    Toggle.disable(toggle)
                end
            end
        end)
    end

    toggle.MouseButton1Click:Connect(function()
        self.Library.flags[self.flag] = not self.Library.flags[self.flag]
        self.callback(self.Library.flags[self.flag])
        
        Config.save_flags(self.Library)

        if self.Library.flags[self.flag] then
            Toggle.enable(toggle)
        else
            Toggle.disable(toggle)
        end
    end)

    return toggle
end


return Toggle