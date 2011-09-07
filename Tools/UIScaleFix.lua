local scaler = CreateFrame("Frame")
scaler:RegisterEvent("VARIABLES_LOADED")
scaler:RegisterEvent("UI_SCALE_CHANGED")
scaler:SetScript("OnEvent", function(self, event)
	if not InCombatLockdown() then
		local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
		if scale < .64 then
			UIParent:SetScale(scale)
		else
			SetCVar("uiScale", scale)
		end
	else
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end)