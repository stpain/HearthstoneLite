local _, hsl = ...

local L = hsl.locales;

HslSquareButtonMixin = {}
HslSquareButtonMixin.tooltipText = "";
HslSquareButtonMixin.enabled = true;
HslSquareButtonMixin.contentFrameKey = nil;

function HslSquareButtonMixin:SetBackground_Atlas(fileID)
    self.Background:SetAtlas(fileID)
    self.Background:SetSize(56, 56)
end

function HslSquareButtonMixin:OnEnter()
    local this = self;
    self.Highlight:Show()
    GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT')
    GameTooltip:AddLine(L[this.className])
    GameTooltip:Show()
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



HslDeckListviewItemMixin = {}

function HslDeckListviewItemMixin:SetText(text)
    self.Text:SetText(text)
end

function HslDeckListviewItemMixin:SetClassID(id)
    self.classID = id;
end

function HslDeckListviewItemMixin:SetDeckID(id)
    self.deckID = id;
end


HslDeleteDeckMixin = {}

function HslDeleteDeckMixin:OnMouseDown()
    local classID = self:GetParent().classID;
    local deckID = self:GetParent().deckID;
    if classID and deckID then
        local key = nil;
        for k, v in ipairs(HSL.decks[classID]) do
            if tonumber(v.ID) == tonumber(deckID) then
                key = k;
            end
        end
        if key then
            table.remove(HSL.decks[classID], key)
        end
    end
    self:GetParent().callback(classID);
end


HslCardMixin = {}

function HslCardMixin:OnShow()
    -- quick font size hack
    local fontName, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(fontName, 20, fontFlags)
    self.power:SetFont(fontName, 20, fontFlags)
    self.health:SetFont(fontName, 20, fontFlags)
    self.name:SetFont(fontName, 14, fontFlags)

    self.art:SetTexture("interface/encounterjournal/ui-ej-boss-wrathion.blp")

    self.info:SetText("Flame Dragon breathes fire in a frontal cone disorientating enemies for 1 round")
end

function HslCardMixin:SetArtByFileName(fileName)
    self.art:SetTexture(fileName)
end

function HslCardMixin:SetArtByFileID(fileID)
    self.art:SetTexture(fileID)
end

function HslCardMixin:LoadCard(card)
    self.art:SetTexture(card.art)
    self.cost:SetText(card.cost)
    self.power:SetText(card.power)
    self.health:SetText(card.health)
    self.name:SetText(card.name)
    self.info:SetText(card.info)

    self.elite:SetShown(card.elite)

    self:Show()
end





--- this is the dropdown button mixin, all that needs to happen is set the text and call any func if passed
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