local _, ns = ...
local oUF = ns.oUF or oUF

local PrePriority = 0
local ZoneList = {}
local RaidDebuffList = {
	-- Baradin Hold
	[752] = {
		-- Demon Containment Unit
		{89354, 2},
		-- Argaloth
		{88942, 11}, -- Meteor Slash
		{88954, 12}, -- Consuming Darkness
		-- Occu'thar
		{96913, 21}, -- Searing Shadows
		-- Eye of Occu'thar
		{97028, 22}, -- Gaze of Occu'thar		
	},
	-- Firelands
	[800] = {
		-- Flamewaker Forward Guard
		{76622, 2}, -- Sunder Armor
		{99610, 2}, -- Shockwave
		-- Flamewaker Pathfinder
		{99695, 2}, -- Flaming Spear
		{99800, 2}, -- Ensnare
		-- Fire Scorpion
		{99993, 2}, -- Fiery Blood
		-- Molten Lord
		{100767, 2}, -- Melt Armor
		-- Ancient Core Hound
		{99693, 2}, -- Dinner Time
		-- Unstable Magma
		{100549, 2}, -- Lava Surge
		-- Hell Hound
		{100057, 2}, -- Rend Flesh
		-- Unbound Pyrelord
		{101166, 2}, -- Ignite
		-- Flamewalker Subjugator
		{100526, 2}, -- Blistering Wound
		-- Harbinger of Flame
		{100095, 2}, -- Fieroclast Barrage
		-- Druid of the Flame
		{99650, 2}, -- Reactive flames
		-- Magma
		{97151, 2}, -- Magma

		-- Beth'tilac
		{99506, 11}, -- The Widow's Kiss
		-- Cinderweb Drone
		{49026, 12}, -- Fixate (Heroic)
		-- Cinderweb Spinner
		{97202, 13}, -- Fiery Web Spin
		-- Cinderweb Spiderling
		{97079, 14}, -- Seeping Venom
		-- Upstairs
		{100048, 15}, -- Fiery Web Silk

		-- Lord Rhyolith
		{98492, 21}, -- Eruption

		-- Alysrazor
		{101729, 31}, -- Blazing Claw
		{100094, 32}, -- Fieroblast
		{99389, 33}, -- Imprinted
		{99308, 34}, -- Gushing Wound
		{100640, 35}, -- Harsh Winds
		{100555, 35}, -- Smouldering Roots

		-- Shannox
		{99936, 41}, -- Jagged Tear
		{99837, 42}, -- Crystal Prison Trap Effect
		{101208, 43}, -- Immolation Trap
		{99840, 44}, -- Magma Rupture
		-- Rageface
		{99947, 45},  -- Face Rage
		{100415, 46}, -- Rage

		-- Baleroc
		{99252, 51}, -- Blaze of Glory
		{99256, 52}, -- Torment
		{99403, 53}, -- Tormented
		{99516, 54}, -- Countdown
		{99353, 55}, -- Decimating Strike
		{100908, 56}, -- Fiery Torment

		-- Majordomo Staghelm
		{98535, 61}, -- Leaping Flames
		{98443, 62}, -- Fiery Cyclone
		{98450, 63}, -- Searing Seeds
		-- Burning Orbs
		{100210, 65}, -- Burning Orb
		-- ?
		{96993, 64}, -- Stay Withdrawn?

		-- Ragnaros
		{99399, 71}, -- Burning Wound
		{100293, 72}, -- Lava Wave
		{100238, 73}, -- Magma Trap Vulnerability
		{98313, 74}, -- Magma Blast
		-- Lava Scion
		{100460, 75}, -- Blazing Heat
		-- Lava
		{98981, 76}, -- Lava Bolt
		-- Living Meteor
		{100249, 77}, -- Combustion
		-- Molten Wyrms
		{99613, 78}, -- Molten Blast
	},
	-- Blackwing Descent
	[754] = {
		-- Drakonid Slayer
		{80390, 2}, -- Mortal Strike
		-- Maimgor/Ivoroc
		{80270, 2}, -- Shadowflame
		{80145, 2}, -- Piercing Grip
		-- Spirit of Ironstar (spreads to other spirits when you kill Ironstar)
		{80727, 2}, -- Execution Sentence
		-- Drakeadon Mongrel
		{80345, 2}, -- Corrosive Acid
		{80329, 2}, -- Time Lapse
		-- Drakonid Drudge
		{79630, 2}, -- Drakonid Rush
		-- Drakonid Chainwielder
		{79589, 2}, -- Constricting Chains
		{79580, 2}, -- Overhead Smash
		{91910, 2}, -- Grievous Wound
		-- Golem Sentry
		{81060, 2}, -- Flash Bomb
		-- Pyrecraw
		{80127, 2}, -- Flame Buffet
		-- Nefarian
		{79353, 2}, -- Shadow of Cowardice
		
		-- Magmaw
		{89773, 11}, -- Mangle
		{78941, 12}, -- Parasitic Infection
		{88287, 13}, -- Massive Crash
		{78199, 14}, -- Sweltering Armor
		
		-- Omnitron Defense System
		{79888, 21}, -- Lightning Conductor
		{80161, 22}, -- Chemical Cloud
		{80011, 23}, -- Soaked in Poison
		{79505, 24}, -- Flamethrower
		{80094, 25}, -- Fixate
		{79501, 26}, -- Acquiring Target
		-- Omnitron Defense System(Heroic)
		{92053, 27}, -- Shadow Conductor
		{92048, 28}, -- Shadow Infusion
		{92023, 29}, -- Encasing Shadows
		
		-- Chimaeron
		{89084, 31}, -- Low Health
		{82890, 32}, -- Mortality
		{82935, 33}, -- Caustic Slime
		-- Chimaeron(Heroic)
		{82881, 34}, -- Break
		{91307, 35}, -- Mocking Shadows

		-- Atramedes
		{78092, 41}, -- Tracking
		{77982, 42}, -- Searing Flame
		{78023, 43}, -- Roaring Flame
		{78897, 44}, -- Noisy!
		-- Atramedes(Heroic)
		{92685, 45}, --Pestered!

		-- Maloriak
		{78034, 51}, -- Rend 10-normal
		{78225, 52}, -- Acid Nova 10-normal
		{77615, 53}, -- Debilitating Slime 10-normal/25-normal
		{77786, 54}, -- Consuming Flames 10-normal
		{78617, 55}, -- Fixate
		{77760, 56}, -- Biting Chill
		{77699, 57}, -- Flash Freeze 10-normal
		-- Maloriak(Heroic)
		{92987, 58}, -- Dark Sludge 
		{92982, 59}, -- Engulfing Darkness

		-- Nefarian
		{81118, 81}, -- Magma 10-normal
		{77827, 82}, -- Tail Lash 10-normal
		-- Nefarian(Heroic)
		{79339, 83}, -- Explosive Cinders
		{79318, 84}, -- Dominion
	},
	-- The Bastion of Twilight
	[758] = {
		-- Magma (falling off)
		{81118, 2}, -- Magma
		-- Tremors
		{87931, 2}, -- Tremors
		-- Phased Burn
		{85799, 2}, -- Phased Burn
		-- Crimson Flames
		{88232, 2}, -- Crimson Flames
		-- Twilight Soulblade
		{84850, 2}, -- Soul Blade
		{84853, 2}, -- Dark Pool
		-- Crimsonborne Firestarter
		{88219, 2}, -- Burning Twilight
		-- Twilight Elementalist
		{88079, 2}, -- Frostfire Bolt
		-- Twilight Shadow Knight
		{76622, 2}, -- Sunder Armor
		{84832, 2}, -- Dismantle
		-- Twilight Dark Mender
		{84856, 2}, -- Hungering Shadows
		-- Twilight Shadow Mender
		{85643, 2}, -- Mind Sear
		-- Twilight-shifter
		{85564, 2}, -- Shifted Reality
		-- Bound Zephyr
		{93277, 2}, -- Rending Gale
		{93306, 2}, -- Vaporize
		-- Bound Rumbler
		{93327, 2}, -- Entomb
		{93325, 2}, -- Shockwave
		-- Faceless Guardian
		{85482, 2}, -- Shadow Volley
		-- Shadow Lord
		{87629, 2}, -- Gripping Shadows

		-- Halfus Wyrmbreaker
		{83710, 11}, -- Furious Roar
		{83908, 12}, -- Malevolent Strikes
		{83603, 13}, -- Stone Touch

		-- Valiona and Theralion
		{86788, 21}, -- Blackout 10-normal
		{86622, 22}, -- Engulfing Magic 10-normal
		{86202, 23}, -- Twilight Shift 10-normal
		{86014, 24}, -- Twilight Meteorite
		{92886, 25}, -- Twilight Zone

		-- Twilight Ascendant Council
		{82762, 31}, -- Waterlogged
		{83099, 32}, -- Lightning Rod
		{82285, 33}, -- Elemental Stasis
		{82660, 34}, -- Burning Blood
		{82665, 35}, -- Heart of Ice
		{82772, 36}, -- Frozen
		{84948, 37}, -- Gravity Crush
		{83500, 38}, -- Swirling Winds
		{83581, 38}, -- Grounded
		{82285, 38}, -- Elemental Stasis
		-- Twilight Ascendant Council(Heroic)
		{92307, 39}, -- Frost Beacon
		{92467, 39}, -- Static Overload
		{92538, 39}, -- Gravity Core

		-- Cho'gall
		{81701, 41}, -- Corrupted Blood
		{81836, 42}, -- Corruption: Accelerated
		{82125, 43}, -- Corruption: Malformation
		{82170, 44}, -- Corruption: Absolute
		{82523, 45}, -- Gall's Blast
		{82518, 46}, -- Cho's Blast
		{82411, 47}, -- Debilitating Beam

		-- Sinestra
		{89299, 51}, -- Twilight Spit
	},
	-- Throne of the Four Winds
	[773] = {
		-- Conclave of Wind
		{84645, 11}, -- Wind Chill
		{86111, 12}, -- Ice Patch
		{86082, 13}, -- Permafrost
		{86481, 14}, -- Hurricane
		{86282, 15}, -- Toxic Spores
		{85573, 16}, -- Deafening Winds
		{85576, 17}, -- Withering Winds
		-- Conclave of Wind(Heroic)
		{93057, 18}, -- Slicing Gale

		--Al'Akir
		{88301, 21}, --Acid Rain
		{87873, 22}, --Static Shock
		{88427, 23}, --Electrocute
		{89666, 24}, --Lightning Rod
		{89668, 25}, --Lightning Rod
		{87856, 25}, --Squall Line
	}, 
	-- AnyZone
	["AnyZone"] = {
		-- Priest
		{6346, 1}, -- Fear Ward
		{605, 1}, -- Mind Control
		{8122, 1}, -- Psychic Scream
		{64044, 1}, -- Psychic Horror	
		{69910, 1}, -- Pain Suppression
		{15487, 1}, -- Silence
		{47585, 1}, -- Dispersion	
		{17, 1}, -- Power Word: Shield
		{88625, 1}, -- Holy Word: Chastise
		
		-- Paladin
		{853, 1}, -- Hammer of Justice
		{642, 1}, -- Divine Shield
		{10278, 1}, -- Hand of Protection
		{1044, 1}, -- Hand of Freedom
		{6940, 1}, -- Hand of Sacrifice	
		{20066, 1}, -- Repentance
		
		-- Rogue
		{31224, 1}, -- Cloak of Shadows
		{5277, 1}, -- Evasion
		{43235, 1}, -- Wound Poison
		{2094, 1}, -- Blind
		{6770, 1}, -- Sap
		{408, 1}, -- Kidney Shot
		{1776, 1}, -- Gouge	
			
		-- Warrior
		{12294, 1}, -- Mortal Strike
		{1715, 1}, -- Hamstring
		{871, 1}, -- Shield Wall	
		{18499, 1}, -- Berserker Rage
		
		-- Druid
		{33786, 1}, -- Cyclone
		{339, 1}, -- Entangling Roots
		{29166, 1}, -- Innervate
		{2637, 1}, -- Hibernate
		
		-- Warlock
		{5782, 1}, -- Fear
		{5484, 1}, -- Howl of Terror
		{6358, 1}, -- Seduction	
		{1714, 1}, -- Curse of Tongues
		{18223, 1}, -- Curse of Exhaustion
		{6789, 1}, -- Death Coil
		{30283, 1}, -- Shadowfury
		
		-- Shaman
		{51514, 1}, -- Hex
		
		-- Mage
		{18469, 1}, -- Silenced - Improved Counterspell - Rank1
		{55021, 1}, -- Silenced - Improved Counterspell - Rank2
		{2139, 1}, -- Counterspell
		{118, 1}, -- Polymorph
		{61305, 1}, -- Polymorph Black Cat
		{28272, 1}, -- Polymorph Pig
		{61721, 1}, -- Polymorph Rabbit
		{61780, 1}, -- Polymorph Turkey
		{28271, 1}, -- Polymorph Turtle
		{44572, 1}, -- Deep Freeze
		{45438, 1}, -- Ice Block	
		{122, 1}, -- Frost Nova
	
		-- Hunter
		{19503, 1}, -- Scatter Shot
		{55041, 1}, -- Freezing Trap Effect
		{2974, 1}, -- Wing Clip
		{19263, 1}, -- Deterrence
		{34490, 1}, -- Silencing Shot
		{19386, 1}, -- Wyvern Sting
		{19577, 1}, -- Intimidation
		
		-- Death Knight
		{45524, 1}, -- Chains of Ice
		{48707, 1}, -- Anti-Magic Shell
		{47476, 1}, -- Strangulate
	}
}

local Event = CreateFrame("Frame")
Event.Timer = 0
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Event:SetScript("OnEvent", function(self, event, ...)
    self:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer < 5 then return end
		if IsInInstance() then
			SetMapToCurrentZone()
			local Zone = GetCurrentMapAreaID()
			ZoneList = RaidDebuffList["AnyZone"]
			if RaidDebuffList[Zone] then
				for _, value in pairs(RaidDebuffList[Zone]) do
					tinsert(ZoneList, value)
				end
			end
		else
			ZoneList = RaidDebuffList["AnyZone"]
		end
		self:SetScript("OnUpdate", nil)
	end)

    if event == "PLAYER_ENTERING_WORLD" then self:UnregisterEvent("PLAYER_ENTERING_WORLD") end
end)

local function ShouldBeShown(name)
	for key, value in pairs(ZoneList) do
		local Name = GetSpellInfo(value[1])
		if Name == name and value[2] >= PrePriority then
			PrePriority = value[2]
			return true
		end
	end
	return false
end

local function Update(self, event, unit)
    if self.unit ~= unit then return end
	local RaidDebuff = self.RaidDebuff
	local index = 1
	local Flag = true
    while true do
		local name, _, icon, count, _, duration, expires  = UnitAura(unit, index)
		if not name then break end
		if ShouldBeShown(name) then
			if RaidDebuff.Icon then RaidDebuff.Icon:SetTexture(icon) end
			if RaidDebuff.Count then RaidDebuff.Count:SetText(count > 1 and count or nil) end
			if RaidDebuff.Cooldown then RaidDebuff.Cooldown:SetCooldown(expires-duration, duration) end
			RaidDebuff:Show()
			Flag = false
		end
		index = index + 1
	end
	if Flag and RaidDebuff:IsShown() then
		RaidDebuff:Hide()
		PrePriority = 0
		Update(self, event, unit)
	end
end

local function Enable(self)
	if self.RaidDebuff then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local function Disable(self)
	if self.RaidDebuff then self:UnregisterEvent("UNIT_AURA", Update) end
end

oUF:AddElement("RaidDebuff", Update, Enable, Disable)
