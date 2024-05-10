local TweenService = game:GetService('TweenService')

local Section = {}


function Section:update()
    for _, object in self.container:GetChildren() do
        if not object.Name:find('Section') then
            continue
        end

        if object == self.left_section then
            TweenService:Create(object, TweenInfo.new(0.4), {
                Position = UDim2.new(0.297, 0, 0.041, 0)
            }):Play()

            continue
        end

        if object == self.right_section then
            TweenService:Create(object, TweenInfo.new(0.4), {
                Position = UDim2.new(0.648, 0, 0.041, 0)
            }):Play()

            continue
        end

        TweenService:Create(object, TweenInfo.new(0.4), {
            Position = UDim2.new(0.648, 0, 1, 0)
        }):Play()

        TweenService:Create(object, TweenInfo.new(0.4), {
            Position = UDim2.new(0.297, 0, 1, 0)
        }):Play()

        object.Visible = false
    end
end


function Section:create()
    local section = game:GetObjects('rbxassetid://17449483108')[1]
    section.Parent = self.side
    section.TopBackground.SectionName.Text = self.name

    return section
end


return Section