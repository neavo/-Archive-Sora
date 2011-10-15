-- Engines
local _, _, _, DB = unpack(select(2, ...))
local ThreatList, ThreatFlag = {}, {}

-- 创建主框体
local Threat = CreateFrame("Frame", nil, UIParent)
Threat:SetWidth(ThreatDB.ThreatBarWidth)
Threat:SetHeight(8)
Threat:SetFrameLevel(0)
Threat:SetBackdrop({
	bgFile = DB.ThreatBar, insets = {left = 3, right = 3, top = 3, bottom = 3},
	edgeFile = DB.GlowTex, edgeSize = 3
})
Threat:SetBackdropBorderColor(0, 0, 0, 1)
Threat:SetAlpha(0)
-- 创建坦克仇恨标签
Threat.FlagT = CreateFrame("Frame", "ThreatFlagTank", Threat)
Threat.FlagT:SetWidth(1)
Threat.FlagT:SetHeight(Threat:GetHeight()-6)
Threat.FlagT:SetBackdrop({ bgFile = DB.Solid })
Threat.FlagT:SetBackdropColor(0, 0, 0)
Threat.FlagT:SetFrameLevel(2)
Threat.FlagT.Name = Threat.FlagT:CreateTexture(nil, "OVERLAY")
Threat.FlagT.Name:SetHeight(24)
Threat.FlagT.Name:SetWidth(24)
Threat.FlagT.Name:SetTexture(DB.ArrowT)
Threat.FlagT.Name:SetPoint("BOTTOM", Threat.FlagT, "TOP", 0, 0)
Threat.FlagT.Text = Threat.FlagT:CreateFontString(nil, "OVERLAY")
Threat.FlagT.Text:SetFont(DB.Font, 10, "THINOUTLINE")
Threat.FlagT.Text:SetPoint("BOTTOM", Threat.FlagT.Name, "TOP", 0, -8)
-- 创建一般仇恨标签
for i=1, ThreatDB.ThreatLimited do 
	local Flag = CreateFrame("Frame", nil, Threat)
	Flag:SetWidth(1)
	Flag:SetHeight(Threat:GetHeight()-6)
	Flag:SetBackdrop({ bgFile = DB.Solid })
	Flag:SetBackdropColor(0, 0, 0)
	Flag:SetFrameLevel(2)
	Flag.Name = Flag:CreateTexture(nil, "OVERLAY")
	Flag.Name:SetHeight(16)
	Flag.Name:SetWidth(16)
	Flag.Name:SetTexture(DB.Arrow)
	Flag.Name:SetPoint("TOP", Flag, "BOTTOM", 0, 0)
	Flag.Text = Flag:CreateFontString(nil, "OVERLAY")
	Flag.Text:SetFont(DB.Font, 10, "THINOUTLINE")
	Flag.Text:SetPoint("TOP", Flag.Name, "BOTTOM", 1, 3)
	tinsert(ThreatFlag, Flag)
end

-- 更新仇恨列表
local function getThreat(unit, pet)
	if UnitName(pet or unit) == UNKNOWN or not UnitIsVisible(pet or unit) then
		return
	end
	local isTanking, _, _, rawPercent = UnitDetailedThreatSituation(pet or unit, "target")
	local name = pet and UnitName(pet) or UnitName(unit)
	for index, value in ipairs(ThreatList) do
		if value.name == name then
			tremove(ThreatList, index)
			break
		end
	end
	tinsert(ThreatList, {
		name = name, 
		class = select(2, UnitClass(unit)), 
		rawPercent = rawPercent or 0, 
		isTanking = isTanking or false, 
	})
end

local function addThreat(unit, pet)
	if UnitExists(pet) then
		getThreat(unit)
		getThreat(unit, pet)
	elseif GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
		getThreat(unit)
	end
end

local function updateThreat()
	wipe(ThreatList)
	if UnitExists("target") and UnitCanAttack("player", "target") then
		if GetNumRaidMembers() > 0 then
			for i = 1, GetNumRaidMembers() do
				addThreat("raid"..i, "raid"..i.."pet")
			end
		elseif GetNumPartyMembers() > 0 then
			addThreat("player", "pet")
			for i = 1, GetNumPartyMembers() do
				addThreat("party"..i, "party"..i.."pet")
			end
		else
			addThreat("player", "pet")
		end	
	end	
end

-- 更新仇恨标签
local function formatName(name)
	if strupper(name) ~= name then
		return name:sub(1, ThreatDB.NameTextL)
	else
		return name:sub(1, ThreatDB.NameTextL*3)
	end
end
local function sortThreat(a, b)
	return a.rawPercent > b.rawPercent
end
local function shouldShow()
	local temp = true
	if not UnitCanAttack("player", "target") or UnitIsDead("target") then
		temp = false
	end
	if not HasPetUI() and not (GetNumPartyMembers() > 0) then
		temp = false
	end
	if IsActiveBattlefieldArena() then
		temp = false
	end
	return temp
end

local function updateThreatFlag()
	-- 隐藏旧的仇恨标签
	Threat.FlagT:Hide()
	for key, value in ipairs(ThreatFlag) do
		value:Hide()
	end
	-- 设置Tank仇恨标签
	for key, value in ipairs(ThreatList) do
		if ThreatList[key].isTanking then
			local CLASS_COLORS = RAID_CLASS_COLORS[value.class]
			Threat.FlagT.Name:SetVertexColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)
			
			Threat.FlagT.Text:SetText(formatName(value.name))
			Threat.FlagT.Text:SetTextColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)

			Threat.FlagT:SetPoint("LEFT", Threat, "LEFT", 207*100/130+3, 0)
			Threat.FlagT:Show()
			
			tremove(ThreatList, key)
		end
	end
	-- 仇恨排序
	table.sort(ThreatList, sortThreat)
	-- 设置一般仇恨标签
	for key, value in pairs(ThreatFlag) do
		if ThreatList[key] then
			local class = ThreatList[key].class
			local rawPercent = ThreatList[key].rawPercent
			local name = ThreatList[key].name	
			local CLASS_COLORS = RAID_CLASS_COLORS[class]
			value.Name:SetVertexColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)	
			value.Text:SetText(formatName(name))
			value.Text:SetTextColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b)	
			value:SetPoint("LEFT", Threat, "LEFT", 207*rawPercent/130+3, 0)
			value:Show()
		end
	end		
end

-- 更新目标
local function updateTarget()
	wipe(ThreatList)
	if shouldShow() then
		UIFrameFadeIn(Threat, 0.5, 0, 1)
	else
		UIFrameFadeOut(Threat, 0.5, 1, 0)
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:RegisterEvent("PLAYER_REGEN_DISABLED")
Event:RegisterEvent("PLAYER_REGEN_ENABLED")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Threat:SetPoint(unpack(DB.ThreatPos))
	elseif event == "PLAYER_REGEN_DISABLED" then
		if shouldShow() then
			if Threat:GetAlpha() < 0.1 then
				UIFrameFadeIn(Threat, 0.5, 0, 1)
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if shouldShow() then
			if Threat:GetAlpha() > 0.9 then
				UIFrameFadeOut(Threat, 0.5, 1, 0)
			end
		end
	elseif event == "UNIT_THREAT_LIST_UPDATE" and UnitAffectingCombat("player") then
		updateThreat()
		updateThreatFlag()
	elseif event == "PLAYER_TARGET_CHANGED" and UnitAffectingCombat("player") then
		updateTarget()
		updateThreatFlag()
	end	
end)
