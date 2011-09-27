----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.MapConfig
local BMFrame =_G["BMFrame"]
local Init = false

local numberize = function(v)
    if v <= 9999 then return v end
    if v >= 1000000 then
        local value = string.format("%.1fm", v/1000000)
        return value
    elseif v >= 10000 then
        local value = string.format("%.1fk", v/1000)
        return value
    end
end

local Bar = CreateFrame("StatusBar", nil, BMFrame)
Bar:SetStatusBarTexture(cfg.Statusbar)
Bar:SetWidth(Minimap:GetWidth()-2)
Bar:SetHeight(4)
Bar:SetValue(0)
Bar:SetPoint("TOP", BMFrame, "BOTTOM", 0, -3)
Bar.Text = Bar:CreateFontString(nil,"OVERLAY")
Bar.Text:SetPoint("TOP", Bar, "BOTTOM", 0, -5)
Bar.Text:SetFont(cfg.Font, 9, "THINOUTLINE")
Bar.Text:SetAlpha(0)
Bar:SetScript("OnEnter", function()
	BMFrame:SetAlpha(1)
	Bar.Text:SetAlpha(1)
end)
Bar:SetScript("OnLeave", function()
	BMFrame:SetAlpha(0.2)
	Bar.Text:SetAlpha(0)
end)

local RBar = CreateFrame("StatusBar", nil, BMFrame)
RBar:SetStatusBarTexture(cfg.Statusbar)
RBar:SetAllPoints(Bar)
RBar:SetValue(0)
RBar:EnableMouse(true)
RBar:SetBackdrop({
	bgFile= cfg.Statusbar,
	insets = {left = -1, right = -1, top = -1, bottom = -1}
})
RBar:SetBackdropColor(0,0,0,1)
RBar.BG = RBar:CreateTexture(nil, "BORDER")
RBar.BG:SetAllPoints(RBar)
RBar.BG:SetTexture(cfg.Statusbar)
RBar.BG:SetVertexColor(0.16,0.16,0.16,1)

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_XP_UPDATE")
Event:RegisterEvent("PLAYER_LEVEL_UP")
Event:RegisterEvent("UPDATE_EXHAUSTION")
Event:RegisterEvent("UPDATE_FACTION")
Event:SetScript("OnEvent", function(self)

	currXP = UnitXP("player")
	playerMaxXP = UnitXPMax("player")
	exhaustionXP  = GetXPExhaustion("player")
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()

	RBar:SetMinMaxValues(0,playerMaxXP)
	Bar:SetMinMaxValues(0,playerMaxXP)
	
	if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
		if name then
			Bar:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 1)
			Bar:SetMinMaxValues(minrep,maxrep)
			Bar:SetValue(value)
			RBar:SetValue(0)
			Bar.Text:SetText(value-minrep.." / "..maxrep-minrep.."\n"..floor(((value-minrep)/(maxrep-minrep))*1000)/10 .."% | ".. name)
			Bar:Show()
			RBar:Show()
		else
			Bar:Hide()
			RBar:Hide()
		end
	else
		Bar:SetStatusBarColor(.4,.2,.8, 1)
		Bar:SetValue(currXP)
		if exhaustionXP  then
			Bar.Text:SetText(numberize(currXP).." / "..numberize(playerMaxXP).."\n"..floor((currXP/playerMaxXP)*1000)/10 .."%" .. " (+"..numberize(exhaustionXP )..")")
			RBar:SetMinMaxValues(0,playerMaxXP)
			RBar:SetStatusBarColor(0.2, 0.4, 0.8, 0.3)
			Bar:SetStatusBarColor(0.2, 0.4, 0.8, 1)
			if (exhaustionXP +currXP) >= playerMaxXP then
				RBar:SetValue(playerMaxXP)
			else
				RBar:SetValue(exhaustionXP +currXP)
			end
		else
			Bar.Text:SetText(numberize(currXP).." / "..numberize(playerMaxXP).." | "..floor((currXP/playerMaxXP)*1000)/10 .."%")
			RBar:SetValue(0)
			Bar:SetStatusBarColor(0.4, 0.1, 0.6, 1)
		end
	end

end)
