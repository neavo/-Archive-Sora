-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("MiniMapPanels", "AceTimer-3.0")
local MiniMapButton, RaidButton = {}, {}
local BlackList = { 
	["MiniMapTracking"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["MiniMapLFGFrame"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MiniMapMailFrame"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["MinimapBackdrop"] = true,
	["GameTimeFrame"] = true,
	["TimeManagerClockButton"] = true,
	["FeedbackUIButton"] = true,
}

-- BuildTopFrame
local function InitMiniMapTracking(TopFrame)
	MiniMapTrackingBackground:Hide()
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTracking:SetParent(TopFrame)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetFrameStrata("HIGH")
	MiniMapTracking:SetFrameLevel("0")
	MiniMapTracking:SetPoint("LEFT", 3, 0)
	MiniMapTracking:SetScale(0.7)
end
local function BuildTopFrame()
	local TopFrame = S.MakeButton(UIParent)
	TopFrame:SetSize(Minimap:GetWidth()+2, 16)
	TopFrame:SetPoint("BOTTOM", Minimap, "TOP", 0, 3)
	TopFrame:SetAlpha(0.2)
	TopFrame:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
	TopFrame:HookScript("OnLeave", function(self) self:SetAlpha(0.2) end)
	TopFrame.Text = S.MakeFontString(TopFrame, 10)
	TopFrame.Text:SetPoint("CENTER")
	TopFrame.Timer = 0
	TopFrame:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			self.Text:SetText(GetMinimapZoneText())
		end
	end)
	InitMiniMapTracking(TopFrame)
end

-- BuildBottomFrame
local function UpdateMiniMapButton()
	wipe(MiniMapButton)
	for _, value in ipairs({Minimap:GetChildren()}) do
		if not BlackList[value:GetName()] then
			if value:GetObjectType() == "Button" and value:GetNumRegions() >= 3 then
				value:SetScale(0.8)
				tinsert(MiniMapButton, value)
			end
		end
	end
	for key, value in pairs(MiniMapButton) do
		value:ClearAllPoints()
		if key == 1 then
			value:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -5, -30)
		else
			value:SetPoint("LEFT", MiniMapButton[key-1], "RIGHT", 5, 0)
		end
	end
end
local function BuildBottomLeftFrame(Frame)
	local Button = CreateFrame("Button", nil, Frame)
	Button:SetSize(16, 16)
	Button:SetPoint("LEFT")
	local Text = S.MakeFontString(Button, 9)
	Text:SetPoint("CENTER")
	Text:SetText("B")
	Button:SetScript("OnEnter", function(self)
		Frame:SetAlpha(1)
		Text:SetTextColor(1, 0, 0)
	end)
	Button:SetScript("OnLeave", function(self)
		Frame:SetAlpha(0.2)
		Text:SetTextColor(1, 1, 1)
	end)
	Button:SetScript("OnClick", function(self, button, ...)
		UpdateMiniMapButton()
		for _, value in pairs(MiniMapButton) do
			if value:IsShown() then
				value:Hide()
			else
				value:Show()
			end
		end
		PlaySound("igMiniMapOpen")
	end)
end
local function BuildRaidButton()
	for i = 1, 5 do
		local Button = S.MakeButton(UIParent)
		Button:SetSize(80, 20)
		Button.Text = Button:CreateFontString(nil, "OVERLAY")
		Button.Text:SetPoint("CENTER")
		Button.Text:SetFont(DB.Font, 10, "THINOUTLINE")
		Button.HideFrame = CreateFrame("Frame", nil, Button)
		Button.HideFrame:SetAllPoints()
		Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		Button.HideFrame:EnableMouse(true)

		if i == 1 then
			Button:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 10, 15)
			Button.Text:SetText("就位确认")
			Button:SetScript("OnMouseDown", function(self, button, ...) DoReadyCheck() PlaySound("igMiniMapOpen") end)
		elseif i == 2 then
			Button:SetPoint("TOP", RaidButton[i-1], "BOTTOM", 0, -10)
			Button.Text:SetText("角色检查")
			Button:SetScript("OnMouseDown", function(self, button, ...) InitiateRolePoll() PlaySound("igMiniMapOpen") end)
		elseif i == 3 then
			Button:SetPoint("TOP", RaidButton[i-1], "BOTTOM", 0, -10)
			Button.Text:SetText("转化为团队")
			Button:SetScript("OnMouseDown", function(self, button, ...) ConvertToRaid() PlaySound("igMiniMapOpen") end)
		elseif i == 4 then
			Button:SetPoint("TOP", RaidButton[i-1], "BOTTOM", 0, -10)
			Button.Text:SetText("转化为小队")
			Button:SetScript("OnMouseDown", function(self, button, ...) ConvertToParty() PlaySound("igMiniMapOpen") end)
		elseif i == 5 then
			Button:SetPoint("TOP", RaidButton[i-1], "BOTTOM", 0, -10)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetHeight(16)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetWidth(16)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent(Button)
			CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint("CENTER")
			Button.HideFrame:SetFrameLevel(CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetFrameLevel()+1)
		end
		
		Button:SetAlpha(0)
		tinsert(RaidButton, Button)
	end
end
local function BuildBottomRightFrame(Frame)
	BuildRaidButton()
	local Button = CreateFrame("Button", nil, Frame)
	Button:SetSize(16, 16)
	Button:SetPoint("RIGHT")
	local Text = S.MakeFontString(Button, 9)
	Text:SetPoint("CENTER")
	Text:SetText("G")
	Button:SetScript("OnEnter", function(self)
		Frame:SetAlpha(1)
		Text:SetTextColor(1, 0, 0)
	end)
	Button:SetScript("OnLeave", function(self)
		Frame:SetAlpha(0.2)
		Text:SetTextColor(1, 1, 1)
	end)
	Button:SetScript("OnClick", function(self, ...)
		if RaidButton[1]:GetAlpha() > 0.95 then
			for _, value in pairs(RaidButton) do
				UIFrameFadeOut(value, 0.5, 1, 0)
				value.HideFrame:Show()
			end
		else
			for _, value in pairs(RaidButton) do
				UIFrameFadeIn(value, 0.5, 0, 1)
				value.HideFrame:Hide()
			end
		end
		PlaySound("igMiniMapOpen")
	end)
end
local function BuildBottomFrame()
	local Frame = S.MakeButton(UIParent)
	Frame:SetSize(Minimap:GetWidth()+2, 16)
	Frame:SetPoint("TOP", Minimap, "BOTTOM", 0, -3)
	Frame:SetAlpha(0.2)
	Frame:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
	Frame:HookScript("OnLeave", function(self) self:SetAlpha(0.2) end)
	Frame.Text = S.MakeFontString(Frame, 10)
	Frame.Text:SetPoint("CENTER")
	Frame.Timer = 0
	Frame:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			local x, y = GetPlayerMapPosition("player")
			self.Text:SetText(format("|　%.2d  :  %.2d　|", 100*x, 100*y))
		end
	end)
	BuildBottomRightFrame(Frame)
	BuildBottomLeftFrame(Frame)
end

function Module:DelayOnEnable()
	UpdateMiniMapButton()
	for _, value in pairs(MiniMapButton) do
		value:Hide()
	end
end

function Module:OnEnable()
	BuildTopFrame()
	BuildBottomFrame()
	Module:ScheduleTimer("DelayOnEnable", 2)
end
