local S, _, _, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Announce")
function Module:OnEnable()
local open = AnnounceDB.Open
local spells = AnnounceDB.List
local spellsall = AnnounceDB.All
if open ~= true then return end
local announce = CreateFrame("Frame")
announce:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
announce:SetScript("OnEvent", function(self, _, ...)
local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellID = ...
local inInstance, instanceType = IsInInstance()
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
end