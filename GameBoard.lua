

local _, hsl = ...

local AceComm = LibStub:GetLibrary("AceComm-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")

local L = hsl.locales
local gameBoard;
local MAX_MOVE_TIME = 90

local BATTLEFIELD_COMMS = {}
BATTLEFIELD_COMMS.prefix = "hslite";

function BATTLEFIELD_COMMS:Transmit(data, channel, target, priority)
    local serialized = LibSerialize:Serialize(data);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

    if not priority then
        priority = "NORMAL"; -- 99% of game comms will just be normal prio so save us some typing
    end

    if encoded and channel and priority then
        print('[comms_out]', string.format("type: %s, channel: %s target: %s", data.event or 'nil', channel, target or 'nil'))
        self:SendCommMessage(self.prefix, encoded, channel, target, priority)
    end
end

function BATTLEFIELD_COMMS:OnCommReceived(prefix, message, distribution, sender)
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
    if not data.type == "HSL_BATTLEFIELD_EVENT" then -- we only care about battlefield stuff here
        return;
    end
    print('[comms in]', string.format("%s from %s", data.event, sender))

    -- when a game event happens we just need to be able to check the data.event and pass in the data.args
    if data.event == "CARD_PLAYED_TO_BATTLEFIELD" then
        --HearthstoneLite.gameBoard:CardPlayedToBattlefield(data.args)
        gameBoard:CardPlayedToBattlefield(data.args)
    end

    if data.event == "BASIC_ATTACK" then
        --HearthstoneLite.gameBoard:OnBasicAttack(data.args)
        gameBoard:OnBasicAttack(data.args)
    end
end

local function loadDeckToGameBoard(deck)
    gameBoard:AddDebugMessage("loaded deck "..deck.name)
    for _, card in ipairs(deck.cards) do
        table.insert(gameBoard.deck, card)
    end
end

local function gameBoard_OnUpdate()

    if next(gameBoard.targetBattlefield.cards) then
        for k, card in ipairs(gameBoard.targetBattlefield.cards) do
            if card:IsMouseOver() then
                --print('mouse in card', card.model.name)
            end
        end
    end

    if gameBoard.moveTimerStartTime then
        local moveTimeRemaining = (GetTime() - (gameBoard.moveTimerStartTime + MAX_MOVE_TIME)) * -1;
        if moveTimeRemaining > 0 then
            gameBoard.moveTimer:SetValue(moveTimeRemaining)
        end

    end



    -- remove any target cards that died
    if next(gameBoard.targetBattlefield.cards) then
        local cardsToRemove = 0;
        for k, card in ipairs(gameBoard.targetBattlefield.cards) do
            if card.model.health < 1 then
                cardsToRemove = cardsToRemove + 1;
            end
        end
        if cardsToRemove > 0 then
            for i = 1, cardsToRemove do
                local key;
                for k, card in ipairs(gameBoard.targetBattlefield.cards) do
                    if card.model.health < 1 then
                        key = k;
                        card:Hide()
                        gameBoard.cardPool:Release(card)
                    end
                end
                table.remove(gameBoard.targetBattlefield.cards, key)
            end
            gameBoard:ReturnCardsToBattlefieldPositions('targetBattlefield')
        end
    end

    -- remove any player cards that died
    if next(gameBoard.playerBattlefield.cards) then
        local cardsToRemove = 0;
        for k, card in ipairs(gameBoard.playerBattlefield.cards) do
            if card.model.health < 1 then
                cardsToRemove = cardsToRemove + 1;
            end
        end
        if cardsToRemove > 0 then
            for i = 1, cardsToRemove do
                local key;
                for k, card in ipairs(gameBoard.playerBattlefield.cards) do
                    if card.model.health < 1 then
                        key = k;
                        card:Hide()
                        gameBoard.cardPool:Release(card)
                    end
                end
                table.remove(gameBoard.playerBattlefield.cards, key)
            end
            gameBoard:ReturnCardsToBattlefieldPositions('playerBattlefield')
        end
    end

end

---returns targets based on the effet target string
---@param ts string the ability or bcdr target
---@return table table of target cards can also be a single card
local function getTargetCards(ts)
    if gameBoard.targetBattlefield.cards and next(gameBoard.targetBattlefield.cards) then
        if ts == "RANDOM_TARGET" then
            gameBoard:AddDebugMessage('get random target from '..#gameBoard.targetBattlefield.cards)
            local rndIndex = random(#gameBoard.targetBattlefield.cards);
            return {gameBoard.targetBattlefield.cards[rndIndex]}
        end
        if ts == "ALL_TARGETS" then
            return gameBoard.targetBattlefield.cards;
        end
        if ts == "ALL_PLAYER_CARDS" then
            return gameBoard.playerBattlefield.cards;
        end
    end
end

GameBoardMixin = {}
GameBoardMixin.deck = {}
GameBoardMixin.moveTimerStartTime = nil;
GameBoardMixin.debugMessages = {}
GameBoardMixin.cardDrawnID = 1;
GameBoardMixin.playerBattlefield = {
    cards = {},
}
GameBoardMixin.targetBattlefield = {
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


function GameBoardMixin:OnLoad()
    -- HybridScrollFrame_CreateButtons(self.debugWindow.listview, "HslDebugListviewItem", -5, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    -- HybridScrollFrame_SetDoNotHideScrollBar(self.debugWindow.listview, true)

    self.targetBattlefield.cards = {}
    self.playerBattlefield.cards = {}

    gameBoard = HearthstoneLite.gameBoard;
    self:SetScript("OnUpdate", gameBoard_OnUpdate)

    gameBoard.moveTimer:SetReverseFill(true)

    -- using lua to setup the listview rows and scroll bar func
    C_Timer.After(5, function()
        self.debugListviewRows = {}
        for i = 1, 19 do
            local f = CreateFrame("FRAME", nil, self.debugWindow, "HslDebugListviewItem")
            f:SetPoint("TOP", -6, ((i-1)*-30) -30)
            self.debugListviewRows[i] = f
        end
    end)
end

function GameBoardMixin:DebugWindowScrollBar_OnValueChanged()
    if self.debugMessages then
        local scrollPos = math.floor(self.debugWindow.scrollBar:GetValue())
        if scrollPos == 0 then
            scrollPos = 1
        end
        for i = 1, 19 do
            if self.debugMessages[(i - 1) + scrollPos] then
                self.debugListviewRows[i].text:SetText("")
                self.debugListviewRows[i]:Hide()
                self.debugListviewRows[i].text:SetText(self.debugMessages[(i - 1) + scrollPos])
                self.debugListviewRows[i]:Show()
            end
        end
    end
end

function GameBoardMixin:AddDebugMessage(msg)
    table.insert(self.debugMessages, msg)
    --debugWindow_Update()
    local pos = self.debugWindow.scrollBar:GetValue()
    if self.debugMessages and next(self.debugMessages) then
        local logCount = #self.debugMessages - 18
        if logCount < 1 then
            self.debugWindow.scrollBar:SetMinMaxValues(1, 2)
            self.debugWindow.scrollBar:SetValue(2)
            self.debugWindow.scrollBar:SetValue(1)
            self.debugWindow.scrollBar:SetMinMaxValues(1, 1)
        else
            self.debugWindow.scrollBar:SetMinMaxValues(1, logCount)
            self.debugWindow.scrollBar:SetValue(pos - 1)
            self.debugWindow.scrollBar:SetValue(pos)
        end
    end
end

function GameBoardMixin:GetCardTableKey(drawnID, t)
    local tableIndex = nil;
    for k, card in ipairs(t) do
        if drawnID == card.drawnID then
            tableIndex = k;
        end
    end
    if tableIndex then
        return tableIndex;
    end
end


---send an addonComm message with the move data
---@param eventName string the event name, or the move name
---@param eventData table table of args required by the target to mimic the move on their game
function GameBoardMixin:FireEvent(eventName, eventData)
    local event = {
        type = "HSL_BATTLEFIELD_EVENT",
        event = eventName,
        args = eventData,
    }
    local target = UnitName('player')
    target = Ambiguate(target, "none")
    BATTLEFIELD_COMMS:Transmit(event, "WHISPER", target, "NORMAL")
end


function GameBoardMixin:OnShow()
    -- copy some dummy cards, make sure these exist in sv file!
    self.playerControls.theHand.cards = nil;

    self.playerControls.selectDeck.menu = {}
    if HSL.decks and next(HSL.decks) then
        for _, classDecks in pairs(HSL.decks) do
            for _, deck in ipairs(classDecks) do
                table.insert(self.playerControls.selectDeck.menu, {
                    text = deck.name,
                    func = function()
                        loadDeckToGameBoard(deck)
                    end,
                })
            end
        end
    end
end


function GameBoardMixin:ResetGameBoard()
    self.cardPool:ReleaseAll()
    self.cardDrawnID = 1;
    self.targetBattlefield.cards = {}
    self.playerBattlefield.cards = {}
    self.playerControls.theHand.cards = {}
    self.deck = {}

    self.moveTimer:SetValue(0)
end

function GameBoardMixin:StartGame()

    self.moveTimer:SetMinMaxValues(0,MAX_MOVE_TIME) -- 90s per move
    self.moveTimer:SetValue(0)

    self.moveTimerStartTime = GetTime()
end


function GameBoardMixin:ExitGame()

    -- this func will get more added over time, stats, winner etc


    self:ResetGameBoard()

    self.moveTimerStartTime = nil;

end

---loop the cards in the hand table and reset their positions
function GameBoardMixin:RepositionPlayerHandCards()
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


function GameBoardMixin:ReturnCardsToBattlefieldPositions(battlefield)
    if next(self[battlefield].cards) then
        for i, card in ipairs(self[battlefield].cards) do
            card:ClearAllPoints()
            card:SetPoint("CENTER", self[battlefield], "CENTER", self.battlefieldCardOffsets[#self[battlefield].cards][i], 0)
            card:StopMovingOrSizing()
        end
    end
end


---draw a random card from the deck, this also uses the cardPool for the ui frame
function GameBoardMixin:DrawCard()
    if not next(self.deck) then
        return;
    end
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
        self:AddDebugMessage(string.format("Player card draw, %s", card.model.name))
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
    --print("returning card to player hand", card.model.name, card.drawnID)
    card:SetParent(self.playerControls.theHand)
    self:AddDebugMessage(string.format("returning card %s with drawnID %s to player hand frame (not table)", card.model.name, card.drawnID))
    self:RepositionPlayerHandCards()
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
    self:AddDebugMessage(string.format("playing %s to playerBattlefield", card.model.name))
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
            self:AddDebugMessage(string.format("found card %s with index %s in theHand table", c.model.name, k))
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
        self:RepositionPlayerHandCards()

        -- handle the battle effect if exists
        if card.model.battlecry and card.model.battlecry > 0 then
            local targets = getTargetCards(hsl.db.battlecries[card.model.battlecry].target) or {}
            for _, targetCard in ipairs(targets) do
                if hsl.db.battlecries[card.model.battlecry].effect == "DAMAGE" then
                    targetCard.model.health = targetCard.model.health - card.model.power;
                    targetCard:UpdateUI()
                end
                if hsl.db.battlecries[card.model.battlecry].effect == "HEAL" then
                    targetCard.model.health = targetCard.model.health + card.model.power;
                    targetCard:UpdateUI()
                end
                if hsl.db.battlecries[card.model.battlecry].effect == "BUFF" then
                    targetCard.model.attack = targetCard.model.attack + hsl.db.battlecries[card.model.battlecry].values[1];
                    targetCard.model.health = targetCard.model.health + hsl.db.battlecries[card.model.battlecry].values[2];
                    targetCard:UpdateUI()
                end
            end
        end

    end)

    local move = {
        model = card.model,
        drawnID = card.drawnID,
    }
    self:FireEvent("CARD_PLAYED_TO_BATTLEFIELD", move)
end

---this is called when the opponent fires the CARD_PLAYED_TO_BATTLEFIELD event
---for this we will need to create a card frame and load the data into it
---@param event table the event payload containing the data model of the card played and the cards drawnID
function GameBoardMixin:CardPlayedToBattlefield(event)
    self:AddDebugMessage(string.format("card %s was played to battlefield", event.model.name))
    if not self.targetBattlefield.cards then
        self.targetBattlefield.cards = {}
    end
    local numCards = #self.targetBattlefield.cards
    local card = self.cardPool:Acquire()
    card.drawnID = event.drawnID+100; --testing this so we make target cards drawnID start at 100
    card:Hide()
    card:LoadCard(event.model)
    card:Show()
    card:ScaleTo(0.75)
    card:SetParent(self.targetBattlefield)
    card:SetFrameLevel(numCards+20)
    card.showTooltipCard = true;
    self.targetBattlefield.cards[numCards+1] = card;
    self:ReturnCardsToBattlefieldPositions('targetBattlefield')
end


---a basic attack using card attack and health values
---@param player table the frame making the attack
---@param target table the frame the mouse is over that is to be attacked
function GameBoardMixin:PlayBasicAttack(player, target)
    self:AddDebugMessage(string.format("Attack made! %s attacks %s", player.model.name, target.model.name))

    -- TODO: should this happen here? do we send the normal target and let the opponent handle the taunt?
    -- does a card have taunt? keep it simple, find the first card with taunt and make it the target - no damage carry over
    for k, card in ipairs(self.targetBattlefield.cards) do
        if tonumber(card.model.ability) == 1 then
            print(target.model.name, card.model.name)
            target = card;
        end
    end


    target.model.health = target.model.health - player.model.attack; -- update data table
    player.model.health = player.model.health - target.model.attack;
    target:UpdateUI() -- update our own UI
    player:UpdateUI() -- update our own UI

    -- send move
    local move = {
        player = player.model,
        playerDrawnID = player.drawnID,
        target = target.model,
        targetDrawnID = target.drawnID,
    }
    self:FireEvent("BASIC_ATTACK", move)
end


---incoming basic attack
---@param event table the event payload
function GameBoardMixin:OnBasicAttack(event)
    -- this is what your opponent recieves, they would now need to scan their playerBattlefield
    -- find the card being attacked and run code to make the attack happen

    -- this will most likely need to be changed when its an actual opponent and not myself
    local cardKey = self:GetCardTableKey(event.targetDrawnID, self.targetBattlefield.cards)
    local targetCard = self.targetBattlefield.cards[cardKey]

    self:DeselectAllBattlefieldCards()
end



function GameBoardMixin:Refresh()

end
















function hsl.gameBoard_init()
    gameBoard = HearthstoneLite.gameBoard

    AceComm:Embed(BATTLEFIELD_COMMS)
    BATTLEFIELD_COMMS:RegisterComm(BATTLEFIELD_COMMS.prefix)
end