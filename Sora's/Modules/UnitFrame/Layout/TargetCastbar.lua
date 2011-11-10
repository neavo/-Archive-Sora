-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("TargetCastbar")
local Parent = nil

function Module:UpdateWidth(value)
	Parent:SetWidth(value)
	Parent.Castbar:SetWidth(value-UnitFrameDB["TargetCastbarHeight"]-5)
end
function Module:UpdateHeight(value)
	Parent:SetHeight(value)
	Parent.Castbar:SetHeight(value)
	Parent.Castbar.Icon:SetSize(value, value)
end

local function BuildTargetCastbar(self, ...)
	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(DB.Statusbar)
	Castbar:SetStatusBarColor(95/255, 182/255, 255/255, 1)
	Castbar:SetPoint("RIGHT")
	
	Castbar.Shadow = S.MakeShadow(Castbar, 3)
	Castbar.Shadow:SetBackdrop({
		bgFile = DB.Statusbar,insets = {left = 3, right = 3, top = 3, bottom = 3}, 
		edgeFile = DB.GlowTex, edgeSize = 3, 
	})
	Castbar.Shadow:SetBackdropColor(0, 0, 0, 0.5)
	Castbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	
	Castbar.CastingColor = {95/255, 182/255, 255/255}
	Castbar.CompleteColor = {20/255, 208/255, 0/255}
	Castbar.FailColor = {255/255, 12/255, 0/255}
	Castbar.ChannelingColor = {95/255, 182/255, 255/255}

	Castbar.Text = S.MakeFontString(Castbar, 10)
	Castbar.Text:SetPoint("LEFT", 2, 0)
	
	Castbar.Time = S.MakeFontString(Castbar, 10)
	Castbar.Time:SetPoint("RIGHT", -2, 0)
	
	Castbar.Icon = Castbar:CreateTexture(nil, "ARTWORK")
	Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Castbar.Icon:SetPoint("BOTTOMRIGHT", Castbar, "BOTTOMLEFT", -5, 0)
	Castbar.Icon.Shadow = S.MakeTexShadow(Castbar, Castbar.Icon, 3)

	Castbar.OnUpdate = S.OnCastbarUpdate
	Castbar.PostCastStart = S.PostCastStart
	Castbar.PostChannelStart = S.PostCastStart
	Castbar.PostCastStop = S.PostCastStop
	Castbar.PostChannelStop = S.PostChannelStop
	Castbar.PostCastFailed = S.PostCastFailed
	Castbar.PostCastInterrupted = S.PostCastFailed
	
	Parent = self
	self.Castbar = Castbar
	Module:UpdateWidth(UnitFrameDB["TargetCastbarWidth"])
	Module:UpdateHeight(UnitFrameDB["TargetCastbarHeight"])
	
end

function Module:OnInitialize()
	if not UnitFrameDB.TargetCastbarEnable then return end
	oUF:RegisterStyle("TargetCastbar", BuildTargetCastbar)
	oUF:SetActiveStyle("TargetCastbar")
	DB.TargetCastbar = oUF:Spawn("Target", "oUF_SoraTargetCastbar")
	MoveHandle.TargetCastbar = S.MakeMoveHandle(DB.TargetCastbar, "目标施法条", "TargetCastbar")
end
