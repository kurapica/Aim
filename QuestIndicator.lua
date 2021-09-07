--========================================================--
--                Aim Quest Indicator                     --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2020/12/11                              --
--========================================================--

if not Scorpio.IsRetail then return end

--========================================================--
Scorpio           "Aim.Indicator.Quest"              "1.0.0"
--========================================================--

_QuestLog                       = {}
_WorldQuest                     = {}
_QuestSubject                   = System.Reactive.Subject()

-----------------------------------------------------------
-- Addon Event Handler
-----------------------------------------------------------
function OnEnable()
    for _, task in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(MapUtil.GetDisplayableMapForPlayer())) do
        if task.inProgress then
            local name          = C_TaskQuest.GetQuestInfoByQuestID(task.questId)
            if name then _WorldQuest[name] = task.questId end
        end
    end
end

__SystemEvent__()
function QUEST_ACCEPTED(questId)
    if QuestUtils_IsQuestWorldQuest(questId) then
        local name              = C_TaskQuest.GetQuestInfoByQuestID(questId)
        if name then
            _WorldQuest[name]   = questId
            Next(RefreshAllQuestMark)
        end
    end
end

__SystemEvent__()
function QUEST_REMOVED(questId)
    local name = C_TaskQuest.GetQuestInfoByQuestID(questId)
    if name then
        _WorldQuest[name] = nil
        Next(RefreshAllQuestMark)
    end
end

__SystemEvent__()
function QUEST_LOG_UPDATE()
    _M:UnregisterEvent("QUEST_LOG_UPDATE")
    UpdateQuestLog()
end

__SystemEvent__()
function UNIT_QUEST_LOG_CHANGED(unit)
    if unit == "player" then
        Next(UpdateQuestLog, true)
    end
end

function UpdateQuestLog(forceRefresh)
    wipe(_QuestLog)

    for i = 1, C_QuestLog.GetNumQuestLogEntries() do
        local questID           = C_QuestLog.GetQuestIDForLogIndex(i) or 0
        if questID > 0 then
            _QuestLog[C_QuestLog.GetTitleForLogIndex(i)] = true
        end
    end

    if forceRefresh then
        return RefreshAllQuestMark()
    end
end

function RefreshAllQuestMark()
    _QuestSubject:OnNext("any")
end

--- Whether the unit is a task target
__AutoCache__() __Static__()
function Wow.UnitIsTaskTarget()
    return Wow.FromUnitEvent(_QuestSubject):Map(function(unit)
        if UnitIsPlayer(unit) then return unit, false, false end

        local player            = UnitName("player")
        local isQuest, isOtherQuest, isFullfiled

        for i, text in Scorpio.GetGameTooltipLines("Unit", unit) do
            if i > 2 then
                if _WorldQuest[text] then
                    local progress = C_TaskQuest.GetQuestProgressBarInfo(_WorldQuest[text])
                    if progress then
                        if progress < 100 then
                            return unit, true, false
                        else
                            isFullfiled = true
                        end
                    end
                end

                if _QuestLog[text] then isQuest = _QuestLog[text] end

                local name, progress = text:match("^%s*(%S-)%s*%-%s*(.+)$")

                if progress then
                    if (not name or name == "" or name == player) then
                        local x, y = progress:match("(%d+)/(%d+)")
                        if x and y then
                            if tonumber(y) > tonumber(x) then
                                return unit, true, false
                            else
                                isFullfiled = true
                            end
                        end
                    else
                        local x, y = progress:match("(%d+)/(%d+)")
                        if x and y then
                            if tonumber(y) > tonumber(x) then
                                isOtherQuest = true
                            end
                        else
                            isOtherQuest = true
                        end
                    end
                else
                    local x, y = text:match("(%d+)/(%d+)")
                    if x and y then
                        if tonumber(y) > tonumber(x) then
                            return unit, true, false
                        else
                            isFullfiled = true
                        end
                    end
                end
            end
        end

        if (isQuest and not isFullfiled) or isOtherQuest then
            return unit, true, true
        end

        return unit, false, false
    end)
end

-----------------------------------------------------------
-- Indicator
-----------------------------------------------------------
__Sealed__() __ChildProperty__(NamePlateUnitFrame, "QuestMark")
class "QuestMark"               { Texture }

------------------------------------------------------------
--                     Default Style                      --
------------------------------------------------------------
Style.UpdateSkin("Default",     {
    [QuestMark]                 = {
        atlas                   = {
            atlas               = "QuestNormal",
            useAtlasSize        = true,
        },
        visible                 = Wow.UnitIsTaskTarget():Map(function(unit, hastask, isMemberQuest) return hastask end),
        desaturated             = Wow.UnitIsTaskTarget():Map(function(unit, hastask, isMemberQuest) return isMemberQuest end),
    }
})