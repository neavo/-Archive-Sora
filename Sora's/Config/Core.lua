-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Congig", "AceConsole-3.0")
local Version = 1106

-- SetDefault
local function SetDefault()
	SlashCmdList.AutoSet()
	SoraVersion = Version
	-- 聊天频道职业染色
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")   
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	SetCVar("alwaysShowActionBars", 1) -- 总是显示动作条
	SetCVar("lootUnderMouse", 1) --拾取框跟随鼠标
end

MoveHandle = {}
Modules = {
	ResetToDefault = {
		type = "execute",
		name = "恢复默认设置",
		order = 1,
		func = function()
			for _, value in pairs(C) do value.ResetToDefault() end
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
				for _, value in pairs(MoveHandle) do value:Show() end
			end		
		end,
	},
	Lock = {
		type = "execute",
		name = "锁定框体",
		order = 3,
		func = function()
			if not UnitAffectingCombat("player") then
				for _, value in pairs(MoveHandle) do value:Hide() end
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

local function ShowConfig()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 780, 550)
	LibStub("AceConfigDialog-3.0"):Open("Sora's Config")
end

local function BuildGameMenuButton()
	local Button = CreateFrame("Button", "SoraGameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
	S.Reskin(Button)
	Button:SetSize(GameMenuButtonHelp:GetWidth(), GameMenuButtonHelp:GetHeight())
	Button:SetText("|cff70C0F5Sora's|r")
	Button:SetPoint(GameMenuButtonHelp:GetPoint())
	Button:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		ShowConfig()
	end)
	GameMenuButtonHelp:SetPoint("TOP", Button, "BOTTOM", 0, -1)
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+Button:GetHeight())	
end

-- OnInitialize
function Module:OnInitialize()
	for _, value in pairs(C) do
		value.LoadSettings()
		value.BuildGUI()
	end
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Sora's Config", {
		type = "group",
		name = "|cff70C0F5Sora's|r",
		args = Modules,
	})
	Module:RegisterChatCommand("Sora", ShowConfig)
end

-- OnEnable
function Module:OnEnable()
	BuildGameMenuButton()
	if not SoraVersion or SoraVersion < Version then
		StaticPopupDialogs["Sora's"] = {
			text = "欢迎使用|cff70C0F5Sora's|r\n\n请点击确定按钮加载默认配置\n",
			button1 = OKAY,
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

