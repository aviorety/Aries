local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local LocalPlayer = game:GetService('Players').LocalPlayer
local UserInputService = game:GetService('UserInputService')

local mouse = LocalPlayer:GetMouse()

for _, object in CoreGui:GetChildren() do
	if object.Name ~= 'Aries' then
		continue
	end

	object:Destroy()
end

local Library = {}
Library.flags = {}
Library.enabled = true
Library.slider_drag = false

Library.dragging = false
Library.drag_position = nil
Library.start_position = nil


function Library:open()
	self.Container.Visible = true
	self.Shadow.Visible = true
	self.Mobile.Modal = true

	TweenService:Create(self.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 699, 0, 426)
	}):Play()

	TweenService:Create(self.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 776, 0, 509)
	}):Play()
end


function Library:close()
	TweenService:Create(self.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()

	local main_tween = TweenService:Create(self.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 0, 0, 0)
	})

	main_tween:Play()
	main_tween.Completed:Once(function()
		if Library.enabled then
			return
		end

		self.Container.Visible = false
		self.Shadow.Visible = false
		self.Mobile.Modal = false
	end)
end


function Library:drag()
	if not Library.drag_position then
		return
	end
	
	if not Library.start_position then
		return
	end
	
	local delta = self.input.Position - Library.drag_position
	local position = UDim2.new(Library.start_position.X.Scale, Library.start_position.X.Offset + delta.X, Library.start_position.Y.Scale, Library.start_position.Y.Offset + delta.Y)

	TweenService:Create(self.container.Container, TweenInfo.new(0.2), {
		Position = position
	}):Play()

    TweenService:Create(self.container.Shadow, TweenInfo.new(0.2), {
		Position = position
	}):Play()
end


function Library:visible()
	Library.enabled = not Library.enabled

	if Library.enabled then
		Library.open(self)
	else
		Library.close(self)
	end
end


function Library:new()
	local container = game:GetObjects('rbxassetid://17291182583')[1]
	container.Parent = CoreGui

	local tabs = game:GetObjects('rbxassetid://17290916582')[1]
	tabs.Parent = container.Container

	local mobile_button = game:GetObjects('rbxassetid://17338575060')[1]
	mobile_button.Parent = container

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

		if not container or not container.Parent then
			return
		end

		if input.KeyCode == Enum.KeyCode.Insert then
			Library.visible(container)
		end
	end)

	mobile_button.MouseButton1Click:Connect(function()
		Library.visible(container)
	end)

	local Tab = {}

	function Tab:update_sections()
		self.left_section.Visible = true
		self.right_section.Visible = true

		for _, object in container.Container:GetChildren() do
			if not object.Name:find('Section') then
				continue
			end

			if object == self.left_section then
				continue
			end

			if object == self.right_section then
				continue
			end

			object.Visible = false
		end
	end

	function Tab:open_tab()
		Tab.update_sections({
			left_section = self.left_section,
			right_section = self.right_section
		})

		TweenService:Create(self.tab.Fill, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play()

		TweenService:Create(self.tab.Glow, TweenInfo.new(0.4), {
			ImageTransparency = 0
		}):Play()

		TweenService:Create(self.tab.TextLabel, TweenInfo.new(0.4), {
			TextTransparency = 0
		}):Play()

		TweenService:Create(self.tab.Logo, TweenInfo.new(0.4), {
			ImageTransparency = 0
		}):Play()

		for _, object in tabs:GetChildren() do
			if object.Name ~= 'Tab' then
				continue
			end

			if object == self.tab then
				continue
			end

			TweenService:Create(object.Fill, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play()

			TweenService:Create(object.Glow, TweenInfo.new(0.4), {
				ImageTransparency = 1
			}):Play()
	
			TweenService:Create(object.TextLabel, TweenInfo.new(0.4), {
				TextTransparency = 0.5
			}):Play()
	
			TweenService:Create(object.Logo, TweenInfo.new(0.4), {
				ImageTransparency = 0.5
			}):Play()
		end
	end

	function Tab:create_tab()
		local tab = game:GetObjects('rbxassetid://17291017542')[1]
		tab.Parent = tabs
		tab.TextLabel.Text = self

		local left_section = game:GetObjects('rbxassetid://17416841186')[1]
		local right_section = game:GetObjects('rbxassetid://17416847297')[1]

		if container.Container:FindFirstChild('RightSection') then
			left_section.Visible = false
			right_section.Visible = false
		else
			Tab.open_tab({
				tab = tab,
				left_section = left_section,
				right_section = right_section
			})
		end

		left_section.Parent = container.Container
		right_section.Parent = container.Container

		tab.MouseButton1Click:Connect(function()
			Tab.open_tab({
				tab = tab,
				left_section = left_section,
				right_section = right_section
			})
		end)

		local Module = {}

		function Module:create_title()
			local section = self.section == 'left' and left_section or right_section

			local title = game:GetObjects('rbxassetid://17291106124')[1]
			title.Parent = section
			title.Text = self.name
		end

		function Module:enable_toggle()
			TweenService:Create(self.Checkbox.Fill, TweenInfo.new(0.4), {
				BackgroundTransparency = 0
			}):Play()

			TweenService:Create(self.Checkbox.Glow, TweenInfo.new(0.4), {
				ImageTransparency = 0
			}):Play()
		end

		function Module:disable_toggle()
			TweenService:Create(self.Checkbox.Fill, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play()

			TweenService:Create(self.Checkbox.Glow, TweenInfo.new(0.4), {
				ImageTransparency = 1
			}):Play()
		end

		function Module:update_toggle()
			if self.state then
				Module.enable_toggle(self.toggle)
			else
				Module.disable_toggle(self.toggle)
			end
		end

		function Module:create_toggle()
			local section = self.section == 'left' and left_section or right_section

			local toggle = game:GetObjects('rbxassetid://17291122957')[1]
			toggle.Parent = section
			toggle.TextLabel.Text = self.name

			Library.flags[self.flag] = self.enabled
			self.callback(self.enabled)
			
			Module.update_toggle({
				state = self.enabled,
				toggle = toggle
			})

			toggle.MouseButton1Click:Connect(function()
				self.enabled = not self.enabled
				Library.flags[self.flag] = self.enabled

				Module.update_toggle({
					state = self.enabled,
					toggle = toggle
				})

				self.callback(self.enabled)
			end)
		end

		function Module:update_slider()
			local result = math.clamp((mouse.X - self.slider.Box.AbsolutePosition.X) / self.slider.Box.AbsoluteSize.X, 0, 1)

			if not result then
				return
			end

			local number = math.floor(((self.maximum_value - self.minimum_value) * result) + self.minimum_value)
			local slider_size = math.clamp(result, 0.001, 0.999)
			
			self.slider.Box.Fill.UIGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(slider_size, 0),
				NumberSequenceKeypoint.new(math.min(slider_size + 0.001, 1), 1),
				NumberSequenceKeypoint.new(1, 1)
			})
			
			self.slider.Box.Glow.UIGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(slider_size, 0),
				NumberSequenceKeypoint.new(math.min(slider_size + 0.03, 1), 1),
				NumberSequenceKeypoint.new(1, 1)
			})

			Library.flags[self.flag] = number

			self.slider.Number.Text = number
			self.callback(number)
		end

		function Module:slider_loop()
			Library.slider_drag = true
			
			while Library.slider_drag do
				Module.update_slider(self)
				
				task.wait()
			end
		end

		function Module:create_slider()
			local drag = false
			local section = self.section == 'left' and left_section or right_section

			local slider = game:GetObjects('rbxassetid://17382846106')[1]
			slider.Parent = section
			slider.TextLabel.Text = self.name
			slider.Number.Text = self.value

			Library.flags[self.flag] = self.value
			self.callback(self.value)

			slider.Box.Hitbox.MouseButton1Down:Connect(function()
				if Library.slider_drag then
					return
				end

				Module.slider_loop({
					slider = slider,
					flag = self.flag,
					callback = self.callback,

					maximum_value = self.maximum_value,
					minimum_value = self.minimum_value,
				})
			end)
			
			UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Library.slider_drag = false
				end
			end)
		end

		function Module:create_dropdown()
			local section = self.section == 'left' and left_section or right_section
			local list_size = 6
			local open = false

			local option = game:GetObjects('rbxassetid://17401027015')[1]

			local dropdown = game:GetObjects('rbxassetid://17401016934')[1]
			dropdown.Parent = section
			dropdown.Box.TextLabel.Text = self.option

			local Dropdown = {}

			function Dropdown:open()
				TweenService:Create(dropdown.Box.Options, TweenInfo.new(0.4), {
					Size = UDim2.new(0, 202, 0, list_size)
				}):Play()

				TweenService:Create(dropdown, TweenInfo.new(0.4), {
					Size = UDim2.new(0, 215, 0, 30 + list_size)
				}):Play()

				TweenService:Create(dropdown.Box.Arrow, TweenInfo.new(0.4), {
					Rotation = 180
				}):Play()
			end
			
			function Dropdown:close()
				TweenService:Create(dropdown.Box.Options, TweenInfo.new(0.4), {
					Size = UDim2.new(0, 202, 0, 0)
				}):Play()

				TweenService:Create(dropdown, TweenInfo.new(0.4), {
					Size = UDim2.new(0, 215, 0, 36)
				}):Play()

				TweenService:Create(dropdown.Box.Arrow, TweenInfo.new(0.4), {
					Rotation = 0
				}):Play()
			end

			function Dropdown:clear()
				for _, object in dropdown.Box.Options:GetChildren() do
					if object.Name ~= 'Option' then
						continue
					end

					object:Destroy()
				end
			end

			function Dropdown:select_option()
				TweenService:Create(self, TweenInfo.new(0.4), {
					TextTransparency = 0
				}):Play()

				for _, object in dropdown.Box.Options:GetChildren() do
					if object.Name ~= 'Option' then
						continue
					end

					if object == self then
						continue
					end

					TweenService:Create(object, TweenInfo.new(0.4), {
						TextTransparency = 0.5
					}):Play()
				end

				dropdown.Box.TextLabel.Text = self.Text
			end

			function Dropdown:update()
				Dropdown.clear()

				for _, value in self.options do
					list_size += 23

					local new_option = option:Clone()
					new_option.Parent = dropdown.Box.Options
					new_option.Text = value
	
					if value == self.option then
						new_option.TextTransparency = 0
					end
	
					new_option.MouseButton1Click:Connect(function()
						Library.flags[self.flag] = value
						self.callback(value)

						Dropdown.select_option(new_option)
					end)
				end
			end

			Dropdown.update(self)
			Library.flags[self.flag] = self.option

			dropdown.MouseButton1Click:Connect(function()
				open = not open

				if open then
					Dropdown.open()
				else
					Dropdown.close()
				end
			end)

			return Dropdown
		end

		return Module
	end

	return Tab
end


--[[

local main = Library.new()
local tab = main.create_tab('Tab')

tab.create_title({
	name = 'Section',
	section = 'left'
})

tab.create_toggle({
	name = 'Toggle',
	flag = 'toggle',

	section = 'left',
	enabled = false,

	callback = function(state: boolean)
		warn(state)
	end
})

tab.create_slider({
	name = 'Slider',
	flag = 'slider',

	section = 'left',

	value = 50,
	minimum_value = 0,
	maximum_value = 100,

	callback = function(value: number)
		warn(value)
	end
})

tab.create_dropdown({
	flag = 'dropdown',
	section = 'left',

	option = 'Option 1',
	options = {'Option 1', 'Option 2'},

	callback = function(value: string)
		warn(value)
	end
})

tab.create_dropdown({
	name = 'Dropdown',
	flag = 'dropdown',

	section = 'left',

	option = 'Option 1',
	options = {'Option 1', 'Option 2'},

	callback = function(value: string)
		warn(value)
	end
})

]]


return Library