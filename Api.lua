

local addonName, addon = ...;


--work on this
local function generateRandom()

    local val = 0;
    for i = 1, 10 do
        local seed = tostring(time())
        local rnd = math.random(1, #seed)
        local res = seed:sub(rnd, rnd)
        val = val + tonumber(res)
    end

    local div = math.random(15, 20)
    local lowMean = math.floor(val / div)
    local highMean = math.ceil(val / div)

    print("RANDOM NUM GEN:")
    if math.random(10) == 7 then
        print("1 in 10:", lowMean + math.random(3))
        return lowMean + math.random(3)
    else
        if math.random(10) > 3 then
            print("low:", lowMean)
            return lowMean
        else
            print("high:", highMean)
            return highMean
        end
    end
    print("-----------------")

end


local prefixes = {"Aba", "Zara", "Neo", "Luna", "Kai", "Evo", "Raya", "Max", "Sky", "Ivy", "Aria", "Zephyr", "Nyx", "Loki", "Kira", "Cleo", "Orion", "Nova", "Soren", "Faye"}
local suffixes = {"son", "lyn", "ra", "xis", "ton", "elle", "vian", "mond", "line", "rick", "fire", "blade", "storm", "hawk", "shade", "thorn", "dream", "flare", "shadow", "soul"}
local function generateName()

    -- Select a random prefix and suffix
    local randomPrefix = prefixes[math.random(#prefixes)]
    local randomSuffix = suffixes[math.random(#suffixes)]

    -- Concatenate the prefix and suffix to form the random name
    local randomName = randomPrefix .. randomSuffix

    return randomName
end


HearthstoneLite.Api = {}

local unitClassifications = {
    elite = true,
    rareelite = true,
    rare = true,
}
function HearthstoneLite.Api.OnLootOpened()

    local sourceGUIDs = {}

    for i = 1, GetNumLootItems() do
		local sources = {GetLootSourceInfo(i)}
        local _, name = GetLootSlotInfo(i)
		for j = 1, #sources, 2 do
            table.insert(sourceGUIDs, sources[j])
		end
	end

    -- looting creatures gives creature type cards
    -- looting chest etc gives a spell/weapon type card
    for _, guid in ipairs(sourceGUIDs) do
        local hasDrop = random(1, 100)
        if hasDrop > 10 then -- 10% chance of a card dropping
            --return
        end
        --local creatureName = C_PlayerInfo.GetClass({guid = GUID})
        --print(guid)
        if string.find(guid, "Creature-", nil, true) then

            local class, atlas = "neutral", "NEUTRAL"
            local className, classFile, classID = GetClassInfo(random(12))
            local isElite = false
            if unitClassifications[UnitClassification("mouseover")] then
                isElite = true;
            end
            local creatureType = UnitCreatureType("mouseover")
            if not addon.db.cardMeta[creatureType] then
                return
            end
            local randomKey = random(#addon.db.cardMeta[creatureType])
            local art = addon.db.cardMeta[creatureType][randomKey].fileID

            local rnd = math.random(1,100)
            if rnd > 22 then
                --as not all wow classes exists in HS these will just produce neutral cards for now
                if classFile:lower() == "demonhunter" then
                    class = "neutral";
                    atlas = "NEUTRAL";
                elseif classFile:lower() == "monk" then
                    class = "neutral";
                    atlas = "NEUTRAL";
                elseif classFile:lower() == "evoker" then
                    class = "neutral";
                    atlas = "NEUTRAL";
                else
                    class = classFile:lower();
                    atlas = "CREATURE";
                end
            else
                classID = -1; --pure neutral
            end
            local card, link = HearthstoneLite.Api.GenerateCreatureCard(class, atlas, art, isElite, classID)
            return card, link
        end
    end
end

function HearthstoneLite.Api.GetHeroAtlas(classID, specID)
    local _, className = GetClassInfo(classID)
    local id, specName, description, icon, role, isRecommended, isAllowed = GetSpecializationInfoForClassID(classID, specID)
    return string.format("spec-thumbnail-%s-%s", className:gsub(" ", ""):lower(), specName:gsub(" ", ""):lower())
end

function HearthstoneLite.Api.GetBackgroundForHero(classID, specID)
    local _, className = GetClassInfo(classID)
    local id, specName, description, icon, role, isRecommended, isAllowed = GetSpecializationInfoForClassID(classID, specID)
    return string.format("talents-background-%s-%s", className:lower(), specName:gsub(" ", ""):lower())
end

function HearthstoneLite.Api.GetRandomBackgroundForClass(classID)
    local _, className = GetClassInfo(classID)
    local rndSpec = math.random(1, GetNumSpecializationsForClassID(classID))
    local id, specName, description, icon, role, isRecommended, isAllowed = GetSpecializationInfoForClassID(classID, rndSpec)
    --print(className, rndSpec, specName)
    return string.format("talents-background-%s-%s", className:lower(), specName:gsub(" ", ""):lower())
end


function HearthstoneLite.Api.GenerateCreatureCard(_class, _atlas, _art, isElite, classID)


    local cardItemLevel = math.random(3, 25)

    local isUncommon = (cardItemLevel > 12) and true or false;
    local isRare = (cardItemLevel > 18) and true or false;
    local isEpic = (cardItemLevel > 22) and true or false;

    local hasAbility;

    if isUncommon and (not isRare) and (not isEpic) then
        hasAbility = (math.random() > 0.7) and true or false;
    end
    if isRare and (not isEpic) then
        hasAbility = (math.random() > 0.5) and true or false;
    end
    if isEpic then
        hasAbility = (math.random() > 0.3) and true or false;
    end
    if isElite then
        hasAbility = true;
        cardItemLevel = 28;
    end

    local adjuster = math.random()
    local cil = cardItemLevel / 2.5
    local health = math.floor(cil * adjuster)
    local attack = math.floor(cil * (1 - adjuster))

    if health == 0 then
        health = 1;
    end

    local abilityID, abilityPower = -1, -1;
    if hasAbility then
        abilityID = random(#addon.db.abilities)
        abilityPower = (cardItemLevel / 3) * adjuster;

        -- bump up taunt ability card health value
        if abilityID == 1 then
            health = health + random(2, 4)
        end
    end


    -- generate the cost
    local cost = ((attack + health) < 7) and math.floor((attack + health) / 3) or math.ceil((attack + health) / 3) + 1
    if abilityPower > 0 then
        cost = cost + math.ceil((abilityPower + 3) / 3)
    end
    -- cap cost at 9
    if cost > 9 then
        cost = 9
    end
    if cost == 0 then
        cost = 1;
    end

    local card = {
        id = time(),
        art = _art,
        name = generateName(),
        health = health,
        attack = attack,
        cost = cost,
        backgroundPath = _class,
        background = 1,
        atlas = _atlas,
        rarity = 1,
        classID = classID,
        ability = abilityID;
        power = abilityPower;
    };


    if (not isUncommon) and (not isRare) and (not isEpic) then
        --common 5 these get no ability or bcdr
        card.background = 5;
        card.rarity = 1;
        if card.atlas == "NEUTRAL" then
            card.background = 1;
            card.backgroundPath = "neutral"
        end  
    end

    if isUncommon and (not isRare) and (not isEpic) then
        --uncommon 7 ability decided earlier
        card.background = 7;
        card.rarity = 2
        if card.atlas == "NEUTRAL" then
            card.background = 1;
            card.backgroundPath = "neutral_common"
        end  
    end

    if isRare and (not isEpic) then
        --rare 9
        card.background = 9;
        card.rarity = 3;
        if card.atlas == "NEUTRAL" then
            card.background = 1;
            card.backgroundPath = "neutral_rare"
        end     
    end

    if isEpic then
        --epic 11
        card.background = 11;
        card.rarity = 4;
        if card.atlas == "NEUTRAL" then
            card.background = 1;
            card.backgroundPath = "neutral_epic"
        end 
    end

    if isElite then
        --legendary
        card.cost = math.ceil((random(4) + random(4,8) + random(8,16)) / 3)
        card.background = 13;
        card.rarity = 5;
        if card.atlas == "NEUTRAL" then
            card.background = 1;
            card.backgroundPath = "neutral_legendary"
        end 
    end

    local link = string.format("|cFFFFFF00|Hgarrmission?hslite?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s|h%s|h|r",
        tostring(card.art),
        tostring(card.class),
        tostring(card.name), 
        tostring(card.health), 
        tostring(card.attack),  
        tostring(card.ability), 
        tostring(card.power), 
        tostring(card.cost), 
        tostring(card.backgroundPath), 
        tostring(card.background), 
        tostring(card.atlas), 
        tostring(card.rarity), 
        ITEM_QUALITY_COLORS[card.rarity].hex.."["..card.name.."]|r"
    )
    --print(string.format("|cff1D9800You receive hearthstone card:|r %s", link))

    return card, link
end

















---scan the looted guids and determine a drop chance
local function lootOpened()

    local sourceGUIDs = {}

    for i = 1, GetNumLootItems() do
		local sources = {GetLootSourceInfo(i)}
		for j = 1, #sources, 2 do
			sourceGUIDs[sources[j]] = false;
		end
	end

    -- looting creatures gives creature type cards
    -- looting chest etc gives a spell/weapon type card
    for GUID, _ in pairs(sourceGUIDs) do
        local hasDrop = random(1, 100)
        if hasDrop > 10 then -- 10% chance of a card dropping
            --return
        end
        --local creatureName = C_PlayerInfo.GetClass({guid = GUID})
        if GUID:find("Creature") then
            for i = 1, 100 do
                -- determine class, name and art
                local class, atlas, name, art;
                local className, classFile, classID = GetClassInfo(random(12))
                if classFile:lower() == "demonhunter" or classFile:lower() == "monk" then
                    class = "neutral";
                    atlas = "NEUTRAL";
                else
                    class = classFile:lower();
                    atlas = "CREATURE";
                end
                local creatureType = UnitCreatureType("mouseover")
                if not addon.db.cardMeta[creatureType] then
                    return
                end
                if not addon.db.cardMeta[creatureType][class] then
                    return
                end
                if not next(addon.db.cardMeta[creatureType][class]) then
                    return
                end
                local randomKey = random(#addon.db.cardMeta[creatureType][class])
                name = addon.db.cardMeta[creatureType][class][randomKey].name
                art = addon.db.cardMeta[creatureType][class][randomKey].fileID
                local isElite = UnitClassification("mouseover") == "elite" and true or false
                generateCreatureCard(class, atlas, name, art, false, isElite)
            end
        elseif GUID:find("GameObject") then

        end
    end
end








local Settings = {}
function Settings.MakeDummyDeck()
    local cards = {}
    local ct = {
        "Beast",
        "Humanoid",
        "Elemental",
        "Undead",
        "Demon",
        "Giant",
        "Dragonkin",
    }
    for k, class in pairs({"druid", "hunter", "rogue", "shaman", "mage", "paladin", "priest", "warlock", "warrior", "deathknight"}) do
        for i = 1, math.random(45, 55) do
            local creatureType = ct[random(#ct)]
            if addon.db.cardMeta[creatureType][class] and next(addon.db.cardMeta[creatureType][class]) then
                local randomKey = random(#addon.db.cardMeta[creatureType][class])
                local isElite = (random(100) > 50) and true or false;
                local card, link = HearthstoneLite.Api.GenerateCreatureCard(class, "CREATURE", addon.db.cardMeta[creatureType][class][randomKey].name, addon.db.cardMeta[creatureType][class][randomKey].fileID, isElite)
                table.insert(cards, card)
            end
        end
    end
    local class = "neutral";
    for i = 1, math.random(45, 55) do
        local creatureType = ct[random(#ct)]
        if addon.db.cardMeta[creatureType][class] and next(addon.db.cardMeta[creatureType][class]) then
            local randomKey = random(#addon.db.cardMeta[creatureType][class])
            local isElite = (random(100) > 85) and true or false;
            local card, link = HearthstoneLite.Api.GenerateCreatureCard(class, "NEUTRAL", addon.db.cardMeta[creatureType][class][randomKey].name, addon.db.cardMeta[creatureType][class][randomKey].fileID, isElite)
            table.insert(cards, card)
        end
    end

    return cards;
end


addon.Settings = Settings;