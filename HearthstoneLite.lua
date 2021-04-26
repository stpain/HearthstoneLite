
--https://www.curseforge.com/api/projects/474073/package?token=45de603f-d93c-4c20-ac24-1afba7041926


local addonName, hsl = ...

local AceComm = LibStub:GetLibrary("AceComm-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")

local LibFlyPaper = LibStub:GetLibrary("LibFlyPaper-1.0")

local L = hsl.locales

local COMMS;

local randomSeed = time()

local showHelptips = false;
local helptips = {}

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- local util functions
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

--- prints a message with addon name in []
local function printInfoMessage(msg)
    print("[|cff0070DDHearthstone Lite|r] "..msg)
end


--- adjusts the font size of a fontObject while keeping fontName and fontFlags intact
---@param obj FontInstance the font object to adjust
---@param size integer the new font size
local function fontSizeHack(obj, size)
    local fontName, _, fontFlags = obj:GetFont()
    obj:SetFont(fontName, size, fontFlags)
end


--- hides all frames in main addon UI then shows the supplied frame
---@param frame frame the frame to be shown
local function navigateTo(frame)
    for k, frame in ipairs(HearthstoneLite.frames) do
        frame:Hide()
    end
    HearthstoneLite[frame]:Show()

    for k, frame in ipairs(helptips) do
        frame:SetShown(showHelptips)
    end
end


---return a random number with a 20% chance for a bonus added
local function generateRandom()
    local r1, r2, r3, r4, r5 = random(4), random(4), random(4), random(4), random(14) -- max=28
    -- 20% chance for a bonus
    if (random(100) < 20) then
        return math.floor((r1+r2+r3+r4+r5) / 5) + random(3)
    else
        return math.floor((r1+r2+r3+r4+r5) / 5)
    end
end


---generate a random creature card
---@param _class string class/set to use as card 
---@param _atlas string atlas to use for card
---@param _name name to use as card name
---@param returnLink boolean should return a card hyperlink
---@param isElite boolean roll for legendary card from elite mob
local function generateCreatureCard(_class, _atlas, _name, _art, returnLink, isElite)

    -- generate some card values
    local _attack = generateRandom()
    local _health = generateRandom()
    -- health cannot be 0
    if _health == 0 then
        _health = 1;
    end

    --if health and attack match then 50% chance to re-roll
    if _attack == _health and (random(100) < 51) then
        _attack = generateRandom()
        _health = generateRandom()
        -- health cannot be 0
        if _health == 0 then
            _health = 1;
        end
    end

    --does card have an ability
    local _abilityID, _abilityPower = nil, nil;
    local _hasAbility = (random(10) < 6) and true or false;
    if _hasAbility then
        _abilityID = random(1, #hsl.db.abilities[_class] - 1)
        _abilityPower = generateRandom()
    else
        _abilityID = 0
        _abilityPower = 0
    end

    -- bump up taunt ability card health value
    if hsl.db.abilities[_class][_abilityID].info == "Taunt" then
        _health = _health + random(2, 4)
    end

    -- does card have battleCry or deathRattle
    local _hasBCDR = ((_abilityID == 0) and (random(10) < 4)) and true or false;
    local _battlecry = 0;
    local _deathrattle = 0;
    --if card has an ability then cancel
    if _hasBCDR then
        if random(10) < 6 then
            _battlecry = random(#hsl.db.battlecries - 1);
        else
            _deathrattle = random(#hsl.db.deathrattles - 1);
        end
        -- make sure bcdr has a power
        if _abilityPower == 0 then
            _abilityPower = random(3)
        end
    end

    -- generate the cost
    local _cost = ((_attack + _health) < 7) and math.floor((_attack + _health) / 3) or math.ceil((_attack + _health) / 3) + 1
    if _abilityPower > 0 then
        _cost = _cost + math.ceil((_abilityPower + 3) / 3)
    end
    -- cap cost at 9
    if _cost > 9 then
        _cost = 9
    end
    if _cost == 0 then
        _cost = 1;
    end

    local loot = {
        art = _art,
        name = _name,
        health = _health,
        attack = _attack,
        cost = _cost,
        backgroundPath = _class,
        background = 1,
        atlas = _atlas,
        rarity = 1,
        class = _class,
    };

    local rnd7 = random(3) -- used to decide between ability/battlecry/deathrattle for cards rare and above
    local rnd = random(100)
    -- 45%
    if rnd < 46 then
        --common 5 these get no ability or bcdr
        loot.abilityID = 0;
        loot.power = 0;
        loot.battlecry = 0;
        loot.deathrattle = 0;
        loot.background = 5;
        loot.rarity = 1;
        if loot.atlas == "NEUTRAL" then
            loot.background = 1;
            loot.backgroundPath = "neutral"
        end  
    end
    -- 35%
    if rnd > 45 and rnd < 81 then
        --uncommon 7 ability decided earlier
        loot.abilityID = _abilityID;
        loot.power = _abilityPower;
        loot.battlecry = _battlecry;
        loot.deathrattle = _deathrattle;
        loot.background = 7;
        loot.rarity = 2
        if loot.atlas == "NEUTRAL" then
            loot.background = 1;
            loot.backgroundPath = "neutral_common"
        end  
    end
    -- 15%
    if rnd > 80 and rnd < 96 then
        --rare 9
        loot.background = 9;
        loot.rarity = 3;
        loot.power = random(2,6)
        if rnd7 == 3 then
            loot.ability = random(1, #hsl.db.abilities[_class] - 1)
        elseif rnd7 == 2 then
            loot.battlecry = random(1, #hsl.db.battlecries - 1);
        else
            loot.deathrattle = random(1, #hsl.db.deathrattles - 1);
        end

        if loot.atlas == "NEUTRAL" then
            loot.background = 1;
            loot.backgroundPath = "neutral_rare"
        end     
    end
    -- 5%
    if rnd > 95 then
        --epic 11
        loot.background = 11;
        loot.rarity = 4;
        loot.power = random(4,8)
        if rnd7 == 3 then
            loot.ability = random(1, #hsl.db.abilities[_class] - 1)
        elseif rnd7 == 2 then
            loot.battlecry = random(1, #hsl.db.battlecries - 1);
        else
            loot.deathrattle = random(1, #hsl.db.deathrattles - 1);
        end

        if loot.atlas == "NEUTRAL" then
            loot.background = 1;
            loot.backgroundPath = "neutral_epic"
        end 
    end
    -- 1% and only on elite mobs
    if rnd > 90 and isElite then -- CHANGE THIS BACK TO A 1% CHANCE, 10% ONLY FOR TESTING
        --legendary
        loot.background = 13;
        loot.rarity = 5;
        loot.power = random(8,12)
        loot.health = random(7,10) -- override the health to a higher value
        if rnd7 == 3 then
            loot.ability = random(1, #hsl.db.abilities[_class] - 1)
        elseif rnd7 == 2 then
            loot.battlecry = random(1, #hsl.db.battlecries - 1);
        else
            loot.deathrattle = random(1, #hsl.db.deathrattles - 1);
        end

        if loot.atlas == "NEUTRAL" then
            loot.background = 1;
            loot.backgroundPath = "neutral_legendary"
        end 
    end

    local link;

    if not HSL.collection then
        HSL.collection = {}
    end
    if not HSL.collection[_class] then
        HSL.collection[_class] = {}
    end
    -- set a card id as the table key so we can fetch it super easy
    loot.id = #HSL.collection[_class] + 1;

    link = string.format("|cFFFFFF00|Hgarrmission:hslite:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s|h%s|h|r",
        tostring(loot.art),
        tostring(loot.class),
        tostring(loot.id),
        tostring(loot.name), 
        tostring(loot.health), 
        tostring(loot.attack),  
        tostring(loot.ability), 
        tostring(loot.power), 
        tostring(loot.battlecry), 
        tostring(loot.deathrattle), 
        tostring(loot.cost), 
        tostring(loot.backgroundPath), 
        tostring(loot.background), 
        tostring(loot.atlas), 
        tostring(loot.rarity), 
        ITEM_QUALITY_COLORS[loot.rarity].hex.."["..loot.name.."]|r"
    )
    print(string.format("|cff1D9800You receive hearthstone card:|r %s", link))

    table.insert(HSL.collection[_class], loot)

    -- return the card link
    if returnLink == true and link then
        return link
    end

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
                if not hsl.db.cardMeta[creatureType] then
                    return
                end
                if not hsl.db.cardMeta[creatureType][class] then
                    return
                end
                if not next(hsl.db.cardMeta[creatureType][class]) then
                    return
                end
                local randomKey = random(#hsl.db.cardMeta[creatureType][class])
                name = hsl.db.cardMeta[creatureType][class][randomKey].name
                art = hsl.db.cardMeta[creatureType][class][randomKey].fileID
                local isElite = UnitClassification("mouseover") == "elite" and true or false
                generateCreatureCard(class, atlas, name, art, false, isElite)
            end
        elseif GUID:find("GameObject") then

        end
    end
end


---deck view popout listview update function
---@param deck table the deck to view
local function deckViewerPopoutListview_Update(deck)
    if not deck then
        return
    end
    if not HSL then
        return
    end
    if not HSL.decks then
        return
    end

    table.sort(deck, function(a, b)
        return a.name < b.name;
    end)

    DeckBuilderMixin.deck = deck;

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.deckBuilder.deckViewer.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.deckBuilder.deckViewer.listview);

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:Hide()
    end

    local items = deck;

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        local itemIndex = buttonIndex + offset

        if itemIndex <= #items then
            local item = items[itemIndex]
            button:SetCard(item)
            button:Show()

            button.card = item; --set the button.card to the hsl.db.card

            button.callback = deckViewerPopoutListview_Update;
        else
            button.card = nil;
            button:Hide()
        end
    end

    HybridScrollFrame_Update(HearthstoneLite.deckBuilder.deckViewer.listview, #deck * 36, HearthstoneLite.deckBuilder.deckViewer.listview:GetHeight())
end


---menu panel listview update function
---@param classID number the classID to be used when creating a new deck or loading decks
local function deckViewerMenuPanelListview_Update(classID)
    if not HSL then
        return
    end
    if not HSL.decks then
        return
    end

    local buttons = HybridScrollFrame_GetButtons(HearthstoneLite.deckBuilder.menuPanel.listview);
    local offset = HybridScrollFrame_GetOffset(HearthstoneLite.deckBuilder.menuPanel.listview);

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:Hide()
    end

    if HSL.decks[classID] then

        local items = HSL.decks[classID];

        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            local itemIndex = buttonIndex + offset

            if itemIndex <= #items then
                local item = items[itemIndex]
                button:SetText(item.name)
                button:SetClassID(classID)
                button:SetDeckID(item.id)
                button:Show()

                button.deleteDeck = deckViewerMenuPanelListview_Update; -- dirty hack, when the delete button is pressed we call this function via Getparent()

                button.updateDeckViewer = deckViewerPopoutListview_Update
            else
                button:Hide()
            end
        end

        HybridScrollFrame_Update(HearthstoneLite.deckBuilder.menuPanel.listview, #HSL.decks[classID] * 40, HearthstoneLite.deckBuilder.menuPanel.listview:GetHeight())

    else
        for buttonIndex = 1, #buttons do
            local button = buttons[buttonIndex]
            button:Hide()
        end
    end
end



-- TODO: check this is setting up the new deckBuilderMixin system rather than the older menuPanel system
---this function is used to update the menu panel listview when a new class/hero is selected
---@param button table
local function classButton_Clicked(button)
    if button then
        for i = 1, GetNumClasses() do
            local className, classFile, classID = GetClassInfo(i)
            if button.className == classFile then
                --HearthstoneLite.deckBuilder.menuPanel.listviewHeader:SetText(className, 20);
                HearthstoneLite.deckBuilder.menuPanel.listviewHeader.newDeck.classID = classID;
                HearthstoneLite.deckBuilder.menuPanel.listviewHeader.newDeck.className = className;
                --HearthstoneLite.deckBuilder.menuPanel.listviewHeader.newDeck.classIcon = button.Background:GetAtlas();

                local class = classFile:sub(1,1):upper()..classFile:sub(2):lower()
                if class == "Deathknight" then
                    class = "DeathKnight";
                end

                HearthstoneLite.deckBuilder:HideCards()

                HearthstoneLite.deckBuilder.classFile = classFile;
                HearthstoneLite.deckBuilder.classID = classID;

                HearthstoneLite.deckBuilder.menuPanel.listviewHeader:SetIcon_Atlas(string.format("GarrMission_ClassIcon-%s", class))

                deckViewerMenuPanelListview_Update(classID)
            end
        end
    end
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- main UI
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

HearthstoneLiteMixin = {}

function HearthstoneLiteMixin:OnLoad()

end

function HearthstoneLiteMixin:OnShow()

    -- set helptip text and add to helptips table
    self.menuHelptip.Text:SetText(L["MenuHelptip"])
    table.insert(helptips, self.menuHelptip)
end

HearthstoneButtonMixin = {}

function HearthstoneButtonMixin:OnMouseDown()
    navigateTo("home")
    self:AdjustPointsOffset(-1, -1)
end

function HearthstoneButtonMixin:OnMouseUp()
    self:AdjustPointsOffset(1, 1)
end

function HearthstoneButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
    GameTooltip:AddLine(L["Menu"])
    GameTooltip:Show()
end

function HearthstoneButtonMixin:OnLeave()
    GameTooltip:Hide()
end


ToggleHelptipMixin = {}

function ToggleHelptipMixin:OnMouseDown()
    showHelptips = not showHelptips;
    for k, frame in ipairs(helptips) do
        frame:SetShown(showHelptips)
    end
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- home
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

HomeMixin = {}

function HomeMixin:OnShow()

    fontSizeHack(self.deckBuilder.Text, 22)
    self.deckBuilder.Text:SetPoint("TOP", 0, -10)
    self.deckBuilder:SetText(L["DeckBuilder"])

    fontSizeHack(self.settings.Text, 22)
    self.settings.Text:SetPoint("TOP", 0, -10)
    self.settings:SetText(L["Settings"])

    fontSizeHack(self.collection.Text, 22)
    self.collection.Text:SetPoint("TOP", 0, -10)
    self.collection:SetText(L["Collection"])

    fontSizeHack(self.gameBoard.Text, 22)
    self.gameBoard.Text:SetPoint("TOP", 0, -10)
    self.gameBoard:SetText(L["GameBoard"])


    -- introstinger ?
    --PlaySoundFile(1068313)

end

function HomeMixin:MenuButton_OnClick(frame)
    navigateTo(frame)
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- settings
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

SettingsMixin = {}

local function resetUI()
    deckViewerMenuPanelListview_Update()
    deckViewerPopoutListview_Update()
    HearthstoneLite.collection:HideCards()
    HearthstoneLite.collection.deck = nil;
end

function SettingsMixin:OnShow()
    self.resetSavedVar.Text:SetText('Reset saved var')
    self.resetSavedVar.Text:SetPoint("TOP", 0, -10)

    self.runFirstLoad.Text:SetText("Run first load [dev]")
end

function SettingsMixin:ResetGlobalSettings()
    StaticPopup_Show('ResetGlobalSettings', nil, nil, {callback = resetUI})
end

function SettingsMixin:RunFirstLoad()
    HSL = nil;
    HSL = {
        decks = {},
        collection = {},
    };
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
        for i = 1, 50 do
            local creatureType = ct[random(#ct)]
            if hsl.db.cardMeta[creatureType][class] and next(hsl.db.cardMeta[creatureType][class]) then
                local randomKey = random(#hsl.db.cardMeta[creatureType][class])
                local isElite = (random(100) > 50) and true or false;
                generateCreatureCard(class, "CREATURE", hsl.db.cardMeta[creatureType][class][randomKey].name, hsl.db.cardMeta[creatureType][class][randomKey].fileID, false, isElite)
            end
        end
    end
    local class = "neutral";
    for i = 1, 50 do
        local creatureType = ct[random(#ct)]
        if hsl.db.cardMeta[creatureType][class] and next(hsl.db.cardMeta[creatureType][class]) then
            local randomKey = random(#hsl.db.cardMeta[creatureType][class])
            local isElite = (random(100) > 85) and true or false;
            generateCreatureCard(class, "NEUTRAL", hsl.db.cardMeta[creatureType][class][randomKey].name, hsl.db.cardMeta[creatureType][class][randomKey].fileID, false, isElite)
        end
    end
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- collection
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

HslCollectionMixin = {}
HslCollectionMixin.page = 1;

function HslCollectionMixin:OnShow()
    if HSL.collecion then
        return
    end
    self.page = 1;
    local deck = {} -- we'll load all cards into 1 deck
    for class, cards in pairs(HSL.collection) do
        for _, card in ipairs(cards) do
            table.insert(deck, card)
        end
    end
    -- sort by set/class then by cost
    table.sort(deck, function(a, b)
        if a.backgroundPath == b.backgroundPath then -- backgroundPath=class
            return a.cost > b.cost;
        else
            return a.backgroundPath < b.backgroundPath;
        end
    end)
    if next(deck) then
        self.deck = deck;
        self.pageNumber:SetText(self.page..' / '..math.ceil(#self.deck / 10));

        for i = 1, 10 do
            self["card"..i]:Hide()
        end

        C_Timer.After(0, function()
            for i = 1, 10 do
                if self.deck[i] then
                    self["card"..i]:LoadCard(self.deck[i])
                end
            end
        end)
    end
end

function HslCollectionMixin:OnLoad()
    -- flip the next page arrow 180
    self.nextPage.Background:SetRotation(3.14)
    self.nextPage.Highlight:SetRotation(3.14)
end

function HslCollectionMixin:HideCards()
    for i = 1, 10 do
        self["card"..i]:Hide()
    end
end

function HslCollectionMixin:PrevPage()
    if not HSL.collection then
        return;
    end
    if self.page == 1 then
        return
    end
    if not self.deck then
        return
    end
    self.page = self.page - 1;
    self.pageNumber:SetText(self.page..' / '..math.ceil(#self.deck / 10));

    local cardIndex = 1;
    for i = ((10 * self.page) - 9), (10 * self.page) do
        if self.deck[i] then
            self["card"..cardIndex]:LoadCard(self.deck[i])
        else
            self["card"..cardIndex]:Hide()
        end
        cardIndex = cardIndex + 1;
    end
end

function HslCollectionMixin:NextPage()
    if not HSL.collection then
        return;
    end
    if not self.deck then
        return
    end
    if self.page == math.ceil(#self.deck / 10) then
        return
    end
    self.page = self.page + 1;
    self.pageNumber:SetText(self.page..' / '..math.ceil(#self.deck / 10));

    local cardIndex = 1;
    for i = ((10 * self.page) - 9), (10 * self.page) do
        if self.deck[i] then
            self["card"..cardIndex]:LoadCard(self.deck[i])
        else
            self["card"..cardIndex]:Hide()
        end
        cardIndex = cardIndex + 1;
    end
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- deck builder
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

DeckBuilderMixin = {}
DeckBuilderMixin.ClassID = nil;
DeckBuilderMixin.ClassFile = nil;

function DeckBuilderMixin:OnLoad()

    -- font size hack
    local fontName, _, fontFlags = self.menuPanel.selectClass:GetFont()
    self.menuPanel.selectClass:SetFont(fontName, 26, fontFlags)
    self.menuPanel.selectClass:SetText(L["SelectHero"])

    for i = 1, GetNumClasses() do
        local className, classFile, classID = GetClassInfo(i)
        if self.menuPanel[classFile:lower()] then
            self.menuPanel[classFile:lower()]:SetBackground_Atlas(string.format("classicon-%s", classFile:lower()))
            self.menuPanel[classFile:lower()].func = function()
                classButton_Clicked(self.menuPanel[classFile:lower()])
            end
        end
    end

    self.menuPanel.listviewHeader:SetSize(240, 40)
    self.menuPanel.listviewHeader:SetText(L["SelectDeck"], 20)

    HybridScrollFrame_CreateButtons(self.menuPanel.listview, "HslDeckListviewItem", -10, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.menuPanel.listview, true)



    self.cardViewer.showClass:Resize(40,40)
    self.cardViewer.showClass.func = function()
        if self.classFile then
            --self:LoadCards(hsl.db.cards[self.classFile:lower()]);
            self:LoadCards(HSL.collection[self.classFile:lower()]);
        end
    end
    self.cardViewer.showNeutral:Resize(40,40)
    self.cardViewer.showNeutral:SetBackground_Atlas("GarrMission_ClassIcon-Warrior-Protection")
    self.cardViewer.showNeutral.func = function()
        --self:LoadCards(hsl.db.cards.generic);
        self:LoadCards(HSL.collection.neutral);
    end

    self.cardViewer.page = 1;

    -- flip the next page arrow 180
    self.cardViewer.nextPage.Background:SetRotation(3.14)
    self.cardViewer.nextPage.Highlight:SetRotation(3.14)

    fontSizeHack(self.cardViewer.pageNumber, 32)


    HybridScrollFrame_CreateButtons(self.deckViewer.listview, "HslCardListviewItem", -5, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.deckViewer.listview, true)

end

function DeckBuilderMixin:OnShow()

    -- deck open
    PlaySound(1068314)

    self.selectHeroHelptip.Text:SetText(L["SelectHeroHelptip"])
    self.selectHeroHelptip:Show()
    table.insert(helptips, self.selectHeroHelptip)

    self.cardViewer.deckEditingHelptip.Text:SetText(L["DeckEditingHelptip"])
    self.cardViewer.deckEditingHelptip:Show()
    table.insert(helptips, self.cardViewer.deckEditingHelptip)

    self.deckViewer.deckEditingHelptip_Popout.Text:SetText(L["DeckEditingHelptipPopout"])
    self.deckViewer.deckEditingHelptip_Popout:Show()
    table.insert(helptips, self.deckViewer.deckEditingHelptip_Popout)

    self.cardViewer.cardToggleHelptip.Text:SetText(L["ClassToggleHelptip"])
    self.cardViewer.cardToggleHelptip:SetSize(200, 40)
    self.cardViewer.cardToggleHelptip:Show()
    table.insert(helptips, self.cardViewer.cardToggleHelptip)

    deckViewerMenuPanelListview_Update(nil)

    HearthstoneLite.deckBuilder:HideCards()

    self.deckViewer:Hide()

end

function DeckBuilderMixin:GetClassInfo()
    if self.classFile and self.classID then
        return { classFile = self.classFile, classID = self.classID }
    end
end

function DeckBuilderMixin:NextPage()
    if not self.deck then
        return;
    end

    if self.cardViewer.page == math.ceil(#self.deck / 8) then
        return;
    end
    self.cardViewer.page = self.cardViewer.page + 1;
    self.cardViewer.pageNumber:SetText(self.cardViewer.page..' / '..math.ceil(#self.deck / 8));

    local cardIndex = 1;

    for i = ((8 * self.cardViewer.page) - 7), (8 * self.cardViewer.page) do
        if self.deck[i] then
            self.cardViewer["card"..cardIndex]:LoadCard(self.deck[i])
        else
            self.cardViewer["card"..cardIndex]:Hide()
        end
        cardIndex = cardIndex + 1;
    end
end

function DeckBuilderMixin:PrevPage()
    if not self.deck then
        return;
    end
    if self.cardViewer.page == 1 then
        return
    end
    self.cardViewer.page = self.cardViewer.page - 1;
    self.cardViewer.pageNumber:SetText(self.cardViewer.page..' / '..math.ceil(#self.deck / 8));

    local cardIndex = 1;
    for i = ((8 * self.cardViewer.page) - 7), (8 * self.cardViewer.page) do
        if self.deck[i] then
            self.cardViewer["card"..cardIndex]:LoadCard(self.deck[i])
        else
            self.cardViewer["card"..cardIndex]:Hide()
        end
        cardIndex = cardIndex + 1;
    end
end

function DeckBuilderMixin:HideCards()
    for i = 1, 8 do
        if self.cardViewer["card"..i] then
            self.cardViewer["card"..i]:Hide()
        end
    end
end

function DeckBuilderMixin:LoadCards(deck)

    if not deck then
        return
    end
    if deck then
        self.deck = deck
        self.cardViewer.page = 1;
        self.cardViewer.pageNumber:SetText(self.cardViewer.page..' / '..math.ceil(#self.deck / 8));

        for i = 1, 8 do
            self.cardViewer["card"..i]:Hide()
        end

        for i = 1, 8 do
            if self.deck[i] then
                self.cardViewer["card"..i]:LoadCard(self.deck[i])
            end
        end
    end

    --deckViewerPopoutListview_Update(deck)
end

function DeckBuilderMixin:AddCard(card)
    if not HSL then
        return;
    end
    if not HSL.decks[self.classID] then
        return;
    end
    if HSL.decks and card then
        for _, deck in ipairs(HSL.decks[self.classID]) do
            if deck.id == self.deckID then
                -- card is the HSL.collection[class] item
                -- update the saved var table and pass back into the hybrid scroll update func
                table.insert(deck.cards, card)
                deckViewerPopoutListview_Update(deck.cards)
                --printInfoMessage(string.format("added %s to deck %s", card.name, deck.name))
                return;
            end
        end
    end
end

function DeckBuilderMixin:RemoveCard(card)
    if not HSL then
        return;
    end
    local cardIndex = nil;
    if HSL.decks and card then
        for _, deck in ipairs(HSL.decks[self.classID]) do
            if deck.id == self.deckID then
                for k, v in ipairs(deck.cards) do
                    -- since we are in the correct deck we can use the card name as uniqueness
                    -- if the card count is greater than 1 then we simple remove the card with
                    -- highest key this means only 1 card is removed
                    if v.name == card.name then
                        cardIndex = k;
                    end
                end
                if cardIndex then
                    -- update the saved var table and pass back into the hybrid scroll update func
                    table.remove(deck.cards, cardIndex)
                    deckViewerPopoutListview_Update(deck.cards)
                    return;
                end
            end
        end
    end
end


-- TODO:
-- this is using an old system to hold the class ID
-- update this to just use the DeckBuilderMixin
HslNewDeckMixin = {}

function HslNewDeckMixin:OnMouseDown()
    if self.classID > 0 then
        StaticPopup_Show("HslNewDeck", self.className, nil, {ClassID = self.classID, Icon = self.classIcon, callback = deckViewerMenuPanelListview_Update})
    end
end



--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- game board
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

GameBoardMixin = {}
GameBoardMixin.cardDrawnID = 1;
GameBoardMixin.playerBattlefield = {
    cards = {},
}
GameBoardMixin.cardPool = CreateFramePool("FRAME", nil, "HslBattlefieldCard", nil, false)
GameBoardMixin.battlefieldCardOffsets = {
    [1] = {0},
    [2] = {-100, 100},
    [3] = {-170, 0, 170},
    [4] = {-270, -100, 100, 270},
    [5] = {-340, -170, 0, 170, 340},
    [6] = {-440, -270, -100, 100, 270, 440},
    [7] = {-510, -340, -170, 0, 170, 340, 510},
}
-- GameBoardMixin.playerControlsCardOffsets = {
--     [1] = {0},
--     [2] = {0, 150},
--     [3] = {0, 150, 300,},
--     [4] = {0, 150, 300, 450,},
--     [5] = {0, 150, 300, 450, 600},
--     [6] = {0},
--     [7] = {0, 150},
--     [8] = {0, 150, 300,},
--     [9] = {0, 150, 300, 450,},
--     [10] = {0, 150, 300, 450, 600},
-- }

-- do i need these?
function GameBoardMixin:PlayerBattlefield_OnLeave()
    self.playerBattlefield.mouseOver = false
end

function GameBoardMixin:PlayerBattlefield_OnEnter()
    self.playerBattlefield.mouseOver = true
end
--

function GameBoardMixin:FireEvent(eventName, eventData)
    local event = {
        type = "GAME_EVENT",
        event = eventName,
        args = eventData,
    }
    local target = UnitName('player')
    target = Ambiguate(target, "none")
    COMMS:Transmit(event, "WHISPER", target, "NORMAL")
end

function GameBoardMixin:OnShow()
    -- copy some dummy cards, make sure these exist in sv file!
    self.deck = {}
    for _, card in ipairs(HSL.collection.shaman) do
        table.insert(self.deck, card)
    end
    self.playerControls.theHand.cards = nil;
end


function GameBoardMixin:StartGame()

end


function GameBoardMixin:ExitGame()

end

---loop the cards in the hand table and reset their positions
function GameBoardMixin:ResetCardsInHandPositions()
    if next(self.playerControls.theHand.cards) then
        for i, card in ipairs(self.playerControls.theHand.cards) do
            card:ClearAllPoints()
            card:SetParent(self.playerControls.theHand)
            if i < 6 then
                card:SetPoint("LEFT", (i-1) * 150, 20)
            else
                card:SetPoint("LEFT", ((i - 6) * 150) + 55, -20)
            end
            card:SetFrameLevel(i+20)
            card:StopMovingOrSizing()
        end
    end
end


---draw a random card from the deck, this also uses the cardPool for the ui frame
function GameBoardMixin:DrawCard()
    if not self.playerControls.theHand.cards then
        self.playerControls.theHand.cards = {}
    end
    local numCards = #self.playerControls.theHand.cards
    if numCards > 9 then
        return
    end
    if not self.deck and not next(self.deck) then
        return
    end

    if not self.playerControls.theHand.cards[numCards+1] then
        local card = self.cardPool:Acquire()
        card.drawnID = self.cardDrawnID
        self.cardDrawnID = self.cardDrawnID + 1;
        card:SetParent(self.playerControls.theHand)
        card:ScaleTo(0.75)
        -- adjust the positions
        if numCards < 5 then
            card:SetPoint("LEFT", numCards * 150, 20)
        else
            card:SetPoint("LEFT", ((numCards - 5) * 150) + 55, -20)
        end
        card:SetFrameLevel(numCards+20)
        card.showTooltipCard = true

        -- pick random from deck
        local rndCardIndex = random(#self.deck)
        if self.deck[rndCardIndex] then
            card:LoadCard(self.deck[rndCardIndex])
            table.remove(self.deck, rndCardIndex)
        end
        self.playerControls.theHand.cards[numCards+1] = card;

    else
        local card = self.playerControls.theHand.cards[numCards+1];
        local rndCardIndex = random(#self.deck)
        if self.deck[rndCardIndex] then
            card:LoadCard(self.deck[rndCardIndex])
            table.remove(self.deck, rndCardIndex)
        end
    end

end

---reset the currently held card back to the hand
---@param card frame the ui card frame currently held
function GameBoardMixin:ReturnCardToHand(card)
    card:SetParent(self.playerControls.theHand)
    self:ResetCardsInHandPositions()
end


function GameBoardMixin:DeselectAllBattlefieldCards()
    if self.playerBattlefield.cards and next(self.playerBattlefield.cards) then
        for _, card in ipairs(self.playerBattlefield.cards) do
            card.selected = false;
            card.cardSelected:SetShown(card.selected)
        end
    end
    if self.targetBattlefield.cards and next(self.targetBattlefield.cards) then
        for _, card in ipairs(self.targetBattlefield.cards) do
            card.selected = false;
            card.cardSelected:SetShown(card.selected)
        end
    end
end

---move card from the hand to battlefield
---@param card frame the card to be played
function GameBoardMixin:PlayCardToBattlefield(card)
    card:StopMovingOrSizing()
    print("playing card to battlefield")
    if not self.playerBattlefield.cards then
        self.playerBattlefield.cards = {}
    end
    if #self.playerBattlefield.cards > 6 then
        return
    end
    local numCards = #self.playerBattlefield.cards
    self.playerBattlefield.cards[numCards+1] = card;
    card:SetParent(self.playerBattlefield)
    local handIndex;
    for k, c in ipairs(self.playerControls.theHand.cards) do
        if c.drawnID == card.drawnID then
            handIndex = k;
            print(k, c.card.name)
        end
    end
    --self.playerControls.theHand.cards[handIndex] = nil;
    table.remove(self.playerControls.theHand.cards, handIndex)
    C_Timer.After(0, function()
        for i = 1, numCards+1 do
            self.playerBattlefield.cards[i]:ClearAllPoints()
            self.playerBattlefield.cards[i]:SetPoint("CENTER", self.playerBattlefield, "CENTER", self.battlefieldCardOffsets[numCards+1][i], 0)
        end
        self:DeselectAllBattlefieldCards()
        self:ResetCardsInHandPositions()
    end)

    self:FireEvent("CARD_PLAYED_TO_BATTLEFIELD", {
        model = card.card,
        drawnID = card.drawnID,
    })
end

---this is called when the opponent fires the CARD_PLAYED_TO_BATTLEFIELD event
---for this we will need to create a card frame and load the data into it
---@param model table the data for the card
function GameBoardMixin:CardPlayedToBattlefield(model, drawnID)
    print('card played to battlefield')
    print('model table')
    for k, v in pairs(model) do
        print("    ",k,v)
    end
    if not self.targetBattlefield.cards then
        self.targetBattlefield.cards = {}
    end
    local numCards = #self.targetBattlefield.cards
    local card = self.cardPool:Acquire()
    card.drawnID = drawnID;
    card:Hide()
    card:LoadCard(model, true)
    card:Show()
    print("card.card table")
    for k, v in pairs(card.card) do
        print("    ",k,v)
    end
    card:ScaleTo(0.75)
    card:SetParent(self.targetBattlefield)
    card:SetFrameLevel(numCards+20)
    card.showTooltipCard = true;
    self.targetBattlefield.cards[numCards+1] = card;
    for i = 1, numCards+1 do
        self.targetBattlefield.cards[i]:ClearAllPoints()
        self.targetBattlefield.cards[i]:SetPoint("CENTER", self.battlefieldCardOffsets[numCards+1][i], 0)
    end
    print('END card played to battlefield')
end


function GameBoardMixin:PlayBasicAttack(player, target)
    if self.targetBattlefield.selectedCard and self.playerBattlefield.selectedCard then
        target.card.health = target.card.health - player.card.attack; -- update data table

        print(player.card.name, player.drawnID, 'attacks', target.card.name, target.drawnID)

        -- send new card data table to opponent
        local move = {
            event = "BASIC_ATTACK",
            player = player.card,
            target = target.card,
        }
        local target = UnitName('player')
        target = Ambiguate(target, "none")
        COMMS:Transmit(move, "WHISPER", target, "NORMAL")
    end
end


function GameBoardMixin:OnBasicAttack(target, player)
    print('being attacked', player.id, player.name, 'attacks', target.id, target.name)


    for k, card in ipairs(self.targetBattlefield.cards) do
        print("OnBasicAttack", card.card.name)
        if card.drawnID == target.drawnID then
            print(card.card.name, 'attacked for', player.attack)
        end
    end

    self:DeselectAllBattlefieldCards()
end



--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- addon comms
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

local commsMixin = {}
commsMixin.prefix = "HearthstoneLite";

function commsMixin:Transmit(data, channel, target, priority)
    local serialized = LibSerialize:Serialize(data);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

    if encoded and channel and priority then
        print('comms_out', string.format("type: %s, channel: %s target: %s, prio: %s", data.event or 'nil', channel, (target or 'nil'), priority))
        self:SendCommMessage(self.prefix, encoded, channel, target, priority)
    end
end

function commsMixin:OnCommReceived(prefix, message, distribution, sender)
    if prefix ~= self.prefix then
        return
    end
    local decoded = LibDeflate:DecodeForWoWAddonChannel(message);
    if not decoded then
        return;
    end
    local decompressed = LibDeflate:DecompressDeflate(decoded);
    if not decompressed then
        return;
    end
    local success, data = LibSerialize:Deserialize(decompressed);
    if not success or type(data) ~= "table" then
        return;
    end
    print('comms_in', string.format("%s from %s", data.event, sender))

    if data.type == "GAME_EVENT" then
        if data.event == "CARD_PLAYED_TO_BATTLEFIELD" then
            HearthstoneLite.gameBoard:CardPlayedToBattlefield(data.args.model, data.args.drawnID)
        end
    end

    if data.event == "BASIC_ATTACK" then
        HearthstoneLite.gameBoard:OnBasicAttack(data.target, data.player)
    end
end

COMMS = commsMixin

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- init
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

local function init()
    local version = GetAddOnMetadata(addonName, "Version")
    printInfoMessage("v"..version..L["WelcomeMessage"])

    AceComm:Embed(COMMS)
    COMMS:RegisterComm(COMMS.prefix)
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- event frame
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

local e = CreateFrame("FRAME")
e:RegisterEvent("ADDON_LOADED")
e:RegisterEvent("LOOT_OPENED")
e:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...):lower() == "hearthstonelite" then
        init()
    end
    if event == "LOOT_OPENED" then
        lootOpened()
    end
end)


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- hyperlinks
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

local hyperlinkCard = CreateFrame("FRAME", "HearthstoneLiteHyperlinkCardTip", UIParent, "HslCard")
hyperlinkCard:SetPoint("CENTER", 0, 0)
hyperlinkCard:Hide()
-- add a close button
hyperlinkCard.close = CreateFrame("BUTTON", nil, hyperlinkCard, "UIPanelCloseButton")
hyperlinkCard.close:SetPoint("TOPRIGHT", 4, 4)
hyperlinkCard.close:SetScript("OnClick", function(self)
    self:GetParent():Hide()
end)


local function parseCardHyperlink(link, showCard)
    local linkType, addon, _art, _class, _id, _name, _health, _attack, _ability, _power, _battlecry, _deathrattle, _cost, _backgroundPath, _background, _atlas, _rarity = strsplit(":", link)
    if _name and showCard then
        hyperlinkCard:Hide()
        hyperlinkCard:LoadCard({
            art = tonumber(_art),
            name = _name,
            class = _class,
            id = tonumber(_id),
            health = tonumber(_health),
            attack = tonumber(_attack),
            ability = tonumber(_ability),
            power = tonumber(_power),
            battlecry = tonumber(_battlecry),
            deathrattle = tonumber(_deathrattle),
            cost = tonumber(_cost),
            backgroundPath = _backgroundPath,
            background = tonumber(_background),
            atlas = _atlas,
            rarity = tonumber(_rarity),
        })
        hyperlinkCard:Show()
    end
end

hooksecurefunc("SetItemRef", function(link)
	local linkType, addon = strsplit(":", link)
	if linkType == "garrmission" and addon == "hslite" then
		parseCardHyperlink(link, true)
	end
end)