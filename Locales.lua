local name, addon = ...;

local L = {}
L.enUS = {
    LOBBY = "Lobby",
    GAME = "Game",
    DECKS = "Decks",
    COLLECTION = "Collection",

    NEUTRAL_CARDS = "Neutral Cards",
    CLASS_CARDS = "Class Cards",


    BATTLE_CRY = "Battle Cry:",
    DEATH_RATTLE = "Death Rattle:",
}


addon.locales = L[GetLocale()]