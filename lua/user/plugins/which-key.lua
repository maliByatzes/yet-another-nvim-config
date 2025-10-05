return {
  'folke/which-key.nvim',
  event = "VeryLazy",
  dependencies = {
    { 'nvim-mini/mini.nvim',         version = false },
    { "nvim-tree/nvim-web-devicons", opts = {} },
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add(
      {
        { "<leader><tab>",  group = "tabs" },
        { "<leader>t",      group = "tabs" },
        { "<leader>b",      group = "buffer/BufferLine" },
        { "<leader>c",      group = "code" },
        { "<leader>d",      group = "debugger" },
        { "<leader>f",      group = "file/find" },
        { "<leader>g",      group = "git" },
        { "<leader>gh",     group = "hunks" },
        { "<leader>h",      group = "gitsigns/hop" },
        { "<leader>s",      group = "search" },
        { "<leader>u",      group = "ui/toggle" },
        { "<leader>r",      group = "refactor" },
        { "<leader>w",      group = "windows" },
        { "<leader>x",      group = "diagnostics" },
        { "<localleader>u", group = "toggle" },
        { "[",              group = "prev" },
        { "]",              group = "next" },
        { "g",              group = "goto" },
        { "gz",             group = "surround" },
      })
  end,
}
