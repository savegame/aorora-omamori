return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 19,
  height = 16,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 12,
  nextobjectid = 48,
  properties = {},
  tilesets = {
    {
      name = "hide_tileset",
      firstgid = 1,
      filename = "hide_tileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../images/hide_battlefield_tileset.png",
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
          tile = 8,
          properties = {}
        }
      },
      tilecount = 128,
      tiles = {
        {
          id = 0,
          type = "Path"
        },
        {
          id = 4,
          type = "Grass"
        },
        {
          id = 5,
          type = "Grass"
        },
        {
          id = 6,
          type = "Grass"
        },
        {
          id = 7,
          type = "Grass"
        },
        {
          id = 8,
          terrain = { -1, -1, -1, 0 }
        },
        {
          id = 9,
          terrain = { -1, -1, 0, 0 }
        },
        {
          id = 10,
          terrain = { -1, -1, 0, -1 }
        },
        {
          id = 11,
          terrain = { 0, 0, 0, -1 }
        },
        {
          id = 12,
          terrain = { 0, 0, -1, 0 }
        },
        {
          id = 21,
          type = "Mountains"
        },
        {
          id = 22,
          type = "Lantern"
        },
        {
          id = 23,
          type = "Mountains"
        },
        {
          id = 24,
          terrain = { -1, 0, -1, 0 }
        },
        {
          id = 25,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 26,
          terrain = { 0, -1, 0, -1 }
        },
        {
          id = 27,
          terrain = { 0, -1, 0, 0 }
        },
        {
          id = 28,
          terrain = { -1, 0, 0, 0 }
        },
        {
          id = 37,
          type = "Mountains"
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
          type = "Mountains"
        },
        {
          id = 40,
          terrain = { -1, 0, -1, -1 }
        },
        {
          id = 41,
          terrain = { 0, 0, -1, -1 }
        },
        {
          id = 42,
          terrain = { 0, -1, -1, -1 }
        },
        {
          id = 52,
          type = "Mountains"
        },
        {
          id = 53,
          type = "Mountains"
        },
        {
          id = 55,
          type = "Mountains"
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
          id = 68,
          type = "Mountains"
        },
        {
          id = 69,
          type = "Mountains"
        },
        {
          id = 70,
          type = "Mountains"
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
          type = "Mountains"
        },
        {
          id = 77,
          type = "Mountains"
        },
        {
          id = 78,
          type = "Mountains"
        },
        {
          id = 125,
          type = "Mountains"
        },
        {
          id = 126,
          type = "Mountains"
        },
        {
          id = 127,
          type = "Mountains"
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 7,
      name = "background",
      x = 0,
      y = 0,
      width = 19,
      height = 16,
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    },
    {
      type = "tilelayer",
      id = 8,
      name = "terrains",
      x = 0,
      y = 0,
      width = 19,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAAAAAAABAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    },
    {
      type = "tilelayer",
      id = 9,
      name = "tallGrass",
      x = 0,
      y = 0,
      width = 19,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "BQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAUAAAAFAAAABQAAAAcAAAAFAAAABQAAAAUAAAAFAAAABgAAAAgAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAIAAAABQAAAAUAAAAFAAAAUQAAAEIAAABCAAAAQgAAAEIAAABTAAAACAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAAQQAAAFMAAAAHAAAABQAAAGQAAAAIAAAABQAAAAYAAAAFAAAAcQAAAFIAAABCAAAAQwAAAAUAAAAFAAAABQAAAAUAAAAFAAAACAAAAAUAAABkAAAABQAAAAUAAABkAAAABQAAAAUAAAAIAAAABQAAAAUAAABkAAAABQAAAAUAAAAGAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAAZAAAAAUAAAAIAAAAcQAAAEIAAABTAAAABQAAAAYAAAAFAAAAZAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAGAAAABQAAAGQAAAAFAAAABgAAAAUAAAAFAAAAewAAAFYAAAB4AAAAQgAAAHIAAABCAAAAQgAAAFMAAAAFAAAABQAAAAUAAAAFAAAABQAAAEEAAABtAAAAVgAAAHgAAABCAAAAQgAAAG4AAAAAAAAAZwAAAAgAAAAFAAAABQAAAAcAAABkAAAACAAAAAUAAAAFAAAABQAAAAUAAAAFAAAAdQAAAHYAAABqAAAABQAAAAUAAAB1AAAAbwAAAHcAAAAFAAAABgAAAAUAAAAFAAAAZAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAYAAAAFAAAAZAAAAAgAAAAFAAAABwAAAGQAAAAIAAAABQAAAAUAAAAIAAAABQAAAGQAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAHQAAAAFAAAABQAAAAUAAABkAAAABQAAAAUAAAAFAAAAVQAAAHgAAABzAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAUAAABRAAAAcgAAAEIAAABSAAAAQgAAAFsAAAB3AAAABQAAAAYAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAgAAABBAAAAcwAAAAUAAAAFAAAAdAAAAAgAAAAFAAAABQAAAAgAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAACAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAgAAAAFAAAABQAAAAYAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAA=="
    },
    {
      type = "tilelayer",
      id = 10,
      name = "specials",
      x = 0,
      y = 0,
      width = 19,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAOQAAAAAAAAAAAAAAOQAAADkAAAA5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAAAAAAAAAAAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAAAAAAAAAAAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAADkAAAA5AAAAAAAAAAAAAAA5AAAAOQAAAAAAAAA5AAAAOQAAADkAAAA5AAAAAAAAAAAAAAAAAAAAAAAAADkAAAA5AAAAOQAAAAAAAAA5AAAAOQAAADkAAAAAAAAAOQAAADkAAAAAAAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAAAAAADkAAAA5AAAAAAAAAAAAAAAAAAAAOQAAADkAAAA5AAAAAAAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAAAAAAAA5AAAAOQAAADkAAAA5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5AAAAOQAAADkAAAA5AAAAOQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADkAAAA5AAAAOQAAADkAAAAAAAAAOQAAADkAAAA5AAAAAAAAADkAAAA5AAAAAAAAAAAAAAAAAAAAOQAAADkAAAAAAAAAAAAAAAAAAAA5AAAAOQAAADkAAAA5AAAAAAAAADkAAAA5AAAAAAAAAAAAAAA5AAAAOQAAADkAAAA5AAAAAAAAADkAAAA5AAAAOQAAAAAAAAA5AAAAOQAAADkAAAA5AAAAOQAAAAAAAAA5AAAAOQAAAAAAAAAAAAAAOQAAADkAAAA5AAAAOQAAAAAAAAA5AAAAOQAAADkAAAAAAAAAOQAAADkAAAA5AAAAAAAAAAAAAAAAAAAAOQAAADkAAAA5AAAAAAAAAAAAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOQAAADkAAAA5AAAAOQAAAAAAAAAAAAAAAAAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAADkAAAA5AAAAAAAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAAAAAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAADkAAAA5AAAAOQAAADkAAAA5AAAAOQAAADkAAAAAAAAAAAAAAA=="
    },
    {
      type = "objectgroup",
      id = 5,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 276,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 39,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 368,
          y = 192,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 73,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 192,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 74,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 483,
          y = 296,
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
          x = 479,
          y = 283,
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
          x = 482,
          y = 272,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 105,
          y = 312,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 63,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 97,
          y = 293,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 63,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 434,
          y = 409,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 63,
          visible = true,
          properties = {}
        },
        {
          id = 37,
          name = "",
          type = "",
          shape = "rectangle",
          x = 99,
          y = 221,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 38,
          name = "",
          type = "",
          shape = "rectangle",
          x = 95,
          y = 208,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        },
        {
          id = 39,
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 195,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 61,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      id = 11,
      name = "bounds",
      x = 0,
      y = 0,
      width = 19,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "GgAAABoAAAAMAAAAKgAAAA0AAAAMAAAAKgAAACoAAAAqAAAADQAAABoAAAAaAAAAGgAAABoAAAAaAAAAGgAAABoAAAAaAAAAGgAAABoAAAAMAAAAKwAAAAAAAAApAAAAKwAAAAAAAAAAAAAAAAAAACkAAAAqAAAAKgAAACoAAAAqAAAAKgAAACoAAAANAAAAGgAAABoAAAAMAAAAKwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGQAAABoAAAAaAAAAGwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACkAAAAaAAAAGgAAABsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQAAAA0AAAAbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAAGwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGQAAABsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkAAAAbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAAHAAAAAsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJAAAAHQAAABoAAAAbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQAAAA0AAAAaAAAAGwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAAGgAAABwAAAALAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGQAAABoAAAAaAAAAHAAAAAsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkAAAAaAAAAGgAAABoAAAAbAAAAAAAAAAAAAAAAAAAAAAAAAAkAAAALAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkAAAAdAAAAGgAAABoAAAAaAAAAHAAAAAoAAAAKAAAACgAAAAoAAAAdAAAAHAAAAAoAAAAKAAAACgAAAAoAAAAKAAAACgAAAAoAAAAdAAAAGgAAAA=="
    }
  }
}
