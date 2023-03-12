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
require('lib/carddb')
require('lib/imagedb')

-- dev_mode_enabled = false

local gDeckBuilderInput = ""
local deckBuilderUI = self


--[[ POSITION APIs --]]

local gDeckBuilderSpawnBaselineLeft = -5.55
local gDeckBuilderSpawnBaselineZOffset = (5.55 - 1.85)
local gDeckBuilderSpawnBaselineXOffset = -0.25
local gDeckBuilderSpawnHeight = 1.25
local gDeckBuilderCardHeightOffset = 0.2

local gDeckBuilderDefaultCardScale = { x = 1.5, y = 1.0, z = 1.5 }

local function getCardPositionForGenericCard(cardNumber)
    local pos = deckBuilderUI.getPosition()
    local position = {
        x=pos.x + gDeckBuilderSpawnBaselineXOffset,
        y=pos.y + gDeckBuilderSpawnHeight + (cardNumber * gDeckBuilderCardHeightOffset),
        z=pos.z + gDeckBuilderSpawnBaselineLeft + (gDeckBuilderSpawnBaselineZOffset * 0)
    }
    local rotation = { x=0, y=90, z=180 }
    return {
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
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
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
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
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
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
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
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
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
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
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
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
        position = position,
        rotation = rotation,
        scale = gDeckBuilderDefaultCardScale
    }
end


--[[ CARD SPAWNING --]]

local function _cardMetadata(cardID, card, position, rotation, scale, backFaceURL)
    local cardFaceImageURL = nil
    local cardFaceImage = OSCImageDB[cardID]
    if cardFaceImage ~= nil then
        cardFaceImageURL = cardFaceImage.url
    else
        -- cardFaceImageURL = "https://d2h5owxb2ypf43.cloudfront.net/cards/" .. cardID .. ".png"
        cardFaceImageURL = "http://cloud-3.steamusercontent.com/ugc/2021591863531608584/C373576B1A7417AE484C84D6C146C36CD3235522/"
        log("no local image found: " .. cardID)
    end

    -- Custom overrides for particular card images
    if cardID == "ELE000" then
        cardFaceImageURL = "http://cloud-3.steamusercontent.com/ugc/1684898660861024963/80840508762EB0CAC1281D3304A06975EB09032F/"
    end

    if backFaceURL == nil then
        backFaceURL = "https://fabdb2.imgix.net/cards/backs/card-back-1.png"
        -- backFaceURL = "http://cloud-3.steamusercontent.com/ugc/1465311478988561488/365997716DD5087410C2FDA5F18293303B5511F5/"
    end

    local cardDescriptionText = card.functionalText
    if cardDescriptionText == nil then
        cardDescriptionText = card.text
    end

    local isLandscapeCard = false
    local keywords = card.keywords
    if not string.isNilOrEmpty(keywords) then
        for _, keyword in pairs(string.split(keywords, ",")) do
            if keyword ~= nil and keyword == "landmark" then
                isLandscapeCard = true
            end
        end
    end

    -- return {
    --     Name = 'Card',
    --     Nickname = card.name,
    --     Description = cardDescriptionText,
    --     Value = 0,
    --     Tags = {},
    --     Transform = {
    --         posX = position.x, posY = position.y, posZ = position.z,
    --         rotX = rotation.x, rotY = rotation.y, rotZ = rotation.z,
    --         scaleX = scale.x, scaleY = scale.y, scaleZ = scale.z
    --     },
    --     ColorDiffuse = { r = 1, g = 1, b = 1 },
    --     Locked = false,
    --     Grid = true,
    --     Snap = true,
    --     Autoraise = true,
    --     Sticky = true,
    --     Tooltip = true,
    --     GridProjection = false,
    --     Hands = true,
    --     HideWhenFaceDown = true,
    --     CustomDeck = {
    --         [1] = {
    --             FaceURL = cardFaceImageURL,
    --             BackURL = backFaceURL,
    --             NumWidth = 1,
    --             NumHeight = 1,
    --             BackIsHidden = true,
    --             UniqueBack = false,
    --             Type = 0
    --         }
    --     }
    -- }

    return {
        face = cardFaceImageURL,
        back = backFaceURL,
        sideways = isLandscapeCard,
        name = cardID .. " - " .. card.name,
        description = cardDescriptionText
    }
end

local function _spawnCard(cardID, card, position, rotation, scale, backFaceURL)
    -- Some cards are double-sided. Instead of spawning multiple cards to hide the back-side, states are used.

    local cardData = _cardMetadata(cardID, card, position, rotation, scale, backFaceURL)
    local cardBack = OSCCardDB[cardID .. "-BACK"]

    -- spawnObjectData({ data = cardData }, function(card) log("item spawned") end)

    local frontGUID = spawnObject({
        type = 'Card',
        position = position,
        rotation = rotation,
        scale = scale,
        callback_function = function (spawned)
            spawned.setCustomObject({
                type = 0,
                face = cardData.face,
                back = cardData.back,
                sideways = cardData.sideways
            })
            spawned.setName(cardData.name)
            spawned.setDescription(cardData.description)
            spawned.reload()
        end
    }).getGUID()

    if cardBack ~= nil then
        local cardBackData = _cardMetadata(cardID .. "-BACK", cardBack, position, rotation, scale, backFaceURL)
        cardData["States"] = {
            [1] = cardBackData
        }

        spawnObject({
            type = 'Card',
            position = position,
            rotation = rotation,
            scale = scale,
            callback_function = function (spawned)
                spawned.setCustomObject({
                    type = 0,
                    face = cardBackData.face,
                    back = cardBackData.back,
                    sideways = cardBackData.sideways
                })
                spawned.setName(cardBackData.name)
                spawned.setDescription(cardBackData.description)
                spawned.reload()

                local backGUID = spawned.getGUID()

                local lastState = getObjectFromGUID(frontGUID).getData()
                lastState["States"] = {
                    [1] = spawned.getData()
                }

                spawnObjectData({
                    data = lastState,
                    position = position,
                    callback_function = function()
                        destroyObject(getObjectFromGUID(backGUID))
                        destroyObject(getObjectFromGUID(frontGUID))
                    end
                })
            end
        })
    end
end

local function spawnCard(cardOrIdentifier, position, rotation, scale, backFaceURL)
    -- Cards are dynamically created instead of cloned. This offers greater flexibility and less instances on the table.

    if string.isNilOrEmpty(cardOrIdentifier.cardIdentifier) then
        -- get the card data to spawn it
        -- retrieveCardFromFabDBAPI(cardOrIdentifier:upper(), position, rotation, backFaceURL)
        local cardID = cardOrIdentifier:upper()

        local cardData = OSCCardDB[cardID]
        if cardData ~= nil then
            return _spawnCard(cardID, cardData, position, rotation, scale, backFaceURL)
        else
            return FABDBGetCardFromIdentifier(cardID, function(card) _spawnCard(cardID, card, position, rotation, scale, backFaceURL) end)
        end
    end

    return _spawnCard(cardOrIdentifier.cardIdentifier:upper(), cardOrIdentifier, position, rotation, scale, backFaceURL)
end

local function spawnPackCard(card, cardNumber, backFaceURL)
    local pos = getCardPositionForGenericCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
end

local function spawnHero(card, cardNumber, backFaceURL)
    local pos = getCardPositionForHeroCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
end

local function spawnWeapon(card, cardNumber, backFaceURL)
    local pos = getCardPositionForWeaponCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
end

local function spawnEquipment(card, cardNumber, backFaceURL)
    local pos = getCardPositionForEquipmentCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
end

local function spawnDeck(card, cardNumber, backFaceURL)
    local pos = getCardPositionForDeckCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
end

local function spawnSideboard(card, cardNumber, backFaceURL)
    local pos = getCardPositionForSideboardCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
end

local function spawnExtra(card, cardNumber, backFaceURL)
    local pos = getCardPositionForExtraCard(cardNumber)
    return spawnCard(card, pos.position, pos.rotation, pos.scale, backFaceURL)
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

local function _hasValue(seq, value)
    for _, d in ipairs(seq) do
        if d == value then
            return true
        end
    end

    return false
end

function DBOnSpawnTokensPressed()
    -- Some tokens are available in multiple sets so keep track and only spawn the first one found.
    local names = {}

    for cardID, card in pairs(OSCCardDB) do
        local isToken = false
        local types = card.types:split(",")
        isToken = _hasValue(types, "Token")

        if isToken and not _hasValue(names, card.name) then
            -- table.insert(names, card.name)
            card.cardIdentifier = cardID
            spawnHero(card, 1, nil)
        end
    end
end