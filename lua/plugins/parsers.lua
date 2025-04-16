-- Additional Tree-sitter parsers for special functionality
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add the parsers identified as missing in the health check
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "regex",  -- Required by noice.nvim
        "jsonc",  -- Required by neoconf.nvim
      })
      
      return opts
    end,
  }
}
