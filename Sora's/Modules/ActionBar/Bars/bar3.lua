-- Engines
local S, _, _, DB = unpack(select(2, ...))
MultiBarBottomRight:SetParent(DB.ActionBar)
MultiBarBottomRight:ClearAllPoints()
MultiBarBottomRight.SetPoint = function() end

for i=1, 12 do
	local Button = _G["MultiBarBottomRightButton"..i]
	Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
	Button:ClearAllPoints()	
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar)
	elseif i <= 3 then
		local Pre = _G["MultiBarBottomRightButton"..i-1]      
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
	elseif i == 4 then
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar, 0, ActionBarDB.ActionBarButtonSize+5)
	elseif i <= 6 then
		local Pre = _G["MultiBarBottomRightButton"..i-1]      
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)	
	elseif i == 7 then
		Button:SetPoint("BOTTOMRIGHT", DB.ActionBar)
	elseif i <= 9 then
		local Pre = _G["MultiBarBottomRightButton"..i-1]      
		Button:SetPoint("RIGHT", Pre, "LEFT", -3, 0)
	elseif i == 10 then
		Button:SetPoint("BOTTOMRIGHT", DB.ActionBar, 0, ActionBarDB.ActionBarButtonSize+5)
	elseif i <= 12 then
		local Pre = _G["MultiBarBottomRightButton"..i-1]      
		Button:SetPoint("RIGHT", Pre, "LEFT", -3, 0)	
	end
end
