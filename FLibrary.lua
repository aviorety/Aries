local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

local Library = {}
Library.assets = {
    tab = game:GetObjects('rbxassetid://17774101626')[1],
    left_section = game:GetObjects('rbxassetid://17795941028')[1],
    right_section = game:GetObjects('rbxassetid://17795946150')[1],

    label = game:GetObjects('rbxassetid://17795953323')[1]
}

Library.UI = nil
Library.UI_open = true


for _, object in CoreGui:GetChildren() do
    if object.Name ~= 'Flow' then
        continue
    end

    object:Destroy()
end


function Library.new()
    Library.UI = game:GetObjects('rbxassetid://17774027224')[1]
    Library.UI.Parent = CoreGui

    local TabManager = {}

    function TabManager:create_tab()
        local tab = Library.assets.tab:Clone()
        tab.Label.Text = self.name
        tab.Icon.Image = self.icon

        local left_section = Library.assets.left_section:Clone()
        left_section.Parent = Library.UI.Container

        local right_section = Library.assets.right_section:Clone()
        right_section.Parent = Library.UI.Container

        if not Library.UI.Container.Tabs.List:FindFirstChild('Tab') then
            TweenService:Create(tab.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 0
            }):Play()

            TweenService:Create(tab.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 0
            }):Play()

            TweenService:Create(tab.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 0
            }):Play()

            TweenService:Create(tab.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                TextTransparency = 0
            }):Play()
        else
            left_section.Visible = false
            right_section.Visible = false
        end

        tab.Parent = Library.UI.Container.Tabs.List

        local function update()
            for _, object in Library.UI.Container:GetChildren() do
                if not object.Name:find('Section') then
                    continue
                end

                if object == left_section or object == right_section then
                    object.Visible = true

                    continue
                end

                object.Visible = false
            end

            for _, object in Library.UI.Container.Tabs.List:GetChildren() do
                if object.Name ~= 'Tab' then
                    continue
                end

                if object == tab then
                    TweenService:Create(object.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        ImageTransparency = 0
                    }):Play()
    
                    TweenService:Create(object.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        ImageTransparency = 0
                    }):Play()
    
                    TweenService:Create(object.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        ImageTransparency = 0
                    }):Play()
    
                    TweenService:Create(object.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        TextTransparency = 0
                    }):Play()

                    continue
                end

                TweenService:Create(object.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()

                TweenService:Create(object.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()

                TweenService:Create(object.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.8
                }):Play()

                TweenService:Create(object.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 0.8
                }):Play()
            end
        end

        tab.MouseEnter:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 138, 0, 36)
            }):Play()
            
            TweenService:Create(tab.Fill, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 138, 0, 36)
            }):Play()
            
            TweenService:Create(tab.Glow, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 153, 0, 50)
            }):Play()
        end)
        
        tab.MouseLeave:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 135, 0, 33)
            }):Play()
            
            TweenService:Create(tab.Fill, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 135, 0, 33)
            }):Play()
            
            TweenService:Create(tab.Glow, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 148, 0, 45)
            }):Play()
        end)

        tab.MouseButton1Click:Connect(function()
            update()
        end)

        local ModuleManager = {}

        function ModuleManager:create_label()
            local section = self.section == 'right' and right_section or left_section
            
            local label = Library.assets.label:Clone()
            label.Parent = section
            label.Text = self.name
        end

        return ModuleManager
    end

    return TabManager
end


function Library.__init()
    if not Library.UI then
        return
    end

    Library.UI.Container.UIScale.Scale = 0
    Library.UI.Shadow.UIScale.Scale = 0
    
    Library.UI.Container.Tabs.List.UIPadding.PaddingTop = UDim.new(0, 1000)
    Library.UI.Container.Tabs.List.UIListLayout.Padding = UDim.new(0, 1000)

    TweenService:Create(Library.UI.Container.UIScale, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Scale = 1
    }):Play()
    
    TweenService:Create(Library.UI.Shadow.UIScale, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Scale = 1
    }):Play()
    
    TweenService:Create(Library.UI.Container.Tabs.List.UIPadding, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        PaddingTop = UDim.new(0, 10)
    }):Play()
    
    TweenService:Create(Library.UI.Container.Tabs.List.UIListLayout, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Padding = UDim.new(0, 4)
    }):Play()
end


local main = Library.new()

local blatant = main.create_tab({
    name = 'Blatant',
    icon = 'rbxassetid://17773816885'
})

blatant.create_label({
    name = 'AutoParry',
    section = 'left'
})

local visuals = main.create_tab({
    name = 'Visuals',
    icon = 'rbxassetid://17773816885'
})

local misc = main.create_tab({
    name = 'Misc',
    icon = 'rbxassetid://17773816885'
})

local settings = main.create_tab({
    name = 'Settings',
    icon = 'rbxassetid://17773816885'
})

Library.__init()


return Library