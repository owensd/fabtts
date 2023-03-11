--[[

    This is the API file for working with fabdb.net.

--]]

local function sanitizeJSON(text)
    -- Handle the unicode apostophes...
    local result = string.gsub(text, "‘", "'")
    result = string.gsub(result, "’", "'")
    result = string.gsub(result, "\\u2018", "'")
    result = string.gsub(result, '"identifier"', '"cardIdentifier"')
    return result
end

function FABDBGetCardFromIdentifier(identifier, fn)
    -- Card info is normally found in the locally cached data - however, for cases where that data is not known, this function
    -- can be used to lookup the card from FabDB.

    local headers = {
      ["Content-Type"] = "application/json",
      Accept = "application/json",
    }
    local url = "https://api.fabdb.net/cards/" .. identifier
    WebRequest.get(url, function(request)
        if request.is_error then
            log(request.error)
        else
            if request.text == nil then
                print("Unable to load card: " .. identifier)
            elseif string.sub(request.text, 1, 1) ~= "{" then
                print("Unable to load card: " .. identifier)
            else
                local data = JSON.decode(sanitizeJSON(request.text))
                fn(data)
            end
        end
    end)
end

function FABDBGetDeckFrom(urlOrSlug, fn)
    local headers = {
        ["Content-Type"] = "application/json",
    }

    -- https://fabdb.net/decks/oZKNgjjK
    local parts = string.split(urlOrSlug, "/")
    local slugID = parts[#parts]

    local url = ""
    if slugID ~= nil then
        url = "https://api.fabdb.net/decks/" .. slugID .. "/osc"
    else
        print("Unable to determine the deck ID: " .. urlOrSlug)
        return
    end

    WebRequest.custom(url, "GET", true, " ", headers, function(resp) fn(resp) end)
end
