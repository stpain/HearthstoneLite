

local _, hsl = ...

local L = hsl.locales;

StaticPopupDialogs['HslNewDeck'] = {
    text = L["NewDeck"].." %s",
    button1 = L["Create"],
    button2 = L['Cancel'],
    hasEditBox = true,
    OnShow = function(self, info)
        self.button1:Disable()
        self.icon = info.Icon
    end,
    EditBoxOnTextChanged = function(self)
        if self:GetText() ~= '' then
            if(self:GetText():match("%W")) then
                self:GetParent().button1:Disable()
            end
            self:GetParent().button1:Enable()
        else
            self:GetParent().button1:Disable()
        end
    end,
    OnAccept = function(self, info)
        if not HSL then
            HSL = {};
        end
        if not HSL.decks then
            HSL.decks = {};
        end
        if not HSL.decks[info.ClassID] then
            HSL.decks[info.ClassID] = {};
        end
        table.insert(HSL.decks[info.ClassID], {
            id = time(),
            name = self.editBox:GetText(),
            cards = {},
        })
        info.callback(info.ClassID)
    end,
    OnCancel = function(self)

    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = false,
    preferredIndex = 3,
    showAlert = 1,
}

StaticPopupDialogs['HslDeleteDeck'] = {
    text = L["DeleteDeck"].." %s",
    button1 = L["Delete"],
    button2 = L['Cancel'],
    OnAccept = function(self, info)
        if not HSL then
            HSL = {};
        end
        if not HSL.decks then
            HSL.decks = {};
        end
        if HSL.decks[info.classID] then
            table.remove(HSL.decks[info.classID], info.deckIndex)
            info.deleteDeck(info.classID)
            info.updateDeckViewer({}) -- pass in an empty table to cause the popout deck viewer to clear itself
        end
    end,
    OnCancel = function(self)

    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = false,
    preferredIndex = 3,
    showAlert = 1,
}