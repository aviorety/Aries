local filter = RaycastParams.new()
filter.FilterDescendantsInstances = {}
filter.FilterType = Enum.RaycastFilterType.Exclude
filter.IgnoreWater = true

local AI = {}
AI.exclude = {}

AI.offset_delay = tick()
AI.offset = Vector3.zero

AI.goal = CFrame.new()
AI.last_goal = CFrame.new()

AI.last_jump = tick()
AI.last_double_jump = tick()


function AI:random_jump()
    if (tick() - AI.last_jump) < math.random(1, 50) then
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

        local direction = (self.target_root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
        local offset = self.target_root.CFrame + (-direction * distance)

        AI.offset = offset
        AI.offset_delay = tick()
    end

    AI.goal = AI.goal:Lerp(AI.offset, 0.08)

    local passed_distance = (AI.goal.Position - AI.last_goal.Position).Magnitude

    if passed_distance >= 6 then
        AI.last_goal = AI.goal

        AI.move_to({
            character = self.character,
            goal = AI.goal.Position
        })
    
        AI.random_jump(self.character.Humanoid)
    end
end


return AI