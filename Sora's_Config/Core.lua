-- Engines
local S, C, _, _ = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):NewAddon("SoraConfig", "AceConsole-3.0")
MoveHandle = {}

-- ResetToDefault
local function ResetToDefault()
	for _, value in pairs(C) do
		value.ResetToDefault()
	end
	ReloadUI()
end

-- UnLock
local function UnLock()
	if not UnitAffectingCombat("player") then
		for _, value in pairs(MoveHandle) do
			value:Show()
		end
	end
end

-- Lock
local function Lock()
	if not UnitAffectingCombat("player") then
		for _, value in pairs(MoveHandle) do
			value:Hide()
		end
	end
end

Modules = {
	ResetToDefault = {
		type = "execute",
		name = "恢复默认设置",
		order = 1,
		func = function() ResetToDefault() end
	},
	UnLock = {
		type = "execute",
		name = "解锁框体",
		order = 2,
		func = function() UnLock() end,
	},
	Lock = {
		type = "execute",
		name = "锁定框体",
		order = 3,
		func = function() Lock() end,
	},
	Reload = {
		type = "execute",
		name = "应用(重载界面)",
		order = 4,
		func = function() ReloadUI() end
	},
}

-- OnFristLoad
local function OnFristLoad()
	for _, value in pairs(C) do
		value.LoadSettings()
		value.BuildGUI()
		SoraInited = true
	end
end

-- ShowConfig
local function ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 760, 500)
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
