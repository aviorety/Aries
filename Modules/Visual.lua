local Debris = game:GetService('Debris')

local Visual = {}
Visual.balls_hiden = false


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


function Visual:hide_balls()
    Visual.balls_hiden = true

    for _, object in workspace.Balls:GetDescendants() do
        if object == self.ball then
            continue
        end

        if object:IsA('Part') then
            object.Transparency = 1
        end

        if object:IsA('Highlight') then
            object.FillTransparency = 1
            object.OutlineTransparency = 1

            local connection = nil

            connection = object.Changed:Connect(function()
                if not Visual.balls_hiden then
                    connection:Disconnect()
                end

                object.FillTransparency = 1
                object.OutlineTransparency = 1
            end)
        end
    end
end


function Visual:unhide_balls()
    Visual.balls_hiden = false

    for _, object in workspace.Balls:GetDescendants() do
        if object == self.ball then
            continue
        end

        if object:IsA('Part') then
            object.Transparency = 0
        end

        if object:IsA('Highlight') then
            object.FillTransparency = 0
            object.OutlineTransparency = 0
        end
    end
end


function Visual:change_ball()
    local asset = self.assets.Balls:FindFirstChild(self.asset_name)

    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.Balls:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = workspace
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

        object:Destroy()
    end
end


return Visual
