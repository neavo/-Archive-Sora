----------------
--  命名空间  --
----------------

local _, ns = ...
local cfg = ns.cfg

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
	local TopFrame = CreateFrame("Frame", nil, Minimap)
	TopFrame:SetHeight(16)
	TopFrame:SetWidth(Minimap:GetWidth())
	TopFrame:SetPoint("BOTTOM", Minimap, "TOP", 0, 3)
	TopFrame:SetBackdrop( { 
		edgeFile = cfg.Solid, edgeSize = 1, 
	})
	TopFrame:SetBackdropBorderColor(0, 0, 0, 1)
	TopFrame:SetAlpha(0.2)
	TopFrame:SetScript("OnEnter", function(self)
		self:SetAlpha(1)
	end)
	TopFrame:SetScript("OnLeave", function(self)
		self:SetAlpha(0.2)
	end)	
	TopFrame.Text = TopFrame:CreateFontString(nil, "OVERLAY")
	TopFrame.Text:SetPoint("CENTER", TopFrame, "CENTER", 0, 0)
	TopFrame.Text:SetFont(cfg.Font, 10, "THINOUTLINE")
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
	BottomFrame.Right.Text:SetFont(cfg.Font, 9, "THINOUTLINE")
	BottomFrame.Right.Text:SetText("B")
end

-- BuildButtonTable
local function BuildButtonTable()
	local ButtonTable = {}
	for i = 1, 5 do
		local Button = CreateFrame("Button", nil, UIParent)
		Button:SetSize(80, 20)
		if IsAddOnLoaded("Aurora") then
			local F, C = unpack(Aurora)
			F.Reskin(Button)
		else
			Button:SetBackdrop({
				bgFile = cfg.Solid, insets = {left = 3, right = 3, top = 3, bottom = 3},
				edgeFile = cfg.GlowTex, edgeSize = 2
			})
			Button:SetBackdropColor(0, 0, 0, 0.3)
			Button:SetBackdropBorderColor(0, 0, 0, 1)
			Button:SetScript("OnEnter", function(self)
				self.Text:SetTextColor(1, 0, 0)
			end)
			Button:SetScript("OnLeave", function(self)
				self.Text:SetTextColor(1, 1, 1)
			end)
		end
		
		Button.Text = Button:CreateFontString(nil, "OVERLAY")
		Button.Text:SetPoint("CENTER")
		Button.Text:SetFont(cfg.Font, 10, "THINOUTLINE")
		Button.HideFrame = CreateFrame("Frame", nil, Button)
		
		Button.HideFrame:SetAllPoints()
		Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		Button.HideFrame:EnableMouse(true)
		Button.HideFrame:Hide()

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
	BottomFrame.Left.Text:SetFont(cfg.Font, 9, "THINOUTLINE")
	BottomFrame.Left.Text:SetText("G")
end

-- BuildExpBar
local function BuildExpBar(BottomFrame)
	local function numberize(value)
		if value <= 9999 then return value end
		if value >= 1000000 then
			local value = string.format("%.1fm", value/1000000)
			return value
		elseif value >= 10000 then
			local value = string.format("%.1fk", value/1000)
			return value
		end
	end

	local Bar = CreateFrame("StatusBar", nil, BottomFrame)
	Bar:SetStatusBarTexture(cfg.Statusbar)
	Bar:SetWidth(Minimap:GetWidth()-2)
	Bar:SetHeight(4)
	Bar:SetValue(0)
	Bar:SetFrameStrata("MEDIUM")
	Bar:SetPoint("TOP", BottomFrame, "BOTTOM", 0, -3)
	Bar.Text = Bar:CreateFontString(nil, "OVERLAY")
	Bar.Text:SetPoint("TOP", Bar, "BOTTOM", 0, -5)
	Bar.Text:SetFont(cfg.Font, 9, "THINOUTLINE")
	Bar.Text:SetAlpha(0)
	Bar:SetScript("OnEnter", function()
		BottomFrame:SetAlpha(1)
		Bar.Text:SetAlpha(1)
	end)
	Bar:SetScript("OnLeave", function()
		BottomFrame:SetAlpha(0.2)
		Bar.Text:SetAlpha(0)
	end)
	Bar.R = CreateFrame("StatusBar", nil, BottomFrame)
	Bar.R:SetStatusBarTexture(cfg.Statusbar)
	Bar.R:SetAllPoints(Bar)
	Bar.R:SetValue(0)
	Bar.R:EnableMouse(true)
	Bar.R:SetBackdrop({
		bgFile= cfg.Statusbar, 
		insets = {left = -1, right = -1, top = -1, bottom = -1}
	})
	Bar.R:SetBackdropColor(0, 0, 0, 1)
	Bar.R.BG = Bar.R:CreateTexture(nil, "BORDER")
	Bar.R.BG:SetAllPoints(Bar.R)
	Bar.R.BG:SetTexture(cfg.Statusbar)
	Bar.R.BG:SetVertexColor(0.16, 0.16, 0.16, 1)
	
	Bar:RegisterEvent("PLAYER_XP_UPDATE")
	Bar:RegisterEvent("PLAYER_LEVEL_UP")
	Bar:RegisterEvent("UPDATE_EXHAUSTION")
	Bar:RegisterEvent("UPDATE_FACTION")
	Bar:SetScript("OnEvent", function(self)
		currXP = UnitXP("player")
		playerMaxXP = UnitXPMax("player")
		exhaustionXP  = GetXPExhaustion("player")
		name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
		self.R:SetMinMaxValues(0, playerMaxXP)
		self:SetMinMaxValues(0, playerMaxXP)
		if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
			if name then
				self:SetStatusBarColor(0.9, 0.7, 0, 1)
				self:SetMinMaxValues(minrep, maxrep)
				self:SetValue(value)
				self.R:SetValue(0)
				self.Text:SetText(value-minrep.." / "..maxrep-minrep.."\n"..floor(((value-minrep)/(maxrep-minrep))*1000)/10 .."% | ".. name)
				self:Show()
				self.R:Show()
			else
				self:Hide()
				self.R:Hide()
			end
		else
			self:SetStatusBarColor(.4, .2, .8, 1)
			self:SetValue(currXP)
			if exhaustionXP  then
				self.Text:SetText(numberize(currXP).." / "..numberize(playerMaxXP).."\n"..floor((currXP/playerMaxXP)*1000)/10 .."%" .. " (+"..numberize(exhaustionXP )..")")
				self.R:SetMinMaxValues(0, playerMaxXP)
				self.R:SetStatusBarColor(0.2, 0.4, 0.8, 0.3)
				self:SetStatusBarColor(0.2, 0.4, 0.8, 1)
				if (exhaustionXP +currXP) >= playerMaxXP then
					self.R:SetValue(playerMaxXP)
				else
					self.R:SetValue(exhaustionXP +currXP)
				end
			else
				self.Text:SetText(numberize(currXP).." / "..numberize(playerMaxXP).." | "..floor((currXP/playerMaxXP)*1000)/10 .."%")
				self.R:SetValue(0)
				self:SetStatusBarColor(0.4, 0.1, 0.6, 1)
			end
		end
	end)
end

-- BuildBottomFrame
local function BuildBottomFrame()
	local BottomFrame = CreateFrame("Frame", nil, Minimap)
	BottomFrame:SetHeight(16)
	BottomFrame:SetWidth(Minimap:GetWidth())
	BottomFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, -3)
	BottomFrame:SetBackdrop({edgeFile = cfg.Solid, edgeSize = 1})
	BottomFrame:SetBackdropBorderColor(0, 0, 0, 1)
	BottomFrame:SetAlpha(0.2)
	BottomFrame:SetScript("OnEnter", function(self)
		self:SetAlpha(1)
	end)
	BottomFrame:SetScript("OnLeave", function(self)
		self:SetAlpha(0.2)
	end)
	BottomFrame.Text = BottomFrame:CreateFontString(nil, "OVERLAY")
	BottomFrame.Text:SetPoint("CENTER", BottomFrame, "CENTER", 0, 0)
	BottomFrame.Text:SetFont(cfg.Font, 10, "THINOUTLINE")
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
	BuildExpBar(BottomFrame)
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




