local SocialService = game:GetService('SocialService')

local ParryService = {}


function ParryService:parry()
    if not self.closest_entity then
        return
    end

    local screen_view = workspace.CurrentCamera:WorldToScreenPoint(self.closest_entity.HumanoidRootPart.Position)

    self.remote:FireServer(
        0.5,
        workspace.CurrentCamera.CFrame,
        {[self.closest_entity.Name] = screen_view},
        {screen_view.X, screen_view.Y},
        false
    )
end


function ParryService:dungeon_parry()
    if not self.closest_entity then
        return
    end

    --local screen_view = workspace.CurrentCamera:WorldToScreenPoint(self.closest_entity.HumanoidRootPart.Position)

    self.remote:FireServer(
        workspace.CurrentCamera.CFrame,
        workspace.CurrentCamera.CFrame,
        false
    )
end


return ParryService
