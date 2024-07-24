

local name, addon = ...;

local savedVarsDefaults = {
    decks = {},
    collection = {},
    currency = {},
    config = {},
    
}

local SavedVars = {}

function SavedVars:Init(forceReset)

    if not HearthstoneLiteSavedVars then
        HearthstoneLiteSavedVars = savedVarsDefaults;
    end

    if forceReset then
        HearthstoneLiteSavedVars = savedVarsDefaults;
    end

    self.db = HearthstoneLiteSavedVars;

    if forceReset then
        HearthstoneLite.CallbackRegistry:TriggerEvent(HearthstoneLite.Callbacks.SavedVariables_OnReset)
    end
end

function SavedVars:AddCardToCollection(card)
    if self.db then
        table.insert(self.db.collection, card)
    end
end

function SavedVars:GetCollection(classID)
    if self.db then
        if classID then
            local t = {}
            for _, card in ipairs(self.db.collection) do
                if card.classID == classID then
                    table.insert(t, card)
                end
            end
            return t;
        else
            return self.db.collection;
        end
    end
end

function SavedVars:GetNeutralCollection()
    if self.db then
        local t = {}
        for _, card in ipairs(self.db.collection) do
            if card.class == "neutral" then
                table.insert(t, card)
            end
        end
        return t;
    end
end

function SavedVars:NewDeck(deck)
    table.insert(self.db.decks, deck)
end

function SavedVars:DeleteDeck(deck)
    local keyToRemove;
    for k, v in ipairs(self.db.decks) do
        if v.id == deck.id then
            keyToRemove = k
        end
    end
    if keyToRemove then
        table.remove(self.db.decks, keyToRemove)
    end
end

function SavedVars:GetDeck(id)
    if not id then
        return self.db.decks;
    else

    end
end

addon.SavedVars = SavedVars;