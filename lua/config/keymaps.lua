local keymap = vim.keymap.set

-- Set leader keys: main leader and local leader (used as a prefix for custom mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation: move between split windows using Ctrl-h/j/k/l
keymap("n", "<C-h>", "<C-w>h") -- Move to the left window
keymap("n", "<C-j>", "<C-w>j") -- Move to the window below
keymap("n", "<C-k>", "<C-w>k") -- Move to the window above
keymap("n", "<C-l>", "<C-w>l") -- Move to the right window

-- Save and quit: quick save and close using <leader>w and <leader>q
keymap("n", "<leader>w", ":w<CR>") -- Save current buffer
keymap("n", "<leader>q", ":q<CR>") -- Close current window/buffer

-- Quit helpers: save all and quit, or force quit without saving
-- Implemented in a separate module for cleaner configuration
local quit = require("config.quit")
keymap("n", "<leader>Q", quit.save_and_quit, { desc = "Save all, close explorer and quit" }) -- Save all + quit
keymap("n", "<leader>QF", quit.quit_without_saving, { desc = "Quit all without saving" }) -- Force quit without saving

-- File explorer toggle: open/close Neo-tree with <leader>e
keymap("n", "<leader>e", ":Neotree toggle<CR>") -- Toggle Neo-tree explorer

-- LSP shortcuts: go-to definition, find references, show hover, code action, and rename
keymap("n", "gd", vim.lsp.buf.definition) -- Jump to symbol definition
keymap("n", "gr", vim.lsp.buf.references) -- List references to the symbol
keymap("n", "K", vim.lsp.buf.hover) -- Show hover documentation/info
keymap("n", "<leader>ca", vim.lsp.buf.code_action) -- Show available code actions
keymap("n", "<leader>rn", vim.lsp.buf.rename) -- Rename symbol under cursor

-- Format file: trigger formatter (conform) asynchronously, fallback to LSP formatting
keymap("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" }) -- Format current buffer (async; LSP fallback)

-- Mouse navigation: use mouse buttons X1 and X2 to jump back and forward in jump list
keymap("n", "<X1Mouse>", "<C-o>", { desc = "Jump back (mouse)" })
keymap("n", "<X2Mouse>", "<C-i>", { desc = "Jump forward (mouse)" })


-- Start xbindkeys automatically when Neovim starts, and stop it on exit
-- Managed by the `config.xbindkeys` module to keep keymaps clean and focused
require("config.xbindkeys").setup_autocmds()

-- Atajos para plegado de código (folding) con nvim-ufo
keymap("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Abrir todos los pliegues" })
keymap("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Cerrar todos los pliegues" })
