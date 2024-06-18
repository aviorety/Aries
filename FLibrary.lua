local UserInputService = game:GetService('UserInputService')
local LocalPlayer = game:GetService('Players').LocalPlayer
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local CoreGui = game:GetService('CoreGui')

local mouse = LocalPlayer:GetMouse()

local Library = {}
Library.connections = {}
Library.flags = {}
Library.assets = {
    tab = game:GetObjects('rbxassetid://17774101626')[1],
    left_section = game:GetObjects('rbxassetid://17795941028')[1],
    right_section = game:GetObjects('rbxassetid://17795946150')[1],

    label = game:GetObjects('rbxassetid://17796551754')[1],
    toggle = game:GetObjects('rbxassetid://17796652221')[1],
    slider = game:GetObjects('rbxassetid://17898030390')[1],
    dropdown = game:GetObjects('rbxassetid://17900518951')[1],
    option = game:GetObjects('rbxassetid://17900393661')[1]
}

Library.UI = nil
Library.UI_open = true
Library.UI_scale = 1

Library.slider_drag = false

if not isfolder(`Flow`) then
	makefolder(`Flow`)
end

function Library:save_flags()
	if not Library.UI or not Library.UI.Parent then
		return
	end

	local flags = HttpService:JSONEncode(Library.flags)
	writefile(`Flow/{game.GameId}.lua`, flags)
end


function Library:load_flags()
	if not isfile(`Flow/{game.GameId}.lua`) then
		Library.save_flags()

		return
	end

	local flags = readfile(`Flow/{game.GameId}.lua`)

	if not flags then
		Library.save_flags()

		return
	end
	
	Library.flags = HttpService:JSONDecode(flags)
end


Library.load_flags()


function Library:get_screen_scale()
    local viewport_size_x = workspace.CurrentCamera.ViewportSize.X
    local viewport_size_y = workspace.CurrentCamera.ViewportSize.Y

    local screen_size = (viewport_size_x + viewport_size_y) / 3000
    local screen_size_threshold = math.max(0.85 - screen_size, 0)

    Library.UI_scale = screen_size + screen_size_threshold
end


for _, object in CoreGui:GetChildren() do
    if object.Name ~= 'Flow' then
        continue
    end

    object:Destroy()
end


function Library.new()
    Library.UI = game:GetObjects('rbxassetid://17899813159')[1]
    Library.UI.Parent = CoreGui

    Library.connections['rescale'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
        Library.get_screen_scale()
    
        if not Library.UI_open then
            return
        end

        Library.UI.Container.UIScale.Scale = Library.UI_scale
    end)

    Library.connections['ui_detect'] = Library.UI.Changed:Connect(function()
        if Library.UI and Library.UI.Parent then
            return
        end
    
        for _, value in Library.connections do
            if typeof(value) == 'function' then
                continue
            end
    
            value:Disconnect()
        end
    end)

    function Library:open()
        TweenService:Create(Library.UI.Container.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Scale = Library.UI_scale
        }):Play()
    end

    function Library:close()
        TweenService:Create(Library.UI.Container.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Scale = 0
        }):Play()
    end

    UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if not Library.UI or not Library.UI.Parent then
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

    local TabManager = {}

    function TabManager:create_tab()
        local tab = Library.assets.tab:Clone()
        tab.Label.Text = self.name
        tab.Icon.Image = self.icon

        local left_section = Library.assets.left_section:Clone()
        left_section.Parent = Library.UI.Container

        local right_section = Library.assets.right_section:Clone()
        right_section.Parent = Library.UI.Container

        if not Library.UI.Container.Tabs.List:FindFirstChild('Tab') then
            TweenService:Create(tab.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 0
            }):Play()

            TweenService:Create(tab.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 0
            }):Play()

            TweenService:Create(tab.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 0
            }):Play()

            TweenService:Create(tab.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                TextTransparency = 0
            }):Play()
            
            left_section.List.UIPadding.PaddingTop = UDim.new(0, 1000)
            right_section.List.UIPadding.PaddingTop = UDim.new(0, 1000)

            left_section.List.UIListLayout.Padding = UDim.new(0, 1000)
            right_section.List.UIListLayout.Padding = UDim.new(0, 1000)
            
            TweenService:Create(left_section.List.UIPadding, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                PaddingTop = UDim.new(0, 10)
            }):Play()
                        
            TweenService:Create(right_section.List.UIPadding, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                PaddingTop = UDim.new(0, 10)
            }):Play()
            
            TweenService:Create(left_section.List.UIListLayout, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Padding = UDim.new(0, 2)
            }):Play()

            TweenService:Create(right_section.List.UIListLayout, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Padding = UDim.new(0, 2)
            }):Play()
        else
            left_section.Visible = false
            right_section.Visible = false
        end

        tab.Parent = Library.UI.Container.Tabs.List

        local function update()
            for _, object in Library.UI.Container:GetChildren() do
                if not object.Name:find('Section') then
                    continue
                end

                if object == left_section or object == right_section then
                    object.Visible = true
                    object.List.UIPadding.PaddingTop = UDim.new(0, 1000)
                    object.List.UIListLayout.Padding = UDim.new(0, 1000)
                    
                    TweenService:Create(object.List.UIPadding, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                        PaddingTop = UDim.new(0, 10)
                    }):Play()

                    TweenService:Create(object.List.UIListLayout, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                        Padding = UDim.new(0, 2)
                    }):Play()

                    continue
                end

                object.Visible = false
            end

            for _, object in Library.UI.Container.Tabs.List:GetChildren() do
                if object.Name ~= 'Tab' then
                    continue
                end

                if object == tab then
                    TweenService:Create(object.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        ImageTransparency = 0
                    }):Play()
    
                    TweenService:Create(object.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        ImageTransparency = 0
                    }):Play()
    
                    TweenService:Create(object.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        ImageTransparency = 0
                    }):Play()
    
                    TweenService:Create(object.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        TextTransparency = 0
                    }):Play()

                    continue
                end

                TweenService:Create(object.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()

                TweenService:Create(object.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()

                TweenService:Create(object.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.8
                }):Play()

                TweenService:Create(object.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 0.8
                }):Play()
            end
        end

        tab.MouseEnter:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 138, 0, 36)
            }):Play()
            
            TweenService:Create(tab.Fill, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 138, 0, 36)
            }):Play()
            
            TweenService:Create(tab.Glow, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 153, 0, 50)
            }):Play()
        end)
        
        tab.MouseLeave:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 135, 0, 33)
            }):Play()
            
            TweenService:Create(tab.Fill, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 135, 0, 33)
            }):Play()
            
            TweenService:Create(tab.Glow, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 148, 0, 45)
            }):Play()
        end)

        tab.MouseButton1Click:Connect(function()
            update()
        end)

        local ModuleManager = {}

        function ModuleManager:create_label()
            local section = self.section == 'right' and right_section.List or left_section.List
            
            local label = Library.assets.label:Clone()
            label.Parent = section
            label.Text = self.name
        end

        function ModuleManager:create_toggle()
            local section = self.section == 'right' and right_section.List or left_section.List
            
            local toggle = Library.assets.toggle:Clone()
            toggle.Parent = section
            toggle.Label.Text = self.name

            local function enable()
                TweenService:Create(toggle.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 0
                }):Play()

                TweenService:Create(toggle.Box.Checkmark, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 0
                }):Play()

                TweenService:Create(toggle.Box.Checkmark.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Scale = 1
                }):Play()

                TweenService:Create(toggle.Box.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0
                }):Play()

                TweenService:Create(toggle.Box.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.2
                }):Play()
            end

            local function disable()
                TweenService:Create(toggle.Label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 0.8
                }):Play()
                
                TweenService:Create(toggle.Box.Checkmark, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 360
                }):Play()

                TweenService:Create(toggle.Box.Checkmark.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Scale = 0
                }):Play()

                TweenService:Create(toggle.Box.Fill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()

                TweenService:Create(toggle.Box.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()
            end

            if Library.flags[self.flag] then
                self.callback(Library.flags[self.flag])
                enable()
            end

            toggle.MouseButton1Click:Connect(function()
                Library.flags[self.flag] = not Library.flags[self.flag]
                self.callback(Library.flags[self.flag])
                Library.save_flags()

                if Library.flags[self.flag] then
                    enable()
                else
                    disable()
                end
            end)
        end

        function ModuleManager:create_slider()
            local section = self.section == 'right' and right_section.List or left_section.List
            
            local slider = Library.assets.slider:Clone()
            slider.Parent = section
            slider.Label.Text = self.name

            if not Library.flags[self.flag] then
                Library.flags[self.flag] = self.value
            end

            slider.Value.Text = Library.flags[self.flag]
            self.callback(Library.flags[self.flag])

            local function update_slider()
                local result = math.clamp((mouse.X - slider.Box.AbsolutePosition.X) / slider.Box.AbsoluteSize.X + 0.02, 0, 1)
                local number = math.floor(result * self.maximum_value)
                local number_threshold = math.clamp(number, self.minimum_value, self.maximum_value)

                TweenService:Create(slider.Box.Fill, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, result * 220, 0, 5)
                }):Play()
    
                Library.flags[self.flag] = number_threshold
                slider.Value.Text = number_threshold
                self.callback(number_threshold)
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

            local result = math.clamp((Library.flags[self.flag] - self.minimum_value) / (self.maximum_value - self.minimum_value), 0, 1)

            TweenService:Create(slider.Box.Fill, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, result * 220, 0, 5)
            }):Play()
			
			Library.connections[`slider_input_{self.flag}`] = UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Library.slider_drag = false
					Library.save_flags()
				end
			end)
        end

        function ModuleManager:create_dropdown()
            local section = self.section == 'right' and right_section.List or left_section.List
            local list_open = false
            local list_size = 3
            
            local dropdown = Library.assets.dropdown:Clone()
            dropdown.Parent = section
            dropdown.Box.Label.Text = self.name

            if not Library.flags[self.flag] then
                Library.flags[self.flag] = self.option
            end

            dropdown.Box.Label.Text = Library.flags[self.flag]
            self.callback(Library.flags[self.flag])

            local function update()
                for _, object in dropdown.Box.Options.List:GetChildren() do
                    if object.Name ~= 'Option' then
                        continue
                    end

                    if object.Text == Library.flags[self.flag] then
                        TweenService:Create(object, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                            TextTransparency = 0
                        }):Play()

                        continue
                    end

                    TweenService:Create(object, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                        TextTransparency = 0.8
                    }):Play()
                end
            end

            local function open()
                dropdown.Box.Label.Text = Library.flags[self.flag]

                TweenService:Create(dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 242, 0, 40 + list_size)
                }):Play()

                TweenService:Create(dropdown.Box.Options, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 219, 0, list_size)
                }):Play()

                TweenService:Create(dropdown.Box.Options.List, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 219, 0, list_size - 3)
                }):Play()

                TweenService:Create(dropdown.Box.Arrow, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 540
                }):Play()
            end

            local function close()
                dropdown.Box.Label.Text = self.name

                TweenService:Create(dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 242, 0, 40)
                }):Play()

                TweenService:Create(dropdown.Box.Options, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 219, 0, 0)
                }):Play()

                TweenService:Create(dropdown.Box.Options.List, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 219, 0, 0)
                }):Play()

                TweenService:Create(dropdown.Box.Arrow, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                    Rotation = 0
                }):Play()
            end

            for index, value in self.options do
                if index <= self.maximum_options then
                    list_size += 16
                end

                local option = Library.assets.option:Clone()
                option.Text = value
                option.Parent = dropdown.Box.Options.List

                option.MouseButton1Click:Connect(function()
                    Library.flags[self.flag] = value

                    if list_open then
                        dropdown.Box.Label.Text = Library.flags[self.flag]
                    end

                    update()
                    self.callback(Library.flags[self.flag])
                    Library.save_flags()
                end)
            end

            update()

            dropdown.MouseButton1Click:Connect(function()
                list_open = not list_open

                if list_open then
                    open()
                else
                    close()
                end
            end)
        end

        return ModuleManager
    end

    return TabManager
end


function Library.__init()
    if not Library.UI then
        return
    end

    Library.get_screen_scale()

    Library.UI.Container.UIScale.Scale = 0
    Library.UI.Watermark.UIScale.Scale = 0
    
    Library.UI.Container.Tabs.List.UIPadding.PaddingTop = UDim.new(0, 1000)
    Library.UI.Container.Tabs.List.UIListLayout.Padding = UDim.new(0, 1000)

    TweenService:Create(Library.UI.Container.UIScale, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Scale = Library.UI_scale
    }):Play()

    TweenService:Create(Library.UI.Watermark.UIScale, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Scale = Library.UI_scale + 0.1
    }):Play()
    
    TweenService:Create(Library.UI.Container.Tabs.List.UIPadding, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        PaddingTop = UDim.new(0, 10)
    }):Play()
    
    TweenService:Create(Library.UI.Container.Tabs.List.UIListLayout, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Padding = UDim.new(0, 4)
    }):Play()
end


--[[
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/aviorety/Aries/main/FLibrary.lua'))()
local main = Library.new()

local blatant = main.create_tab({
    name = 'Blatant',
    icon = 'rbxassetid://17773816885'
})

blatant.create_label({
    name = 'AutoParry',
    section = 'left'
})

blatant.create_toggle({
    name = 'Enabled',
    flag = 'auto_parry',
    section = 'left',

    callback = function(value: boolean)
        
    end
})

blatant.create_slider({
    name = 'Accuracy',
    flag = 'auto_parry_accuracy',
    section = 'left',

    value = 100,
    maximum_value = 100,
    minimum_value = 1,

    callback = function(value: number)
        
    end
})

blatant.create_dropdown({
    name = 'Curve',
    flag = 'auto_parry_curve',
    section = 'left',

    option = 'Camera',
    options = {'Camera', 'Straight', 'High', 'Random'},
    maximum_options = 4,

    callback = function(value: string)
        
    end
})

local visuals = main.create_tab({
    name = 'Visuals',
    icon = 'rbxassetid://17773816885'
})

local misc = main.create_tab({
    name = 'Misc',
    icon = 'rbxassetid://17773816885'
})

local settings = main.create_tab({
    name = 'Settings',
    icon = 'rbxassetid://17773816885'
})

Library.__init()
]]

return Library