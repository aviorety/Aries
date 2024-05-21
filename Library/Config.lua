local HttpService = game:GetService('HttpService')

local Config = {}


function Config:save_flags()
	if not self.container or not self.container.Parent then
		return
	end

	local flags = HttpService:JSONEncode(self.flags)
	writefile(`Atonium/{game.GameId}.lua`, flags)
end


function Config:load_flags()
	if not isfile(`Atonium/{game.GameId}.lua`) then
		Config.save_flags(self)

		return
	end

	local flags = readfile(`Atonium/{game.GameId}.lua`)

	if not flags then
		Config.save_flags(self)

		return
	end
	
	self.flags = HttpService:JSONDecode(flags)
end


return Config