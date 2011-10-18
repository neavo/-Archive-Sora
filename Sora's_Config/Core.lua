-- Engines
local S, C, _, _ = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):NewAddon("SoraConfig", "AceConsole-3.0")

-- SetDefault
local function SetDefault()
	SlashCmdList.AutoSet()
	SoraInited = true
end

MoveHandle = {}
Modules = {
	ResetToDefault = {
		type = "execute",
		name = "恢复默认设置",
		order = 1,
		func = function()
			for _, value in pairs(C) do
				value.ResetToDefault()
			end
			SetDefault()
			ReloadUI()
		end
	},
	UnLock = {
		type = "execute",
		name = "解锁框体",
		order = 2,
		func = function()
			if not UnitAffectingCombat("player") then
				for _, value in pairs(MoveHandle) do
					value:Show()
				end
			end		
		end,
	},
	Lock = {
		type = "execute",
		name = "锁定框体",
		order = 3,
		func = function()
			if not UnitAffectingCombat("player") then
				for _, value in pairs(MoveHandle) do
					value:Hide()
				end
			end
		end,
	},
	Reload = {
		type = "execute",
		name = "应用(重载界面)",
		order = 4,
		func = function() ReloadUI() end
	},
}

-- ShowConfig
local function ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 760, 500)
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
	SoraConfig:RegisterChatCommand("Sora", ShowConfig)
end

-- OnEnable
function SoraConfig:OnEnable()
	if not SoraInited then
		StaticPopupDialogs["Sora's"] = {
			text = "欢迎使用|cff70C0F5Sora's|r\n请点击确定按钮加载默认配置",
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				SetDefault()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 0,
		}
		StaticPopup_Show("Sora's")
	end
end

