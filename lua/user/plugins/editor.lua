return {
  -- mini pairs
  {
    'echasnovski/mini.pairs',
    event = 'InsertEnter',
    config = true,
  },

  -- flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    lazy = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- luadev
  {
    "folke/lazydev.nvim",
    event = "VeryLazy",
    ft = "lua",
    config = true,
  },

  -- comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require('Comment').setup(opts)
    end
  },
  -- library used by other plugins
  { "nvim-lua/plenary.nvim",       lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- Glyphs and Icons for neovim

  -- todo comments
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    cmd = { "TodoTelescope", "TodoLocList" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>tt", "<cmd>TodoTelescope<cr>",                            desc = "List Todo in Telescope" },
      { "<leader>tl", "<cmd>TodoLocList<cr>",                              desc = "List Todo in LocList" },
    },
  }
}
