local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

--[[
local Config = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Config.lua'))()
local Animation = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Animation.lua'))()

local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Slider.lua'))()
local Dropdown = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Dropdown.lua'))()
local Colorpicker = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Colorpicker.lua'))()
]]

local Tab = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Tab.lua'))()
local Toggle = {} --loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Toggle.lua'))()


function Toggle:enable()

end


function Toggle:disable()

end


function Toggle:create()
    local toggle = game:GetObjects('rbxassetid://')[1]
end


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

    Library.container = container

    local tabs = game:GetObjects('rbxassetid://17448344475')[1]
    tabs.Parent = container.Container.TabsManager

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

        if not Library.container then
            return
        end

        if not Library.container.Parent then
            return
        end

        Library.container_open = not Library.container_open

        if Library.container_open then
            Library.open()
        else
            Library.close()
        end
    end)

    local TabManager = {}

    function TabManager:create_tab()
        local left_section = game:GetObjects('rbxassetid://17448581780')[1]
        local right_section = game:GetObjects('rbxassetid://17448583456')[1]

        local tab = Tab.create({
            container = container.Container,
            tabs = container.Container.TabsManager.Tabs,

            name = self.name,
            icon = self.icon,

            left_section = left_section,
            right_section = right_section
        })

        if container.Container:FindFirstChild('RightSection') then
			left_section.Visible = false
			right_section.Visible = false
		else
			Tab.open(tab)
		end

        left_section.Parent = container.Container
        right_section.Parent = container.Container

        local SectionManager = {}

        function SectionManager:create_section()
            local side = self.side == 'right' and right_section or left_section

            local section = Section.create()

            local ModuleManager = {}

            function ModuleManager:create_toggle()
                Toggle.create({
                    section = section,
                    name = self.name
                    enabled = self.enabled
                    callback = self.callback,
                    library = Library
                })
            end

            return ModuleManager
        end

        return SectionManager
    end

    return TabManager
end


--[[
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Library.lua'))()

]]

local main = Library.__init()

local blatant = main.create_tab({
    name = 'Blatant',
    icon = 'rbxassetid://17447902260'
})

local world = main.create_tab({
    name = 'World',
    icon = 'rbxassetid://17447918843'
})

local misc = main.create_tab({
    name = 'Misc',
    icon = 'rbxassetid://17447926845'
})

local settings = main.create_tab({
    name = 'Settings',
    icon = 'rbxassetid://17447924593'
})


return Library