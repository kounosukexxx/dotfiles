-- enable lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

vim.g.mapleader = " "

-- enable plugins
require("lazy").setup({
	{

		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = { "echo", "echomsg" },
						find = "written",
					},
					opts = { skip = true },
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"907th/vim-auto-save",
		event = "VeryLazy",
		config = function()
			vim.g.auto_save = 1
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "auto",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			-- Ctrl + b でトグル
			vim.keymap.set("n", "<leader>b", ":Neotree toggle<CR>", { silent = true })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			vim.keymap.set("n", "<leader>p", ":Telescope find_files<CR>", { silent = true })
			vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>", { silent = true })
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
		config = function()
			vim.keymap.set("n", "<C-/>", "gcc", { remap = true })
			vim.keymap.set("v", "<C-/>", "gc", { remap = true })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						["<leader>b"] = function(state)
							vim.cmd("Neotree close")
						end,
					},
				},
			})

			-- 起動時にneo-treeを開く（configの中で行う）
			vim.defer_fn(function()
				vim.cmd("Neotree toggle")
				vim.cmd.wincmd("l")
			end, 0)

			vim.keymap.set("n", "<leader>b", function()
				vim.cmd("Neotree toggle")
			end, { silent = true })
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 100,
				open_mapping = "<leader>t",
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
			})
		end,
	},
})

-- keybinds
vim.keymap.set("n", "<D-/>", "<NOP>")
vim.keymap.set("n", "<D-s>", "<NOP>")
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", { silent = true })
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>", { silent = true })
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", { silent = true })

-- クリップボードの設定
vim.opt.clipboard:append("unnamed")

-- 背景を透明に設定
vim.opt.termguicolors = true
vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NormalNC guibg=none")

-- 端末の設定
vim.opt.termguicolors = true
