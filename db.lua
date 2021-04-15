

local _, hsl = ...

hsl.db = {}



hsl.db.cards = {}

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- generic cards
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

--neutral card backgrounds are determined by the backgroundPath
local generic = {}
generic[1] = {
    art = 522189,                       -- the artwork of the card that appears in the upper section inset
    name = "Gut Ripper",                -- name on card
    health = 4,                         -- card health
    power = 5,                          -- card attack power
    info = "",                          -- flavour text
    ability = false,                    -- the card's ability (not determined yet, most likely this will be a table maybe?)
    battlecry = false,                  -- effect when entering battle
    deathrattle = false,                -- effect when dies
    cost = 3,                           -- mana gem cost to play
    backgroundPath = "neutral",         -- hero/set card belongs to -> this also determines the card background art
    background = 1,                     -- this is the background of the card, from topleft 1>14 as viewed on template.tga
    atlas = "NEUTRAL",                  -- this determines the texcoords used only weapon or neutral require different
}
generic[2] = {
    art = 522207,
    name = "Flame Hound",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral",
    background = 1,
    atlas = "NEUTRAL",
}
generic[3] = {
    art = 522206,
    name = "The Baron",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral_common",
    background = 1,
    atlas = "NEUTRAL",
}
generic[4] = {
    art = 522243,
    name = "Troll Priest",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral",
    background = 1,
    atlas = "NEUTRAL",
}
generic[5] = {
    art = 522257,
    name = "Obsidian Drake",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral_legendary",
    background = 1,
    atlas = "NEUTRAL",
}
generic[6] = {
    art = 522207,
    name = "Flame Hound",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral",
    background = 1,
    atlas = "NEUTRAL",
}
generic[7] = {
    art = 522261,
    name = "Fire Elemental",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral_epic",
    background = 1,
    atlas = "NEUTRAL",
}
generic[8] = {
    art = 536053,
    name = "Archbishop",
    health = 4,
    power = 5,
    info = "Weilding the power of the void, this once noble bishop now corrupted serves only darkness",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral_rare",
    background = 1,
    atlas = "NEUTRAL",
}
generic[9] = {
    art = 536054,
    name = "Unknown",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "neutral",
    background = 1,
    atlas = "NEUTRAL",
}

hsl.db.cards.generic = generic;


-- all other cards use the background value as an identifier for the card in the file topleft=1

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- druid
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local druid = {}
druid[1] = {
    art = 536054,
    name = "Elf druid",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "druid",
    background = 6,
    atlas = "CREATURE",
}

hsl.db.cards.druid = druid;

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- hunter
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local hunter = {}
hunter[1] = {
    art = 536054,
    name = "Blood hunter",
    health = 4,
    power = 5,
    info = "",
    ability = false,
    battlecry = false,
    deathrattle = false,
    cost = 3,
    backgroundPath = "hunter",
    background = 9,
    atlas = "CREATURE",
}

hsl.db.cards.hunter = hunter;