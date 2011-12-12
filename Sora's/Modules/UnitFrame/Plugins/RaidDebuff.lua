local _, _, _, uiVersion = GetBuildInfo()
if uiVersion ~= 40300 then return end

local _, ns = ...
local oUF = ns.oUF or oUF

local PrePriority, ZoneList = 0, {}
local RaidDebuffList = {
	-- Baradin Hold
	[752] = {
		-- Demon Containment Unit
		[GetSpellInfo(89354)] = 2,
		-- Argaloth
		[GetSpellInfo(88942)] = 11, -- Meteor Slash
		[GetSpellInfo(88954)] = 12, -- Consuming Darkness
		-- Occu'thar
		[GetSpellInfo(96913)] = 21, -- Searing Shadows
		-- Eye of Occu'thar
		[GetSpellInfo(97028)] = 22, -- Gaze of Occu'thar		
	},
	-- Dragon Soul
	[824] = {
		--Morchok
		[GetSpellInfo(103687)] = 11, --Crush Armor
		[GetSpellInfo(103821)] = 12, --Earthen Vortex
		[GetSpellInfo(103785)] = 13, --Black Blood of the Earth
		[GetSpellInfo(103534)] = 14, --Danger (Red)
		[GetSpellInfo(103536)] = 15, --Warning (Yellow)
		-- Don't need to show Safe people
		[GetSpellInfo(103541)] = 16, --Safe (Blue)

		--Warlord Zon'ozz
		[GetSpellInfo(104378)] = 21, --Black Blood of Go'rath
		[GetSpellInfo(103434)] = 22, --Disrupting Shadows (dispellable)

		--Yor'sahj the Unsleeping
		[GetSpellInfo(104849)] = 31, --Void Bolt
		[GetSpellInfo(105171)] = 32, --Deep Corruption

		--Hagara the Stormbinder
		[GetSpellInfo(105316)] = 41, --Ice Lance
		[GetSpellInfo(105465)] = 42, --Lightning Storm
		[GetSpellInfo(105369)] = 43, --Lightning Conduit
		[GetSpellInfo(105289)] = 44, --Shattered Ice (dispellable)
		[GetSpellInfo(105285)] = 45, --Target (next Ice Lance)
		[GetSpellInfo(104451)] = 46, --Ice Tomb
		[GetSpellInfo(110317)] = 47, --Watery Entrenchment

		--Ultraxion
		[GetSpellInfo(105925)] = 51, --Fading Light
		[GetSpellInfo(106108)] = 52, --Heroic Will
		[GetSpellInfo(105984)] = 53, --Timeloop
		[GetSpellInfo(105927)] = 54, --Faded Into Twilight

		--Warmaster Blackhorn
		[GetSpellInfo(108043)] = 61, --Sunder Armor
		[GetSpellInfo(107558)] = 62, --Degeneration
		[GetSpellInfo(107567)] = 64, --Brutal Strike
		[GetSpellInfo(108046)] = 64, --Shockwave

		--Spine of Deathwing
		[GetSpellInfo(105563)] = 71, --Grasping Tendrils
		[GetSpellInfo(105479)] = 72, --Searing Plasma
		[GetSpellInfo(105490)] = 73, --Fiery Grip

		--Madness of Deathwing
		[GetSpellInfo(105445)] = 81, --Blistering Heat
		[GetSpellInfo(105841)] = 82, --Degenerative Bite
		[GetSpellInfo(106385)] = 83, --Crush
		[GetSpellInfo(106730)] = 84, --Tetanus
		[GetSpellInfo(106444)] = 85, --Impale
		[GetSpellInfo(106794)] = 86, --Shrapnel (target)
	},
	-- Firelands
	[800] = {
		-- Flamewaker Forward Guard
		[GetSpellInfo(76622)] = 2, -- Sunder Armor
		[GetSpellInfo(99610)] = 2, -- Shockwave
		-- Flamewaker Pathfinder
		[GetSpellInfo(99695)] = 2, -- Flaming Spear
		[GetSpellInfo(99800)] = 2, -- Ensnare
		-- Fire Scorpion
		[GetSpellInfo(99993)] = 2, -- Fiery Blood
		-- Molten Lord
		[GetSpellInfo(100767)] = 2, -- Melt Armor
		-- Ancient Core Hound
		[GetSpellInfo(99693)] = 2, -- Dinner Time
		-- Unstable Magma
		[GetSpellInfo(100549)] = 2, -- Lava Surge
		-- Hell Hound
		[GetSpellInfo(100057)] = 2, -- Rend Flesh
		-- Unbound Pyrelord
		[GetSpellInfo(101166)] = 2, -- Ignite
		-- Flamewalker Subjugator
		[GetSpellInfo(100526)] = 2, -- Blistering Wound
		-- Harbinger of Flame
		[GetSpellInfo(100095)] = 2, -- Fieroclast Barrage
		-- Druid of the Flame
		[GetSpellInfo(99650)] = 2, -- Reactive flames
		-- Magma
		[GetSpellInfo(97151)] = 2, -- Magma

		-- Beth'tilac
		[GetSpellInfo(99506)] = 11, -- The Widow's Kiss
		-- Cinderweb Drone
		[GetSpellInfo(49026)] = 12, -- Fixate (Heroic)
		-- Cinderweb Spinner
		[GetSpellInfo(97202)] = 13, -- Fiery Web Spin
		-- Cinderweb Spiderling
		[GetSpellInfo(97079)] = 14, -- Seeping Venom
		-- Upstairs
		[GetSpellInfo(100048)] = 15, -- Fiery Web Silk

		-- Lord Rhyolith
		[GetSpellInfo(98492)] = 21, -- Eruption

		-- Alysrazor
		[GetSpellInfo(101729)] = 31, -- Blazing Claw
		[GetSpellInfo(100094)] = 32, -- Fieroblast
		[GetSpellInfo(99389)] = 33, -- Imprinted
		[GetSpellInfo(99308)] = 34, -- Gushing Wound
		[GetSpellInfo(100640)] = 35, -- Harsh Winds
		[GetSpellInfo(100555)] = 35, -- Smouldering Roots

		-- Shannox
		[GetSpellInfo(99936)] = 41, -- Jagged Tear
		[GetSpellInfo(99837)] = 42, -- Crystal Prison Trap Effect
		[GetSpellInfo(101208)] = 43, -- Immolation Trap
		[GetSpellInfo(99840)] = 44, -- Magma Rupture
		-- Rageface
		[GetSpellInfo(99947)] = 45,  -- Face Rage
		[GetSpellInfo(100415)] = 46, -- Rage

		-- Baleroc
		[GetSpellInfo(99252)] = 51, -- Blaze of Glory
		[GetSpellInfo(99256)] = 52, -- Torment
		[GetSpellInfo(99403)] = 53, -- Tormented
		[GetSpellInfo(99516)] = 54, -- Countdown
		[GetSpellInfo(99353)] = 55, -- Decimating Strike
		[GetSpellInfo(100908)] = 56, -- Fiery Torment

		-- Majordomo Staghelm
		[GetSpellInfo(98535)] = 61, -- Leaping Flames
		[GetSpellInfo(98443)] = 62, -- Fiery Cyclone
		[GetSpellInfo(98450)] = 63, -- Searing Seeds
		-- Burning Orbs
		[GetSpellInfo(100210)] = 65, -- Burning Orb
		-- ?
		[GetSpellInfo(96993)] = 64, -- Stay Withdrawn?

		-- Ragnaros
		[GetSpellInfo(99399)] = 71, -- Burning Wound
		[GetSpellInfo(100293)] = 72, -- Lava Wave
		[GetSpellInfo(100238)] = 73, -- Magma Trap Vulnerability
		[GetSpellInfo(98313)] = 74, -- Magma Blast
		-- Lava Scion
		[GetSpellInfo(100460)] = 75, -- Blazing Heat
		-- Lava
		[GetSpellInfo(98981)] = 76, -- Lava Bolt
		-- Living Meteor
		[GetSpellInfo(100249)] = 77, -- Combustion
		-- Molten Wyrms
		[GetSpellInfo(99613)] = 78, -- Molten Blast
	},
	-- Blackwing Descent
	[754] = {
		-- Drakonid Slayer
		[GetSpellInfo(80390)] = 2, -- Mortal Strike
		-- Maimgor/Ivoroc
		[GetSpellInfo(80270)] = 2, -- Shadowflame
		[GetSpellInfo(80145)] = 2, -- Piercing Grip
		-- Spirit of Ironstar (spreads to other spirits when you kill Ironstar)
		[GetSpellInfo(80727)] = 2, -- Execution Sentence
		-- Drakeadon Mongrel
		[GetSpellInfo(80345)] = 2, -- Corrosive Acid
		[GetSpellInfo(80329)] = 2, -- Time Lapse
		-- Drakonid Drudge
		[GetSpellInfo(79630)] = 2, -- Drakonid Rush
		-- Drakonid Chainwielder
		[GetSpellInfo(79589)] = 2, -- Constricting Chains
		[GetSpellInfo(79580)] = 2, -- Overhead Smash
		[GetSpellInfo(91910)] = 2, -- Grievous Wound
		-- Golem Sentry
		[GetSpellInfo(81060)] = 2, -- Flash Bomb
		-- Pyrecraw
		[GetSpellInfo(80127)] = 2, -- Flame Buffet
		-- Nefarian
		[GetSpellInfo(79353)] = 2, -- Shadow of Cowardice
		
		-- Magmaw
		[GetSpellInfo(89773)] = 11, -- Mangle
		[GetSpellInfo(78941)] = 12, -- Parasitic Infection
		[GetSpellInfo(88287)] = 13, -- Massive Crash
		[GetSpellInfo(78199)] = 14, -- Sweltering Armor
		
		-- Omnitron Defense System
		[GetSpellInfo(79888)] = 21, -- Lightning Conductor
		[GetSpellInfo(80161)] = 22, -- Chemical Cloud
		[GetSpellInfo(80011)] = 23, -- Soaked in Poison
		[GetSpellInfo(79505)] = 24, -- Flamethrower
		[GetSpellInfo(80094)] = 25, -- Fixate
		[GetSpellInfo(79501)] = 26, -- Acquiring Target
		-- Omnitron Defense System(Heroic)
		[GetSpellInfo(92053)] = 27, -- Shadow Conductor
		[GetSpellInfo(92048)] = 28, -- Shadow Infusion
		[GetSpellInfo(92023)] = 29, -- Encasing Shadows
		
		-- Chimaeron
		[GetSpellInfo(89084)] = 31, -- Low Health
		[GetSpellInfo(82890)] = 32, -- Mortality
		[GetSpellInfo(82935)] = 33, -- Caustic Slime
		-- Chimaeron(Heroic)
		[GetSpellInfo(82881)] = 34, -- Break
		[GetSpellInfo(91307)] = 35, -- Mocking Shadows

		-- Atramedes
		[GetSpellInfo(78092)] = 41, -- Tracking
		[GetSpellInfo(77982)] = 42, -- Searing Flame
		[GetSpellInfo(78023)] = 43, -- Roaring Flame
		[GetSpellInfo(78897)] = 44, -- Noisy!
		-- Atramedes(Heroic)
		[GetSpellInfo(92685)] = 45, -- Pestered!

		-- Maloriak
		[GetSpellInfo(78034)] = 51, -- Rend 10-normal
		[GetSpellInfo(78225)] = 52, -- Acid Nova 10-normal
		[GetSpellInfo(77615)] = 53, -- Debilitating Slime 10-normal/25-normal
		[GetSpellInfo(77786)] = 54, -- Consuming Flames 10-normal
		[GetSpellInfo(78617)] = 55, -- Fixate
		[GetSpellInfo(77760)] = 56, -- Biting Chill
		[GetSpellInfo(77699)] = 57, -- Flash Freeze 10-normal
		-- Maloriak(Heroic)
		[GetSpellInfo(92987)] = 58, -- Dark Sludge 
		[GetSpellInfo(92982)] = 59, -- Engulfing Darkness

		-- Nefarian
		[GetSpellInfo(81118)] = 81, -- Magma 10-normal
		[GetSpellInfo(77827)] = 82, -- Tail Lash 10-normal
		-- Nefarian(Heroic)
		[GetSpellInfo(79339)] = 83, -- Explosive Cinders
		[GetSpellInfo(79318)] = 84, -- Dominion
	},
	-- The Bastion of Twilight
	[758] = {
		-- Magma (falling off)
		[GetSpellInfo(81118)] = 2, -- Magma
		-- Tremors
		[GetSpellInfo(87931)] = 2, -- Tremors
		-- Phased Burn
		[GetSpellInfo(85799)] = 2, -- Phased Burn
		-- Crimson Flames
		[GetSpellInfo(88232)] = 2, -- Crimson Flames
		-- Twilight Soulblade
		[GetSpellInfo(84850)] = 2, -- Soul Blade
		[GetSpellInfo(84853)] = 2, -- Dark Pool
		-- Crimsonborne Firestarter
		[GetSpellInfo(88219)] = 2, -- Burning Twilight
		-- Twilight Elementalist
		[GetSpellInfo(88079)] = 2, -- Frostfire Bolt
		-- Twilight Shadow Knight
		[GetSpellInfo(76622)] = 2, -- Sunder Armor
		[GetSpellInfo(84832)] = 2, -- Dismantle
		-- Twilight Dark Mender
		[GetSpellInfo(84856)] = 2, -- Hungering Shadows
		-- Twilight Shadow Mender
		[GetSpellInfo(85643)] = 2, -- Mind Sear
		-- Twilight-shifter
		[GetSpellInfo(85564)] = 2, -- Shifted Reality
		-- Bound Zephyr
		[GetSpellInfo(93277)] = 2, -- Rending Gale
		[GetSpellInfo(93306)] = 2, -- Vaporize
		-- Bound Rumbler
		[GetSpellInfo(93327)] = 2, -- Entomb
		[GetSpellInfo(93325)] = 2, -- Shockwave
		-- Faceless Guardian
		[GetSpellInfo(85482)] = 2, -- Shadow Volley
		-- Shadow Lord
		[GetSpellInfo(87629)] = 2, -- Gripping Shadows

		-- Halfus Wyrmbreaker
		[GetSpellInfo(83710)] = 11, -- Furious Roar
		[GetSpellInfo(83908)] = 12, -- Malevolent Strikes
		[GetSpellInfo(83603)] = 13, -- Stone Touch

		-- Valiona and Theralion
		[GetSpellInfo(86788)] = 21, -- Blackout 10-normal
		[GetSpellInfo(86622)] = 22, -- Engulfing Magic 10-normal
		[GetSpellInfo(86202)] = 23, -- Twilight Shift 10-normal
		[GetSpellInfo(86014)] = 24, -- Twilight Meteorite
		[GetSpellInfo(92886)] = 25, -- Twilight Zone

		-- Twilight Ascendant Council
		[GetSpellInfo(82762)] = 31, -- Waterlogged
		[GetSpellInfo(83099)] = 32, -- Lightning Rod
		[GetSpellInfo(82285)] = 33, -- Elemental Stasis
		[GetSpellInfo(82660)] = 34, -- Burning Blood
		[GetSpellInfo(82665)] = 35, -- Heart of Ice
		[GetSpellInfo(82772)] = 36, -- Frozen
		[GetSpellInfo(84948)] = 37, -- Gravity Crush
		[GetSpellInfo(83500)] = 38, -- Swirling Winds
		[GetSpellInfo(83581)] = 38, -- Grounded
		[GetSpellInfo(82285)] = 38, -- Elemental Stasis
		-- Twilight Ascendant Council(Heroic)
		[GetSpellInfo(92307)] = 39, -- Frost Beacon
		[GetSpellInfo(92467)] = 39, -- Static Overload
		[GetSpellInfo(92538)] = 39, -- Gravity Core

		-- Cho'gall
		[GetSpellInfo(81701)] = 41, -- Corrupted Blood
		[GetSpellInfo(81836)] = 42, -- Corruption: Accelerated
		[GetSpellInfo(82125)] = 43, -- Corruption: Malformation
		[GetSpellInfo(82170)] = 44, -- Corruption: Absolute
		[GetSpellInfo(82523)] = 45, -- Gall's Blast
		[GetSpellInfo(82518)] = 46, -- Cho's Blast
		[GetSpellInfo(82411)] = 47, -- Debilitating Beam

		-- Sinestra
		[GetSpellInfo(89299)] = 51, -- Twilight Spit
	},
	-- Throne of the Four Winds
	[773] = {
		-- Conclave of Wind
		[GetSpellInfo(84645)] = 11, -- Wind Chill
		[GetSpellInfo(86111)] = 12, -- Ice Patch
		[GetSpellInfo(86082)] = 13, -- Permafrost
		[GetSpellInfo(86481)] = 14, -- Hurricane
		[GetSpellInfo(86282)] = 15, -- Toxic Spores
		[GetSpellInfo(85573)] = 16, -- Deafening Winds
		[GetSpellInfo(85576)] = 17, -- Withering Winds
		-- Conclave of Wind(Heroic)
		[GetSpellInfo(93057)] = 18, -- Slicing Gale

		--Al'Akir
		[GetSpellInfo(88301)] = 21, --Acid Rain
		[GetSpellInfo(87873)] = 22, --Static Shock
		[GetSpellInfo(88427)] = 23, --Electrocute
		[GetSpellInfo(89666)] = 24, --Lightning Rod
		[GetSpellInfo(89668)] = 25, --Lightning Rod
		[GetSpellInfo(87856)] = 25, --Squall Line
	},
	-- AnyZone
	["AnyZone"] = {
		-- Priest
		[GetSpellInfo(6346)] = 1, -- Fear Ward
		[GetSpellInfo(605)] = 1, -- Mind Control
		[GetSpellInfo(8122)] = 1, -- Psychic Scream
		[GetSpellInfo(64044)] = 1, -- Psychic Horror	
		[GetSpellInfo(69910)] = 1, -- Pain Suppression
		[GetSpellInfo(15487)] = 1, -- Silence
		[GetSpellInfo(47585)] = 1, -- Dispersion	
		[GetSpellInfo(17)] = 1, -- Power Word: Shield
		[GetSpellInfo(88625)] = 1, -- Holy Word: Chastise
		
		-- Paladin
		[GetSpellInfo(853)] = 1, -- Hammer of Justice
		[GetSpellInfo(642)] = 1, -- Divine Shield
		[GetSpellInfo(1022)] = 1, -- Hand of Protection
		[GetSpellInfo(1044)] = 1, -- Hand of Freedom
		[GetSpellInfo(6940)] = 1, -- Hand of Sacrifice	
		[GetSpellInfo(20066)] = 1, -- Repentance
		[GetSpellInfo(20925)] = 1, -- 神圣之盾
		[GetSpellInfo(86150)] = 1, -- 远古列王守卫
		
		-- Rogue
		[GetSpellInfo(31224)] = 1, -- Cloak of Shadows
		[GetSpellInfo(5277)] = 1, -- Evasion
		[GetSpellInfo(43235)] = 1, -- Wound Poison
		[GetSpellInfo(2094)] = 1, -- Blind
		[GetSpellInfo(6770)] = 1, -- Sap
		[GetSpellInfo(408)] = 1, -- Kidney Shot
		[GetSpellInfo(1776)] = 1, -- Gouge	
			
		-- Warrior
		[GetSpellInfo(12294)] = 1, -- Mortal Strike
		[GetSpellInfo(1715)] = 1, -- Hamstring
		[GetSpellInfo(871)] = 1, -- Shield Wall	
		[GetSpellInfo(18499)] = 1, -- Berserker Rage
		
		-- Druid
		[GetSpellInfo(33786)] = 1, -- Cyclone
		[GetSpellInfo(339)] = 1, -- Entangling Roots
		[GetSpellInfo(29166)] = 1, -- Innervate
		[GetSpellInfo(2637)] = 1, -- Hibernate
		
		-- Warlock
		[GetSpellInfo(5782)] = 1, -- Fear
		[GetSpellInfo(5484)] = 1, -- Howl of Terror
		[GetSpellInfo(6358)] = 1, -- Seduction	
		[GetSpellInfo(1714)] = 1, -- Curse of Tongues
		[GetSpellInfo(18223)] = 1, -- Curse of Exhaustion
		[GetSpellInfo(6789)] = 1, -- Death Coil
		[GetSpellInfo(30283)] = 1, -- Shadowfury
		
		-- Shaman
		[GetSpellInfo(51514)] = 1, -- Hex
		
		-- Mage
		[GetSpellInfo(18469)] = 1, -- Silenced - Improved Counterspell - Rank1
		[GetSpellInfo(55021)] = 1, -- Silenced - Improved Counterspell - Rank2
		[GetSpellInfo(2139)] = 1, -- Counterspell
		[GetSpellInfo(118)] = 1, -- Polymorph
		[GetSpellInfo(44572)] = 1, -- Deep Freeze
		[GetSpellInfo(45438)] = 1, -- Ice Block	
		[GetSpellInfo(122)] = 1, -- Frost Nova
	
		-- Hunter
		[GetSpellInfo(19503)] = 1, -- Scatter Shot
		[GetSpellInfo(55041)] = 1, -- Freezing Trap Effect
		[GetSpellInfo(2974)] = 1, -- Wing Clip
		[GetSpellInfo(19263)] = 1, -- Deterrence
		[GetSpellInfo(34490)] = 1, -- Silencing Shot
		[GetSpellInfo(19386)] = 1, -- Wyvern Sting
		[GetSpellInfo(19577)] = 1, -- Intimidation
		
		-- Death Knight
		[GetSpellInfo(45524)] = 1, -- Chains of Ice
		[GetSpellInfo(48707)] = 1, -- Anti-Magic Shell
		[GetSpellInfo(47476)] = 1, -- Strangulate
	},
}

local Event = CreateFrame("Frame")
Event.Timer = 0
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Event:SetScript("OnEvent", function(self, event, ...)
    self:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 5 then
			if IsInInstance() then
				SetMapToCurrentZone()
				local AreaID = GetCurrentMapAreaID()
				ZoneList = RaidDebuffList["AnyZone"]
				if RaidDebuffList[AreaID] then
					for key, value in pairs(RaidDebuffList[AreaID]) do
						ZoneList[key] = value
					end
				end
			else
				ZoneList = RaidDebuffList["AnyZone"]
			end		
			self:SetScript("OnUpdate", nil)
			self.Timer = 0
		end
	end)

    if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

local function UpdateRaidDebuff(RaidDebuff, icon, count, duration, expires)
	if RaidDebuff then
		RaidDebuff:Show()
	end
	if RaidDebuff.Icon then
		RaidDebuff.Icon:SetTexture(icon)
	end
	if RaidDebuff.Count then
		RaidDebuff.Count:SetText(count > 1 and count or "")
	end
	if RaidDebuff.Cooldown then
		CooldownFrame_SetTimer(RaidDebuff.Cooldown, expires-duration, duration, 1)
	end
end

local function Update(self, event, unit)
    if self.unit ~= unit then return end
	
	local RaidDebuff = self.RaidDebuff
	local Flag = true
	
    local index = 1
    while true do
		local name, _, icon, count, _, duration, expires = UnitBuff(unit, index)
		if not name then break end
		if ZoneList[name] and ZoneList[name] >= PrePriority then
			UpdateRaidDebuff(RaidDebuff, icon, count, duration, expires)
			PrePriority = ZoneList[name]
			Flag = false			
		end
		index = index + 1
	end
	
	local index = 1
    while true do
		local name, _, icon, count, _, duration, expires = UnitDebuff(unit, index)
		if not name then break end
		if ZoneList[name] and ZoneList[name] >= PrePriority then
			UpdateRaidDebuff(RaidDebuff, icon, count, duration, expires)
			PrePriority = ZoneList[name]
			Flag = false			
		end
		index = index + 1
	end
	
	if Flag then
		PrePriority = 0
		RaidDebuff:Hide()
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
