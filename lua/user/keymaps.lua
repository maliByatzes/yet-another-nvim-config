-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
vim.keymap.set('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })

-- Move window using the <C-hjkl> keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Switch to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Swicth to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Switch to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Switch to right window' })

-- Quickfix list
vim.keymap.set('n', '[q', vim.cmd.prev, { desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', vim.cmd.next, { desc = 'Next quickfix item' })

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to prev diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostic quickfix list' })

-- Exit keymap
vim.keymap.set('n', '<leader>x', vim.cmd.Ex)

-- Move selected lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Cursor positions keymaps
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'G', 'Gzz')

-- Keep pasted text on the clipboard
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Paste from system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- Delete text w/o affecting the clipboard
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]])

-- Disable accidental triggers
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', 'q:', '<nop>')

-- Format file
-- vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- Beautiful instant search and replace command
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- TODO: Add some fun animations here i.e. make_it_rain, game_of_life, scramble

-- Quickly reloads/source the current file
vim.keymap.set('n', '<leader><leader>', function ()
  vim.cmd('so')
end)

-- Duplicate and comment line
vim.keymap.set('n', 'yc', 'yy<cmd>normal gcc<CR>p')

local function duplicate_and_comment()
  -- Exit visual mode
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)

  -- Get selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Yank and paste below
  vim.cmd(start_line .. ',' .. end_line .. 'yank')
  vim.cmd((end_line + 1) .. 'put')

  -- Reselect pasted block
  vim.api.nvim_feedkeys('gv', 'n', false)

  -- Comment the original selection
  vim.api.nvim_feedkeys('gc', 'v', false)
end

vim.keymap.set('v', 'yc', duplicate_and_comment)

