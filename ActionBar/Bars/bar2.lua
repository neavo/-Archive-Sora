local bar = CreateFrame("Frame","rABS_MultiBarBottomLeft",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(30*12+3*11)
bar:SetHeight(30)
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", -20, 43)
MultiBarBottomLeft:SetParent(bar)

for i=1, 12 do
	local button = _G["MultiBarBottomLeftButton"..i]
	button:SetSize(30, 30)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar, 0,0)
	else
		local previous = _G["MultiBarBottomLeftButton"..i-1]      
		button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
end
