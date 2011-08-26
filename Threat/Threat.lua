----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ThreatConfig



-- 主框体
local ThreatFrame = CreateFrame("Frame")
ThreatFrame:SetWidth(210)
ThreatFrame:SetHeight(16)
ThreatFrame:SetAlpha(0.80)
ThreatFrame:Hide()

ThreatFrame.Overlay = CreateFrame("Frame", nil, ThreatFrame)
ThreatFrame.Overlay:SetPoint("TOPLEFT",-5,5)
ThreatFrame.Overlay:SetPoint("BOTTOMRIGHT",5,-5)
ThreatFrame.Overlay:SetBackdrop({ 
	edgeFile = cfg.GlowTex , edgeSize = 5,
	})
ThreatFrame.Overlay:SetBackdropBorderColor(0,0,0,0.8)

-- 仇恨条背景
local PreTex
for i = 1,3 do
	local Texture = ThreatFrame:CreateTexture(nil, "BACKGROUND")
	Texture:SetHeight(ThreatFrame:GetHeight())
	Texture:SetTexture(cfg.Statusbar)
	if i == 1 then
		Texture:SetPoint("LEFT", 0, 0)
		Texture:SetWidth(70)	
		Texture:SetGradient("HORIZONTAL", 0.2, 1, 0.2, 1, 1, 0.2)
	elseif i == 2 then
		Texture:SetPoint("LEFT", PreTex, "RIGHT", 0, 0)
		Texture:SetWidth(120)
		Texture:SetGradient("HORIZONTAL", 1, 1, 0.2, 1, 0.2, 0.2)
	elseif i == 3 then
		Texture:SetPoint("LEFT", PreTex, "RIGHT", 0, 0)
		Texture:SetWidth(20)
		Texture:SetVertexColor(1, 0.2, 0.2)
	end
	PreTex = Texture
end	

-- 构建仇恨列表
local threatlist, threatunit, threatguid = {}, "target", ""
local function GetThreat(unit, pet)
	if UnitName(pet or unit) == UNKNOWN or not UnitIsVisible(pet or unit) then
		return
	end
	
	local isTanking, _, _, rawPercent, _  = UnitDetailedThreatSituation(pet or unit, threatunit)
	local name = pet and UnitName(pet) or UnitName(unit)
	
	for index, value in ipairs(threatlist) do
		if value.name == name then
			tremove(threatlist, index)
			break
		end
	end

	table.insert(threatlist, {
		name = name,
		class = select(2, UnitClass(unit)),
		rawPercent = rawPercent or 0,
		isTanking = isTanking or nil,
	})
end

local function AddThreat(unit, pet)
	if UnitExists(pet) then
		GetThreat(unit)
		GetThreat(unit, pet)
	else
		if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
			GetThreat(unit)
		end
	end
end


-- 仇恨滑块
for i = 1,3 do
	ThreatFlag = CreateFrame("Frame","ThreatFlag"..i,ThreatFrame)
	ThreatFlag:SetWidth(7)
	ThreatFlag:SetHeight(ThreatFrame:GetHeight())
	ThreatFlag:SetBackdrop({ 
		bgFile = cfg.Solid , 
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
		edgeFile = cfg.Solid , edgeSize = 1,
	})
	ThreatFlag:SetBackdropColor(1,1,1,1)
	ThreatFlag:SetBackdropBorderColor(0,0,0,1)
	ThreatFlag.Per = ThreatFlag:CreateFontString(nil,"OVERLAY")
	ThreatFlag.Per:SetFont(cfg.Font,10,"THINOUTLINE")
	ThreatFlag.Per:SetPoint("BOTTOM", ThreatFlag, "TOP", 0, 2)
	ThreatFlag.Name = ThreatFlag:CreateFontString(nil,"OVERLAY")
	ThreatFlag.Name:SetFont(cfg.Font,10,"THINOUTLINE")
	ThreatFlag.Name:SetPoint("TOP", ThreatFlag, "BOTTOM", 0, -2)
	ThreatFlag.Name:SetSpacing(2)
end
	
local function SortThreat(a,b)
	return a.rawPercent > b.rawPercent
end
local function UpdateThreatFlag()
	ThreatFrame:Hide()
	for i = 1,3 do
		local ThreatFlag = _G["ThreatFlag"..i]
	end
	for key, _ in ipairs(threatlist) do
		if threatlist[key].isTanking then	
			ThreatFrame:Show()
			local ThreatFlag = _G["ThreatFlag1"]
			ThreatFlag.Name:SetText(format("%.6s",threatlist[key].name))
			ThreatFlag.Per:SetText("100%")
			ThreatFlag:SetPoint("LEFT", ThreatFrame, "LEFT", 207*100/130+3, 0)
			tremove(threatlist, key)
		end
	end
	table.sort(threatlist, SortThreat)
	for key, _ in ipairs(threatlist) do
		if key > 2 then return end
		local rawPercent = threatlist[key].rawPercent
		local ThreatFlag = _G["ThreatFlag"..key + 1]
		ThreatFlag.Name:SetText(format("↑\n%.6s",threatlist[key].name))
		ThreatFlag.Per:SetText(format("%.2s%%",threatlist[key].rawPercent))
		ThreatFlag:SetPoint("LEFT", ThreatFrame, "LEFT", 207*rawPercent/130+3, 0)
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:RegisterEvent("PLAYER_REGEN_DISABLED")
Event:RegisterEvent("PLAYER_REGEN_ENABLED")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent",function(self, event, unit)
	if event == "PLAYER_ENTERING_WORLD" then
		ThreatFrame:SetPoint("TOP","oUF_NevoPlayer", "BOTTOM", 0, -50)
	elseif event == "PLAYER_REGEN_DISABLED" then
		ThreatFrame:Show()
	elseif event == "PLAYER_REGEN_ENABLED" then
		wipe(threatlist)
		ThreatFrame:Hide()
	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		if unit and UnitExists(unit) and UnitGUID(unit) == threatguid and UnitCanAttack("player", threatunit) then
			if GetNumRaidMembers() > 0 then
				for i = 1, GetNumRaidMembers() do
					AddThreat("raid"..i, "raid"..i.."pet")
				end
			elseif GetNumPartyMembers() > 0 then
				AddThreat("player", "pet")
				for i = 1, GetNumPartyMembers() do
					AddThreat("party"..i, "party"..i.."pet")
				end
			else
				AddThreat("player", "pet")
			end
			UpdateThreatFlag()
		end
	elseif event == "PLAYER_TARGET_CHANGED" then
		if UnitExists("target") and not UnitIsDead("target") and not UnitIsPlayer("target") then
			threatguid = UnitGUID("target")
		else
			threatguid = ""
		end
		wipe(threatlist)
		UpdateThreatFlag()
	end	
end)









