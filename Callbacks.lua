
local name, addon = ...;

HearthstoneLite.Callbacks = {

    SavedVariables_OnInitialized = "ON_SAVED_VARIABLES_INITIALIZED",
    SavedVariables_OnReset = "ON_SAVED_VARIABLES_RESET",

    Deck_OnCreated = "ON_DECK_CREATED",
    Deck_OnDeleted = "ON_DECK_DELETED",

    Card_OnDragStop = "ON_CARD_DRAG_STOP",

    Comms_OnPokesEnabled = "ON_COMMS_POKES_ENABLED",
    Comms_OnPokeResponse = "ON_COMMS_POKE_RESPONSE",
}

local callbacksToRegister = {}
for k, v in pairs(HearthstoneLite.Callbacks) do
    table.insert(callbacksToRegister, v)
end

HearthstoneLite.CallbackRegistry = CreateFromMixins(CallbackRegistryMixin)
HearthstoneLite.CallbackRegistry:OnLoad()
HearthstoneLite.CallbackRegistry:GenerateCallbackEvents(callbacksToRegister)