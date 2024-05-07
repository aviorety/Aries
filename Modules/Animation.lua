local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Animation = {}
Animation.storage = {}
Animation.current = nil

function Animation:load_animations()
    for _, object in ReplicatedStorage.Misc.Emotes:GetChildren() do
        if not object:IsA('Animation') then
            continue
        end

        table.insert(Animation.storage, object)
    end
end


function Animation:play()
    if not Animation.storage[self.asset] then
        return
    end

    local animation_asset = ReplicatedStorage.Misc.Emotes:FindFirstChild(self.asset)

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