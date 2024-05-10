local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

--[[
local Config = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Config.lua'))()
local Animation = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Animation.lua'))()

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
Library.container_open = true
Library.keybind = Enum.KeyCode.Insert


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

    local container = game:GetObjects('rbxassetid://17448262149')[1]
    container.Parent = CoreGui

    function Library:open()
        TweenService:Create(container.Container, TweenInfo.new(0.4), {
            Size = UDim2.new(0, 875, 0, 533)
        }):Play()

        TweenService:Create(container.Shadow, TweenInfo.new(0.4), {
            Size = UDim2.new(0, 1008, 0, 628)
        }):Play()
    end

    function Library:close()
        TweenService:Create(container.Container, TweenInfo.new(0.4), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()

        TweenService:Create(container.Shadow, TweenInfo.new(0.4), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
    end

    UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if process then
            return
        end

        if input.KeyCode ~= Library.keybind then
            return
        end

        Library.container_open = not Library.container_open

        if Library.container_open then
            Library.open()
        else
            Library.close()
        end
    end)
end


--[[
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Library.lua'))()

]]

Library.__init()


return Library