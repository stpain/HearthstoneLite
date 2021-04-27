

local _, hsl = ...

local AceComm = LibStub:GetLibrary("AceComm-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")

local L = hsl.locales

local BATTLEFIELD_COMMS = {}
BATTLEFIELD_COMMS.prefix = "hsl-battlefield";

function BATTLEFIELD_COMMS:Transmit(data, channel, target, priority)
    local serialized = LibSerialize:Serialize(data);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

    if encoded and channel and priority then
        print('comms_out', string.format("type: %s, channel: %s target: %s, prio: %s", data.event or 'nil', channel, (target or 'nil'), priority))
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



GameBoardMixin = {}
GameBoardMixin.debugMessages = {}
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


function GameBoardMixin:OnLoad()
    HybridScrollFrame_CreateButtons(self.debugWindow.listview, "HslDebugListviewItem", -10, 0, "TOP", "TOP", 0, -1, "TOP", "BOTTOM")
    HybridScrollFrame_SetDoNotHideScrollBar(self.debugWindow.listview, true)
end

function GameBoardMixin:AddDebugMessage(msg)

    table.insert(self.debugMessages, msg)

    local buttons = HybridScrollFrame_GetButtons(self.debugWindow.listview);
    local offset = HybridScrollFrame_GetOffset(self.debugWindow.listview);

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:Hide()
    end

    local items = self.debugMessages;

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        local itemIndex = buttonIndex + offset

        if itemIndex <= #items then
            local msg = items[itemIndex]
            button.text:SetText(msg)
            button:Show()
        else
            button:Hide()
        end
    end

    HybridScrollFrame_Update(self.debugWindow.listview, #items * 22, self.debugWindow.listview:GetHeight())

end

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
    BATTLEFIELD_COMMS:Transmit(event, "WHISPER", target, "NORMAL")
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


function GameBoardMixin:ReturnCardsToBattlefieldPositions()
    if next(self.playerBattlefield.cards) then
        for i, card in ipairs(self.playerBattlefield.cards) do
            card:ClearAllPoints()
            card:SetPoint("CENTER", self.playerBattlefield, "CENTER", self.battlefieldCardOffsets[#self.playerBattlefield.cards][i], 0)
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
    print("returning card to player hand", card.model.name, card.drawnID)
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
            print('handIndex', k, c.model.name)
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
        model = card.model,
        drawnID = card.drawnID,
    })
end

---this is called when the opponent fires the CARD_PLAYED_TO_BATTLEFIELD event
---for this we will need to create a card frame and load the data into it
---@param model table the data for the card
function GameBoardMixin:CardPlayedToBattlefield(model, drawnID)
    print('card played to battlefield', model.name, drawnID)
    -- print('model table')
    -- for k, v in pairs(model) do
    --     print("    ",k,v)
    -- end
    if not self.targetBattlefield.cards then
        self.targetBattlefield.cards = {}
    end
    local numCards = #self.targetBattlefield.cards
    local card = self.cardPool:Acquire()
    card.drawnID = drawnID+100; --testing this so we make target cards drawnID start at 100
    card:Hide()
    card:LoadCard(model)
    card:Show()
    card:ScaleTo(0.75)
    card:SetParent(self.targetBattlefield)
    card:SetFrameLevel(numCards+20)
    card.showTooltipCard = true;
    self.targetBattlefield.cards[numCards+1] = card;
    for i = 1, numCards+1 do
        self.targetBattlefield.cards[i]:ClearAllPoints()
        self.targetBattlefield.cards[i]:SetPoint("CENTER", self.targetBattlefield, "CENTER", self.battlefieldCardOffsets[numCards+1][i], 0)
    end
end


function GameBoardMixin:PlayBasicAttack(player, target)
    target.model.health = target.model.health - player.model.attack; -- update data table

    print(player.model.name, player.drawnID, 'attacks', target.model.name, target.drawnID)

    -- send move
    local move = {
        event = "BASIC_ATTACK",
        player = player.model,
        target = target.model,
    }
    local target = UnitName('player')
    target = Ambiguate(target, "none")
    BATTLEFIELD_COMMS:Transmit(move, "WHISPER", target, "NORMAL")
end


function GameBoardMixin:OnBasicAttack(target, player)
    print('attacked received', player.id, player.name, 'attacks', target.id, target.name)

    -- this is what your opponent recieves, they would now need to scan their playerBattlefield
    -- find the card being attacked and run code to make the attack happen

    self:DeselectAllBattlefieldCards()
end























function hsl.registerBattlefieldComms()
    AceComm:Embed(BATTLEFIELD_COMMS)
    BATTLEFIELD_COMMS:RegisterComm(BATTLEFIELD_COMMS.prefix)
end