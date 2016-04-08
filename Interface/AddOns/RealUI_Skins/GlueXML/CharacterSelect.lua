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

    do --[[ CharSelectEnterWorldButton ]]--
        local self = _G.CharSelectEnterWorldButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(173), Mod.Value(34))
        self:SetPoint("BOTTOM", 0, Mod.Value(46))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ RotateButtons ]]--
        local rotateButtons = {
            Left = {"TOPRIGHT", "CharSelectEnterWorldButton", "BOTTOM", Mod.Value(-3), Mod.Value(-10)},
            Right = {"TOPLEFT", "CharacterSelectRotateLeft", "TOPRIGHT", Mod.Value(7), 0}
        }
        for side, anchors in next, rotateButtons do
            local self = _G["CharacterSelectRotate"..side]
            Skin.Button(self)
            self:SetSize(Mod.Value(24), Mod.Value(24))
            self:SetHitRectInsets(0, 0, 0, 0)
            self:ClearAllPoints()
            self:SetPoint(anchors[1], anchors[2], anchors[3], anchors[4], anchors[5])

            local arrow = Skin.CreateArrow(side, self)
            arrow:SetPoint("TOPLEFT", Mod.Value(4), Mod.Value(-6))
            arrow:SetPoint("BOTTOMRIGHT", Mod.Value(-4), Mod.Value(6))
        end
    end

    do --[[ CharacterSelectBackButton ]]--
        local self = _G.CharacterSelectBackButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(90), Mod.Value(20))
        self:ClearAllPoints()
        self:SetPoint("TOPRIGHT", _G.CharacterSelectCharacterFrame, "BOTTOMRIGHT", 0, Mod.Value(-10))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ CharacterSelectMenuButton ]]--
        local self = _G.CharacterSelectMenuButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(128), Mod.Value(20))
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", Mod.Value(40), Mod.Value(7))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ CharacterSelectAddonsButton ]]--
        local self = _G.CharacterSelectAddonsButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(128), Mod.Value(20))
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", _G.CharacterSelectMenuButton, "TOPLEFT", 0, Mod.Value(7))
    end

    do --[[ StoreButton ]]--
        local self = _G.StoreButton
        Skin.UIPanelGoldButton(self)
        self:SetSize(Mod.Value(128), Mod.Value(26))
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", _G.CharacterSelectAddonsButton, "TOPLEFT", 0, Mod.Value(13))
        self:SetScript("OnUpdate", nil)

        Mod.SetSize(self.Logo)
    end

    do --[[ CopyCharacterButton ]]--
        local self = _G.CopyCharacterButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(164), Mod.Value(40))
        Mod.SetPoint(self)
    end

    do --[[ CharacterSelectDeleteButton ]]--
        local self = _G.CharacterSelectDeleteButton
        Skin.GlueButton(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", _G.CharacterSelectCharacterFrame, "BOTTOMLEFT", 0, Mod.Value(-10))
        self:SetPoint("BOTTOMRIGHT", _G.CharacterSelectBackButton, "BOTTOMLEFT", Mod.Value(-15), 0)
        self:SetScript("OnUpdate", nil)
    end

    do --[[ CharacterSelectCharacterFrame ]]--
        local self = _G.CharacterSelectCharacterFrame
        Skin.Backdrop(self)
        self:SetPoint("TOPRIGHT", Mod.Value(-8), Mod.Value(-18))

        Mod.SetPoint(_G.CharSelectRealmName)
        Skin.Font(_G.CharSelectRealmName)
        Mod.SetPoint(_G.CharSelectUndeleteLabel)
        Skin.Font(_G.CharSelectUndeleteLabel)

        local prevBtn
        local function OnEnter(btn)
            btn:SetBackdropBorderColor(btn.color.r, btn.color.g, btn.color.b, 1)
        end
        local function OnLeave(btn)
            btn:SetBackdropBorderColor(0, 0, 0, 0)
        end
        for i = 1, _G.MAX_CHARACTERS_DISPLAYED do
            self = _G["CharSelectCharacterButton"..i]
            self.selection:SetTexture("")
            self:SetHighlightTexture("")
            self:SetHitRectInsets(0, 0, 0, 0)

            self:HookScript("OnEnter", OnEnter)
            self:HookScript("OnLeave", OnLeave)

            Skin.Backdrop(self)
            self:SetBackdropBorderColor(0, 0, 0, 0)

            for _, name in next, {"name", "Info", "Location"} do
                local font = self.buttonText[name]
                Skin.Font(font)
                if name == "name" then
                    font:SetPoint("TOPLEFT", Mod.Value(8), Mod.Value(-3))
                else
                    Mod.SetPoint(font)
                    Mod.SetSize(font)
                end
            end

            self:ClearAllPoints()
            if i == 1 then
                self:SetPoint("TOPLEFT", Mod.Value(9), Mod.Value(-64))
            else
                self:SetPoint("TOPLEFT", prevBtn, "BOTTOMLEFT", 0, Mod.Value(-5))
            end
            self:SetSize(Mod.Value(231), Mod.Value(52))
            prevBtn = self
        end
    end

    --local events = private.events
    --events:RegisterEvent("UPDATE_SELECTED_CHARACTER")
    --function events:UPDATE_SELECTED_CHARACTER(charID)
    local bdAlpha, bdMod = private.bdInfo[1], private.bdInfo[2]
    _G.hooksecurefunc("UpdateCharacterSelection", function(self)
        debug("UpdateCharacterSelection")
        for key, value in next, self do
            debug(key, value)
        end
        local charID = _G.GetCharIDFromIndex(self.selectedIndex)
        debug("charID", charID)
        debug("GetCharacterInfo", _G.GetCharacterInfo(charID))
        debug("GetIndexFromCharID", _G.GetIndexFromCharID(charID))
        local _, _, _, class = _G.GetCharacterInfo(charID)
        private.classColor = _G.RAID_CLASS_COLORS[class]

        for index = 1, _G.math.min(_G.GetNumCharacters(), _G.MAX_CHARACTERS_DISPLAYED) do
            local button = _G["CharSelectCharacterButton"..index]
            if not button.color then
                local charIDForBtn = _G.GetCharIDFromIndex(index + _G.CHARACTER_LIST_OFFSET)
                local _, _, _, class = _G.GetCharacterInfo(charIDForBtn)
                button.color = _G.RAID_CLASS_COLORS[class]
            end
            if button.selection:IsShown() and button.color then
                button:SetBackdropColor(button.color.r * bdMod, button.color.g * bdMod, button.color.b * bdMod, bdAlpha)
            else
                button:SetBackdropColor(0, 0, 0, 0)
            end
        end
    end)

    _G.hooksecurefunc("UpdateCharacterList", function(skipSelect)
        local self = _G.CharacterSelectCharacterFrame
        if self.scrollBar:IsShown() then
            self:SetPoint("BOTTOMLEFT", _G.CharacterSelectUI, "BOTTOMRIGHT", Mod.Value(-278), Mod.Value(50))
        else
            self:SetPoint("BOTTOMLEFT", _G.CharacterSelectUI, "BOTTOMRIGHT", Mod.Value(-258), Mod.Value(50))
        end
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
