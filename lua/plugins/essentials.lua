-- essentials.lua
-- Core plugin list and basic configurations for Neovim.
-- This file returns a table of plugin specifications consumed by the plugin manager (e.g., lazy.nvim).
-- Keep plugin setups minimal here; more complex configs should be placed in separate modules.
return {
	-- Theme plugin: Tokyo Night (provides color scheme)
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Set the global colorscheme to 'tokyonight-night'
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	-- File explorer: Neo-tree (file tree with optional filters and icons)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			-- Do not hide dotfiles or gitignored files by default
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
			})
		end,
	},

	-- Fuzzy search native sorter: telescope-fzf-native (requires build step: make)
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- Telescope: fuzzy finder with keybindings and sensible defaults
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto (grep)" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Ver buffers abiertos" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Ayuda de Neovim" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					-- Ignore common large directories and VCS metadata
					file_ignore_patterns = { "node_modules", ".git/", "bin/", "obj/", "target/" },
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = { prompt_position = "top" },
					},
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
			})
		end,
	},

	-- Statusline (lualine): lightweight statusline plugin
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup()
		end,
	},

	-- Autopairs: automatically close brackets and quotes
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- Commenting: toggle comments easily with Comment.nvim
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Formatting: conform.nvim to provide formatters and on-save formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Formatters selected per filetype
			formatters_by_ft = {
				cs = { "csharpier" },
				lua = { "stylua" },
			},
			-- Format on save settings: timeout and use LSP formatting as a fallback
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}

