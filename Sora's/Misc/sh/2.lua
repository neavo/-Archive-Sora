local Text = UIParent:CreateFontString(nil, "OVERLAY")
Text:SetPoint("CENTER")
Text:SetFont("Fonts\\", 20, "THINOUTLINE")
Text:SetText("斩杀了!")
Text:Hide()

local Event = CreateFrame("Frame")
Event:RegisterEvent("UNIT_HEALTH")
Event:SetScript("OnEvent", function(self, event, unitID, ...)
	if event == "UNIT_HEALTH" and unitID == "target" then
		if not UnitCanAttack("player", unitID) or UnitIsDead(unitID) then return end
		if UnitHealth("target")/UnitHealthMax("target") < 1 then
			Text:Show()
		else
			Text:Hide()
		end
	end
end)
