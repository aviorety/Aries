local Teleport = {}
Teleport.places = {
    dungeon = 16581648071,
    dungeon_round = 16581648071,
    ranked = 14915220621
}
Teleport.worlds = {
    [0] = workspace.Spawn.Queues['Grass Area'].Pads['1'].Hitbox,
    [20] = workspace.Spawn.Queues['Frost Area'].Pads['1'].Hitbox,
    [40] = workspace.Spawn.Queues['Space Area'].Pads['1'].Hitbox
}


function Teleport:dungeon_teleport()
    local teleport_world = Teleport.worlds[1]

    for index, value in Teleport.worlds do
        if self.level >= index then
            teleport_world = value

            break
        end
    end

    self.root.CFrame = teleport_world.CFrame + Vector3.new(5)
    warn(self.level)
end


return Teleport