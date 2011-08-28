-- Quel'evel 3.3.0.9 by Tekkub Stoutwrithe

local questtags, tags = {}, {Elite = "+", Group = "G", Dungeon = "D", Raid = "R", PvP = "P", Daily = "•", Heroic = "H", Repeatable = "∞"}

local function GetTaggedTitle(i)
	local name, level, tag, group, header, _, complete, daily = GetQuestLogTitle(i)
	if header or not name then return end
	if not group or group == 0 then group = nil end
	return string.format("[%s %s %s %s] %s", level, tag and tags[tag] or "", daily and tags.Daily or "",group or "", name), tag, daily, complete
end

-- Add tags to the quest log
local function QuestLog_Update()
	for i, butt in pairs(QuestLogScrollFrame.buttons) do
		local qi = butt:GetID()
		local title, tag, daily, complete = GetTaggedTitle(qi)
		if title then butt:SetText("  "..title) end
		if (tag or daily) and not complete then butt.tag:SetText("") end
		QuestLogTitleButton_Resize(butt)
	end
end
hooksecurefunc("QuestLog_Update", QuestLog_Update)
hooksecurefunc(QuestLogScrollFrame, "update", QuestLog_Update)

-- Add tags to the quest watcher
hooksecurefunc("WatchFrame_Update", function()
	local questWatchMaxWidth, watchTextIndex = 0, 1
	for i = 1, GetNumQuestWatches() do
		local qi = GetQuestIndexForWatch(i)
		if qi then
			local numObjectives = GetNumQuestLeaderBoards(qi)
			if numObjectives > 0 then
				for bi, butt in pairs(WATCHFRAME_QUESTLINES) do
					if butt.text:GetText() == GetQuestLogTitle(qi) then butt.text:SetText(GetTaggedTitle(qi)) end
				end
			end
		end
	end
end)

-- Add tags to quest links in chat
local function filter(self, event, msg, ...)
	if msg then
		return false, msg:gsub("(|c%x+|Hquest:%d+:(%d+))", "(%2) %1"), ...
	end
end
for _, event in pairs{"SAY", "GUILD", "GUILD_OFFICER", "WHISPER", "WHISPER_INFORM", "PARTY", "RAID", "RAID_LEADER", "BATTLEGROUND", "BATTLEGROUND_LEADER"} do ChatFrame_AddMessageEventFilter("CHAT_MSG_"..event, filter) end

-- Add tags to gossip frame
local i
local TRIVIAL, NORMAL = "|cff%02x%02x%02x[%d%s%s]|r "..TRIVIAL_QUEST_DISPLAY, "|cff%02x%02x%02x[%d%s%s]|r ".. NORMAL_QUEST_DISPLAY
local function helper(isActive, ...)
	local num = select('#', ...)
	if num == 0 then return end
	local skip = isActive and 4 or 5
	for j = 1, num, skip do
		local title, level, isTrivial, daily, repeatable = select(j, ...)
		if isActive then daily, repeatable = nil end
		if title and level and level ~= -1 then
			local color = GetQuestDifficultyColor(level)
			_G["GossipTitleButton"..i]:SetFormattedText(isActive and isTrivial and TRIVIAL or NORMAL, color.r*255, color.g*255, color.b*255, level, repeatable and tags.Repeatable or "", daily and tags.Daily or "", title)
		end
		i = i + 1
	end
	i = i + 1
end

local function GossipUpdate()
	i = 1
	helper(false, GetGossipAvailableQuests()) 	-- name, level, trivial, daily, repeatable
	helper(true, GetGossipActiveQuests()) 		-- name, level, trivial, complete
end
hooksecurefunc("GossipFrameUpdate", GossipUpdate)
if GossipFrame:IsShown() then GossipUpdate() end



-- QuestCollapse v0.1 by thek

local collapseAll = CreateFrame("Button", "QuestCollapse" , QuestLogFrame, "UIPanelButtonTemplate")
_G[collapseAll:GetName().."Text"]:SetText("全部收起")
collapseAll:SetPoint("TOP", QuestLogFrame, "TOP", -100, -40)
collapseAll:SetWidth(100)
collapseAll:SetHeight(25)
collapseAll:SetScript("OnClick", function() CollapseQuestHeader(0) end)

local expandAll = CreateFrame("Button", "QuestExpand", QuestLogFrame, "UIPanelButtonTemplate")
_G[expandAll:GetName().."Text"]:SetText("全部展开")
expandAll:SetPoint("TOP", QuestLogFrame, "TOP", 0, -40)
expandAll:SetWidth(100)
expandAll:SetHeight(25)
expandAll:SetScript("OnClick", function() ExpandQuestHeader(0) end)



-- QuestPrice by Abin   2010/12/10

local _G = _G
local QuestLogFrame = QuestLogFrame
local pcall = pcall
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestItemLink = GetQuestItemLink
local select = select
local GetItemInfo = GetItemInfo
local MoneyFrame_SetType = MoneyFrame_SetType
local MoneyFrame_Update = MoneyFrame_Update

local function QuestPriceFrame_OnUpdate(self)
	local button = self.button
	if not button.rewardType or button.rewardType == "item" then
		local result, link = pcall(QuestLogFrame:IsShown() and GetQuestLogItemLink or GetQuestItemLink, button.type, button:GetID())
		if not result then
			link = nil
		end

		if link ~= self.link then
			self.link = link
			local price = link and select(11, GetItemInfo(link))
			if price and price > 0 then
				MoneyFrame_Update(self, price)
				self:SetAlpha(1)
			else
				self:SetAlpha(0)
			end
		end
	end
end

local function CreatePriceFrame(name)
	local button = _G[name]
	if button then
		local frame = CreateFrame("Frame", name.."QuestPriceFrame", button, "SmallMoneyFrameTemplate")
		frame:SetPoint("BOTTOMRIGHT", 10, 0)
		frame:Raise()
		frame:SetScale(0.85)
		frame:SetAlpha(0)
		MoneyFrame_SetType(frame, "STATIC")
		frame.button = button
		frame:SetScript("OnShow", QuestPriceFrame_OnUpdate)
		frame:SetScript("OnUpdate", QuestPriceFrame_OnUpdate)
	end
end

local i
for i = 1, 10 do
	CreatePriceFrame("QuestInfoItem"..i)
end