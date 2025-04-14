-- Plugin for developing plugins
return {
  "folke/lazydev.nvim",
  -- Only load if we're actively developing plugins
  cond = function()
    -- Check if we're in development mode
    return vim.env.NVIM_DEV == "1"
  end,
  -- Configure with explicit string paths (not booleans)
  opts = {
    -- Explicitly provide string paths for development
    paths = {
      -- Standard Neovim config path
      vim.fn.expand("~/.config/nvim/lua"),
    },
    -- Other options
    library = {
      -- Plugin library settings (using strings)
      plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      types = true,
    },
    -- No boolean values here
  },
}
