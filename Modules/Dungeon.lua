local Dungeon = {}


function Dungeon:get_current_zone()
    local current_zone = workspace:GetAttribute('Dungeons_CurrentZone')

    if not current_zone then
        return
    end

    return current_zone
end


function Dungeon:get_current_mobs()
    local current_mobs = workspace:GetAttribute('Dungeons_CurrentMobs')

    if not current_mobs then
        return
    end

    return current_mobs
end


function Dungeon:get_current_floor()
    local current_floor = self.dungeon_floors:FindFirstChild(`FLOOR_{self.current_floor}`)

    if not current_floor then
        return
    end

    return current_floor
end


function Dungeon:get_position()
    local y_speed = 2
    local y_distance = 5
    local x_z_distance = 10
    
    local y_offset = 100 - (math.sin(tick() * y_speed) * y_distance)
    local x_offset = math.sin(tick()) * distance
    local z_offset = math.cos(tick()) * distance

    local result = self.CFrame + Vector3.new(x_offset, y_offset, z_offset)

    return result
end


return Dungeon
