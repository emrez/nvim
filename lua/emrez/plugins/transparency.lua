-- Enhanced transparency plugin with syntax highlighting preservation
local function apply_syntax_colors()
  -- Catppuccin Mocha palette
  local colors = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
  }
  
  -- Apply these highlight groups with explicit foreground colors but NO background colors
  -- Standard syntax groups
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.overlay0, italic = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.mauve, bold = true, bg = "NONE" }) 
  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.blue, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.sky, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "String", { fg = colors.green, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.peach, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Boolean", { fg = colors.peach, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Type", { fg = colors.yellow, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Special", { fg = colors.pink, bg = "NONE" })
  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.red, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.mauve, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Conditional", { fg = colors.mauve, italic = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Repeat", { fg = colors.mauve, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Operator", { fg = colors.sky, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Todo", { fg = colors.red, bold = true, italic = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "Underlined", { underline = true, bg = "NONE" })
  
  -- TreeSitter syntax groups
  vim.api.nvim_set_hl(0, "@comment", { fg = colors.overlay0, italic = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@keyword", { fg = colors.mauve, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@function", { fg = colors.sky, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@method", { fg = colors.blue, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@property", { fg = colors.lavender, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@variable", { fg = colors.text, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@parameter", { fg = colors.text, italic = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@string", { fg = colors.green, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@string.special", { fg = colors.green, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@number", { fg = colors.peach, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@boolean", { fg = colors.peach, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@type", { fg = colors.yellow, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@constant", { fg = colors.peach, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@attribute", { fg = colors.blue, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@field", { fg = colors.blue, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@operator", { fg = colors.sky, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@tag", { fg = colors.mauve, bg = "NONE" })
  vim.api.nvim_set_hl(0, "@punctuation", { fg = colors.overlay2, bg = "NONE" })
  
  -- Important for transparent float windows
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue, bg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" }) -- Slightly visible
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.mauve, bold = true, bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.overlay1, bg = "NONE" })
  
  -- Force normal text to have proper foreground
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.text, bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { fg = colors.text, bg = "NONE" })
  
  -- Fix diagnostic text coloring
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red, bg = "NONE" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.yellow, bg = "NONE" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.blue, bg = "NONE" })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.teal, bg = "NONE" })
  
  -- Force update to make sure changes take effect
  vim.cmd("redraw")
end

return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1001,  -- Load AFTER colorscheme with higher priority
    config = function()
      -- Check if running in WezTerm
      local is_wezterm = (vim.env.TERM_PROGRAM or ""):lower() == "wezterm"
      
      -- Configure transparency differently for WezTerm
      if is_wezterm then
        -- WezTerm-specific configuration
        require("transparent").setup({
          groups = {  -- Table of groups that should be transparent by default
            'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
            'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
            'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
            'SignColumn', 'CursorLineNr', 'EndOfBuffer',
          },
          extra_groups = {  -- Optimized for WezTerm
            "NormalFloat",
            "NvimTreeNormal",
            "NvimTreeEndOfBuffer",
            "TelescopeNormal",
            "TelescopePrompt",
            "TelescopeBorder",
            "TelescopeResults",
            "WhichKeyFloat",
            "FloatBorder",
            "NotifyBackground",
            -- WezTerm-specific groups
            "WinSeparator",
            "VertSplit", 
            "StatusLine",
            "StatusLineNC",
            -- Better panel integration
            "NvimTreeWinSeparator",
            "TabLine",
            "TabLineFill",
          },
          exclude_groups = {}, -- Groups that should not be transparent even if transparent_background = true
        })
        
        -- Better blending settings for WezTerm
        vim.g.transparent_use_title_bar = true
        
      else
        -- Default configuration for other terminals
        require("transparent").setup({
          groups = {  -- Table of groups that should be transparent by default
            'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
            'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
            'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
            'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
            'EndOfBuffer',
          },
          extra_groups = {  -- Additional groups that should be transparent
            "NormalFloat",
            "NvimTreeNormal",
            "NvimTreeNormalNC", 
            "NvimTreeEndOfBuffer",
            "TelescopeNormal",
            "TelescopeBorder",
            "WhichKeyFloat",
            "FloatBorder",
            "NotifyBackground",
          },
          exclude_groups = {}, -- Groups that should not be transparent even if transparent_background = true
        })
      end
      
      -- Setup an event handler to ensure syntax highlighting is preserved after transparency is toggled
      vim.api.nvim_create_autocmd("User", {
        pattern = "TransparentEnabled",
        callback = function()
          -- Delay slightly to let transparency effect complete
          vim.defer_fn(function()
            apply_syntax_colors()
          end, 10)
        end
      })
      
      -- Another handler for when transparency is disabled
      vim.api.nvim_create_autocmd("User", {
        pattern = "TransparentDisabled",
        callback = function()
          -- Allow theme to restore colors then enhance them
          vim.defer_fn(function()
            if vim.g.colors_name == "catppuccin" then
              vim.cmd.colorscheme "catppuccin"
            end
          end, 10)
        end
      })
      
      -- Create autocmd to ensure syntax highlighting is preserved when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Only apply if transparency is enabled
          if vim.g.transparent_enabled then
            -- Delay application to ensure it happens after colorscheme is fully applied
            vim.defer_fn(function()
              apply_syntax_colors()
            end, 20) -- Slightly longer delay to ensure colorscheme is fully applied
          end
        end
      })
      
      -- Apply syntax highlighting immediately if transparency is already enabled
      if vim.g.transparent_enabled then
        apply_syntax_colors()
      end
    end,
  }
}
