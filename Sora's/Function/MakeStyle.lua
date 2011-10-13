-- Engines
local S, _, _, DB = unpack(select(2, ...))

function S.MakeShadow(Frame, Size)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeTexShadow(Parent, Anchor, Size)
	local Border = CreateFrame("Frame", nil, Parent)
	Border:SetPoint("TOPLEFT", Anchor, -Size, Size)
	Border:SetPoint("BOTTOMRIGHT", Anchor, Size, -Size)
	Border:SetFrameLevel(1)
	Border:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Border:SetBackdropBorderColor(0, 0, 0, 1)
	return Border
end

function S.MakeFontString(Parent, FontSize)
	local Text = Parent:CreateFontString(nil, "OVERLAY")
	Text:SetFont(DB.Font, FontSize, "THINOUTLINE")
	return Text
end