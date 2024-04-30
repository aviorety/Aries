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

    for _, object in asset:GetChildren() do
        if not object:IsA('ParticleEmitter') then
            continue
        end

        object:Emit(object:GetAttribute('EmitCount'))
    end

    Debris:AddItem(asset, 2)
end


function Visual:change_ball()
    local asset = self.assets.Balls:FindFirstChild(self.asset_name)

    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.Balls:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = workspace.Balls
    asset.Weld.Part1 = self.ball
end


function Visual:remove_ball()
    for _, object in self.ball:GetChildren() do
        if not object:IsA('Part') then
            continue
        end
    
        local ball_asset = self.assets.Balls:FindFirstChild(object.Name)

        if not ball_asset then
            continue
        end

        ball_asset:Destroy()
    end
end


return Visual
