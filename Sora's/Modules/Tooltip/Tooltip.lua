-- Engines
local _, ns = ...
local S, _, _, DB = unpack(select(2, ...))

local classification = {elite = "精英", rare = "稀有", rareelite = "稀有精英"}

local tooltips = {GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, DropDownList1MenuBackdrop, DropDownList2MenuBackdrop,}

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
        return S.ToHex(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()

    if unit then
        if TooltipDB.HideInCombat and InCombatLockdown() then return self:Hide() end

        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or 
            UnitIsDND(unit) and CHAT_FLAG_DND or 
            not UnitIsConnected(unit) and "<离线>" or ""))
            local unitGuild = GetGuildInfo(unit)
            local text2 = GameTooltipTextLeft2:GetText()
            if unitGuild and text2 and text2:find("^"..unitGuild) then GameTooltipTextLeft2:SetTextColor(1, 0.1, 0.8) end
        end

        local alive = not UnitIsDeadOrGhost(unit)
        local level = UnitLevel(unit)
        if level then
            local unitClass = UnitIsPlayer(unit) and S.ToHex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)
            if level == -1 then level = "|cffff0000首领" end
            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(S.ToHex(diff), tostring(level), classification[classify] or "")
            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    if alive then
                        tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                    else
                        tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
                    end
                end
                if tiptext:GetText():find(PVP) then tiptext:SetText(nil) end
            end
        end
        if not alive then GameTooltipStatusBar:Hide() end
        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end
        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
    else
        for i=2, self:NumLines() do
            local tiptext = _G["GameTooltipTextLeft"..i]
            if tiptext:GetText():find(PVP) then tiptext:SetText(nil) end
        end
        GameTooltipStatusBar:SetStatusBarColor(0, 0.9, 0)
    end

    if GameTooltipStatusBar:IsShown() then
        GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetHeight(6)
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 1, 8)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -1, 8)
		if not GameTooltipStatusBar.Shadow then GameTooltipStatusBar.Shadow = S.MakeShadow(GameTooltipStatusBar, 3) end
    end
end)

GameTooltipStatusBar:SetStatusBarTexture(DB.Statusbar)
GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then return end
    local min, max = self:GetMinMaxValues()
    if value < min or value > max then return end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
            self.text:SetPoint("CENTER", GameTooltipStatusBar)
            self.text:SetFont(DB.Font, 12, "THINOUTLINE")
        end
        self.text:Show()
        local hp = S.SVal(min).." / "..S.SVal(max)
        self.text:SetText(hp)
    end
end)

local function SetTooltipPosition(tooltip)
	local X, Y = 0, 0
	tooltip:ClearAllPoints()
	if TooltipDB.Cursor then
		local CurrentX, CurrentY = GetCursorPosition()
		local Scale = UIParent:GetEffectiveScale()
		X, Y = CurrentX/Scale, CurrentY/Scale
		tooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", X+25, Y+25)
	else
		tooltip:SetPoint(unpack(DB.TooltipPos))
	end
end
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	if TooltipDB.Cursor then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	else
		tooltip:SetOwner(parent,"ANCHOR_NONE")
	end
	SetTooltipPosition(tooltip)
	tooltip.default = 1
	if not tooltip[tostring(tooltip)] then
		tooltip[tostring(tooltip)] = 1
		tooltip:HookScript("OnUpdate", function(self, ...) if self.default then SetTooltipPosition(self) end end)
		tooltip:HookScript("OnHide", function(self, unit)
			tooltip.default = nil
			tooltip.unit = nil
		end)
	end
end)

local function setBakdrop(frame)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8", insets = {left = 3, right = 3, top = 3, bottom = 3},
		edgeFile = DB.GlowTex, edgeSize = 3,
	})
    frame.freebBak = true
end

local function style(frame)
    if not frame.freebBak then setBakdrop(frame) end
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
	if UnitIsPlayer(unit) then frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit)) end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName().."TextLeft"..index]:SetFont(DB.Font, 11+2, "THINOUTLINE")
            else
                _G[frame:GetName().."TextLeft"..index]:SetFont(DB.Font, 11, "THINOUTLINE")
            end
            _G[frame:GetName().."TextRight"..index]:SetFont(DB.Font, 11, "THINOUTLINE")
        end
    end
end

for _, value in ipairs(tooltips) do
    value:SetScript("OnShow", function(value)
        if TooltipDB.HideInCombat and InCombatLockdown() then return value:Hide() end
        style(value) 
    end)
end

--[[for _, value in ipairs({"OnTooltipSetItem", "OnTooltipSetAchievement", "OnTooltipSetQuest", "OnTooltipSetSpell"}) do
	ItemRefTooltip:HookScript(value, function(self) style(self) end)
end]]
	--ItemRefTooltip:HookScript("OnTooltipSetItem", function(self) style(self) end)


-- Event
local Event = CreateFrame("Frame")
Event:SetScript("OnEvent", function(self, event, ...)
	if ns[event] then return ns[event](ns, event, ...) end
end)
Event:RegisterEvent("PLAYER_LOGIN", function(self)
	for i, frame in ipairs(tooltips) do
		setBakdrop(frame)
	end	
end)
function ns:RegisterEvent(...)
	for i=1,select("#", ...) do
		Event:RegisterEvent((select(i, ...)))
	end
end
function ns:UnregisterEvent(...)
	for i=1,select("#", ...) do
		Event:UnregisterEvent((select(i, ...)))
	end
end


