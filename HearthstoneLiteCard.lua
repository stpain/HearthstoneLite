

local _, hsl = ...

local L = hsl.locales;

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the texture atlas data for the cards
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

local CARD_FONT_PATH = [[Interface\Addons\HearthstoneLite\Media\PollerOne-Regular.ttf]]

local FONT_SIZE = 22;

local CARD_TEMPLATE_PATH = [[Interface\Addons\HearthstoneLite\CardTemplates\]]
local CARD_ATLAS = {}

local CREATURE_TEMPLATE_WIDTH = 2048
local CREATURE_TEMPLATE_HEIGHT = 2048

CARD_ATLAS.CREATURE = {}
CARD_ATLAS.CREATURE[1] = {
    left = 20 / CREATURE_TEMPLATE_WIDTH,
    right = 272 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[2] = {
    left = 288 / CREATURE_TEMPLATE_WIDTH,
    right = 540 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[3] = {
    left = 555 / CREATURE_TEMPLATE_WIDTH,
    right = 807 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[4] = {
    left = 824 / CREATURE_TEMPLATE_WIDTH,
    right = 1076 / CREATURE_TEMPLATE_WIDTH,
    top = 2 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 357 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[5] = {
    left = 15 / CREATURE_TEMPLATE_WIDTH,
    right = 271 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[6] = {
    left = 290 / CREATURE_TEMPLATE_WIDTH,
    right = 541 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[7] = {
    left = 555 / CREATURE_TEMPLATE_WIDTH,
    right = 811 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[8] = {
    left = 823 / CREATURE_TEMPLATE_WIDTH,
    right = 1079 / CREATURE_TEMPLATE_WIDTH,
    top = 362 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 724 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[9] = {
    left = 18 / CREATURE_TEMPLATE_WIDTH,
    right = 271 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[10] = {
    left = 288 / CREATURE_TEMPLATE_WIDTH,
    right = 544 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[11] = {
    left = 555 / CREATURE_TEMPLATE_WIDTH,
    right = 811 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[12] = {
    left = 823 / CREATURE_TEMPLATE_WIDTH,
    right = 1080 / CREATURE_TEMPLATE_WIDTH,
    top = 775 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1137 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[13] = {
    left = 20 / CREATURE_TEMPLATE_WIDTH,
    right = 277 / CREATURE_TEMPLATE_WIDTH,
    top = 1161 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1538 / CREATURE_TEMPLATE_HEIGHT,
}
CARD_ATLAS.CREATURE[14] = {
    left = 288 / CREATURE_TEMPLATE_WIDTH,
    right = 544 / CREATURE_TEMPLATE_WIDTH,
    top = 1161 / CREATURE_TEMPLATE_HEIGHT,
    bottom = 1538 / CREATURE_TEMPLATE_HEIGHT,
}


-- neutral cards are 1 per file so the file path will determine the image used
local NEUTRAL_TEMPLATE_WIDTH = 512
local NEUTRAL_TEMPLATE_HEIGHT = 512

CARD_ATLAS.NEUTRAL = {}
CARD_ATLAS.NEUTRAL[1] = {
    left = 0 / NEUTRAL_TEMPLATE_WIDTH,
    right = 257 / NEUTRAL_TEMPLATE_WIDTH,
    top = 20 / NEUTRAL_TEMPLATE_HEIGHT,
    bottom = 381 / NEUTRAL_TEMPLATE_HEIGHT,
}


local WEAPON_TEMPLATE_WIDTH = 1024
local WEAPON_TEMPLATE_HEIGHT = 1024

CARD_ATLAS.WEAPON = {}
CARD_ATLAS.WEAPON[1] = {
    left = 0.0 / WEAPON_TEMPLATE_WIDTH,
    right = 278 / WEAPON_TEMPLATE_WIDTH,
    top = 15 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 400 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[2] = {
    left = 291 / WEAPON_TEMPLATE_WIDTH,
    right = 569 / WEAPON_TEMPLATE_WIDTH,
    top = 15 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 400 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[3] = {
    left = 584 / WEAPON_TEMPLATE_WIDTH,
    right = 862 / WEAPON_TEMPLATE_WIDTH,
    top = 15 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 400 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[4] = {
    left = 0.0 / WEAPON_TEMPLATE_WIDTH,
    right = 278 / WEAPON_TEMPLATE_WIDTH,
    top = 434 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 819 / WEAPON_TEMPLATE_HEIGHT,
}
CARD_ATLAS.WEAPON[5] = {
    left = 291 / WEAPON_TEMPLATE_WIDTH,
    right = 569 / WEAPON_TEMPLATE_WIDTH,
    top = 434 / WEAPON_TEMPLATE_HEIGHT,
    bottom = 819 / WEAPON_TEMPLATE_HEIGHT,
}


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the mixin for the cards
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--




--base card object
HslCardMixin = {}


function HslCardMixin:OnShow()

end

-- should do this in xml?
function HslCardMixin:OnLoad()
    -- quick font size hack
    local _, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(CARD_FONT_PATH, math.floor(FONT_SIZE * 1.25), fontFlags)
    self.attack:SetFont(CARD_FONT_PATH, FONT_SIZE, fontFlags)
    self.health:SetFont(CARD_FONT_PATH, FONT_SIZE, fontFlags)
    --self.name:SetFont(CARD_FONT_PATH, 9, fontFlags)

    self:RegisterForDrag("LeftButton")
end

function HslCardMixin:SetOrigin(x, y, override)
    if override then
        x, y = self:GetCenter()
    end
    self.origin = {x = x, y = y}
end

function HslCardMixin:OnMouseDown()
    if self.dragEnabled then
        if not self.origin then
            local x, y = self:GetCenter()
            self:SetOrigin(x, y)
        end
        self:StartMoving()
        self:SetFrameStrata("TOOLTIP")
    end
end

function HslCardMixin:SetPositionResetFunc(func)
    self.resetPositionFunc = func;
end

function HslCardMixin:SetDragEnabled()
    self.dragEnabled = true;
    self.resetPosition:SetScript("OnFinished", function()
        self.resetPositionFunc()
        self:SetFrameStrata("HIGH")
        self:EnableMouse(true)
    end)
end

function HslCardMixin:SetCardInfo(info)
    self.art:SetTexture(info.art)
    self.cost:SetText(info.cost)
    self.attack:SetText(info.attack)
    self.health:SetText(info.health)
    self.name:SetText(info.name)
    if info.battlecry and info.battlecry > 0 then
        self.info:SetText(L.BATTLE_CRY..string.format(hsl.db.battlecries[info.battlecry].info, info.power))
    end
    if info.deathrattle and info.deathrattle > 0 then
        self.info:SetText(L.DEATH_RATTLE..string.format(hsl.db.deathrattles[info.deathrattle].info, info.power))
    end
    if info.ability and info.ability > 0 then
        self.info:SetText(string.format(hsl.db.abilities[info.ability].info, info.power))
    end
    for _, attribute in ipairs({"cost", "attack", "health"}) do
        self[attribute]:Hide();
        if info[attribute] then
            self[attribute]:Show();
        end
    end
end

---scale the card frame and adjust the fontstring font heights
---@param scale number the new scale to be used
---@param fontSize number the size to use on the fontstrings
function HslCardMixin:ScaleTo(scale, fontSize)
    if not scale then
        scale = 1;
    end
    local fontSize = fontSize and fontSize or 28
    local fontName, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(fontName, fontSize, fontFlags)
    self.attack:SetFont(fontName, fontSize, fontFlags)
    self.health:SetFont(fontName, fontSize, fontFlags)
    self.name:SetFont(fontName, fontSize * 0.36, fontFlags) --monitor this, maybe just pass in a third value?

    self:SetScale(scale)
end

---load card data model into a ui frame
---@param data table a table containing the card info
function HslCardMixin:CreateFromData(data)
    if not data then
        return
    end

    self.onLoadAnim:Play()

    self.selected = false;

    self.cardDbEntry = data;

    --copy the card data, don't use the card data itself as these values will change during combat and we don't want to change the db entry
    self.data = {}
    for k, v in pairs(data) do
        self.data[k] = v;
    end

    self.info:SetText("")
    self.cardTemplate:SetTexture(nil)

    -- card.atlas = the atlas table to use
    -- card.background = the card number from the file to use
    self.cardTemplate:SetTexture(CARD_TEMPLATE_PATH..data.backgroundPath)

    self.cardTemplate:SetTexCoord(
        CARD_ATLAS[data.atlas][data.background].left, 
        CARD_ATLAS[data.atlas][data.background].right, 
        CARD_ATLAS[data.atlas][data.background].top, 
        CARD_ATLAS[data.atlas][data.background].bottom
    )

    if data.background > 12 then
        self.cardTemplate:ClearAllPoints()
        self.cardTemplate:SetPoint("TOPLEFT", 0, 9)
        self.cardTemplate:SetPoint("BOTTOMRIGHT", 0, 0)
    else
        self.cardTemplate:ClearAllPoints()
        self.cardTemplate:SetAllPoints()
    end

    -- i had issues keeping the data text updated, using C_Timer to delay the update func by a frame
    local function updateCard()
        self.art:SetTexture(data.art)
        self.cost:SetText(data.cost)
        self.attack:SetText(data.attack)
        self.health:SetText(data.health)
        self.name:SetText(data.name)
        -- if data.battlecry and data.battlecry > 0 then
        --     self.info:SetText(L.BATTLE_CRY..string.format(hsl.db.battlecries[data.battlecry].info, data.power))
        -- end
        -- if data.deathrattle and data.deathrattle > 0 then
        --     self.info:SetText(L.DEATH_RATTLE..string.format(hsl.db.deathrattles[data.deathrattle].info, data.power))
        -- end
        if data.ability and data.ability > 0 then
            self.info:SetText(string.format(hsl.db.abilities[data.ability].info, data.power))
        end
        for _, attribute in ipairs({"cost", "attack", "health"}) do
            self[attribute]:Hide();
            if data[attribute] then
                self[attribute]:Show();
            end
        end
    end

    -- if data.background > 4 then
    --     self.name:ClearAllPoints()
    --     self.name:SetPoint("CENTER", 4, -8)
    -- else
    --     self.name:ClearAllPoints()
    --     self.name:SetPoint("CENTER", 4, -4)
    -- end

    C_Timer.After(0.1, updateCard)

    self:Show()
end


--- when the card is hidden we just remove the model data
function HslCardMixin:OnHide()
    self.art:SetTexture(nil)
    self.cost:SetText("")
    self.attack:SetText("")
    self.health:SetText("")
    self.name:SetText("")
    self.info:SetText("")

    self.selected = false;
    self.cardSelected:SetShown(self.selected)

    self.data = nil;
    self.drawnID = nil;
end


function HslCardMixin:OnMouseUp()
    self:StopMovingOrSizing()
    self:EnableMouse(false)
    HearthstoneLite.CallbackRegistry:TriggerEvent(HearthstoneLite.Callbacks.Card_OnDragStop, self)
end

function HslCardMixin:SetLocation(location)
    self.location = location
end

function HslCardMixin:GetLocation()
    return self.location
end

function HslCardMixin:OnClick(button)
    if not self.data then
        return;
    end
    --dev stuffs
    if IsAltKeyDown() and IsControlKeyDown() then
        print('data model for card:', self.data.name)
        for k, v in pairs(self.data) do
            print(string.format('    [%s] = %s', k, v))
        end
    end

    if button == "RightButton" then
        hsl.tooltipCard:CreateFromData(self.data)
        hsl.tooltipCard:ClearAllPoints()
        hsl.tooltipCard:SetPoint("RIGHT", self, "LEFT", 0, 0) -- this needs to be changable by the user
        hsl.tooltipCard:Show()
        hsl.tooltipCard:ScaleTo(self.tooltipScaleTo)
        hsl.tooltipCard:SetFrameStrata("TOOLTIP")
    end

    -- self.selected = not self.selected;
    -- self.cardSelected:SetShown(self.selected)

    --use parent name to determine action TODO: setup more templates ?
    -- local parent = self:GetParent():GetName();
    -- if parent then
    --     if parent == "deckBuilderCardViewer" and IsControlKeyDown() then
    --         HearthstoneLite.deckBuilder:AddCard(self.data)
    --         return;
    --     end
    -- end

end


function HslCardMixin:OnEnter()
    if self.showTooltipCard then
        hsl.tooltipCard:CreateFromData(self.data)
        hsl.tooltipCard:ClearAllPoints()
        hsl.tooltipCard:SetPoint("RIGHT", self, "LEFT", 0, 0) -- this needs to be changable by the user
        hsl.tooltipCard:Show()
        hsl.tooltipCard:ScaleTo(self.tooltipScaleTo)
        hsl.tooltipCard:SetFrameStrata("TOOLTIP")
    end
end

function HslCardMixin:OnLeave()
    --hsl.tooltipCard:Hide()
end



---return a custom hyperlink for a card
---@return string hyperlink clickable link that can be shared with other hsl addon users
function HslCardMixin:GetCardLink()
    if not self.data then
        return ""
    end
    local link = string.format("|cFFFFFF00|Hgarrmission?hslite?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s|h%s|h|r", -- use ? as a sep because a card name may contain : (SI:7 for example)
    tostring(self.data.art),
    tostring(self.data.class),
    tostring(self.data.name), 
    tostring(self.data.id), 
    tostring(self.data.health), 
    tostring(self.data.attack),  
    tostring(self.data.ability), 
    tostring(self.data.power), 
    tostring(self.data.battlecry), 
    tostring(self.data.deathrattle), 
    tostring(self.data.cost), 
    tostring(self.data.backgroundPath), 
    tostring(self.data.background), 
    tostring(self.data.atlas), 
    tostring(self.data.rarity), 
    ITEM_QUALITY_COLORS[self.data.rarity].hex.."["..self.data.name.."]|r"
    )
    return link;
end


--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- battlefield card
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
HslBattlefieldCardMixin = {}
HslBattlefieldCardMixin.tooltipScaleTo = 1.25

function HslBattlefieldCardMixin:OnLoad()
    -- quick font size hack
    local _, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(CARD_FONT_PATH, math.floor(FONT_SIZE * 1.25), fontFlags)
    self.attack:SetFont(CARD_FONT_PATH, FONT_SIZE, fontFlags)
    self.health:SetFont(CARD_FONT_PATH, FONT_SIZE, fontFlags)
    self.name:SetFont(CARD_FONT_PATH, 9, fontFlags)
end

function HslBattlefieldCardMixin:OnEnter()
    --self.attackArrow:Show()
end

function HslBattlefieldCardMixin:OnLeave()
    hsl.tooltipCard:Hide()
    --self.attackArrow:Hide()
end

function HslBattlefieldCardMixin:OnMouseDown(button)
    if not self.data then
        return;
    end
    --dev stuffs
    if IsAltKeyDown() then
        print('data table for card:', self.data.name)
        for k, v in pairs(self.data) do
            print(string.format('    card data [%s] = %s', k, v))
        end
        print("card parent:",self:GetParent():GetName())
        if self.drawnID then
            print("drawnID = ", self.drawnID)
        end
    end

    if button == "RightButton" then
        hsl.tooltipCard:CreateFromData(self.data)
        hsl.tooltipCard:ClearAllPoints()
        hsl.tooltipCard:SetPoint("RIGHT", self, "LEFT", 0, 0) -- this needs to be changable by the user
        hsl.tooltipCard:Show()
        hsl.tooltipCard:ScaleTo(self.tooltipScaleTo)
        hsl.tooltipCard:SetFrameStrata("TOOLTIP")
    end

    -- handle the card selection
    local x = self.selected
    for _, card in ipairs(self:GetParent().cards) do
        card.selected = false;
        card.cardSelected:SetShown(card.selected)
    end
    self.selected = not x;
    self.cardSelected:SetShown(false)
    --self.cardSelected:SetShown(self.selected)

    -- is this still going to be used?
    if self.selected then
        self:GetParent().selectedCard = self;
        print(string.format("selected card %s", self.data.name))
    else
        self:GetParent().selectedCard = nil;
        print(string.format("deselected card %s", self.data.name))
    end

    local gb = HearthstoneLite.gameBoard;

    -- if the mouse is over a player area then we can move the card
    if gb.playerControls:IsMouseOver() or gb.playerBattlefield:IsMouseOver() then
        self:SetMovable(true)
        self:EnableMouse(true)
        self:StartMoving()

        gb.cursorHasCard = true
        gb.cursorCard = self
    else
        self:SetScript("OnDragStart", nil)
        self:SetScript("OnDragStop", nil)
        self:SetMovable(false)
    end

end

---get the table index for this card using drawnID as an identifier
---@param t table the table this card belongs to
---@return integer tableIndex the index of this card
function HslBattlefieldCardMixin:GetTableKey(t)
    local tableIndex = nil;
    for k, card in ipairs(t) do
        if self.drawnID == card.drawnID then
            tableIndex = k;
        end
    end
    if tableIndex then
        return tableIndex;
    end
end

---update the card UI, this will set the health, attack etc to the current model values
function HslBattlefieldCardMixin:UpdateUI()
    if self.data then
        self.attack:SetText(self.data.attack)
        self.health:SetText(self.data.health)
    end
end


---this function will determine what happens based on if the cursor has a card and where the cursor is
function HslBattlefieldCardMixin:OnMouseUp()
    local card = self;
    local gb = HearthstoneLite.gameBoard;

    if gb.cursorHasCard == true then

        if gb.playerBattlefield:IsMouseOver() then
            --print("mouse is over player battlefield")
            -- if not gb.playerBattlefield.cards then --this should be done elsewhere need to see why its an issue!
            --     gb.playerBattlefield.cards = {}
            -- end
            if #gb.playerBattlefield.cards > 6 then -- max num cards currently in battlefield
                --print("battlefield has max num cards")
                gb:ReturnCardToHand(card)
            else
                if self:GetParent() == gb.playerControls.theHand then -- if this card came from the hand then play it to battlefield
                    gb:PlayCardToBattlefield(card)
                end
            end

        elseif gb.targetBattlefield:IsMouseOver() then
            --print("mouse in target battlefield")
            if self:GetParent() == gb.playerBattlefield then -- if this card came from the players battlefield then play move
                -- this needs to go into gameboard.lua ?
                for _, targetCard in ipairs(gb.targetBattlefield.cards) do
                    if targetCard:IsMouseOver() then
                        --print("mouse in card", targetCard.model.name)
                        gb:PlayBasicAttack(card, targetCard)
                    end
                end

            elseif self:GetParent() == gb.playerControls.theHand then
                gb:ReturnCardToHand(card)
            end

        else
            --print("mouse not in battlefield")
            if self:GetParent() == gb.playerControls.theHand then
                gb:ReturnCardToHand(card)
            end
        end
    end

    gb:ReturnCardsToBattlefieldPositions('playerBattlefield')

    gb.cursorHasCard = false;
    gb.cursorCard = nil;
end

