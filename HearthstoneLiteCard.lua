

local _, hsl = ...

local L = hsl.locales;

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- this is the texture atlas data for the cards
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--

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



local tooltipCard;

--base card object
HslCardMixin = {}

function HslCardMixin:OnShow()

end

-- should do this in xml?
function HslCardMixin:OnLoad()
    -- quick font size hack
    local fontName, _, fontFlags = self.cost:GetFont()
    self.cost:SetFont(fontName, 28, fontFlags)
    self.attack:SetFont(fontName, 28, fontFlags)
    self.health:SetFont(fontName, 28, fontFlags)
    self.name:SetFont(fontName, 10, fontFlags)
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
---@param model table a table containing the card info
function HslCardMixin:LoadCard(model)
    if not model then
        return
    end

    self.selected = false;

    --self.defaults = model;
    self.model = {}
    for k, v in pairs(model) do
        self.model[k] = v;
    end

    self.art:SetTexture(model.art)
    self.cost:SetText(model.cost)
    self.attack:SetText(model.attack)
    self.health:SetText(model.health)
    self.name:SetText(model.name)
    self.info:SetText("")

    -- i had issues keeping the model text updated, using C_Timer to delay the update func by a frame
    local function infoDelay()
        if model.battlecry and model.battlecry > 0 then
            self.info:SetText(L["battlecry"]..string.format(hsl.db.battlecries[model.battlecry].info, model.power))
        end
        if model.deathrattle and model.deathrattle > 0 then
            self.info:SetText(L["deathrattle"]..string.format(hsl.db.deathrattles[model.deathrattle].info, model.power))
        end
        if model.ability and model.ability > 0 then
            self.info:SetText(string.format(hsl.db.abilities[model.class][model.ability].info, model.power))
        end
    end
    C_Timer.After(0, infoDelay)

    if model.background > 4 then
        self.name:SetPoint("CENTER", 4, -8)
    else
        self.name:SetPoint("CENTER", 4, -4)
    end

    for _, attribute in ipairs({"cost", "attack", "health"}) do
        if self.model[attribute] then
            self[attribute]:Show();
        else
            self[attribute]:Hide();
        end
    end

    self.cardTemplate:SetTexture(CARD_TEMPLATE_PATH..model.backgroundPath)

    -- card.atlas = the atlas table to use
    -- card.background = the card number from the file to use
    self.cardTemplate:SetTexCoord(
        CARD_ATLAS[model.atlas][model.background].left, 
        CARD_ATLAS[model.atlas][model.background].right, 
        CARD_ATLAS[model.atlas][model.background].top, 
        CARD_ATLAS[model.atlas][model.background].bottom
    )

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

    self.model = nil;
    self.drawnID = nil;
end

function HslCardMixin:OnMouseUp()

end

function HslCardMixin:OnMouseDown()
    if not self.model then
        return;
    end
    --dev stuffs
    if IsAltKeyDown() then
        print('data table for card:', self.model.name)
        for k, v in pairs(self.model) do
            print(string.format('    card data [%s] = %s', k, v))
        end
    end

    self.selected = not self.selected;
    self.cardSelected:SetShown(self.selected)

    --use parent name to determine action TODO: setup more templates ?
    local parent = self:GetParent():GetName();
    if parent then
        if parent == "deckBuilderCardViewer" and IsControlKeyDown() then
            HearthstoneLite.deckBuilder:AddCard(self.model)
            return;
        end
    end

end


function HslCardMixin:OnEnter()
    if self.showTooltipCard then
        tooltipCard:LoadCard(self.model)
        tooltipCard:ClearAllPoints()
        tooltipCard:SetPoint("RIGHT", self, "LEFT", 0, 0) -- this needs to be changable by the user
        tooltipCard:Show()
        tooltipCard:ScaleTo(self.tooltipScaleTo)
        tooltipCard:SetFrameStrata("TOOLTIP")
    end
end

function HslCardMixin:OnLeave()
    tooltipCard:Hide()
end



---return a custom hyperlink for a card
---@return string hyperlink clickable link that can be shared with other hsl addon users
function HslCardMixin:GetCardLink()
    if not self.model then
        return
    end
    local link = string.format("|cFFFFFF00|Hgarrmission?hslite?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s?%s|h%s|h|r", -- use ? as a sep because a card name may contain : (SI:7 for example)
    tostring(self.model.art),
    tostring(self.model.class),
    tostring(self.model.name), 
    tostring(self.model.id), 
    tostring(self.model.health), 
    tostring(self.model.attack),  
    tostring(self.model.ability), 
    tostring(self.model.power), 
    tostring(self.model.battlecry), 
    tostring(self.model.deathrattle), 
    tostring(self.model.cost), 
    tostring(self.model.backgroundPath), 
    tostring(self.model.background), 
    tostring(self.model.atlas), 
    tostring(self.model.rarity), 
    ITEM_QUALITY_COLORS[self.model.rarity].hex.."["..self.model.name.."]|r"
    )
    return link;
end

tooltipCard = CreateFrame("FRAME", "HearthstoneLiteTooltipCard", UIParent, "HslCard")
tooltipCard:SetPoint("CENTER", 0, 0)
tooltipCard:SetFrameLevel(500)
tooltipCard:Hide()
-- add a close button
tooltipCard.close = CreateFrame("BUTTON", nil, tooltipCard, "UIPanelCloseButton")
tooltipCard.close:SetPoint("TOPRIGHT", 4, 4)
tooltipCard.close:SetScript("OnClick", function(self)
    self:GetParent():Hide()
end)

--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
-- battlefield card
--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--
HslBattlefieldCardMixin = {}
HslBattlefieldCardMixin.tooltipScaleTo = 1.25


function HslBattlefieldCardMixin:OnEnter()
    if self.showTooltipCard and IsShiftKeyDown() then
        tooltipCard:LoadCard(self.model)
        tooltipCard:ClearAllPoints()
        tooltipCard:SetPoint("RIGHT", self, "LEFT", 0, 0) -- this needs to be changable by the user
        tooltipCard:Show()
        tooltipCard:ScaleTo(self.tooltipScaleTo)
        tooltipCard:SetFrameStrata("TOOLTIP")
    end
    self.attackArrow:Show()
end

function HslBattlefieldCardMixin:OnLeave()
    tooltipCard:Hide()
    --self.attackArrow:Hide()
end

function HslBattlefieldCardMixin:OnMouseDown()
    if not self.model then
        return;
    end
    --dev stuffs
    if IsAltKeyDown() then
        print('data table for card:', self.model.name)
        for k, v in pairs(self.model) do
            print(string.format('    card data [%s] = %s', k, v))
        end
        print("card parent:",self:GetParent():GetName())
        if self.drawnID then
            print("drawnID = ", self.drawnID)
        end
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
        print(string.format("selected card %s", self.model.name))
    else
        self:GetParent().selectedCard = nil;
        print(string.format("deselected card %s", self.model.name))
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
    if self.model then
        self.attack:SetText(self.model.attack)
        self.health:SetText(self.model.health)
    end
end


---this function will determine what happens based on if the cursor has a card and where the cursor is
function HslBattlefieldCardMixin:OnMouseUp()
    local card = self;
    local gb = HearthstoneLite.gameBoard;

    if gb.cursorHasCard == true then

        if gb.playerBattlefield:IsMouseOver() then
            print("mouse is over player battlefield")
            -- if not gb.playerBattlefield.cards then --this should be done elsewhere need to see why its an issue!
            --     gb.playerBattlefield.cards = {}
            -- end
            if #gb.playerBattlefield.cards > 6 then -- max num cards currently in battlefield
                print("battlefield has max num cards")
                gb:ReturnCardToHand(card)
            else
                if self:GetParent() == gb.playerControls.theHand then -- if this card came from the hand then play it to battlefield
                    gb:PlayCardToBattlefield(card)
                end
            end

        elseif gb.targetBattlefield:IsMouseOver() then
            print("mouse in target battlefield")
            if self:GetParent() == gb.playerBattlefield then -- if this card came from the players battlefield then play move
                -- this needs to go into gameboard.lua ?
                for _, targetCard in ipairs(gb.targetBattlefield.cards) do
                    if targetCard:IsMouseOver() then
                        print("mouse in card", targetCard.model.name)
                        gb:PlayBasicAttack(card, targetCard)
                    end
                end

            elseif self:GetParent() == gb.playerControls.theHand then
                gb:ReturnCardToHand(card)
            end

        else
            print("mouse not in battlefield")
            if self:GetParent() == gb.playerControls.theHand then
                gb:ReturnCardToHand(card)
            end
        end
    end

    gb:ReturnCardsToBattlefieldPositions('playerBattlefield')

    gb.cursorHasCard = false;
    gb.cursorCard = nil;
end

