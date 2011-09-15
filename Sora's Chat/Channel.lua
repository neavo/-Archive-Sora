



----==============================精简聊天频道,可修改汉字自定义==========================----

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

--================================公共频道和自定义频道精简================================--

local gsub = _G.string.gsub
local newAddMsg = {}
local chn, rplc
	rplc = {
		"[%1综合]",  
		"[%1交易]",   
		"[%1防务]",   
		"[%1组队]",   
		"[%1世界]",   
		"[%1招募]",
                "[%1世界]", 
                "[%1自定义]",    -- 自定义频道缩写请自行修改
	}

	chn = {
		"%[%d+%. General.-%]",
		"%[%d+%. Trade.-%]",
		"%[%d+%. LocalDefense.-%]",
		"%[%d+%. LookingForGroup%]",
		"%[%d+%. WorldDefense%]",
		"%[%d+%. GuildRecruitment.-%]",
                "%[%d+%. BigFootChannel.-%]",
                "%[%d+%. CustomChannel.-%]",       -- 自定义频道英文名随便填写
	}

	chn[1] = "%[%d+%. 综合.-%]"
	chn[2] = "%[%d+%. 交易.-%]"
	chn[3] = "%[%d+%. 本地防务.-%]"
	chn[4] = "%[%d+%. 寻求组队%]"
	chn[5] = "%[%d+%. 世界防务%]"	
	chn[6] = "%[%d+%. 公会招募.-%]"
	chn[7] = "%[%d+%. 大脚世界频道.-%]"
	chn[8] = "%[%d+%. 自定义频道.-%]"   -- 请修改频道名对应你游戏里的频道
				
				
				

local function AddMessage(frame, text, ...)
	for i = 1, 8 do	 -- 对应上面几个频道(如果有9个频道就for i = 1, 9 do)
		text = gsub(text, chn[i], rplc[i])
	end

	text = gsub(text, "%[(%d0?)%. .-%]", "%1.") 
	return newAddMsg[frame:GetName()](frame, text, ...)
end

for i = 1, 5 do
	if i ~= 2 then 
		local f = _G[format("%s%d", "ChatFrame", i)]
		newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
		f.AddMessage = AddMessage
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
