local _, private = ...

if not private.FrameXML then return end

-- Lua Globals --
--local _G = _G
--local next = _G.next

-- RealUI --
local Mod = private.Mod
local Skin = private.Skin
--local debug = private.debug

function Skin.UICheckButton(self)
    self:SetSize(Mod.Value(14), Mod.Value(14))
    Skin.Check(self)
    Skin.Font(self.text)
end
