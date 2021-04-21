

local _, hsl = ...

hsl.db = {}


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- abilities
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local abilities = {}
abilities[0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities[1] = {
    info = "Taunt",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities[2] = {
    info = "Divine shield",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities[3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}


hsl.db.abilities = abilities;


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- battlecry
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local battlecries = {}
battlecries[0] = {
    info = "",
    func = nil,
}
battlecries[1] = {
    info = "Attack a single target for %d damage",
    func = function(sender, target)
        if sender and target then
            target.health = target.health - sender.attack;
        end
    end,
}

hsl.db.battlecries = battlecries;


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- deathrattle
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local deathrattles = {}
deathrattles[0] = {
    info = "",
    func = nil,
}
deathrattles[1] = {
    info = "Attack a single target for %d damage",
    func = function(sender, target)
        if sender and target then
            target.health = target.health - sender.attack;
        end
    end,
}

hsl.db.deathrattles = deathrattles;

