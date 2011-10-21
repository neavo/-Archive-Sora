--如需要显示中文，请注意文件编码格式UTF-8

setting = {
	EnableExecute = true,	--开启斩杀提示
	OnlyShowBoss = true,	--仅显示Boss的斩杀提示
	AutoThreshold = true,	--根据职业自动判断斩杀阶段
	ExecuteThreshold = 0.2, --斩杀阶段血量
}

texts = {
	EnterCombat = {
		"进入战斗！",
		},
	LeaveCombat = {
		"脱离战斗！",
		},
	ExecutePhase = {
		"斩杀！",
		},
}

class = {
	["WARRIOR"] = { 0.2, 0.2, 0}, --每个职业每个天赋的斩杀阶段血量，统计可能不准确，0即为不显示，3个数字依次是3系天赋
	["DRUID"] = { 0, 0.25, 0.25},
	["PALADIN"] = { 0, 0, 0.2},
	["PRIEST"] = { 0, 0, 0.25},
	["DEATHKNIGHT"] = { 0, 0.35, 0},
	["WARLOCK"] = { 0.25, 0.25, 0.25},
	["ROGUE"] = { 0.35, 0, 0},
	["HUNTER"] = { 0.2, 0.2, 0.2},
	["MAGE"] = { 0, 0.35, 0},
	["SHAMAN"] = { 0, 0, 0},	
}



local MyAddon = CreateFrame("Frame")
local imsg = CreateFrame("Frame", "CombatAlert")
imsg:SetSize(418, 72)
imsg:SetPoint("TOP", 0, -190)
imsg:Hide()
imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
imsg.bg:SetPoint('BOTTOM')
imsg.bg:SetSize(326, 103)
imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
imsg.bg:SetVertexColor(1, 1, 1, 0.6)

imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
imsg.lineTop:SetPoint("TOP")
imsg.lineTop:SetSize(418, 7)
imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
imsg.lineBottom:SetPoint("BOTTOM")
imsg.lineBottom:SetSize(418, 7)
imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

imsg.text = imsg:CreateFontString(nil, 'ARTWORK', 'GameFont_Gigantic')
imsg.text:SetPoint("BOTTOM", 0, 12)
imsg.text:SetTextColor(1, 0.82, 0)
imsg.text:SetJustifyH("CENTER")

local flag = 0
ExecuteThreshold =  setting.ExecuteThreshold
local function ShowAlert(texts)
	CombatAlert.text:SetText(texts[math.random(1,table.getn(texts))])
	CombatAlert:Show()
end

MyAddon:RegisterEvent("PLAYER_REGEN_ENABLED")
MyAddon:RegisterEvent("PLAYER_REGEN_DISABLED")
if setting.EnableExecute then
	MyAddon:RegisterEvent("UNIT_HEALTH")
	MyAddon:RegisterEvent("PLAYER_TARGET_CHANGED")
end
if setting.AutoThreshold then
	MyAddon:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	MyAddon:RegisterEvent("PLAYER_ENTERING_WORLD")
end

MyAddon:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		ShowAlert(texts.EnterCombat)
		flag = 0
	elseif event == "PLAYER_REGEN_ENABLED" then
		ShowAlert(texts.LeaveCombat)
		flag = 0
	elseif event == "PLAYER_TARGET_CHANGED" then
		flag = 0
	elseif event == "UNIT_HEALTH" then
		if (UnitName("target") and UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < ExecuteThreshold ) and flag == 0 ) then
			if ((setting.OnlyShowBoss and UnitLevel("target")==-1) or ( not setting.OnlyShowBoss)) then 
				ShowAlert(texts.ExecutePhase)
				flag = 1
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		ExecuteThreshold = class[select(2, UnitClass("player"))][GetPrimaryTalentTree() or 1]
	end	
end)
local timer = 0
imsg:SetScript("OnShow", function(self)
	timer = 0
	self:SetScript("OnUpdate", function(self, elasped)
		timer = timer + elasped
		if (timer<0.5) then self:SetAlpha(timer*2) end
		if (timer>1 and timer<1.5) then self:SetAlpha(1-(timer-1)*2) end
		if (timer>=1.5 ) then self:Hide() end
	end)
end)