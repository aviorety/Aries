local Stats = game:GetService('Stats')

local Player = {}


function Player:alive()
    local character_model = self

    if self:IsA('Player') then
        if not self.Character then
            return
        end

        character_model = self.Character
    end

    if not character_model:FindFirstChild('HumanoidRootPart') then
        return
    end

    if not character_model:FindFirstChild('Humanoid') then
        return
    end

    if character_model.Humanoid.Health == 0 then
        return
    end

    return true
end


function Player:get_ping()
    return Stats.Network.ServerStatsItem['Data Ping']:GetValue()
end


function Player:parry()
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


function Player:claim_playtime_rewards()
    for index = 1, 6 do
        ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimPlaytimeReward']:InvokeServer(index)
    end
end


function Player:claim_rewards()
    Player.claim_playtime_rewards()
    
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Daily')
end


return Player
