local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Rewards = {}


function Rewards:claim_battlepass_rewards()
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Daily')
end


function Rewards:claim_playtime_rewards()
    for index = 1, 6 do
        ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimPlaytimeReward']:InvokeServer(index)
    end
end


function Rewards:claim_clan_rewards()
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Daily')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllClanBPQuests']:InvokeServer()
end


function Rewards:claim_login_rewards()
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