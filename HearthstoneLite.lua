--shop-games-legiondeluxe-card

local addonName, hsl = ...

local L = hsl.locales

local randomSeed = time()

local showHelptips = false;
local helptips = {}

local function fontSizeHack(obj, size)
    -- font size hack
    local fontName, _, fontFlags = obj:GetFont()
    obj:SetFont(fontName, size, fontFlags)
end

local function navigateTo(frame)
    for k, frame in ipairs(HearthstoneLite.frames) do
        frame:Hide()
    end
    HearthstoneLite[frame]:Show()

    for k, frame in ipairs(helptips) do
        frame:SetShown(showHelptips)
    end
end

local function lootOpened()
    print('looting for hearthstone')
    local rnd = math.floor(random()*10)
    print(rnd)
end


---deck view popout listview update function
---@param deck table the deck to view
local function deckViewerListview_Update(deck)
    if not deck then
        return
    end
    if not HSL then
        return
    end
    if not HSL.decks then
        return
    end

    HearthstoneDeckViewerMixin.deck = deck;

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.deckBuilder.deckViewer.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.deckBuilder.deckViewer.listview);

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:Hide()
    end

    local items = deck;

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        local itemIndex = buttonIndex + offset

        if itemIndex <= #items then
            local item = items[itemIndex]
            button:SetCard(item)
            button:Show()

            button.card = item; --set the button.card to the hsl.db.card

            button.callback = deckViewerListview_Update;
        else
            button.card = nil;
            button:Hide()
        end
    end

    HybridScrollFrame_Update(HearthstoneLite.deckBuilder.deckViewer.listview, #deck * 36, HearthstoneLite.deckBuilder.deckViewer.listview:GetHeight())
end


---menu panel listview update function
---@param classID number the classID to be used when creating a new deck or loading decks
local function menuPanelDeckListview_Update(classID)
    if not HSL then
        return
    end
    if not HSL.decks then
        return
    end

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.deckBuilder.menuPanel.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.deckBuilder.menuPanel.listview);

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:Hide()
    end

    if HSL.decks[classID] then

        local items = HSL.decks[classID];

        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            local itemIndex = buttonIndex + offset

            if itemIndex <= #items then
                local item = items[itemIndex]
                button:SetText(item.name)
                button:SetClassID(classID)
                button:SetDeckID(item.id)
                button:Show()

                button.deleteDeck = menuPanelDeckListview_Update; -- dirty hack, when the delete button is pressed we call this function via Getparent()

                button.updateDeckViewer = deckViewerListview_Update
            else
                button:Hide()
            end
        end

        HybridScrollFrame_Update(HearthstoneLite.deckBuilder.menuPanel.listview, #HSL.decks[classID] * 40, HearthstoneLite.deckBuilder.menuPanel.listview:GetHeight())

    else
        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            button:Hide()
        end
    end
end




---this function is used to update the menu panel listview when a new class/hero is selected
---@param button table
local function classButton_Clicked(button)
    if button then
        for i = 1, GetNumClasses() do
            local className, classFile, classID = GetClassInfo(i)
            if button.className == classFile then
                --HearthstoneLite.deckBuilder.menuPanel.listviewHeader:SetText(className, 20);
                HearthstoneLite.deckBuilder.menuPanel.listviewHeader.newDeck.classID = classID;
                HearthstoneLite.deckBuilder.menuPanel.listviewHeader.newDeck.className = className;
                --HearthstoneLite.deckBuilder.menuPanel.listviewHeader.newDeck.classIcon = button.Background:GetAtlas();

                local class = classFile:sub(1,1):upper()..classFile:sub(2):lower()
                if class == "Deathknight" then
                    class = "DeathKnight";
                end

                DeckBuilderMixin.selectedClassID = classID;
                DeckBuilderMixin.selectedClassName = className;

                HearthstoneLite.deckBuilder.menuPanel.listviewHeader:SetIcon_Atlas(string.format("GarrMission_ClassIcon-%s", class))

                menuPanelDeckListview_Update(classID)
            end
        end
    end
end



HearthstoneLiteMixin = {}

function HearthstoneLiteMixin:OnLoad()

end

function HearthstoneLiteMixin:OnShow()
    -- HearthstoneLitePortrait:SetTexture([[Interface\Addons\HearthstoneLite\Media\icon]])
    -- HearthstoneLitePortrait:SetParent(self)

    self.menuHelptip.Text:SetText(L["MenuHelptip"])
    table.insert(helptips, self.menuHelptip)

end

HearthstoneButtonMixin = {}

function HearthstoneButtonMixin:OnMouseDown()
    navigateTo("home")
end

function HearthstoneButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
    GameTooltip:AddLine(L["Menu"])
    GameTooltip:Show()
end

function HearthstoneButtonMixin:OnLeave()
    GameTooltip:Hide()
end


ToggleHelptipMixin = {}

function ToggleHelptipMixin:OnMouseDown()
    showHelptips = not showHelptips;
    for k, frame in ipairs(helptips) do
        frame:SetShown(showHelptips)
    end
end




HomeMixin = {}

function HomeMixin:OnShow()

    fontSizeHack(self.deckBuilder.Text, 22)
    self.deckBuilder.Text:SetPoint("TOP", 0, -10)
    self.deckBuilder:SetText(L["DeckBuilder"])

    fontSizeHack(self.settings.Text, 22)
    self.settings.Text:SetPoint("TOP", 0, -10)
    self.settings:SetText(L["Settings"])

end

function HomeMixin:MenuButton_OnClick(frame)
    navigateTo(frame)
end



SettingsMixin = {}

function SettingsMixin:OnShow()
    self.resetSavedVar.Text:SetText('Reset saved var')
    self.resetSavedVar.Text:SetPoint("TOP", 0, -10)
end



DeckBuilderMixin = {}
DeckBuilderMixin.selectedClassID = nil;
DeckBuilderMixin.selectedClassName = nil;

function DeckBuilderMixin:OnShow()

    self.selectHeroHelptip.Text:SetText(L["SelectHeroHelptip"])
    self.selectHeroHelptip:Show()
    table.insert(helptips, self.selectHeroHelptip)

    self.cardViewer.deckEditingHelptip.Text:SetText(L["DeckEditingHelptip"])
    self.cardViewer.deckEditingHelptip:Show()
    table.insert(helptips, self.cardViewer.deckEditingHelptip)

    self.deckViewer.deckEditingHelptip_Popout.Text:SetText(L["DeckEditingHelptipPopout"])
    self.deckViewer.deckEditingHelptip_Popout:Show()
    table.insert(helptips, self.deckViewer.deckEditingHelptip_Popout)

    self.cardViewer.cardToggleHelptip.Text:SetText(L["ClassToggleHelptip"])
    self.cardViewer.cardToggleHelptip:SetSize(200, 40)
    self.cardViewer.cardToggleHelptip:Show()
    table.insert(helptips, self.cardViewer.cardToggleHelptip)

    menuPanelDeckListview_Update(nil)

    HearthstoneLite.deckBuilder.cardViewer:HideCards()
    HearthstoneLite.deckBuilder.deckViewer:Hide()

end


HslDeckBuilderMenuPanelMixin = {}

function HslDeckBuilderMenuPanelMixin:OnLoad()

    -- font size hack
    local fontName, _, fontFlags = self.selectClass:GetFont()
    self.selectClass:SetFont(fontName, 26, fontFlags)
    self.selectClass:SetText(L["SelectHero"])

    for i = 1, GetNumClasses() do
        local className, classFile, classID = GetClassInfo(i)
        if self[classFile:lower()] then
            self[classFile:lower()]:SetBackground_Atlas(string.format("classicon-%s", classFile:lower()))
            self[classFile:lower()].func = function()
                classButton_Clicked(self[classFile:lower()])
                DeckBuilderMixin.selectedClassID = nil;
                DeckBuilderMixin.selectedClassName = nil;
            end
        end
    end

    self.listviewHeader:SetSize(240, 40)
    self.listviewHeader:SetText(L["SelectDeck"], 20)

    HybridScrollFrame_CreateButtons(self.listview, "HslDeckListviewItem", -10, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.listview, true)

end

function HslDeckBuilderMenuPanelMixin:OnShow()

end

-- TODO:
-- this is using an old system to hold the class ID
-- update this to just use the DeckBuilderMixin
HslNewDeckMixin = {}

function HslNewDeckMixin:OnMouseDown()
    if self.classID > 0 then
        StaticPopup_Show("HslNewDeck", self.className, nil, {ClassID = self.classID, Icon = self.classIcon, callback = menuPanelDeckListview_Update})
    end
end




HearthstoneCardViewerMixin = {}
HearthstoneCardViewerMixin.page = 1;
HearthstoneCardViewerMixin.cards = nil;

function HearthstoneCardViewerMixin:OnLoad()

    self.showClass:Resize(40,40)
    self.showNeutral:Resize(40,40)
    self.showNeutral:SetBackground_Atlas("GarrMission_ClassIcon-Warrior-Protection")
    self.showNeutral.func = function()
        self:LoadCards(hsl.db.cards.generic)
    end

    -- flip the next page arrow 180
    self.nextPage.Background:SetRotation(3.14)
    self.nextPage.Highlight:SetRotation(3.14)

    fontSizeHack(self.pageNumber, 32)

    self.classDropdown:SetText(L["SelectDeck"])
    self.classDropdown.menu = {}
    for i = 1, GetNumClasses() do
        local className, classFile, classID = GetClassInfo(i)
        if classFile ~= "MONK" or classFile ~= "DEMONHUNTER" then -- we dont have artwork for these classes yet
            table.insert(self.classDropdown.menu,{
                text = className;
                func = function()
                    self.classDropdown:SetText(className)
                    self:LoadCards(hsl.db.cards[className:lower()])
                end,
            });
        end
    end
    table.insert(self.classDropdown.menu,{
        text = L["Neutral"];
        func = function()
            self.classDropdown:SetText(L["Neutral"])
            self:LoadCards(hsl.db.cards.generic)
        end,
    });
end

function HearthstoneCardViewerMixin:NextPage()
    self.page = self.page + 1;
    self.pageNumber:SetText(self.page);

    local cardIndex = 1;
    if self.deck then
        for i = ((8 * self.page) - 7), (8 * self.page) do
            if self.deck[i] then
                self["card"..cardIndex]:LoadCard(self.deck[i])
            else
                self["card"..cardIndex]:ClearCard()
            end
            cardIndex = cardIndex + 1;
        end
    end
end

function HearthstoneCardViewerMixin:PrevPage()
    if self.page == 1 then
        return
    end
    self.page = self.page - 1;
    self.pageNumber:SetText(self.page);

    local cardIndex = 1;
    if self.deck then
        for i = ((8 * self.page) - 7), (8 * self.page) do
            if self.deck[i] then
                self["card"..cardIndex]:LoadCard(self.deck[i])
            else
                self["card"..cardIndex]:ClearCard()
            end
            cardIndex = cardIndex + 1;
        end
    end
end

function HearthstoneCardViewerMixin:HideCards()
    for i = 1, 8 do
        if self["card"..i] then
            self["card"..i]:Hide()
        end
    end
end

function HearthstoneCardViewerMixin:LoadCards(deck)
    if not hsl.db.cards then
        return
    end
    if not deck then
        deck = hsl.db.cards.generic
    end
    if deck then
        self.deck = deck
        self.page = 1;
        self.pageNumber:SetText(self.page);

        for i = 1, 8 do
            self["card"..i]:Hide()
        end

        for i = 1, 8 do
            if self.deck[i] then
                self["card"..i]:LoadCard(self.deck[i])
            end
        end
    end

    --deckViewerListview_Update(deck)
end


HearthstoneDeckViewerMixin = {}
HearthstoneDeckViewerMixin.deck = {};

function HearthstoneDeckViewerMixin:OnLoad()
    HybridScrollFrame_CreateButtons(self.listview, "HslCardListviewItem", -5, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.listview, true)
end

function HearthstoneDeckViewerMixin:AddCard(card)
    if not HSL then
        return;
    end
    if HSL.decks and card then
        for _, deck in ipairs(HSL.decks[self.classID]) do
            if deck.id == self.deckID then
                -- card is from the hsl.db.cards table
                -- update the saved var table and pass back into the hybrid scroll update func
                table.insert(deck.cards, card)
                deckViewerListview_Update(deck.cards)
                return;
            end
        end
    end
end

function HearthstoneDeckViewerMixin:RemoveCard(card)
    if not HSL then
        return;
    end
    local cardIndex = nil;
    if HSL.decks and card then
        for _, deck in ipairs(HSL.decks[self.classID]) do
            if deck.id == self.deckID then
                for k, v in ipairs(deck.cards) do
                    -- since we are in the correct deck we can use the card name as uniqueness
                    -- if the card count is greater than 1 then we simple remove the card with
                    -- highest key this means only 1 card is removed
                    if v.name == card.name then
                        cardIndex = k;
                    end
                end
                if cardIndex then
                    -- update the saved var table and pass back into the hybrid scroll update func
                    table.remove(deck.cards, cardIndex)
                    deckViewerListview_Update(deck.cards)
                    return;
                end
            end
        end
    end
end













--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- event frame
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local e = CreateFrame("FRAME")
e:RegisterEvent("ADDON_LOADED")
e:RegisterEvent("LOOT_OPENED")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...):lower() == "hearthstonelite" then
        print(L["HearthstoneLite"].." loaded!")
    end
    if event == "LOOT_OPENED" then
        lootOpened()
    end
end)