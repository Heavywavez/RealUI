local _, private = ...

if not private.GlueXML then return end

-- Lua Globals --
--local _G = _G
--local next = _G.next

-- RealUI --
--local Mod = private.Mod
local Skin = private.Skin
local debug = private.debug

function Skin.GlueButton(self)
    debug("GlueButton", self:GetName())
    local font = self:GetFontString()
    font:SetPoint("CENTER", 0, 0)
    Skin.Font(font)
    Skin.Button(self)
end
