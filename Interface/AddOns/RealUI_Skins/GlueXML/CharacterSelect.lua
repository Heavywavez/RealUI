local _, private = ...

local isInGlue = private.isInGlue
if not isInGlue then return end

-- Lua Globals --
local _G = _G
local next = _G.next

-- RealUI --
local Skins = private.Skins
local debug = private.debug

local ModValue = Skins.ModValue

_G.CharacterSelect:SetScale(private.uiScale)

local rotateButtons = {
    Left = {"TOPRIGHT", "CharSelectEnterWorldButton", "BOTTOM", -3, 7},
    Right = {"TOPLEFT", "CharacterSelectRotateLeft", "TOPRIGHT", 7, 0}
}
for side, anchors in next, rotateButtons do
    local btn = _G["CharacterSelectRotate"..side]
    btn:SetSize(25, 25)
    btn:SetHitRectInsets(0, 0, 0, 0)
    btn:ClearAllPoints()
    btn:SetPoint(anchors[1], anchors[2], anchors[3], anchors[4], anchors[5])

    local normTex = btn:GetNormalTexture()
    normTex:SetTexture(0, 0, 0, 0.5)
    local pushTex = btn:GetPushedTexture()
    pushTex:SetTexture(0, 0, 0, 0.8)
    local highTex = btn:GetHighlightTexture()
    highTex:SetTexture(1, 1, 1, 0.2)
    highTex:ClearAllPoints()
    highTex:SetPoint("TOPLEFT", 1, -1)
    highTex:SetPoint("BOTTOMRIGHT", -1, 1)
end

do -- CharacterSelectCharacterFrame
    local self = _G.CharacterSelectCharacterFrame
    local height = self:GetHeight()
    self:SetHeight(ModValue(height))

    local point, _, _, xOfs, yOfs = self:GetPoint()
    self:SetPoint(point, ModValue(xOfs), ModValue(yOfs))
end

do -- PlayersOnServer
    local self = _G.PlayersOnServer
    local connected = _G.IsConnectedToServer()
    debug("IsConnectedToServer", connected)
    if (not connected) then
        self:Hide()
        return
    end
    
    local numHorde, numAlliance = 5, 20
    self.HordeCount:SetText(numHorde)
    self.AllianceCount:SetText(numAlliance)
    self.HordeStar:SetShown(numHorde < numAlliance)
    self.AllianceStar:SetShown(numAlliance < numHorde)
    self:Show()
end

_G.hooksecurefunc("UpdateCharacterList", function(skipSelect)
    local self = _G.CharacterSelectCharacterFrame
    local width = self:GetWidth()
    self:SetWidth(ModValue(width))
end)
