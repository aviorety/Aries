repeat
    task.wait()
until game:IsLoaded()

if isfile(`Atonium/key.lua`) then
    script_key = readfile(`Atonium/key.lua`)
else
    if script_key then
        writefile(`Atonium/key.lua`, flags)
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


function Loader:support()
    local success, executor = pcall(function()
        return identifyexecutor()
    end)

    if not success or not executor then
        warn(`couldn't identify the executor`)

        return
    end

    return executor ~= 'Solara'
end


function Loader:__init()
    if not Loader.games[game.GameId] then
        warn(`{game.GameId} is not supported`)

        return
    end

    local script_id = Loader.games[game.GameId].script_id
    local http = `https://api.luarmor.net/files/v3/loaders/{script_id}.lua`

    warn(`{identifyexecutor()}: {http}`)
    loadstring(game:HttpGet(http))()

    --[[if Loader.support() then
        warn(`{identifyexecutor()}: {http}`)
        loadstring(game:HttpGet(http))()
    else
        warn(`Solara: {script_id}`)
        lrm_load_script(script_id)
    end]]
end


Loader.__init()