-- Engines
local S, _, _, DB = unpack(select(2, ...))

-- InitMiniMapTracking
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

-- BuildTopFrame
local function BuildTopFrame()
	local TopFrame = CreateFrame("Button", nil, UIParent)
	TopFrame:SetSize(Minimap:GetWidth()+2, 16)
	S.Reskin(TopFrame)
	TopFrame:SetPoint("BOTTOM", Minimap, "TOP", 0, 3)
	TopFrame:SetAlpha(0.2)
	TopFrame:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
	TopFrame:HookScript("OnLeave", function(self) self:SetAlpha(0.2) end)
	TopFrame.Text = TopFrame:CreateFontString(nil, "OVERLAY")
	TopFrame.Text:SetPoint("CENTER", TopFrame, "CENTER", 0, 0)
	TopFrame.Text:SetFont(DB.Font, 10, "THINOUTLINE")
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

-- BuildBottomRightFrame
local function BuildBottomRightFrame(BottomFrame)
	BottomFrame.Right = CreateFrame("Button", nil, BottomFrame)
	BottomFrame.Right:SetSize(16, 16)
	BottomFrame.Right:SetPoint("RIGHT")
	BottomFrame.Right:SetScript("OnEnter", function(self)
		BottomFrame:SetAlpha(1)
		self.Text:SetTextColor(1, 0, 0)
	end)
	BottomFrame.Right:SetScript("OnLeave", function(self)
		BottomFrame:SetAlpha(0.2)
		self.Text:SetTextColor(1, 1, 1)
	end)
	BottomFrame.Right:SetScript("OnMouseDown", function(self, button, ...)
		if NBB:IsShown() then
			NBB:Hide()
		else
			NBB:Show()
		end
		PlaySound("igMiniMapOpen")
	end)
	BottomFrame.Right.Text = BottomFrame.Right:CreateFontString(nil, "OVERLAY")
	BottomFrame.Right.Text:SetPoint("CENTER")
	BottomFrame.Right.Text:SetFont(DB.Font, 9, "THINOUTLINE")
	BottomFrame.Right.Text:SetText("B")
end

-- BuildButtonTable
local function BuildButtonTable()
	local ButtonTable = {}
	for i = 1, 5 do
		local Button = CreateFrame("Button", nil, UIParent)
		Button:SetSize(80, 20)
		S.Reskin(Button)
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
			Button:SetPoint("TOP", ButtonTable[i-1], "BOTTOM", 0, -10)
			Button.Text:SetText("角色检查")
			Button:SetScript("OnMouseDown", function(self, button, ...) InitiateRolePoll() PlaySound("igMiniMapOpen") end)
		elseif i == 3 then
			Button:SetPoint("TOP", ButtonTable[i-1], "BOTTOM", 0, -10)
			Button.Text:SetText("转化为团队")
			Button:SetScript("OnMouseDown", function(self, button, ...) ConvertToRaid() PlaySound("igMiniMapOpen") end)
		elseif i == 4 then
			Button:SetPoint("TOP", ButtonTable[i-1], "BOTTOM", 0, -10)
			Button.Text:SetText("转化为小队")
			Button:SetScript("OnMouseDown", function(self, button, ...) ConvertToParty() PlaySound("igMiniMapOpen") end)
		elseif i == 5 then
			Button:SetPoint("TOP", ButtonTable[i-1], "BOTTOM", 0, -10)
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
		tinsert(ButtonTable, Button)
	end
	return ButtonTable
end

-- BuildBottomLeftFrame
local function BuildBottomLeftFrame(BottomFrame)
	local ButtonTable = BuildButtonTable()
	BottomFrame.Left = CreateFrame("Button", nil, BottomFrame)
	BottomFrame.Left:SetSize(16, 16)
	BottomFrame.Left:SetPoint("LEFT")
	BottomFrame.Left:SetScript("OnEnter", function(self)
		BottomFrame:SetAlpha(1)
		self.Text:SetTextColor(1, 0, 0)
	end)
	BottomFrame.Left:SetScript("OnLeave", function(self)
		BottomFrame:SetAlpha(0.2)
		self.Text:SetTextColor(1, 1, 1)
	end)
	BottomFrame.Left:SetScript("OnMouseDown", function(self, button, ...)
		if ButtonTable[1]:GetAlpha() > 0.95 then
			for _, value in pairs(ButtonTable) do
				UIFrameFadeOut(value, 0.5, 1, 0)
				value.HideFrame:Show()
			end
		else
			for _, value in pairs(ButtonTable) do
				UIFrameFadeIn(value, 0.5, 0, 1)
				value.HideFrame:Hide()
			end
		end
		PlaySound("igMiniMapOpen")
	end)
	BottomFrame.Left.Text = BottomFrame.Left:CreateFontString(nil, "OVERLAY")
	BottomFrame.Left.Text:SetPoint("CENTER")
	BottomFrame.Left.Text:SetFont(DB.Font, 9, "THINOUTLINE")
	BottomFrame.Left.Text:SetText("G")
end

-- BuildBottomFrame
local function BuildBottomFrame()
	local BottomFrame = CreateFrame("Button", nil, UIParent)
	BottomFrame:SetSize(Minimap:GetWidth()+2, 16)
	S.Reskin(BottomFrame)
	BottomFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, -3)
	BottomFrame:SetAlpha(0.2)
	BottomFrame:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
	BottomFrame:HookScript("OnLeave", function(self) self:SetAlpha(0.2) end)
	BottomFrame.Text = BottomFrame:CreateFontString(nil, "OVERLAY")
	BottomFrame.Text:SetPoint("CENTER", BottomFrame, "CENTER", 0, 0)
	BottomFrame.Text:SetFont(DB.Font, 10, "THINOUTLINE")
	local x, y = 0, 0
	BottomFrame.Timer = 0
	BottomFrame:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1 then
			self.Timer = 0
			x, y = GetPlayerMapPosition("player")
			self.Text:SetText(format("|　%.2d  :  %.2d　|", 100*x, 100*y))
		end
	end)
	
	BuildBottomRightFrame(BottomFrame)
	BuildBottomLeftFrame(BottomFrame)
end

-- Event
Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		BuildTopFrame()
		BuildBottomFrame()
	end
end)




