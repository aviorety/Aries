local TweenService = game:GetService('TweenService')

local Section = {}
Section.asset = game:GetObjects('rbxassetid://17517814042')[1]
Section.offsets = {
    LeftSection = {
        open = UDim2.new(0.297, 0, 0.041, 0),
        close = UDim2.new(0.297, 0, 1, 0)
    },
    RightSection = {
        open = UDim2.new(0.648, 0, 0.041, 0),
        close = UDim2.new(0.648, 0, 1, 0)
    }
}


function Section:update()
    for _, object in self.container:GetChildren() do
        if not object.Name:find('Section') then
            continue
        end

        if object == self.left_section or object == self.right_section then
            TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = Section.offsets[object.Name].open
            }):Play()

            continue
        end

        TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Position = Section.offsets[object.Name].close
        }):Play()

        object.Visible = false
    end
end


function Section:create()
    local section = Section.asset:Clone()
    section.Parent = self.side
    section.TopBackground.SectionName.Text = self.name
    section.ClipsDescendants = false

    return section
end


return Section