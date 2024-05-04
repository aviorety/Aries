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

		local left_section = game:GetObjects('rbxassetid://17291069143')[1]
		local right_section = game:GetObjects('rbxassetid://17291072834')[1]

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
			
			self.Fill.UIGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(slider_size, 0),
				NumberSequenceKeypoint.new(math.min(slider_size + 0.001, 1), 1),
				NumberSequenceKeypoint.new(1, 1)
			})
			
			self.Glow.UIGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(slider_size, 0),
				NumberSequenceKeypoint.new(math.min(slider_size + 0.03, 1), 1),
				NumberSequenceKeypoint.new(1, 1)
			})

			Library.flags[self.flag] = number

			self.TextLabel.Text = number
			self.callback(number)
		end

		function Module:slider_loop()
			Library.slider_drag = true
			
			while Library.slider_drag do
				Slider.update_slider(self)
				
				task.wait()
			end
		end

		function Module:create_slider()
			local drag = false
			local section = self.section == 'left' and left_section or right_section

			local slider = game:GetObjects('rbxassetid://17382405626')[1]
			slider.Parent = section
			slider.TextLabel.Text = self.name
			slider.Number.Text = self.value

			Library.flags[self.flag] = self.value
			self.callback(self.value)

			slider.Hitbox.MouseButton1Down:Connect(function()
				if Library.slider_drag then
					return
				end

				Module.slider_loop({
					slider = slider,
					flag = self.flag,
					callback = self.callback,

					maximum_value = self.maximum_value,
					minumum_value = self.minumum_value,
				})
			end)
			
			UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Library.slider_drag = false
				end
			end)
		end

		return Module
	end

	return Tab
end


return Library
