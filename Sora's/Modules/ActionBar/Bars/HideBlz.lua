
--hide blizzard stuff

MainMenuBar:SetScale(0.00001)
MainMenuBar:EnableMouse(false)
VehicleMenuBar:SetScale(0.00001)
VehicleMenuBar:EnableMouse(false)

local FramesToHide = {
	MainMenuBar, 
	MainMenuBarArtFrame, 
	BonusActionBarFrame, 
	VehicleMenuBar,
	PossessBarFrame,
}  

for _, value in pairs(FramesToHide) do
	if value:GetObjectType() == "Frame" then value:UnregisterAllEvents() end
	if value ~= MainMenuBar then --patch 4.0.6 fix found by tukz
		  value:HookScript("OnShow", function(self) self:Hide() end)
		  value:Hide()
	end
	value:SetAlpha(0)
end

-- code by tukz/evl22
-- fix main bar keybind not working after a talent switch. :X
hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)

