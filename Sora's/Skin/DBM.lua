-- Engines
local S, _, _, DB = unpack(select(2, ...))
if not SkinDB.EnableDBMSkin then return end


local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function()
	if IsAddOnLoaded("DBM-Core") then
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

					if icon1 then
						icon1:ClearAllPoints()
						icon1:SetSize(24, 24)
						icon1:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -5, 0)
					end

					if icon2 then
						icon2:ClearAllPoints()
						icon2:SetSize(24, 24)
						icon2:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, 0)
					end

					if not frame.styled then
						frame:SetScale(1)
						frame:SetHeight(icon1:GetHeight()/3)
						frame.Shadow = S.MakeShadow(frame, 3)
						frame.styled = true
					end

					if not tbar.styled then
						tbar:SetAllPoints(frame)
						frame.styled = true
					end

					if not spark.killed then
						spark:SetAlpha(0)
						spark:SetTexture(nil)
						spark.killed = true
					end

					if not icon1.styled then
						icon1.Shadow = S.MakeTexShadow(frame, icon1, 3)
						icon1.styled = true
					end

					if not name.styled then
						name:ClearAllPoints()
						name:SetPoint("LEFT", frame, 5, 5)
						name:SetFont(DB.Font, 11, "THINOUTLINE")
						name:SetShadowOffset(0, 0)
						name.SetFont = function() end
						name.styled = true
					end

					if not timer.styled then
						timer:ClearAllPoints()
						timer:SetPoint("RIGHT", frame, -5, 5)					
						timer:SetFont(DB.Font, 11, "THINOUTLINE")
						timer:SetShadowOffset(0, 0)
						timer.SetFont = function() end
						timer.styled = true
					end

					frame:Show()
					bar:Update(0)
					bar.injected = true
				end
			end
		end)

		DBM_SavedOptions.Enabled = true
		DBT_SavedOptions["DBM"].Scale = 1
		DBT_SavedOptions["DBM"].HugeScale = 1
		DBT_SavedOptions["DBM"].Texture = DB.Statusbar
		DBT_SavedOptions["DBM"].ExpandUpwards = false
		DBT_SavedOptions["DBM"].BarXOffset = 0
		DBT_SavedOptions["DBM"].BarYOffset = 20
		DBT_SavedOptions["DBM"].IconLeft = true
		DBT_SavedOptions["DBM"].Texture = "Interface\\Buttons\\WHITE8x8"
		DBT_SavedOptions["DBM"].IconRight = false
	end
end)