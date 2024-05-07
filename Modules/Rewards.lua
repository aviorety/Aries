local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Rewards = {}
Rewards.flags = {
    Battlepass = true,
    Playtime = true,
    Clan = true,
    Login = true
}


function Rewards:claim_battlepass_rewards()
    if not Rewards.flags.Battlepass then
        return
    end

    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Daily')
end


function Rewards:claim_playtime_rewards()
    if not Rewards.flags.Playtime then
        return
    end

    for index = 1, 6 do
        ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimPlaytimeReward']:InvokeServer(index)
    end
end


function Rewards:claim_clan_rewards()
    if not Rewards.flags.Clan then
        return
    end
    
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Daily')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllClanBPQuests']:InvokeServer()
end


function Rewards:claim_login_rewards()
    if not Rewards.flags.Login then
        return
    end

    ReplicatedStorage.Remote.RemoteEvent:FireServer('ClaimLoginReward')

    for index = 1, 30 do
        ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', index)  
    end
end


function Rewards:claim_rewards()
    Rewards.claim_battlepass_rewards()
    Rewards.claim_playtime_rewards()
    Rewards.claim_clan_rewards()
    Rewards.claim_login_rewards()
end


return Rewards