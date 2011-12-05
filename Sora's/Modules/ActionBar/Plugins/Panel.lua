-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ActionBarPanel", "AceEvent-3.0")
local ExpBar = nil

function Module:BuildExpBar()
	ExpBar = CreateFrame("StatusBar", nil, UIParent)
	ExpBar:SetStatusBarTexture(DB.Statusbar)
	if C["MainBarLayout"] == 1 then
		ExpBar:SetPoint("TOPLEFT", MultiBarBottomRightButton2, "BOTTOMLEFT", 2, -9)
		ExpBar:SetPoint("BOTTOMRIGHT", MultiBarBottomRightButton8, "BOTTOMRIGHT", -2, -14)
	end
	if C["MainBarLayout"] == 2 then
		ExpBar:SetPoint("TOPLEFT", ActionButton2, "BOTTOMLEFT", 2, -9)
		ExpBar:SetPoint("BOTTOMRIGHT", ActionButton12, "BOTTOMRIGHT", -2, -14)
	end
	ExpBar.Rest = CreateFrame("StatusBar", nil, ExpBar)
	ExpBar.Rest:SetAllPoints()
	ExpBar.Rest:SetStatusBarTexture(DB.Statusbar)
	ExpBar.Rest:SetFrameLevel(ExpBar:GetFrameLevel()-1)
	ExpBar.Text = S.MakeFontString(ExpBar, 10)
	ExpBar.Text:SetPoint("CENTER")
	ExpBar.Text:SetAlpha(0)
	ExpBar.Shadow = S.MakeShadow(ExpBar, 3)
	ExpBar:SetStatusBarTexture(DB.Statusbar)
	ExpBar:SetScript("OnEnter",function(self)
		self.Text:SetAlpha(1)
	end)
	ExpBar:SetScript("OnLeave",function(self)
		self.Text:SetAlpha(0)
	end)
end

function Module:Register()
	Module:RegisterEvent("PLAYER_XP_UPDATE", "OnEvent")
	Module:RegisterEvent("PLAYER_LEVEL_UP", "OnEvent")
	Module:RegisterEvent("UPDATE_EXHAUSTION", "OnEvent")
	Module:RegisterEvent("UPDATE_FACTION", "OnEvent")
end

function Module:BuildButton()
	local LeftButton = S.MakeButton(UIParent)
	LeftButton:SetSize(C["ButtonSize"], 8)
	LeftButton:SetPoint("RIGHT", ExpBar, "LEFT", -5, 0)
	LeftButton:SetScript("OnClick", function(self)
		S.LeftBarFade()
	end)
	local RightButton = S.MakeButton(UIParent)
	RightButton:SetSize(C["ButtonSize"], 8)
	RightButton:SetPoint("LEFT", ExpBar, "RIGHT", 5, 0)
	RightButton:SetScript("OnClick", function(self)
		S.RightBarFade()
	end)
end

function Module:OnEvent()
	local currXP = UnitXP("player")
	local playerMaxXP = UnitXPMax("player")
	local exhaustionXP  = GetXPExhaustion("player")
	local name, standingID, barMin, barMax, barValue = GetWatchedFactionInfo()
	if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
		ExpBar.Rest:SetMinMaxValues(0, 1)
		ExpBar.Rest:SetValue(0)
		if name then
			ExpBar:SetStatusBarColor(FACTION_BAR_COLORS[standingID].r, FACTION_BAR_COLORS[standingID].g, FACTION_BAR_COLORS[standingID].b, 1)
			ExpBar:SetMinMaxValues(barMin, barMax)
			ExpBar:SetValue(barValue)
			ExpBar.Text:SetText(barValue-barMin.." / "..barMax-barMin.."    "..floor(((barValue-barMin)/(barMax-barMin))*1000)/10 .."% | ".. name.. "(".._G["FACTION_STANDING_LABEL"..standingID]..")")
		else
			ExpBar:SetStatusBarColor(0.2, 0.4, 0.8, 1)
			ExpBar:SetMinMaxValues(0, 1)
			ExpBar:SetValue(1)
			ExpBar.Text:SetText("")
		end
	else
		ExpBar:SetStatusBarColor(0.4, 0.1, 0.6, 1)
		ExpBar.Rest:SetStatusBarColor(0.2, 0.4, 0.8, 1)
		ExpBar:SetMinMaxValues(0, playerMaxXP)
		ExpBar.Rest:SetMinMaxValues(0, playerMaxXP)
		if exhaustionXP then
			ExpBar.Text:SetText(S.SVal(currXP).." / "..S.SVal(playerMaxXP).."    "..floor((currXP/playerMaxXP)*1000)/10 .."%" .. " (+"..S.SVal(exhaustionXP )..")")
			if exhaustionXP+currXP >= playerMaxXP then
				ExpBar:SetValue(currXP)
				ExpBar.Rest:SetValue(playerMaxXP)
			else
				ExpBar:SetValue(currXP)
				ExpBar.Rest:SetValue(exhaustionXP+currXP)
			end
		else
			ExpBar:SetValue(currXP)
			ExpBar.Rest:SetValue(0)
			ExpBar.Text:SetText(S.SVal(currXP).." / "..S.SVal(playerMaxXP).."    "..floor((currXP/playerMaxXP)*1000)/10 .."%")
		end
	end
end

function Module:OnInitialize()
	C = ActionBarDB
end

function Module:OnEnable()
	Module:BuildExpBar()
	Module:BuildButton()
	Module:Register()
end


