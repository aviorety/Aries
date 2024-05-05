local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Animation = {}
Animation.storage = {
    [`Astral Sword`] = ReplicatedStorage.Misc.SwordPacksVFX[`Astral Sword`],
    [`Crimson Katana`] = ReplicatedStorage.Misc.SwordPacksVFX[`Crimson Katana`],
    [`Crystal Hammer`] = ReplicatedStorage.Misc.SwordPacksVFX[`Crystal Hammer`],
    [`Crystal Scissors`] = ReplicatedStorage.Misc.SwordPacksVFX[`Crystal Scissors`],
    [`Cupid's Bow`] = ReplicatedStorage.Misc.SwordPacksVFX[`Cupid's Bow`],
    [`Dual Crystal Hammer`] = ReplicatedStorage.Misc.SwordPacksVFX[`Dual Crystal Hammer`],
    [`Dual Shadow Mirage`] = ReplicatedStorage.Misc.SwordPacksVFX[`Dual Shadow Mirage`],
    [`Dual Stardust Katana`] = ReplicatedStorage.Misc.SwordPacksVFX[`Dual Stardust Katana`],
    [`Dual Void Scythes`] = ReplicatedStorage.Misc.SwordPacksVFX[`Dual Void Scythes`],
    [`Heavenly Sword`] = ReplicatedStorage.Misc.SwordPacksVFX[`Heavenly Sword`],
    [`Lunar Parasol`] = ReplicatedStorage.Misc.SwordPacksVFX[`Lunar Parasol`],
    [`Shadow Mirage`] = ReplicatedStorage.Misc.SwordPacksVFX[`Shadow Mirage`],
    [`Void Scythe`] = ReplicatedStorage.Misc.SwordPacksVFX[`Void Scythe`]
}
Animation.current = nil


function Animation:play()
    if not Animation.storage[self.asset] then
        return
    end

    local animation_asset = Animation.storage[self.asset]:FindFirstChild('Animation')

    if not animation_asset then
        warn(`Animation asset hasn't been found in {self.asset}`)

        return
    end

    Animation.current = self.asset

    local animation = self.humanoid:LoadAnimation(animation_asset)
    animation:Play()

    repeat
        task.wait()
    until Animation.current ~= self.asset or not animation

    if animation then
        animation:Stop()
    end
end


return Animation