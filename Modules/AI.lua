local filter = RaycastParams.new()
filter.FilterDescendantsInstances = {}
filter.FilterType = Enum.RaycastFilterType.Exclude
filter.IgnoreWater = true

local AI = {}
AI.exclude = {}

AI.offset_delay = tick()
AI.offset = Vector3.zero
AI.goal = CFrame.new()

AI.last_jump = tick()
AI.last_double_jump = tick()


function AI:random_jump()
    if (tick() - AI.last_jump) < 1 then
        return
    end

    if math.random() < 0.9 then
        return
    end

    if self.FloorMaterial == Enum.Material.Air then
        return
    end

    AI.last_jump = tick()
    self:ChangeState(Enum.HumanoidStateType.Jumping)
end


function AI:move_to()
    self.character.Humanoid:MoveTo(self.goal)
end


function AI:find_path()
    if (tick() - AI.offset_delay) >= 0.5 then
        local distance = 50 - (self.ball.Velocity.Magnitude / 10)

        local x = math.random(-distance, distance)
        local z = math.random(-distance, distance)
        local offset = Vector3.new(x, 0, z)
    
        AI.offset = self.ball.CFrame + offset
        AI.offset_delay = tick()
    end

    AI.goal = AI.goal:Lerp(AI.offset, 0.01)
    
    AI.move_to({
        character = self.character,
        goal = AI.goal.Position
    })

    AI.random_jump(self.character.Humanoid)
end


return AI