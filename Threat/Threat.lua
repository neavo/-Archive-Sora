----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ThreatConfig


-- 主框体
local ThreatFrame = CreateFrame("Frame")
ThreatFrame:SetWidth(210)
ThreatFrame:SetHeight(6)
ThreatFrame:SetAlpha(0.9)
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
for i = 1,4 do
	local Texture = ThreatFrame:CreateTexture(nil, "BACKGROUND",ThreatFrame)
	Texture:SetHeight(ThreatFrame:GetHeight())
	Texture:SetTexture(cfg.Statusbar)
	if i == 1 then
		Texture:SetPoint("LEFT", 0, 0)
		Texture:SetWidth(53)	
		Texture:SetGradient("HORIZONTAL", 0.69, 0.69, 0.69, 1, 1, 0.47)
	elseif i == 2 then
		Texture:SetPoint("LEFT", PreTex, "RIGHT", 0, 0)
		Texture:SetWidth(54)
		Texture:SetGradient("HORIZONTAL", 1, 1, 0.47, 1, 0.6, 0)
	elseif i == 3 then
		Texture:SetPoint("LEFT", PreTex, "RIGHT", 0, 0)
		Texture:SetWidth(54)
		Texture:SetGradient("HORIZONTAL", 1, 0.6, 0, 1, 0, 0)
	elseif i == 4 then
		Texture:SetPoint("LEFT", PreTex, "RIGHT", 0, 0)
		Texture:SetWidth(48)
		Texture:SetVertexColor(1, 0, 0)
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
	ThreatFlag:SetWidth(2)
	ThreatFlag:SetHeight(ThreatFrame:GetHeight())
	ThreatFlag:SetBackdrop({ bgFile = cfg.Solid })
	ThreatFlag:SetBackdropColor(0,0,0)
	ThreatFlag:SetFrameLevel(2)
	
	ThreatFlag.Name = ThreatFlag:CreateTexture(nil,"OVERLAY")
	
	ThreatFlag.Text = ThreatFlag:CreateFontString(nil,"OVERLAY")
	ThreatFlag.Text:SetFont(cfg.Font,9,"THINOUTLINE")
end

-- 文字格式
local function FormatNameText(nametext)
	local t
	if strupper(nametext) ~= nametext then
		t = 'English'
	else
		t = 'Chinese'
	end

	local L = 3
	local strbox = {}
	if t == 'English' then
		for i = 1, L do
			tinsert(strbox, strsub(nametext, i, i))
		end
	elseif t == 'Chinese' then
		for i = 1, L*3, 3 do
			tinsert(strbox, strsub(nametext, i, i+2))
		end
	end
	return table.concat(strbox,'')
end

-- 仇恨排序	
local function SortThreat(a,b)
	return a.rawPercent > b.rawPercent
end

-- 清除旧的ThreatFlag
local function ClearThreatFlag()
	ThreatFrame:Hide()
	for i = 1,3 do
		local ThreatFlag = _G["ThreatFlag"..i]
		ThreatFlag:Hide()
	end	
end

local function UpdateThreatFlag()
	ClearThreatFlag()
	for i = 1,3 do
		local ThreatFlag = _G["ThreatFlag"..i]
	end
	for key, value in ipairs(threatlist) do
		if threatlist[key].isTanking then
			local Color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[value.class] and CUSTOM_CLASS_COLORS[value.class] or RAID_CLASS_COLORS[value.class]		
			ThreatFrame:Show()
			
			local ThreatFlag = _G["ThreatFlag1"]
			ThreatFlag:Show()
			
			ThreatFlag.Name:SetHeight(26)
			ThreatFlag.Name:SetWidth(26)
			ThreatFlag.Name:SetTexture(cfg.ArrowLarge)
			ThreatFlag.Name:SetPoint("BOTTOM", ThreatFlag, "TOP", 0, 2)
			ThreatFlag.Name:SetVertexColor(Color.r, Color.g, Color.b)

			
			ThreatFlag.Text:SetText(FormatNameText(value.name))
			ThreatFlag.Text:SetTextColor(Color.r, Color.g, Color.b)
			ThreatFlag.Text:SetPoint("BOTTOM", ThreatFlag.Name, "TOP", 1, -10)
			
			ThreatFlag:SetPoint("LEFT", ThreatFrame, "LEFT", 207*100/130+3, 0)
			tremove(threatlist, key)
		end
	end
	table.sort(threatlist, SortThreat)
	for key, value in ipairs(threatlist) do
		if key > 2 then return end
		local Color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[value.class] and CUSTOM_CLASS_COLORS[value.class] or RAID_CLASS_COLORS[value.class]	
		local rawPercent = value.rawPercent
		local ThreatFlag = _G["ThreatFlag"..key + 1]
		ThreatFlag:Show()
		
		ThreatFlag.Name:SetHeight(16)
		ThreatFlag.Name:SetWidth(16)
		ThreatFlag.Name:SetTexture(cfg.ArrowSmall)
		ThreatFlag.Name:SetPoint("TOP", ThreatFlag, "BOTTOM", 0, -2)
		ThreatFlag.Name:SetVertexColor( Color.r, Color.g, Color.b)
		
		ThreatFlag.Text:SetText(FormatNameText(value.name))
		ThreatFlag.Text:SetTextColor(Color.r, Color.g, Color.b)
		ThreatFlag.Text:SetPoint("TOP", ThreatFlag.Name, "BOTTOM", 1, 3)
		
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
		ClearThreatFlag()
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









