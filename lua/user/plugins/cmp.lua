return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp',     lazy = true },
    { 'hrsh7th/cmp-buffer',       lazy = true },
    { 'hrsh7th/cmp-nvim-lua',     lazy = true },
    { 'hrsh7th/cmp-cmdline',      lazy = true },
    { 'hrsh7th/cmp-path',         lazy = true },
    { 'hrsh7th/cmp-emoji',        lazy = true },
    { 'saadparwaiz1/cmp_luasnip', lazy = true },
  },
  opts = function()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
          and vim.api
          .nvim_buf_get_lines(0, line - 1, line, true)[1]
          :sub(col, col)
          :match("%s")
          == nil
    end

    local cmp = require('cmp')
    local luasnip = require('luasnip')

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        format = function(entry, vim_item)
          local icons = require('user.defaults').icons.kinds
          -- Kind icons
          -- This concantenates the icons with name of item kind
          vim_item.kind = string.format(
            "%s",
            icons[vim_item.kind],
            vim_item.kind
          )
          -- Source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            path = "[Path]",
            emoji = "[Emoji]",
            neorg = "[Neorg]",
            spell = "[Spell]",
          })[entry.source.name]
          return vim_item
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({
          TriggerOnly = "triggerOnly",
        }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "nvim_lua" },
        { name = "emoji" },
        { name = "neorg" },
      }, {
        { name = 'buffer' },
      }, {
        { name = 'path' },
      }),
    }
  end,

  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts)

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "path" },
        { name = "cmdline" },
      },
    })
  end,
}
