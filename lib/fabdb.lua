
function retrieveCardFromFabDBAPI(identifier, position, rotation, back_face_url)
    -- Card info is normally found in the locally cached data - however, for cases where that data is not known, this function
    -- can be used to lookup the card from FabDB.
  
    local headers = {
      ["Content-Type"] = "application/json",
      Accept = "application/json",
    }
    local url = "https://api.fabdb.net/cards/" .. card_id
    WebRequest.get(url, function(request)
        if request.is_error then
            log(request.error)
        else
            local data = JSON.decode(request.text)
    
            local new_card = spawnObject({
            type = "Card",
            position = position,
            rotation = rotation,
            scale = { x = 1.5, y = 1.0, z = 1.5 },
            callback_function = function(spawned_card)
                -- set the front and back url
                end
            })
    
            local is_sideways = false
            for _, keyword in pairs(data["keywords"]) do
                if keyword == "landmark" then
                    is_sideways = true
                end
            end
    
            -- Custom overrides for particular card images
            image_url = data["image"]:split("?")[1]
            if card_id == "ELE000" then
                image_url = "http://cloud-3.steamusercontent.com/ugc/1684898660861024963/80840508762EB0CAC1281D3304A06975EB09032F/"
            end
    
            card_params = {
                face = image_url,
                back = back_face_url,
                sideways = is_sideways
            }
            new_card.setCustomObject(card_params)
            new_card.setName(identifier .. " - " .. data["name"])
            new_card.setDescription(data["text"])
            new_card.reload()
        end
    end)
end