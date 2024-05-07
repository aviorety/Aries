local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Rewards = {}


function Rewards:redeem_quests_type()
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Daily')
end


function Rewards:claim_playtime_rewards()
    for index = 1, 6 do
        ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimPlaytimeReward']:InvokeServer(index)
    end
end


function Rewards:claim_clan_quests()
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Daily')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllClanBPQuests']:InvokeServer()
end


function Rewards:claim_login_reward()
    ReplicatedStorage.Remote.RemoteEvent:FireServer('ClaimLoginReward')

    for index = 1, 30 do
        ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', index)  
    end
end


function Rewards:claim_rewards()
    Rewards.redeem_quests_type()
    Rewards.claim_playtime_rewards()
    Rewards.claim_clan_quests()
    Rewards.claim_login_reward()
end


return Rewards