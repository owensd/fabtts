

function onLoad()
    local background_url = self.getCustomObject().image
    local background_index = Global.call("oscGetBackgroundIndexForURL", { guid = self.guid, url = background_url })
    -- Delay setting so the UI is created.
    Wait.frames(function() self.UI.setAttribute("background_index", "text", tostring(background_index)) end, 1)
  end
  
  function onFixedUpdate()
    if self.interactable then
      self.UI.show("panel")
    else
      self.UI.hide("panel")
    end
  end
  
  function onSelectPreviousMat()
    updateMatIndex(-1)
  end
  
  function onSelectNextMat()
    updateMatIndex(1)
  end
  
  function onIndexChanged(player, value)
    local new_index = tonumber(value)
    if new_index != nil then
      background_index = new_index
      updateMatIndex(0, background_index)
    end
  end
  
  function updateMatIndex(offset, base)
    Global.call("oscUpdateBackgroundIndex", { guid = self.guid, offset = offset, base = base })
  end