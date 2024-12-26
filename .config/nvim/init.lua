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
		config = function()
			-- https://dev.classmethod.jp/articles/eetann-noice-nvim-beginner/
			local noice = require("noice")

			local function myMiniView(pattern, kind)
				kind = kind or ""
				return {
					view = "mini",
					filter = {
						event = "msg_show",
						kind = kind,
						find = pattern,
					},
				}
			end

			require("notify").setup({
				background_colour = "#000000",
			})

			noice.setup({
				messages = {
					view_search = "mini",
				},
				routes = {
					{
						view = "notify",
						filter = { event = "msg_showmode" },
					},
					{
						filter = {
							event = "notify",
							warning = true,
							find = "failed to run generator.*is not executable",
						},
						opts = { skip = true },
					},
					myMiniView("Already at .* change"),
					myMiniView("written"),
					myMiniView("yanked"),
					myMiniView("more lines?"),
					myMiniView("fewer lines?"),
					myMiniView("fewer lines?", "lua_error"),
					myMiniView("change; before"),
					myMiniView("change; after"),
					myMiniView("line less"),
					myMiniView("lines indented"),
					myMiniView("No lines in buffer"),
					myMiniView("search hit .*, continuing at", "wmsg"),
					myMiniView("E486: Pattern not found", "emsg"),
				},
			})
		end,
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
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { silent = true })
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
						["<C-t>"] = function(state)
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

			vim.keymap.set("n", "<C-t>", function()
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
				shade_filezypes = {},
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
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
				git_cmd = { "git", "--no-pager", "-c", "diff.context=999" },
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
			})

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- キーマッピング
			vim.keymap.set("n", "<leader>ba", function()
				harpoon:list():add()
			end, { silent = false, desc = "Harpoon append" })

			vim.keymap.set("n", "<leader>be", function()
				toggle_telescope(harpoon:list())
			end, { silent = false, desc = "Harpoon quick menu" })

			vim.keymap.set("n", "<leader>bs", function()
				harpoon:list():select(1)
			end, { silent = false, desc = "Harpoon select 1" })

			vim.keymap.set("n", "<leader>bd", function()
				harpoon:list():select(2)
			end, { silent = false, desc = "Harpoon select 2" })

			vim.keymap.set("n", "<leader>bf", function()
				harpoon:list():select(3)
			end, { silent = false, desc = "Harpoon select 3" })

			vim.keymap.set("n", "<leader>bg", function()
				harpoon:list():select(4)
			end, { silent = false, desc = "Harpoon select 4" })

			vim.keymap.set("n", "<leader>bp", function()
				harpoon:list():prev()
			end, { silent = false, desc = "Harpoon prev" })

			vim.keymap.set("n", "<leader>bn", function()
				harpoon:list():next()
			end, { silent = false, desc = "Harpoon next" })
		end,
	},
})

-- keybinds
vim.keymap.set("n", "<D-/>", "<NOP>")
vim.keymap.set("n", "<D-s>", "<NOP>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true })
-- git
vim.keymap.set("n", "<leader>g", "<cmd>DiffviewOpen<CR>", silent)

-- クリップボードの設定
vim.opt.clipboard:append("unnamed")

-- 背景を透明に設定
vim.opt.termguicolors = true
vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NormalNC guibg=none")

-- 端末の設定
vim.opt.termguicolors = true
