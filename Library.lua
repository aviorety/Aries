local UserInputService = game:GetService('UserInputService')
local LocalPlayer = game:GetService('Players').LocalPlayer
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local CoreGui = game:GetService('CoreGui')

local mouse = LocalPlayer:GetMouse()

local Library = {}
Library.assets = {
    tab = game:GetObjects('rbxassetid://17594615079')[1],
    left_section = game:GetObjects('rbxassetid://17625905436')[1],
    middle_section = game:GetObjects('rbxassetid://17625910943')[1],
    right_section = game:GetObjects('rbxassetid://17625913258')[1],

    title = game:GetObjects('rbxassetid://17595506467')[1],
    toggle = game:GetObjects('rbxassetid://17595515058')[1],
    slider = game:GetObjects('rbxassetid://17595853646')[1],
    dropdown = game:GetObjects('rbxassetid://17625931042')[1],
    option = game:GetObjects('rbxassetid://17625935548')[1]
}
Library.flags = {}
Library.connections = {}

Library.UI = nil
Library.UI_open = true

Library.slider_drag = false

if not isfolder(`Atonium`) then
	makefolder(`Atonium`)
end


function Library:disconnect()
    for _, value in Library.connections do
        if not Library.connections[value] then
            continue
        end

        Library.connections[value]:Disconnect()
        Library.connections[value] = nil
    end
end


function Library:clear()
    for _, object in CoreGui:GetChildren() do
        if object.Name ~= 'Atonium' then
            continue
        end

        object:Destroy()
    end
end


function Library:save_flags()
	if not Library.UI or not Library.UI.Parent then
		return
	end

	local flags = HttpService:JSONEncode(Library.flags)
	writefile(`Atonium/{game.GameId}.lua`, flags)
end


function Library:load_flags()
	if not isfile(`Atonium/{game.GameId}.lua`) then
		Library.save_flags()

		return
	end

	local flags = readfile(`Atonium/{game.GameId}.lua`)

	if not flags then
		Library.save_flags()

		return
	end
	
	Library.flags = HttpService:JSONDecode(flags)
end


Library.load_flags()
Library.clear()


function Library:__init()
    local UI = game:GetObjects('rbxassetid://17626007114')[1]
    UI.Parent = CoreGui
    UI.Container.UIScale.Scale = 0

    Library.UI = UI

    function Library:open()
        TweenService:Create(UI.Container.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Scale = 1
        }):Play()
    end

    function Library:close()
        TweenService:Create(UI.Container.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Scale = 0
        }):Play()
    end

    Library.open()

    UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if not UI or not UI.Parent then
            return
        end

        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            Library.UI_open = not Library.UI_open

            if Library.UI_open then
                Library.open()
            else
                Library.close()
            end
        end
    end)

    UI.Mobile.MouseButton1Click:Connect(function()
        Library.UI_open = not Library.UI_open

        if Library.UI_open then
            Library.open()
        else
            Library.close()
        end
    end)

    local TabsManager = {}
    TabsManager.tab_value = -1
    TabsManager.tab_size = 8

    function TabsManager:update()
        for _, object in UI.Container.Top.Tabs.Storage:GetChildren() do
            if object.Name ~= 'Tab' then
                continue
            end

            if object == self.tab then
                TweenService:Create(object.Icon, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0
                }):Play()

                continue
            end

            TweenService:Create(object.Icon, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.5
            }):Play()
        end

        for _, object in UI.Container:GetChildren() do
            if not object.Name:find('Section') then
                continue
            end

            if object == self.left_section or object == self.middle_section or object == self.right_section then
                object.Size = UDim2.new(0, 222, 0, 0)
                object.UIListLayout.Padding = UDim.new(0, 500)
                object.Visible = true

                TweenService:Create(object.UIListLayout, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Padding = UDim.new(0, 6)
                }):Play()

                TweenService:Create(object, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 222, 0, 341)
                }):Play()

                continue
            end

            object.Size = UDim2.new(0, 222, 0, 0)
            object.UIListLayout.Padding = UDim.new(0, 1000)
            object.Visible = false
        end
    end

    function TabsManager:create_tab()
        TabsManager.tab_value += 1
        TabsManager.tab_size += 40

        local tab_value = TabsManager.tab_value
        local tab = Library.assets.tab:Clone()
        tab.Icon.Image = self

        local left_section = Library.assets.left_section:Clone()
        left_section.Parent = UI.Container

        local middle_section = Library.assets.middle_section:Clone()
        middle_section.Parent = UI.Container

        local right_section = Library.assets.right_section:Clone()
        right_section.Parent = UI.Container

        if not UI.Container.Top.Tabs.Storage:FindFirstChild('Tab') then
            tab.Parent = UI.Container.Top.Tabs.Storage

            TabsManager.update({
                tab = tab,
                left_section = left_section,
                middle_section = middle_section,
                right_section = right_section
            })
        else
            left_section.Visible = false
            middle_section.Visible = false
            right_section.Visible = false
        end

        tab.Parent = UI.Container.Top.Tabs.Storage

        TweenService:Create(UI.Container.Top.Tabs, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, TabsManager.tab_size, 0, 30)
        }):Play()

        TweenService:Create(UI.Container.Top.Tabs.Storage, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, TabsManager.tab_size - 8, 0, 30)
        }):Play()

        tab.MouseButton1Click:Connect(function()
            local fill_offset = 0.02 + (0.24 * tab_value)

            TweenService:Create(UI.Container.Top.Tabs.Fill, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Position = UDim2.new(fill_offset, 0, 0.5, 0)
            }):Play()

            TabsManager.update({
                tab = tab,
                left_section = left_section,
                middle_section = middle_section,
                right_section = right_section
            })
        end)

        local ModulesManager = {}

        function ModulesManager:create_title()
            local section = self.section == 'middle' and middle_section or self.section == 'right' and right_section or left_section

            local title = Library.assets.title:Clone()
            title.Parent = section
            title.Text = self.name
        end

        function ModulesManager:create_toggle()
            local section = self.section == 'middle' and middle_section or self.section == 'right' and right_section or left_section

            local toggle = Library.assets.toggle:Clone()
            toggle.Parent = section
            toggle.ToggleName.Text = self.name
            toggle.Box.Checkmark.Rotation = 360

            local function enable()
                TweenService:Create(toggle.Box, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    BackgroundColor3 = Color3.fromRGB(43, 80, 208)
                }):Play()

                TweenService:Create(toggle.Box.Checkmark.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Scale = 1
                }):Play()

                TweenService:Create(toggle.Box.Checkmark, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 0
                }):Play()
            end

            local function disable()
                TweenService:Create(toggle.Box, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    BackgroundColor3 = Color3.fromRGB(18, 18, 21)
                }):Play()

                TweenService:Create(toggle.Box.Checkmark.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Scale = 0
                }):Play()

                TweenService:Create(toggle.Box.Checkmark, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 360
                }):Play()
            end

            if not Library.flags[self.flag] then
                Library.flags[self.flag] = false
            end

            if Library.flags[self.flag] then
                enable()
            end

            self.callback(Library.flags[self.flag])

            toggle.MouseButton1Click:Connect(function()
                Library.flags[self.flag] = not Library.flags[self.flag]
                Library.save_flags()

                if Library.flags[self.flag] then
                    enable()
                else
                    disable()
                end

                self.callback(Library.flags[self.flag])
            end)
        end

        function ModulesManager:create_slider()
            local section = self.section == 'middle' and middle_section or self.section == 'right' and right_section or left_section

            local slider = Library.assets.slider:Clone()
            slider.Parent = section
            slider.SliderName.Text = self.name

            local slider_value = Instance.new('NumberValue', slider)
            slider_value.Name = 'slider_value'

            if not Library.flags[self.flag] then
                Library.flags[self.flag] = self.value
            end

            slider.SliderValue.Text = Library.flags[self.flag]
            self.callback(Library.flags[self.flag])

            local function update_slider()
                local result = math.clamp((mouse.X - slider.Box.AbsolutePosition.X) / slider.Box.AbsoluteSize.X, 0, 1)
    
                if not result then
                    return
                end
    
                local number = math.floor(((self.maximum_value - self.minimum_value) * result) + self.minimum_value)
                local slider_size = math.clamp(result, 0.001, 0.999)

                TweenService:Create(slider_value, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    Value = slider_size
                }):Play()
    
                Library.flags[self.flag] = number
                slider.SliderValue.Text = number
                self.callback(number)
            end

            slider.Box.Hitbox.MouseButton1Down:Connect(function()
				if Library.slider_drag then
					return
				end

				Library.slider_drag = true
                
                task.defer(function()
                    while Library.slider_drag do
                        update_slider()

                        task.wait()
                    end
                end)
			end)

            slider_value.Changed:Connect(function()
                slider.Box.Fill.UIGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(slider_value.Value, 0),
                    NumberSequenceKeypoint.new(math.min(slider_value.Value + 0.001, 1), 1),
                    NumberSequenceKeypoint.new(1, 1)
                })
            end)

            local result = (Library.flags[self.flag] - self.minimum_value) / (self.maximum_value - self.minimum_value)
            local slider_size = math.clamp(result, 0.001, 0.999)

            slider_value.Value = slider_size
			
			Library.connections[`slider_input_{self.flag}`] = UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
                if not UI or not UI.Parent then
                    Library.disconnect()

                    return
                end

				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Library.slider_drag = false
					Library.save_flags()
				end
			end)
        end

        function ModulesManager:create_dropdown()
            local section = self.section == 'middle' and middle_section or self.section == 'right' and right_section or left_section

            local list_size = 4
            local list_open = false

            local dropdown = Library.assets.dropdown:Clone()
            dropdown.Parent = section
            dropdown.Box.DropdownName.Text = self.name

            if not Library.flags[self.flag] then
                Library.flags[self.flag] = self.option
            end

            local function update()
                for _, object in dropdown.Box.Options.Options:GetChildren() do
                    if object.Name ~= 'Option' then
                        continue
                    end

                    if object.Text == Library.flags[self.flag] then
                        TweenService:Create(object, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                            TextTransparency = 0
                        }):Play()

                        continue
                    end

                    TweenService:Create(object, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                        TextTransparency = 0.5
                    }):Play()
                end
            end

            local function open()
                dropdown.Box.DropdownName.Text = Library.flags[self.flag]

                TweenService:Create(dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 222, 0, 39 + list_size)
                }):Play()

                TweenService:Create(dropdown.Box.Options, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 200, 0, list_size)
                }):Play()

                TweenService:Create(dropdown.Box.Options.Options, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 200, 0, list_size)
                }):Play()

                TweenService:Create(dropdown.Box.Arrow, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 540
                }):Play()
            end

            local function close()
                dropdown.Box.DropdownName.Text = self.name

                TweenService:Create(dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 222, 0, 44)
                }):Play()

                TweenService:Create(dropdown.Box.Options, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 200, 0, 0)
                }):Play()

                TweenService:Create(dropdown.Box.Options.Options, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 200, 0, 0)
                }):Play()

                TweenService:Create(dropdown.Box.Arrow, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 0
                }):Play()
            end

            for index, value in self.options do
                if index <= self.maximum_options then
                    list_size += 20
                end

                local option = Library.assets.option:Clone()
                option.Text = value
                option.Parent = dropdown.Box.Options.Options

                option.MouseButton1Click:Connect(function()
                    Library.flags[self.flag] = value

                    if list_open then
                        dropdown.Box.DropdownName.Text = Library.flags[self.flag]
                    end

                    update()
                    self.callback(Library.flags[self.flag])
                    Library.save_flags()
                end)
            end

            dropdown.MouseButton1Click:Connect(function()
                list_open = not list_open

                if list_open then
                    open()
                else
                    close()
                end
            end)

            update()
        end

        return ModulesManager
    end

    return TabsManager
end


--[[
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/NewLibrary.lua'))()
local main = Library.__init()

local blatant = main.create_tab('rbxassetid://17594480612')

blatant.create_title({
    name = 'AutoParry',
    section = 'left'
})

blatant.create_toggle({
    name = 'Enabled',
    flag = 'auto_parry',
    section = 'left',

    callback = function(result: string)
        
    end
})

blatant.create_slider({
    name = 'Accuracy',
    flag = 'auto_parry_accuracy',
    section = 'left',

    value = 100,
    maximum_value = 100,
    minimum_value = 1,

    callback = function(result: number)
        
    end
})

blatant.create_dropdown({
    name = 'Direction',
    flag = 'auto_parry_direction',
    section = 'left',

    option = 'Classic',
    options = {'Classic', 'Straight', 'High', 'Random'},
    maximum_options = 3,

    callback = function(result: string)
        
    end
})

local ai_title = blatant.create_title({
    name = 'AI',
    section = 'middle'
})

local ai_toggle = blatant.create_toggle({
    name = 'Enabled',
    flag = 'ai',
    section = 'middle',

    callback = function(result: string)
        
    end
})

local world = main.create_tab('rbxassetid://17594472203')

local custom_ball_title = world.create_title({
    name = 'CustomBall',
    section = 'left'
})

local custom_ball_toggle = world.create_toggle({
    name = 'Enabled',
    flag = 'custom_ball',
    section = 'left',
    
    callback = function(result: string)
        
    end
})

local misc = main.create_tab('rbxassetid://17594481589')
local settings = main.create_tab('rbxassetid://17594482300')
]]

return Library