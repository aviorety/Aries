local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService('CoreGui')

--[[
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/SaveManager.lua'))()

local Tab = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Tab.lua'))()
local Section = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Section.lua'))()
local Toggle = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Toggle.lua'))()
local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Slider.lua'))()
local Dropdown = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Dropdown.lua'))()
local Colorpicker = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Colorpicker.lua'))()
]]

local Library = {}
Library.flags = {}
Library.container = nil
Library.container_open = false


function Library:clear()
    for _, object in CoreGui:GetChildren() do
        if object.Name ~= 'Aries' then
            continue
        end

        object:Destroy()
    end
end


function Library:__init()
    Library.clear()

    local container = game:GetObjects('rbxassetid://17447962998')[1]
    container.Parent = CoreGui
end


return Library