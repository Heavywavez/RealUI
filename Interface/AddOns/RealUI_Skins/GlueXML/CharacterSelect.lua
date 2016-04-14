local _, private = ...

if not private.GlueXML then return end

-- Lua Globals --
local _G = _G
local next = _G.next

-- RealUI --
local Mod = private.Mod
local Skin = private.Skin
local debug = private.debug

local showProgressIcon = false

_G.tinsert(private.GlueXML, function()
    private.debugEnabled = false
    local DEFAULT_TEXT_OFFSET, MOVING_TEXT_OFFSET = 8, 16

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
        Mod.SetSize(self, 191, 43)
        Mod.SetPoint(self)
        Skin.GlueButton(self)

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
        self:SetScript("OnUpdate", nil)
        Mod.SetSize(self, 173, 34)
        Mod.SetPoint(self, "BOTTOM", 0, 46)
        Skin.GlueButton(self)
    end

    do --[[ RotateButtons ]]--
        local rotateButtons = {
            Left = {"TOPRIGHT", "CharSelectEnterWorldButton", "BOTTOM", -3, -10},
            Right = {"TOPLEFT", "CharacterSelectRotateLeft", "TOPRIGHT", 7, 0}
        }
        for side, anchors in next, rotateButtons do
            local self = _G["CharacterSelectRotate"..side]
            self:SetHitRectInsets(0, 0, 0, 0)
            self:ClearAllPoints()
            Mod.SetPoint(self, anchors[1], anchors[2], anchors[3], anchors[4], anchors[5])
            Mod.SetSize(self, 24, 24)
            Skin.Button(self)

            local arrow = Skin.CreateArrow(side, self)
            Mod.SetPoint(arrow, "TOPLEFT", 4, -6)
            Mod.SetPoint(arrow, "BOTTOMRIGHT", -4, 6)
        end
    end

    do --[[ CharacterSelectBackButton ]]--
        local self = _G.CharacterSelectBackButton
        self:SetScript("OnUpdate", nil)
        self:ClearAllPoints()
        Mod.SetPoint(self, "TOPRIGHT", _G.CharacterSelectCharacterFrame, "BOTTOMRIGHT", 0, -10)
        Mod.SetSize(self, 90, 20)
        Skin.GlueButton(self)
    end

    do --[[ CharacterSelectMenuButton ]]--
        local self = _G.CharacterSelectMenuButton
        self:SetScript("OnUpdate", nil)
        self:ClearAllPoints()
        Mod.SetPoint(self, "BOTTOMLEFT", 40, 7)
        Mod.SetSize(self, 128, 20)
        Skin.GlueButton(self)
    end

    do --[[ CharacterSelectAddonsButton ]]--
        local self = _G.CharacterSelectAddonsButton
        self:SetScript("OnUpdate", nil)
        self:ClearAllPoints()
        Mod.SetPoint(self, "BOTTOMLEFT", _G.CharacterSelectMenuButton, "TOPLEFT", 0, 7)
        Mod.SetSize(self, 128, 20)
        Skin.GlueButton(self)
    end

    do --[[ StoreButton ]]--
        local self = _G.StoreButton
        self:SetScript("OnUpdate", nil)
        self:ClearAllPoints()
        Mod.SetPoint(self, "BOTTOMLEFT", _G.CharacterSelectAddonsButton, "TOPLEFT", 0, 13)
        Mod.SetSize(self, 128, 26)
        Skin.UIPanelGoldButton(self)

        Mod.SetSize(self.Logo)
    end

    do --[[ CopyCharacterButton ]]--
        local self = _G.CopyCharacterButton
        Skin.GlueButton(self)
        Mod.SetSize(self, 164, 40)
        Mod.SetPoint(self)
    end

    do --[[ CharacterSelectDeleteButton ]]--
        local self = _G.CharacterSelectDeleteButton
        self:SetScript("OnUpdate", nil)
        self:ClearAllPoints()
        Mod.SetPoint(self, "TOPLEFT", _G.CharacterSelectCharacterFrame, "BOTTOMLEFT", 0, -10)
        Mod.SetPoint(self, "BOTTOMRIGHT", _G.CharacterSelectBackButton, "BOTTOMLEFT", -15, 0)
        Skin.GlueButton(self)
    end

    do --[[ CharacterSelectCharacterFrame ]]--
        local self = _G.CharacterSelectCharacterFrame
        Skin.Backdrop(self)
        Mod.SetPoint(self, "TOPRIGHT", -8, -18)

        for i = 1, _G.CharSelectRealmName:GetNumPoints() do
            Mod.SetPoint(_G.CharSelectRealmName, i)
        end
        Mod.SetHeight(_G.CharSelectRealmName, 7)
        Skin.Font(_G.CharSelectRealmName)

        Mod.SetPoint(_G.CharSelectUndeleteLabel)
        Skin.Font(_G.CharSelectUndeleteLabel)

        _G.CharSelectChangeRealmButton:SetScript("OnUpdate", nil)
        Mod.SetPoint(_G.CharSelectChangeRealmButton, "TOP", _G.CharSelectRealmName, "BOTTOM", 0, -9)
        Mod.SetSize(_G.CharSelectChangeRealmButton, 120, 18)
        Skin.GlueButton(_G.CharSelectChangeRealmButton)

        local prevBtn
        local function OnEnter(btn)
            btn:SetBackdropBorderColor(btn.rUIColor.r, btn.rUIColor.g, btn.rUIColor.b, 1)
        end
        local function OnLeave(btn)
            if not (btn.upButton:IsMouseOver() or btn.downButton:IsMouseOver()) then
                btn:SetBackdropBorderColor(0, 0, 0, 0)
            end
        end
        local moveButtons = {
            up = {"TOPRIGHT", -3, -3},
            down = {"BOTTOMRIGHT", -3, 3}
        }
        for i = 1, _G.MAX_CHARACTERS_DISPLAYED do
            self = _G["CharSelectCharacterButton"..i]
            self:SetHitRectInsets(0, 0, 0, 0)
            self:SetHighlightTexture("")
            self:SetBackdropBorderColor(0, 0, 0, 0)
            self:HookScript("OnEnter", OnEnter)
            self:HookScript("OnLeave", OnLeave)
            self:ClearAllPoints()
            if i == 1 then
                Mod.SetPoint(self, "TOPLEFT", 9, -64)
            else
                Mod.SetPoint(self, "TOPLEFT", prevBtn, "BOTTOMLEFT", 0, -5)
            end
            Mod.SetSize(self, 231, 52)
            Skin.Backdrop(self)

            self.selection:SetTexture("")

            for _, name in next, {"name", "Info", "Location"} do
                local font = self.buttonText[name]
                Skin.Font(font)
                if name == "name" then
                    Mod.SetPoint(font, "TOPLEFT", DEFAULT_TEXT_OFFSET, -3)
                else
                    Mod.SetPoint(font)
                    Mod.SetSize(font)
                end
            end

            for dir, anchors in next, moveButtons do
                local btn = self[dir.."Button"]
                Mod.SetSize(btn, 22, 22)
                Mod.SetPoint(btn, anchors[1], anchors[2], anchors[3])
                Skin.Button(btn)

                local arrow = Skin.CreateArrow(dir, btn)
                Mod.SetPoint(arrow, "TOPLEFT", 5, -8)
                Mod.SetPoint(arrow, "BOTTOMRIGHT", -5, 8)
            end

            local charSvc = _G["CharSelectPaidService"..i]
            charSvc:HookScript("OnEnter", OnEnter)
            charSvc:ClearAllPoints()
            Mod.SetPoint(charSvc, "RIGHT", self, "LEFT", -12, 0)
            Mod.SetSize(charSvc, 43, 43)
            Skin.Button(charSvc)

            charSvc.GoldBorder:SetTexture("")
            Skin.Icon(charSvc.VASIcon)

            local procIcon = _G["CharacterServicesProcessingIcon"..i]
            Mod.SetPoint(procIcon, "RIGHT", self, "LEFT", -12, 0)
            Mod.SetSize(procIcon)
            prevBtn = self
        end
    end

    _G.hooksecurefunc("CharacterSelectButton_OnDragStart", function(self)
        Mod.SetPoint(self.buttonText.name, "TOPLEFT", MOVING_TEXT_OFFSET, -3)
    end)
    _G.hooksecurefunc("CharacterSelectButton_OnDragStop", function(self)
        for index = 1, _G.MAX_CHARACTERS_DISPLAYED do
            local button = _G["CharSelectCharacterButton"..index]
            Mod.SetPoint(button.buttonText.name, "TOPLEFT", DEFAULT_TEXT_OFFSET, -3)
        end
    end)

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

        local resetColor = self.orderChanged or self.currentBGTag ~= _G.GetSelectBackgroundModel(charID)
        for index = 1, _G.math.min(_G.GetNumCharacters(), _G.MAX_CHARACTERS_DISPLAYED) do
            local button = _G["CharSelectCharacterButton"..index]
            if not button.rUIColor or resetColor then
                local btnCharID = _G.GetCharIDFromIndex(index + _G.CHARACTER_LIST_OFFSET)
                local _, _, _, btnClass = _G.GetCharacterInfo(btnCharID)
                button.rUIColor = _G.RAID_CLASS_COLORS[btnClass]
                _G["CharSelectPaidService"..index].rUIColor = button.rUIColor
            end
            if button.selection:IsShown() and button.rUIColor then
                button:SetBackdropColor(button.rUIColor.r * bdMod, button.rUIColor.g * bdMod, button.rUIColor.b * bdMod, bdAlpha)
            else
                button:SetBackdropColor(0, 0, 0, 0)
            end
            if button:IsMouseOver() and button.rUIColor then
                button:SetBackdropBorderColor(button.rUIColor.r, button.rUIColor.g, button.rUIColor.b, 1)
            else
                button:SetBackdropBorderColor(0, 0, 0, 0)
            end
        end
    end)

    _G.hooksecurefunc("UpdateCharacterList", function(skipSelect)
        local self = _G.CharacterSelectCharacterFrame
        if self.scrollBar:IsShown() then
            Mod.SetPoint(self, "BOTTOMLEFT", _G.CharacterSelectUI, "BOTTOMRIGHT", -278, 50)
        else
            Mod.SetPoint(self, "BOTTOMLEFT", _G.CharacterSelectUI, "BOTTOMRIGHT", -258, 50)
        end
        for index = 1, _G.math.min(_G.GetNumCharacters(), _G.MAX_CHARACTERS_DISPLAYED) do
            local button = _G["CharSelectCharacterButton"..index]
            if ( _G.CharacterSelect.draggedIndex ) then
                if ( _G.CharacterSelect.draggedIndex == button.index ) then
                    Mod.SetPoint(button.buttonText.name, "TOPLEFT", MOVING_TEXT_OFFSET, -3)
                else
                    Mod.SetPoint(button.buttonText.name, "TOPLEFT", DEFAULT_TEXT_OFFSET, -3)
                end
            end
            if showProgressIcon then
                local procIcon = _G["CharacterServicesProcessingIcon"..index]
                procIcon:SetShown(not _G["CharSelectPaidService"..index]:IsShown())
                procIcon.tooltip = _G.CHARACTER_UPGRADE_PROCESSING;
                procIcon.tooltip2 = _G.CHARACTER_STATE_ORDER_PROCESSING;
            end
        end
    end)
end)

_G.tinsert(private.DebugXML, function()
    -- These are frames that wouldn't typically be shown for players
    private.debugEnabled = true
    local connected = _G.IsConnectedToServer()
    debug("IsConnectedToServer", connected)

    do --[[ CharacterServicesProcessingIcon ]]--
        local numTemplates = _G.GetNumCharacterTemplates()
        debug("numTemplates", numTemplates)
        showProgressIcon = numTemplates > 0 and connected
    end
    do --[[ PlayersOnServer ]]--
        local self = _G.PlayersOnServer
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
