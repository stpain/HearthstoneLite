

local addonName, hsl = ...

local L = {}

L["InfoMsg"] = "[|cff0070DDHearthstone Lite|r] "
L["HearthstoneLite"] = "Hearthstone Lite"
L["Ok"] = "Ok"
L["Create"] = "Create"
L["Delete"] = "Delete"
L["Cancel"] = "Cancel"
L["Collection"] = "Collection"
L["DeckBuilder"] = "Deck builder"
L["NewDeck"] = "Create new deck for" -- used in the static popup dialog
L["DeleteDeck"] = "Do you want to delete" -- used in the static popup dialog
L["SelectClass"] = "Select Class"
L["SelectHero"] = "Select Hero"
L["SelectDeck"] = "Select Deck"
L["Neutral"] = "Neutral"
L["ShowClassCards"] = "Show class cards"
L["ShowNeutralCards"] = "Show neutral cards"
L["Menu"] = "Menu"
L["Settings"] = "Settings"
L["ResetGlobalSettings"] = "Reset all settings? This will delete all your decks and progress!"
L["GlobalSettingsReset"] = "account settings have been reset."

L["MenuHelptip"] = "Click the Hearthstone to return to the menu"
L["SelectHeroHelptip"] = "Select a class to view decks.\n\nClick here to create new decks"
L["DeckEditingHelptip"] = "|cff0070DDCtrl|r+click on a card to add it to your deck."
L["DeckEditingHelptipPopout"] = "|cff0070DDCtrl|r+click on a card to remove it from your deck"
L["ClassToggleHelptip"] = "Toggle between class or neutral cards"

L["battlecry"] = "|cff000000Battlecry|r "
L["deathrattle"] = "|cff000000Deathrattle|r "

-- class and spec
L['DEATHKNIGHT'] = 'Death Knight'
L['DEMONHUNTER'] = 'Demon Hunter'
L['DRUID'] = 'Druid'
L['HUNTER'] = 'Hunter'
L['MAGE'] = 'Mage'
L['MONK'] = 'Monk'
L['PALADIN'] = 'Paladin'
L['PRIEST'] = 'Priest'
L['SHAMAN'] = 'Shaman'
L['ROGUE'] = 'Rogue'
L['WARLOCK'] = 'Warlock'
L['WARRIOR'] = 'Warrior'
--mage/dk
L['Arcane'] = 'Arcane'
L['Fire'] = 'Fire'
L['Frost'] = 'Frost'
L['Blood'] = 'Blood'
L['Unholy'] = 'Unholy'
--druid/shaman
L['Restoration'] = 'Restoration'
L['Enhancement'] = 'Enhancement'
L['Elemental'] = 'Elemental'
L['Cat'] = 'Cat'
L['Bear'] = 'Bear'
L['Balance'] = 'Balance'
--rogue
L['Assassination'] = 'Assassination'
L['Combat'] = 'Combat'
L['Subtlety'] = 'Subtlety'
--hunter
L['Marksmanship'] = 'Marksmanship'
L['Beast Master'] = 'Beast Master'
L['Survival'] = 'Survival'
--warlock
L['Destruction'] = 'Destruction'
L['Affliction'] = 'Affliction'
L['Demonology'] = 'Demonology'
--warrior/paladin/priest
L['Fury'] = 'Fury'
L['Arms'] = 'Arms'
L['Protection'] = 'Protection'
L['Retribution'] = 'Retribution'
L['Holy'] = 'Holy'
L['Discipline'] = 'Discipline'
L['Shadow'] = 'Shadow'

hsl.locales = L