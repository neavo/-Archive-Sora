-- Engines
local S, _, _, DB = unpack(select(2, ...))
MultiBarBottomLeft:SetParent(DB.ActionBar)
MultiBarBottomLeft:ClearAllPoints()
MultiBarBottomLeft.SetPoint = function() end

for i=1, 12 do
	local Button = _G["MultiBarBottomLeftButton"..i]
	Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "BOTTOMLEFT", ActionBarDB.ActionBarButtonSize*3+3*3, ActionBarDB.ActionBarButtonSize+5)
	else
		local Pre = _G["MultiBarBottomLeftButton"..i-1]
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
	end
end


