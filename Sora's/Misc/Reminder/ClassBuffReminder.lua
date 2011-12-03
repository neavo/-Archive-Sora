----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.RDConfig

local ClassBuff, BuffFrame = {}, {}

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("UNIT_AURA")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_REGEN_DISABLED")
Event:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
Event:SetScript("OnEvent",function(self, event, unit, ...)
	
	if event == "UNIT_AURA" and unit ~= "player" then 
		return
	end
	
	-- 初始化Buff列表
	if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local _, Class =  UnitClass("player")
		ClassBuff = cfg.ClassBuffList[Class][GetPrimaryTalentTree() or 1]
		
		for key,value in pairs(ClassBuff) do
		
			local Temp = CreateFrame("Frame", nil, UIParent)
			Temp:SetWidth(cfg.ClassBuffSize)
			Temp:SetHeight(cfg.ClassBuffSize)
			
			Temp.Border = CreateFrame("Frame", nil, Temp)
			Temp.Border:SetAllPoints(Temp)
			Temp.Border:SetBackdrop({
				edgeFile = cfg.Solid, edgeSize = 1,
			})
			Temp.Border:SetBackdropBorderColor(0, 0, 0, 1)
			Temp.Border:SetFrameLevel(2)
			
			Temp.Shadow = CreateFrame("Frame", nil, Temp)
			Temp.Shadow:SetPoint("TOPLEFT", Temp, "TOPLEFT", 4, -5)
			Temp.Shadow:SetPoint("BOTTOMRIGHT", Temp, "BOTTOMRIGHT", 4, -5)
			Temp.Shadow:SetBackdrop({
				edgeFile = cfg.GlowTex, edgeSize = 5,
			})
			Temp.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
			Temp.Shadow:SetFrameLevel(0)
			
			Temp.Texture = Temp:CreateTexture(nil, "ARTWORK")
			Temp.Texture:SetAllPoints()
			
			Temp.Text = Temp:CreateFontString(nil, "ARTWORK")
			Temp.Text:SetFont(cfg.Font, 16, "THINOUTLINE")
			Temp.Text:SetPoint("TOP", Temp, "BOTTOM", 0, -10)

			if key == 1 then
				Temp:SetPoint(unpack(cfg.ClassBuffPos))
			else
				Temp:SetPoint("LEFT", BuffFrame[key-1], "RIGHT", cfg.ClassBuffSpace, 0)
			end

			Temp:SetAlpha(0)	
			table.insert(BuffFrame,Temp)
		end
	end
	
	-- 声音提示
	if event == "PLAYER_REGEN_DISABLED" then
		for _,value in pairs(BuffFrame) do
			value:SetAlpha(0)
		end
		local i = 0
		for key,value in pairs(ClassBuff) do
			local flag = 0
			for _,temp in pairs(value) do
				local Name, _, Icon = select(1, GetSpellInfo(temp))
				if UnitAura("player", Name) then
					flag = 1
				end
			end
			if flag == 0 then
				local Name, _, Icon = select(1, GetSpellInfo(value[1]))
				i = i + 1
				BuffFrame[i].Texture:SetTexture(Icon)
				BuffFrame[i].Texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
				BuffFrame[i].Text:SetText(format("缺少：%s",Name))
				BuffFrame[i]:SetAlpha(1)
			end
		end
		if i ~= 0 and cfg.ClassBuffSound then
			PlaySoundFile(cfg.Warning)			
		end
	end
	
	-- 生成Buff缺失提示
	for _,value in pairs(BuffFrame) do
		value:SetAlpha(0)
	end
	local i = 0
	for key,value in pairs(ClassBuff) do
		local flag = 0
		for _,temp in pairs(value) do
			local Name, _, Icon = select(1, GetSpellInfo(temp))
			if UnitAura("player", Name) then
				flag = 1
			end
		end
		if flag == 0 then
			local Name, _, Icon = select(1, GetSpellInfo(value[1]))
			i = i + 1
			BuffFrame[i].Texture:SetTexture(Icon)
			BuffFrame[i].Texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			BuffFrame[i].Text:SetText(format("%s",Name))
			BuffFrame[i]:SetAlpha(1)
		end
	end

end)