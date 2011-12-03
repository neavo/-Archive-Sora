local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")	
	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)	
	ActionButton_HideGrid = function() end
	for i = 1, 12 do
		local button = _G[format("ActionButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("BonusActionButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarBottomRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarBottomLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
	end
end)