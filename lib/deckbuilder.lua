--[[

FaB Deck Builder
Created by David Owens @ Owens Satisfactory Cards (satifsactorycards.com).

Currently, there are two ways to import a deck:
  1. JSON output from FaB DB
  2. JSON output from fabrary.net (preferred)

These follow the format defined here: https://gist.github.com/owensd/af086ac73d2b3692558ed804865fa319

--]]

require('lib/strings')
require('lib/fabrary')
require('lib/fabdb')

-- dev_mode_enabled = false

local gDeckBuilderInput = ""
local deckBuilderUI = self


--[[ POSITION APIs --]]

local gDeckBuilderSpawnBaselineLeft = -5.55
local gDeckBuilderSpawnBaselineZOffset = (5.55 - 1.85)
local gDeckBuilderSpawnBaselineXOffset = -0.25
local gDeckBuilderSpawnHeight = 1.25
local gDeckBuilderCardHeightOffset = 0.2

local function getCardPositionForGenericCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 0)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end

local function getCardPositionForHeroCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 0)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end

local function getCardPositionForWeaponCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 1)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end

local function getCardPositionForEquipmentCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 2)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end

local function getCardPositionForDeckCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 3)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end

local function getCardPositionForSideboardCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 4)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end

local function getCardPositionForExtraCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 5)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        ["position"] = position,
        ["rotation"] = rotation
    }
end


--[[ CARD SPAWNING --]]

local function _spawnCard(card, position, rotation, backFaceURL, cardID)
    -- fabdb.net uses a different `identifier` for cards... so use the override if present.
    if cardID == nil then
        cardID = card.cardIdentifier:upper()
    end

    -- Some cards have special objects created on the game table; those cards should be loaded from there.
    -- local new_card = loadCardObjectFromGameAssets(cardID, position, rotation, backFaceURL)
    -- if new_card != nil then
    --     return new_card
    -- end

    if backFaceURL == nil then
        backFaceURL = "https://fabdb2.imgix.net/cards/backs/card-back-1.png"
    end

    local isLandscapeCard = false
    local keywords = card.keywords
    if keywords ~= nil then
        for _, keyword in pairs(keywords) do
            if keyword ~= nil and keyword == "landmark" then
                isLandscapeCard = true
            end
        end
    end

    -- Custom overrides for particular card images
    local cardFaceImageURL = card["image"]:split("?")[1]
    cardFaceImageURL = cardFaceImageURL:gsub("webp", "png")
    if cardID == "ELE000" then
        cardFaceImageURL = "http://cloud-3.steamusercontent.com/ugc/1684898660861024963/80840508762EB0CAC1281D3304A06975EB09032F/"
    end

    local extraObjectInfo = {
        face = cardFaceImageURL,
        back = backFaceURL,
        sideways = isLandscapeCard
    }

    local cardDescriptionText = card["functionalText"]
    if cardDescriptionText == nil then
        cardDescriptionText = card["text"]
    end

    local objectInfo = {
        type = "Card",
        position = position,
        rotation = rotation,
        scale = { x = 1.5, y = 1.0, z = 1.5 },
        callback_function = function(spawnedCard)
            spawnedCard.setCustomObject(extraObjectInfo)
            spawnedCard.setName(cardID .. " - " .. card["name"])
            spawnedCard.setDescription(cardDescriptionText)
            spawnedCard.reload()
        end
    }

    -- Spawn the card!
    return spawnObject(objectInfo)
end

local function spawnCard(cardOrIdentifier, position, rotation, backFaceURL)
    -- Cards are dynamically created instead of cloned. This offers greater flexibility and less instances on the table.

    if string.isNilOrEmpty(cardOrIdentifier.cardIdentifier) then
        -- get the card data to spawn it
        -- retrieveCardFromFabDBAPI(cardOrIdentifier:upper(), position, rotation, backFaceURL)
        local cardID = cardOrIdentifier:upper()
        FABDBGetCardFromIdentifier(cardOrIdentifier:upper(), function(card) _spawnCard(card, position, rotation, backFaceURL, cardID) end)
        return
    end

    return _spawnCard(cardOrIdentifier, position, rotation, backFaceURL)
end

local function spawnPackCard(card, cardNumber, backFaceURL)
    local pos = getCardPositionForGenericCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

local function spawnHero(card, cardNumber, backFaceURL)
    local pos = getCardPositionForHeroCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

local function spawnWeapon(card, cardNumber, backFaceURL)
    local pos = getCardPositionForWeaponCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

local function spawnEquipment(card, cardNumber, backFaceURL)
    local pos = getCardPositionForEquipmentCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

local function spawnDeck(card, cardNumber, backFaceURL)
    local pos = getCardPositionForDeckCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

local function spawnSideboard(card, cardNumber, backFaceURL)
    local pos = getCardPositionForSideboardCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

local function spawnExtra(card, cardNumber, backFaceURL)
    local pos = getCardPositionForExtraCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, backFaceURL)
end

-- lookup table when spawning cards to a specific location.
local gDeckBuilderCardSpawnerFuncs = {
    ["H"] = function(cardID, num) spawnHero(cardID, num) end,
    ["W"] = function(cardID, num) spawnWeapon(cardID, num) end,
    ["E"] = function(cardID, num) spawnEquipment(cardID, num) end,
    ["M"] = function(cardID, num) spawnDeck(cardID, num) end,
    ["S"] = function(cardID, num) spawnSideboard(cardID, num) end
}

--[[ DECK SPAWNING APIs --]]

local function sanitizeJSON(text)
    -- Handle the unicode apostophes...
    local result = string.gsub(text, "‘", "'")
    result = string.gsub(result, "’", "'")
    result = string.gsub(result, "\\u2018", "'")
    return result
end

--[[
    Loads cards from V1 of the deck format. This is the FABDB.net format.
]]
local function loadDeckFromV1Format(resp)
    local json = sanitizeJSON(resp.text)
    if type(json) ~= "string" or json:sub(1, 1) ~= "{" then
        broadcastToAll("Unable to retrieve data from URL: " .. gDeckBuilderInput)
        return
    end

    local deck = JSON.decode(json)
    if deck == nil then
        broadcastToAll("Deck JSON format invalid.")
        return
    end
    if deck.weapons == nil and deck.equipment == nil and deck.maindeck == nil then
        broadcastToAll("Deck does not have cards.")
        return
    end

    local numHeroes = 1
    local numWeapons = 1
    local numEquipment = 1
    local numDeck = 1
    local numSideboard = 1

    local backFaceURL = nil --deck.cardBack

    spawnHero(deck.hero_id, numHeroes, backFaceURL)
    numHeroes = numHeroes + 1
    for _, card in pairs(deck.weapons) do
        local num_to_spawn = card.count or 1
        for _ = 1, num_to_spawn do
            spawnWeapon(card.id, numWeapons, backFaceURL)
            numWeapons = numWeapons + 1
        end
    end
    for _, card in pairs(deck.equipment) do
        local num_to_spawn = card.count or 1
        for _ = 1, num_to_spawn do
            spawnEquipment(card.id, numEquipment, backFaceURL)
            numEquipment = numEquipment + 1
        end
    end
    for _, card in pairs(deck.maindeck) do
        local num_to_spawn = card.count or 1
        for _ = 1,num_to_spawn do
            spawnDeck(card.id, numDeck, backFaceURL)
            numDeck = numDeck + 1
        end
    end
    for _, card in pairs(deck.sideboard) do
        local num_to_spawn = card.count or 1
        for _ = 1,num_to_spawn do
            spawnSideboard(card.id, numSideboard, backFaceURL)
            numSideboard = numSideboard + 1
        end
    end
end

--[[
  Loads cards from V2 of the deck format.
]]
local function loadDeckFromV2Format(resp)
    local json = sanitizeJSON(resp.text)
    log(json)
    if type(json) ~= "string" or json:sub(1, 1) ~= "{" then
        broadcastToAll("Unable to retrieve data from URL: " .. gDeckBuilderInput)
        return
    end

    local deck = JSON.decode(json)
    if deck == nil then
        broadcastToAll("Deck JSON format invalid.")
        return
    end
    if deck.cards == nil then
        broadcastToAll("Deck does not have cards.")
        return
    end

    local numHeroes = 1
    local numWeapons = 1
    local numEquipment = 1
    local numDeck = 1
    local numSideboard = 1

    local backFaceURL = deck.cardBack

    for _, card in pairs(deck.cards) do
        local num_to_spawn = card.total
        local num_to_spawn_to_sideboard = card.sideboardTotal

        if card.type == "weapon" then
        for _ = 1, num_to_spawn do
            spawnWeapon(card, numWeapons, backFaceURL)
            numWeapons = numWeapons + 1
        end
        for _ = 1,num_to_spawn_to_sideboard do
            spawnSideboard(card, numSideboard, backFaceURL)
            numSideboard = numSideboard + 1
        end

        elseif card.type == "hero" then
            spawnHero(card, numHeroes, backFaceURL)
            numHeroes = numHeroes + 1
        elseif card.type == "equipment" then
            for _ = 1, num_to_spawn do
                spawnEquipment(card, numEquipment, backFaceURL)
                numEquipment = numEquipment + 1
            end
            for _ = 1,num_to_spawn_to_sideboard do
                spawnSideboard(card, numSideboard, backFaceURL)
                numSideboard = numSideboard + 1
            end
        else
            for _ = 1, num_to_spawn do
                spawnDeck(card, numDeck, backFaceURL)
                numDeck = numDeck + 1
            end
            for _ = 1,num_to_spawn_to_sideboard do
                spawnSideboard(card, numSideboard, backFaceURL)
                numSideboard = numSideboard + 1
            end
        end
    end
end

local function getDeckFromURL(deck_url)
    WebRequest.get(deck_url, loadDeckFromV2Format)
end

--[[ UI HANDLERS --]]


function DBOnDeckBuilderInputChanged(player, value, id)
    gDeckBuilderInput = value:trim()
end

function DBOnLoadDeckFromFABDBPressed()
    if gDeckBuilderInput == nil or gDeckBuilderInput == '' then
    else
        FABDBGetDeckFrom(gDeckBuilderInput, function(resp)
            loadDeckFromV1Format(resp)
        end)
    end
end

function DBOnLoadDeckFromFabraryPressed()
    if string.isNilOrEmpty(gDeckBuilderInput) then
    else
        FBGetDeckFrom(gDeckBuilderInput, function(resp)
            loadDeckFromV2Format(resp)
        end)
    end
end

function DBOnLoadSingleCardPressed()
    if string.isNilOrEmpty(gDeckBuilderInput) then
        return
    end

    if string.find(gDeckBuilderInput, "http") then
        getDeckFromURL(gDeckBuilderInput)
    else
        -- Multiple cards can be added at once using the format:
        --  <cardID>[:slot_id][:num]
        -- ex:
        --  MON001,MON002:W:2,MON003:E,MON004:M:3,MON005:S,MON006
        local cards = gDeckBuilderInput:split(",")
        for _, t in pairs(cards) do
            local parts = t:split(":")
            local cardID = parts[1]
            local slotID = (parts[2] or "H"):upper()
            local num = parts[3] or 1

            for n = 1, num do
                if gDeckBuilderCardSpawnerFuncs[slotID] == nil then
                    spawnHero(cardID, num)
                else
                    gDeckBuilderCardSpawnerFuncs[slotID](cardID, num)
                end
            end
        end
    end
end
