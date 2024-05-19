local Loader = {}
Loader.http = 'https://raw.githubusercontent.com/aviorety/Aries/main/Games/'
Loader.games = {
    [4777817887] = nil
}


function Loader:check()
    local success, result = pcall(function()
        return game:HttpGet(`{Loader.http}{self}.lua`)
    end)

    if result:find('404') then
        warn(`couldn't access to the {Loader.http}{self}.lua`)

        return
    end

    return result
end


function Loader:support()
    local success, executor = pcall(function()
        return identifyexecutor()
    end)

    if not success or not executor then
        warn(`couldn't identify the executor`)

        return
    end
    
    return executor ~= 'Solara ALPHA'
end


function Loader:__init()
    if not Loader.support() then
        return
    end

    local __loadstring = Loader.check(game.GameId)

    if not __loadstring then
        return
    end

    loadstring(__loadstring)()
end


return Loader