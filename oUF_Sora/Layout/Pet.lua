----------------
--  命名空间  --
----------------

local _, SR = ...
local oUF = SR.oUF or oUF
local cfg = SR.cfg
local cast = SR.cast

local function MakeShadow(Frame)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", 5, 0)
	Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex, edgeSize = 5, 
	})
	Shadow:SetBackdropBorderColor(0,0,0,1)
	return Shadow
end

local function MakeTexBorder()
	local Border = CreateFrame("Frame")
	Border:SetFrameLevel(1)
	Border:SetBackdrop({ 
		edgeFile = cfg.Solid, edgeSize = 1, 
	})
	Border:SetBackdropBorderColor(0,0,0,1)
	return Border
end

local function MakeBorder(Frame)
	local Border = CreateFrame("Frame", nil, Frame)
	Border:SetFrameLevel(1)
	Border:SetPoint("TOPLEFT", -1, 1)
	Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Border:SetBackdrop({ 
		edgeFile = cfg.Solid, edgeSize = 1, 
	})
	Border:SetBackdropBorderColor(0,0,0,1)
	return Border
end

local function MakeFontString(parent, fontsize)
	local tempText = parent:CreateFontString(nil, "OVERLAY")
	tempText:SetFont(cfg.Font, fontsize, "THINOUTLINE")
	return tempText
end

local function BuildMenu(self)
	local cunit = self.unit:gsub("^%l", string.upper)

	if cunit == "Vehicle" then cunit = "Pet" end

	if _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(cfg.Statusbar)
	Bar:SetHeight(14)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP", 0, 0)
	Bar.Shadow = MakeShadow(Bar)
	Bar.Border = MakeBorder(Bar)
	Bar.BG = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BG:SetTexture(cfg.Statusbar)
	Bar.BG:SetAllPoints()
	Bar.BG:SetVertexColor(0.1, 0.1, 0.1)
	Bar.BG.multiplier = 0.2
	
	Bar.frequentUpdates = true
	Bar.colorSmooth = true
	Bar.colorClass = true
	Bar.colorReaction = true
	Bar.Smooth = true
	Bar.colorTapping = true

	self.Health = Bar
end

local function BuildTags(self)
	local Name = MakeFontString(self.Health, 9)
	Name:SetPoint("LEFT", 0, 5)
	self:Tag(Name, "[name]")
	local HPTag = MakeFontString(self.Health, 7)
	HPTag:SetPoint("RIGHT", self.Health, 7, -5)
	self:Tag(HPTag, "[Sora:hp]")
end

local function BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildPetFrame(self, ...)
	-- RegisterForClicks
	self.menu = BuildMenu
	self:RegisterForClicks("AnyDown")
	
	-- Set Size and Scale
	self:SetScale(cfg.Scale)
	self:SetSize(60, 14)
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildTags
	BuildTags(self)

	-- BuildRaidMark
	BuildRaidIcon(self)

end

if cfg.ShowPet then
	oUF:RegisterStyle("SoraPet", BuildPetFrame)
	oUF:SetActiveStyle("SoraPet")
	SR.PetFrame = oUF:Spawn("pet")
	SR.PetFrame:SetPoint("TOPLEFT", SR.PlayerFrame, "BOTTOMLEFT", 0, -10)
end