--[[

FaB Deck Builder
Created by David Owens @ Owens Satisfactory Cards (satifsactorycards.com).

Currently, there are two ways to import a deck:
  1. JSON output from FaB DB
  2. JSON output from thepitchzone.com (thanks @Ever)

These follow the format defined here: https://gist.github.com/owensd/af086ac73d2b3692558ed804865fa319

--]]

require('lib/strings')
require('lib/fabrary')
require('lib/fabdb')

dev_mode_enabled = false

deck_builder_input = nil
spawning_deck = false
last_selected_sealed = ""


function onLoad()
  math.randomseed(os.time())

  -- Hide the invocation list cards from the users.
  for _, obj_id in pairs(invocation_list) do
    local obj = getObjectFromGUID(obj_id)
    local pos = obj.getPosition()
    if dev_mode_enabled then
      pos.y = 1
      obj.interactable = true
    else
      pos.y = -4
      obj.interactable = false
    end

    obj.setPosition(pos)
  end
end

function onDeckInputChanged(player, value, id)
  deck_builder_input = value:trim()
end

function onLoadDeckFromFABDBPressed()
  if deck_builder_input == nil or deck_builder_input == '' then
  elseif string.find(deck_builder_input, "fabrary.net") then
    fabrary_getDeckFromURL()
  else
    fabdb_createDeckFromAPI(deck_builder_input)
  end
end

function onLoadDeckFromGenericURLPressed()
  if deck_builder_input == nil or deck_builder_input == '' then
  elseif string.find(deck_builder_input, "fabrary.net") then
    fabrary_getDeckFromURL()
  elseif string.find(deck_builder_input, "http") then
    osc_getDeckFromURL(deck_builder_input)
  end
end


function onLoadSingleCardPressed()

  local fns = {
    ["H"] = function(card_id, num) spawnHero(card_id, num) end,
    ["W"] = function(card_id, num) spawnWeapon(card_id, num) end,
    ["E"] = function(card_id, num) spawnEquipment(card_id, num) end,
    ["M"] = function(card_id, num) spawnDeck(card_id, num) end,
    ["S"] = function(card_id, num) spawnSideboard(card_id, num) end
  }

  if deck_builder_input == nil or deck_builder_input == '' then
  else
    -- Multiple cards can be added at once using the format:
    --  <card_id>[:slot_id][:num]
    -- ex:
    --  MON001,MON002:W:2,MON003:E,MON004:M:3,MON005:S,MON006
    local cards = string.split(deck_builder_input, ",")
    for _, t in pairs(cards) do
      local parts = string.split(t, ":")
      local card_id = parts[1]
      local slot_id = (parts[2] or "H"):upper()
      local num = parts[3] or 1

      for n = 1, num do
        if fns[slot_id] == nil then
          spawnHero(card_id, num)
        else
          fns[slot_id](card_id, num)
        end
      end
    end
  end
end

function onGenerateSetSelected(player, option, id)
  local info = deck_list[option]
  if info then
    if info.deck_id then
      fabdb_createDeckFromAPI(info.deck_id)
    else
      local card_ids = {}

      -- The deck can be formed of deck IDs or info to generate all of the IDs.
      if info.first then

        for card_id, _ in pairs(card_images) do
          if card_id:find(info.prefix, 1, true) == 1 then
            table.insert(card_ids, card_id)
          end
        end
        -- for n=info.first, info.last do
        --   local card_id = info.prefix .. string.format("%03d", n)
        --   table.insert(card_ids, card_id)
        -- end
      elseif info.card_ids then
        card_ids = info.card_ids
      end

      local count = 0
      for _, v in pairs(card_ids) do
        spawnHero(v, count)
        count = count + 1
      end
    end
  end
end

function loadCardObjectFromGameAssets(identifier, position, rotation, back_face_url)
  -- With the Uprising set, there are cards that need to be spawned from objects, so handle that here.
  local obj_id = invocation_list[identifier]
  if obj_id != nil then
    obj_id = invocation_list[identifier]
    card_obj = getObjectFromGUID(obj_id)
    new_card = card_obj.clone()
    new_card.setPosition(position)
    new_card.setRotation(rotation)
    new_card.setLock(false)

    return new_card
  end

  return nil
end



function spawnCard(identifier, position, rotation, back_face_url)
    -- Cards are dynamically created instead of cloned. This offers greater flexibility and less instances on the table.

    -- Some cards have special objects created on the game table; those cards should be loaded from there.
    local new_card = loadCardObjectFromGameAssets(identifier, position, rotation, back_face_url)
    if new_card != nil then
        return new_card
    end

    if back_face_url == nil then
        back_face_url = "https://fabdb2.imgix.net/cards/backs/card-back-1.png"
    end

    card_id = identifier:upper()
    retrieveCardFromFabDBAPI(card_id, position, rotation, back_face_url)
end

SPAWN_BASELINE_LEFT = -5.55
SPAWN_BASELINE_ZOFF = (5.55 - 1.85)
SPAWN_BASELINE_XOFF = -0.25
SPAWN_HEIGHT = 1.25
CARD_HEIGHT_OFFSET = 0.2

function cardPosition_GenericCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 0) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end

function cardPosition_HeroCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 0) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end

function cardPosition_WeaponCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 1) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end

function cardPosition_EquipmentCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 2) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end

function cardPosition_DeckCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 3) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end

function cardPosition_SideboardCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 4) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end

function cardPosition_ExtraCard(card_number)
  local pos = self.getPosition()
  local position = { x=pos.x + SPAWN_BASELINE_XOFF, y=pos.y + SPAWN_HEIGHT + (card_number * CARD_HEIGHT_OFFSET), z=pos.z + SPAWN_BASELINE_LEFT + (SPAWN_BASELINE_ZOFF * 5) }
  local rotation = { x=0, y=90, z=180 }
  return {
    ["position"] = position,
    ["rotation"] = rotation
  }
end


function spawnPackCard(card, card_number, back_face_url)
  local pos = cardPosition_GenericCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function spawnHero(card, card_number, back_face_url)
  local pos = cardPosition_HeroCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function spawnWeapon(card, card_number, back_face_url)
  local pos = cardPosition_WeaponCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function spawnEquipment(card, card_number, back_face_url)
  local pos = cardPosition_EquipmentCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function spawnDeck(card, card_number, back_face_url)
  local pos = cardPosition_DeckCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function spawnSideboard(card, card_number, back_face_url)
  local pos = cardPosition_SideboardCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function spawnExtra(card, card_number, back_face_url)
  local pos = cardPosition_ExtraCard(card_number)
  return spawnCard(card, pos.position, pos.rotation, back_face_url)
end

function sanitizeJSON(text)
  -- Handle the unicode apostophes...
  local result = string.gsub(text, "‘", "'")
  result = string.gsub(result, "’", "'")
  result = string.gsub(result, "\\u2018", "'")
  return result
end


--[[

Standard Deck Loading Methods for OSC format.

]]--

function osc_getDeckFromURL(deck_url)
  if spawning_deck then
    return
  end
  spawning_deck = true
  WebRequest.get(deck_url, osc_loadDeck)
end

function osc_loadDeck(resp)
  local json = sanitizeJSON(resp.text)
  if type(json) != "string" or json:sub(1, 1) != "{" then
    broadcastToAll("Unable to retrieve data from URL: " .. deck_builder_input)
    spawning_deck = false
    return
  end

  local deck = JSON.decode(json)
  if deck == nil then
    broadcastToAll("Deck JSON format invalid.")
    spawning_deck = false
    return
  end
  if deck.weapons == nil and deck.equipment == nil and deck.maindeck == nil then
    broadcastToAll("Deck does not have cards.")
    spawning_deck = false
    return
  end

  local n_heroes = 1
  local n_weapons = 1
  local n_equipment = 1
  local n_deck = 1
  local n_sideboard = 1

  local back_face_url = nil --deck.cardBack

  spawnHero(deck.hero_id, n_heroes, back_face_url)
  n_heroes = n_heroes + 1
  for _, card in pairs(deck.weapons) do
    local num_to_spawn = card.count or 1
    for _ = 1, num_to_spawn do
      spawnWeapon(card.id, n_weapons, back_face_url)
      n_weapons = n_weapons + 1
    end
  end
  for _, card in pairs(deck.equipment) do
    local num_to_spawn = card.count or 1
    for _ = 1, num_to_spawn do
      spawnEquipment(card.id, n_equipment, back_face_url)
      n_equipment = n_equipment + 1
    end
  end
  for _, card in pairs(deck.maindeck) do
    local num_to_spawn = card.count or 1
    for _ = 1,num_to_spawn do
      spawnDeck(card.id, n_deck, back_face_url)
      n_deck = n_deck + 1
    end
  end
  for _, card in pairs(deck.sideboard) do
    local num_to_spawn = card.count or 1
    for _ = 1,num_to_spawn do
      spawnSideboard(card.id, n_sideboard, back_face_url)
      n_sideboard = n_sideboard + 1
    end
  end

  spawning_deck = false
end

--[[
  Loads cards from V2 of the deck format.
]]
function osc_loadDeckV2(resp)
  local json = sanitizeJSON(resp.text)
  if type(json) != "string" or json:sub(1, 1) != "{" then
    broadcastToAll("Unable to retrieve data from URL: " .. deck_builder_input)
    log(resp)
    spawning_deck = false
    return
  end

  local deck = JSON.decode(json)
  if deck == nil then
    broadcastToAll("Deck JSON format invalid.")
    spawning_deck = false
    return
  end
  if deck.cards == nil then
    broadcastToAll("Deck does not have cards.")
    spawning_deck = false
    return
  end

  local n_heroes = 1
  local n_weapons = 1
  local n_equipment = 1
  local n_deck = 1
  local n_sideboard = 1

  local back_face_url = deck.cardBack

  for _, card in pairs(deck.cards) do
    local num_to_spawn = card.total
    local num_to_spawn_to_sideboard = card.sideboardTotal

    if card.type == "weapon" then
      for _ = 1, num_to_spawn do
        spawnWeapon(card.cardIdentifier, n_weapons, back_face_url)
        n_weapons = n_weapons + 1
      end
      for _ = 1,num_to_spawn_to_sideboard do
        spawnSideboard(card.cardIdentifier, n_sideboard, back_face_url)
        n_sideboard = n_sideboard + 1
      end

    elseif card.type == "hero" then
      spawnHero(card.cardIdentifier, n_heroes, back_face_url)
      n_heroes = n_heroes + 1
    elseif card.type == "equipment" then
      for _ = 1, num_to_spawn do
        spawnEquipment(card.cardIdentifier, n_equipment, back_face_url)
        n_equipment = n_equipment + 1
      end
      for _ = 1,num_to_spawn_to_sideboard do
        spawnSideboard(card.cardIdentifier, n_sideboard, back_face_url)
        n_sideboard = n_sideboard + 1
      end
    else
      for _ = 1, num_to_spawn do
        spawnDeck(card.cardIdentifier, n_deck, back_face_url)
        n_deck = n_deck + 1
      end
      for _ = 1,num_to_spawn_to_sideboard do
        spawnSideboard(card.cardIdentifier, n_sideboard, back_face_url)
        n_sideboard = n_sideboard + 1
      end
    end
  end

  spawning_deck = false
end

--[[

FaB DB Parsing Methods.

]]--

function fabdb_packRetrieved(resp)
  local json = sanitizeJSON(resp.text)
  local info = JSON.decode(json)
  if info == nil then
    broadcastToAll("Unable to load pack for set.")
    return
  end

  -- First, find out if there are any duplicate cards. Doing this means the temporary deck does not need to be created multiple times.
  local cards = {}

  for _, card in pairs(info) do
    if cards[card.identifier] == nil then
      cards[card.identifier] = 1
    else
      cards[card.identifier] = cards[card.identifier] + 1
    end
  end

  local count = 0
  local base_deck = nil
  -- Spawn the cards!
  for key, num in pairs(cards) do
    spawnPackCard(key, num, count)
    count = count + 1
  end
end

function fabdb_deckRetrieved(resp)
  local json = sanitizeJSON(resp.text)
  if type(json) != "string" or json:sub(1, 1) != "{" then
    broadcastToAll("Unable to retrieve deck from: " .. deck_builder_input)
    spawning_deck = false
    return
  end

  local info = JSON.decode(json)
  if info == nil then
    broadcastToAll("Unable to load deck from ID.")
    spawning_deck = false
    return
  end
  if info.cards == nil then
    broadcastToAll("JSON does not have a cards collection.")
    spawning_deck = false
    return
  end

  local n_heroes = 1
  local n_weapons = 1
  local n_equipment = 1
  local n_deck = 1
  local n_sideboard = 1

  -- fabdb has _all_ cards the cards in `info.cards`. This table stores the `card.identifier` and the number of
  -- instances contained in the sideboard.
  local in_sideboard = {}

  -- Load up the sideboard.
  for _, card in pairs(info.sideboard) do
    in_sideboard[card.identifier] = card.total

    for _ = 1,card.total do
      spawnSideboard(card.identifier, n_sideboard)
      n_sideboard = n_sideboard + 1
    end
  end

  -- Spawn the cards!
  for _, card in pairs(info.cards) do
    local num_in_sideboard = in_sideboard[card.identifier]
    if num_in_sideboard == nil then
      num_in_sideboard = 0
    end
    local num_to_spawn = card.total - num_in_sideboard

    for _ = 1,num_to_spawn do
      if table.contains(card.keywords, "hero") then
        spawnHero(card.identifier, n_heroes)
        n_heroes = n_heroes + 1
      elseif table.contains(card.keywords, "weapon") then
        spawnWeapon(card.identifier, n_weapons)
        n_weapons = n_weapons + 1
      elseif table.contains(card.keywords, "equipment") then
        spawnEquipment(card.identifier, n_equipment)
        n_equipment = n_equipment + 1
      else
        spawnDeck(card.identifier, n_deck)
        n_deck = n_deck + 1
      end
    end
  end



  spawning_deck = false
end

function fabdb_createDeckFromAPI(deck_url_or_id)
  if spawning_deck then
    return
  end

  if deck_url_or_id == nil then
    return
  end

  -- Support the full URL or just the deck ID
  deck_url_or_id = deck_url_or_id:trim()
  if deck_url_or_id == "" then
    return
  end

  local deck_id = ""
  local s_index = string.find(deck_url_or_id, "/[^/]*$")
  if s_index == nil then
    deck_id = deck_url_or_id
  else
    deck_id = deck_url_or_id:sub(s_index + 1)
  end

  local fabdb_url = "https://api.fabdb.net/decks/" .. deck_id .. "/osc"
  osc_getDeckFromURL(fabdb_url)
end


--[[
  Table helpers.
]]
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

--[[
  String helpers.
]]

function string.trim(s)
  -- source: http://lua-users.org/wiki/StringTrim
  local from = s:match"^%s*()"
  return from > #s and "" or s:match(".*%S", from)
end

invocation_list = {
  ["UPR006"] = "3e3cb5",
  ["UPR007"] = "23bba9",
  ["UPR008"] = "079c18",
  ["UPR009"] = "63b7f7",
  ["UPR010"] = "e06e56",
  ["UPR011"] = "0cdeab",
  ["UPR012"] = "213364",
  ["UPR013"] = "13cf9f",
  ["UPR014"] = "0a5bd3",
  ["UPR015"] = "77d0fc",
  ["UPR016"] = "34e4bf",
  ["UPR017"] = "b52990",
  ["UPR006-MV"] = "0baf91",
  ["UPR007-MV"] = "2e4879",
  ["UPR008-MV"] = "1bba8d",
  ["UPR009-MV"] = "939bfe",
  ["UPR010-MV"] = "38de83",
  ["UPR011-MV"] = "b7aeea",
  ["UPR012-MV"] = "1d4911",
  ["UPR013-MV"] = "7edb96",
  ["UPR014-MV"] = "7d167d",
  ["UPR015-MV"] = "ab82bb",
  ["UPR016-MV"] = "1da4b7",
  ["UPR017-MV"] = "108588",

  ["DYN092"] = "a84220",
  ["DYN092-MV"] = "5d998b",
  ["DYN212"] = "72bbab",
  ["DYN212-MV"] = "4dd770",
}
