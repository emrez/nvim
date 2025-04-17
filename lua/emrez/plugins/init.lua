return {
  -- Core
  { "folke/lazy.nvim" },
  { "nvim-lua/plenary.nvim" },

  -- Copilot -- 
  { "github/copilot.vim" },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = { "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

}
