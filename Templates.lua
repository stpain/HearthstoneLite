local _, hsl = ...

local L = hsl.locales;

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

                -- this needs to be updated to the new universal deckBuilderMixin
                HearthstoneLite.deckBuilder.cardViewer.showClass:SetBackground_Atlas(string.format("classicon-%s", classFile:lower()))
                HearthstoneLite.deckBuilder:CreateFromDatas(HSL.collection[classFile:lower()])
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

function HslCardListviewItemMixin:OnLoad()
    NineSliceUtil.ApplyLayout(self, NineSliceLayouts.TooltipDefaultDarkLayout)
end
function HslCardListviewItemMixin:SetDataBinding(card)
    -- quick font size hack
    self.Cost:SetText(card.cost)
    self.Name:SetText(card.name)
    self.Icon:SetTexture(card.art)

    self:SetScript("OnEnter", function ()
        HearthstoneLiteTooltipCard:SetPoint("TOPRIGHT", self, "TOPLEFT")
        HearthstoneLiteTooltipCard:CreateFromData(card)
        HearthstoneLiteTooltipCard:Show()
    end)
    self:SetScript("OnLeave", function()
        HearthstoneLiteTooltipCard:Hide()
    end)
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