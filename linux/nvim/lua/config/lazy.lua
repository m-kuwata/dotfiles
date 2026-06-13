-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- LazyVim
require("lazy").setup({
	spec = {
		-- LazyVim core and its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- Local plugin specs (lua/plugins/*.lua)
		{ import = "plugins" },
	},
	defaults = {
		version = false,
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	-- Automatically check for plugin updates (without intrusive notifications)
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			-- Disable some built-in rtp plugins to speed up startup
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
