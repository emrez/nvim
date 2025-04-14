-- Enhanced Git integration
return {
  -- Diffview for advanced git diff viewing and merge conflict resolution
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        use_icons = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
          },
        },
        file_panel = {
          win_config = {
            position = "left",
            width = 35,
          },
        },
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>hgd", "<cmd>DiffviewOpen<CR>", { desc = "Git diff" })
      vim.keymap.set("n", "<leader>hgh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
      vim.keymap.set("n", "<leader>hgf", "<cmd>DiffviewFileHistory<CR>", { desc = "Repo file history" })
      vim.keymap.set("n", "<leader>hgc", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
    end,
  },
  
  -- Neogit - Magit-like interface for Git
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        kind = "tab",
        integrations = {
          diffview = true,
          telescope = true,
        },
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        commit_popup = {
          kind = "split",
        },
      })
      
      -- Keymap
      vim.keymap.set("n", "<leader>hgg", function() neogit.open() end, { desc = "Open Neogit" })
      vim.keymap.set("n", "<leader>hgc", function() neogit.open({ "commit" }) end, { desc = "Neogit commit" })
    end,
  },
  
  -- Git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = false,
        highlights = {
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })
    end,
  }
}
