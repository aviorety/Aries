local Player = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Modules/Player.lua'))()

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
    local current_floor = self.dungeon_floors:FindFirstChild(`FLOOR_{self.current_zone}`)

    if not current_floor then
        return
    end

    return current_floor
end


function Dungeon:find_bot()
    local bot = workspace.Alive:FindFirstChildOfClass('Actor')

    if not bot then
        return
    end

    if not Player.alive(bot) then
        return
    end

    return bot
end


function Dungeon:get_position()
    local offset = math.min(45 + (self.current_zone * 2), 100)
    local result = nil

    local bot = Dungeon.find_bot()

    if bot then
        result = bot.HumanoidRootPart.CFrame + Vector3.new(0, offset, 0)
    else
        result = self.current_floor.CFrame + Vector3.new(0, offset, 0)
    end

    return result
end


return Dungeon