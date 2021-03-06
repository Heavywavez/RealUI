local _, mods = ...

-- Lua Globals --
local next = _G.next

-- This is for small modifications that are not yet worth having thier own file.
-- Or to make modifications to a frame that Aurora modified.
_G.tinsert(mods["Aurora"], function(F, C)
    mods.debug("MiscSkins", F, C)
    local r, g, b = C.r, C.g, C.b

    -- Splash Frame SplashFrame_Open("LEGION_PREPATCH")
    F.CreateBD(_G.SplashFrame, nil, true)
    _G.hooksecurefunc("SplashFrame_Display", function(tag, showStartButton)
        --print("SplashFrame", tag, showStartButton)
        _G.SplashFrame.LeftTexture:SetDrawLayer("BACKGROUND", 7)
        F.ReskinAtlas(_G.SplashFrame.LeftTexture, _G.SPLASH_SCREENS[tag].leftTex)

        _G.SplashFrame.RightTexture:SetDrawLayer("BACKGROUND", 7)
        F.ReskinAtlas(_G.SplashFrame.RightTexture, _G.SPLASH_SCREENS[tag].rightTex)

        _G.SplashFrame.BottomTexture:SetDrawLayer("BACKGROUND", 7)
        local left, right, top, bottom = F.ReskinAtlas(_G.SplashFrame.BottomTexture, _G.SPLASH_SCREENS[tag].bottomTex, true)
        _G.SplashFrame.BottomTexture:SetTexCoord(right, top, left, top, right, bottom, left, bottom)

        _G.SplashFrame.Label:SetTextColor(1, 1, 1)

        _G.SplashFrame.BottomLine:SetDrawLayer("BACKGROUND", 7)
        F.ReskinAtlas(_G.SplashFrame.BottomLine, "splash-botleft")
    end)

    -- Objective Tracker
    F.ReskinExpandOrCollapse(_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)
    for _, headerName in next, {"QuestHeader", "AchievementHeader", "ScenarioHeader"} do
        local header = _G.ObjectiveTrackerFrame.BlocksFrame[headerName]
        header.Background:Hide()

        local bg = header:CreateTexture(nil, "ARTWORK")
        bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
        bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
        bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
        bg:SetPoint("BOTTOMLEFT", -30, -4)
        bg:SetSize(210, 30)
    end

    -- Scroll to bottom
    for i = 1, 10 do
        local chat = _G["ChatFrame" .. i]
        local btn = chat.buttonFrame.bottomButton
        btn:SetSize(20, 20)
        F.Reskin(btn, true)

        local arrow = btn:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 6, -6)
        arrow:SetPoint("BOTTOMRIGHT", -6, 6)
        arrow:SetTexture(C.media.arrowDown)

        local flash = _G[btn:GetName() .. "Flash"]
        flash:ClearAllPoints()
        flash:SetAllPoints(arrow)
        flash:SetTexture(C.media.arrowDown)
        flash:SetVertexColor(r, g, b, .8)
    end

    -- World State Frame
    F.Reskin(_G.WorldStateScoreFrameQueueButton)
    for i = 1, _G.MAX_WORLDSTATE_SCORE_BUTTONS do
        local scoreBtn = _G["WorldStateScoreButton" .. i]
        scoreBtn.factionLeft:SetTexture(C.media.backdrop)
        scoreBtn.factionLeft:SetBlendMode("ADD")
        scoreBtn.factionRight:SetTexture(C.media.backdrop)
        scoreBtn.factionRight:SetBlendMode("ADD")
    end
    _G.WorldStateScoreWinnerFrameLeft:SetTexture(C.media.backdrop)
    _G.WorldStateScoreWinnerFrameLeft:SetBlendMode("ADD")
    _G.WorldStateScoreWinnerFrameRight:SetTexture(C.media.backdrop)
    _G.WorldStateScoreWinnerFrameRight:SetBlendMode("ADD")
end)

_G.tinsert(mods["PLAYER_LOGIN"], function(F, C)
    mods.debug("PLAYER_LOGIN - Misc", F, C)
    -- These addons are loaded before !Aurora_RealUI.

    --mods["Blizzard_PetBattleUI"](F, C)
    if _G.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
        mods["Blizzard_CompactRaidFrames"](F, C)
    end

end)

mods["Blizzard_AuctionUI"] = function(F, C)
    mods.debug("Blizzard_AuctionUI", F, C)

   _G.WowTokenGameTimeTutorial.Tutorial:SetDrawLayer("BACKGROUND", 7)
    F.ReskinAtlas(_G.WowTokenGameTimeTutorial.Tutorial, "token-info-background")

    for _, side in next, {"LeftDisplay", "RightDisplay"} do
        _G.WowTokenGameTimeTutorial[side].Label:SetTextColor(1, 1, 1)
        _G.WowTokenGameTimeTutorial[side].Tutorial1:SetTextColor(.5, .5, .5)
    end

    _G.StoreButton:SetSize(149, 26)
    _G.StoreButton:SetPoint("TOPLEFT", _G.WowTokenGameTimeTutorial.RightDisplay.Tutorial2, "BOTTOMLEFT", 56, -12)
end
