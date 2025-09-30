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
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>r", group = "refactor" },
        { "<leader>w", group = "workspace" },
        { "[",         group = "prev" },
        { "]",         group = "next" },
        { "g",         group = "goto" },
      })
  end,
}
