-- Engines
local S, _, _, DB = unpack(select(2, ...))
MultiBarBottomLeft:SetParent(DB.ActionBar)

for i=1, 12 do
	local Button = _G["MultiBarBottomLeftButton"..i]
	Button:SetSize(26, 26)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "BOTTOMLEFT", 26*3+3*3, 26+5)
	else
		local Pre = _G["MultiBarBottomLeftButton"..i-1]
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
	end
end
