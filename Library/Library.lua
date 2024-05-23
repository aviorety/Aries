local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

--[[
local Animation = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Animation.lua'))()

local Colorpicker = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Colorpicker.lua'))()
]]

local Config = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Config.lua'))()

local Tab = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Tab.lua'))()
local Section = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Section.lua'))()
local Toggle = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Toggle.lua'))()
local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Slider.lua'))()
local Dropdown = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Dropdown.lua'))()
local Notification = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/Library/Notification.lua'))()

local Library = {}
Library.assets = {
    left_section = game:GetObjects('rbxassetid://17577814687')[1],
    right_section = game:GetObjects('rbxassetid://17577820790')[1]
}
Library.flags = {}
Library.keybind = Enum.KeyCode.Insert

Library.container = nil
Library.container_open = true

Library.dragging = false
Library.drag_position = nil
Library.start_position = nil

Library.slider_drag = false

if not isfolder(`Atonium`) then
	makefolder(`Atonium`)
end


function Library:clear()
    for _, object in CoreGui:GetChildren() do
        if object.Name ~= 'Atonium' then
            continue
        end

        object:Destroy()
    end
end


Config.load_flags(Library)


function Library:__init()
    Library.clear()

    local container = game:GetObjects('rbxassetid://17580879104')[1]
    container.Container.Size = UDim2.new(0, 0, 0, 0)
    container.Shadow.Size = UDim2.new(0, 0, 0, 0)
    container.Parent = CoreGui

    Library.container = container

    function Library:open()
        TweenService:Create(container.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 775, 0, 472)
        }):Play()

        TweenService:Create(container.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 892, 0, 556)
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

    function Library:drag()
        if not container.Parent then
            return
        end
    
        if not Library.drag_position then
            return
        end
        
        if not Library.start_position then
            return
        end
        
        local delta = self.input.Position - Library.drag_position
        local position = UDim2.new(Library.start_position.X.Scale, Library.start_position.X.Offset + delta.X, Library.start_position.Y.Scale, Library.start_position.Y.Offset + delta.Y)
    
        TweenService:Create(container.Container, TweenInfo.new(0.2), {
            Position = position
        }):Play()
    
        TweenService:Create(container.Shadow, TweenInfo.new(0.2), {
            Position = position
        }):Play()
    end

    function Library:create_notification()
        Notification.create({
            container = container,

            name = self.name,
            description = self.description,

            __time = self.__time,
            __type = self.__type
        })
    end

    Library.open()

    container.Container.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Library.dragging = true
            Library.drag_position = input.Position
            Library.start_position = container.Container.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
					Library.dragging = false
					Library.drag_position = nil
					Library.start_position = nil
                end
            end)
        end
    end)

	UserInputService.InputChanged:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            Library.drag({
                input = input,
                container = container
            })
        end
    end)

    UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if process then
            return
        end

        if input.KeyCode ~= Library.keybind then
            return
        end

        if not container.Parent then
            return
        end

        Library.container_open = not Library.container_open

        if Library.container_open then
            Library.open()
        else
            Library.close()
        end
    end)

    container.Mobile.MouseButton1Click:Connect(function()
        if not container.Parent then
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

        left_section.Position = UDim2.new(0.297, 0, 1, 0)
        right_section.Position = UDim2.new(0.648, 0, 1, 0)

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

            TweenService:Create(left_section, TweenInfo.new(0.4, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.297, 0, 0.041, 0)
            }):Play()
    
            TweenService:Create(right_section, TweenInfo.new(0.4, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.648, 0, 0.041, 0)
            }):Play()
		end

        left_section.Parent = container.Container
        right_section.Parent = container.Container

        local SectionManager = {}

        function SectionManager:create_section()
            local side = self.side == 'right' and right_section or left_section
            local section_size = 42

            local section = Section.create({
                side = side,
                name = self.name
            })

            local ModuleManager = {}

            function ModuleManager:create_toggle()
                section_size += 26
                
                section.Size = UDim2.new(0, 251, 0, section_size)
                section.Modules.Size = UDim2.new(0, 251, 0, section_size - 29)

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

            function ModuleManager:create_slider()
                section_size += 41
                
                section.Size = UDim2.new(0, 251, 0, section_size)
                section.Modules.Size = UDim2.new(0, 251, 0, section_size - 29)

                if not Library.flags[self.flag] then
                    Library.flags[self.flag] = self.value
                end

                Slider.create({
                    Library = Library,
                    Config = Config,

                    section = section,
                    name = self.name,
                    flag = self.flag,

                    value = Library.flags[self.flag],
                    maximum_value = self.maximum_value,
                    minimum_value = self.minimum_value,

                    callback = self.callback
                })

                self.callback(Library.flags[self.flag])
            end

            function ModuleManager:create_dropdown()
                section_size += 26
                
                section.Size = UDim2.new(0, 251, 0, section_size)
                section.Modules.Size = UDim2.new(0, 251, 0, section_size - 29)

                if not Library.flags[self.flag] then
                    Library.flags[self.flag] = self.option
                end

                Dropdown.create({
                    Library = Library,
                    Config = Config,

                    section = section,
                    name = self.name,
                    flag = self.flag,

                    option = Library.flags[self.flag],
                    options = self.options,

                    callback = self.callback
                })

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

Library.create_notification({
    name = 'Atonium Loaded',
    description = 'Atonium has been loaded successfully',

    __time = 3,
    __type = 'neutral'
})

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
        Library.create_notification({
            name = 'AutoParry',
            description = 'Enabled',

            __time = 1.5,
            __type = 'neutral'
        })
    end
})

auto_parry_section.create_slider({
    name = 'Accuracy',
    flag = 'auto_parry_accuracy',

    value = 80,
    maximum_value = 100,
    minimum_value = 1,

    callback = function(result: number)
        
    end
})

auto_parry_section.create_dropdown({
    name = 'Direction',
    flag = 'direction',

    option = 'Classic',
    options = {'Classic', 'Straight', 'Random', 'High'}

    callback = function(result: string)
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