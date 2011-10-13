-- Engines
local S, _, _, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- BuildMainBar()
local function BuildMainBar()
	local MainBar = CreateFrame("Frame", nil, UIParent)
	MainBar:SetPoint("TOPLEFT", ActionButton1, "LEFT", -10, -3)
	MainBar:SetPoint("BOTTOMRIGHT", ActionButton12, "BOTTOMRIGHT", 10, -7)
	MainBar:SetBackdrop({
		bgFile = DB.bgFile, insets = {left = 4, right = 4, top = 4, bottom = 4},
		edgeFile = DB.GlowTex, edgeSize = 3, 
	})
	MainBar:SetBackdropColor(0, 0, 0, 0.2)
	MainBar:SetBackdropBorderColor(0, 0, 0, 1)
	return MainBar
end

-- BuildExtraBar
local function BuildExtraBar(MainBar)
	if ActionBarDB.ShowExtraBar then
		MainBar.Left = CreateFrame("Frame", nil, MainBar)
		MainBar.Left:SetPoint("TOPLEFT", MainBar, "TOPLEFT", -11, 0)
		MainBar.Left:SetPoint("BOTTOMRIGHT", MainBar, "BOTTOMLEFT", 2, 0)
		MainBar.Left:SetBackdrop({
			edgeFile = DB.GlowTex, edgeSize = 3, 
		})
		MainBar.Left:SetBackdropBorderColor(0, 0, 0, 1)

		MainBar.Left:SetScript("OnMouseDown", function(self)
			if MultiBarLeftButton1:GetAlpha() < 0.1 then
				S.LeftBarFadeIn()
			elseif MultiBarLeftButton1:GetAlpha() > 0.9 then
				S.LeftBarFadeOut()
			end
		end)
		MainBar.Right = CreateFrame("Frame", nil, MainBar)
		MainBar.Right:SetPoint("TOPRIGHT", MainBar, "TOPRIGHT", 11, 0)
		MainBar.Right:SetPoint("BOTTOMLEFT", MainBar, "BOTTOMRIGHT", -2, 0)
		MainBar.Right:SetBackdrop({
			edgeFile = DB.GlowTex, edgeSize = 3, 
		})
		MainBar.Right:SetBackdropBorderColor(0, 0, 0, 1)
		MainBar.Right:SetScript("OnMouseDown", function(self)
			if MultiBarRightButton1:GetAlpha() < 0.1 then
				S.RightBarFadeIn()
			elseif MultiBarRightButton1:GetAlpha() > 0.9 then
				S.RightBarFadeOut()
			end
		end)
	else
		_G["rABS_MultiBarLeft"]:Hide()
		_G["rABS_MultiBarRight"]:Hide()
	end
end

local MainBar = BuildMainBar()
BuildExtraBar(MainBar)