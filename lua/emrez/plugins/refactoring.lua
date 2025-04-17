return {
  -- Advanced code refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = true,
          java = true,
          cpp = true,
          c = true,
          h = true,
          hpp = true,
          cxx = true,
        },
        prompt_func_param_type = {
          go = true,
          java = true,
          cpp = true,
          c = true,
          h = true,
          hpp = true,
          cxx = true,
        },
        printf_statements = {},
        print_var_statements = {},
      })
      
      -- Remaps for refactorings
      vim.keymap.set(
        {"n", "x"},
        "<leader>rr",
        function() require("refactoring").select_refactor() end,
        { desc = "Select refactoring" }
      )
      
      -- Extract function supports both normal and visual mode
      vim.keymap.set(
        "x",
        "<leader>re",
        function() require("refactoring").refactor("Extract Function") end,
        { desc = "Extract function" }
      )
      
      -- Extract variable supports only visual mode
      vim.keymap.set(
        "x",
        "<leader>rv",
        function() require("refactoring").refactor("Extract Variable") end,
        { desc = "Extract variable" }
      )
      
      -- Inline variable supports both normal and visual mode
      vim.keymap.set(
        {"n", "x"},
        "<leader>ri",
        function() require("refactoring").refactor("Inline Variable") end,
        { desc = "Inline variable" }
      )
      
      -- Extract block supports only normal mode
      vim.keymap.set(
        "n",
        "<leader>rb",
        function() require("refactoring").refactor("Extract Block") end,
        { desc = "Extract block" }
      )
      
      -- Telescope integration
      vim.keymap.set(
        "n",
        "<leader>fr",
        function() require("telescope").extensions.refactoring.refactors() end,
        { desc = "Find refactorings" }
      )
    end,
  },
}
