local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Rewards = {}


function Rewards:redeem_quests_type()
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Daily')
end


function Rewards:claim_playtime_reward()
    for index = 1, 6 do
        ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimPlaytimeReward']:InvokeServer(index)
    end
end


function Rewards:claim_all_daily_missions()
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Daily')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllDailyMissions']:InvokeServer('Weekly')
end


function Rewards:claim_new_daily_login_reward()
    for index = 1, 30 do
        ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', index)  
    end
end


function Rewards:claim_rewards()
    Rewards.redeem_quests_type()
    Rewards.claim_playtime_reward()
    Rewards.claim_all_daily_missions()
    Rewards.claim_new_daily_login_reward()

    ReplicatedStorage.Remote.RemoteEvent:FireServer('ClaimLoginReward')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimAllClanBPQuests']:InvokeServer()
end


return Rewards