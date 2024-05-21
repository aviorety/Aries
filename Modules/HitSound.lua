local Debris = game:GetService('Debris')

local HitSound = {}


function HitSound:play()
    local asset = self.assets.HitSounds:FindFirstChild(self.asset)

    if not asset then
        warn(`asset {asset} not found`)

        return
    end

    asset = asset:Clone()
    asset.Parent = self.ball
    asset:Play()

    Debris:AddItem(asset, 2)
end


return HitSound