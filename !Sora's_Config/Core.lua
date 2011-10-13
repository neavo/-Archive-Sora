-- Engines
local S, C, _, DB = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):NewAddon("SoraConfig", "AceConsole-3.0")
Modules = {}

-- ShowConfig
function SoraConfig:ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 780, 500)
	LibStub("AceConfigDialog-3.0"):Open("Sora's Config")
end

-- OnInitialize
function SoraConfig:OnInitialize()
	for _, value in pairs(C) do
		value.LoadSettings()
		value.BuildGUI()
	end
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Sora's Config", {
		type = "group",
		name = "|cff70C0F5Sora's|r",
		args = Modules,
	})
	SoraConfig:RegisterChatCommand("Sora", "ShowConfig")
end
