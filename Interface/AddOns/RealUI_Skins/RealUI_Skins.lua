local ADDON_NAME, private = ...

-- Lua Globals --
local _G = _G
local next, ipairs = _G.next, _G.ipairs

-- RealUI --
local Mod, Skin = {}, {}
local isInGlue = _G.InGlue()
local debug = _G.RealUIDebug or _G.nop
if isInGlue then
    private.GlueXML = {}
else
    private.FrameXML = {}
end
private.DebugXML = {}
private.AddOns = {}

_G.RealUI_Skins = {Mod, Skin}
private.Mod = Mod
private.Skin = Skin

private.isInGlue = isInGlue
private.debug = debug
private.debugMode = false
private.classColor = { r = 0.0, g = 1.00 , b = 0.59, colorStr = "ff00ff96" }

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

local frame = _G.CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
if isInGlue then
    frame:RegisterEvent("UPDATE_SELECTED_CHARACTER")
end
frame:SetScript("OnEvent", function(self, event, ...)
    if not isInGlue then
        debug(event, ...)
    end
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == ADDON_NAME then
            _G.RealUI_SkinsDB = _G.RealUI_SkinsDB or defaults

            local screenResolutions = {_G.GetScreenResolutions()}
            local uiHieght = screenResolutions[_G.GetCurrentResolution()]:match("%d+x(%d+)")
            private.uiScale = 768 / uiHieght
            private.uiMod = (uiHieght / 768) * _G.RealUI_SkinsDB.realUIScale
            debug("UISize", uiHieght, private.uiScale, private.uiMod)

            local uiScale = private.uiScale
            if uiScale < .64 or isInGlue then
                (_G.UIParent or _G.GlueParent):SetScale(uiScale)
            elseif uiScale ~= _G.tonumber(_G.GetCVar("uiScale")) then
                _G.SetCVar("useUiScale", 1)
                _G.SetCVar("uiScale", uiScale)
            end

            if private.debugMode then
                for index, func in ipairs(private.DebugXML) do
                    func()
                end
            else
                local uiXML = private.GlueXML or private.FrameXML
                for index, func in ipairs(uiXML) do
                    func()
                end
            end
        elseif addonName:match("Blizzard") then
            local func = private.AddOns[addonName]
            if func then
                func()
            end
        end
    elseif event == "UPDATE_SELECTED_CHARACTER" then
        local charID = ...
        debug("charID", charID)
        debug("GetCharacterInfo", _G.GetCharacterInfo(charID))
        debug("GetIndexFromCharID", _G.GetIndexFromCharID(charID))
        local _, _, _, class = _G.GetCharacterInfo(charID)
        private.classColor = _G.RAID_CLASS_COLORS[class]
    else
        debug("GetScreenHeight", _G.GetScreenHeight())
        if not isInGlue then
            debug("UIParent:GetSize", _G.UIParent:GetSize())
            self:UnregisterEvent(event)
        end
    end
end)

--[[ Point Modifications ]]--
local function ModValue(value)
    return _G.floor(value * private.uiMod + 0.5)
end
Mod.Value = ModValue

function Mod.SetFont(self)
    local fontFile, fontSize, fontFlags = self:GetFont()
    self:SetFont(fontFile, ModValue(fontSize), fontFlags)
    local xOfs, yOfs = self:GetShadowOffset()
    self:SetShadowOffset(ModValue(xOfs), ModValue(yOfs))
end

function Mod.SetPoint(self)
    local point, relTo, relPoint, xOfs, yOfs = self:GetPoint()
    self:SetPoint(point, relTo, relPoint, ModValue(xOfs), ModValue(yOfs))
end

function Mod.SetSize(self)
    local width, height = self:GetSize()
    self:SetSize(ModValue(width), ModValue(height))
end

function Mod.SetHeight(self)
    self:SetHeight(ModValue(self:GetHeight()))
end
function Mod.SetWidth(self)
    self:SetWidth(ModValue(self:GetWidth()))
end


--[[ Skins ]]--
local bdBorder, bdMod = 0.1, 0.6
local bdColor, bdAlpha = bdBorder * bdMod, 0.7

function Skin.CreateArrow(type, parent)
    type = type:lower()
    local tex = {}
    for i = 1, 2 do
        tex[i] = parent:CreateTexture()
        tex[i]:SetTexture([[Interface\AddOns\nibRealUI_Init\textures\triangle]])
    end
    if type == "left" then
        tex[1]:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0)
        tex[2]:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
    elseif type == "right" then
        tex[1]:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
        tex[2]:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
    end
    return tex
end

function Skin.Backdrop(self)
    self:SetBackdrop({
        bgFile = [[Interface\BUTTONS\WHITE8X8]],
        edgeFile = [[Interface\BUTTONS\WHITE8X8]],
        edgeSize = 1,
    })
    self:SetBackdropColor(bdColor, bdColor, bdColor, bdAlpha)
    self:SetBackdropBorderColor(bdBorder, bdBorder, bdBorder, 1)
end

do
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
        debug("Button", self:GetName())
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

function Skin.Font(self)
    local objName = self:GetFontObject():GetName()
    self:SetFontObject("RealUI_"..objName)

    Mod.SetFont(self)
end
