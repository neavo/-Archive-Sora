----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.TooltipConfig

local classification = {
    elite = "精英",
    rare = "稀有",
    rareelite = "稀有精英",
}

local find = string.find
local format = string.format
local hex = function(color)
    return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function unitColor(unit)
    local color = { r=1, g=1, b=1 }
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = RAID_CLASS_COLORS[class]
        return color
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
            return color
        end
    end
    return color
end

function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
    return color.r, color.g, color.b
end

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format("你")
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()

    if unit then
        if cfg.HideInCombat and InCombatLockdown() then
            return self:Hide()
        end

        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)

        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
        end

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or 
            UnitIsDND(unit) and CHAT_FLAG_DND or 
            not UnitIsConnected(unit) and "<离线>" or ""))

            local unitGuild = GetGuildInfo(unit)
            local text2 = GameTooltipTextLeft2:GetText()
            if unitGuild and text2 and text2:find("^"..unitGuild) then	
                GameTooltipTextLeft2:SetTextColor(1, 0.1, 0.8)
            end
        end


        local alive = not UnitIsDeadOrGhost(unit)
        local level = UnitLevel(unit)

        if level then
            local unitClass = UnitIsPlayer(unit) and hex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)

            if level == -1 then
                level = "|cffff0000??"
            end

            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    if alive then
                        tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                    else
                        tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
                    end
                end

                if tiptext:GetText():find(PVP) then
                    tiptext:SetText(nil)
                end
            end
        end

        if not alive then
            GameTooltipStatusBar:Hide()
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
    else
        for i=2, self:NumLines() do
            local tiptext = _G["GameTooltipTextLeft"..i]

            if tiptext:GetText():find(PVP) then
                tiptext:SetText(nil)
            end
        end

        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end

    if GameTooltipStatusBar:IsShown() then
        GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetHeight(6)
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 1, 8)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -1, 8)
		if not GameTooltipStatusBar.BG then 
			GameTooltipStatusBar.BG = CreateFrame("Frame", nil, GameTooltipStatusBar)
			GameTooltipStatusBar.BG:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel()-1)
			GameTooltipStatusBar.BG:SetPoint("TOPLEFT", -1, 1)
			GameTooltipStatusBar.BG:SetPoint("BOTTOMRIGHT", 1, -1)
			GameTooltipStatusBar.BG:SetBackdrop({
				edgeFile = cfg.Solid, edgeSize = 1,
			})
			GameTooltipStatusBar.BG:SetBackdropBorderColor(0, 0, 0, 1)
		end
    end
end)

GameTooltipStatusBar:SetStatusBarTexture(cfg.Statusbar)
local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(GameTooltipStatusBar)
bg:SetTexture(cfg.Statusbar)
bg:SetVertexColor(0.5, 0.5, 0.5, 0.5)

local numberize = function(val)
    if val >= 1e6 then
        return ("%.1fm"):format(val / 1e6)
    elseif val >= 1e3 then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if value < min or value > max then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
			self.text:SetPoint("BOTTOM", GameTooltipStatusBar, "TOP", 0, -5)
            self.text:SetFont(cfg.Font, 12, "THINOUTLINE")
        end
        self.text:Show()
        local hp = numberize(min).." / "..numberize(max)
        self.text:SetText(hp)
    end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local frame = GetMouseFocus()
    if cfg.Cursor and frame == WorldFrame then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    else
        tooltip:SetOwner(parent, "ANCHOR_NONE")	
        tooltip:SetPoint(unpack(cfg.Position))
    end
    tooltip.default = 1
end)

local function setBakdrop(frame)

	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8", 
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
		edgeFile = cfg.Solid, edgeSize = 1,
	})
	
    frame.freebBak = true
	
end

local function style(frame)
    if not frame.freebBak then
        setBakdrop(frame)
    end

    frame:SetBackdropColor(0.05, 0.05, 0.05, 0.4)
    frame:SetBackdropBorderColor(0, 0, 0, 1)
	
    if frame.GetItem then
        local _, item = frame:GetItem()
        if item then
            local quality = select(3, GetItemInfo(item))
            if quality then
                local r, g, b = GetItemQualityColor(quality)
                frame:SetBackdropBorderColor(r, g, b)
            end
        else
            frame:SetBackdropBorderColor(0, 0, 0, 1)
        end
    end

	local _, unit = GameTooltip:GetUnit()
	if UnitIsPlayer(unit) then
		frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
	end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.Font, 10+2, "THINOUTLINE")
            else
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.Font, 10, "THINOUTLINE")
            end
            _G[frame:GetName()..'TextRight'..index]:SetFont(cfg.Font, 10, "THINOUTLINE")
        end
    end
end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip,
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
}

for i, frame in ipairs(tooltips) do
    frame:SetScript("OnShow", function(frame) style(frame) end)
end

local itemrefScripts = {
    "OnTooltipSetItem",
    "OnTooltipSetAchievement",
    "OnTooltipSetQuest",
    "OnTooltipSetSpell",
}

for i, script in ipairs(itemrefScripts) do
    ItemRefTooltip:HookScript(script, function(self)
        style(self)
    end)
end

local f = CreateFrame"Frame"
f:SetScript("OnEvent", function(self, event, ...) if SR[event] then return SR[event](SR, event, ...) end end)
function SR:RegisterEvent(...) for i=1,select("#", ...) do f:RegisterEvent((select(i, ...))) end end
function SR:UnregisterEvent(...) for i=1,select("#", ...) do f:UnregisterEvent((select(i, ...))) end end

SR:RegisterEvent"PLAYER_LOGIN"
function SR:PLAYER_LOGIN()
    for i, frame in ipairs(tooltips) do
        setBakdrop(frame)
    end

    SR:UnregisterEvent"PLAYER_LOGIN"
end
