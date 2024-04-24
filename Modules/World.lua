local Player = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Modules/Player.lua'))()

local World = {}


function World:get_closest_entity()
    local closest_entity = nil
    local minimal_dot_product = -math.huge
    local camera_direction = workspace.CurrentCamera.CFrame.LookVector

    for _, player in workspace.Alive:GetChildren() do
        if player == self.Character then
            continue
        end

        if not Player.alive(player) then
            continue
        end

        local entity_direction = (player.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Unit
        local dot_product = camera_direction:Dot(entity_direction)

        if dot_product > minimal_dot_product then
            minimal_dot_product = dot_product
            closest_entity = player
        end
    end

    return closest_entity
end


return World
