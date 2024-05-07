local filter = RaycastParams.new()
filter.FilterDescendantsInstances = {}
filter.FilterType = Enum.RaycastFilterType.Exclude
filter.IgnoreWater = true

local AI = {}
AI.offset = Vector3.zero
AI.goal = CFrame.new()
AI.offset_delay = tick()
AI.exclude = {}


function AI:move_to()
    self.character.Humanoid:MoveTo(self.goal)
end


function AI:find_path()
    if (tick() - AI.offset_delay) >= 1.5 then
        local distance = 50 - (self.ball.Velocity.Magnitude / 10)

        local x = math.random(-distance, distance)
        local z = math.random(-distance, distance)
        local offset = Vector3.new(x, 0, z)
    
        AI.offset = self.ball.CFrame + offset
        AI.offset_delay = tick()
    end

    AI.goal = AI.goal:Lerp(AI.offset, 0.05)
    AI.move_to({
        character = self.character,
        goal = AI.goal.Position
    })

    warn('updated')
end


return AI