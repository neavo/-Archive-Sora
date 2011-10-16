local Event = CreateFrame("Frame")
Event:RegisterAllEvents()
Event.Count = 0
Event:SetScript("OnEvent", function(self, event)
	if UnitAffectingCombat("player") then return end
	Event.Count = Event.Count + 1
	if Event.Count > 6000 then
		collectgarbage("collect")
		Event.Count = 0
	end
end)