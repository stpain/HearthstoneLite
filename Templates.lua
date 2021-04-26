local _, hsl = ...

local L = hsl.locales;

local LibFlyPaper = LibStub:GetLibrary("LibFlyPaper-1.0")

local CARD_TEMPLATE_PATH = [[Interface\Addons\HearthstoneLite\CardTemplates\]]
local CARD_ATLAS = {}

local CREATURE_TEMPLATE_WIDTH = 2048
local CREATURE_TEMPLATE_HEIGHT = 2048

CARD_ATLAS.CREATURE = {}
CARD_ATLAS.CREATURE[1] = {
    left = 20 / CREATURE_TEMPLATE_WIDTH,
    right = 272 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[2] = {
    left = 288 / CREATURE_TEMPLATE_WIDTH,
    right = 540 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[3] = {
    left = 555 / CREATURE_TEMPLATE_WIDTH,
    right = 807 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[4] = {
    left = 824 / CREATURE_TEMPLATE_WIDTH,
    right = 1076 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[5] = {
    left = 15 / CREATURE_TEMPLATE_WIDTH,
    right = 271 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[6] = {
    left = 290 / CREATURE_TEMPLATE_WIDTH,
    right = 541 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[7] = {
    left = 555 / CREATURE_TEMPLATE_WIDTH,
    right = 811 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[8] = {
    left = 823 / CREATURE_TEMPLATE_WIDTH,
    right = 1079 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[9] = {
    left = 18 / CREATURE_TEMPLATE_WIDTH,
    right = 271 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[10] = {
    left = 288 / CREATURE_TEMPLATE_WIDTH,
    right = 544 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[11] = {
    left = 555 / CREATURE_TEMPLATE_WIDTH,
    right = 811 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[12] = {
    left = 823 / CREATURE_TEMPLATE_WIDTH,
    right = 1080 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[13] = {
    left = 20 / CREATURE_TEMPLATE_WIDTH,
    right = 277 / CREATURE_TEMPLATE_WIDTH,
    top = 1161 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1538 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[14] = {
    left = 288 / CREATURE_TEMPLATE_WIDTH,
    right = 544 / CREATURE_TEMPLATE_WIDTH,
    top = 1161 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1538 / CREATURE_TEMPLATE_HEIGHT,
}


-- neutral cards are 1 per file so the file path will determine the image used
local NEUTRAL_TEMPLATE_WIDTH = 512
local NEUTRAL_TEMPLATE_HEIGHT = 512

CARD_ATLAS.NEUTRAL = {}
CARD_ATLAS.NEUTRAL[1] = {
    left = 0 / NEUTRAL_TEMPLATE_WIDTH,
    right = 257 / NEUTRAL_TEMPLATE_WIDTH,
    top = 20 / NEUTRAL_TEMPLATE_HEIGHT,
    bottom = 381 / NEUTRAL_TEMPLATE_HEIGHT,
}


local WEAPON_TEMPLATE_WIDTH = 1024
local WEAPON_TEMPLATE_HEIGHT = 1024

CARD_ATLAS.WEAPON = {}
CARD_ATLAS.WEAPON[1] = {
    left = 0.0 / WEAPON_TEMPLATE_WIDTH,
    right = 278 / WEAPON_TEMPLATE_WIDTH,
    top = 15 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 400 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[2] = {
    left = 291 / WEAPON_TEMPLATE_WIDTH,
    right = 569 / WEAPON_TEMPLATE_WIDTH,
    top = 15 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 400 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[3] = {
    left = 584 / WEAPON_TEMPLATE_WIDTH,
    right = 862 / WEAPON_TEMPLATE_WIDTH,
    top = 15 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 400 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[4] = {
    left = 0.0 / WEAPON_TEMPLATE_WIDTH,
    right = 278 / WEAPON_TEMPLATE_WIDTH,
    top = 434 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 819 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[5] = {
    left = 291 / WEAPON_TEMPLATE_WIDTH,
    right = 569 / WEAPON_TEMPLATE_WIDTH,
    top = 434 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 819 / WEAPON_TEMPLATE_HEIGHT,
}




HslSquareButtonMixin = {}
HslSquareButtonMixin.tooltipText = "";
HslSquareButtonMixin.enabled = true;
HslSquareButtonMixin.contentFrameKey = nil;

function HslSquareButtonMixin:Resize(x, y)
    local x1, y1 = x*0.9, y*0.9
    local x2, y2 = x*1.1, y*1.1

    self:SetSize(x, y)
    self.Border:SetSize(x2, y2)
    self.Background:SetSize(x1, y1)
    self.Highlight:SetSize(x, y)
end

function HslSquareButtonMixin:SetBackground_Atlas(fileID)
    self.Background:SetAtlas(fileID)
    local x, y = self:GetWidth(), self:GetHeight()
    self.Background:SetSize(x*0.9, y*0.9)
end

function HslSquareButtonMixin:OnEnter()
    local this = self;
    self.Highlight:Show()
    if this.tooltipText then
        GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT')
        GameTooltip:AddLine(L[this.tooltipText])
        GameTooltip:Show()
    end
end

function HslSquareButtonMixin:OnLeave()
	self.Highlight:Hide()
    GameTooltip:Hide()
end

-- function HslSquareButtonMixin:Disable()
-- 	self.enabled = false
-- end
-- function HslSquareButtonMixin:Enable()
-- 	self.enabled = true
-- end

function HslSquareButtonMixin:OnMouseUp()
    self:AdjustPointsOffset(1, 1)
end

function HslSquareButtonMixin:OnMouseDown()
    self:AdjustPointsOffset(-1, -1)
    if self.func then
        self.func()
    end
end





HslTexturedTextboxMixin = {}

function HslTexturedTextboxMixin:SetText(text, size, font)
    local fontName, fontHeight, fontFlags = self.Text:GetFont()
    fontName = font or fontName;
    self.Text:SetFont(fontName, size, fontFlags)
    self.Text:SetText(text)
end

function HslTexturedTextboxMixin:SetTexture_Atlas(atlas, size)
    self.Background:SetAtlas(atlas, size)
end

function HslTexturedTextboxMixin:ShowBackground(display)
    self.Background:SetShown(display)
end

function HslTexturedTextboxMixin:SetIcon_Atlas(atlas)
    self.Icon:SetAtlas(atlas)
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the mixin for buttons in the menu panel deck listview
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
HslMenuPanelDeckListviewItemMixin = {}

function HslMenuPanelDeckListviewItemMixin:SetText(text)
    self.Text:SetText(text)
end

function HslMenuPanelDeckListviewItemMixin:SetClassID(id)
    self.classID = id;
end

function HslMenuPanelDeckListviewItemMixin:SetDeckID(id)
    self.deckID = id;
end

function HslMenuPanelDeckListviewItemMixin:OnMouseDown()
    local classFile = HearthstoneLite.deckBuilder:GetClassInfo().classFile;
    local classID = HearthstoneLite.deckBuilder:GetClassInfo().classID;

    HearthstoneLite.deckBuilder.deckViewer:Show()
    if HSL.decks and HSL.decks[classID] and next(HSL.decks[classID]) then
        for k, deck in ipairs(HSL.decks[classID]) do
            if deck.id == self.deckID then
                self.updateDeckViewer(deck.cards)
                HearthstoneLite.deckBuilder.deckID = self.deckID;

                HearthstoneLite.deckBuilder.cardViewer.showClass:SetBackground_Atlas(string.format("classicon-%s", classFile:lower()))
                HearthstoneLite.deckBuilder:LoadCards(HSL.collection[classFile:lower()])
            end
        end
    end
end

--- this is the delete icon for the menu panel deck listview buttons
HslDeleteDeckMixin = {}

function HslDeleteDeckMixin:OnMouseDown()
    local classID = self:GetParent().classID;
    local deckID = self:GetParent().deckID;
    if classID and deckID then
        local key, name = nil, nil;
        for k, v in ipairs(HSL.decks[classID]) do
            if tonumber(v.id) == tonumber(deckID) then
                key = k;
                name = v.name
            end
        end
        if key then
            StaticPopup_Show("HslDeleteDeck", name, nil, {
                classID = classID,
                deckIndex = key,
                deleteDeck = self:GetParent().deleteDeck,
                updateDeckViewer = self:GetParent().updateDeckViewer
            })
        end
    end
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the mixin for buttons in the deck builder popout
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
HslCardListviewItemMixin = {}

function HslCardListviewItemMixin:SetCard(card)
    -- quick font size hack
    local fontName, _, fontFlags = self.Name:GetFont()
    self.Name:SetFont(fontName, 14, fontFlags)
    local fontName, _, fontFlags = self.Cost:GetFont()

    self.Cost:SetFont(fontName, 16, fontFlags)
    self.Cost:SetText(card.cost)
    self.Name:SetText(card.name)
    self.Icon:SetTexture(card.art)
end

function HslCardListviewItemMixin:OnMouseDown()
    local classID = HearthstoneLite.deckBuilder.deckViewer.classID;
    local deckID = HearthstoneLite.deckBuilder.deckViewer.deckID;

    if IsControlKeyDown() then
        --HearthstoneLite.deckBuilder.deckViewer:RemoveCard(self.card)
        HearthstoneLite.deckBuilder:RemoveCard(self.card)
    end
end



--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the mixin for the cards
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
HslCardMixin = {}

function HslCardMixin:OnShow()
    -- quick font size hack
    local fontName, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(fontName, 28, fontFlags)
    self.attack:SetFont(fontName, 28, fontFlags)
    self.health:SetFont(fontName, 28, fontFlags)
    self.name:SetFont(fontName, 10, fontFlags)
end

function HslCardMixin:ScaleTo(scale)
    if not scale then
        scale = 1;
    end
    local fontSize = 28 * (scale * 0.85);
    local fontName, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(fontName, fontSize, fontFlags)
    self.attack:SetFont(fontName, fontSize, fontFlags)
    self.health:SetFont(fontName, fontSize, fontFlags)
    self.name:SetFont(fontName, 10 * scale, fontFlags)

    self:SetScale(scale)
end

function HslCardMixin:LoadCard(card, printInfo)
    if not card then
        return
    end

    self.selected = false;

    --self.defaults = card;
    self.card = {}
    for k, v in pairs(card) do
        self.card[k] = v;
        if printInfo then
            --print(string.format('    set card data [%s] >> %s', k, v)) 
        end
    end

    --self.card = card;
    self.art:SetTexture(card.art)
    self.cost:SetText(card.cost)
    self.attack:SetText(card.attack)
    self.health:SetText(card.health)
    self.name:SetText(card.name)
    self.info:SetText("")

    -- i had issues keeping the card text updated, using C_Timer to delay the update func by a frame
    local function infoDelay()
        if card.battlecry and card.battlecry > 0 then
            self.info:SetText(L["battlecry"]..string.format(hsl.db.battlecries[card.battlecry].info, card.power))
        end
        if card.deathrattle and card.deathrattle > 0 then
            self.info:SetText(L["deathrattle"]..string.format(hsl.db.deathrattles[card.deathrattle].info, card.power))
        end
        if card.ability and card.ability > 0 then
            self.info:SetText(string.format(hsl.db.abilities[card.class][card.ability].info, card.power))
        end
    end
    C_Timer.After(0, infoDelay)

    if card.background > 4 then
        self.name:SetPoint("CENTER", 4, -8)
    else
        self.name:SetPoint("CENTER", 4, -4)
    end

    for _, attribute in ipairs({"cost", "attack", "health"}) do
        if self.card[attribute] then
            self[attribute]:Show();
        else
            self[attribute]:Hide();
        end
    end

    self.cardTemplate:SetTexture(CARD_TEMPLATE_PATH..card.backgroundPath)

    -- card.atlas = the atlas table to use
    -- card.background = the card number from the file to use
    self.cardTemplate:SetTexCoord(
        CARD_ATLAS[card.atlas][card.background].left, 
        CARD_ATLAS[card.atlas][card.background].right, 
        CARD_ATLAS[card.atlas][card.background].top, 
        CARD_ATLAS[card.atlas][card.background].bottom
    )

    self:Show()
end

function HslCardMixin:OnHide()
    self.art:SetTexture(nil)
    self.cost:SetText("")
    self.attack:SetText("")
    self.health:SetText("")
    self.name:SetText("")
    self.info:SetText("")

    self.selected = false;
    self.cardSelected:SetShown(self.selected)

    self.card = nil;
    self.drawnID = nil;
end

function HslCardMixin:OnMouseUp()

end

function HslCardMixin:OnMouseDown()
    if not self.card then
        return;
    end
    --dev stuffs
    if IsAltKeyDown() then
        print('data table for card:', self.card.name)
        for k, v in pairs(self.card) do
            print(string.format('    card data [%s] = %s', k, v))
        end
    end

    self.selected = not self.selected;
    self.cardSelected:SetShown(self.selected)

    --use parent name to determine action TODO: setup more templates ?
    local parent = self:GetParent():GetName();
    if parent then
        if parent == "deckBuilderCardViewer" and IsControlKeyDown() then
            --HearthstoneLite.deckBuilder.deckViewer:AddCard(self.card)
            HearthstoneLite.deckBuilder:AddCard(self.card)
            return;
        end
    end

end

local tooltipCard;

function HslCardMixin:OnEnter()
    if self.showTooltipCard then
        tooltipCard:LoadCard(self.card)
        tooltipCard:ClearAllPoints()
        tooltipCard:SetPoint("BOTTOM", self, "TOP", 0, 0) -- this needs to be changable by the user
        tooltipCard:Show()
        tooltipCard:ScaleTo(self.tooltipScaleTo)
        tooltipCard:SetFrameStrata("TOOLTIP")
    end
end

function HslCardMixin:OnLeave()
    tooltipCard:Hide()
end

tooltipCard = CreateFrame("FRAME", "HearthstoneLiteTooltipCard", UIParent, "HslCard")
tooltipCard:SetPoint("CENTER", 0, 0)
tooltipCard:SetFrameLevel(500)
tooltipCard:Hide()
-- add a close button
tooltipCard.close = CreateFrame("BUTTON", nil, tooltipCard, "UIPanelCloseButton")
tooltipCard.close:SetPoint("TOPRIGHT", 4, 4)
tooltipCard.close:SetScript("OnClick", function(self)
    self:GetParent():Hide()
end)


---return a custom hyperlink for a card
---@return string hyperlink clickable link that can be shared with other hsl addon users
function HslCardMixin:GetCardLink()
    if not self.card then
        return
    end
    local link = string.format("|cFFFFFF00|Hgarrmission:hslite:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s|h%s|h|r",
    tostring(self.card.art),
    tostring(self.card.class),
    tostring(self.card.name), 
    tostring(self.card.id), 
    tostring(self.card.health), 
    tostring(self.card.attack),  
    tostring(self.card.ability), 
    tostring(self.card.power), 
    tostring(self.card.battlecry), 
    tostring(self.card.deathrattle), 
    tostring(self.card.cost), 
    tostring(self.card.backgroundPath), 
    tostring(self.card.background), 
    tostring(self.card.atlas), 
    tostring(self.card.rarity), 
    ITEM_QUALITY_COLORS[self.card.rarity].hex.."["..self.card.name.."]|r"
    )
    return link;
end


-- cards ont he battlefield
HslBattlefieldCardMixin = {}
HslBattlefieldCardMixin.tooltipScaleTo = 1.25

function HslBattlefieldCardMixin:OnUpdate()
    if self.isMouseDown == true then
        local x1, y1 = self.startCursorPosX, self.startCursorPosY
        local x2, y2 = self.endCursorPosX, self.endCursorPosY

        local a = math.atan2(y2 - y1, x2 - x1)
        print(a)
    end
end

function HslBattlefieldCardMixin:OnEnter()
    if self.showTooltipCard then
        tooltipCard:LoadCard(self.card)
        tooltipCard:ClearAllPoints()
        tooltipCard:SetPoint("RIGHT", self, "LEFT", 0, 0) -- this needs to be changable by the user
        tooltipCard:Show()
        tooltipCard:ScaleTo(self.tooltipScaleTo)
        tooltipCard:SetFrameStrata("TOOLTIP")
    end

    if self:GetParent() == HearthstoneLite.gameBoard.playerBattlefield then
        --self.attackArrow:Show()
    end
end

function HslBattlefieldCardMixin:OnLeave()
    tooltipCard:Hide()
    --self.attackArrow:Hide()
end

function HslBattlefieldCardMixin:OnMouseDown()
    if not self.card then
        return;
    end
    --dev stuffs
    if IsAltKeyDown() then
        print('data table for card:', self.card.name)
        for k, v in pairs(self.card) do
            print(string.format('    card data [%s] = %s', k, v))
        end
    end
    print("card parent:",self:GetParent():GetName())

    local gb = HearthstoneLite.gameBoard;

    -- handle the card selection
    local x = self.selected
    for _, card in ipairs(self:GetParent().cards) do
        card.selected = false;
        card.cardSelected:SetShown(card.selected)
    end
    self.selected = not x;
    self.cardSelected:SetShown(false)
    --self.cardSelected:SetShown(self.selected)

    if self.selected then
        self:GetParent().selectedCard = self;
        self.attackArrow:Show()
        print(string.format("selected card %s", self.card.name))
    else
        self.attackArrow:Hide()
        self:GetParent().selectedCard = nil;
        print(string.format("deselected card %s", self.card.name))
    end


    if gb.playerBattlefield.selectedCard and gb.targetBattlefield.selectedCard then
        gb:PlayBasicAttack(gb.playerBattlefield.selectedCard, gb.targetBattlefield.selectedCard)
    end

    if gb.playerControls:IsMouseOver() then --IsControlKeyDown() and 
        self:SetMovable(true)
        self:EnableMouse(true)
        self:StartMoving()

        gb.cursorHascard = true
        gb.cursorCard = self
    else
        self:SetScript("OnDragStart", nil)
        self:SetScript("OnDragStop", nil)
        self:SetMovable(false)
    end

end


function HslBattlefieldCardMixin:OnMouseUp()
    local card = self;
    local gb = HearthstoneLite.gameBoard;
    if gb.cursorHascard == true then
        if gb.playerBattlefield:IsMouseOver() then
            if not gb.playerBattlefield.cards then --this should be done elsewhere need to see why its an issue!
                gb.playerBattlefield.cards = {}
            end
            if #gb.playerBattlefield.cards > 6 then
                gb:ReturnCardToHand(card)
            else
                if self:GetParent():GetName() == "HearthstoneGameBoardPlayerControlsHand" then
                    gb:PlayCardToBattlefield(card)
                end
            end
        else
            gb:ReturnCardToHand(card)
        end
    end

end


















--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the dropdown button mixin, all that needs to happen is set the text and call any func if passed
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
HslDropDownFlyoutButtonMixin = {}

function HslDropDownFlyoutButtonMixin:OnEnter()
    self.Highlight:Show()
end

function HslDropDownFlyoutButtonMixin:OnLeave()
    self.Highlight:Hide()
end

function HslDropDownFlyoutButtonMixin:SetText(text)
    self.Text:SetText(text)
end

function HslDropDownFlyoutButtonMixin:GetText(text)
    return self.Text:GetText()
end

function HslDropDownFlyoutButtonMixin:OnMouseDown()
    if self.func then
        self:func()
    end
    if self:GetParent().delay then
        self:GetParent().delay:Cancel()
    end
    self:GetParent():Hide()
end


--- the dropdown widget mixin
HslDropdownMixin = {}

function HslDropdownMixin:GetFlyout()
    return self.Flyout
end

function HslDropdownMixin:SetText(text)
    self.Text:SetText(text)
end

function HslDropdownMixin:GetText()
    return self.Text:GetText()
end

function HslDropdownMixin:OnShow()
    local width = self:GetWidth()
    if width > 90 then
        self.BackgroundMiddle:SetWidth(width - 88)
    end
end



--- this is the button that opens/closes the dropdown
HslDropdownButtonMixin = {}

function HslDropdownButtonMixin:OnEnter()
    self.ButtonHighlight:Show()
end

function HslDropdownButtonMixin:OnLeave()
    self.ButtonHighlight:Hide()
end

function HslDropdownButtonMixin:OnMouseDown()

    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

    self.ButtonUp:Hide()
    self.ButtonDown:Show()

    local flyout = self:GetParent().Flyout
    if flyout:IsVisible() then
        flyout:Hide()
    else
        flyout:Show()
    end
end

function HslDropdownButtonMixin:OnMouseUp()
    self.ButtonDown:Hide()
    self.ButtonUp:Show()
end




HslDropdownFlyoutMixin = {}

function HslDropdownFlyoutMixin:OnLeave()
    self.delay = C_Timer.NewTicker(3, function()
        if not self:IsMouseOver() then
            self:Hide()
        end
    end)
end

function HslDropdownFlyoutMixin:OnShow()

    self:SetFrameStrata("DIALOG")

    if self.delay then
        self.delay:Cancel()
    end

    self.delay = C_Timer.NewTicker(3, function()
        if not self:IsMouseOver() then
            self:Hide()
        end
    end)

    -- the .menu needs to a table that mimics the blizz dropdown
    -- t = {
    --     text = buttonText,
    --     func = functionToRun,
    -- }
    if self:GetParent().menu then
        if not self.buttons then
            self.buttons = {}
        end
        for i = 1, #self.buttons do
            self.buttons[i]:SetText("")
            self.buttons[i].func = nil
            self.buttons[i]:SetWidth(100)
            self.buttons[i]:Hide()
        end
        for buttonIndex, info in ipairs(self:GetParent().menu) do
            if not self.buttons[buttonIndex] then
                self.buttons[buttonIndex] = CreateFrame("FRAME", "HslDropdownFlyoutButton"..buttonIndex, self, "HslDropDownButton")
                self.buttons[buttonIndex]:SetPoint("TOP", 0, (buttonIndex * -22) + 22)
            end
            self.buttons[buttonIndex]:SetText(info.text)

            while self.buttons[buttonIndex].Text:IsTruncated() do
                self:SetWidth(self:GetWidth() + 2)
            end
            --self.buttons[buttonIndex].arg1 = info.arg1
            self.buttons[buttonIndex].func = info.func
            self.buttons[buttonIndex]:Show()

            self:SetHeight(buttonIndex * 22)
            buttonIndex = buttonIndex + 1
        end
        for i = 1, #self.buttons do
            self.buttons[i]:SetWidth(self:GetWidth() - 2)
        end
    end

end



HelpTipMixin = {}

function HelpTipMixin:OnShow()

end