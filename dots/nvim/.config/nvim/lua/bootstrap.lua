-- bootstrap M global variable
local M = {}

-- set echo utility
M.echo = function(str)
  vim.cmd "redraw"
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

function M.mkdir_run()
  local dir = vim.fn.expand('<afile>:p:h')

  -- This handles URLs using netrw. See ':help netrw-transparent' for details.
  if dir:find('%l+://') == 1 then
    return
  end

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
end

M.load_plugins = function()
  local install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(install_path) then
    --------- lazy.nvim ---------------
    M.echo "  Installing lazy.nvim & plugins ..."
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", repo, install_path }
  end

  -- add lazy to the plugins path
  vim.opt.rtp:prepend(install_path)

  -- install plugins
  require('lazy')
    .setup(require('plugins'))
end

M.load_settings = function()
  -- load legacy settings first
  vim.cmd 'silent! source ~/.virc'
  vim.cmd 'silent! source ~/.vimrc'

  -- load lua-based settings
  require('settings')
end

M.load_keybindings = function()
  -- load lua-based keybinds
  local mappings = require('keybindings')

  -- register the set mappings
  local function register_mappings(mappings, default_options)
    for mode, mode_mappings in pairs(mappings) do
      for _, mapping in pairs(mode_mappings) do
        local options = #mapping == 3 and table.remove(mapping) or default_options
        local prefix, cmd = unpack(mapping)
        pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
      end
    end
  end

  register_mappings(mappings, { silent = true, noremap = true })
end

M.load = function()
  vim.cmd([[
    augroup MkdirRun
    autocmd!
    autocmd BufWritePre * lua require('bootstrap').mkdir_run()
    augroup END
  ]])
end

return M
