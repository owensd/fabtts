
local gPlaymatLeftColXOffset = 1.47
local gPlaymatLeftCol2XOffset = 1.05
local gPlaymatRightColXOffset = -gPlaymatLeftColXOffset
local gPlaymatRightCol2XOffset = -gPlaymatLeftCol2XOffset

local gPlaymatLeftMidColXOffset = 0.425
local gPlaymatRightMidColXOffset = -gPlaymatLeftMidColXOffset

local gPlaymatTopRowZOffset = -0.44
local gPlaymatMiddleRowZOffset = 0.125
local gPlaymatBottomRowZOffset = 0.685

function onLoad()
    self.setSnapPoints({
        -- hero card
        { position = {0,0,gPlaymatMiddleRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- weapon left card
        { position = {gPlaymatLeftMidColXOffset,0,gPlaymatMiddleRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- weapon right card
        { position = {gPlaymatRightMidColXOffset,0,gPlaymatMiddleRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- arsenal card
        { position = {0,0,gPlaymatBottomRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- arsenal-left card
        { position = {gPlaymatLeftMidColXOffset,0,gPlaymatBottomRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- arsenal-right card
        { position = {gPlaymatRightMidColXOffset,0,gPlaymatBottomRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },

        -- helm card
        { position = {gPlaymatLeftColXOffset,0,gPlaymatTopRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- chest card
        { position = {gPlaymatLeftColXOffset,0,gPlaymatMiddleRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- arms card
        { position = {gPlaymatLeftCol2XOffset,0,gPlaymatMiddleRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- boots card
        { position = {gPlaymatLeftColXOffset,0,gPlaymatBottomRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },

        -- graveyard
        { position = {gPlaymatRightColXOffset,0,gPlaymatTopRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- deck
        { position = {gPlaymatRightColXOffset,0,gPlaymatMiddleRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
        -- banished
        { position = {gPlaymatRightColXOffset,0,gPlaymatBottomRowZOffset},
            rotation = {0,0,0},
            rotation_snap = true },
    })
end


--[[ UI Interactions --]]

function PLOnPitchPressed(player)
    local deck_ray = self.positionToWorld({x=gPlaymatRightColXOffset, y=5, z=gPlaymatMiddleRowZOffset})
    local pitch_ray = self.positionToWorld({x=gPlaymatRightCol2XOffset, y=5, z=gPlaymatMiddleRowZOffset})
    local ray_dir = {x=0, y=-1, z=0}
    local card_size = {x=3.5, y=2, z=5}

    -- This can be a card or a deck, it doesn't matter for our purposes.
    local deck = nil
    local deck_pick = Physics.cast({
        origin = deck_ray,
        direction = ray_dir,
    })
    for _, hit in pairs(deck_pick) do
        if hit.hit_object.tag == "Card" or hit.hit_object.tag == "Deck" then
        deck = hit.hit_object
        break
        end
    end

    -- This can be a set of cards or a deck, it doesn't matter.
    local pitch_cards = {}
    local pitch_pick = Physics.cast({
        origin = pitch_ray,
        direction = ray_dir,
        type = 3,   -- box selection
        size = card_size
    })

    --[[

    Story Time:

    TTS has a lot of trouble with ordering loose cards. There is the ability to perform physics casting,
    however, the order may not actually be the order you intended. Also, functionality like `group()` are
    all based on the same building blocks: they are unreliable.

    As such, this API ensures that only a single deck is found in the pitch area. This can be sorted using
    the "Search" functionality. Then, pressing "End Turn" will put the pitch deck properly at the bottom of
    your deck.

    ]]

    for _, hit in pairs(pitch_pick) do
        if hit.hit_object.tag == "Card" or hit.hit_object.tag == "Deck" then
        table.insert(pitch_cards, hit.hit_object)
        end
    end

    -- Nothing to do if there are no pitch cards!
    if #pitch_cards == 0 then
        return
    end

    if #pitch_cards > 1 then
        broadcastToColor("Please order your pitch area into a deck first to ensure the order is what you intend.", player.color)
        return
    end

    -- If the player doesn't have a deck, then the pitch deck is the new deck. Hopefully they kill their opponent
    -- quickly!
    if deck == nil then
        local pitch_deck = pitch_cards[1]

        local deck_pos = self.positionToWorld({x=gPlaymatRightColXOffset, y=1.5, z=gPlaymatMiddleRowZOffset})
        local deck_rot = pitch_deck.getRotation()
        deck_rot.z = 180

        pitch_deck.setPositionSmooth(deck_pos, false, false)
        pitch_deck.setRotationSmooth(deck_rot, false, false)
    else
        -- TTS will combine a single card into a deck... so, if your deck has only one card, but your pitch is a deck,
        -- TTS combines this incorrectly. Thus, we need to use the physics engine to actually stack our cards...
        local deck_pos = self.positionToWorld({x=gPlaymatRightColXOffset, y=2, z=gPlaymatMiddleRowZOffset})
        deck.setPositionSmooth(deck_pos, false, false)
        deck.lock()

        Wait.time(function()
            local pitch_deck = pitch_cards[1]
            local deck_pos = self.positionToWorld({x=gPlaymatRightColXOffset, y=1.15, z=gPlaymatMiddleRowZOffset})
            local deck_rot = deck.getRotation()
            pitch_deck.setPositionSmooth(deck_pos, false, false)
            pitch_deck.setRotationSmooth(deck_rot, false, false)

            Wait.time(function()
                deck.unlock()
            end, 1.25)
        end, 0.5)
    end
end