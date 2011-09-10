----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.TooltipConfig

local TARGETYOU = "<你>"
local worldBoss = "首领"
local rareElite = "稀有+"
local rare = "稀有"
local TARGET = "|cfffed100"..TARGET..":|r "	
local ClassColors = {}

local StatNames = {
	ITEM_MOD_SPIRIT_SHORT,
	ITEM_MOD_DODGE_RATING_SHORT,
	ITEM_MOD_PARRY_RATING_SHORT,
	ITEM_MOD_HIT_RATING_SHORT,
	ITEM_MOD_CRIT_RATING_SHORT,
	ITEM_MOD_HASTE_RATING_SHORT,
	ITEM_MOD_EXPERTISE_RATING_SHORT,
	ITEM_MOD_MASTERY_RATING_SHORT
}
local reforgeIDs = {
	{1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {1, 8},
	{2, 1}, {2, 3}, {2, 4}, {2, 5}, {2, 6}, {2, 7}, {2, 8},
	{3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7}, {3, 8},
	{4, 1},{4, 2},{4, 3},{4, 5},{4, 6},{4, 7},{4, 8},
	{5, 1},{5, 2},{5, 3},{5, 4},{5, 6},{5, 7},{5, 8},
	{6, 1},{6, 2},{6, 3},{6, 4},{6, 5},{6, 7},{6, 8},
	{7, 1},{7, 2},{7, 3},{7, 4},{7, 5},{7, 6},{7, 8},
	{8, 1},{8, 2},{8, 3},{8, 4},{8, 5},{8, 6},{8, 7},
}

local function GetHexColor(color)
	return ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
end

for class, color in pairs(RAID_CLASS_COLORS) do
	ClassColors[class] = GetHexColor(RAID_CLASS_COLORS[class])
end

local Reaction = {}
for i = 1, #FACTION_BAR_COLORS do
	Reaction[i] = GetHexColor(FACTION_BAR_COLORS[i])
end

local function getTargetLine(unit)
	if UnitIsUnit(unit, "player") then
		return ("|cffff0000%s|r"):format(TARGETYOU)
	elseif UnitIsPlayer(unit, "player")then
		return ClassColors[select(2, UnitClass(unit, "player"))]..UnitName(unit).."|r"
	elseif UnitReaction(unit, "player") then
		return ("%s%s|r"):format(Reaction[UnitReaction(unit, "player")], UnitName(unit))
	else
		return ("|cffffffff%s|r"):format(UnitName(unit))
	end
end

function GameTooltip_UnitColor(unit)
	local r, g, b
	local reaction = UnitReaction(unit, "player")
	if reaction then
		r = FACTION_BAR_COLORS[reaction].r
		g = FACTION_BAR_COLORS[reaction].g
		b = FACTION_BAR_COLORS[reaction].b
	else
		r = 1.0
		g = 1.0
		b = 1.0
	end
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if not UnitCanAttack("player", unit) then
				r = 1.0
				g = 1.0
				b = 1.0
			else
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		local unit = (select(2, self:GetUnit())) or (GetMouseFocus() and GetMouseFocus():GetAttribute("unit")) or (UnitExists("mouseover") and "mouseover") or nil

		if unit then
		
			if cfg.HideInCombat and InCombatLockdown() then
				return self:Hide()
			end
			
			local name = UnitName(unit)
			local ricon = GetRaidTargetIndex(unit)
			local level = UnitLevel(unit)
			local color = GetQuestDifficultyColor(level)
			local textLevel = ("%s%d|r"):format(GetHexColor(color), level)
			local unitPvP = ""
			local pattern = "%s"
			if level == "??" or level == -1 then
				textLevel = "|cffff0000??|r"
			end
			
			if UnitIsPlayer(unit) then
				local unitRace = UnitRace(unit)
				local _, unitClass = UnitClass(unit)
				if UnitSex(unit) == 2 then
					unitClass = LOCALIZED_CLASS_NAMES_MALE[unitClass]
				else
					unitClass = LOCALIZED_CLASS_NAMES_FEMALE[unitClass]
				end
				
				
				if UnitIsAFK(unit) then
					self:AppendText((" |cff00cc00%s|r"):format(CHAT_FLAG_AFK))
				elseif UnitIsDND(unit) then 
					self:AppendText((" |cff00cc00%s|r"):format(CHAT_FLAG_DND))
				end
				
				for i = 2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft"..i]:GetText():find(unitRace) then
						pattern = pattern.." %s %s, %s"
						_G["GameTooltipTextLeft"..i]:SetText((pattern):format(unitPvP, textLevel, unitRace, unitClass:lower()):trim())
						break
					end
				end

				if ricon then
					local text = GameTooltipTextLeft1:GetText()
					GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
				end
				
                local title = UnitPVPName(unit)
                if title then
                    local text = GameTooltipTextLeft1:GetText()
                    title = title:gsub(name, "")
                    text = text:gsub(title, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end

				local unitGuild = GetGuildInfo((unit=="player") and UnitName(unit) or unit)
				local text = GameTooltipTextLeft2:GetText()
				if unitGuild and text and text:find("^"..unitGuild) then	
					GameTooltipTextLeft2:SetTextColor(112/255, 192/255, 245/255, 1)
				end
			else
				local text = GameTooltipTextLeft2:GetText()
				local reaction = UnitReaction(unit, "player")
				if reaction and text and not text:find(LEVEL) then
					GameTooltipTextLeft2:SetTextColor(FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b)
				end
				if level ~= 0 then
					
						local class = UnitClassification(unit)
						if class == "worldboss" then
							textLevel = ("|cffff0000%s|r"):format(worldBoss)
						elseif class == "rareelite" then
							if level == -1 then
								textLevel = ("|cffff0000??+|r %s"):format(rareElite)
							else
								textLevel = ("%s%d+|r %s"):format(GetHexColor(color), level, rareElite)
							end
						elseif class == "elite" then
							if level == -1 then
								textLevel = "|cffff0000??+|r"
							else
								textLevel = ("%s%d+|r"):format(GetHexColor(color), level)
							end
						elseif class == "rare" then
							if level == -1 then
								textLevel = ("|cffff0000??|r %s"):format(rare)
							else
								textLevel = ("%s%d|r %s"):format(GetHexColor(color), level, rare)
							end
						end
					
					local creatureType = UnitCreatureType(unit)
					for i = 2, GameTooltip:NumLines() do
						if _G["GameTooltipTextLeft"..i]:GetText():find(LEVEL) then
							pattern = pattern.." %s %s"
							_G["GameTooltipTextLeft"..i]:SetText((pattern):format(unitPvP, textLevel, creatureType or ""):trim())
							break
						end
					end
				end
			end

			if UnitIsPVP(unit) then
				for i = 2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
						_G["GameTooltipTextLeft"..i]:SetText(nil)
						break
					end
				end
			end

			if UnitExists(unit .. "target") then
				local text = ("%s%s"):format(TARGET, getTargetLine(unit.."target"))
				GameTooltip:AddLine(text)
			end

			local r, g, b = GameTooltip_UnitColor(unit)
			GameTooltipStatusBar:SetStatusBarColor(r, g, b)
			
			if UnitIsDead(unit) or UnitIsGhost(unit) then
				GameTooltipStatusBar:Hide()
			else
				GameTooltipStatusBar:Show()
			end
		end
	end)

	local healthBar = GameTooltipStatusBar
	healthBar:ClearAllPoints()
	healthBar:SetHeight(6)
	healthBar:SetPoint("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", 1, -8)
	healthBar:SetPoint("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", -1, -8)
	healthBar:SetStatusBarTexture(cfg.dM3)

	healthBar.BG = CreateFrame("Frame", "StatusBarBG", healthBar)
	healthBar.BG:SetFrameLevel(healthBar:GetFrameLevel() - 1)
	healthBar.BG:SetPoint("TOPLEFT", -1, 1)
	healthBar.BG:SetPoint("BOTTOMRIGHT", 1, -1)
	healthBar.BG:SetBackdrop({
		edgeFile = cfg.Solid, edgeSize = 1,
	})
	healthBar.BG:SetBackdropBorderColor(0, 0, 0, 1)

	local function ShortValue(value)
		if value >= 1e7 then
			return ('%.1fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
		elseif value >= 1e6 then
			return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
		elseif value >= 1e5 then
			return ('%.0fk'):format(value / 1e3)
		elseif value >= 1e3 then
			return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
		else
			return value
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
		local unit  = select(2, GameTooltip:GetUnit())
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			if not self.text then
				self.text = self:CreateFontString(nil, "OVERLAY")
				self.text:SetPoint("CENTER", GameTooltipStatusBar,"TOP",0,0)
				self.text:SetFont(cfg.Font, 11, "THINOUTLINE")
				self.text:SetJustifyV("MIDDLE")
			end
			self.text:Show()
			local hp = ShortValue(min).." / "..ShortValue(max)
			self.text:SetText(hp)
		end
	end)
	
	local Tooltips = {GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3}
	for i, v in ipairs(Tooltips) do
		v:SetBackdrop(nil)
		v.bg = CreateFrame("Frame", nil, v)
		v.bg:SetAllPoints(v)
		v.bg:SetPoint("TOPLEFT", v, "TOPLEFT", 1, -1)
		v.bg:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", -1, 1)
		v.bg:SetFrameLevel(v:GetFrameLevel() - 1)
		v.bg:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8", 
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
			edgeFile = cfg.Solid, edgeSize = 1,
		})
		v.bg:SetBackdropColor(0.05, 0.05, 0.05, 0.4)
		v.bg:SetBackdropBorderColor(0, 0, 0, 1)
		
		
		for i = 1, select('#', v:GetRegions()) do
		  local obj = select(i, v:GetRegions())
		  if obj and obj:GetObjectType() == "FontString" then
				obj:SetFont(cfg.Font, 11, "THINOUTLINE")
				obj:GetParent():SetScale(1)
		  end
		end
		
		v:SetScript("OnShow", function(self)
			local name, item = self:GetItem()
			if item then
				local _, _, Color, Ltype, itemID, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = item:find( "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
			
				local quality = select(3, GetItemInfo(item))
				if quality then
					local r, g, b = GetItemQualityColor(quality)
					self.bg:SetBackdropBorderColor(r, g, b)
				end
				
				local regions = {self:GetRegions()}
				local itemLink = select(2, GetItemInfo(item))
				for i = 1, #regions do
					local region = regions[i]
					if region and region:GetObjectType() == "FontString" then
						local text = region:GetText()
						if text and text == REFORGED then
							local rid = tonumber(itemLink:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:(%d+)"))
							local info = reforgeIDs[rid - 113 + 1]
							if info[1] and info[2] then
								region:SetText(text.." ("..StatNames[info[1]].." -> "..StatNames[info[2]]..")")
							end
						end
					end
				end
			else
				self.bg:SetBackdropBorderColor(0, 0, 0, 1)
			end
		end)
	end
	
	local function TooltipAnchorToCursor(tooltip)
		local x, y
		tooltip:ClearAllPoints()
		if cfg.Cursor then
			local CurrentX, CurrentY = GetCursorPosition()
			local Scale = UIParent:GetEffectiveScale()
			x, y = CurrentX / Scale, CurrentY / Scale
			tooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y + 40)
		else
			tooltip:SetPoint(unpack(cfg.Position))
		end
	end

	hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
		if TooltipAnchorCursor then
			tooltip:SetOwner(parent,"ANCHOR_CURSOR")
		else
			tooltip:SetOwner(parent)
		end
			TooltipAnchorToCursor(tooltip)
			tooltip.default = 1
			tooltip:HookScript("OnUpdate", function(self, ...)
			TooltipAnchorToCursor(self)
		end)
	end)

	hooksecurefunc("SetItemRef", function(link, text, button)
		local icon
		local type, id = string.match(link, "^([a-z]+):(%d+)")
		if type == "item" then
			icon = select(10, GetItemInfo(link))
		elseif type == "spell" or type == "enchant" then
			icon = select(3, GetSpellInfo(id))
		elseif type == "achievement"  then
			icon = select(10, GetAchievementInfo(id))
		end	
		
		if not icon then
			ItemRefTooltipTexture10:Hide()

			ItemRefTooltipTextLeft1:ClearAllPoints()
			ItemRefTooltipTextLeft1:SetPoint("TOPLEFT", ItemRefTooltip, "TOPLEFT", 8, -10)

			ItemRefTooltipTextLeft2:ClearAllPoints()
			ItemRefTooltipTextLeft2:SetPoint("TOPLEFT", ItemRefTooltipTextLeft1, "BOTTOMLEFT", 0, -2)
			return
		end

		ItemRefTooltipTexture10:ClearAllPoints()
		ItemRefTooltipTexture10:SetPoint("TOPLEFT", ItemRefTooltip, "TOPLEFT", 8, -7)
		ItemRefTooltipTexture10:SetTexture(icon)
		ItemRefTooltipTexture10:SetHeight(20)
		ItemRefTooltipTexture10:SetWidth(20)
		ItemRefTooltipTexture10:Show()
		ItemRefTooltipTexture10:SetTexCoord(.1,.9,.1,.9)
		
		ItemRefTooltipTextLeft1:ClearAllPoints()
		ItemRefTooltipTextLeft1:SetPoint("TOPLEFT", ItemRefTooltipTexture10, "TOPLEFT", 24, -2)

		ItemRefTooltipTextLeft2:ClearAllPoints()
		ItemRefTooltipTextLeft2:SetPoint("TOPLEFT", ItemRefTooltip, "TOPLEFT", 8, -28)
		
		local textRight = ItemRefTooltipTextLeft1:GetRight()
		local closeLeft = ItemRefCloseButton:GetLeft()
		
		if closeLeft <= textRight then
			ItemRefTooltip:SetWidth(ItemRefTooltip:GetWidth() + (textRight - closeLeft))
		end
	end)