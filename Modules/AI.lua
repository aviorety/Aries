local filter = RaycastParams.new()
filter.FilterDescendantsInstances = {}
filter.FilterType = Enum.RaycastFilterType.Exclude
filter.IgnoreWater = true

local AI = {}
AI.offset = Vector3.zero
AI.offset_delay = tick()
AI.exclude = {}


function AI:path_check()
    filter.FilterDescendantsInstances = AI.exclude

    local direction = (self.origin - self.goal).Unit
    local distance = (self.origin - self.goal).Magnitude
    local raycast = workspace:Raycast(self.origin, direction * distance)

    if not raycast then
        return
    end

    if not raycast.Instance.CanCollide then
        return
    end

    if raycast.Instance.Parent ~= self.map.Border then
        return
    end

    return raycast.Position
end


function AI:move_to()
    local path = AI.path_check({
        origin = self.character.HumanoidRootPart.Position,
        goal = self.goal,
        map = self.map
    })

    if path then
        self.goal = path
    end

    self.character.Humanoid:MoveTo(self.goal)
end


function AI:find_path()
    if (tick() - AI.offset_delay) > 0.7 then
        local distance = 50 - (self.ball.Velocity.Magnitude / 10)

        local x = math.random(-distance, distance)
        local z = math.random(-distance, distance)
        local offset = Vector3.new(x, 0, z)
    
        AI.offset = self.ball.Position + offset
        AI.offset_delay = tick()
    end

    AI.move_to({
        character = self.character,
        goal = AI.offset,
        map = self.map
    })
end


return AI