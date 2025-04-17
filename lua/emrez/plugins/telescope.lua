
  -- Fuzzy finder
  return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      }
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      telescope.load_extension("fzf")

      -- Keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
      keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find text" })
      keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
      keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })
      keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Find diagnostics" })
      keymap("n", "<leader>fc", "<cmd>Telescope git_commits<CR>", { desc = "Find commits" })
      keymap("n", "<leader>fs", "<cmd>Telescope git_status<CR>", { desc = "Find git status" })
    end,
  }
