--shop-games-legiondeluxe-card

local addonName, hsl = ...

local L = hsl.locales


local function menuPanelDeckListview_Update(classID)
    if not HSL then
        return
    end
    if not HSL.decks then
        return
    end

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.menuPanel.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.menuPanel.listview);

    if HSL.decks[classID] then

        local items = HSL.decks[classID];

        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            local itemIndex = buttonIndex + offset

            if itemIndex <= #items then
                local item = items[itemIndex]
                button:SetText(item.Name)
                button:SetClassID(classID)
                button:SetDeckID(item.ID)
                button:Show()

                button.callback = menuPanelDeckListview_Update; -- dirty hack, when the delete button is pressed we call this function via Getparent()
            else
                button:Hide()
            end
        end

        HybridScrollFrame_Update(HearthstoneLite.menuPanel.listview, #HSL.decks[classID] * 40, HearthstoneLite.menuPanel.listview:GetHeight())

    else
        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            button:Hide()
        end
    end
end

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

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.deckViewer.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.deckViewer.listview);

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

            --button.callback = deckViewerListview_Update;
        else
            button:Hide()
        end
    end

    HybridScrollFrame_Update(HearthstoneLite.deckViewer.listview, #deck * 36, HearthstoneLite.deckViewer.listview:GetHeight())
end

local function classButton_Clicked(button)
    if button then
        for i = 1, GetNumClasses() do
            local className, classFile, classID = GetClassInfo(i)
            if button.className == classFile then
                HearthstoneLite.menuPanel.listviewHeader:SetText("|cffffffff"..className, 20);
                HearthstoneLite.menuPanel.listviewHeader.newDeck.classID = classID;
                HearthstoneLite.menuPanel.listviewHeader.newDeck.className = className;
                HearthstoneLite.menuPanel.listviewHeader.newDeck.classIcon = button.Background:GetAtlas();

                --HearthstoneLite.contentPanel:SetBackground_Atlas("Artifacts-Shaman-BG")

                menuPanelDeckListview_Update(classID)
            end
        end
    end
end



HearthstoneLiteMixin = {}

function HearthstoneLiteMixin:OnShow()
    self:SetPortraitToUnit('player')
    HearthstoneLitePortrait:SetParent(self.menuPanel)
end


HearthstoneLiteMenuPanelMixin = {}

function HearthstoneLiteMenuPanelMixin:OnLoad()

    -- font size hack
    local fontName, _, fontFlags = self.selectClass:GetFont()
    self.selectClass:SetFont(fontName, 26, fontFlags)
    self.selectClass:SetText(L["SelectDeck"])

    for i = 1, GetNumClasses() do
        local className, classFile, classID = GetClassInfo(i)
        self[classFile:lower()]:SetBackground_Atlas(string.format("classicon-%s", classFile:lower()))
        self[classFile:lower()].func = function()
            classButton_Clicked(self[classFile:lower()])
        end
    end

    self.listviewHeader:SetSize(240, 40)

    HybridScrollFrame_CreateButtons(self.listview, "HslDeckListviewItem", -10, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.listview, true)


end

function HearthstoneLiteMenuPanelMixin:OnShow()

end

HearthstoneLiteNewDeckMixin = {}

function HearthstoneLiteNewDeckMixin:OnMouseDown()
    if self.classID > 0 then
        StaticPopup_Show("HslNewDeck", self.className, nil, {ClassID = self.classID, Icon = self.classIcon, callback = menuPanelDeckListview_Update})
    end
end


HearthstoneLiteContentPanelMixin = {}

function HearthstoneLiteContentPanelMixin:SetBackground_Atlas(atlas)
    self.Background:SetAtlas(atlas)
end



HearthstoneCardViewerMixin = {}
HearthstoneCardViewerMixin.page = 1;
HearthstoneCardViewerMixin.cards = nil;

function HearthstoneCardViewerMixin:OnLoad()
    -- flip the next page arrow 180
    self.nextPage.Background:SetRotation(3.14)
    self.nextPage.Highlight:SetRotation(3.14)

    -- font size hack
    local fontName, _, fontFlags = self.pageNumber:GetFont()
    self.pageNumber:SetFont(fontName, 32, fontFlags)

    self.classDropdown:SetText(L["SelectDeck"])
    self.classDropdown.menu = {}
    for i = 1, GetNumClasses() do
        local className, classFile, classID = GetClassInfo(i)
        table.insert(self.classDropdown.menu,{
            text = className;
            func = function()
                self.classDropdown:SetText(className)
            end,
        });
    end
    table.insert(self.classDropdown.menu,{
        text = L["Neutral"];
        func = function()
            self.classDropdown:SetText(L["Neutral"])
            self:LoadCards()
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
        self["card"..i]:Hide()
    end
end

function HearthstoneCardViewerMixin:LoadCards(deck)
    if not hsl.cards then
        return
    end
    if not deck then
        deck = hsl.cards.generic
    end
    if deck then
        self.deck = deck
        self.page = 1;
        self.pageNumber:SetText(self.page);

        for i = 1, 8 do
            if self.deck[i] then
                self["card"..i]:LoadCard(self.deck[i])
            end
        end
    end

    deckViewerListview_Update(deck)
end


DeckViewerMixin = {}

function DeckViewerMixin:OnLoad()


    HybridScrollFrame_CreateButtons(self.listview, "HslCardListviewItem", -5, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.listview, true)
end
