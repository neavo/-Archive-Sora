local S, C, L, DB = unpack(select(2, ...))

for _, VALUE in pairs({"MirrorTimer1","MirrorTimer2","MirrorTimer3"}) do   
	for _, value in pairs({_G[VALUE]:GetRegions()}) do
		if value.GetTexture and value:GetTexture() == "SolidTexture" then
			value:Hide()
		end
	end
	
	local Bar = _G[VALUE]
	local Text = _G[VALUE.."Text"]
	local StatusBar = _G[VALUE.."StatusBar"]
	_G[VALUE.."Border"]:Hide()
	
	Bar:SetHeight(18)
	Bar:SetWidth(250)
	Text:SetFont(DB.Font, 12, "THINOUTLINE")
	Text:ClearAllPoints()
	Text:SetPoint("CENTER", Bar, 0, 0)
	StatusBar:SetAllPoints(Bar)
	
	local BG = Bar:CreateTexture(VALUE.."Background", "BACKGROUND", Bar)
	BG:SetTexture(DB.Statusbar)
	BG:SetAllPoints(VALUE)
	BG:SetVertexColor(0.1, 0.1, 0.1, 0.75)
	
	local Border = CreateFrame("Frame", nil, Bar)
	Border:SetFrameLevel(0)
	Border:SetPoint("TOPLEFT", -1, 1)
	Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Border:SetBackdrop({
		edgeFile = DB.Solid, edgeSize = 1, 
	})
	Border:SetBackdropBorderColor(0, 0, 0, 0.8)
end