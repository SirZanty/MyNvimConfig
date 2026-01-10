-- Module providing fold helpers using Tree-sitter for precise function/class folding
-- Falls back to builtin commands when Tree-sitter is unavailable

local M = {}

local function is_treesitter_available()
  return pcall(vim.treesitter.get_parser, 0)
end

-- Collapse all function/class definitions into manual folds
function M.collapse_to_definitions()
  if not is_treesitter_available() then
    vim.notify("nvim-treesitter not available: falling back to indent folds", vim.log.levels.WARN)
    vim.o.foldmethod = "indent"
    vim.cmd("normal! zM")
    return
  end

  -- Use manual folds created from AST nodes
  vim.api.nvim_buf_set_option(0, "foldmethod", "manual")
  -- Remove any existing manual folds
  vim.cmd("silent! normal! zE")

  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok then
    vim.notify("Failed to get tree-sitter parser", vim.log.levels.ERROR)
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    return
  end
  local root = tree:root()

  local function traverse(node)
    for child in node:iter_children() do
      local t = child:type()
      if t:match("function") or t:match("method") or t:match("def") or t:match("class") then
        local sr, sc, er, ec = child:range()
        if er > sr then
          -- create a manual fold for the node range
          vim.cmd(string.format("%d,%dfold", sr + 1, er + 1))
        end
      end
      traverse(child)
    end
  end

  traverse(root)
end

-- Create a fold for the current function/class at cursor
function M.fold_current()
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if ok and ts_utils.get_node_at_cursor then
    local node = ts_utils.get_node_at_cursor()
    while node do
      local t = node:type()
      if t:match("function") or t:match("method") or t:match("def") or t:match("class") then
        local sr, sc, er, ec = node:range()
        if er > sr then
          vim.api.nvim_buf_set_option(0, "foldmethod", "manual")
          vim.cmd(string.format("%d,%dfold", sr + 1, er + 1))
          return
        end
      end
      node = node:parent()
    end
    vim.notify("No function/class found at cursor", vim.log.levels.INFO)
  else
    -- Fallback: try to create a fold using the % text-object/bracket match
    pcall(vim.cmd, "normal! zf%")
  end
end

-- Unfold the entire function/class at the cursor (recursively open nested folds)
function M.unfold_current()
  -- Save cursor position to restore later
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1], pos[2]

  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  local start_row
  if ok and ts_utils.get_node_at_cursor then
    local node = ts_utils.get_node_at_cursor()
    while node do
      local t = node:type()
      if t:match("function") or t:match("method") or t:match("def") or t:match("class") then
        local sr, sc, er, ec = node:range()
        start_row = sr
        break
      end
      node = node:parent()
    end
  end

  if start_row then
    -- Move cursor to the start of the node and open all folds recursively
    vim.api.nvim_win_set_cursor(0, {start_row + 1, 0})
    vim.cmd("normal! zO")
    -- Restore original cursor
    vim.api.nvim_win_set_cursor(0, {row, col})
  else
    -- Fallback: open fold at cursor recursively
    vim.cmd("normal! zO")
  end
end

-- Toggle the fold at the cursor
function M.toggle_current()
  vim.cmd("normal! za")
end

-- Open all folds
function M.open_all()
  vim.cmd("normal! zR")
end

return M
