local Count = 0
local Event = CreateFrame("Frame")
Event:RegisterAllEvents()
Event:SetScript("OnEvent", function(self, event, ...)
	if not UnitAffectingCombat("player") then
		Count = Count + 1
		if Count > 6000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
			collectgarbage("collect")
			Count = 0
		end
	end
end)