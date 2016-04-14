local _, private = ...

if not private.FrameXML then return end

-- Lua Globals --
local _G = _G
--local next = _G.next

-- RealUI --
local Mod = private.Mod
--local Skin = private.Skin
--local debug = private.debug

_G.tinsert(private.FrameXML, function()
    local self = _G.UIParent
    self:SetAttribute("DEFAULT_FRAME_WIDTH", Mod.Value(384))
    self:SetAttribute("TOP_OFFSET", Mod.Value(-116))
    self:SetAttribute("LEFT_OFFSET", Mod.Value(16))
    self:SetAttribute("RIGHT_OFFSET_BUFFER", Mod.Value(80))
    self:SetAttribute("PANEl_SPACING_X", Mod.Value(32))

    _G.hooksecurefunc("UpdateUIPanelPositions", function()
        self:SetAttribute("CENTER_OFFSET", Mod.Value(self:GetAttribute("CENTER_OFFSET")))
        self:SetAttribute("RIGHT_OFFSET", Mod.Value(self:GetAttribute("RIGHT_OFFSET")))
    end)
end)
