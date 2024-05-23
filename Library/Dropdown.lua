local TweenService = game:GetService('TweenService')

local Dropdown = {}
Dropdown.assets = {
    dropdown = game:GetObjects('rbxassetid://17588969574')[1],
    option = game:GetObjects('rbxassetid://17589098486')[1]
}


function Dropdown:open()
    --[[TweenService:Create(self.dropdown, TweenInfo.new(0.4), {
        Size = UDim2.new(0, 215, 0, 18 + self.list_size)
    }):Play()]]

    TweenService:Create(self.dropdown.Box.Options, TweenInfo.new(0.4), {
        Size = UDim2.new(0, 113, 0, self.list_size)
    }):Play()
end


function Dropdown:close()
    --[[TweenService:Create(self.dropdown, TweenInfo.new(0.4), {
        Size = UDim2.new(0, 215, 0, 18)
    }):Play()]]

    TweenService:Create(self.dropdown.Box.Options, TweenInfo.new(0.4), {
        Size = UDim2.new(0, 113, 0, 20)
    }):Play()
end


function Dropdown:update()
    for _, object in self.dropdown.Box.Options:GetChildren() do
        if not object:IsA('TextButton') then
            continue
        end

        if object == self.option then
            TweenService:Create(object, TweenInfo.new(0.4), {
                TextTransparency = 0
            }):Play()

            continue
        end
        
        TweenService:Create(object, TweenInfo.new(0.4), {
            TextTransparency = 0.5
        }):Play()
    end
end


function Dropdown:create()
    local list_size = 20
    local options = 0
    local open = false

    local dropdown = Dropdown.assets.dropdown:Clone()
    dropdown.Parent = self.section.Modules
    dropdown.Box.Option.Text = self.option
    dropdown.DropdownName.Text = self.name

    for _, value in self.options do
        options += 1
        list_size += 15

        local option = Dropdown.assets.option:Clone()
        option.Parent = dropdown.Box.Options
        option.Text = value

        if value == self.option then
            TweenService:Create(option, TweenInfo.new(0.4), {
                TextTransparency = 0
            }):Play()
        end

        option.MouseButton1Click:Connect(function()
            Dropdown.update({
                dropdown = dropdown,
                option = option
            })

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
                --section_data = self.section_data,
                section = self.section,
                dropdown = dropdown,
            })
        else
            Dropdown.close({
                --section_data = self.section_data,
                section = self.section,
                dropdown = dropdown,
            })
        end
    end)
end


return Dropdown