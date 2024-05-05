local filter = RaycastParams.new()
filter.FilterDescendantsInstances = {}
filter.FilterType = Enum.RaycastFilterType.Exclude
filter.IgnoreWater = true

local AI = {}
AI.offset = Vector3.zero
AI.offset_delay = tick()


function AI:path_check()
    filter.FilterDescendantsInstances = self.exclude

    local direction = (self.origin - self.goal).Unit
    local distance = (self.origin - self.goal).Magnitude
    local raycast = workspace:Raycast(self.origin, direction * distance)

    if not raycast then
        return
    end

    if not raycast.Instance.CanCollide then
        return
    end

    return raycast.Position
end


function AI:move_to()
    local path = path_check({
        origin = self.character.HumanoidRootPart.Position,
        goal = self.goal
    })

    if path then
        self.goal = path
    end

    self.character.Humanoid:MoveTo(self.goal)
end


function AI:find_path()
    if (tick() - AI.offset_delay) > 2 then
        local x_z = math.random(-30, 30)
        local offset = Vector3.new(x_z, 0, x_z)
    
        AI.offset = self.ball_spawn + offset
        AI.offset_delay = tick()
    
        local ball_spawn_direction = (self.ball_spawn - AI.offset).Unit
        local ball_spawn_distance = (self.ball_spawn - AI.offset).Magnitude
    
        if ball_spawn_distance <= 15 then
            local maximum_distance = math.max(15 - ball_spawn_distance, 1)
            AI.offset += (ball_spawn_direction * maximum_distance)
        end
    end

    AI.move_to({
        character = self.character,
        goal = AI.offset
    })
end


return AI