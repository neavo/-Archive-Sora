-- Engines
local S, _, _, DB = unpack(select(2, ...))

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:SetScript("OnEvent", function()
	if IsAddOnLoaded("DBM-Core") then
		local croprwicons = true			-- crops blizz shitty borders from icons in RaidWarning messages
		local rwiconsize = 18			-- RaidWarning icon size, because 12 is small for me. Works only if croprwicons=true
		local buttonsize = 24

		local function SkinBoss()
			local count = 1
			while _G[format("DBM_BossHealth_Bar_%d", count)] do
				local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
				local background = _G[bar:GetName().."BarBorder"]
				local progress = _G[bar:GetName().."Bar"]
				local name = _G[bar:GetName().."BarName"]
				local timer = _G[bar:GetName().."BarTimer"]
				local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]	

				if count == 1 then
					local	_, anch, _ , _, _ = bar:GetPoint()
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint("BOTTOM", anch, "TOP" , 0 , 12)
					else
						bar:SetPoint("TOP", anch, "BOTTOM" , 0, -buttonsize)
					end
				else
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, buttonsize+4)
					else
						bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, -(buttonsize+4))
					end
				end
				if not bar.styled then
					bar:SetHeight(buttonsize)
					if not bar.bg then
						bar.bg = CreateFrame("Frame", nil, bar)
						bar.bg:SetAllPoints()
					end
					S.MakeShadow(bar.bg, 3)
					background:SetNormalTexture(nil)
					bar.styled = true
				end	
		
				if not progress.styled then
					progress:SetStatusBarTexture(DB.Statusbar)
					progress.styled = true
				end				
				progress:ClearAllPoints()
				progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
				progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
	
				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", bar, "LEFT", 4, 2)
					name:SetFont(DB.Font, 12, "THINOUTLINE")
					name:SetShadowColor(0, 0, 0, 0)
					name.styled = true
				end
		
				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", bar, "RIGHT", -4, 2)
					timer:SetFont(DB.Font, 12, "THINOUTLINE")
					timer:SetShadowColor(0, 0, 0, 0)
					timer.styled = true
				end
				count = count + 1
			end
		end

		-- Hooks
		hooksecurefunc(DBT, "CreateBar", function(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					local frame = bar.frame
					local tbar = _G[frame:GetName().."Bar"]
					local spark = _G[frame:GetName().."BarSpark"]
					local texture = _G[frame:GetName().."BarTexture"]
					local icon1 = _G[frame:GetName().."BarIcon1"]
					local icon2 = _G[frame:GetName().."BarIcon2"]
					local name = _G[frame:GetName().."BarName"]
					local timer = _G[frame:GetName().."BarTimer"]
			
					if not icon1.overlay then
						icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
						icon1.overlay:SetSize(buttonsize, buttonsize)
						icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -5, 0)
						S.MakeShadow(icon1.overlay, 3)
					end

					if not icon2.overlay then
						icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
						icon2.overlay:SetSize(buttonsize, buttonsize)
						icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", -5, 0)
						S.MakeShadow(icon2.overlay, 3)
					end

					if bar.color then
						tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
					else
						tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
					end
			
					if bar.enlarged then
						frame:SetWidth(bar.owner.options.HugeWidth)
					else
						frame:SetWidth(bar.owner.options.Width)
					end
					if bar.enlarged then
						tbar:SetWidth(bar.owner.options.HugeWidth)
					else
						tbar:SetWidth(bar.owner.options.Width)
					end
	
					if not frame.styled then
						frame:SetScale(1)
						frame.SetScale = function() return end
						frame:SetHeight(buttonsize/3)
						S.MakeShadow(frame, 3)
						frame.styled = true
					end

					if not spark.killed then
						spark:SetAlpha(0)
						spark:SetTexture(nil)
						spark.killed = true
					end

					if not icon1.styled then
						icon1:ClearAllPoints()
						icon1:SetAllPoints(icon1.overlay)
						icon1.styled = true
					end
			
					if not icon2.styled then
						icon2:ClearAllPoints()
						icon2:SetAllPoints(icon2.overlay)
						icon2.styled = true
					end

					if not texture.styled then
						texture:SetTexture(DB.Statusbar)
						texture.styled = true
					end
			
					tbar:SetStatusBarTexture(DB.Statusbar)
					if not tbar.styled then
						tbar:SetAllPoints(frame)
						tbar.styled = true
					end

					if not name.styled then
						name:ClearAllPoints()
						name:SetPoint("CENTER", frame, -4, 3)
						name:SetFont(DB.Font, 12, "THINOUTLINE")
						name:SetShadowColor(0, 0, 0, 0)
						name.SetFont = function() return end
						name.styled = true
					end
			
					if not timer.styled then	
						timer:ClearAllPoints()
						timer:SetPoint("RIGHT", frame, 0, 3)
						timer:SetFont(DB.Font, 12, "THINOUTLINE")
						timer:SetShadowColor(0, 0, 0, 0)
						timer.SetFont = function() return end
						timer.styled = true
					end

					if bar.owner.options.IconLeft then
						icon1:Show()
						icon1.overlay:Show()
					else
						icon1:Hide()
						icon1.overlay:Hide()
					end
					if bar.owner.options.IconRight then
						icon2:Show()
						icon2.overlay:Show()
					else
						icon2:Hide()
						icon2.overlay:Hide()
					end
					
					tbar:SetAlpha(1)
					frame:SetAlpha(1)
					texture:SetAlpha(1)
					frame:Show()
					bar:Update(0)
					bar.injected = true
				end
			end
		end)
		hooksecurefunc(DBM.BossHealth, "Show", function()
			local anchor = DBMBossHealthDropdown:GetParent()
			if not anchor.styled then
				local header={anchor:GetRegions()}
					if header[1]:IsObjectType("FontString") then
						header[1]:SetFont(DB.Font, 12, "THINOUTLINE")
						header[1]:SetTextColor(1, 1, 1, 1)
						header[1]:SetShadowColor(0, 0, 0, 0)
						anchor.styled = true	
					end
				header = nil
			end
			anchor = nil
		end)
		hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
		hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss)

		DBM.RangeCheck:Show()
		DBM.RangeCheck:Hide()
		DBMRangeCheck:HookScript("OnShow", function(self)
			self:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
			self:SetBackdropBorderColor(65/255, 74/255, 79/255)
			self.shadow = S.MakeShadow(self, 3)
		end)

		DBMRangeCheckRadar:HookScript("OnShow", function(self)
			self:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
			self:SetBackdropBorderColor(65/255, 74/255, 79/255)
			self.shadow = S.MakeShadow(self, 3)
			self.text:SetFont(DB.Font, 12, "THINOUTLINE")
		end)

		local RaidNotice_AddMessage_=RaidNotice_AddMessage
		RaidNotice_AddMessage=function(noticeFrame, textString, colorInfo)
			if textString:find(" |T") then textString = string.gsub(textString, "(:12:12)", ":18:18:0:0:64:64:5:59:5:59") end
			return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
		end
	end
end)
	
	
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(self)
	DBM_SavedOptions.Enabled = true	
	DBT_SavedOptions["DBM"].Scale = 1
	DBT_SavedOptions["DBM"].HugeScale = 1
	DBT_SavedOptions["DBM"].BarXOffset = 0
end)
