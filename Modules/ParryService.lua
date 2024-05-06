local SocialService = game:GetService('SocialService')

local ParryService = {}


function ParryService:parry()
    if not self.entity_aim then
        return
    end

    local target_position = workspace.CurrentCamera:WorldToScreenPoint(self.entity_aim.HumanoidRootPart.Position)
    local direction = workspace.CurrentCamera.CFrame

    if self.direction == 'High' then
        direction = CFrame.new(workspace.CurrentCamera.CFrame.Position, Vector3.new(0, 1000, 0))
    elseif self.direction == 'Random' then
        local x_rad = math.random(-1000, 1000)
        local y_rad = math.random(-1000, 1000)
        local z_rad = math.random(-1000, 1000)

        direction = CFrame.new(workspace.CurrentCamera.CFrame.Position, Vector3.new(x_rad, y_rad, z_rad))
    end

    self.remote:FireServer(
        0.5,
        direction,
        {[self.entity_aim.Name] = target_position},
        {target_position.X, target_position.Y},
        false
    )
end


function ParryService:dungeon_parry()
    self:FireServer(
        workspace.CurrentCamera.CFrame,
        workspace.CurrentCamera.CFrame,
        false
    )
end


return ParryService
