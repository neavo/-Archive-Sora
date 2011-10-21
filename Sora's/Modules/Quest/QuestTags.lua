local function GetTaggedTitle(i)
	local name, level, _, group, header, _, _, _ = GetQuestLogTitle(i)
	if header or not name then return end
	if not group or group == 0 then group = nil end
	return string.format("%s%s%s", "["..level.."]",group and "["..group.."+]"or "", name)
end

-- Add tags to the quest log
local function QuestLog_Update()
	for i, butt in pairs(QuestLogScrollFrame.buttons) do
		local qi = butt:GetID()
		local title = GetTaggedTitle(qi)
		if title then butt:SetText("  "..title) end
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
local function helper(isActive, ...)
	local num = select('#', ...)
	if num == 0 then return end
	local skip = isActive and 4 or 5
	for j = 1, num, skip do
		local title, level = select(j, ...)
		if title and level and level ~= -1 then
			_G["GossipTitleButton"..i]:SetText("["..level.."] "..title)
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