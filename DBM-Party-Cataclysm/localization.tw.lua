if GetLocale() ~= "zhTW" then return end

local L

-------------------------
--  Blackrock Caverns  --
--------------------------
-- Rom'ogg Bonecrusher --
--------------------------
L = DBM:GetModLocalization("Romogg")

L:SetGeneralLocalization({
	name = "羅姆歐格·裂骨者"
})

-------------------------------
-- Corla, Herald of Twilight --
-------------------------------
L = DBM:GetModLocalization("Corla")

L:SetGeneralLocalization({
	name = "柯爾菈，暮光信使"
})

L:SetWarningLocalization({
	WarnAdd		= "小怪被釋放了"
})

L:SetOptionLocalization({
	WarnAdd		= "當一隻小怪丟棄$spell:75608增益時警告"
})

-----------------------
-- Karsh SteelBender --
-----------------------
L = DBM:GetModLocalization("KarshSteelbender")

L:SetGeneralLocalization({
	name = "卡爾許·控鋼者"
})

L:SetTimerLocalization({
	TimerSuperheated 	= "極灸水銀護甲 (%d)"	-- should work, no need for translation :)
})

L:SetOptionLocalization({
	TimerSuperheated	= "為$spell:75846顯示持續時間計時器"
})

------------
-- Beauty --
------------
L = DBM:GetModLocalization("Beauty")

L:SetGeneralLocalization({
	name = "美麗"
})

-----------------------------
-- Ascendant Lord Obsidius --
-----------------------------
L = DBM:GetModLocalization("AscendantLordObsidius")

L:SetGeneralLocalization({
	name = "卓越者領主奧希迪厄斯"
})

L:SetOptionLocalization({
	SetIconOnBoss	= "$spell:76200後標記首領"
})

---------------------
--  The Deadmines  --
---------------------
-- Glubtok --
-------------
L = DBM:GetModLocalization("Glubtok")

L:SetGeneralLocalization({
	name = "格魯巴托克"
})

-----------------------
-- Helix Gearbreaker --
-----------------------
L = DBM:GetModLocalization("Helix")

L:SetGeneralLocalization({
	name = "赫利克斯•碎輪者"
})

---------------------
-- Foe Reaper 5000 --
---------------------
L = DBM:GetModLocalization("FoeReaper")

L:SetGeneralLocalization({
	name = "敵人收割者5000"
})

L:SetOptionLocalization{
	HarvestIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(88495)
}

----------------------
-- Admiral Ripsnarl --
----------------------
L = DBM:GetModLocalization("Ripsnarl")

L:SetGeneralLocalization({
	name = "利普斯納爾上將"
})

----------------------
-- "Captain" Cookie --
----------------------
L = DBM:GetModLocalization("Cookie")

L:SetGeneralLocalization({
	name = "『隊長』餅乾"
})

----------------------
-- Vanessa VanCleef --
----------------------
L = DBM:GetModLocalization("Vanessa")

L:SetGeneralLocalization({
	name = "凡妮莎·范克里夫"
})

L:SetTimerLocalization({
	achievementGauntlet	= "充滿活力"
})

------------------
--  Grim Batol  --
---------------------
-- General Umbriss --
---------------------
L = DBM:GetModLocalization("GeneralUmbriss")

L:SetGeneralLocalization({
	name = "昂布里斯將軍"
})

L:SetOptionLocalization{
	PingBlitz	= "當昂布里斯將軍即將閃擊你時點擊小地圖"
}

L:SetMiscLocalization{
	Blitz		= "將目光注射|cFFFF0000(%S+)"
}

--------------------------
-- Forgemaster Throngus --
--------------------------
L = DBM:GetModLocalization("ForgemasterThrongus")

L:SetGeneralLocalization({
	name = "鍛造大師瑟隆葛斯"
})

-------------------------
-- Drahga Shadowburner --
-------------------------
L = DBM:GetModLocalization("DrahgaShadowburner")

L:SetGeneralLocalization({
	name = "德拉卡·燃影者"
})

L:SetMiscLocalization{
	ValionaYell	= "龍啊，聽我命令! 抓住我!",	-- translate -- Yell when Valiona is incoming
	Add		= "%s進行",
	Valiona		= "瓦莉歐娜"
}

------------
-- Erudax --
------------
L = DBM:GetModLocalization("Erudax")

L:SetGeneralLocalization({
	name = "伊魯達克斯"
})

----------------------------
--  Halls of Origination  --
----------------------------
-- Temple Guardian Anhuur --
----------------------------
L = DBM:GetModLocalization("TempleGuardianAnhuur")

L:SetGeneralLocalization({
	name = "神殿守護者安胡爾"
})

---------------------
-- Earthrager Ptah --
---------------------
L = DBM:GetModLocalization("EarthragerPtah")

L:SetGeneralLocalization({
	name = "地怒者普塔"
})

L:SetMiscLocalization{
	Kill		= "普塔...不再...存在..."
}

--------------
-- Anraphet --
--------------
L = DBM:GetModLocalization("Anraphet")

L:SetGeneralLocalization({
	name = "安拉斐特"
})

L:SetTimerLocalization({
	achievementGauntlet	= "勝過光速"
})

L:SetMiscLocalization({
	Brann				= "好了，快走吧!只需要把最後的登錄程序輸入到門的機關中….然後…"
})

------------
-- Isiset --
------------
L = DBM:GetModLocalization("Isiset")

L:SetGeneralLocalization({
	name = "伊希賽特"
})

L:SetWarningLocalization({
	WarnSplitSoon	= "分裂 即將到來"
})

L:SetOptionLocalization({
	WarnSplitSoon	= "為分裂顯示預先警告"
})

-------------
-- Ammunae --
------------- 
L = DBM:GetModLocalization("Ammunae")

L:SetGeneralLocalization({
	name = "安姆內"
})

-------------
-- Setesh  --
------------- 
L = DBM:GetModLocalization("Setesh")

L:SetGeneralLocalization({
	name = "賽特胥"
})

----------
-- Rajh --
----------
L = DBM:GetModLocalization("Rajh")

L:SetGeneralLocalization({
	name = "拉頡"
})

--------------------------------
--  Lost City of the Tol'vir  --
--------------------------------
-- General Husam --
-------------------
L = DBM:GetModLocalization("GeneralHusam")

L:SetGeneralLocalization({
	name = "胡薩姆將軍"
})

------------------------------------
-- Siamat, Lord of the South Wind --
------------------------------------
L = DBM:GetModLocalization("Siamat")

L:SetGeneralLocalization({
	name = "希亞梅特"		-- "Siamat, Lord of the South Wind" --> Real name is too long :((
})

L:SetWarningLocalization{
	specWarnPhase2Soon	= "5秒後進入第2階段"
}

L:SetTimerLocalization({
	timerPhase2 	= "第2階段開始"
})

L:SetOptionLocalization{
	specWarnPhase2Soon	= "當第2階段即將到來(5秒)時顯示特別警告",
	timerPhase2 	= "為第2階段開始顯示計時器"
}

------------------------
-- High Prophet Barim --
------------------------
L = DBM:GetModLocalization("HighProphetBarim")

L:SetGeneralLocalization({
	name = "高階預言者巴瑞姆"
})

L:SetOptionLocalization{
	BossHealthAdds	= "在首領血量框架顯示小怪血量"	-- translate
}

L:SetMiscLocalization{
	BlazeHeavens		= "天之燃炎",	-- translate
	HarbringerDarkness	= "黑暗先驅者"	-- translate
}

--------------
-- Lockmaw --
--------------
L = DBM:GetModLocalization("Lockmaw")

L:SetGeneralLocalization({
	name = "鎖喉"
})

L:SetOptionLocalization{
	RangeFrame	= "顯示距離框 (5碼)"		-- translate
}

----------
-- Augh --
----------
L = DBM:GetModLocalization("Augh")

L:SetGeneralLocalization({
	name = "奧各"		-- translate
})

-----------------------
--  Shadowfang Keep  --
-----------------------
-- Baron Ashbury --
-------------------
L = DBM:GetModLocalization("Ashbury")

L:SetGeneralLocalization({
	name = "艾胥柏利男爵"
})

-----------------------
-- Baron Silverlaine --
-----------------------
L = DBM:GetModLocalization("Silverlaine")

L:SetGeneralLocalization({
	name = "席瓦萊恩男爵"
})

--------------------------
-- Commander Springvale --
--------------------------
L = DBM:GetModLocalization("Springvale")

L:SetGeneralLocalization({
	name = "指揮官斯普林瓦爾"
})

L:SetTimerLocalization({
	TimerAdds		= "下批小怪"
})

L:SetOptionLocalization{
	TimerAdds		= "為下一批小怪顯示計時器"
}

L:SetMiscLocalization{
	YellAdds		= "趕走入侵者!"
}

-----------------
-- Lord Walden --
-----------------
L = DBM:GetModLocalization("Walden")

L:SetGeneralLocalization({
	name = "瓦爾登領主"
})

L:SetWarningLocalization{
	specWarnCoagulant	= "綠色混合 - 不斷移動!",	-- Green light
	specWarnRedMix		= "紅色混合 - 不要移動!"		-- Red light
}

L:SetOptionLocalization{
	RedLightGreenLight	= "為紅/綠色移動方式顯示特別警告"
}

------------------
-- Lord Godfrey --
------------------
L = DBM:GetModLocalization("Godfrey")

L:SetGeneralLocalization({
	name = "高佛雷領主"
})

L:SetWarningLocalization{
}

L:SetOptionLocalization{
}

---------------------
--  The Stonecore  --
---------------------
-- Corborus --
-------------- 
L = DBM:GetModLocalization("Corborus")

L:SetGeneralLocalization({
	name = "寇伯拉斯"
})

L:SetWarningLocalization({
	WarnEmerge	= "鑽出地面",
	WarnSubmerge	= "鑽進地裡"
})

L:SetTimerLocalization({
	TimerEmerge	= "下一次 鑽出地面",
	TimerSubmerge	= "下一次 鑽進地裡"
})

L:SetOptionLocalization({
	WarnEmerge	= "為鑽出地面顯示警告",
	WarnSubmerge	= "為鑽進地裡顯示警告",
	TimerEmerge	= "為鑽出地面顯示計時器",
	TimerSubmerge	= "為鑽進地裡顯示計時器",
	CrystalArrow	= "當你附近的人中了$spell:81634時顯示DBM箭頭",
	RangeFrame	= "顯示距離框 (5碼)"
})

-----------
-- Ozruk --
----------- 
L = DBM:GetModLocalization("Ozruk")

L:SetGeneralLocalization({
	name = "歐茲魯克"
})

--------------
-- Slabhide --
-------------- 
L = DBM:GetModLocalization("Slabhide")

L:SetGeneralLocalization({
	name = "岩革"
})

L:SetWarningLocalization({
	WarnAirphase			= "空中階段",
	WarnGroundphase			= "地上階段",
	specWarnCrystalStorm		= "水晶風暴 - 找掩護"
})

L:SetTimerLocalization({
	TimerAirphase			= "下一次 空中階段",
	TimerGroundphase		= "下一次 地上階段"
})

L:SetOptionLocalization({
	WarnAirphase			= "當岩革升空時顯示警告",
	WarnGroundphase			= "當岩革降落時顯示警告",
	TimerAirphase			= "為下一次 空中階段顯示計時器",
	TimerGroundphase		= "為下一次 地上階段顯示計時器",
	specWarnCrystalStorm		= "為$spell:92265顯示特別警告"
})

-------------------------
-- High Priestess Azil --
------------------------
L = DBM:GetModLocalization("HighPriestessAzil")

L:SetGeneralLocalization({
	name = "高階祭司艾吉兒"
})

---------------------------
--  The Vortex Pinnacle  --
---------------------------
-- Grand Vizier Ertan --
------------------------
L = DBM:GetModLocalization("GrandVizierErtan")

L:SetGeneralLocalization({
	name = "首相伊爾丹"
})

L:SetMiscLocalization{
	Retract		= "%s收起了他的颶風之盾!"
}

--------------
-- Altairus --
-------------- 
L = DBM:GetModLocalization("Altairus")

L:SetGeneralLocalization({
	name = "艾塔伊洛斯"
})

L:SetOptionLocalization({
	BreathIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(88308)
})

-----------
-- Asaad --
-----------
L = DBM:GetModLocalization("Asaad")

L:SetGeneralLocalization({
	name = "亞沙德"
})

L:SetOptionLocalization({
	SpecWarnStaticCling	= "為$spell:87618顯示特別警告"
})

L:SetWarningLocalization({
	SpecWarnStaticCling	= "快跳!"
})

---------------------------
--  The Throne of Tides  --
---------------------------
-- Lady Naz'jar --
------------------ 
L = DBM:GetModLocalization("LadyNazjar")

L:SetGeneralLocalization({
	name = "納茲賈爾女士"
})

-----======-----------
-- Commander Ulthok --
---------------------- 
L = DBM:GetModLocalization("CommanderUlthok")

L:SetGeneralLocalization({
	name = "指揮官烏索克"
})

-------------------------
-- Erunak Stonespeaker --
-------------------------
L = DBM:GetModLocalization("ErunakStonespeaker")

L:SetGeneralLocalization({
	name = "伊魯納克·石語者"
})

------------
-- Ozumat --
------------ 
L = DBM:GetModLocalization("Ozumat")

L:SetGeneralLocalization({
	name = "歐蘇瑪特"
})

----------------
--  Zul'Aman  --
---------------
--  Nalorakk --
---------------
L = DBM:GetModLocalization("Nalorakk5")

L:SetGeneralLocalization{
	name = "納羅拉克(熊)"
}

L:SetWarningLocalization{
	WarnBear		= "熊形態",
	WarnBearSoon	= "5秒後 熊形態",
	WarnNormal		= "普通形態",
	WarnNormalSoon	= "5秒後 普通形態"
}

L:SetTimerLocalization{
	TimerBear		= "熊形態",
	TimerNormal		= "普通形態"
}

L:SetOptionLocalization{
	WarnBear		= "為熊形態顯示警告",--Translate
	WarnBearSoon	= "為熊形態顯示預先警告",--Translate
	WarnNormal		= "為普通形態顯示警告",--Translate
	WarnNormalSoon	= "為普通形態顯示預先警告",--Translate
	TimerBear		= "為熊形態顯示計時器",--Translate
	TimerNormal		= "為普通形態顯示計時器",
	InfoFrame		= "在資訊框架顯示中了$spell:42402的玩家"
}

L:SetMiscLocalization{
	YellBear 	= "你們既然將野獸召喚出來，就將付出更多的代價!",
	YellNormal	= "沒有人可以擋在納羅拉克的面前!",
	PlayerDebuffs	= "剛被衝鋒過"
}

---------------
--  Akil'zon --
---------------
L = DBM:GetModLocalization("Akilzon5")

L:SetGeneralLocalization{
	name = "阿奇爾森(鷹)"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	StormIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97300),
	RangeFrame	= "顯示距離框(10碼)",
	StormArrow	= "為$spell:97300顯示DBM箭頭",
	SetIconOnEagle	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97318)
}

L:SetMiscLocalization{
}

---------------
--  Jan'alai --
---------------
L = DBM:GetModLocalization("Janalai5")

L:SetGeneralLocalization{
	name = "賈納雷(龍鷹)"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	FlameIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(43140)
}

L:SetMiscLocalization{
	YellBomb	= "燒死你們!",
	YellHatchAll= "現在，讓我來告訴你們什麼叫數量優勢...",
	YellAdds	= "雌鷹哪裡去啦?快去孵蛋!"
}

--------------
--  Halazzi --
--------------
L = DBM:GetModLocalization("Halazzi5")

L:SetGeneralLocalization{
	name = "哈拉齊(山貓)"
}

L:SetWarningLocalization{
	WarnSpirit	= "靈魂階段",
	WarnNormal	= "普通階段"
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	WarnSpirit	= "為靈魂階段顯示警告",--Translate
	WarnNormal	= "為普通階段顯示警告"--Translate
}

L:SetMiscLocalization{
	YellSpirit	= "狂野的靈魂與我同在...",
	YellNormal	= "靈魂，回到我這裡來!"
}

--------------------------
--  Hex Lord Malacrass --
--------------------------
L = DBM:GetModLocalization("Malacrass5")

L:SetGeneralLocalization{
	name = "妖術領主瑪拉克雷斯"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
	TimerSiphon	= "%s: %s"
}

L:SetOptionLocalization{
	TimerSiphon	= "為$spell:43501顯示計時器"
}

L:SetMiscLocalization{
	YellPull	= "陰影將會降臨在你們頭上..."
}

-------------
-- Daakara --
-------------
L = DBM:GetModLocalization("Daakara")

L:SetGeneralLocalization{
	name = "達卡拉"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
	timerNextForm	= "下一次轉換形態"
}

L:SetOptionLocalization{
	timerNextForm	= "為轉換形態顯示計時器",
	InfoFrame		= "在資訊框架顯示中了$spell:42402的玩家",
	ThrowIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97639),
	ClawRageIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97672)
}

L:SetMiscLocalization{
	PlayerDebuffs	= "剛被衝鋒過"
}

-----------------
--  Zul'Gurub  --
-------------------------
-- High Priest Venoxis --
-------------------------
L = DBM:GetModLocalization("Venoxis")

L:SetGeneralLocalization{
	name = "高階祭司溫諾希斯"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	SetIconOnToxicLink	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(96477),
	LinkArrow		= "當你中了$spell:96477時顯示DBM箭頭"
}

L:SetMiscLocalization{
}

------------------------
-- Bloodlord Mandokir --
------------------------
L = DBM:GetModLocalization("Mandokir")

L:SetGeneralLocalization{
	name = "血領主曼多基爾"
}

L:SetWarningLocalization{
	WarnRevive		= "還剩餘 %d 救贖的靈魂",
	SpecWarnOhgan	= "奧根復活! 快擊殺!" -- check this, i'm not good at English
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	WarnRevive		= "通告還剩餘多少救贖的靈魂",
	SpecWarnOhgan	= "當奧根復活的時候顯示警告", -- check this, i'm not good at English
	SetIconOnOhgan	= "當奧根復活的時候給他設定標記"
}

L:SetMiscLocalization{
	Ohgan		= "奧根"
}

------------
-- Zanzil --
------------
L = DBM:GetModLocalization("Zanzil")

L:SetGeneralLocalization{
	name = "贊吉爾"
}

L:SetWarningLocalization{
	SpecWarnToxic	= "去點綠鍋"
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	SpecWarnToxic	= "當你沒有$spell:96328時顯示特別警告",
	InfoFrame		= "在資訊框架顯示沒有中$spell:96328的玩家",
	SetIconOnGaze	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(96342)
}

L:SetMiscLocalization{
	PlayerDebuffs	= "沒有點綠鍋"
}

----------------------------
-- High Priestess Kilnara --
----------------------------
L = DBM:GetModLocalization("Kilnara")

L:SetGeneralLocalization{
	name = "高階祭司基爾娜拉"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
	WaveAgony	= "感受我的痛苦!"
}

----------------------------
-- Jindo --
----------------------------
L = DBM:GetModLocalization("Jindo")

L:SetGeneralLocalization{
	name = "破神者金度"
}

L:SetWarningLocalization{
	WarnBarrierDown	= "哈卡之鏈被破壞 - 剩餘 %d/3"
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	WarnBarrierDown	= "當哈卡之鏈被破壞時顯示警告",
	BodySlamIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(97198)
}

L:SetMiscLocalization{
	Kill			= "你跨越了你的分際，金度。你觸碰了遠超越你的力量。你忘了我是誰嗎?你忘了我的能耐了嗎?" -- temporarily
}

----------------------
-- Cache of Madness --
----------------------
-------------
-- Gri'lek --
-------------
--L= DBM:GetModLocalization(603)

L = DBM:GetModLocalization("CoMGrilek")

L:SetGeneralLocalization{
	name = "格里雷克"
}

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

--			"<15.7> [MONSTER_EMOTE] CHAT_MSG_MONSTER_EMOTE#%s is chasing Bownd.#Gri'lek###Bownd##0#0##0#4672##0#false#false", -- [94]
L:SetMiscLocalization({
	pursuitEmote	= "%s is chasing"
})

---------------
-- Hazza'rah --
---------------
--L= DBM:GetModLocalization(604)

L = DBM:GetModLocalization("CoMGHazzarah")

L:SetGeneralLocalization{
	name = "哈札拉爾"
}

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

L:SetMiscLocalization({
})

--------------
-- Renataki --
--------------
--L= DBM:GetModLocalization(605)

L = DBM:GetModLocalization("CoMRenataki")

L:SetGeneralLocalization{
	name = "雷納塔基"
}

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

L:SetMiscLocalization({
})

---------------
-- Wushoolay --
---------------
--L= DBM:GetModLocalization(606)

L = DBM:GetModLocalization("CoMWushoolay")

L:SetGeneralLocalization{
	name = "烏蘇雷"
}

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

L:SetMiscLocalization({
})

--------------------
--  World Bosses  --
-------------------------
-- Akma'hat --
-------------------------
L = DBM:GetModLocalization("Akmahat")

L:SetGeneralLocalization{
	name = "阿克瑪哈特"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
}

-----------
-- Garr --
----------
L = DBM:GetModLocalization("Garr")

L:SetGeneralLocalization{
	name = "加爾 (Cata)"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
}

----------------
-- Julak-Doom --
----------------
L = DBM:GetModLocalization("JulakDoom")

L:SetGeneralLocalization{
	name = "毀滅祖拉克"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	SetIconOnMC	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(93621)
}

L:SetMiscLocalization{
}

-----------
-- Mobus --
-----------
L = DBM:GetModLocalization("Mobus")

L:SetGeneralLocalization{
	name = "莫比斯"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
}

-----------
-- Xariona --
-----------
L = DBM:GetModLocalization("Xariona")

L:SetGeneralLocalization{
	name = "克薩瑞歐納"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
}