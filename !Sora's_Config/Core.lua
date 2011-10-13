-- Engines
local S, C, _, _ = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):NewAddon("SoraConfig", "AceConsole-3.0")
Modules = {}

-- ShowConfig
local function ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 780, 500)
	LibStub("AceConfigDialog-3.0"):Open("Sora's Config")
end

-- OnFristLoad
local function OnFristLoad()
	for _, value in pairs(C) do
		value.LoadSettings()
		value.BuildGUI()
		SoraInited = true
	end
end

-- OnInitialize
function SoraConfig:OnInitialize()
	if not SoraInited then OnFristLoad() end
	for _, value in pairs(C) do
		value.LoadSettings()
		value.BuildGUI()
	end
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Sora's Config", {
		type = "group",
		name = "|cff70C0F5Sora's|r",
		args = Modules,
	})
	SoraConfig:RegisterChatCommand("Sora", ShowConfig)
end
