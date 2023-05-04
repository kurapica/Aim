--========================================================--
--                Aim                                     --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2020/12/11                              --
--========================================================--

--========================================================--
Scorpio           "Aim"                              "1.0.0"
--========================================================--

namespace "Aim"

import "System.Reactive"

-----------------------------------------------------------
-- Template Class
-----------------------------------------------------------
__Sealed__()
class "NamePlateUnitFrame" { Scorpio.Secure.InSecureUnitFrame }

-----------------------------------------------------------
-- Addon Event Handler
-----------------------------------------------------------
_Hooked                         = {}
_VerticalScale                  = 1
_HorizontalScale                = 1

__Async__()
function OnEnable()
    if not IsAddOnLoaded("Blizzard_NamePlates") then
        while NextEvent("ADDON_LOADED") ~= "Blizzard_NamePlates" do end
        Next()
    end

    if Scorpio.IsRetail then
        -- _G.NamePlateDriverFrame:UnregisterAllEvents()
        for k in pairs(_G) do
            if type(k) == "string" and k:match("^ClassNameplateBar%w+Frame$") then
                _G[k]:UnregisterAllEvents()
            end
        end

        _G.DeathKnightResourceOverlayFrame:UnregisterAllEvents()

        _G.ClassNameplateManaBarFrame:UnregisterAllEvents()
        _G.ClassNameplateManaBarFrame:Hide()
        _G.NamePlateDriverFrame:SetClassNameplateManaBar(nil)
        _G.NamePlateDriverFrame:SetClassNameplateBar(nil)
        --_G.NamePlateTargetResourceFrame:UnregisterAllEvents()
        --_G.NamePlatePlayerResourceFrame:UnregisterAllEvents()

        SetCVar("showQuestTrackingTooltips", "1")
    end

    _M:SecureHook(_G.NamePlateDriverFrame, "UpdateNamePlateOptions")
    _M:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateCreated")

    UpdateNamePlateOptions()
end

function UpdateNamePlateOptions()
    --[[ @todo support later, maybe just leave it
    _VerticalScale              = tonumber(GetCVar("NamePlateVerticalScale")) or 1
    _HorizontalScale            = tonumber(GetCVar("NamePlateHorizontalScale")) or 1

    if _VerticalScale < 1   then _VerticalScale = 1 end
    if _HorizontalScale < 1 then _HorizontalScale = 1 end--]]
end

__Async__()
function OnNamePlateCreated(self, base)
    Next()

    repeat
        local frame             = base.UnitFrame
        if frame and not _Hooked[frame] then
            _Hooked[frame]      = true
            frame:Hide()
            frame:SetAlpha(0)
            frame:HookScript("OnShow", frame.Hide)
        end

        Next()
    until frame
end

__SystemEvent__()
function NAME_PLATE_UNIT_ADDED(unit)
    local base                  = C_NamePlate.GetNamePlateForUnit(unit)
    if UnitIsUnit("player", unit) then unit = "player" end

    NamePlateUnitFrame("AimNamePlate", base).Unit = unit
end

__SystemEvent__()
function NAME_PLATE_UNIT_REMOVED(unit)
    local base                  = C_NamePlate.GetNamePlateForUnit(unit)
    NamePlateUnitFrame("AimNamePlate", base).Unit = nil
end