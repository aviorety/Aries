local HttpService = game:GetService('HttpService')

local Config = {}


function Config:save_flags()
	if not self.exist() then
		return
	end

	local flags = HttpService:JSONEncode(self.flags)
	writefile(`Aries/{game.GameId}.lua`, flags)
end


function Config:load_flags()
	if not isfile(`Aries/{game.GameId}.lua`) then
		Config.save_flags(self)

		return
	end

	local flags = readfile(`Aries/{game.GameId}.lua`)

	if not flags then
		Config.save_flags(self)

		return
	end
	
	self.flags = HttpService:JSONDecode(flags)
end


return Config