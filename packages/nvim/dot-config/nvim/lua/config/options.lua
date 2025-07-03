-- High level NeoVim configurations

local opt = vim.opt -- Macro

-- Spaces
-- Define highlight group ExtraWhitespace with red background
vim.cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
-- Match trailing whitespaces on BufWinEnter
vim.cmd("au BufWinEnter * match ExtraWhitespace /\\s\\+$/")
-- Match trailing whitespaces on InsertEnter, excluding the cursor position
vim.cmd("au InsertEnter * match ExtraWhitespace /\\s\\+\\%\\#\\@<!$/")
-- Clear matches on InsertLeave
vim.cmd("au InsertLeave * match ExtraWhitespace /\\s\\+$/")
-- Clear matches on BufWinLeave
vim.cmd("au BufWinLeave * call clearmatches()")

-- Tab/Indentation
opt.tabstop = 4 -- How many spaces does tab character occupy
opt.shiftwidth = 4 -- Set spaces for each indentation level
opt.softtabstop = 4 -- How many spaces is tab in Insert mode
opt.expandtab = true -- Convert tabs to spaces
opt.smartindent = true -- Allows auto indentation
opt.wrap = wrap -- Soft wrap (:set wrap to manually soft wrap)

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Appearance
opt.relativenumber = true
opt.number = true
opt.termguicolors = true
opt.colorcolumn = "80"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour
opt.showmode = true
opt.hidden = true -- Change buffers without saving
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false -- Automatically change the directory we're in
opt.iskeyword:append("-")
opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
opt.modifiable = true
opt.guicursor =
	"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blonkoff150-blinkon175"
opt.encoding = "UTF-8"
