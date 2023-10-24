


function FBGetDeckFrom(urlOrSlug, fn)
    local headers = {
        ["x-api-key"] = "tts-osc-vpnycGhvzfyjyRdvzQ8VPescPgfqAX2",
        Accept = "application/json",
    }

    -- https://atofkpq0x8.execute-api.us-east-2.amazonaws.com/prod/v1/decks/{deckId}
    local parts = string.split(urlOrSlug, "/")
    local slugID = parts[#parts]

    local url = ""
    if slugID ~= nil then
        url = 'https://atofkpq0x8.execute-api.us-east-2.amazonaws.com/prod/v1/decks/' .. slugID .. "?includeText=true"
    else
        print("Unable to determine the deck ID: " .. urlOrSlug)
        return
    end

    WebRequest.custom(url, "GET", true, " ", headers, function(resp) fn(resp) end)
end