


function fabrary_getDeckFromURL()
    if spawning_deck then
        return
    end
    
    local headers = {
        ["x-api-key"] = "tts-osc-vpnycGhvzfyjyRdvzQ8VPescPgfqAX",
        Accept = "application/json",
    }
    
    -- https://fabrary.net/decks/01G76G1DP5VVB050BT3YV9TQ7K
    local parts = string.split(deck_builder_input, "/")
    local slug_id = parts[#parts]

    local url = ""
    if slug_id != nil then
        url = 'https://5zvy977nw7.execute-api.us-east-2.amazonaws.com/prod/decks/' .. slug_id
    else
        print("Unable to determine the deck ID")
        return
    end
    
    spawning_deck = true
    WebRequest.custom(url, "GET", true, " ", headers, osc_loadDeckV2)
end