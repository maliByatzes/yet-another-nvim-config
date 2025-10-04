require('user.options')

local utils = require('user.utils')

-- Load editor syntax, autocmds and keymaps
utils.lazy_load({ 'user.syntax', 'user.autocmds', 'user.keymaps' })

local diagnostics_options = require("user.defaults").diagnostics_options
-- configure floating window
vim.diagnostic.config(diagnostics_options)

-- setup borders for handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = diagnostics_options.float.border,
})
--
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = diagnostics_options.float.border,
    })

-- configure diagnostics signs
for name, icon in pairs(require("user.defaults").icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

-- configure debugger diagnostics signs
for name, icon in pairs(require("user.defaults").icons.debugger) do
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  'user.plugins',
  {
    change_detection = { enabled = false }
  }
)
