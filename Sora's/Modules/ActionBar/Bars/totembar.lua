-- Engines
local _, _, _, DB = unpack(select(2, ...))

if select(2, UnitClass("player"))== "SHAMAN" then
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(DB.ActionBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame.ClearAllPoints = function() end
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
	end
end