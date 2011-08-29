local addon, ns = ...
local oUF = ns.oUF or oUF
  
local cfg = ns.cfg
local lib = ns.lib
  
	-- Unit has an Aura
	function hasUnitAura(unit, name)
	
		local _, _, _, count, _, _, _, caster = UnitAura(unit, name)
		if (caster and caster == "player") then
			return count
		end
	end
	
	-- Unit has a Debuff
	function hasUnitDebuff(unit, name)
		
		local _, _, _, count, _, _, _, _ = UnitDebuff(unit, name)
		if (count) then return count
		end
	end
			
local MyPvPUpdate = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local pvp = self.MyPvP
	if(pvp) then
		local factionGroup = UnitFactionGroup(unit)
		-- FFA!
		if(UnitIsPVPFreeForAll(unit)) then
			pvp:SetTexture([[Interface\TargetingFrame\UI-PVP-FFA]])
			pvp:Show()
		elseif(UnitIsPVP(unit) and factionGroup) then
			if(factionGroup == 'Horde') then
				pvp:SetTexture([[Interface\Addons\oUF_Fail\media\Horde]])
			else
				pvp:SetTexture([[Interface\Addons\oUF_Fail\media\Alliance]])
			end
			pvp:Show()
		else
			pvp:Hide()
		end
	end
end

oUF.colors.smooth = {42/255,48/255,50/255, 42/255,48/255,50/255, 42/255,48/255,50/255}
  -----------------------------
  -- STYLE FUNCTIONS
  -----------------------------

local UnitSpecific = {

	player = function(self, ...)

		self.mystyle = "player"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(220, 22)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_portrait(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.gen_InfoIcons(self)
		lib.HealPred(self)
		lib.gen_castbar(self)
		lib.RogueComboPoints(self)

		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		
		self.Power.colorPower = true
		self.Power.Smooth = true
		self.Power.frequentUpdates = true
		self.Power.BG.multiplier = 0.2

		lib.genRunes(self)
		lib.genHolyPower(self)
		lib.genShards(self)
		lib.addEclipseBar(self)
		lib.gen_TotemBar(self)
		
	end,
	
	target = function(self, ...)
	
		self.mystyle = "target"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(220, 22)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_portrait(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.gen_InfoIcons(self)
		lib.gen_castbar(self)
		lib.debuffHighlight(self)
		lib.HealPred(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		self.Health.colorTapping = true
		
		self.Power.frequentUpdates = true
		self.Power.Smooth = true
		self.Power.colorPower = true
		self.Power.BG.multiplier = 0.2


		if cfg.showTargetBuffs then	lib.createBuffs(self) end
		if cfg.showTargetDebuffs then lib.createDebuffs(self) end

	end,
	
	focus = function(self, ...)
	
		self.mystyle = "focus"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(220, 22)
		
		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_portrait(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.gen_castbar(self)
		lib.HealPred(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.Smooth = true
		self.Health.colorSmooth = true
		
		self.Power.frequentUpdates = true
		self.Power.Smooth = true
		self.Power.colorPower = true
		self.Power.BG.multiplier = 0.2

		
	end,
	
	targettarget = function(self, ...)

		self.mystyle = "tot"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(60, 14)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true

	end,
	
	focustarget = function(self, ...)
		
		self.mystyle = "focustarget"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(60, 14)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
	
	end,
	
	pet = function(self, ...)
		local _, playerClass = UnitClass("player")
		
		self.mystyle = "pet"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(60,14)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_ppbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		
		self.Power.frequentUpdates = true
		self.Power.Smooth = true
		self.Power.colorPower = true
		self.Power.BG.multiplier = 0.2

	end,

  raid = function(self, ...)
				
		self.mystyle = "raid"
		
		self.Range = {
			insideAlpha = 1,
			outsideAlpha = 0.4,
		}

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.ReadyCheck(self)
		lib.gen_LFDRole(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Power.colorPower = true
		self.Power.BG.multiplier = 0.2
		lib.gen_InfoIcons(self)
		lib.CreateThreatBorder(self)
		lib.HealPred(self)
		lib.debuffHighlight(self)
		lib.raidDebuffs(self)
		lib.createAuraWatch(self, unit)

		self.Health.PostUpdate = lib.PostUpdateRaidFrame
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
	end,
}	
  
-- The Shared Style Function
local GlobalStyle = function(self, unit, isSingle)

	self.menu = lib.spawnMenu
	self:RegisterForClicks('AnyDown')
	
	-- Call Unit Specific Styles
	if UnitSpecific[unit] then
		return UnitSpecific[unit](self)
	end
end

-- The Shared Style Function for Party and Raid
local GroupGlobalStyle = function(self, unit)

	self.menu = lib.spawnMenu
	self:RegisterForClicks('AnyDown')
	
	-- Call Unit Specific Styles
	if UnitSpecific[unit] then
		return UnitSpecific[unit](self)
	end
end
	
  -----------------------------
  -- SPAWN UNITS
  -----------------------------

oUF:RegisterStyle('Sora', GlobalStyle)
oUF:RegisterStyle('SoraGroup', GroupGlobalStyle)

oUF:Factory(function(self)

	-- Single Frames
	self:SetActiveStyle('Sora')
	self:Spawn('player'):SetPoint("CENTER", UIParent, "CENTER", -270, -100)
	self:Spawn('target'):SetPoint("CENTER", UIParent, "CENTER", 270, -100)
	if cfg.showtot then self:Spawn('targettarget'):SetPoint("TOPRIGHT",oUF_SoraTarget,"BOTTOMRIGHT", 0, -25) end
	if cfg.showpet then self:Spawn('pet'):SetPoint("RIGHT",oUF_SoraPlayer,"LEFT", -10, 0) end
	if cfg.showfocus then self:Spawn('focus'):SetPoint("BOTTOM", oUF_SoraPlayer, "TOP", 0, 150) end
	if cfg.showfocustarget then self:Spawn('focustarget'):SetPoint("BOTTOMLEFT",oUF_SoraFocus,"TOPLEFT", 0, 10) end
	
	-- Raid Frames
	if cfg.ShowRaid then
		-- Hide the Blizzard raid frames
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager.Show = function() end
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer.Show = function() end
		CompactRaidFrameContainer:Hide()		
		CompactRaidFrameContainer:SetParent(UIParent)
	end		
	if cfg.RaidPartyH then
		local raid = oUF:SpawnHeader("oUF_Raid", nil, 'raid,party,solo',
			"showRaid", cfg.ShowRaid,  
			'showPlayer', true,
			'showSolo', false,
			'showParty', true,
			"xoffset", 7,
			"yOffset", -10,
			"groupFilter", "1,2,3,4,5",
			"groupBy", "GROUP",
			"groupingOrder", "1,2,3,4,5",
			"sortMethod", "INDEX",
			"maxColumns", 5,
			"unitsPerColumn", 5,
			"columnSpacing", 9,
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(cfg.RaidUnitWidth, cfg.RaidUnitHeight))
		raid:SetScale(cfg.raidScale)
		raid:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT", -425, 165)		
	else
		local raid = oUF:SpawnHeader("oUF_Raid", nil, 'raid,party,solo',
			"showRaid", cfg.ShowRaid,  
			'showPlayer', true,
			'showSolo', false,
			'showParty', true,
			"xoffset", 7,
			"yOffset", -10,
			"groupFilter", "1,2,3,4,5",
			"groupBy", "GROUP",
			"groupingOrder", "1,2,3,4,5",
			"sortMethod", "INDEX",
			"maxColumns", 5,
			"unitsPerColumn", 5,
			"columnSpacing", 9,
			"point", "TOP",
			"columnAnchorPoint", "LEFT",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(cfg.RaidUnitWidth, cfg.RaidUnitHeight))
		raid:SetScale(cfg.raidScale)
		raid:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT", -430, 165)
	end
end)
