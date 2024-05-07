local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Stats = game:GetService('Stats')

local Player = {}


function Player.alive(object: any, parent_check: boolean)
    local character_model = object

    if object:IsA('Player') then
        if not object.Character then
            return
        end

        character_model = object.Character
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


function Player:get_level()
    local leaderstats = self:FindFirstChild('leaderstats')

    if not leaderstats then
        return
    end

    local level = leaderstats:FindFirstChild('Level')

    if not level then
        return
    end

    return level.Value
end


return Player