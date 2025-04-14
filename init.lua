-- Entry point for Neovim configuration
-- Load core settings
require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.transparent')  -- Load transparency module

-- Load Python auto-import utility
-- require('plugins.python.auto_imports')  -- Ensure auto-imports module is available

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Load plugins
require("lazy").setup("plugins")
require('config.pyproject').setup()  -- Load Python project detection
