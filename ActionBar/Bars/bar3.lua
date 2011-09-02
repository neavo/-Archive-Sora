local bar = CreateFrame("Frame","rABS_MultiBarBottomRight",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(28*12+3*11)
bar:SetHeight(28)
bar:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 3)
MultiBarBottomRight:SetParent(bar)

for i=1, 12 do
	local button = _G["MultiBarBottomRightButton"..i]
	button:SetSize(28, 28)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar, 0,0)
	else
		local previous = _G["MultiBarBottomRightButton"..i-1]      
		button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
end
