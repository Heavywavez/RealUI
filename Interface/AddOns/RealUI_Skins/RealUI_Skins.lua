local _, private = ...

-- Lua Globals --
local _G = _G
--local next = _G.next

-- RealUI --
local Skins = {}
private.Skins = Skins
_G.RealUI_Skins = Skins

local isInGlue = _G.InGlue()
private.isInGlue = isInGlue
local debug = isInGlue and _G.RealUIDebug or _G.nop
private.debug = debug

local screenResolutions = {_G.GetScreenResolutions()}
local function UpdateUISize()
    local uiHieght = screenResolutions[_G.GetCurrentResolution()]:match("%d+x(%d+)")
    private.uiScale = 768 / uiHieght
    private.uiMod = uiHieght / 768
    debug("UpdateUISize", uiHieght, private.uiScale, private.uiMod)
end
UpdateUISize()

function Skins:ModValue(value)
    return _G.floor(value * private.uiMod + 0.5)
end

local uiScale = private.uiScale
if uiScale < .64 or isInGlue then
    (_G.UIParent or _G.GlueParent):SetScale(uiScale)
elseif uiScale ~= _G.tonumber(_G.GetCVar("uiScale")) then
    _G.SetCVar("useUiScale", 1)
    _G.SetCVar("uiScale", uiScale)
end
