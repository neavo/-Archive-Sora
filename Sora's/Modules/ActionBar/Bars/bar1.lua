-- Engines
local S, _, _, DB = unpack(select(2, ...))

DB.ActionBar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate") 
DB.ActionBar:SetWidth(ActionBarDB.ActionBarButtonSize*18+3*17)
DB.ActionBar:SetHeight(ActionBarDB.ActionBarButtonSize*2+5)
DB.ActionBar:SetPoint("BOTTOM", UIParent, 0, 20)
  
local Page = {
	["DRUID"] = "[bonusbar:1, nostealth] 7; [bonusbar:1, stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;", 
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;", 
	["PRIEST"] = "[bonusbar:1] 7;", 
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;", 
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;", 
}
  
local function GetBar()
	local condition = Page["DEFAULT"]
	local _, class = UnitClass("player")
	local page = Page[class]
	if page then
	  condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end
  
DB.ActionBar:RegisterEvent("PLAYER_LOGIN")
DB.ActionBar:RegisterEvent("PLAYER_ENTERING_WORLD")
DB.ActionBar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
DB.ActionBar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
DB.ActionBar:RegisterEvent("BAG_UPDATE")
DB.ActionBar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button, buttons
			for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
			end  

			self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
			  table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
			]])

			self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
			  button:SetAttribute("actionpage", tonumber(newstate))
			end
			]])

			RegisterStateDriver(self, "page", GetBar())	
	elseif event == "PLAYER_ENTERING_WORLD" then
		for i = 1, 12 do
			local Button = _G["ActionButton"..i]
			Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
			Button:ClearAllPoints()
			Button:SetParent(self)
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "BOTTOMLEFT", ActionBarDB.ActionBarButtonSize*3+3*3, 0)
			else
				local Pre = _G["ActionButton"..i-1]
				Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
			end
		end
	else
	   MainMenuBar_OnEvent(self, event, ...)
	end
end)