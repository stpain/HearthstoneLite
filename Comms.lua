

local name, addon = ...;

local AceComm = LibStub:GetLibrary("AceComm-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")

local Comms = {
    prefix = "HS-Lite",
    version = 1,
    pokedPlayers = {},
    pokesEnabled = true,
    dispatchQueue = {},
    dispatcher = CreateFrame("Frame"),
    dispatcherElapsed = 0.0,
    dispatcherElapsedDelay = 1.0,
}

function Comms:Init()
    
    AceComm:Embed(self);
    self:RegisterComm(self.prefix);

    self.dispatcher:SetScript("OnUpdate", self.DispatcherOnUpdate)

    self.version = tonumber(C_AddOns.GetAddOnMetadata(name, "Version"));

    HearthstoneLite.CallbackRegistry:RegisterCallback(HearthstoneLite.Callbacks.Comms_OnPokesEnabled, self.Comms_OnPokesEnabled, self)
end

function Comms:Comms_OnPokesEnabled(enabled)
    self.pokesEnabled = enabled

    if self.pokesEnabled then
        self:ParsePokes()
    end
end

--[[
    This update script will run once a second and check if the dispatch queue has a message to send.
    Messages will be dispatched when their dispatch time has passed and remaining message will have
    their dispatch time updated to maintain a stagger effect
]]
---Dispatch addon messages from the queue
---@param self table
---@param elapsed any
function Comms.DispatcherOnUpdate(self, elapsed)
    
    Comms.dispatcherElapsed = Comms.dispatcherElapsed + elapsed;
    if Comms.dispatcherElapsed < Comms.dispatcherElapsedDelay then
        return
    else
        Comms.dispatcherElapsed = 0.0;
    end

    if #Comms.dispatchQueue == 0 then
        self:SetScript("OnUpdate", nil)
    
    else
        local msg = Comms.dispatchQueue[1]
        local now = time()

        if msg.dispatchTime < now then

            if msg.event == "POKE_NEARBY_PLAYER" then
                
                local message = {
                    target = msg.target,
                    channel = "WHISPER",
                    event = "PLAYER_POKE",
                    payload = {},
                }
                --Comms:Transmit(message)

                Comms:DummyPoke(message)
            end
        

            for i = 2, #Comms.dispatchQueue do
                Comms.dispatchQueue[i].dispatchTime = (i - 1) * 3.0;
            end

            table.remove(Comms.dispatchQueue, 1)
            if #Comms.dispatchQueue == 0 then
                self:SetScript("OnUpdate", nil)
            end

        end
    end

end

function Comms:RegisterNearbyPlayer(nameRealm)

    if not self.pokedPlayers[nameRealm] then
        self.pokedPlayers[nameRealm] = {
            registered = time(),
        }
        if self.pokesEnabled then
            self:PokeNearbyPlayer(nameRealm)
        end
        --print("no poke for", nameRealm)
    else
        --self.pokedPlayers[nameRealm] = time();
        --print("added poke for", nameRealm)
    end
end

function Comms:ParsePokes()
    for nameRealm, info in pairs(self.pokedPlayers) do
        if not info.lastPoke then
            
        else
            if (info.lastPoke + 60.0) < time() then
                
            end
        end
    end
end

function Comms:PokeNearbyPlayer(nameRealm)

    self.pokedPlayers[nameRealm].lastPoke = time()

    table.insert(self.dispatchQueue, {
        target = nameRealm,
        event = "POKE_NEARBY_PLAYER",
        dispatchTime = time(),
    })
    self.dispatcher:SetScript("OnUpdate", self.DispatcherOnUpdate)
end

function Comms:Transmit(message)

    message.version = self.version;

    local serialized = LibSerialize:Serialize(message);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

    print("Comms out:", message.channel, self.prefix, message.target)

    self:SendCommMessage(self.prefix, encoded, message.channel, message.target, "NORMAL")
end

function Comms:OnCommReceived(prefix, message, distribution, sender)

    --print(sender)

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
    
    --DevTools_Dump({data})

    if (type(data.version) == "number") and (type(self.version) == "number") and (data.version >= self.version) then
        DevTools_Dump({data})

        -- if data.event == "PLAYER_POKE" then
        --     self:DummyPoke(data)
        -- end
    else
        --DevTools_Dump(data)
    end
end

function Comms:DummyPoke(data)
    HearthstoneLite.CallbackRegistry:TriggerEvent(HearthstoneLite.Callbacks.Comms_OnPokeResponse, data)
end

addon.Comms = Comms;