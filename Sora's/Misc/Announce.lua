local S, _, _, DB = unpack(select(2, ...))
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
	local spellsall = false  --false僅僅只通報自己释放的true全部包括隊友的
	if not (inInstance and (instanceType == "raid" or instanceType == "party")) then return end

	if event == "SPELL_CAST_SUCCESS" or event == "SPELL_RESURRECT" then
		if spellsall == true then
			if not (destName and sourceName) then return end

			for i, spells in pairs(spells) do
				if spellID == spells then
					if GetRealNumRaidMembers() > 0 then
			SendChatMessage(sourceName.." 对 "..destName.." 释放"..GetSpellLink(spellID), "RAID")
					elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
						SendChatMessage(sourceName.." 对 "..destName.." 释放"..GetSpellLink(spellID), "PARTY")
					else
						SendChatMessage(sourceName.." 对 "..destName.." 释放"..GetSpellLink(spellID), "SAY")
					end
				end
			end
		else
			if not (sourceGUID == UnitGUID("player") and destName) then return end

			for i, spells in pairs(spells) do
				if spellID == spells then
					if GetRealNumRaidMembers() > 0 then
						SendChatMessage("已对 "..destName.." 释放"..GetSpellLink(spellID), "RAID")
					elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
						SendChatMessage("已对 "..destName.." 释放"..GetSpellLink(spellID), "PARTY")
					else
						SendChatMessage("已对 "..destName.." 释放"..GetSpellLink(spellID), "SAY")
					end
				end
			end
		end
	end
end)