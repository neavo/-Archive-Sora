local myclass = select(2, UnitClass("player"))


-- styling totembar
if myclass == "SHAMAN" then
	local TotemBar = CreateFrame("Frame", "holder_TotemBar", UIParent, "SecureHandlerStateTemplate")
	TotemBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -101, 113)
	local tN = { 2, 1, 3, 4 }
	local TotemButtons = {
		MultiCastActionPage1,
		MultiCastActionPage2,
		MultiCastActionPage3,
		MultiCastSlotButton1,
		MultiCastSlotButton2,
		MultiCastSlotButton3,
		MultiCastSlotButton4,
		MultiCastFlyoutFrame,
		MultiCastFlyoutButton,
	}
 	if MultiCastActionBarFrame then
		TotemBar:SetSize(_G['MultiCastActionBarFrame']:GetWidth(), _G['MultiCastActionBarFrame']:GetHeight()) 
		TotemBar:Show()
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(TotemBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", TotemBar, 0, 0)
		MultiCastActionBarFrame:SetAllPoints(TotemBar)
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
		for _, f in pairs(TotemButtons) do
			f:SetParent(TotemBar);
		end
		MultiCastSummonSpellButton:ClearAllPoints();
		MultiCastSummonSpellButton:SetPoint("BOTTOMLEFT",TotemBar,"BOTTOMLEFT",0,3);
		MultiCastSummonSpellButton:SetSize(26,26)
		for i = 1, 12 do
			local b = _G["MultiCastSlotButton"..i]
			local b2 = _G["MultiCastActionButton"..i]
			b2:SetSize(26,26)
			if i <= 4 then
				local b = _G["MultiCastSlotButton"..i]
				b:ClearAllPoints()
				b:SetSize(26,26)
				b:SetPoint("TOPLEFT",b2,"TOPLEFT")
			end
 			if i == 1 or i == 5 or i == 9 then 
				b2:SetPoint("LEFT",MultiCastSummonSpellButton,"RIGHT",1,0)
			else
				b2:SetPoint("LEFT",_G["MultiCastActionButton"..(i-1)],"RIGHT",1,0)
			end
		end
		MultiCastRecallSpellButton:ClearAllPoints();
		MultiCastRecallSpellButton:SetPoint("TOPLEFT",MultiCastSummonSpellButton,"TOPRIGHT", 1*5+26*4-2, 0)
		MultiCastRecallSpellButton:SetSize(26,26)
	end
	-- right click to destroy totem
	local function TotemBar_Destroy(self, button)
		if (button ~= "RightButton") then return end
		if (self:GetName() == "MultiCastActionButton1") or (self:GetName() == "MultiCastActionButton5") or (self:GetName() == "MultiCastActionButton9") then
			DestroyTotem(2);
		elseif (self:GetName() == "MultiCastActionButton2") or (self:GetName() == "MultiCastActionButton6") or (self:GetName() == "MultiCastActionButton10") then
			DestroyTotem(1);
		elseif (self:GetName() == "MultiCastActionButton3") or (self:GetName() == "MultiCastActionButton7") or (self:GetName() == "MultiCastActionButton11") then
			DestroyTotem(3);
		elseif (self:GetName() == "MultiCastActionButton4") or (self:GetName() == "MultiCastActionButton8") or (self:GetName() == "MultiCastActionButton12") then
			DestroyTotem(4);
		end
	end
	for i = 1, 12 do
		hooker = _G["MultiCastActionButton"..i];
		hooker:RegisterForClicks("LeftButtonUp")
		hooker:HookScript("OnMouseUp", TotemBar_Destroy)
	end
	-- totem timers
	TotemBar.OnUpdate = function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 0.2 then
			local tl = GetTotemTimeLeft(self.tN)
			if tl > 0 then
				self.t:SetFormattedText(SecondsToTimeAbbrev(tl))
				self.elapsed = 0
			else
				self.t:SetText("")
				self:Hide()
			end
		end
	end
	TotemBar.OnEvent = function(self, event, tN)
		if event == "PLAYER_ENTERING_WORLD" then 
			tN = self.tN 
			self.elapsed = 1000
		elseif tN ~= self.tN then	
			return 
		end
		local _, _, start, duration = GetTotemInfo(tN)
		if duration > 0 then
			self.start = start
			self.duration = duration
			self:Show()
		else
			self:Hide()
		end
	end
	local tcol = {
		[1] = {r=.5,g=.7,b=.3}, -- earth
		[2] = {r=.8,g=.4,b=.2}, -- fire
		[3] = {r=.3,g=.7,b=.8}, -- water
		[4] = {r=.8,g=.5,b=.9}, -- air
	}
	for i = 1, #tN do
		local btn = _G["MultiCastSlotButton"..i]
		local h = CreateFrame("Frame", nil, btn)
		h.tN = tN[i]
		h:SetAllPoints(btn)
		h:SetFrameStrata("MEDIUM")
		h:SetFrameLevel(10)
		h.bg = h:CreateTexture(nil, "BACKGROUND")
		h.bg:SetPoint("BOTTOM",h,"BOTTOM")
		h.bg:SetSize(h:GetHeight()-2,h:GetHeight()/3)
		h.bg:SetTexture(0, 0, 0)
		h.bg:SetAlpha(0.6)
		h.t = h:CreateFontString(nil, "OVERLAY")
		h.t:SetPoint("CENTER", h.bg, "CENTER", 0, 0)
		h.t:SetWidth(h:GetWidth())
		h.t:SetFont("Fonts\\ZYKai_T.ttf", 9, "THINOUTLINE")
		h.t:SetTextColor(tcol[i].r,tcol[i].g,tcol[i].b)
		h:SetScript("OnEvent", TotemBar.OnEvent)
		h:SetScript("OnUpdate", TotemBar.OnUpdate)
		h:SetScript("OnHide", function(self) self.start = nil self.duration = nil end)
		h:SetScript("OnShow", function(self) if not self.start or not self.duration then return self:Hide() end	self.elapsed = 1000 end)
		h:RegisterEvent("PLAYER_ENTERING_WORLD")
		h:RegisterEvent("PLAYER_TOTEM_UPDATE")
		TotemBar.OnEvent(h, "PLAYER_TOTEM_UPDATE", h.tN)
	end
end
