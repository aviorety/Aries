repeat
    task.wait()
until game:IsLoaded()

if isfile(`Atonium/key.lua`) then
    if script_key then
        writefile(`Atonium/key.lua`, script_key)
    else
        script_key = readfile(`Atonium/key.lua`)
    end
end

warn(`running loader: {script_key}`)

local Loader = {}
Loader.games = {
    [4777817887] = {
        name = 'Blade Ball',
        script_id = 'f8555be8e5bebb5c92efc25ad31686c7'
    }
}


function Loader:__init()
    if not Loader.games[game.GameId] then
        warn(`{game.GameId} is not supported`)

        return
    end

    local script_id = Loader.games[game.GameId].script_id
    local http = `https://api.luarmor.net/files/v3/loaders/{script_id}.lua`

    warn(`{identifyexecutor()}: {http}`)
    loadstring(game:HttpGet(http))()
end


Loader.__init()