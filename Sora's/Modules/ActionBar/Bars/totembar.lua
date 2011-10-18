-- Engines
local _, _, _, DB = unpack(select(2, ...))

if select(2, UnitClass("player"))== "SHAMAN" then
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(DB.ActionBar)
		hooksecurefunc("MultiCastActionButton_Update",function(MultiCastActionButton)
			if not InCombatLockdown() then
				MultiCastActionButton:SetAllPoints(MultiCastActionButton.slotButton)
			end
		end)
 
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
		MultiCastRecallSpellButton.SetPoint = function() end
	end
end