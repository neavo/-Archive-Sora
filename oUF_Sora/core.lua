local addon, ns = ...
local oUF = ns.oUF or oUF
  
local cfg = ns.cfg
local lib = ns.lib

-----------------------------
-- STYLE FUNCTIONS
-----------------------------

local UnitSpecific = {

	party = function(self, ...)
				
		self.mystyle = "party"

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = 0.4,
		}

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_ppbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_RaidMark(self)
		lib.ReadyCheck(self)
		lib.gen_LFDRole(self)
		
		-- style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Power.colorPower = true
		self.Power.BG.multiplier = 0.2
		lib.gen_InfoIcons(self)
		lib.CreateThreatBorder(self)
		
		if cfg.showPartyDebuff then lib.createDebuffs(self) end

		self.Health.PostUpdate = lib.PostUpdateRaidFrame
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
	end,

  raid = function(self, ...)
				
		self.mystyle = "raid"
		
		self.Range = {
			insideAlpha = 1,
			outsideAlpha = 0.4,
		}

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_ppbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
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
	
  -----------------------------
  -- SPAWN UNITS
  -----------------------------

oUF:RegisterStyle('Sora', GlobalStyle)

oUF:Factory(function(self)

	-- Single Frames
	self:SetActiveStyle('Sora')

	if cfg.ShowParty or cfg.ShowRaid then
		-- Hide the Blizzard raid frames
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager.Show = function() end
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer.Show = function() end
		CompactRaidFrameContainer:Hide()		
		CompactRaidFrameContainer:SetParent(UIParent)	
	end
	
	-- Party Frames
	if cfg.ShowParty then
		local party = oUF:SpawnHeader("oUF_Party", nil, 'raid,party,solo',
		"showRaid", false,
		"showParty", cfg.ShowParty, 
		'showSolo', false,
		"showPlayer", false,
		"yoffset", -30,
		"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
   		]]):format(180, 26))
		party:SetScale(cfg.raidScale)
		party:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -280)
	end
	
	-- Raid Frames
	if cfg.ShowRaid then
		if cfg.RaidPartyH then
			local raid = oUF:SpawnHeader("oUF_Raid", nil, 'raid,party,solo',
				"showRaid", cfg.ShowRaid,  
				'showPlayer', true,
				'showSolo', false,
				'showParty', true,
				"xoffset", 7,
				"groupFilter", "1,2,3,4,5",
				"groupBy", "GROUP",
				"groupingOrder", "1,2,3,4,5",
				"sortMethod", "INDEX",
				"maxColumns", 5,
				"unitsPerColumn", 5,
				"columnSpacing", 7,
				"point", "LEFT",
				"columnAnchorPoint", "TOP",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				]]):format(cfg.RaidUnitWidth, 20))
			raid:SetScale(cfg.raidScale)
			raid:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT", -370, 135)		
		else
			local raid = oUF:SpawnHeader("oUF_Raid", nil, 'raid,party,solo',
				"showRaid", cfg.ShowRaid,  
				'showPlayer', true,
				'showSolo', false,
				'showParty', true,
				"yoffset", -7,
				"groupFilter", "1,2,3,4,5",
				"groupBy", "GROUP",
				"groupingOrder", "1,2,3,4,5",
				"sortMethod", "INDEX",
				"maxColumns", 5,
				"unitsPerColumn", 5,
				"columnSpacing", 7,
				"point", "TOP",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				]]):format(cfg.RaidUnitWidth, 20))
			raid:SetScale(cfg.raidScale)
			raid:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT", -370, 135)
		end
	end
end)
