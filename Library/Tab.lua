local Tab = {}


function Tab:open()
    TweenService:Create(self.IconBackground, TweenInfo.new(0.4), {
        ImageTransparency = 0
    }):Play()

    TweenService:Create(self.IconBackground.Icon, TweenInfo.new(0.4), {
        ImageTransparency = 0
    }):Play()

    TweenService:Create(self.TabName, TweenInfo.new(0.4), {
        TextTransparency = 0
    }):Play()
end


function Tab:close()
    TweenService:Create(self.IconBackground, TweenInfo.new(0.4), {
        ImageTransparency = 1
    }):Play()

    TweenService:Create(self.IconBackground.Icon, TweenInfo.new(0.4), {
        ImageTransparency = 0.5
    }):Play()

    TweenService:Create(self.TabName, TweenInfo.new(0.4), {
        TextTransparency = 0.5
    }):Play()
end


function Tab:update_tabs()
    for _, object in self.tabs:GetChildren() do
        if object.Name ~= 'Tab' then
            continue
        end

        if object ~= self.tab then
            Tab.close(object)

            continue
        end

        Tab.open(object)
    end
end


function Tab:create()
    local tab = game:GetObjects('rbxassetid://17448395130')[1]
    tab.Parent = self.tabs
    tab.TabName.Text = self.name
    tab.IconBackground.Icon.Image = self.icon

    tab.MouseButton1Click:Connect(function()
        Tab.update_tabs({
            tabs = self.tabs,
            tab = tab
        })
    end)

    return tab
end


return Tab