local RunService = game:GetService('RunService')
local Debris = game:GetService('Debris')

local Player = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Modules/Player.lua'))()

local Visual = {}
Visual.balls_hiden = false


function Visual:remove_trail()
    for _, object in self.torso:GetChildren() do
        local asset = self.assets.Trails[self.asset_name]:FindFirstChild(object.Name)

        if not asset then
            continue
        end

        object:Destroy()
    end
end


function Visual:set_trail()
    Visual.remove_trail({
        torso = self.torso
        assets = self.assets
        asset_name = self.asset_name
    })

    local asset = self.assets.Trails:FindFirstChild(self.asset_name)
    
    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.Trails:GetChildren())}`)

        return
    end

    for _, object in asset:GetChildren() do
        local asset_part = object:Clone()
        asset_part.Parent = self.torso
    end
end


function Visual:remove_ambient()
    self.Loops.disconnect('ambient')

    for _, object in workspace:GetChildren() do
        local asset = self.assets.Ambient:FindFirstChild(object.Name)

        if not asset then
            continue
        end

        object:Destroy()
    end
end


function Visual:set_ambient()
    Visual.remove_ambient({
        Loops = self.Loops,
        assets = self.assets
    })

    local asset = self.assets.Ambient:FindFirstChild(self.asset_name)
    
    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.Ambient:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = workspace
    
    self.Loops['ambient'] = RunService.Heartbeat:Connect(function()
        if not Player.alive(self.character, false) then
            return
        end

        asset.Position = self.character.HumanoidRootPart.Position + Vector3.new(0, 35, 0)
    end)
end


function Visual:remove_aura()
    for _, object in self.torso:GetChildren() do
        local asset = self.assets.Auras.Main:FindFirstChild(object.Name)

        if not asset then
            continue
        end

        object:Destroy()
    end
end


function Visual:set_aura()
    Visual.remove_aura({
        torso = self.torso,
        assets = self.assets
    })

    local asset = self.assets.Auras.Main:FindFirstChild(self.asset_name)
    
    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.Auras.Main:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = self.torso
end


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


function Visual:hide_client_ball()
    Visual.balls_hiden = true
    self.Transparency = 1

    local highlight = self:FindFirstChildOfClass('Highlight')

    if not highlight then
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 1
    
        local connection = nil
    
        connection = highlight.Changed:Connect(function()
            if not Visual.balls_hiden then
                connection:Disconnect()
            end
    
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 1
        end)
    end

    local trail = self:FindFirstChildOfClass('Trail')

    if trail then
        trail.Enabled = false

        local connection = nil

        connection = trail.Changed:Connect(function()
            if not Visual.balls_hiden then
                connection:Disconnect()
            end

            trail.Enabled = false
        end)
    end
end


function Visual:unhide_client_ball()
    Visual.balls_hiden = false
    self.Transparency = 0

    local highlight = self:FindFirstChildOfClass('Highlight')

    if not highlight then
        return
    end

    highlight.FillTransparency = 0
    highlight.OutlineTransparency = 0

    local trail = self:FindFirstChildOfClass('Trail')

    if trail then
        trail.Enabled = true
    end
end


function Visual:change_ball()
    local asset = self.assets.Balls:FindFirstChild(self.asset_name)

    if not asset then
        warn(`asset {self.asset_name} not found. Try using these assets: {unpack(self.assets.Balls:GetChildren())}`)

        return
    end

    asset = asset:Clone()
    asset.Parent = self.ball
    asset.Anchored = true
    
    self.ball.Changed:Connect(function()
        asset.Position = self.ball.Position
    end)

    Visual.hide_client_ball(self.ball)
end


function Visual:remove_ball()
    Visual.unhide_client_ball(self.ball)

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