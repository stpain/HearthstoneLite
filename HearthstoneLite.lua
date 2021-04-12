--shop-games-legiondeluxe-card

local addonName, hsl = ...

local L = hsl.locales

local function deckListview_Update(classID)
    if not HSL then
        return
    end
    if not HSL.decks then
        return
    end

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.MenuPanel.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.MenuPanel.listview);

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

                button.callback = deckListview_Update;
            else
                button:Hide()
            end
        end

        HybridScrollFrame_Update(HearthstoneLite.MenuPanel.listview, #HSL.decks[classID] * 30, HearthstoneLite.MenuPanel.listview:GetHeight())

    else
        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            button:Hide()
        end
    end
end

local function classButton_Clicked(button)
    if button then
        for i = 1, GetNumClasses() do
            local className, classFile, classID = GetClassInfo(i)
            if button.className == classFile then
                HearthstoneLite.MenuPanel.listviewHeader:SetText("|cffffffff"..className, 20);
                HearthstoneLite.MenuPanel.listviewHeader.newDeck.classID = classID;
                HearthstoneLite.MenuPanel.listviewHeader.newDeck.className = className;
                HearthstoneLite.MenuPanel.listviewHeader.newDeck.classIcon = button.Background:GetAtlas();

                --HearthstoneLite.ContentPanel:SetBackground_Atlas("Artifacts-Shaman-BG")

                deckListview_Update(classID)
            end
        end
    end
end



HearthstoneLiteMixin = {}

function HearthstoneLiteMixin:OnShow()
    self:SetPortraitToUnit('player')
    HearthstoneLitePortrait:SetParent(self.MenuPanel)
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
        StaticPopup_Show("HslNewDeck", self.className, nil, {ClassID = self.classID, Icon = self.classIcon, callback = deckListview_Update})
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

    self.classDropdown:SetText(L["SelectClass"])
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
            self:LoadCards("generic")
        end,
    });
end

function HearthstoneCardViewerMixin:NextPage()
    self.page = self.page + 1;
    self.pageNumber:SetText(self.page);
end

function HearthstoneCardViewerMixin:PrevPage()
    if self.page == 1 then
        return
    end
    self.page = self.page - 1;
    self.pageNumber:SetText(self.page);
end

function HearthstoneCardViewerMixin:HideCards()
    for i = 1, 8 do
        self["card"..i]:Hide()
    end
end

function HearthstoneCardViewerMixin:LoadCards(id)
    if not hsl.cards then
        return
    end
    if hsl.cards[id] then
        self.page = 1;
        self.pageNumber:SetText(self.page);

        for i = 1, 8 do
            if hsl.cards[id][i] then
                self["card"..i]:LoadCard(hsl.cards[id][i])
            end
        end
    end
end