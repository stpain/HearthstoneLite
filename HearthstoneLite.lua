
--https://www.curseforge.com/api/projects/474073/package?token=45de603f-d93c-4c20-ac24-1afba7041926


local addonName, addon = ...

local DDE = LibStub("LibDropDownExtension-1.0", true)

local L = addon.locales;
local SavedVars = addon.SavedVars;
local Comms = addon.Comms;

local CHAT_CHANNEL_NAME = "HearthstoneLite";
local CHAT_CHANNEL_PASSWORD = "";

HearthstoneLiteMixin = {}

function HearthstoneLiteMixin:OnLoad()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("LOOT_OPENED")
    self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
    self:RegisterEvent("CHAT_MSG_CHANNEL_JOIN")
    self:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE")
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED")

    NineSliceUtil.ApplyLayout(self, NineSliceLayouts.GenericMetal)
    NineSliceUtil.ApplyLayout(self.decks.deckInfo, HearthstoneLite.Constants.NineSliceLayouts.ListviewMetal)
    NineSliceUtil.ApplyLayout(self.game.lobby, NineSliceLayouts.TooltipDefaultDarkLayout)
    NineSliceUtil.ApplyLayout(self.game.playerControls, NineSliceLayouts.TooltipDefaultDarkLayout)
    NineSliceUtil.ApplyLayout(self.game.board, NineSliceLayouts.TooltipDefaultDarkLayout)

    DDE:RegisterEvent("OnShow OnHide", function(dropdown, event, options)
        if dropdown.unit and dropdown.unit == "player" then
            if event == "OnShow" then
                options[1] = {
                    text = addonName,
                    func = function()
                        self:Show()
                    end,
                }
                return true
            else
                options[1] = nil
            end
        end
    end, 1)


    self:RegisterForDrag("LeftButton")
    PanelTemplates_SetNumTabs(self, #self.tabs);
    PanelTemplates_SetTab(self, 1);

    for _, tab in ipairs(self.tabs) do
        tab:SetScript("OnClick", function()
            self:SetView(tab:GetID())
        end)
    end

    self.tab1:SetText(L.GAME)
    self.tab2:SetText(L.DECKS)
    self.tab3:SetText(L.COLLECTION)
    self.tab4:SetText(SETTINGS)

    self:SetupDeckBuilder()
    self:SetupNewDeckDialog()
    self:SetupCollectionTab()
    self:SetupSettings()
    self:SetupGame()

    HearthstoneLite.CallbackRegistry:RegisterCallback(HearthstoneLite.Callbacks.Deck_OnCreated, self.Deck_OnCreated, self)
    HearthstoneLite.CallbackRegistry:RegisterCallback(HearthstoneLite.Callbacks.Deck_OnDeleted, self.Deck_OnDeleted, self)
    HearthstoneLite.CallbackRegistry:RegisterCallback(HearthstoneLite.Callbacks.Card_OnDragStop, self.Card_OnDragStop, self)
    HearthstoneLite.CallbackRegistry:RegisterCallback(HearthstoneLite.Callbacks.SavedVariables_OnReset, self.OnSavedVarsReset, self)
    HearthstoneLite.CallbackRegistry:RegisterCallback(HearthstoneLite.Callbacks.Comms_OnPokeResponse, self.Comms_OnPokeResponse, self)


    Comms:Init()
end

function HearthstoneLiteMixin:OnSavedVarsReset()
    
    self.decks.deckInfoText.numCards:SetText("No deck selected")
    self.decks.deckHero.background:SetAtlas(nil)
    self.decks.deckInfo.scrollView:SetDataProvider(CreateDataProvider({}))

    for k, v in ipairs(self.decks.deckViewer.cards) do
        v:Hide()
    end
    for k, v in ipairs(self.collection.cardBinderContainer.cards) do
        v:Hide()
    end

end

function HearthstoneLiteMixin:OnEvent(event, ...)
    if self[event] then
        self[event](self, ...)
    else
        DevTools_Dump({...})
    end
end


--[[
    using event names as functions
]]
function HearthstoneLiteMixin:PLAYER_ENTERING_WORLD(...)
    SavedVars:Init()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function HearthstoneLiteMixin:LOOT_OPENED(...)
    local card, link = HearthstoneLite.Api.OnLootOpened()
    if card and link then
        SavedVars:AddCardToCollection(card)
        print(string.format("[%s] you found a card! %s", addonName, link))
    end
end

function HearthstoneLiteMixin:CHAT_MSG_CHANNEL_NOTICE(...)
    local msg, sender, _, channelDisplayName, _, _, _, channelID, channelName = ...;

    if channelName == CHAT_CHANNEL_NAME then
        if msg == "YOU_CHANGED" then
            self:UpdateGameLobbyInfo(true, channelID)
        else
            self:UpdateGameLobbyInfo(false)
        end
    end

end


function HearthstoneLiteMixin:NAME_PLATE_UNIT_ADDED(...)
    local token = ...;
    --token = "player"
    if token and UnitIsPlayer(token) then
        local name, realm = UnitFullName(token)
        if not realm then
            realm = GetNormalizedRealmName()
        end
        local playerName = string.format("%s-%s", name, realm)
        Comms:RegisterNearbyPlayer(playerName)
    end
end








function HearthstoneLiteMixin:SetView(id)
    for _, view in ipairs(self.views) do
        view:Hide()
    end
    self.views[id]:Show()
    PanelTemplates_SetTab(self, id);
    --PlaySound(SOUNDKIT.TUTORIAL_POPUP)
end

function HearthstoneLiteMixin:Card_OnDragStop(card)
   
    if card:GetLocation() == "deckBuilder" then

        local x, y = card:GetCenter()
        local translateX = card.origin.x - x
        local translateY = card.origin.y - y

        card.resetPosition.translate:SetOffset(translateX, translateY)
        card.resetPosition:Play()

        if self.decks.deckInfo:IsMouseOver() then
            if self.decks.deckViewer.selectedDeck then
                table.insert(self.decks.deckViewer.selectedDeck.cards, card.cardDbEntry)
                self:UpdateDeckBuilderDeckInfo()
            end
        end
    end
end

function HearthstoneLiteMixin:SetupSettings()
    
    self.settings.resetSavedVars:SetScript("OnClick", function ()
        SavedVars:Init(true)
    end)
end


function HearthstoneLiteMixin:Deck_OnDeleted()
    self:UpdateDeckBuilderDeckList()
end

function HearthstoneLiteMixin:Deck_OnCreated(classID, specID, deckName)
    
    local deck = {
        id = time(),
        cards = {},
        name = deckName,
        classID = classID,
        specID = specID,
    }

    --add dummy cards for now
    --deck.cards = addon.Settings.MakeDummyDeck()

    SavedVars:NewDeck(deck)
    self.newDeckPopup:Hide()

    self:UpdateDeckBuilderDeckList()
end

function HearthstoneLiteMixin:OnDecksShow()
    self:UpdateDeckBuilderDeckList()
end

function HearthstoneLiteMixin:OnDecksHide()
    self.newDeckPopup:Hide()
    --self.decks.deckInfo:Hide()
    self.background:SetAtlas(HearthstoneLite.Constants.DefaultBackground)
end

function HearthstoneLiteMixin:UpdateDeckBuilderDeckList()

    for k, v in ipairs(self.decks.deckViewer.cards) do
        v:Hide()
    end
    
    local decks = SavedVars:GetDeck()
    local list = {}
    for _, deck in ipairs(decks) do
        local _, name = GetClassInfo(deck.classID)
        table.insert(list, {
            label = "|cffffffff"..deck.name,
            fontObject = GameFontNormalHuge,
            showMask = true,
            atlas = string.format("classicon-%s", name:lower():gsub(" ", "")),
            backgroundAtlas = HearthstoneLite.Api.GetHeroAtlas(deck.classID, deck.specID),
            backgroundAlpha = 0.4,
            highlightAtlas = "heartofazeroth-list-item-highlight",
            init = function(f)
                NineSliceUtil.ApplyLayout(f, HearthstoneLite.Constants.NineSliceLayouts.DeckListviewItem)
                f.background:SetTexCoord(0,1, 0.3, 0.7)
                f.background:ClearAllPoints()
                f.background:SetPoint("TOPLEFT", 2, -2)
                f.background:SetPoint("BOTTOMRIGHT", -2, 2)
                f.ring:SetVertexColor(RAID_CLASS_COLORS[name]:GetRGBA())
                f.ring:SetDrawLayer("OVERLAY", 6)
                f.selected:SetAtlas("heartofazeroth-list-item-selected")
            end,
            onMouseDown = function()
                self:LoadDeck(deck)
            end,
            rightButton = {
                offsetY = -8,
                size = {20,20},
                atlas = "common-icon-redx",
                onClick = function()
                    SavedVars:DeleteDeck(deck)
                    HearthstoneLite.CallbackRegistry:TriggerEvent(HearthstoneLite.Callbacks.Deck_OnDeleted)
                end,
            }
        })
    end
    self.decks.decksListview.scrollView:SetDataProvider(CreateDataProvider(list))
    --self.decks.deckInfo.scrollView:SetDataProvider(CreateDataProvider({}))
    --self.decks.deckHero.background:SetAtlas(nil)
end

function HearthstoneLiteMixin:UpdateDeckBuilderDeckInfo()
    if self.decks.deckViewer.selectedDeck then
        table.sort(self.decks.deckViewer.selectedDeck.cards, function(a, b)
            if a.cost == b.cost then
                return a.rarity > b.rarity;
            else
                return a.cost < b.cost
            end
        end)
    
        self.decks.deckInfoText.numCards:SetText(string.format("Cards: %d",#self.decks.deckViewer.selectedDeck.cards))
        self.decks.deckInfo.scrollView:SetDataProvider(CreateDataProvider(self.decks.deckViewer.selectedDeck.cards))
    end
end

function HearthstoneLiteMixin:LoadDeck(deck)

    for k, v in ipairs(self.decks.deckViewer.cards) do
        v:Hide()
    end

    self.decks.deckViewer.selectedDeck = deck

    table.sort(deck.cards, function(a, b)
        if a.cost == b.cost then
            return a.rarity > b.rarity;
        else
            return a.cost < b.cost
        end
    end)

    local classCards = SavedVars:GetCollection(self.decks.deckViewer.selectedDeck.classID)
    self.decks.deckViewer.set = classCards
    self.decks.deckViewer.header:SetText(L.CLASS_CARDS)
    self:DeckBuilderOnPageChanged()
    
    --self.fadeBackground:Play()
    --self.background:SetAtlas(HearthstoneLite.Api.GetBackgroundForHero(deck.classID, deck.specID))

    self.decks.deckInfoText.numCards:SetText(string.format("Cards: %d",#deck.cards))
    self.decks.deckHero.background:SetAtlas(HearthstoneLite.Api.GetHeroAtlas(deck.classID, deck.specID))
    self.decks.deckInfo.scrollView:SetDataProvider(CreateDataProvider(deck.cards))
    self.decks.deckInfo:Show()

end

function HearthstoneLiteMixin:ResetDeckBuilderCardPositions()
    for i = 1, 5 do
        local card = self.decks.deckViewer.cards[i]
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT", ((i-1) * 150) + 30, -30)
    end
    for i = 6, 10 do
        local card = self.decks.deckViewer.cards[i]
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT", ((i-6) * 150) + 30, -260)
    end
end

function HearthstoneLiteMixin:DeckBuilderOnPageChanged()

    self.decks.deckViewer.numPages = math.ceil(#self.decks.deckViewer.set / 10)

    self.decks.deckViewer.pageLabel:SetText(string.format("%s / %s", self.decks.deckViewer.page, self.decks.deckViewer.numPages))

    for k, v in ipairs(self.decks.deckViewer.cards) do
        v:Hide()
    end

    local from, to = (self.decks.deckViewer.page * 10) - 9, (self.decks.deckViewer.page * 10);
    local i = 1;
    for k = from, to do
        if self.decks.deckViewer.set[k] then
            self.decks.deckViewer.cards[i]:CreateFromData(self.decks.deckViewer.set[k])
            self.decks.deckViewer.cards[i]:Show()
        end
        i = i + 1;
    end

    PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end

function HearthstoneLiteMixin:SetupDeckBuilder()

    self.decks:SetScript("OnShow", function()
        self:OnDecksShow()
    end)
    self.decks:SetScript("OnHide", function()
        self:OnDecksHide()
    end)

    self.decks.newDeck:SetScript("OnClick", function(b)
        self.newDeckPopup.newDeckNameInput:SetText("")
        self.newDeckPopup:Show()
    end)

    self.decks.deckViewer.page = 1;

    self.decks.deckViewer.header:SetText(L.NEUTRAL_CARDS)

    self.decks.deckViewer.cards = {}
    local deckBuilderFramePool = CreateFramePool("CheckButton", self.decks.deckViewer, "HslCard")
    for i = 1, 5 do
        local card = deckBuilderFramePool:Acquire()
        card:SetPoint("TOPLEFT", ((i-1) * 150), -30)
        card:SetLocation("deckBuilder")
        card:SetDragEnabled()
        card:SetPositionResetFunc(function()
            card:ClearAllPoints()
            card:SetParent(self.decks.deckViewer)
            card:SetPoint("TOPLEFT", self.decks.deckViewer, "TOPLEFT", ((i-1) * 150), -30)
        end)
        table.insert(self.decks.deckViewer.cards, card)
    end
    for i = 6, 10 do
        local card = deckBuilderFramePool:Acquire()
        card:SetPoint("TOPLEFT", ((i-6) * 150), -260)
        card:SetLocation("deckBuilder")
        card:SetDragEnabled()
        card:SetPositionResetFunc(function()
            card:ClearAllPoints()
            card:SetParent(self.decks.deckViewer)
            card:SetPoint("TOPLEFT", self.decks.deckViewer, "TOPLEFT", ((i-6) * 150), -260)
        end)
        table.insert(self.decks.deckViewer.cards, card)
    end

    self.decks.deckViewer.page = 1;
    
    self.decks.deckViewer.next:SetNormalTexture(130866)
    self.decks.deckViewer.next:SetPushedTexture(130865)
    self.decks.deckViewer.next:SetScript("OnClick", function()
        self.decks.deckViewer.page = self.decks.deckViewer.page + 1;
        if self.decks.deckViewer.page > self.decks.deckViewer.numPages then
            self.decks.deckViewer.page = self.decks.deckViewer.numPages;
        end
        self:DeckBuilderOnPageChanged()
    end)
    self.decks.deckViewer.previous:SetNormalTexture(130869)
    self.decks.deckViewer.previous:SetPushedTexture(130868)
    self.decks.deckViewer.previous:SetScript("OnClick", function()
        self.decks.deckViewer.page = self.decks.deckViewer.page - 1;
        if self.decks.deckViewer.page < 1 then
            self.decks.deckViewer.page = 1;
        end
        self:DeckBuilderOnPageChanged()
    end)


    self.decks.deckViewer.classCards:SetScript("OnClick", function ()
        if self.decks.deckViewer.selectedDeck then
            local classCards = SavedVars:GetCollection(self.decks.deckViewer.selectedDeck.classID)
            self.decks.deckViewer.set = classCards
            self:DeckBuilderOnPageChanged()
        end
        self.decks.deckViewer.header:SetText(L.CLASS_CARDS)
    end)

    self.decks.deckViewer.neutralCards:SetScript("OnClick", function ()
        local cards = SavedVars:GetCollection(-1)
        self.decks.deckViewer.set = cards
        self:DeckBuilderOnPageChanged()
        self.decks.deckViewer.header:SetText(L.NEUTRAL_CARDS)
    end)

end

function HearthstoneLiteMixin:SetupNewDeckDialog()

    self.newDeckPopup.cancel:SetScript("OnClick", function()
        self.newDeckPopup:Hide()
    end)

    self.newDeckPopup.header:SetText(NORMAL_FONT_COLOR:WrapTextInColorCode("Select Class"))
    
    local newDeckClassPool = CreateFramePool("BUTTON", self.newDeckPopup.classSelectContainer, "TBDCircleButtonTemplate")
    local lastButton;
    for i = 1, 5 do
        local className, fileName, classID = GetClassInfo(i)
        if className then
            local classButton = newDeckClassPool:Acquire()
            classButton:SetSize(80, 80)
            classButton.border:SetVertexColor(RAID_CLASS_COLORS[fileName]:GetRGBA())
            classButton.classID = i;
            classButton:Init({
                atlas = string.format("classicon-%s", fileName:lower():gsub(" ", "")),
                label = className,
            })
            if i == 1 then
                classButton:SetPoint("TOPLEFT", 44, 0)
            else
                classButton:SetPoint("LEFT", lastButton, "RIGHT")
            end
            classButton:Show()
            lastButton = classButton;
        end
    end
    local lastButton = nil;
    for i = 6, 10 do
        local className, fileName, classID = GetClassInfo(i)
        if className then
            local classButton = newDeckClassPool:Acquire()
            classButton:SetSize(80, 80)
            classButton.border:SetVertexColor(RAID_CLASS_COLORS[fileName]:GetRGBA())
            classButton.classID = i;
            classButton:Init({
                atlas = string.format("classicon-%s", fileName:lower():gsub(" ", "")),
                label = className,
            })
            if i == 6 then
                classButton:SetPoint("TOPLEFT", 44, -100)
            else
                classButton:SetPoint("LEFT", lastButton, "RIGHT")
            end
            classButton:Show()
            lastButton = classButton;
        end
    end
    local lastButton = nil;
    for i = 11, 13 do
        local className, fileName, classID = GetClassInfo(i)
        if className then
            local classButton = newDeckClassPool:Acquire()
            classButton:SetSize(80, 80)
            classButton.border:SetVertexColor(RAID_CLASS_COLORS[fileName]:GetRGBA())
            classButton.classID = i;
            classButton:Init({
                atlas = string.format("classicon-%s", fileName:lower():gsub(" ", "")),
                label = className,
            })
            if i == 11 then
                classButton:SetPoint("TOPLEFT", 124, -200)
            else
                classButton:SetPoint("LEFT", lastButton, "RIGHT")
            end
            classButton:Show()
            lastButton = classButton;
        end
    end

    local function clearHeroButtons()
        for _, button in ipairs(self.newDeckPopup.heroSelectContainer.heroSelectButtons) do
            button.border:SetAtlas("spec-thumbnailborder-off")
            button.isSelected = false;
        end
    end

    local function setHeroButton(button)
        clearHeroButtons()
        button.border:SetAtlas("spec-thumbnailborder-on")
        button.isSelected = true
    end

    self.newDeckPopup.back:SetScript("OnClick", function ()
        self.newDeckPopup.slideRight:Play()
        self.newDeckPopup.back:SetAlpha(0)
    end)

    self.newDeckPopup.next:GetNormalTexture():SetRotation(3.14)

    self.newDeckPopup:SetScript("OnHide", function ()
        self.newDeckPopup.classSelectContainer:ClearAllPoints()
        self.newDeckPopup.classSelectContainer:SetPoint("TOP", 0, -70)
        self.newDeckPopup.classSelectContainer:SetAlpha(1)
        self.newDeckPopup.heroSelectContainer:ClearAllPoints()
        self.newDeckPopup.heroSelectContainer:SetPoint("TOP", 495, -70)

        clearHeroButtons()
    end)

    self.newDeckPopup.slideLeft:SetScript("OnFinished", function ()
        self.newDeckPopup.classSelectContainer:ClearAllPoints()
        self.newDeckPopup.classSelectContainer:SetPoint("TOP", -495, -70)
        self.newDeckPopup.heroSelectContainer:ClearAllPoints()
        self.newDeckPopup.heroSelectContainer:SetPoint("TOP", 0, -70)

        self.newDeckPopup.back:SetAlpha(1)
        clearHeroButtons()

        self.newDeckPopup.header:SetText(NORMAL_FONT_COLOR:WrapTextInColorCode("Select Hero"))
    end)
    self.newDeckPopup.slideRight:SetScript("OnFinished", function ()
        self.newDeckPopup.classSelectContainer:ClearAllPoints()
        self.newDeckPopup.classSelectContainer:SetPoint("TOP", 0, -70)
        self.newDeckPopup.heroSelectContainer:ClearAllPoints()
        self.newDeckPopup.heroSelectContainer:SetPoint("TOP", 495, -70)

        for classButton in newDeckClassPool:EnumerateActive() do
            classButton.selected:Hide()
            classButton.isSelected = false;
        end
        clearHeroButtons()

        self.newDeckPopup.header:SetText(NORMAL_FONT_COLOR:WrapTextInColorCode("Select Class"))
    end)

    for _, button in ipairs(self.newDeckPopup.heroSelectContainer.heroSelectButtons) do
        button:SetScript("OnClick", setHeroButton)
    end

    local function setClassButton(button)
        for classButton in newDeckClassPool:EnumerateActive() do
            classButton.selected:Hide()
            classButton.isSelected = false;
        end
        button.selected:Show()
        button.isSelected = true;
        self.newDeckPopup.slideLeft:Play()

        for _, button in ipairs(self.newDeckPopup.heroSelectContainer.heroSelectButtons) do
            button:Hide()
        end

        local _, className = GetClassInfo(button.classID)
        local numSpecs = GetNumSpecializationsForClassID(button.classID)
        for i = 1, numSpecs do
            local id, specName, description, icon, role, isRecommended, isAllowed = GetSpecializationInfoForClassID(button.classID, i)
            --print(specName)
            if self.newDeckPopup.heroSelectContainer["spec"..i] then
                self.newDeckPopup.heroSelectContainer["spec"..i].background:SetAtlas(string.format("spec-thumbnail-%s-%s", className:gsub(" ", ""):lower(), specName:gsub(" ", ""):lower()))
                self.newDeckPopup.heroSelectContainer["spec"..i]:Show()
            end
        end
    end

    for classButton in newDeckClassPool:EnumerateActive() do
        classButton:SetScript("OnMouseDown", setClassButton)
    end


--    self.newDeckPopup.accept:SetEnabled(false)
    self.newDeckPopup.accept:SetScript("OnClick", function()
        local classSelected;
        for classButton in newDeckClassPool:EnumerateActive() do
            if classButton.isSelected then
                classSelected = classButton.classID
            end
        end
        local heroSelected;
        for specID, button in ipairs(self.newDeckPopup.heroSelectContainer.heroSelectButtons) do
            if button.isSelected then
                heroSelected = specID;
            end
        end
        local deckName = self.newDeckPopup.newDeckNameInput:GetText()
        if classSelected and (#deckName > 0) and heroSelected then
            HearthstoneLite.CallbackRegistry:TriggerEvent(HearthstoneLite.Callbacks.Deck_OnCreated, classSelected, heroSelected, deckName)
        end
    end)
end











function HearthstoneLiteMixin:CollectionBinderOnPageChanged()
    
    for k, v in ipairs(self.collection.cardBinderContainer.cards) do
        v:Hide()
    end

    for i = 1, 12 do
        local card = self.collection.cardBinderContainer.cards[i]
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT")
    end

    if not self.collection.cardBinderContainer.set then
        return
    end

    self.collection.cardBinderContainer.numPages = math.ceil(#self.collection.cardBinderContainer.set / 12)

    self.collection.cardBinderContainer.pageLabel:SetText(string.format("%s / %s", self.collection.cardBinderContainer.page, self.collection.cardBinderContainer.numPages))

    local from, to = (self.collection.cardBinderContainer.page * 12) - 11, (self.collection.cardBinderContainer.page * 12);
    local i = 1;
    for k = from, to do
        if self.collection.cardBinderContainer.set[k] then
            self.collection.cardBinderContainer.cards[i]:CreateFromData(self.collection.cardBinderContainer.set[k])
            self.collection.cardBinderContainer.cards[i]:Show()
        end
        i = i + 1;
    end

    self.collection.cardBinderContainer.anim:Play()

    PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end


function HearthstoneLiteMixin:SetupCollectionTab()
    
    -- self.collection.cardBinderContainer.cards = {}
    -- local collectionFramePool = CreateFramePool("FRAME", self.collection.cardBinderContainer, "HslCard")
    -- for i = 1, 6 do
    --     local card = collectionFramePool:Acquire()
    --     card:SetPoint("TOPLEFT", ((i-1) * 150) + 40, -30)
    --     table.insert(self.collection.cardBinderContainer.cards, card)
    -- end
    -- for i = 7, 12 do
    --     local card = collectionFramePool:Acquire()
    --     card:SetPoint("TOPLEFT", ((i-7) * 150) + 40, -260)
    --     card:Hide()
    --     table.insert(self.collection.cardBinderContainer.cards, card)
    -- end

    self.collection.cardBinderContainer.anim:SetScript("OnFinished", function()
        for i = 1, 6 do
            local card = self.collection.cardBinderContainer.cards[i]
            card:ClearAllPoints()
            card:SetPoint("TOPLEFT", ((i-1) * 150) + 40, -30)
        end
        for i = 7, 12 do
            local card = self.collection.cardBinderContainer.cards[i]
            card:ClearAllPoints()
            card:SetPoint("TOPLEFT", ((i-7) * 150) + 40, -260)
        end
    end)

    for i = 1, GetNumClasses() do
        local name, className, classID = GetClassInfo(i)
        self.collection.classFilterList.DataProvider:Insert({
            label = name,
            showMask = true,
            atlas = string.format("classicon-%s", className:lower():gsub(" ", "")),
            backgroundAtlas = "heartofazeroth-list-item",
            highlightAtlas = "heartofazeroth-list-item-highlight",
            init = function(f)
                f.ring:SetVertexColor(RAID_CLASS_COLORS[className]:GetRGBA())
                f.selected:SetAtlas("heartofazeroth-list-item-selected")
            end,
            onMouseUp = function(f, button)
                local collection;
                if button == "RightButton" then
                    collection = SavedVars:GetCollection()
                    f.selected:Hide()
                else
                    collection = SavedVars:GetCollection(classID)
                end

                table.sort(collection, function (a, b)
                    if a.rarity == b.rarity then
                        return a.classID < b.classID
                    else
                        return a.rarity > b.rarity
                    end
                end)
        
                self.collection.cardBinderContainer.set = collection
                self:CollectionBinderOnPageChanged()
            end
        })
    end

    self.collection.cardBinderContainer.page = 1;
    self.collection.cardBinderContainer.numPages = 1;

    self.collection.cardBinderContainer.next:SetNormalTexture(130866)
    self.collection.cardBinderContainer.next:SetPushedTexture(130865)
    self.collection.cardBinderContainer.next:SetScript("OnClick", function()
        self.collection.cardBinderContainer.page = self.collection.cardBinderContainer.page + 1;
        if self.collection.cardBinderContainer.page > self.collection.cardBinderContainer.numPages then
            self.collection.cardBinderContainer.page = self.collection.cardBinderContainer.numPages;
        else
            self:CollectionBinderOnPageChanged()
        end
    end)
    self.collection.cardBinderContainer.previous:SetNormalTexture(130869)
    self.collection.cardBinderContainer.previous:SetPushedTexture(130868)
    self.collection.cardBinderContainer.previous:SetScript("OnClick", function()
        self.collection.cardBinderContainer.page = self.collection.cardBinderContainer.page - 1;
        if self.collection.cardBinderContainer.page < 1 then
            self.collection.cardBinderContainer.page = 1;
        else
            self:CollectionBinderOnPageChanged()
        end
    end)

    self.collection:SetScript("OnShow", function()

        for i = 1, 12 do
            local card = self.collection.cardBinderContainer.cards[i]
            card:ClearAllPoints()
            card:SetPoint("TOPLEFT")
        end
    
        local collection = SavedVars:GetCollection()

        table.sort(collection, function (a, b)
            if a.rarity == b.rarity then
                return a.classID < b.classID
            else
                return a.rarity > b.rarity
            end
        end)

        self.collection.cardBinderContainer.set = collection
        self:CollectionBinderOnPageChanged()
    end)

end










function HearthstoneLiteMixin:UpdateGameLobbyInfo(isConnected, channelID)
    
    if isConnected then
        self.game.lobby.info:SetText(string.format("Connected [channel %d]", channelID))

        ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, CHAT_CHANNEL_NAME);

        local channels = {GetChannelList()}
        for i = 1, #channels, 3 do
            local id, name, disabled = channels[i], channels[i+1], channels[i+2]
            print(id, name, disabled)
        end

        --ListChannelByName(channelID)
        local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(channelID)
        print(name, channelNumber, count)

        ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, CHAT_CHANNEL_NAME)

        for i = 1, 5 do
            local name, owner, moderator, guid = C_ChatInfo.GetChannelRosterInfo(channelID, i)
            --print(name, owner, moderator, guid)
        end
    else
        self.game.lobby.info:SetText("Not connected")
    end

end



function HearthstoneLiteMixin:SetupGame()
    --JoinChannelByName(CHAT_CHANNEL_NAME, CHAT_CHANNEL_PASSWORD, nil, false);
    --JoinTemporaryChannel(CHAT_CHANNEL_NAME, CHAT_CHANNEL_PASSWORD, nil, false);
    --LeaveChannelByName(CHAT_CHANNEL_NAME)

    --by default you should not be joined
    --LeaveChannelByName(CHAT_CHANNEL_NAME)

    --HearthstoneLite.CallbackRegistry:TriggerEvent(HearthstoneLite.Callbacks.Comms_OnPokesEnabled, false)

    self.game.matchMakerContainer.header:SetText(NORMAL_FONT_COLOR:WrapTextInColorCode("Create Match"))

    self.game.board.playerContainer:SetHeight(self.game.board:GetHeight() * 0.6)
    self.game.board.playerContainer.background:SetAtlas("talents-background-druid-balance")
    self.game.board.targetContainer:SetHeight(self.game.board:GetHeight() * 0.4)
    self.game.board.targetContainer.background:SetAtlas("_GarrMissionLocation-Gorgrond-Mid")


    self.game.playerControls.createMatch:SetScript("OnClick", function ()
        self.game.matchMakerContainer:Show()
    end)

    self.game.matchMakerContainer:SetScript("OnShow", function ()
        local decks = SavedVars:GetDeck()
        local list = {}
        for _, deck in ipairs(decks) do
            local _, name = GetClassInfo(deck.classID)
            table.insert(list, {
                label = "|cffffffff"..deck.name,
                fontObject = GameFontNormalHuge,
                showMask = true,
                atlas = string.format("classicon-%s", name:lower():gsub(" ", "")),
                backgroundAtlas = HearthstoneLite.Api.GetHeroAtlas(deck.classID, deck.specID),
                backgroundAlpha = 0.4,
                highlightAtlas = "heartofazeroth-list-item-highlight",
                init = function(f)
                    NineSliceUtil.ApplyLayout(f, HearthstoneLite.Constants.NineSliceLayouts.DeckListviewItem)
                    f.background:SetTexCoord(0,1, 0.3, 0.7)
                    f.background:ClearAllPoints()
                    f.background:SetPoint("TOPLEFT", 2, -2)
                    f.background:SetPoint("BOTTOMRIGHT", -2, 2)
                    f.ring:SetVertexColor(RAID_CLASS_COLORS[name]:GetRGBA())
                    f.ring:SetDrawLayer("OVERLAY", 6)
                    f.selected:SetAtlas("heartofazeroth-list-item-selected")
                end,
                onMouseDown = function()
                    self.game.matchMakerContainer.selectedDeck = deck;
                end,
            })
        end
        self.game.matchMakerContainer.selectDeck.scrollView:SetDataProvider(CreateDataProvider(list))
        self.game.matchMakerContainer.selectedDeck = nil;
        self.game.matchMakerContainer.opponentOptions:SetAlpha(1)
    end)

    self.game.matchMakerContainer:SetScript("OnHide", function ()
        self.game.matchMakerContainer.selectDeck.scrollView:ForEachFrame(function(f, d)
            f.selected:Hide()
        end)
        self.game.matchMakerContainer.matchCreationInfo:Hide()
    end)

    self.game.matchMakerContainer.opponentOptions.practice:SetScript("OnClick", function ()
        if self.game.matchMakerContainer.selectedDeck then
            self:CreatePracticeMatch(self.game.matchMakerContainer.selectedDeck)
        end
    end)

    self.game.matchMakerContainer.matchCreationInfo:SetScript("OnShow", function ()
        self.game.matchMakerContainer.matchCreationInfo.startCreationAnim:Play()
    end)

    self.game.matchMakerContainer.matchCreationInfo:SetScript("OnHide", function ()
        self.game.matchMakerContainer.matchCreationInfo.startCreation:SetAlpha(0)
        self.game.matchMakerContainer.matchCreationInfo.opponentFound:SetAlpha(0)
        self.game.matchMakerContainer.matchCreationInfo.deckConfirmation:SetAlpha(0)
    end)

    self.game.matchMakerContainer.opponentOptions.fadeOut:SetScript("OnFinished", function ()
        self.game.matchMakerContainer.matchCreationInfo:Show()
    end)

end

function HearthstoneLiteMixin:CreatePracticeMatch(deck)
    self.game.matchMakerContainer.opponentOptions.fadeOut:Play()

    self.game.playerControls.deck = deck
    
    C_Timer.After(1.5, function ()
        self.game.matchMakerContainer.matchCreationInfo.opponentFoundAnim:Play()
    end)

    C_Timer.After(3.0, function ()
        self.game.matchMakerContainer.matchCreationInfo.deckConfirmationAnim:Play()
    end)

end

function HearthstoneLiteMixin:Comms_OnPokeResponse(data)
    self.game.lobby.membersList.DataProvider:Insert({
        label = data.target,
    })
end










--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- hyperlinks
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--


local hyperlinkCard = CreateFrame("CheckButton", "HearthstoneLiteHyperlinkCardTip", UIParent, "HslCard")
hyperlinkCard:SetPoint("CENTER", 0, 0)
hyperlinkCard:Hide()
-- add a close button
hyperlinkCard.close = CreateFrame("BUTTON", nil, hyperlinkCard, "UIPanelCloseButton")
hyperlinkCard.close:SetPoint("TOPRIGHT", 4, 4)
hyperlinkCard.close:SetScript("OnClick", function(self)
    self:GetParent():Hide()
end)


local function parseCardHyperlink(link, showCard)
    local linkType, addon, _art, _class, _id, _name, _health, _attack, _ability, _power, _cost, _backgroundPath, _background, _atlas, _rarity = strsplit("?", link)
    if _name and showCard then
        hyperlinkCard:Hide()
        hyperlinkCard:CreateFromData({
            art = tonumber(_art),
            name = _name,
            class = _class,
            health = tonumber(_health),
            attack = tonumber(_attack),
            ability = tonumber(_ability),
            power = tonumber(_power),
            cost = tonumber(_cost),
            backgroundPath = _backgroundPath,
            background = tonumber(_background),
            atlas = _atlas,
            rarity = tonumber(_rarity),
        })
        hyperlinkCard:Show()
    end
end

hooksecurefunc("SetItemRef", function(link)
	local linkType, addon = strsplit("?", link)
	if linkType == "garrmission" and addon == "hslite" then
		parseCardHyperlink(link, true)
	end
end)
