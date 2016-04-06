local _, private = ...

-- Lua Globals --
--local _G = _G
--local next = _G.next

-- RealUI --
--local Mod = private.Mod
local Skin = private.Skin
local debug = private.debug

function Skin.UIPanelGoldButton(self)
    debug("UIPanelGoldButton", self:GetName())
    Skin.Font(self:GetFontString())
    Skin.Button(self)
end
