local Tab = {}


function Tab:create()
    local tab = game:GetObjects('rbxassetid://17448395130')[1]
    tab.Parent = self.tabs_manager
    tab.TabName.Text = self.name
    tab.IconBackground.Icon.Image = self.icon

    tab.MouseButton1Click:Connect(function()
        warn(self.name)
    end)
end


return Tab