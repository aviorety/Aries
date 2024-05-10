local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService('CoreGui')

local Library = {}
Library.flags = {}
Library.container = nil
Library.container_open = false


function Library:__init()
    local container = game:GetObjects('rbxassetid://')[1]
    container.Parent = CoreGui
end


return Library