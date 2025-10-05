local utils = require("user.utils")
local map = utils.map

local opt = { remap = true }

-- quickfix items
map("n", "[q", vim.cmd.prev, { desc = "Previous quickfix item" })
map("n", "]q", vim.cmd.next, { desc = "Next quickfix item" })

-- search selected item in visual mode
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opt)

map("n", "<leader>p", [[m`0"_DP``]], opt, "keep pasting overwriting text")
map("v", "<leader>p", [[m`"_dP``]], opt, "keep pasting over the same thing")

-- delete content w/o messing up with registers
map({ "n", "v" }, "<leader>D", [["_d]], { remap = false }, "delete content without messing up registers")

-- switch CWD to the directory of open buffer
map({ "n", "v", "o" }, "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>", opt, "switch to cwd")

---** Moving around, tabs, windows and buffers **---
-- to use `ALT+{h,j,k,l}` to navigate windows from any mode
map({ "t", "i" }, "<C-h>", [[<C-\><C-N><C-w>h]])
map({ "t", "i" }, "<C-j>", [[<C-\><C-N><C-w>j]])
map({ "t", "i" }, "<C-k>", [[<C-\><C-N><C-w>k]])
map({ "t", "i" }, "<C-l>", [[<C-\><C-N><C-w>l]])

-- move to window using the <ctrl> hkjl keys
map("n", "<C-h>", "<C-w>h", { desc = "Switch to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch to right window" })

local mode = { "n", "v", "o" }

-- buffers
if utils.has("bufferline.nvim") then
  map("n", "<A-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<A-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<A-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Switch to previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", opt, "Delete current buffer")
map("n", "<leader>bo", "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>", opt, "Close all buffers except current")
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New file" })

-- useful mappings for managing tabs
map(mode, "<leader>t1", "<cmd>tabfirst<cr>", opt, "goto first tab")
map(mode, "<leader>t9", "<cmd>tablast<cr>", opt, "goto last tab")
map(mode, "<leader>td", "<cmd>tabclose<cr>", opt, "close tab")
map(mode, "<leader>tn", "<cmd>tabnew<cr>", opt, "new tab")
map(mode, "<leader>to", "<cmd>tabonly<cr>", opt, "close all tabs except current")

map("n", "<leader>tm", "<cmd>tabmove<cr>", opt, "move tab")
map("n", "<leader>]t", "<cmd>tabnext<cr>", opt, "goto next tab")
map("n", "<leader>[t", "<cmd>tabprevious<cr>", opt, "goto previous tab")

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increse window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>=", "<C-W>=", { desc = "Resize and make windows equal" })

-- move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", function()
  vim.cmd([[w]])
end, { desc = "Save file" })

-- quit
map("n", "<C-q>", function()
  vim.cmd([[qall]])
end, { desc = "Quit all" })

---** Terminal **---
-- mapping to open terminal emulator in nvim
-- open terminal on alt+t
map({ "n", "t" }, "<M-t>", function()
  vim.cmd.split({ "term://" .. vim.env.SHELL })
  vim.cmd.resize({ 15 })
end)
-- mapping to close terminal emulator
map("t", "<M-t>", [[<C-\><C-n>:bd!<CR>]])

-- better up/down
vim.keymap.set('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
vim.keymap.set('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })

-- clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- toggle options
---** Spell checking **--
-- vim.cmd [[set spell!]] also works
map("n", "<leader>us", function()
  utils.toggle("spell")
end, { desc = "Toggle spelling" })

map("n", "<leader>uw", function()
  utils.toggle("wrap")
end, { desc = "Toggle word wrap" })

map("n", "<leader>ul", function()
  utils.toggle("relativenumber")
  utils.toggle("number")
end, { desc = "Toggle line numbers" })

map("n", "<leader>uc", function()
  local disable_conceal = 0
  local enable_conceal = 3
  local conceallevel = vim.o.conceallevel > 0 and disable_conceal or enable_conceal

  local filetype = vim.filetype.match({ buf = 0 })
  if filetype == "norg" and utils.has("neorg") then
    utils.toggle("conceallevel", nil, { 0, conceallevel })
  end
end, { desc = "Toggle conceal" })

map("n", "<leader>ue", function()
  utils.toggle("listchars", nil, {
    { tab = [[→→]], trail = "•", extends = "»", precedes = "«" },
    {
      tab = [[→→]],
      trail = "•",
      extends = "»",
      precedes = "«",
      eol = "↴",
    },
  })
end, { desc = "Toggle EOL" })

-- Diagnostics
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to prev diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', 'gl', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostic quickfix list' })

-- Cursor positions keymaps
map('n', 'J', 'mzJ`z')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'G', 'Gzz')

-- Paste from system clipboard
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = "Paste from clipboard" })
map('n', '<leader>Y', [["+Y]], { desc = "Paste from clipboard" })

-- Disable accidental triggers
map('n', 'Q', '<nop>')
map('n', 'q:', '<nop>')

-- Beautiful instant search and replace command
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Instant search and replace" })

-- Quickly reloads/source the current file
map('n', '<leader><leader>', function()
  vim.cmd('so')
end, { desc = "Reload/source current file" })

-- Duplicate and comment line
map('n', 'yc', 'yy<cmd>normal gcc<CR>p', { desc = "Duplicate and comment line" })

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

map('v', 'yc', duplicate_and_comment, { desc = "Duplicate and comment line (visual)" })

-- TODO: Add some fun animations here i.e. make_it_rain, game_of_life, scramble
