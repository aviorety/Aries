local Loader = {}
Loader.games = {
    [4777817887] = {
        name = 'Blade Ball',
        script_id = 'bce7b92acff3dc7c0d113fd939669144'
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

    if Loader.support() then
        loadstring(game:HttpGet(http))
    else
        lrm_load_script(script_id)
    end
end


return Loader