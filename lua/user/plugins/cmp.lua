return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
  },
  opts = function()
    local cmp = require('cmp')

    return {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert(),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }, {
        { name = 'path' },
      })
    }
  end,
}

-- Keymaps for completions
-- Previous item: <C-p>
-- Next item: <C-n>
-- Confirm selection: <C-y>
-- Abort completion: <C-e>
