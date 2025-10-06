return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 14,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 27,
  nextobjectid = 94,
  properties = {},
  tilesets = {
    {
      name = "battlefield_tileset",
      firstgid = 1,
      filename = "field_tileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../images/battlefield_tileset.png",
      imagewidth = 512,
      imageheight = 256,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {
        {
          name = "Bounds",
          tile = 6,
          properties = {}
        },
        {
          name = "Forest",
          tile = 0,
          properties = {}
        }
      },
      tilecount = 128,
      tiles = {
        {
          id = 0,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 1,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 2,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 3,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 4,
          type = "Grass",
          properties = {
            ["walk_cost"] = 1.5,
            ["walkable"] = true
          }
        },
        {
          id = 5,
          type = "Grass",
          properties = {
            ["walk_cost"] = 1.5,
            ["walkable"] = true
          }
        },
        {
          id = 6,
          type = "Grass",
          properties = {
            ["walk_cost"] = 1.5,
            ["walkable"] = true
          }
        },
        {
          id = 7,
          type = "Grass",
          properties = {
            ["walk_cost"] = 1.5,
            ["walkable"] = true
          }
        },
        {
          id = 8,
          properties = {
            ["selectable"] = false
          },
          terrain = { -1, -1, -1, 0 }
        },
        {
          id = 9,
          properties = {
            ["selectable"] = false
          },
          terrain = { -1, -1, 0, 0 }
        },
        {
          id = 10,
          properties = {
            ["selectable"] = false
          },
          terrain = { -1, -1, 0, -1 }
        },
        {
          id = 11,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, 0, 0, -1 }
        },
        {
          id = 12,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, 0, -1, 0 }
        },
        {
          id = 16,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 17,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 18,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 19,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 21,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 22,
          type = "Lantern"
        },
        {
          id = 23,
          properties = {
            ["walk_cost"] = 2
          }
        },
        {
          id = 24,
          properties = {
            ["selectable"] = false
          },
          terrain = { -1, 0, -1, 0 }
        },
        {
          id = 25,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 26,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, -1, 0, -1 }
        },
        {
          id = 27,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, -1, 0, 0 }
        },
        {
          id = 28,
          properties = {
            ["selectable"] = false
          },
          terrain = { -1, 0, 0, 0 }
        },
        {
          id = 29,
          type = "Trees"
        },
        {
          id = 30,
          type = "Houses"
        },
        {
          id = 31,
          type = "Lantern"
        },
        {
          id = 32,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 33,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 34,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 35,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 37,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 38,
          properties = {
            ["shadowHeight"] = 7,
            ["shadowOffsetX"] = 0,
            ["shadowWidth"] = 14
          }
        },
        {
          id = 39,
          properties = {
            ["walk_cost"] = 2
          }
        },
        {
          id = 40,
          properties = {
            ["selectable"] = false
          },
          terrain = { -1, 0, -1, -1 }
        },
        {
          id = 41,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, 0, -1, -1 }
        },
        {
          id = 42,
          properties = {
            ["selectable"] = false
          },
          terrain = { 0, -1, -1, -1 }
        },
        {
          id = 48,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 49,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 50,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 51,
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 52,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 53,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 54,
          properties = {
            ["walkable"] = false
          }
        },
        {
          id = 55,
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = false
          }
        },
        {
          id = 56,
          properties = {
            ["shadowHeight"] = 8,
            ["shadowOffsetX"] = 0,
            ["shadowWidth"] = 18
          }
        },
        {
          id = 57,
          properties = {
            ["shadowHeight"] = 8,
            ["shadowOffsetX"] = 0,
            ["shadowWidth"] = 18
          }
        },
        {
          id = 58,
          properties = {
            ["shadowHeight"] = 4,
            ["shadowOffsetX"] = 0,
            ["shadowWidth"] = 6
          }
        },
        {
          id = 60,
          properties = {
            ["shadowHeight"] = 6,
            ["shadowOffsetX"] = 0,
            ["shadowWidth"] = 10
          }
        },
        {
          id = 62,
          properties = {
            ["shadowHeight"] = 6,
            ["shadowOffsetX"] = 0,
            ["shadowWidth"] = 10
          }
        },
        {
          id = 64,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 65,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 66,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 67,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 68,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 69,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 70,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 72,
          properties = {
            ["shadowHeight"] = 7,
            ["shadowOffsetX"] = 16,
            ["shadowWidth"] = 41
          }
        },
        {
          id = 73,
          properties = {
            ["shadowHeight"] = 7,
            ["shadowOffsetX"] = -16,
            ["shadowWidth"] = 41
          }
        },
        {
          id = 76,
          properties = {
            ["walk_cost"] = 2
          }
        },
        {
          id = 77,
          properties = {
            ["walk_cost"] = 2
          }
        },
        {
          id = 78,
          properties = {
            ["walk_cost"] = 2
          }
        },
        {
          id = 80,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 81,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 82,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 83,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 84,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 85,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 86,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 87,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 88,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { -1, -1, -1, 1 }
        },
        {
          id = 89,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { -1, -1, 1, 1 }
        },
        {
          id = 90,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { -1, -1, 1, -1 }
        },
        {
          id = 91,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, 1, 1, -1 }
        },
        {
          id = 92,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, 1, -1, 1 }
        },
        {
          id = 93,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 94,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 96,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 97,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 98,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 99,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 100,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 101,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 102,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 103,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 104,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { -1, 1, -1, 1 }
        },
        {
          id = 105,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, 1, 1, 1 }
        },
        {
          id = 106,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, -1, 1, -1 }
        },
        {
          id = 107,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, -1, 1, 1 }
        },
        {
          id = 108,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { -1, 1, 1, 1 }
        },
        {
          id = 109,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 110,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 112,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 113,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 114,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 115,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 116,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 117,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 118,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 119,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 120,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { -1, 1, -1, -1 }
        },
        {
          id = 121,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, 1, -1, -1 }
        },
        {
          id = 122,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          },
          terrain = { 1, -1, -1, -1 }
        },
        {
          id = 123,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 124,
          type = "Path",
          properties = {
            ["walk_cost"] = 1,
            ["walkable"] = true
          }
        },
        {
          id = 125,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 126,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        },
        {
          id = 127,
          type = "Mountains",
          properties = {
            ["walk_cost"] = 2,
            ["walkable"] = true
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 19,
      name = "background",
      x = 0,
      y = 0,
      width = 16,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
      }
    },
    {
      type = "tilelayer",
      id = 21,
      name = "terrains",
      x = 0,
      y = 0,
      width = 16,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 5, 5, 8, 5, 5, 5, 8, 8, 5, 5, 0, 0, 0, 0,
        0, 5, 7, 84, 5, 8, 81, 66, 83, 6, 8, 84, 8, 8, 0, 0,
        0, 53, 5, 100, 8, 81, 115, 22, 113, 82, 66, 115, 5, 8, 5, 0,
        0, 5, 8, 100, 5, 100, 8, 54, 5, 100, 5, 5, 5, 5, 5, 0,
        0, 65, 66, 99, 6, 123, 87, 5, 8, 97, 66, 83, 5, 6, 5, 0,
        0, 6, 8, 123, 120, 91, 124, 86, 120, 115, 8, 100, 53, 5, 8, 0,
        0, 0, 8, 117, 119, 5, 117, 111, 119, 5, 6, 100, 8, 5, 8, 0,
        0, 0, 0, 8, 8, 5, 7, 100, 5, 5, 5, 97, 66, 67, 8, 0,
        0, 0, 0, 0, 126, 127, 128, 100, 5, 5, 5, 100, 5, 5, 5, 0,
        0, 0, 0, 8, 53, 5, 8, 97, 66, 82, 66, 115, 8, 5, 0, 5,
        0, 0, 0, 5, 7, 65, 66, 114, 66, 115, 6, 8, 5, 5, 0, 5,
        0, 0, 0, 0, 0, 0, 8, 8, 5, 8, 0, 8, 5, 5, 0, 5,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 26,
      name = "specials",
      x = 0,
      y = 0,
      width = 16,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 57, 0, 0, 57, 57, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 57, 0, 57, 57, 0, 0, 0, 57, 57, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 57, 57, 0, 0,
        0, 0, 0, 0, 0, 0, 57, 0, 0, 0, 0, 0, 57, 57, 57, 0,
        0, 0, 0, 0, 57, 0, 0, 57, 57, 0, 0, 0, 57, 57, 57, 0,
        0, 57, 57, 0, 0, 0, 0, 23, 0, 0, 57, 0, 0, 57, 0, 0,
        0, 0, 0, 0, 0, 57, 0, 0, 0, 57, 57, 0, 57, 57, 0, 0,
        0, 0, 0, 0, 57, 57, 57, 0, 57, 57, 57, 0, 0, 0, 57, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 57, 57, 0, 57, 57, 57, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 57, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 57, 57, 57, 57, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 57, 57, 0, 0, 0, 57, 57, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 11,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 277,
          y = 234,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 75,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 73,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 304,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 74,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 362,
          y = 159,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 343,
          y = 139,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 345,
          y = 132,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 365,
          y = 153,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 295,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 63,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 367,
          y = 267,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 63,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 75,
          y = 158,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 60,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 58,
          y = 142,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 64,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 55,
          y = 152,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 62,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 66,
          y = 148,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 75,
          y = 136,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 75,
          y = 144,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 63,
          visible = true,
          properties = {}
        },
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 261,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 249,
          y = 152,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 36,
          name = "",
          type = "",
          shape = "rectangle",
          x = 250,
          y = 135,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 37,
          name = "",
          type = "",
          shape = "rectangle",
          x = 316,
          y = 161,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 38,
          name = "",
          type = "",
          shape = "rectangle",
          x = 334,
          y = 144,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 39,
          name = "",
          type = "",
          shape = "rectangle",
          x = 274,
          y = 108,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 46,
          name = "",
          type = "",
          shape = "rectangle",
          x = 367,
          y = 298,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 47,
          name = "",
          type = "",
          shape = "rectangle",
          x = 115,
          y = 158,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 48,
          name = "",
          type = "",
          shape = "rectangle",
          x = 119,
          y = 142,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 49,
          name = "",
          type = "",
          shape = "rectangle",
          x = 114,
          y = 130,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 50,
          name = "",
          type = "",
          shape = "rectangle",
          x = 21,
          y = 161,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 75,
          visible = true,
          properties = {}
        },
        {
          id = 51,
          name = "",
          type = "",
          shape = "rectangle",
          x = 45,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 76,
          visible = true,
          properties = {}
        },
        {
          id = 52,
          name = "",
          type = "",
          shape = "rectangle",
          x = 21,
          y = 137,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 62,
          visible = true,
          properties = {}
        },
        {
          id = 59,
          name = "",
          type = "",
          shape = "rectangle",
          x = 245,
          y = 299,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 60,
          name = "",
          type = "",
          shape = "rectangle",
          x = 268,
          y = 293,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 61,
          name = "",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 312,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 62,
          name = "",
          type = "",
          shape = "rectangle",
          x = 263,
          y = 319,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 246,
          y = 313,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "",
          type = "",
          shape = "rectangle",
          x = 253,
          y = 294,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 59,
          visible = true,
          properties = {}
        },
        {
          id = 65,
          name = "",
          type = "",
          shape = "rectangle",
          x = 44,
          y = 137,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 60,
          visible = true,
          properties = {}
        },
        {
          id = 66,
          name = "",
          type = "",
          shape = "rectangle",
          x = 33,
          y = 151,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 93,
          name = "",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 212,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 39,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      id = 24,
      name = "bounds",
      x = 0,
      y = 0,
      width = 16,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        26, 26, 12, 42, 13, 12, 42, 42, 13, 12, 42, 13, 26, 26, 26, 26,
        26, 12, 43, 0, 41, 43, 0, 0, 41, 43, 0, 41, 42, 13, 26, 26,
        12, 43, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 41, 42, 13,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 29,
        28, 10, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 41, 13,
        26, 26, 28, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        26, 26, 26, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        26, 26, 12, 43, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 29,
        26, 26, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 26,
        26, 26, 28, 10, 10, 10, 11, 0, 0, 9, 10, 11, 0, 0, 25, 26,
        26, 26, 26, 26, 26, 26, 28, 10, 10, 29, 26, 28, 10, 10, 29, 26
      }
    }
  }
}
