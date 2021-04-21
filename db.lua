

local _, hsl = ...

hsl.db = {}


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- abilities
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
local abilities = {
    neutral = {},
    druid = {},
    hunter = {},
    mage = {},
    paladin = {},
    priest = {},
    rogue = {},
    shaman = {},
    warlock = {},
    warrior = {},
    deathknight = {},
}

-- neutral
abilities["neutral"][0] = {
    info = "0",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["neutral"][1] = {
    info = "1",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["neutral"][2] = {
    info = "2",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["neutral"][3] = {
    info = "3",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- druid
abilities["druid"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["druid"][1] = {
    info = "Taunt",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["druid"][2] = {
    info = "Rejuvenation, target card heals for 1 health for 4 rounds",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["druid"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- hunter
abilities["hunter"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["hunter"][1] = {
    info = "Frost trap, target card unable to atack for 1 round",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["hunter"][2] = {
    info = "Turtle shell",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["hunter"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- mage
abilities["mage"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["mage"][1] = {
    info = "Mana gem, restore 1 mana",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["mage"][2] = {
    info = "Frost shield",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["mage"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- paladin
abilities["paladin"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["paladin"][1] = {
    info = "Taunt",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["paladin"][2] = {
    info = "Divine shield",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["paladin"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- priest
abilities["priest"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["priest"][1] = {
    info = "Divine prayer, heal all allies for 2 health",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["priest"][2] = {
    info = "Holy nova, deal 3 damage to target card",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["priest"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- rogue
abilities["rogue"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["rogue"][1] = {
    info = "Sap, target card is unable to attack for 2 rounds",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["rogue"][2] = {
    info = "Vanish, become un attackable for 1 round",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["rogue"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- shaman
abilities["shaman"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["shaman"][1] = {
    info = "Earth totem, absorbs 5 damage",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["shaman"][2] = {
    info = "Lightning shield, deals 1 damage to attackers",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["shaman"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- warlock
abilities["warlock"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["warlock"][1] = {
    info = "Suffering, inflict 1 damage per round",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["warlock"][2] = {
    info = "Demonic armor",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["warlock"][3] = {
    info = "Whenever you cast a spell, draw a card",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- warrior
abilities["warrior"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["warrior"][1] = {
    info = "Taunt",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["warrior"][2] = {
    info = "Rage",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["warrior"][3] = {
    info = "Whenever you deal damage gain 1 health",
    func = function(sender, target)
        -- hmm ?
    end,
}

-- deathknight
abilities["deathknight"][0] = {
    info = "",
    func = function(sender, target)
        print('no ability')
    end,
}
abilities["deathknight"][1] = {
    info = "Taunt",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["deathknight"][2] = {
    info = "Bone shield",
    func = function(sender, target)
        -- hmm ?
    end,
}
abilities["deathknight"][3] = {
    info = "Whenever a minion dies, summon a 1/1 ghoul",
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
battlecries[2] = {
    info = "Heal a single target for %d health",
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
deathrattles[2] = {
    info = "Heal a single target for %d health",
    func = function(sender, target)
        if sender and target then
            target.health = target.health - sender.attack;
        end
    end,
}

hsl.db.deathrattles = deathrattles;

