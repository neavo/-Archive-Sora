-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Bar1", "AceEvent-3.0")
DB.ActionBar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;",
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local page = Page[DB.MyClass]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

function Module:OnInitialize()
	C = ActionBarDB
	Module:RegisterEvent("PLAYER_LOGIN")
	Module:RegisterEvent("PLAYER_ENTERING_WORLD")
	Module:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	Module:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE", MainMenuBar_OnEvent)
	Module:RegisterEvent("CURRENCY_DISPLAY_UPDATE", MainMenuBar_OnEvent)
	Module:RegisterEvent("BAG_UPDATE", MainMenuBar_OnEvent)

	if C["MainBarLayout"] == 1 then
		DB.ActionBar:SetSize(C["ButtonSize"]*18+3*17, C["ButtonSize"]*2+5)
	elseif C["MainBarLayout"] == 2 then
		DB.ActionBar:SetSize(C["ButtonSize"]*12+3*11, C["ButtonSize"]*3+2*5)	
	end
	MoveHandle.ActionBar = S.MakeMoveHandle(DB.ActionBar, "主动作条", "ActionBar")
end

function Module:PLAYER_LOGIN(self, event, ...)
	local button
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		button = _G["ActionButton"..i]
		DB.ActionBar:SetFrameRef("ActionButton"..i, button)
	end	

	DB.ActionBar:Execute([[
		buttons = table.new()
		for i = 1, 12 do
			table.insert(buttons, self:GetFrameRef("ActionButton"..i))
		end
	]])

	DB.ActionBar:SetAttribute("_onstate-page", [[ 
		for i, button in ipairs(buttons) do
			button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])
		
	RegisterStateDriver(DB.ActionBar, "page", GetBar())
end

function Module:PLAYER_ENTERING_WORLD(self, event, ...)
	local Button = nil
	for i = 1, 12 do
		Button = _G["ActionButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		Button:SetParent(DB.ActionBar)
		if C["MainBarLayout"] == 1 then
			DB.ActionBar:SetSize(C["ButtonSize"]*18+3*17, C["ButtonSize"]*2+5)
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "BOTTOMLEFT", C["ButtonSize"]*3+3*3, 0)
			else
				Button:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", 3, 0)
			end
		elseif C["MainBarLayout"] == 2 then
			DB.ActionBar:SetSize(C["ButtonSize"]*12+3*11, C["ButtonSize"]*3+2*5)
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar)
			else
				Button:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", 3, 0)
			end			
		end
	end
end

function Module:ACTIVE_TALENT_GROUP_CHANGED(self, event, ...)
	LoadAddOn("Blizzard_GlyphUI")
end