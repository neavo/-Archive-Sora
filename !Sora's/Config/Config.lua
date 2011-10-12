----------------
--  命名空间  --
----------------

Modules = {}
local _, ns = ...
local opt = CreateFrame("Frame")

local function BuildOptTable()
	opt.OptTable = {
		type = "group",
		name = "|cff70C0F5Sora's|r",
		args = Modules,
	}
end

-- Init
local function Init()
	BuildOptTable()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Sora's Config", opt.OptTable)
end

-- Sora
SlashCmdList.Sora = function()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sora's Config", 780, 500)
	LibStub("AceConfigDialog-3.0"):Open("Sora's Config")
end
SLASH_Sora1 = "/Sora"


-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent",function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	end
end)