-- Module to manage xbindkeys lifecycle for Neovim
-- This keeps the logic separated from keymaps for cleaner configuration

local M = {}

local state_dir = vim.fn.expand("~/.local/state")
local pidfile = state_dir .. "/xbindkeys-nvim.pid"
local _jobid = nil
local _started_by_nvim = false

local function is_executable()
  return vim.fn.executable("xbindkeys") == 1
end

local function any_running()
  local pids = vim.fn.systemlist("pgrep -u $USER -x xbindkeys")
  return #pids > 0
end

-- Start xbindkeys if not already running and record ownership
function M.start()
  if not is_executable() then
    return
  end
  if any_running() then
    _started_by_nvim = false
    return
  end

  vim.fn.mkdir(state_dir, "p")
  _jobid = vim.fn.jobstart({"xbindkeys"}, {detach = false})
  if _jobid and _jobid > 0 then
    _started_by_nvim = true
    -- Give the process a brief moment to appear and write its pid to a file
    vim.defer_fn(function()
      local pids = vim.fn.systemlist("pgrep -u $USER -x xbindkeys")
      if #pids > 0 then
        vim.fn.writefile({pids[1]}, pidfile)
      end
    end, 100)
  else
    _started_by_nvim = false
  end
end

-- Stop xbindkeys only if Neovim started it (best-effort)
function M.stop()
  if _jobid then
    pcall(vim.fn.jobstop, _jobid)
    _jobid = nil
  end

  if not _started_by_nvim then
    return
  end

  if vim.fn.filereadable(pidfile) == 1 then
    local lines = vim.fn.readfile(pidfile)
    local pid = lines[1] or ""
    if pid ~= "" then
      local comm = vim.fn.system('ps -p ' .. pid .. ' -o comm= 2>/dev/null'):gsub("%s+", "")
      if comm == "xbindkeys" then
        vim.fn.system('kill ' .. pid .. ' >/dev/null 2>&1 || true')
      end
    end
    os.remove(pidfile)
  end

  _started_by_nvim = false
end

-- Setup autocommands to start/stop on Neovim lifecycle events
function M.setup_autocmds()
  local aug = vim.api.nvim_create_augroup("XbindkeysNvim", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter", { group = aug, callback = M.start })
  vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend", "VimLeave" }, { group = aug, callback = M.stop })
end

return M
