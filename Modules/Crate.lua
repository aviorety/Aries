local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Crate = {}
Crate.storage = {
    NormalSwordCrate = workspace.Spawn.Crates:FindFirstChild('NormalSwordCrate'),
    NormalExplosionCrate = workspace.Spawn.Crates:FindFirstChild('NormalExplosionCrate'),

    PremiumSwordCrate = workspace.Spawn.Crates:FindFirstChild('PremiumSwordCrate'),
    PremiumExplosionCrate = workspace.Spawn.Crates:FindFirstChild('PremiumExplosionCrate')
}


function Crate:open()
    if not Crate.storage[self.crate] then
        return
    end

    ReplicatedStorage.Remote.RemoteFunction:InvokeServer('PromptPurchaseCrate', Crate.storage[self.crate])

    if not self.no_cooldown then
        return
    end
    
    ReplicatedStorage.Remote.RemoteEvent:FireServer('OpeningCase', false)    
end


return Crate