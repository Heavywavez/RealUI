-- Lua Globals --
local _G = _G
local select, tostring = _G.select, _G.tostring

--_G.GAME_LOCALE ="deDE"
local isInGlue = _G.InGlue()

local debugFrame
if isInGlue then
    local width, hieght = _G.GlueParent:GetSize()
    local UIParent = _G.CreateFrame("Frame", "UIParent", _G.GlueParent)
    UIParent:SetWidth(width / 2.5)
    UIParent:SetPoint("TOPLEFT")
    UIParent:SetPoint("BOTTOMLEFT")

    debugFrame = _G.LibStub("RealUI_LibTextDump-1.0"):New("Debug Output", width/3, hieght/1.5)
end

local debugStack, hasTimer = {}
local function debug(...)
    local text = ""
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        text = text .. "     " .. tostring(arg)
    end
    if isInGlue then
        debugFrame:AddLine(text)
        if not hasTimer then
            hasTimer = true
            _G.C_Timer.After(1, function()
                debugFrame:Display()
                hasTimer = false
            end)
        end
    else
        _G.tinsert(debugStack, text)
    end
end
debug("InGlue", isInGlue)

local BlizzAddons = {
    -- Not LoD, in order of load
    "Blizzard_CompactRaidFrames",
    "Blizzard_ClientSavedVariables",
    "Blizzard_CUFProfiles",
    "Blizzard_PetBattleUI",
    "Blizzard_TokenUI",
    "Blizzard_StoreUI", -- can be loaded in GlueXML
    "Blizzard_AuthChallengeUI", -- can be loaded in GlueXML
    "Blizzard_ObjectiveTracker",
    "Blizzard_WowTokenUI",
    "Blizzard_NamePlates",

    -- LoD
    "Blizzard_AchievementUI",
    "Blizzard_AdventureMap",
    "Blizzard_ArchaeologyUI",
    "Blizzard_ArenaUI",
    "Blizzard_ArtifactUI",
    "Blizzard_AuctionUI",
    "Blizzard_BarbershopUI",
    "Blizzard_BattlefieldMinimap",
    "Blizzard_BindingUI",
    "Blizzard_BlackMarketUI",
    "Blizzard_BoostTutorial",
    "Blizzard_Calendar",
    "Blizzard_ChallengesUI",
    "Blizzard_Collections",
    "Blizzard_CombatLog",
    "Blizzard_CombatText",
    "Blizzard_DeathRecap",
    "Blizzard_DebugTools",
    "Blizzard_EncounterJournal",
    "Blizzard_GarrisonTemplates",
    "Blizzard_GarrisonUI",
    "Blizzard_GMChatUI",
    "Blizzard_GMSurveyUI",
    "Blizzard_GuildBankUI",
    "Blizzard_GuildControlUI",
    "Blizzard_GuildUI",
    "Blizzard_InspectUI",
    "Blizzard_ItemSocketingUI",
    "Blizzard_ItemUpgradeUI",
    "Blizzard_LookingForGuildUI",
    "Blizzard_MacroUI",
    "Blizzard_MapCanvas",
    "Blizzard_MovePad",
    "Blizzard_ObliterumUI",
    "Blizzard_OrderHallUI",
    "Blizzard_PVPUI",
    "Blizzard_QuestChoice",
    "Blizzard_RaidUI",
    "Blizzard_SharedMapDataProviders",
    "Blizzard_SocialUI",
    "Blizzard_TalentUI",
    "Blizzard_TalkingHeadUI",
    "Blizzard_TimeManager",
    "Blizzard_TradeSkillUI",
    "Blizzard_TrainerUI",
    "Blizzard_Tutorial",
    "Blizzard_TutorialTemplates",
    "Blizzard_VoidStorageUI",
}

for i = 1, #BlizzAddons do
    local loaded = _G.IsAddOnLoaded(BlizzAddons[i])
    if loaded then
        debug("Pre-loaded:", BlizzAddons[i])
    end
end

for i = 1, _G.GetNumAddOns() do
    local loaded = _G.IsAddOnLoaded(i)
    if loaded then
        debug("Pre-loaded:", _G.GetAddOnInfo(i))
    end
end

local frame = _G.CreateFrame("Frame")
frame:RegisterAllEvents()
frame:SetScript("OnEvent", function(self, event, ...)
    debug(event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName:match("Blizzard") or addonName:match("RealUI") then
            debug("Loaded:", addonName)
        end
        if addonName == "nibRealUI" then
            debug = function (...)
                _G.RealUI.Debug("Dev", ...)
            end
            for i = 1, #debugStack do
                debug(debugStack[i])
            end
            _G.wipe(debugStack)
            self:UnregisterEvent("ADDON_LOADED")
        end
    else
        debug("GetScreenHeight", _G.GetScreenHeight())
        if not isInGlue then
            debug("UIParent:GetSize", _G.UIParent:GetSize())
            self:UnregisterEvent(event)
        end
    end
end)

if isInGlue then
    _G.RealUIDebug = debug
end
