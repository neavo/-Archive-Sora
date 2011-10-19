hooksecurefunc("DungeonCompletionAlertFrame_FixAnchors", function(self)
	for i = MAX_ACHIEVEMENT_ALERTS, 1, -1 do
		local AchievementAlertFrame = _G["AchievementAlertFrame"..i]
		if AchievementAlertFrame and AchievementAlertFrame:IsShown() then
			DungeonCompletionAlertFrame1:ClearAllPoints()
			DungeonCompletionAlertFrame1:SetPoint("BOTTOM", AchievementAlertFrame, "TOP", 0, 10)
			return
		end
	end
	DungeonCompletionAlertFrame1:ClearAllPoints()	
	DungeonCompletionAlertFrame1:SetPoint("CENTER", UIParent, 0, 100)
end)

local function AchievementMove(self, event, ...)
	local Pre = nil
	for i = 1, MAX_ACHIEVEMENT_ALERTS do
		local AchievementAlertFrame = _G["AchievementAlertFrame"..i]
		if AchievementAlertFrame then
			AchievementAlertFrame:ClearAllPoints()
			if Pre and Pre:IsShown() then
				AchievementAlertFrame:SetPoint("BOTTOM", Pre, "TOP", 0, 10)
			else
				AchievementAlertFrame:SetPoint("CENTER", UIParent, 0, 100)
			end	
			Pre = AchievementAlertFrame
		end
	end
end
hooksecurefunc("AchievementAlertFrame_FixAnchors", AchievementMove)
local Event = CreateFrame("Frame")
Event:RegisterEvent("ACHIEVEMENT_EARNED")
Event:SetScript("OnEvent", function(self, event, ...)
	AchievementMove(self, event, ...)
end)