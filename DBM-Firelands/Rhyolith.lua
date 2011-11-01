local mod	= DBM:NewMod(193, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6490 $"):sub(12, -3))
mod:SetCreatureID(52558)--or does 53772 die instead?didn't actually varify this fires right unit_died event yet so we'll see tonight
mod:SetModelID(38414)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\Creature\\RHYOLITH\\VO_FL_RHYOLITH_AGGRO.wav", "Sound\\Creature\\RHYOLITH\\VO_FL_RHYOLITH_KILL_02.wav")
--Long: Blah blah blah Nuisances, Nuisances :)
--Short: So Soft

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_SUMMON",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_HEALTH"
)

local warnHeatedVolcano		= mod:NewSpellAnnounce(98493, 3)
local warnFlameStomp		= mod:NewSpellAnnounce(97282, 3)--According to journal only hits players within 20 yards of him, so melee by default?
local warnMoltenArmor		= mod:NewStackAnnounce(98255, 4, nil, false)	-- Would this be nice if we could show this in the infoFrame? (changed defaults to tanks/healers, if you aren't either it doesn't concern you unless you find shit to stand in)
local warnDrinkMagma		= mod:NewSpellAnnounce(98034, 4)	-- if you "kite" him to close to magma
local warnFragments			= mod:NewSpellAnnounce(98136, 2)
local warnShard				= mod:NewCountAnnounce(98552, 3)
local warnMagmaFlow			= mod:NewSpellAnnounce(97225, 4)
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 2)
local warnPhase2			= mod:NewPhaseAnnounce(2, 3)
local warnObsidian    = mod:NewStackAnnounce(98632, 4)

local specWarnMagmaFlow		= mod:NewSpecialWarningSpell(97225, nil, nil, nil, true)
local specWarnFlameStomp	= mod:NewSpecialWarningSpell(97282)

local timerSparkCD			= mod:NewNextCountTimer(22.5, 98552)
local timerFragmentCD		= mod:NewNextTimer(22.5, 98136)
local timerHeatedVolcano	= mod:NewNextTimer(25.5, 98493)
local timerFlameStomp		= mod:NewNextTimer(30.5, 97282)
local timerSuperheated		= mod:NewNextTimer(10, 101305)		--Add the 10 second party in later at some point if i remember to actually log it better
local timerMagmaFlowActive	= mod:NewBuffActiveTimer(10, 97225)	--10 second buff volcano has, after which the magma line explodes.

local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

local spamAdds = 0
local phase = 1
local spamMoltenArmor = 0
local sparkCount = 0
local fragmentCount = 0
local spamObsidian = 0
local prewarnedPhase2 = false
local spamUnleash = 0
local addcount = 0

function mod:OnCombatStart(delay)
	timerFragmentCD:Start(-delay)
	sndWOP:Schedule(20, "Interface\\AddOns\\DBM-Core\\extrasounds\\fragsoon.mp3")
	timerHeatedVolcano:Start(-delay)
	timerFlameStomp:Start(16-delay)--Actually found an old log, maybe this is right.
	if self:IsDifficulty("heroic10", "heroic25") then
		timerSuperheated:Start(300-delay)--5 min on heroic
	else
		timerSuperheated:Start(360-delay)--6 min on normal
	end
	spamAdds = 0
	spamMoltenArmor = 0
	phase = 1
	sparkCount = 0
	fragmentCount = 1--Fight starts out 1 cycle in so only 1 more spawns before pattern reset.
	spamObsidian = 0
	spamUnleash = 0
	addcount = 0
	prewarnedPhase2 = false
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(98255, 101157, 101158, 101159) and self:GetCIDFromGUID(args.destGUID) == 52558 and args.amount >= 1 and GetTime() - spamMoltenArmor > 5 then
		warnMoltenArmor:Show(args.destName, args.amount)
		spamMoltenArmor = GetTime()
	elseif args:IsSpellID(98632) and self:GetCIDFromGUID(args.destGUID) == 52558 and GetTime() - spamObsidian > 5 then
		warnObsidian:Show(args.destName, args.amount)
		spamObsidian = GetTime()
	end
end

mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_APPLIED_DOSE

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(98034) then
		warnDrinkMagma:Show()
	elseif args:IsSpellID(97282, 100411, 100968, 100969) then
		warnFlameStomp:Show()
		specWarnFlameStomp:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..GetLocale().."\\firestomp.mp3")
		if phase == 1 then
			timerFlameStomp:Start()
		else--13sec cd in phase 2
			timerFlameStomp:Start(13)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(98493) then
		warnHeatedVolcano:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\volcano.mp3")
		if self:IsDifficulty("heroic10", "heroic25") then
			timerHeatedVolcano:Start()
		else
			timerHeatedVolcano:Start(40)--40 seconds on normal post Aug 16th 2011 hotfix.
		end
	elseif args:IsSpellID(97225) then
		warnMagmaFlow:Show()
		specWarnMagmaFlow:Show()
		timerMagmaFlowActive:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\fireline.mp3")
		if phase == 1 then
			sndWOP:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(9, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(100974) and args:IsPlayer() and GetTime() - spamUnleash >= 3 then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")
		spamUnleash = GetTime()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(98136, 100392) and GetTime() - spamAdds > 5 then
		fragmentCount = fragmentCount + 1
		warnFragments:Show()
		if fragmentCount < 2 then
			timerFragmentCD:Start()
			sndWOP:Schedule(20, "Interface\\AddOns\\DBM-Core\\extrasounds\\fragsoon.mp3")
		else--Spark is next start other CD bar and reset count.
			fragmentCount = 0
			timerSparkCD:Start(22.5, sparkCount+1)
			sndWOP:Schedule(20, "Interface\\AddOns\\DBM-Core\\extrasounds\\sparksoon.mp3")
		end		
		spamAdds = GetTime()
		addcount = addcount + 1
		if self:IsDifficulty("heroic10", "heroic25") and addcount == 10 then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")
		end
	elseif args:IsSpellID(98552) then
		sparkCount = sparkCount + 1
		warnShard:Show(sparkCount)
		timerFragmentCD:Start()
		sndWOP:Schedule(20, "Interface\\AddOns\\DBM-Core\\extrasounds\\fragsoon.mp3")
		addcount = addcount + 1
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.yellPhase2 or msg:find(L.yellPhase2) then
		warnPhase2:Show()
		phase = 2
		timerSparkCD:Cancel()
		timerFragmentCD:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\fragsoon.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\sparksoon.mp3")
		timerHeatedVolcano:Cancel()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 52558 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 35 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h < 30 and h > 25 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end