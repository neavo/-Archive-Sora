local _, ns = ...
local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

if not ORD then return end

ORD.ShowDispelableDebuff = true
ORD.FilterDispellableDebuff = true
ORD.MatchBySpellName = false -- false: matching by spellID
ORD.SHAMAN_CAN_DECURSE = true

local debuffFilter = {
-- "PVP"
    -- Priest
	6346,          -- Fear Ward
	605,           -- Mind Control
	34914,         -- Vampiric Touch	
    2944,          -- Devouring Plague
    589,           -- Shadow Word: Pain
    8122,          -- Psychic Scream
    64044,         -- Psychic Horror	
    69910,         -- Pain Suppression
    15487,         -- Silence
    15473,         -- Shadowform	
    47585,         -- Dispersion	
    17,            -- Power Word: Shield
    139,           -- Renew
    33076,         -- Prayer of Mending
    88625,         -- Holy Word: Chastise
	6788,          -- Weakened Soul
	
    -- Paladin
    853,           -- Hammer of Justice
	642,           -- Divine Shield
    10278,         -- Hand of Protection
    1044,          -- Hand of Freedom
    6940,          -- Hand of Sacrifice	
    20066,         -- Repentance
    53563,         -- Beacon of Light
	
    -- Rogue
	31224,         -- Cloak of Shadows
    5277,          -- Evasion
    43235,         -- Wound Poison
    2094,          -- Blind
    3776,          -- Crippling Poison
    6770,          -- Sap
    408,           -- Kidney Shot
    1776,          -- Gouge	
		
    -- Warrior
    12294,         -- Mortal Strike
    1715,          -- Hamstring
    871,           -- Shield Wall	
    18499,         -- Berserker Rage
	
    -- Druid
    33786,         -- Cyclone
    339,           -- Entangling Roots
    29166,         -- Innervate
    2637,          -- Hibernate
    774,           -- Rejuvenation
    8936,          -- Regrowth
    33763,         -- Lifebloom
	
    -- Warlock
	5782,          -- Fear
    5484,          -- Howl of Terror
    6358,          -- Seduction
    30108,         -- Unstable Affliction		
    1714,          -- Curse of Tongues
    18223,         -- Curse of Exhaustion
    6789,          -- Death Coil
    30283,         -- Shadowfury
	
    -- Shaman
    51514,         -- Hex
    974,           -- Earth Shield
    61295,         -- Riptide
	
    -- Mage
    18469,         -- Silenced - Improved Counterspell - Rank1
    55021,         -- Silenced - Improved Counterspell - Rank2
    2139,          -- Counterspell
    118,           -- Polymorph
    61305,         -- Polymorph Black Cat
    28272,         -- Polymorph Pig
    61721,         -- Polymorph Rabbit
    61780,         -- Polymorph Turkey
    28271,         -- Polymorph Turtle
    44572,         -- Deep Freeze
    45438,         -- Ice Block	
    122,           -- Frost Nova
	80353,         -- Time Warp
	
	-- Hunter
    82928,         -- Aimed Shot
    19503,         -- Scatter Shot
    55041,         -- Freezing Trap Effect
    2974,          -- Wing Clip
    19263,         -- Deterrence
    34692,         -- The Beast Within
    34490,         -- Silencing Shot
    19386,         -- Wyvern Sting
    19577,         -- Intimidation
	
	-- Death Knight
    45524,         -- Chains of Ice
    48707,         -- Anti-Magic Shell
    47476,         -- Strangulate
	
-- "Vault of Archavon"
	--Koralon
	67332,66684,--Flaming Cinder (10, 25)

	--Toravon the Ice Watcher
	72004,72098,72120,72121,--Frostbite

	--Toravon the Ice Watcher
	72004,72098,72120,72121,--Frostbite

-- "Naxxramas"
	--Trash
	55314,--Strangulate

	--Anub'Rekhan
	28786, 54022,--Locust Swarm (N, H)

	--Grand Widow Faerlina
	28796, 54098,--Poison Bolt Volley (N, H)
	28794, 54099,--Rain of Fire (N, H)

	--Maexxna
	28622,--Web Wrap (NH)
	54121, 28776,--Necrotic Poison (N, H)

	--Noth the Plaguebringer
	29213, 54835,--Curse of the Plaguebringer (N, H)
	29214, 54836,--Wrath of the Plaguebringer (N, H)
	29212,--Cripple (NH)

	--Heigan the Unclean
	29998, 55011,--Decrepit Fever (N, H)
	29310,--Spell Disruption (NH)

	--Grobbulus
	28169,--Mutating Injection (NH)

	--Gluth
	54378,--Mortal Wound (NH)
	29306,--Infected Wound (NH)

	--Thaddius
	28084, 28085,--Negative Charge (N, H)
	28059, 28062,--Positive Charge (N, H)

	--Instructor Razuvious
	55550,--Jagged Knife (NH)

	--Sapphiron
	28522,--Icebolt (NH)
	28542, 55665,--Life Drain (N, H)

	--Kel'Thuzad
	28410,--Chains of Kel'Thuzad (H)
	27819,--Detonate Mana (NH)
	27808,--Frost Blast (NH)

-- "The Eye of Eternity"
	--Malygos
	56272, 60072,--Arcane Breath (N, H)
	57407, 60936,--Surge of Power (N, H)

-- "The Obsidian Sanctum"
	--Trash
	39647,--Curse of Mending
	58936,--Rain of Fire

	--Sartharion
	60708,--Fade Armor (N, H)
	57491,--Flame Tsunami (N, H)

-- "Ulduar"
	--Trash
	62310, 62928,--Impale (N, H)
	63612, 63673,--Lightning Brand (N, H)
	63615,--Ravage Armor (NH)
	62283, 62438,--Iron Roots (N, H)
	63169, 63549,--Petrify Joints (N, H)

	--Razorscale
	64771,--Fuse Armor (NH)

	--Ignis the Furnace Master
	62548, 63476,--Scorch (N, H)
	62680, 63472,--Flame Jet (N, H)
	62717, 63477,--Slag Pot (N, H)

	--XT-002
	63024, 64234,--Gravity Bomb (N, H)
	63018, 65121,--Light Bomb (N, H)

	--The Assembly of Iron
	61888, 64637,--Overwhelming Power (N, H)
	62269, 63490,--Rune of Death (N, H)
	61903, 63493,--Fusion Punch (N, H)
	61912, 63494,--Static Disruption(N, H)

	--Kologarn
	64290, 64292,--Stone Grip (N, H)
	63355, 64002,--Crunch Armor (N, H)
	62055,--Brittle Skin (NH)

	--Hodir
	62469,--Freeze (NH)
	61969, 61990,--Flash Freeze (N, H)
	62188,--Biting Cold (NH)

	--Thorim
	62042,--Stormhammer (NH)
	62130,--Unbalancing Strike (NH)
	62526,--Rune Detonation (NH)
	62470,--Deafening Thunder (NH)
	62331, 62418,--Impale (N, H)

	--Freya
	62532,--Conservator's Grip (NH)
	62589, 63571,--Nature's Fury (N, H)
	62861, 62930,--Iron Roots (N, H)

	--Mimiron
	63666,--Napalm Shell (N)
	65026,--Napalm Shell (H)
	62997,--Plasma Blast (N)
	64529,--Plasma Blast (H)
	64668,--Magnetic Field (NH)

	--General Vezax
	63276,--Mark of the Faceless (NH)
	63322,--Saronite Vapors (NH)

	--Yogg-Saron
	63147,--Sara's Anger(NH)
	63134,--Sara's Blessing(NH)
	63138,--Sara's Fervor(NH)
	63830,--Malady of the Mind (H)
	63802,--Brain Link(H)
	63042,--Dominate Mind (H)
	64152,--Draining Poison (H)
	64153,--Black Plague (H)
	64125, 64126,--Squeeze (N, H)
	64156,--Apathy (H)
	64157,--Curse of Doom (H)
	--63050,--Sanity(NH)

	--Algalon
	64412,--Phase Punch

-- "Trial of the Crusader"
	--Gormok the Impaler
	66331, 67477, 67478, 67479,--Impale(10, 25, 10H, 25H)
	66406,--Snobolled!

	--Acidmaw --Dreadscale
	66819, 67609, 67610, 67611,--Acidic Spew (10, 25, 10H, 25H)
	66821, 67635, 67636, 67637,--Molten Spew (10, 25, 10H, 25H)
	66823, 67618, 67619, 67620,--Paralytic Toxin (10, 25, 10H, 25H)
	66869,--Burning Bile

	--Icehowl
	66770, 67654, 67655, 67656,--Ferocious Butt(10, 25, 10H, 25H)
	66689, 67650, 67651, 67652,--Arctic Breathe(10, 25, 10H, 25H)
	66683,--Massive Crash

	--Lord Jaraxxus
	66532, 66963, 66964, 66965,--Fel Fireball (10, 25, 10H, 25H)
	66237, 67049, 67050, 67051,--Incinerate Flesh (10, 25, 10H, 25H)
	66242, 67059, 67060, 67061,--Burning Inferno (10, 25, 10H, 25H)
	66197, 68123, 68124, 68125,--Legion Flame (10, 25, 10H, 25H)
	66199, 68126, 68127, 68128,--Legion Flame (Patch?: 10, 25, 10H, 25H)
	66877, 67070, 67071, 67072,--Legion Flame (Patch Icon?: 10, 25, 10H, 25H)
	66283,--Spinning Pain Spike
	66209,--Touch of Jaraxxus(H)
	66211,--Curse of the Nether(H)
	66333, 66334, 66335, 66336, 68156,--Mistress' Kiss (10H, 25H)

	--Faction Champions
	65812, 68154, 68155, 68156,--Unstable Affliction (10, 25, 10H, 25H)
	65801,--Polymorph
	65543,--Psychic Scream
	66054,--Hex
	65809,--Fear

	--The Twin Val'kyr
	67176,--Dark Essence
	67223,--Light Essence
	67282, 67283,--Dark Touch
	67297, 67298,--Light Touch
	67309, 67310, 67311, 67312,--Twin Spike (10, 25, 10H, 25H)

	--Anub'arak
	67574,--Pursued by Anub'arak
	66013, 67700, 68509, 68510,--Penetrating Cold (10, 25, 10H, 25H)
	67847, 67721,--Expose Weakness
	66012,--Freezing Slash
	67863,--Acid-Drenched Mandibles(25H)

-- "Icecrown Citadel"
	--Lord Marrowgar
	70823,--Coldflame
	69065,--Impaled
	70835,--Bone Storm

	--Lady Deathwhisper
	72109,--Death and Decay
	71289,--Dominate Mind
	71204,--Touch of Insignificance
	67934,--Frost Fever
	71237,--Curse of Torpor
	72491,71951,72490,72491,72492,--Necrotic Strike

	--Gunship Battle
	69651,--Wounding Strike

	--Deathbringer Saurfang
	72293,--Mark of the Fallen Champion
	72442,--Boiling Blood
	72449,--Rune of Blood
	72769,--Scent of Blood (heroic)

	--Festergut
	69290,71222,73033,73034,--Blighted Spore
	69248,72274,--Vile Gas?
	71218,72272,72273,73020,73019,69240,--Vile Gas?
	72219,72551,72552,72553,--Gastric Bloat
	69278,69279,71221, -- Gas Spore

	--Rotface
	69674,71224,73022,73023,--Mutated Infection
	69508,--Slime Spray
	30494,69774,69776,69778,71208,--Sticky Ooze

	--Professor Putricide
	70672,72455,72832,72833,--Gaseous Bloat
	72549,--Malleable Goo
	72454,--Mutated Plague
	70341,--Slime Puddle (Spray)
	70342,70346,72869,72868,--Slime Puddle (Pool)
	70911,72854,72855,72856,--Unbound Plague
	69774,72836,72837,72838,--Volatile Ooze Adhesive

	--Blood Prince Council
	71807,72796,72797,72798,--Glittering Sparks
	71911,71822,--Shadow Resonance

	--Blood-Queen Lana'thel
	71623,71624,71625,71626,72264,72265,72266,72267,--Delirious Slash
	70949,--Essence of the Blood Queen (hand icon)
	70867,70871,70872,70879,70950,71473,71525,71530,71531,71532,71533,--Essence of the Blood Queen (bite icon)
	72151,72648,72650,72649,--Frenzied Bloodthirst (bite icon)
	71474,70877,--Frenzied Bloodthirst (red bite icon)
	71340,71341,--Pact of the Darkfallen
	72985,--Swarming Shadows (pink icon)
	71267,71268,72635,72636,72637,--Swarming Shadows (black purple icon)
	71264,71265,71266,71277,72638,72639,72640,72890,--Swarming Shadows (swirl icon)
	70923,70924,73015,--Uncontrollable Frenzy

	--Valithria Dreamwalker
	70873,--Emerald Vigor
	70744,71733,72017,72018,--Acid Burst
	70751,71738,72021,72022,--Corrosion
	70633,71283,72025,72026,--Gut Spray

	--Sindragosa
	70106,--Chilled to the Bone
	69766,--Instability
	69762,--Unchained Magic
	70126,--Frost Beacon
	71665,--Asphyxiation
	70127,72528,72529,72530,--Mystic Buffet

	--Lich King
	70541,73779,73780,73781,--Infest
	70337,70338,73785,73786,73787,73912,73913,73914,--Necrotic Plague
	72133,73788,73789,73790,--Pain and Suffering
	68981,--Remorseless Winter
	69242,--Soul Shriek

	--Trash
	71089,--Bubbling Pus
	69483,--Dark Reckoning
	71163,--Devour Humanoid
	71127,--Mortal Wound
	70435,71154,--Rend Flesh
	
-- "The Ruby Sanctum"
	--Baltharus the Warborn
	74502,--Enervating Brand

	--General Zarithrian
	74367,--Cleave Armor

	--Saviana Ragefire
	74452,--Conflagration

	--Halion
	74562,--Fiery Combustion
	74567,--Mark of Combustion
	
-- "巴拉丁监狱"
	
	-- 阿尔加洛斯
	88954, -- 黑暗噬体
	88942, -- 流星猛击
	
-- "黑翼血环"

	-- 熔喉
	78199, -- 灼烤护甲
	88287, -- 大力撞击
	89773, -- 裂伤
	78941, -- 寄生感染

	-- 全能防御系统
	79888, -- 闪电导体
	80161, -- 化学云雾
	80011, -- 浸透毒液
	79505, -- 火焰喷射器
	80094, -- 注视
	79501, -- 获取目标
	92053, -- 暗影导体(英雄)
	92048, -- 暗影灌注(英雄)
	92023, -- 暗影包围(英雄)

	--马洛拉克
	78034, -- 撕裂 10-normal
	78225, -- 酸性新星 10-normal
	77615, -- 衰弱软泥 10-normal/25-normal
	77786, -- 消蚀烈焰 10-normal
	78617, -- 注视
	77760, -- 酷寒
	77699, -- 快速冻结 10-normal
	92987, -- 黑暗污泥(英雄)
	92982, -- 黑暗吞噬(英雄)

	-- 艾卓曼德斯
	78092, -- 追踪
	77982, -- 灼热烈焰
	78023, -- 咆哮烈焰
	78897, -- 声音太大了！
	92685, -- 纠缠！(英雄)

	-- Chimaeron
	89084, -- Low Health
	82890, -- Mortality
	82935, -- Caustic Slime
	82881, -- Break(H)
	91307, -- Mocking Shadows(H)

	-- Nefarian
	81118, --Magma 10-normal
	77827, --Tail Lash 10-normal
	79339, --Explosive Cinders(H)
	79318, --Dominion(H)

-- "The Bastion of Twilight"

	-- Halfus Wyrmbreaker
	83710, --Furious Roar
	83908, --Malevolent Strikes
	83603, --Stone Touch

	-- Valiona & Theralion
	86788, --Blackout 10-normal
	86622, --Engulfing Magic 10-normal
	86202, --Twilight Shift 10-normal
	86014, --Twilight Meteorite
	92886, --Twilight Zone

	-- Ascendant Council
	82762, --Waterlogged
	83099, --Lightning Rod
	82285, --Elemental Stasis
	82660, --Burning Blood
	82665, --Heart of Ice
	82772, --Frozen
	84948, --Gravity Crush
	83500, --Swirling Winds
	83581, --Grounded
	82285, --Elemental Stasis
	92307, --Frost Beacon(H)
	92467, --Static Overload(H)
	92538, --Gravity Core(H)

	-- Cho'gall
	81701, --Corrupted Blood
	81836, --Corruption: Accelerated
	82125, --Corruption: Malformation
	82170, --Corruption: Absolute
	82523, --Gall's Blast
	82518, --Cho's Blast
	82411, --Debilitating Beam
	
	-- Sinestra
	89299, --Twilight Spit

-- "Throne of the Four Winds"

	-- Conclave of Wind
	84645, --Wind Chill
	86111, --Ice Patch
	86082, --Permafrost
	86481, --Hurricane
	86282, --Toxic Spores
	85573, --Deafening Winds
	85576, --Withering Winds
	93057, --Slicing Gale(H)

	-- Al'Akir
	88301, --Acid Rain
	87873, --Static Shock
	88427, --Electrocute
	89666, --Lightning Rod
	89668, --Lightning Rod
	87856, --Squall Line

-- Firelands
	--Beth'tilac(蜘蛛)
	97202, -- Fiery Web Spin(熾炎蛛網眩暈)
	49026, -- Fixate(凝視)
	99506, -- The Widow's Kiss(寡婦之吻)
	
	--Lord Rhyolith(左右腳)
	98492, -- Eruption(爆發)
	
	--Alysrazor(火鳥)
	101729, -- Blazing Claw(熾炎爪擊)
	100094, -- Fieroblast(猛火衝擊)
	99389, -- Imprinted(印刻)
	
	--Shannox(獵人)
	100415, -- Rage(怒火)
	99947, -- Face Rage(怒氣爆發)
	
	--Baleroc, the Gatekeeper(守門人)
	99403, -- Tormented(受到折磨)
	99256, -- Torment(折磨)
	
	--Majordomo Staghelm(鹿盔)
	98450, -- Searing Seeds(灼熱種子)
	98443, -- Fiery Cyclone(熾炎颶風)
	
	--Ragnaros(大螺絲)
	100460, --Blazing Heat(熾熱高溫)
	99399, -- Burning Wound(燃燒傷口)	
}

ORD:RegisterDebuffs(debuffFilter)