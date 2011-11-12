-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("PlayerCastbar")
local Parent = nil

function Module:UpdateWidth(value)
	if Parent then Parent:SetWidth(value) end
	if Parent.Castbar then Parent.Castbar:SetWidth(value-UnitFrameDB["PlayerCastbarHeight"]-5) end
	if MoveHandle.PlayerCastbar then MoveHandle.PlayerCastbar:SetWidth(value) end
end
function Module:UpdateHeight(value)
	if Parent then Parent:SetHeight(value) end
	if Parent.Castbar then Parent.Castbar:SetSize(UnitFrameDB["PlayerCastbarWidth"]-value-5, value) end
	if Parent.Castbar.Icon then Parent.Castbar.Icon:SetSize(value, value) end
	if MoveHandle.PlayerCastbar then MoveHandle.PlayerCastbar:SetHeight(value) end
end
local function BuildPlayerCastbar(self, ...)
	Parent = self

	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(DB.Statusbar)
	Castbar:SetStatusBarColor(95/255, 182/255, 255/255)
	Castbar:SetPoint("LEFT")
	
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
	Castbar.Icon:SetPoint("BOTTOMLEFT", Castbar, "BOTTOMRIGHT", 5, 0)
	Castbar.Icon.Shadow = S.MakeTexShadow(Castbar, Castbar.Icon, 3)

	Castbar.SafeZone = Castbar:CreateTexture(nil, "OVERLAY")
	Castbar.SafeZone:SetTexture(DB.Statusbar)
	Castbar.SafeZone:SetVertexColor(1, 0.1, 0, 0.6)
	Castbar.SafeZone:SetAllPoints()
	Castbar.Lag = S.MakeFontString(Castbar, 10)
	Castbar.Lag:SetPoint("CENTER", -2, 17)
	Castbar.Lag:Hide()
	self:RegisterEvent("UNIT_SPELLCAST_SENT", S.OnCastSent)

	Castbar.OnUpdate = S.OnCastbarUpdate
	Castbar.PostCastStart = S.PostCastStart
	Castbar.PostChannelStart = S.PostCastStart
	Castbar.PostCastStop = S.PostCastStop
	Castbar.PostChannelStop = S.PostChannelStop
	Castbar.PostCastFailed = S.PostCastFailed
	Castbar.PostCastInterrupted = S.PostCastFailed
	
	self.Castbar = Castbar
	Module:UpdateWidth(UnitFrameDB["PlayerCastbarWidth"])
	Module:UpdateHeight(UnitFrameDB["PlayerCastbarHeight"])
end

function Module:OnInitialize()
	if not UnitFrameDB.PlayerCastbarEnable then return end
	oUF:RegisterStyle("SoraPlayerCastbar", BuildPlayerCastbar)
	oUF:SetActiveStyle("SoraPlayerCastbar")
	DB.PlayerCastbar = oUF:Spawn("player", "oUF_SoraPlayerCastbar")
	MoveHandle.PlayerCastbar = S.MakeMoveHandle(DB.PlayerCastbar, "玩家施法条", "PlayerCastbar")
end
