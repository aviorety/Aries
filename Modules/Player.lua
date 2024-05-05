local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Stats = game:GetService('Stats')

local Player = {}


function Player:alive(instance: any, parent_check: boolean)
    local character_model = instance

    if instance:IsA('Player') then
        if not instance.Character then
            return
        end

        character_model = instance.Character
    end

    if character_model.Parent ~= workspace.Alive and parent_check then
        return
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


return Player