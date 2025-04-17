-- Transparent background configuration
-- This module provides functions to enable/disable transparency and sets up defaults

local M = {}

-- Load WezTerm-specific optimizations
local wezterm = require("emrez.config.wezterm")
wezterm.setup()

-- Default transparency settings
M.transparent_enabled = false

-- Function to enable transparency
function M.enable()
  -- Set variables for transparency
  vim.g.transparent_enabled = true
  M.transparent_enabled = true
  
  -- Let the transparent.nvim plugin handle the transparency
  -- Rather than manually setting highlight groups
  if package.loaded["transparent"] then
    require("transparent").clear_prefix("")
  end
  
  -- Fire an event so other plugins can respond
  vim.api.nvim_exec_autocmds("User", { pattern = "TransparentEnabled" })

  -- Handle catppuccin-specific transparency
  if vim.g.colors_name == "catppuccin" then
    require("catppuccin").setup({
      transparent_background = true,
      term_colors = true,
    })
    vim.cmd.colorscheme "catppuccin"
  end
  
  print("Transparency enabled")
end

-- Function to disable transparency
function M.disable()
  -- Set variables for transparency
  vim.g.transparent_enabled = false
  M.transparent_enabled = false
  
  -- Refresh the colorscheme to restore backgrounds
  local current_scheme = vim.g.colors_name or "default"
  
  -- Special handling for catppuccin
  if current_scheme == "catppuccin" and package.loaded["catppuccin"] then
    require("catppuccin").setup({
      transparent_background = false,
      term_colors = true,
    })
  end
  
  -- Reapply the colorscheme
  vim.cmd("colorscheme " .. current_scheme)
  
  -- Fire an event so other plugins can respond
  vim.api.nvim_exec_autocmds("User", { pattern = "TransparentDisabled" })
  
  print("Transparency disabled")
end

-- Toggle transparency
function M.toggle()
  if M.transparent_enabled then
    M.disable()
    vim.notify("Transparency disabled", vim.log.levels.INFO)
  else
    M.enable()
    vim.notify("Transparency enabled", vim.log.levels.INFO)
  end
end

-- Create user commands for transparency control
vim.api.nvim_create_user_command("TransparencyEnable", function() M.enable() end, {})
vim.api.nvim_create_user_command("TransparencyDisable", function() M.disable() end, {})
vim.api.nvim_create_user_command("TransparencyToggle", function() M.toggle() end, {})

-- Setup keymaps for transparency control
vim.keymap.set("n", "<leader>tp", M.toggle, { desc = "Toggle transparency" })

return M
