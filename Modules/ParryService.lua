local SocialService = game:GetService('SocialService')

local ParryService = {}


function ParryService:parry()
    if not self.entity_aim then
        return
    end

    local screen_view = workspace.CurrentCamera:WorldToScreenPoint(self.entity_aim.HumanoidRootPart.Position)

    self.remote:FireServer(
        0.5,
        workspace.CurrentCamera.CFrame,
        {[self.entity_aim.Name] = screen_view},
        {screen_view.X, screen_view.Y},
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
