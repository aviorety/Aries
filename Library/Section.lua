local Section = {}


function Section:update()
    for _, object in self.container:GetChildren() do
        if object == self.left_section then
            continue
        end

        if object == self.right_section then
            continue
        end

        object.Visible = false
    end
end


function Section:create()
    local section = game:GetObjects('rbxassetid://17448765120')[1]
    section.Parent = self.side
    section.TopBackground.SectionName.Text = self.name
end


return Section