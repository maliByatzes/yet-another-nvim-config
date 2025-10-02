-- Space as <Leader>.
vim.g.mapleader = ' '
-- \ as <LocalLeader>.
vim.g.maplocalleader = '\\'

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Disable startup message.
vim.opt.shortmess:append { s = true, I = true }

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.smartindent = true

vim.opt.writebackup = true
vim.opt.swapfile = true
vim.opt.backup = true
vim.opt_global.backupdir = { "/tmp//" }
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 30000

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.cmd.colorscheme("user")

vim.opt.scrolloff = 999
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.cursorline = true
vim.opt.hidden = false

vim.opt.wrap = true
vim.opt.showbreak = [[↪ ]]
