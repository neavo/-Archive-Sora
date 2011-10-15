--公会
CHAT_GUILD_GET = "|Hchannel:GUILD|h[公会]|h %s: "
CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官员]|h %s: "

--团队
CHAT_RAID_GET = "|Hchannel:RAID|h[团队]|h %s: "
CHAT_RAID_WARNING_GET = "[通知] %s: "
CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[团长]|h %s: "

--队伍
CHAT_PARTY_GET = "|Hchannel:PARTY|h[队伍]|h %s: "
CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|h[队长]|h %s: "
CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|h[向导]:|h %s: "

--战场
CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[战场]|h %s: "
CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[领袖]|h %s: "

--密语  
CHAT_WHISPER_INFORM_GET = "发送给%s: "
CHAT_WHISPER_GET = "%s悄悄话: "
CHAT_BN_WHISPER_INFORM_GET = "发送给%s "
CHAT_BN_WHISPER_GET = "悄悄话%s "

--说 / 喊
CHAT_SAY_GET = "%s: "
CHAT_YELL_GET = "%s: "  

--flags
CHAT_FLAG_AFK = "[暂离] "
CHAT_FLAG_DND = "[勿扰] "
CHAT_FLAG_GM = "[GM] "

for i = 1, NUM_CHAT_WINDOWS do
	if i ~= 2 then
		local ChatFrame = _G["ChatFrame"..i]
		local CA = ChatFrame.AddMessage
		ChatFrame.AddMessage = function(frame, text, ...)
		return CA(frame, text:gsub("|h%[(%d+)%. .-%]|h", "|h%1|h"), ...)
		end
	end
end 

--按TAB切換頻道.如果是在密語頻道則循環前面密過的人名,SHIFT+TAB反序切换频道
function ChatEdit_CustomTabPressed(self)
	if  (self:GetAttribute("chatType") == "SAY")  then
		if (GetNumPartyMembers()>0) then
			self:SetAttribute("chatType", "PARTY");
			ChatEdit_UpdateHeader(self);
		elseif (GetNumRaidMembers()>0) then
			self:SetAttribute("chatType", "RAID");
			ChatEdit_UpdateHeader(self);
		elseif (GetNumBattlefieldScores()>0) then
			self:SetAttribute("chatType", "BATTLEGROUND");
			ChatEdit_UpdateHeader(self);
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self);
		else
			return;
		end
	elseif (self:GetAttribute("chatType") == "PARTY") then
		if (GetNumRaidMembers()>0) then
			self:SetAttribute("chatType", "RAID");
			ChatEdit_UpdateHeader(self);
		elseif (GetNumBattlefieldScores()>0) then
			self:SetAttribute("chatType", "BATTLEGROUND");
			ChatEdit_UpdateHeader(self);
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self);
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end			
	elseif (self:GetAttribute("chatType") == "RAID") then
		if (GetNumBattlefieldScores()>0) then
			self:SetAttribute("chatType", "BATTLEGROUND");
			ChatEdit_UpdateHeader(self);
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self);
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end
	elseif (self:GetAttribute("chatType") == "BATTLEGROUND") then
		if (IsInGuild) then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self);
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end
	elseif (self:GetAttribute("chatType") == "GUILD") then
		self:SetAttribute("chatType", "SAY");
		ChatEdit_UpdateHeader(self);
	elseif (self:GetAttribute("chatType") == "CHANNEL") then
		if (GetNumPartyMembers()>0) then
			self:SetAttribute("chatType", "PARTY");
			ChatEdit_UpdateHeader(self);
		elseif (GetNumRaidMembers()>0) then
			self:SetAttribute("chatType", "RAID");
			ChatEdit_UpdateHeader(self);
		elseif (GetNumBattlefieldScores()>0) then
			self:SetAttribute("chatType", "BATTLEGROUND");
			ChatEdit_UpdateHeader(self);
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self);
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end
	end
end
