return { 
	"EdenEast/nightfox.nvim",
	lazy = false,	-- Prevent lazy loading. Should always be loaded
	priority = 999,	-- Be loaded before everything else
	config = function()
		vim.cmd("colorscheme nightfox")
	end
}
