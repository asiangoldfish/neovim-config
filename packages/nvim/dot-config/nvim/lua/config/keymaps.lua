local keymap = vim.keymap

local opts = { remap = true, silent = true }

-- Directory navigation
-- km.set("n", "<leader>m", ":NvimTreeFocus<CR>", opts)
keymap.set("n", "<leader>m", ":NvimTreeToggle<CR>", opts)

-- Save document
keymap.set("n", "<C-s>", ":update<CR>", opts)
keymap.set("i", "<C-s>", "<ESC>:update<CR>a", opts)

-- Navigating panes and windows
keymap.set("n", "<C-left>", "<C-w>h", opts) -- Navigate left
keymap.set("n", "<C-down>", "<C-w>j", opts) -- Navigate down
keymap.set("n", "<C-up>", "<C-w>k", opts) -- Navigate up
keymap.set("n", "<C-right>", "<C-w>l", opts) -- Navigate right
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- Split vertically
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- Split horizontally
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- Toggle minimize

keymap.set("t", "<C-left>", [[<Cmd>wincmd h<CR>]], opts) -- Navigate left
keymap.set("t", "<C-down>", [[<Cmd>wincmd j<CR>]], opts) -- Navigate down
keymap.set("t", "<C-up>", [[<Cmd>wincmd k<CR>]], opts) -- Navigate up
keymap.set("t", "<C-right>", [[<Cmd>wincmd l<CR>]], opts) -- Navigate right

keymap.set("t", "<C-left>", ":TmuxNavigateLeft<CR>", opts) -- Navigate left
keymap.set("t", "<C-down>", ":TmuxNavigateDown<CR>", opts) -- Navigate down
keymap.set("t", "<C-up>", ":TmuxNavigateUp<CR>", opts) -- Navigate up
keymap.set("t", "<C-right>", ":TmuxNavigateRight<CR>", opts) -- Navigate right

-- Indentation
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Comments
vim.api.nvim_set_keymap("n", "<C-k>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<C-k>", "gcc", { noremap = false })

-- Terminal
-- Map <Esc> in terminal mode to go back to Normal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

