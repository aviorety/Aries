local Player = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Modules/Player.lua'))()

local World = {}


function World:get_ball()
    local ball_models = {}
    local client_ball = nil
    local server_ball = nil

    for _, object in workspace.Balls:GetChildren() do
        if object:IsA('Model') then
            table.insert(ball_models, object)

            continue
        end

        if not object:GetAttribute('realBall') then
            client_ball = object
        else
            server_ball = object
        end
    end

    if client_ball and server_ball then
        return {
            client = client_ball,
            server = server_ball
        }
    end

    return ball_models
end


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
