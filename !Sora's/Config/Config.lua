local Sora = LibStub("AceAddon-3.0"):NewAddon("Sora", "AceConsole-3.0")


-- Sora
function Sora:ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 780, 500)
	LibStub("AceConfigDialog-3.0"):Open("Sora's Config")
end

-- OnInitialize
function Sora:OnInitialize()
	Modules = {}
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Sora's Config", {
		type = "group",
		name = "|cff70C0F5Sora's|r",
		args = Modules,
	})
	Sora:RegisterChatCommand("Sora", "ShowConfig")
end
