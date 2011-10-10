----------------
--  命名空间  --
----------------

local _, ns = ...
local cfg = ns.cfg
local RaidBuffList = ns.RaidBuffList
local Event = CreateFrame("Frame")
local BuffFrame = {}

local function Init()
	for i = 1, 6 do
		local Temp = CreateFrame("Frame", nil, UIParent)
		Temp:SetWidth(RDDB.RaidBuffSize)
		Temp:SetHeight(RDDB.RaidBuffSize)
		Temp:SetFrameStrata("LOW")
		
		Temp.Border = CreateFrame("Frame", nil, Temp)
		Temp.Border:SetAllPoints(Temp)
		Temp.Border:SetBackdrop({
			edgeFile = cfg.Solid, edgeSize = 1,
		})
		Temp.Border:SetBackdropBorderColor(0, 0, 0, 1)
		
		Temp.Shadow = CreateFrame("Frame", nil, Temp)
		Temp.Shadow:SetPoint("TOPLEFT", Temp, "TOPLEFT", 1, -1)
		Temp.Shadow:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMRIGHT", 5, -5)
		Temp.Shadow:SetBackdrop({
			edgeFile = cfg.GlowTex, edgeSize = 5,
		})
		Temp.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		Temp.Shadow:SetFrameLevel(0)
		
		Temp.Texture = Temp:CreateTexture(nil, "ARTWORK")
		Temp.Texture:SetAllPoints()
		if RDDB.RaidBuffDirection == 1 then
			if i == 1 then
				Temp:SetPoint(unpack(cfg.RaidBuffPos))
			else
				Temp:SetPoint("LEFT", BuffFrame[i-1], "RIGHT", RDDB.RaidBuffSpace, 0)
			end
		elseif RDDB.RaidBuffDirection == 2 then
			if i == 1 then
				Temp:SetPoint(unpack(cfg.RaidBuffPos))
			else
				Temp:SetPoint("TOP", BuffFrame[i-1], "BOTTOM", 0, -RDDB.RaidBuffSpace)
			end
		end
		
		Temp.Overlay = Temp:CreateTexture(nil, "OVERLAY")
		Temp.Overlay:SetAllPoints()
		Temp.Overlay:SetTexture(0, 0, 0)
		
		Temp.Flag = Temp:CreateTexture(nil, "OVERLAY")
		if RDDB.RaidBuffDirection == 1 then
			Temp.Flag:SetHeight(2)
			Temp.Flag:SetPoint("TOPLEFT", Temp, "BOTTOMLEFT", 0, -4)
			Temp.Flag:SetPoint("TOPRIGHT", Temp, "BOTTOMRIGHT", 0, -4)
		elseif RDDB.RaidBuffDirection == 2 then
			Temp.Flag:SetWidth(2)
			Temp.Flag:SetPoint("TOPRIGHT", Temp, "TOPLEFT", -4, 0)
			Temp.Flag:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMLEFT", -4, 0)	
		end
		Temp.Flag:SetTexture(0.1, 1, 0.1, 0.8)
		Temp.Flag.Border = CreateFrame("Frame", nil, Temp)
		Temp.Flag.Border:SetPoint("TOPLEFT", Temp.Flag, "TOPLEFT", -1, 1)
		Temp.Flag.Border:SetPoint("BOTTOMRIGHT", Temp.Flag, "BOTTOMRIGHT", 1, -1)
		Temp.Flag.Border:SetBackdrop({
			edgeFile = cfg.Solid, edgeSize = 1,
		})
		Temp.Flag.Border:SetBackdropBorderColor(0, 0, 0, 1)

		Temp:SetAlpha(0)	
		table.insert(BuffFrame,Temp)
	end
end

-- Event
Event.IsInParty = false
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("UNIT_AURA")
Event:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
Event:RegisterEvent("PARTY_MEMBERS_CHANGED")
Event:SetScript("OnEvent",function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	end
	if event == "PARTY_MEMBERS_CHANGED" then
		self.IsInParty = (GetNumPartyMembers() > 0) and true or false
	end
	if RDDB.ShowOnlyInParty and not self.IsInParty then 
		for key, value in pairs(BuffFrame) do
			value:SetAlpha(0)
		end
		return
	end
	if event == "UNIT_AURA" and unit ~= "player" then 
		return
	end
	-- 按照玩家是物理职业还是法系职业
	if event == "ACTIVE_TALENT_GROUP_CHANGED" or "PLAYER_LOGIN" then
		local Melee = false
		local _, Class =  UnitClass("player")
		local Talent = GetPrimaryTalentTree()
		if	(Class == "DRUID" and Talent == 2) or Class == "HUNTER" or Class == "ROGUE" or
			(Class == "SHAMAN" and Talent == 2) or Class == "DEATHKNIGHT" or Class == "WARRIOR" or
			(Class == "PALADIN" and (Talent == 2 or Talent == 3)) then
			Flag = true
		else
			Flag = false
		end
	end
	-- 通用Buff
	for i=1, 5 do
		if RaidBuffList[i] and RaidBuffList[i][1] then
			BuffFrame[i]:SetAlpha(1)
			BuffFrame[i].Texture:SetTexture(select(3, GetSpellInfo(RaidBuffList[i][1])))
			BuffFrame[i].Overlay:SetAlpha(0.7)
			BuffFrame[i].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[i]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[i].Texture:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[i]:SetAlpha(1)
					BuffFrame[i].Overlay:SetAlpha(0)
					BuffFrame[i].Flag:SetAlpha(1)
					break
				end
			end
		end
	end
	-- 按照物理/法系分别对应不同的ID List
	if Flag then
		if RaidBuffList[6] and RaidBuffList[6][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Texture:SetTexture(select(3, GetSpellInfo(RaidBuffList[6][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			BuffFrame[6].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[6]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[6].Texture:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					BuffFrame[6].Flag:SetAlpha(1)
					break
				end
			end
		end
	else
		if RaidBuffList[7] and RaidBuffList[7][1] then
			BuffFrame[6]:SetAlpha(1)
			BuffFrame[6].Texture:SetTexture(select(3, GetSpellInfo(RaidBuffList[7][1])))
			BuffFrame[6].Overlay:SetAlpha(0.7)
			BuffFrame[6].Flag:SetAlpha(0)
			for key, value in pairs(RaidBuffList[7]) do
				local name = GetSpellInfo(value)
				if UnitAura("player", name) then
					BuffFrame[6].Texture:SetTexture(select(3, GetSpellInfo(value)))
					BuffFrame[6]:SetAlpha(1)
					BuffFrame[6].Overlay:SetAlpha(0)
					BuffFrame[6].Flag:SetAlpha(1)
					break
				end
			end
		end
	end
end)