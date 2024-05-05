local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Rewards = {}


function Rewards:claim_playtime_rewards()
    for index = 1, 6 do
        ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/ClaimPlaytimeReward']:InvokeServer(index)
    end
end


function Rewards:claim_event_daily()
    for index = 1, 30 do
        ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', index)  
    end
end


function Rewards:claim_rewards()
    Rewards.claim_playtime_rewards()
    Rewards.claim_event_daily()

    ReplicatedStorage.Remote.RemoteEvent:FireServer('ClaimLoginReward')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Weekly')
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RF/RedeemQuestsType']:InvokeServer('Battlepass', 'Daily')
end


return Rewards