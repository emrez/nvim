-- Enhanced Catppuccin configuration with better transparency support
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- Load before other colorschemes
    config = function()
      require("catppuccin").setup({
        -- Use the "mocha" flavor (darker, works better with transparency)
         flavour = "mocha",
        
        -- Enable terminal colors
        term_colors = true,
        
        -- Use transparency when enabled globally
        transparent_background = vim.g.transparent_enabled or false,
        
        -- Enhanced styles for better visibility with transparency
        styles = {
          comments = { "italic" },
          conditionals = { "italic", "bold" },
          loops = { "bold" },
          functions = { "bold" },
          keywords = { "bold" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = { "bold" },
          properties = {},
          types = { "bold" },
          operators = {},
        },
        
        -- Make certain elements more prominent 
        custom_highlights = function(colors)
          return {
            -- Boost syntax elements for better visibility with transparency
            Comment = { fg = colors.overlay1, style = { "italic" } },
            ["@comment"] = { fg = colors.overlay1, style = { "italic" } },
            ["@keyword"] = { fg = colors.mauve, style = { "bold" } },
            ["@function"] = { fg = colors.blue, style = { "bold" } },
            ["@method"] = { fg = colors.blue, style = { "bold" } },
            ["@property"] = { fg = colors.lavender },
            ["@variable"] = { fg = colors.text },
            ["@string"] = { fg = colors.green },
            ["@number"] = { fg = colors.peach },
            ["@boolean"] = { fg = colors.peach, style = { "bold" } },
            
            -- Improve UI elements
            CursorLine = { bg = colors.mantle },
            CursorLineNr = { fg = colors.mauve, style = { "bold" } },
            LineNr = { fg = colors.overlay1 },
          }
        end,
        
        -- Native integrations with Catppuccin
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
          which_key = true,
          notify = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
      })
      
      -- Apply the colorscheme
      vim.cmd.colorscheme "catppuccin"
      
      -- If transparency is enabled, reapply it to ensure proper highlighting
      if vim.g.transparent_enabled then
        -- Allow a moment for the colorscheme to apply fully
        vim.defer_fn(function()
          -- Re-enable transparency using our enhanced function
          if package.loaded["emrez.config.transparent"] then
            require("emrez.config.transparent").enable()
          end
          
          -- We need to re-apply syntax highlighting
          if package.loaded["transparent"] then
            -- Clear all highlight groups with catppuccin prefix
            require("transparent").clear_prefix("Catppuccin")
            -- Trigger the TransparentEnabled event
            vim.api.nvim_exec_autocmds("User", { pattern = "TransparentEnabled" })
          end
        end, 50) -- Use a longer delay to ensure everything has settled
      end
    end,
  }
}
