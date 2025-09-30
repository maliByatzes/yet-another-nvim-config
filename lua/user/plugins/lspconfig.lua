local on_attach = function(client, bufnr)
  print(client.name .. ' attached to buffer ' .. bufnr)

  local keymap = function(mode, keys, func, opts)
    opts.buffer = bufnr
    vim.keymap.set(mode, keys, func, opts)
  end

  keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
  keymap('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
  keymap('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
  keymap('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
  keymap('n', 'gr', vim.lsp.buf.references, { desc = 'List references' })

  keymap('n', '<leader>ds', vim.lsp.buf.document_symbol, { desc = 'List document symbols' })
  keymap('n', '<leader>ws', vim.lsp.buf.workspace_symbol, { desc = 'List workspace symbols' })

  keymap('n', 'K', vim.lsp.buf.hover, { desc = 'Show documentation' })
  keymap('n', 'gK', vim.lsp.buf.signature_help, { desc = 'Show signature' })
  keymap('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Show signature' })

  keymap('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
  keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })

  keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder' })
  keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace folder' })
  keymap(
    'n',
    '<leader>wl',
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    { desc = 'List workspace folders' }
  )
end

return {
  'neovim/nvim-lspconfig',
  ft = { 'lua', 'c', 'cpp' },
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    -- Wrapper for on_attach with error handling
    local on_attach_wrapper = function(client, bufnr)
      local _, err = pcall(on_attach, client, bufnr)
      if err then
        vim.notify('[on_attach] error: ' .. err, vim.log.levels.ERROR)
      else
        vim.notify('[on_attach] ' .. client.name .. ' attached to buffer ' .. bufnr, vim.log.levels.INFO)
      end
    end

    -- Configure lua_ls
    vim.lsp.config('lua_ls', {
      on_attach = on_attach_wrapper,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    -- Configure ccls
    vim.lsp.config('ccls', {
      on_attach = on_attach_wrapper,
      settings = {
        ccls = {
          compilationDatabaseDirectory = 'build',
          index = {
            threads = 0,
          },
          clang = {
            excludeArgs = { '-frounding-math' },
          },
        },
      },
    })

    -- Enable the LSP servers
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ccls')
  end
}
