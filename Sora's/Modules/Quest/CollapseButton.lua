-- Engines
local S, _, _, DB = unpack(select(2, ...))

local CollapseAll = S.MakeButton(QuestLogFrame)
CollapseAll:SetSize(100, 25)
CollapseAll:SetPoint("TOP", -80, -40)
CollapseAll:SetScript("OnClick", function() CollapseQuestHeader(0) end)
CollapseAll.Text = S.MakeFontString(CollapseAll, 12)
CollapseAll.Text:SetPoint("CENTER")
CollapseAll.Text:SetText("全部收起")

local ExpandAll = S.MakeButton(QuestLogFrame)
ExpandAll:SetSize(100, 25)
ExpandAll:SetPoint("TOP", 80, -40)
ExpandAll:SetScript("OnClick", function() ExpandQuestHeader(0) end)
ExpandAll.Text = S.MakeFontString(ExpandAll, 12)
ExpandAll.Text:SetPoint("CENTER")
ExpandAll.Text:SetText("全部展开")
