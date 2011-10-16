﻿-- Engines
local S, _, _, DB = unpack(select(2, ...))

local CollapseAll = CreateFrame("Button", nil, QuestLogFrame)
CollapseAll:SetWidth(100)
CollapseAll:SetHeight(25)
S.Reskin(CollapseAll)
CollapseAll:SetPoint("TOP", -80, -40)
CollapseAll:SetScript("OnClick", function() CollapseQuestHeader(0) end)
CollapseAll.Text = S.MakeFontString(CollapseAll, 12)
CollapseAll.Text:SetPoint("CENTER")
CollapseAll.Text:SetText("全部收起")

local ExpandAll = CreateFrame("Button", nil, QuestLogFrame)
ExpandAll:SetWidth(100)
ExpandAll:SetHeight(25)
S.Reskin(ExpandAll)
ExpandAll:SetPoint("TOP", 80, -40)
ExpandAll:SetScript("OnClick", function() ExpandQuestHeader(0) end)
ExpandAll.Text = S.MakeFontString(ExpandAll, 12)
ExpandAll.Text:SetPoint("CENTER")
ExpandAll.Text:SetText("全部展开")