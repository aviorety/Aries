local TweenService = game:GetService('TweenService')

local Section = {}
Section.asset = game:GetObjects('rbxassetid://17517814042')[1]


function Section:update()
    for _, object in self.container:GetChildren() do
        if not object.Name:find('Section') then
            continue
        end

        if object == self.left_section then
            TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.297, 0, 0.041, 0)
            }):Play()

            continue
        end

        if object == self.right_section then
            TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.648, 0, 0.041, 0)
            }):Play()

            continue
        end

        if object.Name == 'LeftSection' then
            TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.297, 0, 1, 0)
            }):Play()
        else
            TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.648, 0, 1, 0)
            }):Play()
        end

        object.Visible = false
    end
end


function Section:create()
    local section = Section.asset:Clone()
    section.Parent = self.side
    section.TopBackground.SectionName.Text = self.name

    return section
end


return Section