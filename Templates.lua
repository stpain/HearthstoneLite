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


HearthstoneLiteItemInfoFrameMixin = {}

function HearthstoneLiteItemInfoFrameMixin:SetItem(item)
    if item then
        self.Icon:SetTexture(item.icon)
        self.Name:SetText(item.link)
        self.Count:SetText(item.count and item.count or 0)
        self.item = item
    else
        self.Icon:SetTexture(nil)
        self.Name:SetText(nil)
        self.Count:SetText("")
        self.item = nil
    end
end

function HearthstoneLiteItemInfoFrameMixin:OnEnter()
    if self.item and self.item.link:find("|H") then
        GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
        GameTooltip:SetHyperlink(self.item.link)
    end
end

function HearthstoneLiteItemInfoFrameMixin:OnLeave()
    GameTooltip:Hide()
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
end

function HearthstoneLiteItemInfoFrameMixin:OnHyperlinkClick()

end



HearthstoneLiteDropDownFrameMixin = {}



-- this is the dropdown button mixin, all that needs to happen is set the text and call any func if passed
HearthstoneLiteDropDownFlyoutButtonMixin = {}

function HearthstoneLiteDropDownFlyoutButtonMixin:OnEnter()
    self.Highlight:Show()
end

function HearthstoneLiteDropDownFlyoutButtonMixin:OnLeave()
    self.Highlight:Hide()
end

function HearthstoneLiteDropDownFlyoutButtonMixin:SetText(text)
    self.Text:SetText(text)
end

function HearthstoneLiteDropDownFlyoutButtonMixin:GetText(text)
    return self.Text:GetText()
end

function HearthstoneLiteDropDownFlyoutButtonMixin:OnMouseDown()
    if self.func then
        self:func()
    end
    if self:GetParent().delay then
        self:GetParent().delay:Cancel()
    end
    self:GetParent():Hide()
end


-- if we need to get the flyout although its a child so can be accessed via dropdown.Flyout
HearthstoneLiteDropdownMixin = {}

function HearthstoneLiteDropdownMixin:GetFlyout()
    return self.Flyout
end

function HearthstoneLiteDropdownMixin:OnShow()
    local width = self:GetWidth()
    if width > 90 then
        self.BackgroundMiddle:SetWidth(width - 88)
    end
end




HearthstoneLiteDropdownButtonMixin = {}

function HearthstoneLiteDropdownButtonMixin:OnEnter()
    self.ButtonHighlight:Show()
end

function HearthstoneLiteDropdownButtonMixin:OnLeave()
    self.ButtonHighlight:Hide()
end

function HearthstoneLiteDropdownButtonMixin:OnMouseDown()

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

function HearthstoneLiteDropdownButtonMixin:OnMouseUp()
    self.ButtonDown:Hide()
    self.ButtonUp:Show()
end




HearthstoneLiteDropdownFlyoutMixin = {}

function HearthstoneLiteDropdownFlyoutMixin:OnLeave()
    self.delay = C_Timer.NewTicker(3, function()
        if not self:IsMouseOver() then
            self:Hide()
        end
    end)
end

function HearthstoneLiteDropdownFlyoutMixin:OnShow()

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
            self.buttons[i]:Hide()
        end
        for buttonIndex, info in ipairs(self:GetParent().menu) do
            if not self.buttons[buttonIndex] then
                self.buttons[buttonIndex] = CreateFrame("FRAME", "HearthstoneLiteMailSummaryInboxDropdownFlyoutButton"..buttonIndex, self, "HearthstoneLiteDropDownButton")
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