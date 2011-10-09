----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig
local ChatFrameInScreen = "In"

local MainBar = CreateFrame("Frame", "MainBar", UIParent)
MainBar:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0, -6)
MainBar:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 0, -24)
MainBar:SetBackdrop({
	bgFile = cfg.bgFile, 
	edgeFile = cfg.GlowTex, edgeSize = 3, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
MainBar:SetBackdropColor(0, 0, 0, 0.2)
MainBar:SetBackdropBorderColor(0, 0, 0, 0.8)

MainBar.Right = CreateFrame("Frame", nil, MainBar)
MainBar.Right:SetPoint("TOPLEFT", MainBar, "TOPRIGHT", 0, 0)
MainBar.Right:SetPoint("BOTTOMRIGHT", MainBar, "BOTTOMRIGHT", 12, 0)
MainBar.Right:SetBackdrop({
	edgeFile = cfg.GlowTex, edgeSize = 3, 
})
MainBar.Right:SetBackdropBorderColor(0, 0, 0, 0.8)
MainBar.Right:SetScript("OnMouseDown", function(self)
	--if not UnitAffectingCombat("player") then
		if ChatFrameInScreen == "In" then
			--local _, _, _, OriginalX, OriginalY = ChatFrame1:GetPoint()
			local OriginalX, OriginalY = 5, 23
			local Step, MaxStep = 0, 60
			local Length = ChatFrame1:GetWidth() + OriginalX
			local Timer = 0
			local Updater = CreateFrame("Frame")
			Updater:SetScript("OnUpdate", function(self, elapsed)
				Timer = Timer + elapsed
				if Timer < 0.1 then
					Timer = 0
					Step = Step + 1
					ChatFrame1:SetPoint("BOTTOMLEFT", OriginalX - (Step/MaxStep)*Length, OriginalY)
				end
				if Step >= MaxStep then
					self:SetScript("OnUpdate", nil)
					ChatFrameInScreen = "Out"
				end
			end)			
		elseif ChatFrameInScreen == "Out" then
			local OriginalX, OriginalY = -ChatFrame1:GetWidth(), 23
			local Step, MaxStep = 0, 60
			local Length = ChatFrame1:GetWidth() + 5
			local Timer = 0
			local Updater = CreateFrame("Frame")
			Updater:SetScript("OnUpdate", function(self, elapsed)
				Timer = Timer + elapsed
				if Timer < 0.1 then
					Timer = 0
					Step = Step + 1
					ChatFrame1:SetPoint("BOTTOMLEFT", OriginalX + (Step/MaxStep)*Length, OriginalY)
				end
				if Step >= MaxStep then
					self:SetScript("OnUpdate", nil)
					ChatFrameInScreen = "In"
				end
			end)		
		end
	--end
end)



