--[[

Flesh and Blood: TCG
Mod created by David Owens (owensd.io).
Flesh and Blood was created by Legendary Story Studios, all rights reserved.

Please support LSS buy purchasing the game. This mod is only to facilitate
online play and should not be considered a replacement for purchasing the
product! It's a great game, please support them!

Workshop ID: 2191845555

--]]

-- Allows objects to become interactable that normally should not.
dev_mode_enabled = false

-- A set of object GUIDs that need to be referenced from the code.
BACKGROUND_GUID = "a6a279"
BACKDROP_GUID = "0ba6cc"
DECKBUILDER_GUID = "6214a8"
SINGLE_PLAYER_MAT_BAG_GUID = "e0400a"
PLAYER_MAT_GUID = "679cbe"

-- NOTE: These can change if during development the layout changes.
initial_playmats = {"ef401b", "e7b790"}

mode_objects_to_cleanup = {}
loaded_playmats = {}
mat_urls = {}
background_urls = {}
background_index = {}
current_background_refs = {}

player_selection_order = {"Blue", "Red", "Orange", "Yellow", "Purple", "Pink", "Brown", "Teal"}
available_colors = player_selection_order

allow_mat_selection = false

layouts = {
  two = {
    table = {
      guid = BACKGROUND_GUID,
      position = { x=0, y=0.9, z=0 },
      rotation = { x=0.00, y=180.00, z=0.00 },
      scale = { x=22, y=1, z=22 },
      snap_points = { row_offset = 0.456 },
    },
    deck_builder = {
      guid = DECKBUILDER_GUID,
      position = { x=-26.40, y=1.00, z=0.00 },
      rotation = { x=0, y=90, z=0 },
      scale = { x=3, y=3, z=3 },
    },
    counters = {
      guid = "b79c34",
      position = { x=26.50, y=-4.50, z=0.00 },
      rotation = { x=0.00, y=180.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    quicken = {
      guid = "0e737c",
      position = { x=23.50, y=-4.50, z=2.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    runechant = {
      guid = "0e7039",
      position = { x=23.50, y=-4.50, z=-2.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    seismic = {
      guid = "aae201",
      position = { x=23.50, y=-4.50, z=0.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    copper = {
      guid = "078fab",
      position = { x=23.50, y=-4.50, z=4.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    zen = {
      guid = "a19c63",
      position = { x=23.50, y=-4.50, z=-4.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    spectral_shield = {
      guid = "a38575",
      position = { x=23.50, y=-4.50, z=-6.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    soul_shackle = {
      guid = "04c5ac",
      position = { x=23.50, y=-4.50, z=6.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    embodiment_of_lightning = {
      guid = "938a33",
      position = { x=23.50, y=-4.50, z=10.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    frostbit = {
      guid = "570f8f",
      position = { x=23.50, y=-4.50, z=8.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    embodiment_of_earth = {
      guid = "96c445",
      position = { x=23.50, y=-4.50, z=-8.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    aether_ashwing = {
      guid = "db9849",
      position = { x=26.50, y=-4.50, z=-2.50},
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    ash = {
      guid = "2d625e",
      position = { x=26.50, y=-4.50, z=-4.50},
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    black_tokens = {
      guid = "ff00dc",
      position = { x=23.50, y=-4.50, z=12.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    white_tokens = {
      guid = "233fc0",
      position = { x=23.50, y=-4.50, z=-10.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    black_die = {
      guid = "a0a1f7",
      position = { x=23.50, y=-0.50, z=-11.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=1, y=1, z=1 },
    },
    white_die = {
      guid = "15a290",
      position = { x=23.50, y=-0.50, z=13.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=1, y=1, z=1 },
    },
    hands = {
      Blue = {
        position = { x=0.00, y=5.00, z=-25.00 },
        rotation = { x=0.00, y=0.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Red = {
        position = { x=0.00, y=5.00, z=25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Orange = {
        position = { x=17.50, y=5.00, z=-25.00 },
        rotation = { x=0.00, y=0.00, z=0.00},
        scale = { x=0.00, y=9.00, z=5.00},
      },
      Yellow = {
        position = { x=17.50, y=5.00, z=25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=0.00, y=9.00, z=5.00},
      },
    },

    mats = {
      mat_1 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692293192/BC4DE9AE21106FF947BC65A6574AC529AE6547B2/",
        position = { x=0, y=1, z=-10 },
        rotation = { x=0, y=180, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
      mat_2 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692287068/2B9575B593624B9C59CF8CE2369CA81D80D173FC/",
        position = { x=0, y=1, z=10 },
        rotation = { x=0, y=0, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
    },
  },

  four = {
    table = {
      guid = BACKGROUND_GUID,
      position = { x=0, y=0.9, z=0 },
      rotation = { x=0.00, y=180.00, z=0.00 },
      scale = { x=22, y=1, z=22 },
      snap_points = { row_offset = 0.456 },
    },
    deck_builder = {
      guid = DECKBUILDER_GUID,
      position = { x=-38, y=1.00, z=0.00 },
      rotation = { x=0, y=90, z=0 },
      scale = { x=3, y=1, z=3 },
    },
    counters = {
      guid = "b79c34",
      position = { x=39.50, y=-4.50, z=0.00 },
      rotation = { x=0.00, y=180.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    quicken = {
      guid = "0e737c",
      position = { x=36.50, y=-4.50, z=2.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    runechant = {
      guid = "0e7039",
      position = { x=36.50, y=-4.50, z=-2.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    seismic = {
      guid = "aae201",
      position = { x=36.50, y=-4.50, z=0.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    copper = {
      guid = "078fab",
      position = { x=36.50, y=-4.50, z=4.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    zen = {
      guid = "a19c63",
      position = { x=36.50, y=-4.50, z=-4.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    spectral_shield = {
      guid = "a38575",
      position = { x=36.50, y=-4.50, z=-6.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    embodiment_of_lightning = {
      guid = "938a33",
      position = { x=36.50, y=-4.50, z=10.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    frostbit = {
      guid = "570f8f",
      position = { x=36.50, y=-4.50, z=8.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    embodiment_of_earth = {
      guid = "96c445",
      position = { x=36.50, y=-4.50, z=-8.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    soul_shackle = {
      guid = "04c5ac",
      position = { x=36.50, y=-4.50, z=6.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    aether_ashwing = {
      guid = "db9849",
      position = { x=39.50, y=-4.50, z=-2.50},
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    ash = {
      guid = "2d625e",
      position = { x=39.50, y=-4.50, z=-4.50},
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    black_tokens = {
      guid = "ff00dc",
      position = { x=36.50, y=-4.50, z=12.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    white_tokens = {
      guid = "233fc0",
      position = { x=36.50, y=-4.50, z=-10.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    black_die = {
      guid = "a0a1f7",
      position = { x=36.50, y=-0.50, z=-11.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=1, y=1, z=1 },
    },
    white_die = {
      guid = "15a290",
      position = { x=36.50, y=-0.50, z=13.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=1, y=1, z=1 },
    },
    hands = {
      Blue = {
        position = { x=-17.50, y=5.00, z=-25.00 },
        rotation = { x=0.00, y=0.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Red = {
        position = { x=-17.50, y=5.00, z=25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Orange = {
        position = { x=17.50, y=5.00, z=-25.00 },
        rotation = { x=0.00, y=0.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Yellow = {
        position = { x=17.50, y=5.00, z=25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
    },

    mats = {
      mat_1 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692293192/BC4DE9AE21106FF947BC65A6574AC529AE6547B2/",
        position = { x=17.5, y=1, z=-10 },
        rotation = { x=0, y=180, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
      mat_2 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692287068/2B9575B593624B9C59CF8CE2369CA81D80D173FC/",
        position = { x=17.5, y=1, z=10 },
        rotation = { x=0, y=0, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },

      mat_3 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692290359/E23A51278BD0123EFCD39AA6CEAF2FAB815E8321/",
        position = { x=-17.5, y=1, z=-10 },
        rotation = { x=0, y=180, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
      mat_4 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692293776/68F6B6C6716CED11990EFB66729F5E93572D267D/",
        position = { x=-17.5, y=1, z=10 },
        rotation = { x=0, y=0, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
    },
  },

  -- This layout assumes that mode 4 is also being used.
  eight = {
    table = {
      guid = BACKGROUND_GUID,
      position = { x=81.5, y=0.9, z=0 },
      rotation = { x=0.00, y=180.00, z=0.00 },
      scale = { x=22, y=1, z=22 },
      snap_points = { row_offset = 0.456 },
      clone = true,
      is_table = true,
    },
    deck_builder = {
      guid = DECKBUILDER_GUID,
      position = { x=43.50, y=1.00, z=0.00 },
      rotation = { x=0, y=90, z=0 },
      scale = { x=3, y=1, z=3 },
      clone = true,
    },
    counters = {
      guid = "b79c34",
      position = { x=121.00, y=-4.50, z=0.00 },
      rotation = { x=0.00, y=180.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    quicken = {
      guid = "0e737c",
      position = { x=118.00, y=-4.50, z=2.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    runechant = {
      guid = "0e7039",
      position = { x=118.00, y=-4.50, z=-2.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    seismic = {
      guid = "aae201",
      position = { x=118.00, y=-4.50, z=0.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    copper = {
      guid = "078fab",
      position = { x=118.00, y=-4.50, z=4.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    zen = {
      guid = "a19c63",
      position = { x=118.00, y=-4.50, z=-4.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    spectral_shield = {
      guid = "a38575",
      position = { x=118.00, y=-4.50, z=-6.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    soul_shackle = {
      guid = "04c5ac",
      position = { x=118.00, y=-4.50, z=6.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },

    embodiment_of_lightning = {
      guid = "938a33",
      position = { x=118.00, y=-4.50, z=10.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    frostbit = {
      guid = "570f8f",
      position = { x=118.00, y=-4.50, z=8.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    embodiment_of_earth = {
      guid = "96c445",
      position = { x=118.00, y=-4.50, z=-8.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    aether_ashwing = {
      guid = "db9849",
      position = { x=121.00, y=-4.50, z=-2.50},
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },
    ash = {
      guid = "2d625e",
      position = { x=121.00, y=-4.50, z=-4.50},
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
    },

    black_tokens = {
      guid = "ff00dc",
      position = { x=118.00, y=-4.50, z=12.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    white_tokens = {
      guid = "233fc0",
      position = { x=118.00, y=-4.50, z=-10.00 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=3, y=3, z=3 },
      clone = true,
    },
    black_die = {
      guid = "a0a1f7",
      position = { x=118.00, y=-0.50, z=-11.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=1, y=1, z=1 },
      clone = true,
    },
    white_die = {
      guid = "15a290",
      position = { x=118.00, y=-0.50, z=13.0 },
      rotation = { x=0.00, y=90.00, z=0.00 },
      scale = { x=1, y=1, z=1 },
      clone = true,
    },
    hands = {
      Purple = {
        position = { x=64.00, y=5.00, z=-25.00 },
        rotation = { x=0.00, y=0.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Pink = {
        position = { x=64.0, y=5.00, z=25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Brown = {
        position = { x=99.00, y=5.00, z=-25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
      Teal = {
        position = { x=99.00, y=5.00, z=25.00 },
        rotation = { x=0.00, y=180.00, z=0.00},
        scale = { x=26.00, y=9.00, z=5.00},
      },
    },

    mats = {
      mat_5 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692293192/BC4DE9AE21106FF947BC65A6574AC529AE6547B2/",
        position = { x=99.00, y=1, z=-10 },
        rotation = { x=0, y=180, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
      mat_6 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692287068/2B9575B593624B9C59CF8CE2369CA81D80D173FC/",
        position = { x=99.00, y=1, z=10 },
        rotation = { x=0, y=0, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },

      mat_7 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692290359/E23A51278BD0123EFCD39AA6CEAF2FAB815E8321/",
        position = { x=64.00, y=1, z=-10 },
        rotation = { x=0, y=180, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
      mat_8 = {
        image = "http://cloud-3.steamusercontent.com/ugc/1465311696692293776/68F6B6C6716CED11990EFB66729F5E93572D267D/",
        position = { x=64.00, y=1, z=10 },
        rotation = { x=0, y=0, z=0 },
        scale = { x=10, y=1, z=10 },
        thickness = 0.1,
      },
    },
  },
}

function setSnapPoints(mode)

  local left_col_x_off = 1.2
  local right_col_x_off = -left_col_x_off
  local middle_col_x_off = 0

  local top_row_z_off = -mode.snap_points.row_offset
  local middle_row_z_off = 0
  local bottom_row_z_off = -top_row_z_off

  local table = getObjectFromGUID(BACKGROUND_GUID)

  table.setSnapPoints({
    -- Center mat, 2-player mat snap
    { position = {middle_col_x_off,0,middle_row_z_off},
      rotation = {0,0,0},
      rotation_snap = true },
    -- Center, top mat
    { position = {middle_col_x_off,0,top_row_z_off},
      rotation = {180,0,0},
      rotation_snap = true },
    -- Center, bottom mat
    { position = {middle_col_x_off,0,bottom_row_z_off},
      rotation = {0,0,0},
      rotation_snap = true },

    -- Left mat, 2-player mat snap
    { position = {left_col_x_off,0,middle_row_z_off},
      rotation = {0,0,0},
      rotation_snap = true },
    -- Left, top mat
    { position = {left_col_x_off,0,top_row_z_off},
      rotation = {180,0,0},
      rotation_snap = true },
    -- Left, bottom mat
    { position = {left_col_x_off,0,bottom_row_z_off},
      rotation = {0,0,0},
      rotation_snap = true },

    -- Right mat, 2-player mat snap
    { position = {right_col_x_off,0,middle_row_z_off},
      rotation = {0,0,0},
      rotation_snap = true },
    -- Right, top mat
    { position = {right_col_x_off,0,top_row_z_off},
      rotation = {180,0,0},
      rotation_snap = true },
    -- Right, bottom mat
    { position = {right_col_x_off,0,bottom_row_z_off},
      rotation = {0,0,0},
      rotation_snap = true },
  })

end

function changeMode(mode)
  -- The 8-player mode assumes that the first board has been setup for four players.
  if mode == layouts.eight then
    changeMode(layouts.four)
  end

  -- Remove any objects placed by a mode change that need to be removed.
  for k,o in pairs(mode_objects_to_cleanup) do
    if o != nil then
      destroyObject(o)
    end
  end
  mode_objects_to_cleanup = {}

  -- Remove any placed mats.
  for k,mat in pairs(loaded_playmats) do
    if mat != nil then
      destroyObject(mat)
    end
  end
  loaded_playmats = {}

  -- Setup the layout of any item given with a 'guid'.
  for n,item in pairs(mode) do
    if item.guid != nil then
      local ref = getObjectFromGUID(item.guid)
      if item.clone then
        ref = ref.clone()
        table.insert(mode_objects_to_cleanup, ref)
      end
      local scale = { x=1, y=1, z=1}
      if item.scale != nil then
        scale = item.scale
      end

      -- The cloned items are simply positioned immediately, otherwise, it looks odd.
      if item.clone then
        ref.setPosition(item.position)
        ref.setRotation(item.rotation)
      else
        ref.setPositionSmooth(item.position)
        ref.setRotationSmooth(item.rotation)
      end
      ref.setScale(scale)

      if item.is_table then
        --ref.interactable = false
        table.insert(current_background_refs, ref)
      end
    end
  end

  -- Setup the hand zones.
  for k,v in pairs(mode.hands) do
    Player[k].setHandTransform({
      position = v.position,
      rotation = v.rotation,
      scale    = v.scale,
    }, 1)
  end

  -- Setup the player mats.
  for k,v in pairs(mode.mats) do
    -- Pick a random mat mage with fallback.
    local mat_url = mat_urls[math.random(#mat_urls)]
    if mat_url == nil then
      mat_url = v.image
    end

    local mat_template = getObjectFromGUID(PLAYER_MAT_GUID)
    local cloned_mat = mat_template.clone({ position = v.position })
    cloned_mat.setScale(v.scale)
    cloned_mat.setRotation(v.rotation)
    cloned_mat.setCustomObject({ image = mat_url, thickness = v.thickness })
    cloned_mat = cloned_mat.reload()

    Wait.condition(
      function()
        -- The template is locked; unlock so it will fall to the backdrop.
        cloned_mat.unlock()

        -- Primary to disable the zoom.
        cloned_mat.interactable = false
        -- Make sure to add this to the list of playmats so it can be removed.
        table.insert(loaded_playmats, cloned_mat)
      end,
      function() return not cloned_mat.spawning end
    )

    Wait.time(function() cloned_mat.lock() end, 1, 1)
  end
end

function assignPlayerToAvailableColor(player, color)
  local color = table.remove(available_colors, 1)
  broadcastToAll("Assigning " .. player.steam_name .. " to color " .. color)
  player.changeColor(color)
end

function onPlayerConnect(player)
  assignPlayerToAvailableColor(player)
end

function onPlayerDisconnect(player)
  table.insert(available_colors, 1, player.color)
end

function onLoad()
  getObjectFromGUID(BACKDROP_GUID).interactable = dev_mode_enabled
  getObjectFromGUID(PLAYER_MAT_GUID).interactable = dev_mode_enabled

  local background_ref = getObjectFromGUID(BACKGROUND_GUID)
  table.insert(current_background_refs, background_ref)
  background_ref.interactable = dev_mode_enabled

  -- Assign all connected players to a color spot.
  for _, player in ipairs(Player.getPlayers()) do
    assignPlayerToAvailableColor(player)
  end

  -- Populate the initial playmats
  for _,mat in pairs(initial_playmats) do
    local o = getObjectFromGUID(mat)
    table.insert(loaded_playmats, o)
    o.interactable = false
    o.lock()
  end

  -- Populate the available mat URLs
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692282994/3CAC106C13E4C177EF5B0A3B841500059E39C82C/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692283552/C7647D66DDD768EE894A8EC8F2A4358640322153/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692283927/D269443DF72D47584FBA507F6AACC25881B28564/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692284402/185C644BC66F4F9C9BA5A84135FAD75F71D672F5/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311478989605818/D3DD85DC3255AC2A2DE4CB692E7B2B557596190E/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311478989579854/7B46374B460EF6B4309B7EB0012DBD8EB1B6F787/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692285477/7343FA7C2ACA6351C5EC7A70C5B31D8C4779B430/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692285838/7C22387AA0F8D36ADA67676DC1D64050E087F7B0/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692286241/E6C97E7B5ED440D0769A819FCFA2AD4A0C1016E9/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692287068/2B9575B593624B9C59CF8CE2369CA81D80D173FC/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692288129/388066D358BEA3A585A1BAA3BE4EFBF847CB1FA8/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692288601/CCD18B2CDD4B9B75CBA852BF08E1B2E282AC1CD8/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692289519/217F4D55E7BDB9B64FCB68036F1EB4602CFCF021/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692289931/D5907E6D8FD9515BAD1866A4D7DCDA65931B5380/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692290359/E23A51278BD0123EFCD39AA6CEAF2FAB815E8321/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692290752/78ECEE3A5E94DFDB93553638DFDA018C499539C3/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692291151/D611B5F244FEF7C5C19812F9C17E62E4AFFCA66C/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692291666/1065DF6989DA9E9DC0F7794207A51B603C272FEB/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692292009/17D79140D16A4A6C65BDF95DB7B62AAE880D0CAC/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692292356/2E720944C4F18274E088BC162245ED7C9FF9E4C2/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692293192/BC4DE9AE21106FF947BC65A6574AC529AE6547B2/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692294210/4F3C934D9BC8FF1E42833076297AA0731E7BE4E1/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692293776/68F6B6C6716CED11990EFB66729F5E93572D267D/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692294638/459B3B8B9539A1DF94CCD16CA074D5D0898F681E/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692295065/99A0C0E467C42BD7957D6BCD16D1E29BD330EC43/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692295679/3517384A96054EC07607981A53C8F366BA9BA172/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692296151/106FA4D2FA2E20D78CDCD20B3BD9410F21232432/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692296724/9E9D9D8AF9DE6979D1DF0E62481C17659DFCE859/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692297123/7600AD947243B9E15F73DF5AE61CB1475483FFE5/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1465311696692297491/DF3B0B286D0935B7CA65993C7FB5C76E06494B9D/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1482200828520115034/315469F0F88B4E8E2022698AD27C935E84A61544/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1482200828520115552/B791719632CB35E55DAA3ED520D8A46EEA228B69/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1482200828520116069/73867AD173A4FC05573B260A0D268A0D0CBC4589/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1482200828520116796/FF7F6CFDA1CBF01F515EF4900DC7D0B273F1A496/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1482200828520117293/B88A05600DE2B92D65F641E29361651B9C4784A1/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1620688860151620430/01AEB26B42F6DCFC7153597B9D89D575176BC6E7/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1664610484564875888/3292349DBC1D9593A12EC3444BA529C32AF36A4C/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1754684793159073139/A0B60137855995DF21CF3C5B41C1F51631F77CF0/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1742303890325660383/423E3EBBBE621DC13EE7D33A591FECCFC9896418/")
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497401979/85E11195C7BB0286AF5391E31710C55FF2F8AF70/") -- Prism
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497402130/E4685FF643865057A7F6462CCC963B4C67CA7180/") -- Prism - Young
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497401847/7E69C3C3E5D7564FAB9C78410663D31BAD5A6149/") -- Levia
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497401705/68E83F046EB35A448D1F2F0A03716746A0709B7A/") -- Levia - Young
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497401531/EF6D31AC2159DD688FE6C1BCB4D62D4717E867DC/") -- Chane - Young
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497401408/32E0FD7B87CCEA8717C60C338F65B3C5ED617607/") -- Boltyn
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1800854600497401216/6D4EE9845CD0ACB1DF2C340A037154DCAE3350AF/") -- Boltyn - Young
  table.insert(mat_urls, "http://cloud-3.steamusercontent.com/ugc/1755833913582088725/EE2664E6907F567188803627A745B0FF3D37AD0B/") -- Dark Fill

  -- Populate the background mat URLs.
  table.insert(background_urls, { label = "aria", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929013316/37FBA6DCB1ED1FD4C8DB355670D90111E1FFE2E3/" })
  table.insert(background_urls, { label = "demonastery", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929013866/AF651A48EFF4375000C6F26A8EBC33193B65D96B/" })
  table.insert(background_urls, { label = "metrix", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929014310/109D915E0DA4EB2CEB45E19DB4F96DDB06C0C865/" })
  table.insert(background_urls, { label = "misteria", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929014839/5309790E47CDFC0219DF9509EE3FCA47B05ADD1F/" })
  table.insert(background_urls, { label = "pits", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929015168/A51B4F99462BAB2225E9DCC2DF23A85D4DD17EA6/" })
  table.insert(background_urls, { label = "savage_lands", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929015475/58E2DDE4F60A35C210439AFBFD4E2AB0F6F7E360/" })
  table.insert(background_urls, { label = "solana", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929015786/D1F2E893D401B84A3F7280DFA30130CD083473B3/" })
  table.insert(background_urls, { label = "volcor", url = "http://cloud-3.steamusercontent.com/ugc/1468689621929016151/26DDCFA67A841BA9AB4B122B0ED555C299143342/" })
  table.insert(background_urls, { label = "black", url = "http://cloud-3.steamusercontent.com/ugc/1755833913582103839/7894F5841791FA8550384F4E7F7C00DAF39DDF4F/" })

  -- Set the default game up for two players.
  -- changeMode(layouts.two)
end

function onAllowMatSelections()
  allow_mat_selection = not allow_mat_selection
  local label = "Un- lock"
  if allow_mat_selection then
    label = "Lock"
  end
  self.UI.setAttribute("lock_button", "text", label)

  for _, mat in pairs(loaded_playmats) do
    mat.interactable = allow_mat_selection
  end

  for k,ref in pairs(current_background_refs) do
    if ref != nil then
      ref.interactable = allow_mat_selection
    end
  end
end

function onChangePlayersClicked(player, num)
  if num == "1" then
    changeMode(layouts.two)
  elseif num == "2" then
    changeMode(layouts.two)
  elseif num == "4" then
    changeMode(layouts.four)
  elseif num == "8" then
    changeMode(layouts.eight)
  end
end

function updateBackground(background_index, guid)
  local background_ref = getObjectFromGUID(guid)
  background_ref.setCustomObject({
    image = background_urls[background_index].url,
    thickness = 0.1,
  })
  local new_ref = background_ref.reload()
  table.insert(current_background_refs, new_ref)

  if guid != BACKGROUND_GUID then
    table.insert(mode_objects_to_cleanup, new_ref)
  end
end


--[[
  Public APIs
]]

function oscIsDevModeEnabled()
  return dev_mode_enabled
end

function oscGetNumberOfPlaymatImages(params)
  return #mat_urls
end

function oscGetImageURL(params)
  return mat_urls[params.index]
end

function oscGetIndexForURL(params)
  for k,v in pairs(mat_urls) do
    if v == params.url then
      return k
    end
  end
  return -1
end

function oscRegisterNewMat(params)
  if params.mat != nil then
    table.insert(loaded_playmats, params.mat)
  end
end

function oscGetBackgroundIndexForURL(params)
  for k,v in pairs(background_urls) do
    if v.url == params.url then
      return k
    end
  end
  return 1
end

function oscUpdateBackgroundIndex(params)
  if params.base != nil then
    background_index[params.guid] = params.base
  end

  if background_index[params.guid] == nil then
    background_index[params.guid] = 1
  end

  background_index[params.guid] = background_index[params.guid] + params.offset
  background_index[params.guid] = math.max(1, math.min(background_index[params.guid], #background_urls))
  updateBackground(background_index[params.guid], params.guid)
end

--[[
  Global event handlers.
]]

-- function onObjectEnterZone(zone, object)
--   -- Ensure that all cards that enter into the zone are vertical. This is especially
--   -- problematic for `sideways` cards. However, we still want TTS to support the
--   -- proper zooming, so these cards must stay `sideways=true`.
--
--   local hands = Hands.getHands()
--   log(hands)
--   for _,hand in pairs(hands) do
--     if zone.guid == hand.guid then
--       local rot = zone.getRotation()
--       local card_rot = {0, rot['y'] + 180, 0}
--       object.setRotation(card_rot)
--     end
--   end
--
-- end