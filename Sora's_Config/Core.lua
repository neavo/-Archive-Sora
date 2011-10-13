-- Engines
local S, C, _, _ = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):NewAddon("SoraConfig", "AceConsole-3.0")

-- ResetToDefault
local function ResetToDefault()
	for _, value in pairs(C) do
		value.ResetToDefault()
	end
	ReloadUI()
end

-- OnFristLoad
local function OnFristLoad()
	for _, value in pairs(C) do
		value.LoadSettings()
		value.BuildGUI()
		SoraInited = true
	end
end

Modules = {
	ResetToDefault = {
		type = "execute",
		name = "恢复默认设置",
		order = 1,
		func = function() ResetToDefault() end
	},
	Hiden_1 = {
		type = "execute",
		name = " ",
		order = 2,
		disabled  = true,
	},
	Hiden_2 = {
		type = "execute",
		name = " ",
		order = 3,
		disabled  = true,
	},
	Reload = {
		type = "execute",
		name = "重载界面",
		order = 4,
		func = function() ReloadUI() end
	},
}

-- ShowConfig
local function ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 740, 500)
	LibStub("AceConfigDialog-3.0"):Open("Sora's Config")
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
