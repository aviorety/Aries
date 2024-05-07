local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Teleport = {}
Teleport.places = {
    dungeon = 16581648071,
    dungeon_round = 16581648071,
    ranked = 14915220621
}

local queues = workspace.Spawn:FindFirstChild('Queues')

if queues then
    Teleport.worlds = {
        [0] = workspace.Spawn.Queues['Grass Area'].Pads['1'].Hitbox,
        [20] = workspace.Spawn.Queues['Frost Area'].Pads['1'].Hitbox,
        [40] = workspace.Spawn.Queues['Space Area'].Pads['1'].Hitbox
    }
end


function Teleport:dungeon_teleport()
    if not queues then
        return
    end

    local teleport_world = Teleport.worlds[1]

    for index, value in Teleport.worlds do
        if self.level >= index then
            teleport_world = value
        end
    end

    self.player.Characetr.HumanoidRootPart.CFrame = teleport_world.CFrame + Vector3.new(5)

    repeat
        task.wait()
    until self.player.PlayerGui.DungeonsVote.Enabled
    
    ReplicatedStorage.Packages._Index['sleitnick_net@0.1.0'].net['RE/Dungeons-DifficultyVote']:FireServer(self.mode)
end


return Teleport