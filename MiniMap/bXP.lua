----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.MapConfig


local color = {r = .4, g = .1, b = 0.6}
local restedcolor = {r = .2, g = .4, b = 0.8}
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

local function setup(frame, level)
    frame:SetStatusBarTexture(cfg.Statusbar)
    frame:SetFrameStrata("LOW")
    frame:SetFrameLevel(level)
    frame:SetPoint("LEFT", Minimap, "LEFT", 1, 0)
    frame:SetPoint("RIGHT", Minimap, "RIGHT", -1, 0)
    frame:SetHeight(4)
    frame:SetValue(0)
    frame:Show()
end

local bar = CreateFrame("StatusBar", "bXP", BMFrame)
setup(bar, 2)
bar:SetPoint("TOP", "BMFrame", "BOTTOM", 0, -3)
        
xptext = bar:CreateFontString("XP Text")
xptext:SetPoint("CENTER", bar,"CENTER", 0,-18)
xptext:SetFont(cfg.Font, 9, "THINOUTLINE")
xptext:SetParent(UIParent)
xptext:SetAlpha(0)

bar:RegisterEvent("PLAYER_XP_UPDATE")
bar:RegisterEvent("PLAYER_LEVEL_UP")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("UPDATE_EXHAUSTION");
bar:RegisterEvent("UPDATE_FACTION")

local rbar = CreateFrame("StatusBar", nil, BMFrame)
setup(rbar, 1)
rbar:SetBackdrop({
	bgFile= cfg.Statusbar,
	insets = {left = -1, right = -1, top = -1, bottom = -1}
})
rbar:SetBackdropColor(0,0,0,1)
rbar:EnableMouse(true)
rbar:SetPoint("TOPLEFT", bar, "TOPLEFT")
bg = rbar:CreateTexture(nil, 'BORDER')
bg:SetAllPoints(rbar)
bg:SetTexture(cfg.Statusbar)
bg:SetVertexColor(0.16,0.16,0.16,1)

local function Rested()
    rbar:SetMinMaxValues(0,mxp)
    rbar:SetStatusBarColor(restedcolor.r,restedcolor.g,restedcolor.b, 0.3)
    bar:SetStatusBarColor(restedcolor.r,restedcolor.g,restedcolor.b, 1)
    if (rxp+xp) >= mxp then
        rbar:SetValue(mxp)
    else
        rbar:SetValue(rxp+xp)
    end
end

local function XP()
    bar:SetStatusBarColor(.4,.2,.8, 1)
    bar:SetValue(xp)
    if rxp then
        xptext:SetText(numberize(xp).." / "..numberize(mxp).."\n"..floor((xp/mxp)*1000)/10 .."%" .. " (+"..numberize(rxp)..")")
        Rested()
    else
        xptext:SetText(numberize(xp).." / "..numberize(mxp).." | "..floor((xp/mxp)*1000)/10 .."%")
        rbar:SetValue(0)
        bar:SetStatusBarColor(color.r,color.g,color.b, 1)
    end
end

local function Rep()
    bar:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 1)
    bar:SetMinMaxValues(minrep,maxrep)
    bar:SetValue(value)
    rbar:SetValue(0)
    xptext:SetText(value-minrep.." / "..maxrep-minrep.."\n"..floor(((value-minrep)/(maxrep-minrep))*1000)/10 .."% | ".. name)
end

bar:SetScript("OnEvent", function()
    xp = UnitXP("player")
    mxp = UnitXPMax("player")
    rxp = GetXPExhaustion("player")
    name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
    
    rbar:SetMinMaxValues(0,mxp)
    bar:SetMinMaxValues(0,mxp)
    if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
        if name then
            Rep()
            bar:Show()
            rbar:Show()
        else
        bar:Hide()
        rbar:Hide()
        end
    else
        XP()
    end

	local BMFrame = _G["BMFrame"]
	rbar:SetScript("OnEnter", function()
		BMFrame:SetAlpha(1)
		xptext:SetAlpha(1)
	end)
	rbar:SetScript("OnLeave", function()
		BMFrame:SetAlpha(0.2)
		xptext:SetAlpha(0)
	end)
	bar:SetScript("OnEnter", function()
		BMFrame:SetAlpha(1)
		xptext:SetAlpha(1)
	end)
	bar:SetScript("OnLeave", function()
		BMFrame:SetAlpha(0.2)
		xptext:SetAlpha(0)
	end)
end)









