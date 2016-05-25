local ADDON_NAME, private = ...

-- Lua Globals --
local _G = _G
local next, ipairs = _G.next, _G.ipairs
local floor = _G.math.floor

-- RealUI --
local Mod, Skin = {}, {}
local isInGlue = _G.InGlue()
local Debug
if isInGlue then
    private.GlueXML = {}
    Debug = _G.RealUIDebug or _G.nop
else
    private.FrameXML = {}
    Debug = _G.RealUI and _G.RealUI.GetDebug("Skins") or _G.nop
end
local function debug(...)
    if private.debugEnabled then
        Debug(...)
    end
end
private.DebugXML = {}
private.AddOns = {}

_G.RealUI_Skins = {Mod = Mod, Skin = Skin}
private.Mod = Mod
private.Skin = Skin

private.isInGlue = isInGlue
private.debug = debug
private.classColor = { r = 0.0, g = 0.8 , b = 1.0, colorStr = "ff00ccff" }

-- debugMode: -1 == default | 0 == -1 + skin
--             1 == 0 + hidden frames | 2 == 1 - skin
local debugMode
if _G.IsAddOnLoaded("nibRealUI_Dev") then
    debugMode = 1
else
    debugMode = 0
end

local locale = _G.GAME_LOCALE or _G.GetLocale()
local fonts = {}
if locale == "koKR" then -- Korean
    fonts.normal = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKkr-Regular.otf]]
    fonts.chat = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKkr-Light.otf]]
    fonts.crit = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKkr-Bold.otf]]
    fonts.header = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKkr-Regular.otf]]
elseif locale == "zhCN" then -- Simplified Chinese
    fonts.normal = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKsc-Regular.otf]]
    fonts.chat = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKsc-Light.otf]]
    fonts.crit = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKsc-Bold.otf]]
    fonts.header = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKsc-Regular.otf]]
elseif locale == "zhTW" then -- Traditional Chinese
    fonts.normal = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKtc-Regular.otf]]
    fonts.chat = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKtc-Light.otf]]
    fonts.crit = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKtc-Bold.otf]]
    fonts.header = [[Interface\AddOns\nibRealUI\Fonts\NotoSansCJKtc-Regular.otf]]
else
    fonts.normal = [[Interface\AddOns\nibRealUI\Fonts\Roboto-Regular.ttf]]
    fonts.chat = [[Interface\AddOns\nibRealUI\Fonts\RobotoCondensed-Regular.ttf]]
    fonts.crit = [[Interface\AddOns\nibRealUI\Fonts\Roboto-BoldItalic.ttf]]
    fonts.header = [[Interface\AddOns\nibRealUI\Fonts\RobotoSlab-Regular.ttf]]
end

local defaults = {
    realUIScale = 1,
    fonts = fonts
}

local events = _G.CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(self, event, ...)
    if not isInGlue then
        debug(event, ...)
    end
    if events[event] then
        events[event](events, ...)
    else
        debug("GetScreenHeight", _G.GetScreenHeight())
        if not isInGlue then
            debug("UIParent:GetSize", _G.UIParent:GetSize())
            self:UnregisterEvent(event)
        end
    end
end)
function events:ADDON_LOADED(addonName)
    if addonName == ADDON_NAME then
        _G.RealUI_SkinsDB = _G.RealUI_SkinsDB or defaults

        local screenResolutions = {_G.GetScreenResolutions()}
        local uiHeight = screenResolutions[_G.GetCurrentResolution()]:match("%d+x(%d+)")
        local uiScale = 768 / uiHeight
        private.uiMod = (uiHeight / 768) * isInGlue and 1 or _G.RealUI_SkinsDB.realUIScale
        debug("UISize", uiHeight, uiScale, private.uiMod)
        private.uiScale = uiScale

        local parent = isInGlue and _G.GlueParent or _G.UIParent
        if uiScale < .64 or isInGlue then
            parent:SetScale(uiScale)
        elseif uiScale ~= _G.tonumber(_G.GetCVar("uiScale")) then
            _G.SetCVar("useUiScale", 1)
            _G.SetCVar("uiScale", uiScale)
        end

        if debugMode >= 0 then
            if debugMode >= 1 then
                for index, func in ipairs(private.DebugXML) do
                    func()
                end
            end
            if debugMode < 2 then
                local uiXML = private.GlueXML or private.FrameXML
                for index, func in ipairs(uiXML) do
                    func()
                end
            end
        end
    elseif addonName:match("Blizzard") then
        local func = private.AddOns[addonName]
        if func then
            func()
        end
    end
end
private.events = events

--[[ Point Modifications ]]--
local function ModValue(value)
    return floor(value * private.uiMod + 0.5)
end
Mod.Value = ModValue

function Mod.SetFont(self, fontFile, fontSize, fontFlags)
    local xOfs, yOfs = self:GetShadowOffset()
    if xOfs > 0 or yOfs > 0 then
        self:SetShadowOffset(ModValue(xOfs), ModValue(yOfs))
    end
    if not (fontFile and fontSize) then
        fontFile, fontSize, fontFlags = self:GetFont()
    end
    return self:SetFont(fontFile, ModValue(fontSize), fontFlags)
end

function Mod.SetPoint(self, point, relTo, relPoint, xOfs, yOfs)
    debug(self:GetName(), "SetPoint", point, relTo, relPoint, xOfs, yOfs)
    if not point or _G.type(point) == "number" then
        point, relTo, relPoint, xOfs, yOfs = self:GetPoint(point)
    end
    if (relTo and _G.type(relTo) ~= "number") then
        relPoint = relPoint or point
    elseif _G.type(relTo) == "number" and _G.type(relPoint) == "number" then
        relTo, relPoint, xOfs, yOfs = nil, nil, relTo, relPoint
    end
    debug(self:GetName(), "SetPoint post", point, relTo, relPoint, xOfs, yOfs)
    if relTo and relPoint then
        if xOfs and yOfs then
            debug(self:GetName(), "SetPoint full")
            return self:SetPoint(point, relTo, relPoint, ModValue(xOfs), ModValue(yOfs))
        else
            debug(self:GetName(), "SetPoint relative")
            return self:SetPoint(point, relTo, relPoint)
        end
    else
        if xOfs and yOfs then
            debug(self:GetName(), "SetPoint offset")
            return self:SetPoint(point, ModValue(xOfs), ModValue(yOfs))
        else
            debug(self:GetName(), "SetPoint point")
            return self:SetPoint(point)
        end
    end
end

function Mod.SetSize(self, width, height)
    debug(self:GetName(), "SetSize", width, height)
    if not (width and height) then
        width, height = self:GetSize()
    end
    return self:SetSize(ModValue(width), ModValue(height))
end

function Mod.SetHeight(self, height)
    if not (height) then
        height = self:GetHeight()
    end
    return self:SetHeight(ModValue(height))
end
function Mod.SetWidth(self, width)
    if not (width) then
        width = self:GetWidth()
    end
    return self:SetWidth(ModValue(width))
end


--[[ Skins ]]--
local bdBorder, bdMod = 0.1, 0.6
local bdColor, bdAlpha = bdBorder * bdMod, 0.7
private.bdInfo = {bdAlpha, bdMod, bdColor, bdBorder}

do -- Skin.CreateArrow
    local isHoriz = {left = true, right = true}
    function Skin.CreateArrow(direction, parent)
        direction = direction:lower()
        local arrow = _G.CreateFrame("Frame", nil, parent)
        for i = 1, 2 do
            arrow[i] = arrow:CreateTexture()
            arrow[i]:SetTexture([[Interface\AddOns\nibRealUI_Init\textures\triangle]])
            arrow[i]:SetPoint("TOPLEFT")
            arrow[i]:SetPoint("BOTTOMRIGHT")
        end
        if isHoriz[direction] then
            arrow[1]:SetPoint("BOTTOMRIGHT", arrow, "RIGHT")
            arrow[2]:SetPoint("TOPLEFT", arrow, "LEFT")
            if direction == "left" then
                arrow[1]:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0)
                arrow[2]:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
            elseif direction == "right" then
                arrow[1]:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
                arrow[2]:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
            end
        else
            arrow[1]:SetPoint("BOTTOMRIGHT", arrow, "BOTTOM")
            arrow[2]:SetPoint("TOPLEFT", arrow, "TOP")
            if direction == "up" then
                arrow[1]:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0)
                arrow[2]:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
            elseif direction == "down" then
                arrow[1]:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
                arrow[2]:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
            end
        end
        return arrow
    end
end

function Skin.Backdrop(self, isClass)
    self:SetBackdrop({
        bgFile = [[Interface\BUTTONS\WHITE8X8]],
        edgeFile = [[Interface\BUTTONS\WHITE8X8]],
        edgeSize = 1,
    })
    if isClass then
        local cc = private.classColor
        self:SetBackdropColor(cc.r * bdMod, cc.g * bdMod, cc.b * bdMod, bdAlpha)
        self:SetBackdropBorderColor(cc.r, cc.g, cc.b, 1)
    else
        self:SetBackdropColor(bdColor, bdColor, bdColor, bdAlpha)
        self:SetBackdropBorderColor(bdBorder, bdBorder, bdBorder, 1)
    end
end

do -- Skin.Button
    local function OnEnter(self)
        if not self:IsEnabled() then return end
        local cc = private.classColor
        self:SetBackdropColor(cc.r * bdMod, cc.g * bdMod, cc.b * bdMod, bdAlpha)
        self:SetBackdropBorderColor(cc.r, cc.g, cc.b, 1)
    end
    local function OnLeave(self)
        self:SetBackdropColor(bdColor, bdColor, bdColor, bdAlpha)
        self:SetBackdropBorderColor(bdBorder, bdBorder, bdBorder, 1)
    end

    function Skin.Button(self)
        debug(self:GetName(), "Button")
        Skin.Backdrop(self)
        self:HookScript("OnEnter", OnEnter)
        self:HookScript("OnLeave", OnLeave)
        for _, layer in next, {"Normal", "Pushed", "Highlight", "Disabled"} do
            self["Set"..layer.."Texture"](self, "")
        end

        if self.Left then
            self.Left:SetTexture("")
            self.Middle:SetTexture("")
            self.Right:SetTexture("")
        end
    end
end
do -- Skin.Check
    local function OnEnter(self)
        if not self:IsEnabled() then return end
        local cc = private.classColor
        --self:SetBackdropColor(cc.r * bdMod, cc.g * bdMod, cc.b * bdMod, bdAlpha)
        self:SetBackdropBorderColor(cc.r, cc.g, cc.b, 1)
    end
    local function OnLeave(self)
        --self:SetBackdropColor(bdColor, bdColor, bdColor, bdAlpha)
        self:SetBackdropBorderColor(bdBorder, bdBorder, bdBorder, 1)
    end

    function Skin.Check(self)
        debug(self:GetName(), "Check")
        Skin.Backdrop(self)

        -- Remove button textures
        for _, layer in next, {"Normal", "Pushed", "Highlight", "Disabled"} do
            self["Set"..layer.."Texture"](self, "")
        end

        -- Skin check textures
        local checkOfs = ModValue(3)
        for _, layer in next, {"", "Disabled"} do
            local checkTex = self["Get"..layer.."CheckedTexture"](self)
            checkTex:SetPoint("TOPLEFT", -checkOfs, checkOfs)
            checkTex:SetPoint("BOTTOMRIGHT", checkOfs, -checkOfs)
            if layer == "" then
                -- Class color normal check
                local cc = private.classColor
                checkTex:SetDesaturated(true)
                checkTex:SetVertexColor(cc.r, cc.g, cc.b)
            end
        end

        self:HookScript("OnEnter", OnEnter)
        self:HookScript("OnLeave", OnLeave)
    end
end

function Skin.Icon(self)
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", 1, -1)
    self:SetPoint("BOTTOMRIGHT", -1, 1)
    self:SetTexCoord(.08, .92, .08, .92)
end

function Skin.Font(self)
    local objName = self:GetFontObject():GetName()
    self:SetFontObject("RealUI_"..objName)

    Mod.SetFont(self)
end
