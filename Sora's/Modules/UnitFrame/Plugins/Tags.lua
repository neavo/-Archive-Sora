-- Engines
local S, _, _, DB = unpack(select(2, ...))
local _, ns = ...
local oUF = ns.oUF or oUF

oUF.colors.power["MANA"] = {0.31, 0.45, 0.63}

oUF.Tags["Sora:color"] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif UnitIsTapped(u) and not UnitIsTappedByPlayer(u)then
		return S.ToHex(oUF.colors.tapped)
	elseif UnitIsPlayer(u)then
		return S.ToHex(oUF.colors.class[class])
	elseif reaction then
		return S.ToHex(oUF.colors.reaction[reaction])
	else
		return S.ToHex(1, 1, 1)
	end
end
oUF.TagEvents["Sora:color"] = "UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS"

oUF.Tags["Sora:hp"]  = function(u) 
	local per = oUF.Tags["perhp"](u).."%" or 0
	local min, max = UnitHealth(u), UnitHealthMax(u)
	if u == "target" or u == "focus" then
		return S.SVal(min) .." | ".. per
	elseif u == "player" then
		return S.SVal(min)
	else
		return per
	end
end
oUF.TagEvents["Sora:hp"] = "UNIT_HEALTH"

oUF.Tags["Sora:pp"] = function(u)
    local _, str = UnitPowerType(u)
    local power = UnitPower(u)
	local powerMax = UnitPowerMax(u)
	if str and power > 0 then
		if powerMax > 130 then
			return math.floor(power/powerMax*100+.5).."%".." | "..S.SVal(power)
		else
			return S.SVal(power)
		end
	end
end
oUF.TagEvents["Sora:pp"] = "UNIT_POWER"

oUF.Tags["Sora:level"] = function(unit)
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)
	local str = l	
	if l <= 0 then l = "??" end
	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r", 250, 20, 0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+", d.r*255, d.g*255, d.b*255, l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+", d.r*255, d.g*255, d.b*255, l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r", d.r*255, d.g*255, d.b*255, l)
	else
		if not UnitIsConnected(unit) then
			str = "??"
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s", d.r*255, d.g*255, d.b*255, l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s", d.r*255, d.g*255, d.b*255, l)
			else
				str = string.format("|cff%02x%02x%02x%s", d.r*255, d.g*255, d.b*255, l)
			end
		end		
	end
	return str
end
oUF.TagEvents["Sora:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

oUF.Tags["Sora:info"] = function(u)
    local _, class = UnitClass(u)
    if class then
        if UnitIsDead(u) then
            return S.ToHex(oUF.colors.class[class]).."死亡|r"
        elseif UnitIsGhost(u) then
            return S.ToHex(oUF.colors.class[class]).."灵魂|r"
        elseif not UnitIsConnected(u) then
            return S.ToHex(oUF.colors.class[class]).."离线|r"
        end
    end
end
oUF.TagEvents["Sora:info"] = "UNIT_HEALTH UNIT_CONNECTION"

oUF.UnitlessTagEvents.PLAYER_REGEN_DISABLED = true
oUF.UnitlessTagEvents.PLAYER_REGEN_ENABLED = true