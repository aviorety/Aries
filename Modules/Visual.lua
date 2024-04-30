local Visual = {}


function Visual:hit_particle()
    local asset = self.assets.HitParticles.Main:FindFirstChild(self.asset_name)
    
    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.HitParticles.Main:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = workspace.Terrain
    asset.Position = self.origin

    task.delay(0.05, function()
        for _, object in asset:GetChildren() do
            if not object:IsA('ParticleEmmiter') then
                continue
            end
    
            object:Emit(object:GetAttribute('EmitCount'))
        end
    end)

    warn(`delay`)
end


return Visual
