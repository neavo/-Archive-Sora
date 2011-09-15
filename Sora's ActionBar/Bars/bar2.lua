local bar = CreateFrame("Frame","rABS_MultiBarBottomLeft",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(26*12+3*11)
bar:SetHeight(26)
bar:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 5)
MultiBarBottomLeft:SetParent(bar)

for i=1, 12 do
	local button = _G["MultiBarBottomLeftButton"..i]
	button:SetSize(26, 26)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar, 0,0)
	else
		local previous = _G["MultiBarBottomLeftButton"..i-1]      
		button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
end
