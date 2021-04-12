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
                button:Show()
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

                HearthstoneLite.ContentPanel:SetBackground_Atlas("Artifacts-Shaman-BG")

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

    self.druid:SetBackground_Atlas("Artifacts-Druid-FinalIcon")
    self.druid.func = function()
        classButton_Clicked(self.druid)
    end

    self.hunter:SetBackground_Atlas("Artifacts-Hunter-FinalIcon")
    self.hunter.func = function()
        classButton_Clicked(self.hunter)
    end

    self.mage:SetBackground_Atlas("Artifacts-MageArcane-FinalIcon")
    self.mage.func = function()
        classButton_Clicked(self.mage)
    end

    self.shaman:SetBackground_Atlas("Artifacts-Shaman-FinalIcon")
    self.shaman.func = function()
        classButton_Clicked(self.shaman)
    end

    self.rogue:SetBackground_Atlas("Artifacts-Rogue-FinalIcon")
    self.rogue.func = function()
        classButton_Clicked(self.rogue)
    end

    self.warrior:SetBackground_Atlas("Artifacts-Warrior-FinalIcon")
    self.warrior.func = function()
        classButton_Clicked(self.warrior)
    end

    self.priest:SetBackground_Atlas("Artifacts-Priest-FinalIcon")
    self.priest.func = function()
        classButton_Clicked(self.priest)
    end

    self.monk:SetBackground_Atlas("Artifacts-Monk-FinalIcon")
    self.monk.func = function()
        classButton_Clicked(self.monk)
    end

    self.deathknight:SetBackground_Atlas("Artifacts-DeathKnightFrost-FinalIcon")
    self.deathknight.func = function()
        classButton_Clicked(self.deathknight)
    end

    self.warlock:SetBackground_Atlas("Artifacts-Warlock-FinalIcon")
    self.warlock.func = function()
        classButton_Clicked(self.warlock)
    end

    self.paladin:SetBackground_Atlas("Artifacts-Paladin-FinalIcon")
    self.paladin.func = function()
        classButton_Clicked(self.paladin)
    end

    self.demonhunter:SetBackground_Atlas("Artifacts-DemonHunter-FinalIcon")
    self.demonhunter.func = function()
        classButton_Clicked(self.demonhunter)
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