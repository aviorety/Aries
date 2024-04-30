local Debris = game:GetService('Debris')

local Visual = {}


function Visual:hit_particle()
    local asset = self.assets.HitParticles.Main:FindFirstChild(self.asset_name)
    
    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.HitParticles.Main:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = self.ball
    asset.Position = self.ball.Position

    for _, object in asset:GetChildren() do
        if not object:IsA('ParticleEmitter') then
            continue
        end

        object:Emit(object:GetAttribute('EmitCount'))
    end

    Debris:AddItem(asset, 2)
end


return Visual
