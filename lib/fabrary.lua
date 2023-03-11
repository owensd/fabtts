


function FBGetDeckFrom(urlOrSlug, fn)
    local headers = {
        ["x-api-key"] = "tts-osc-vpnycGhvzfyjyRdvzQ8VPescPgfqAX",
        Accept = "application/json",
    }

    -- https://fabrary.net/decks/01G76G1DP5VVB050BT3YV9TQ7K
    local parts = string.split(urlOrSlug, "/")
    local slugID = parts[#parts]

    local url = ""
    if slugID ~= nil then
        url = 'https://5zvy977nw7.execute-api.us-east-2.amazonaws.com/prod/decks/' .. slugID .. "?includeText=true"
    else
        print("Unable to determine the deck ID: " .. urlOrSlug)
        return
    end

    WebRequest.custom(url, "GET", true, " ", headers, function(resp) fn(resp) end)
end