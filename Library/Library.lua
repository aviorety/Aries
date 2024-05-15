local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

--[[
local Animation = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Animation.lua'))()

local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Slider.lua'))()
local Dropdown = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Dropdown.lua'))()
local Colorpicker = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Colorpicker.lua'))()
]]

local Config = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Config.lua'))()

local Tab = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Tab.lua'))()
local Section = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Section.lua'))()
local Toggle = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Toggle.lua'))()

local Library = {}
Library.assets = {
    left_section = game:GetObjects('rbxassetid://17448581780')[1],
    right_section = game:GetObjects('rbxassetid://17448583456')[1]
}
Library.flags = {}
Library.container = nil
Library.container_open = true
Library.keybind = Enum.KeyCode.Insert

if not isfolder(`Aries`) then
	makefolder(`Aries`)
end


function Library:clear()
    for _, object in CoreGui:GetChildren() do
        if object.Name ~= 'Aries' then
            continue
        end

        object:Destroy()
    end
end


Config.load_flags(Library)


function Library:__init()
    Library.clear()

    local container = game:GetObjects('rbxassetid://17448262149')[1]
    container.Parent = CoreGui

    container.Container.Size = UDim2.new(0, 0, 0, 0)
    container.Shadow.Size = UDim2.new(0, 0, 0, 0)

    Library.container = container

    local tabs = game:GetObjects('rbxassetid://17448344475')[1]
    tabs.Parent = container.Container.TabsManager

    function Library:open()
        TweenService:Create(container.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 875, 0, 533)
        }):Play()

        TweenService:Create(container.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 1008, 0, 628)
        }):Play()
    end

    function Library:close()
        TweenService:Create(container.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()

        TweenService:Create(container.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
    end

    Library.open()

    UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if process then
            return
        end

        if input.KeyCode ~= Library.keybind then
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
        local left_section = Library.assets.left_section:Clone()
        local right_section = Library.assets.right_section:Clone()

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
            local section_size = 46

            local section = Section.create({
                side = side,
                name = self.name
            })

            local ModuleManager = {}

            function ModuleManager:create_toggle()
                section_size += 31
                
                section.Size = UDim2.new(0, 284, 0, section_size)
                section.Modules.Size = UDim2.new(0, 284, 0, section_size - 33)

                local toggle = Toggle.create({
                    section = section,
                    Library = Library,

                    name = self.name,
                    flag = self.flag,

                    keycode = self.keycode,
                    callback = self.callback
                })

                if Library.flags[self.flag] then
                    Toggle.enable(toggle)
                else
                    Toggle.disable(toggle)
                end

                self.callback(Library.flags[self.flag])
            end

            return ModuleManager
        end

        return SectionManager
    end

    return TabManager
end


--[[
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Library.lua'))()
local main = Library.__init()

local blatant = main.create_tab({
    name = 'Blatant',
    icon = 'rbxassetid://17447902260'
})

local auto_parry_section = blatant.create_section({
    side = 'left',
    name = 'AutoParry'
})

auto_parry_section.create_toggle({
    name = 'Enabled',
    flag = 'auto_parry',
    keycode = Enum.KeyCode.R,

    callback = function(result: boolean)
        warn(result)
    end
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
]]


return Library