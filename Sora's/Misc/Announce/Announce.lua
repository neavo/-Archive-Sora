﻿local S, _, _, DB = unpack(select(2, ...))
local announce = CreateFrame("Frame")
announce:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
announce:SetScript("OnEvent", function(self, _, ...)
local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellID = ...
local inInstance, instanceType = IsInInstance()
local spells = {
	34477,	-- 误导
	19801,	-- 寧神射擊
	57934,	-- 偷天換日
	20484,	-- 復生
	633,	-- 聖療術
	10060,  --能量灌注
	33206,   -- 痛苦镇压
	47788,   -- 守護聖靈
	1022, --保護聖禦
	54646, --魔法凝聚
	
}
local spellsall = false  --false僅僅只通報自己釋放的true全部包括隊友的
	if not (inInstance and (instanceType == "raid" or instanceType == "party")) then return end

	if event == "SPELL_CAST_SUCCESS" or event == "SPELL_RESURRECT" then
		if spellsall == true then
			if not (destName and sourceName) then return end

			for i, spells in pairs(spells) do
				if spellID == spells then
					if GetRealNumRaidMembers() > 0 then
			SendChatMessage(sourceName.." 對 "..destName.." 釋放"..GetSpellLink(spellID), "RAID")
					elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
						SendChatMessage(sourceName.." 對 "..destName.." 釋放"..GetSpellLink(spellID), "PARTY")
					else
						SendChatMessage(sourceName.." 對 "..destName.." 釋放"..GetSpellLink(spellID), "SAY")
					end
				end
			end
		else
			if not (sourceGUID == UnitGUID("player") and destName) then return end

			for i, spells in pairs(spells) do
				if spellID == spells then
					if GetRealNumRaidMembers() > 0 then
						SendChatMessage("已對 "..destName.." 釋放"..GetSpellLink(spellID), "RAID")
					elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
						SendChatMessage("已對 "..destName.." 釋放"..GetSpellLink(spellID), "PARTY")
					else
						SendChatMessage("已對 "..destName.." 釋放"..GetSpellLink(spellID), "SAY")
					end
				end
			end
		end
	end
end)

--[[local Event = CreateFrame("Frame")
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
				print("The MapAreaID is "...AreaID)
			end		
			self:SetScript("OnUpdate", nil)
			self.Timer = 0
		end
	end)

    if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)--]]