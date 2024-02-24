local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat("lazystat") then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Include global configurations
require("config.globals")
require("config.options")
require("config.keymaps")
require("config.autocmds")

local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = { "nightfox" }
	},
	rtp = {
		disabled_plugins = {
			"gzip",
			"matchit",
			"matchparen",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin"
		}
	},
	change_detection = {
		notify = true
	}
}

-- Make lazy look for all plugins in the "plugins" directory
require("lazy").setup("plugins", opts)
