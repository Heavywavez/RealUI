local _, private = ...

if not private.GlueXML then return end

-- Lua Globals --
local _G = _G
local next = _G.next

-- RealUI --
local Mod = private.Mod
local Skin = private.Skin
local debug = private.debug

_G.tinsert(private.GlueXML, function()
    _G.CharacterSelect:SetScale(private.uiScale)

    do --[[ CharacterName ]]--
        Mod.SetPoint(_G.CharSelectCharacterName)
        Skin.Font(_G.CharSelectCharacterName)
    end

    do --[[ Logo ]]--
        Mod.SetSize(_G.LogoHoist)

        Mod.SetSize(_G.CharacterSelectLogo)
        Mod.SetPoint(_G.CharacterSelectLogo)
    end

    do --[[ AccountUpgradeButton ]]--
        local self = _G.CharSelectAccountUpgradeButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(191), Mod.Value(43))
        Mod.SetPoint(self)

        for i = 1, 2 do
            local tex = _G["CharSelectAccountUpgradeButtonChains"..i]
            tex:SetTexture("")
            Mod.SetSize(tex)
            Mod.SetPoint(tex)
        end

        self = _G.CharSelectAccountUpgradeButtonBorder
        self:SetTexture("")
        Mod.SetSize(self)
        Mod.SetPoint(self)
    end

    do --[[ RotateButtons ]]--
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
    end

    do --[[ CharacterSelectCharacterFrame ]]--
        Mod.SetHeight(_G.CharacterSelectCharacterFrame)
        Mod.SetPoint(_G.CharacterSelectCharacterFrame)
    end

    _G.hooksecurefunc("UpdateCharacterList", function(skipSelect)
        Mod.SetWidth(_G.CharacterSelectCharacterFrame)
    end)
end)

_G.tinsert(private.DebugXML, function()
    -- These are frames that wouldn't typically be shown for players
    do --[[ PlayersOnServer ]]--
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
end)
