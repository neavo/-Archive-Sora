----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ThreatConfig


-- 主框体
local ThreatFrame = CreateFrame("Frame")
ThreatFrame:SetWidth(210)
ThreatFrame:SetHeight(6)
ThreatFrame:SetAlpha(0)

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
		Texture:SetWidth(49)
		Texture:SetVertexColor(1, 0, 0)
	end
	PreTex = Texture
end	

-- 构建仇恨列表
local ThreatList, ThreatFlag, ThreatUnit, ThreatGuid = {}, {}, "target", ""
local function GetThreat(unit, pet)
	if UnitName(pet or unit) == UNKNOWN or not UnitIsVisible(pet or unit) then
		return
	end
	
	local isTanking, _, _, rawPercent, _  = UnitDetailedThreatSituation(pet or unit, ThreatUnit)
	local name = pet and UnitName(pet) or UnitName(unit)
	
	for index, value in ipairs(ThreatList) do
		if value.name == name then
			tremove(ThreatList, index)
			break
		end
	end

	table.insert(ThreatList, {
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

-- 文字格式
local function FormatNameText(nametext)
	local t
	if strupper(nametext) ~= nametext then
		t = 'English'
	else
		t = 'Chinese'
	end

	local strbox = {}
	if t == 'English' then
		for i = 1, cfg.NameTextL do
			tinsert(strbox, strsub(nametext, i, i))
		end
	elseif t == 'Chinese' then
		for i = 1, cfg.NameTextL * 3, 3 do
			tinsert(strbox, strsub(nametext, i, i+2))
		end
	end
	return table.concat(strbox,'')
end

-- 仇恨排序	
local function SortThreat(a,b)
	return a.rawPercent > b.rawPercent
end

local function UpdateThreatFlag()
	local Flag, FlagT
	
	for key, value in ipairs(ThreatFlag) do
		value:Hide()
	end
	if _G["ThreatFlagTank"] then
		_G["ThreatFlagTank"]:Hide()
	end
	
	for key, value in ipairs(ThreatList) do
		if ThreatList[key].isTanking then
			FlagT = _G["ThreatFlagTank"]
			if not FlagT then
				
				FlagT = CreateFrame("Frame","ThreatFlagTank",ThreatFrame)
				FlagT:SetWidth(2)
				FlagT:SetHeight(ThreatFrame:GetHeight())
				FlagT:SetBackdrop({ bgFile = cfg.Solid })
				FlagT:SetBackdropColor(0,0,0)
				FlagT:SetFrameLevel(2)
				
				FlagT.Name = FlagT:CreateTexture(nil,"OVERLAY")
				FlagT.Name:SetHeight(22)
				FlagT.Name:SetWidth(22)
				FlagT.Name:SetTexture(cfg.ArrowLarge)
				FlagT.Name:SetPoint("BOTTOM", FlagT, "TOP", 0, 2)
				
				FlagT.Text = FlagT:CreateFontString(nil,"OVERLAY")
				FlagT.Text:SetFont(cfg.Font,9,"THINOUTLINE")
				FlagT.Text:SetPoint("BOTTOM", FlagT.Name, "TOP", 1, -8)
				
			end
		
			local Color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[value.class] and CUSTOM_CLASS_COLORS[value.class] or RAID_CLASS_COLORS[value.class]
			FlagT.Name:SetVertexColor(Color.r, Color.g, Color.b)
						
			FlagT.Text:SetText(FormatNameText(value.name))
			FlagT.Text:SetTextColor(Color.r, Color.g, Color.b)

			FlagT:SetPoint("LEFT", ThreatFrame, "LEFT", 207*100/130+3, 0)
			FlagT:Show()
			
			tremove(ThreatList, key)
			
		end
	end
	table.sort(ThreatList, SortThreat)
	for key, value in ipairs(ThreatList) do
		if key > cfg.ThreatLimited then return end
		
		Flag = ThreatFlag[key]
		if not Flag then
			Flag = CreateFrame("Frame","ThreatFlag"..key,ThreatFrame)
			Flag:SetWidth(2)
			Flag:SetHeight(ThreatFrame:GetHeight())
			Flag:SetBackdrop({ bgFile = cfg.Solid })
			Flag:SetBackdropColor(0,0,0)
			Flag:SetFrameLevel(2)
			
			Flag.Name = Flag:CreateTexture(nil,"OVERLAY")
			Flag.Name:SetHeight(16)
			Flag.Name:SetWidth(16)
			Flag.Name:SetTexture(cfg.ArrowSmall)
			Flag.Name:SetPoint("TOP", Flag, "BOTTOM", 0, -2)
			
			Flag.Text = Flag:CreateFontString(nil,"OVERLAY")
			Flag.Text:SetFont(cfg.Font,9,"THINOUTLINE")
			Flag.Text:SetPoint("TOP", Flag.Name, "BOTTOM", 1, 3)
			
			tinsert(ThreatFlag, Flag)
		end

		local Color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[value.class] and CUSTOM_CLASS_COLORS[value.class] or RAID_CLASS_COLORS[value.class]	
		local rawPercent = value.rawPercent
		
		Flag.Name:SetVertexColor( Color.r, Color.g, Color.b)
		
		Flag.Text:SetText(FormatNameText(value.name))
		Flag.Text:SetTextColor(Color.r, Color.g, Color.b)
		
		Flag:SetPoint("LEFT", ThreatFrame, "LEFT", 207*rawPercent/130+3, 0)
		Flag:Show()
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
		ThreatFrame:SetPoint(unpack(cfg.Pos))
	elseif event == "PLAYER_REGEN_DISABLED" then
		UIFrameFadeIn(ThreatFrame, 0.5, 0, 0.8)
	elseif event == "PLAYER_REGEN_ENABLED" then
		UIFrameFadeOut(ThreatFrame, 0.5, 0.8, 0)
	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		if unit and UnitExists(unit) and UnitGUID(unit) == ThreatGuid and UnitCanAttack("player", ThreatUnit) then
			wipe(ThreatList)
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
			ThreatGuid = UnitGUID("target")
			local TargetSwitch = function()
				if UnitAffectingCombat("player") then
					UIFrameFadeIn(ThreatFrame, 0.5, 0, 0.8)
				end
			end
			TargetSwitch()
		else
			ThreatGuid = ""
		end
		wipe(ThreatList)
		UpdateThreatFlag()
	end	
end)
