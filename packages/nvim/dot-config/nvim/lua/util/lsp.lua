local M = {}

-- enable keybinds only when lsp server is available
M.on_attach = function(client, bufnr)
	--keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	----------------
	-- set keybinds
	----------------
	vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>", opts) -- got to declaration
	vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	vim.keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	vim.keymap.set("n", "<leader>pd", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to prev diagnostic in buffer
	vim.keymap.set("n", "<leader>nd", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	vim.keymap.set("n", "<leader>lo", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	if client.name == "solidity" then
		vim.keymap.set("n", "<leader>gD", "Lspsaga goto_definition <CR>") -- go to definition
	end

	if client.name == "pyright" then
		vim.keymap.set("n", "<leader>oi", "<cmd>PyrightOrganizeImports<CR>", opts)
	end
end

return M
