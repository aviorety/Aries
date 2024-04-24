local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

for _, object in CoreGui:GetChildren() do
	if object.Name ~= 'Aries' then
		continue
	end
	
	object:Destroy()
end

local GUI_OPEN = true

local Library = {}
Library.flags = {}


function Library:update_toggle()
	if self.state then
		TweenService:Create(self.toggle.Checkbox, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(65, 80, 133)
		}):Play()
		
		TweenService:Create(self.toggle.Checkbox.UIStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(83, 103, 171)
		}):Play()
	else
		TweenService:Create(self.toggle.Checkbox, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(31, 31, 37)
		}):Play()

		TweenService:Create(self.toggle.Checkbox.UIStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(40, 41, 50)
		}):Play()
	end
end


function Library:visible()
	GUI_OPEN = not GUI_OPEN
	
	if not GUI_OPEN then
		TweenService:Create(self.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
			Size = UDim2.new(0, 0, 0, 0)
		}):Play()

		local main_tween = TweenService:Create(self.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
			Size = UDim2.new(0, 0, 0, 0)
		})

		main_tween:Play()
		main_tween.Completed:Once(function()
			if GUI_OPEN then
				return
			end

			self.Enabled = false
		end)
	else
		self.Enabled = true

		TweenService:Create(self.Container, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
			Size = UDim2.new(0, 739, 0, 437)
		}):Play()

		TweenService:Create(self.Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
			Size = UDim2.new(0, 810, 0, 491)
		}):Play()
	end
end


function Library:new()
	local screen_gui = game:GetObjects('rbxassetid://17193047920')[1]
	screen_gui.Parent = CoreGui
	
	local container = game:GetObjects('rbxassetid://17254016336')[1]
	container.Parent = screen_gui
	
	local shadow = game:GetObjects('rbxassetid://17253947320')[1]
	shadow.Parent = screen_gui
	
	local mobile_button = game:GetObjects('rbxassetid://17253950757')[1]
	mobile_button.Parent = screen_gui
	
	UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
		if process then
			return
		end

		if input.KeyCode == Enum.KeyCode.Insert then
			Library.visible(screen_gui)
		end
	end)
	
	mobile_button.MouseButton1Click:Connect(function()
		Library.visible({
			container = container,
			shadow = shadow
		})
	end)
	
	local tabs = game:GetObjects('rbxassetid://17253920558')[1]
	tabs.Parent = container
	
	local TabFunctions = {}
	
	function TabFunctions:update_sections()
		for _, object in container:GetChildren() do
			if object.Name:find('Sections') then
				object.Visible = false
			end
		end

		self.section_1.Visible = true
		self.section_2.Visible = true
	end

	function TabFunctions:update_tabs()
		TabFunctions.update_sections({
			section_1 = self.section_1,
			section_2 = self.section_2
		})

		TweenService:Create(self.tab, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(65, 80, 133)
		}):Play()
		
		TweenService:Create(self.tab.UIStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(83, 103, 171)
		}):Play()

		for _, object in tabs:GetChildren() do
			if object == self.tab then
				continue
			end

			if object.Name == 'Tab' then
				TweenService:Create(object, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(30, 30, 34)
				}):Play()

				TweenService:Create(object.UIStroke, TweenInfo.new(0.2), {
					Color = Color3.fromRGB(37, 37, 44)
				}):Play()
			end
		end
	end
	
	function TabFunctions:create_tab()
		local tab = game:GetObjects('rbxassetid://17253894877')[1]
		tab.Parent = tabs
		tab.TabName.Text = self

		local section_1 = game:GetObjects('rbxassetid://17253867101')[1]
		local section_2 = game:GetObjects('rbxassetid://17253865212')[1]

		if container:FindFirstChild('RightSections') then
			section_1.Visible = false
			section_2.Visible = false
		else
			TabFunctions.update_tabs({
				tab = tab,
				section_1 = section_1,
				section_2 = section_2
			})
		end

		section_1.Parent = container
		section_2.Parent = container

		tab.MouseButton1Click:Connect(function()
			TabFunctions.update_tabs({
				tab = tab,
				section_1 = section_1,
				section_2 = section_2
			})
		end)
		
		local SectionFunctions = {}
		
		function SectionFunctions:create_section()
			local section_side = self.side == 'right' and section_2 or section_1
			local section_size = 20
			
			local section_name = game:GetObjects('rbxassetid://17253851933')[1]
			section_name.Text = self.name
			section_name.Parent = section_side
			
			local section = game:GetObjects('rbxassetid://17253909862')[1]
			section.Parent = section_side
			
			local Functions = {}

			function Functions:create_toggle()
				section_size += 15
				section.Size = UDim2.new(0, 234, 0, section_size)
				
				local toggle = game:GetObjects('rbxassetid://17253905947')[1]
				toggle.ToggleName.Text = self.name
				toggle.Parent = section
				
				Library.update_toggle({
					toggle = toggle,
					state = self.state
				})
				
				self.callback(self.state)
                Library.flags[self.flag] = self.state
				
				toggle.MouseButton1Click:Connect(function()
					self.state = not self.state
                    Library.flags[self.flag] = self.state
					
					Library.update_toggle({
						toggle = toggle,
						state = self.state
					})
					
					self.callback(self.state)
				end)
			end
			
			return Functions
		end

		return SectionFunctions
	end

	return TabFunctions
end


return Library
