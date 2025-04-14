-- WezTerm-specific optimizations
-- This module detects WezTerm and applies optimizations for transparency

local M = {}

-- Detect if we're running in WezTerm
function M.is_wezterm()
  local term = vim.env.TERM_PROGRAM or ""
  return term:lower() == "wezterm"
end

-- Apply WezTerm-specific settings
function M.setup()
  if not M.is_wezterm() then
    return
  end
  
  -- Set terminal transparency detection
  vim.g.wezterm_detected = true
  
  -- Optimize for WezTerm's transparency handling
  vim.opt.pumblend = 10      -- Make popup menus semi-transparent
  vim.opt.winblend = 10      -- Make floating windows semi-transparent
  
  -- WezTerm performs best with fast update time
  vim.opt.updatetime = 100   -- Faster updates for smoother transparency
  
  -- Fix the sign column to prevent shifting when transparency toggles
  vim.opt.signcolumn = "yes" -- Always show the sign column
  
  -- Custom highlight groups for WezTerm transparency
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      -- Better handling for floating windows in WezTerm
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", blend = 0 })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", blend = 10 })
      
      -- Better panel borders for WezTerm
      vim.api.nvim_set_hl(0, "VertSplit", { fg = "#444444", bg = "NONE" })
      
      -- Enhance floating window visibility
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1a1a", blend = 10 })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2d3144", blend = 0 })
    end,
  })
  
  -- Log successful setup
  vim.notify("WezTerm optimizations applied", vim.log.levels.INFO)
end

return M
