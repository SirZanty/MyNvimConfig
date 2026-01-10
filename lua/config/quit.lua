-- Module providing quit helpers for Neovim
-- Keeps quit-related logic separate from keymaps for clarity

local M = {}

-- Save all buffers, close Neo-tree if open, then quit
function M.save_and_quit()
  -- Save all files
  pcall(vim.cmd, "wa")
  -- Close Neo-tree if available
  pcall(vim.cmd, "Neotree close")
  -- Quit Neovim
  pcall(vim.cmd, "qa")
end

-- Quit all without saving (force quit)
function M.quit_without_saving()
  pcall(vim.cmd, "Neotree close")
  pcall(vim.cmd, "qa!")
end

return M
