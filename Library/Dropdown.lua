local TweenService = game:GetService('TweenService')

local Dropdown = {}
Dropdown.assets = {
    dropdown = game:GetObjects('rbxassetid://17588969574'),
    option = game:GetObjects('rbxassetid://17588976415')
}


function Dropdown:open()
    TweenService:Create(self.dropdown.Box.Options, TweenInfo.new(0.4), {
        Size = UDim2.new(0, 113, 0, self.list_size)
    }):Play()
end


function Dropdown:close()
    TweenService:Create(self.Box.Options, TweenInfo.new(0.4), {
        Size = UDim2.new(0, 113, 0, 20)
    }):Play()
end


function Dropdown:create()
    local list_size = 20
    local options = 0
    local open = false

    local dropdown = Dropdown.assets.dropdown:Clone()
    dropdown.Parent = self.section
    dropdown.Box.Option.Text = self.option
    dropdown.DropdownName.Text = self.name

    for _, value in self.options do
        options += 1
        list_size += 17

        local option = Dropdown.assets.option:Clone()
        option.Parent = dropdown.Box.Options
        option.Text = value

        option.MouseButton1Click:Connect(function()
            dropdown.Box.Option.Text = value

            self.Library.flags[self.flag] = value
            self.callback(value)
            
            Config.save_flags(self.Library)
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        open = not open

        if open then
            Dropdown.open({
                dropdown = dropdown,
                list_size = list_size
            })
        else
            Dropdown.close(dropdown)
        end
    end)
end


return Dropdown