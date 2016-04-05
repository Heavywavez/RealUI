local _, private = ...

if not private.GlueXML then return end

-- Lua Globals --
local _G = _G
local next = _G.next

-- RealUI --
--local Mod = private.Mod
local Skin = private.Skin
local debug = private.debug

function Skin.GlueButton(self)
    debug("GlueButton", self:GetName())
    Skin.Backdrop(self)
    local font = self:GetFontString()
    Skin.Font(font)
    font:SetPoint("CENTER", 0, 0)
    for _, layer in next, {"Normal", "Pushed", "Highlight", "Disabled"} do
        local tex = self["Get"..layer.."Texture"](self)
        tex:SetTexture("")
    end
end
