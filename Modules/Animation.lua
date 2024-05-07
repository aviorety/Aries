local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Animation = {}
Animation.storage = {}
Animation.current = nil


function Animation:load_animations()
    for _, object in ReplicatedStorage.Misc.Emotes:GetChildren() do
        if not object:IsA('Animation') then
            continue
        end

        local emote_name = object:GetAttribute('EmoteName')

        if not emote_name then
            continue
        end

        Animation.storage[emote_name] = object
    end
end


function Animation:play()
    if not Animation.storage[self.asset] then
        return
    end

    Animation.current = self.asset

    local animation = self.humanoid:LoadAnimation(Animation.storage[self.asset])
    animation:Play()

    animation.Stopped:Once(function()
        if Animation.current ~= self.asset then
            return
        end

        Animation.play({
            asset = self.asset,
            humanoid = self.humanoid
        })
    end)

    repeat
        task.wait()
    until Animation.current ~= self.asset or not animation

    if animation then
        animation:Stop()
    end
end


Animation.load_animations()

return Animation