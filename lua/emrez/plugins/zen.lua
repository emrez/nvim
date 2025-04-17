return {
  -- Zen mode for focused editing
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 0.95,
          width = 200,
          height = 1,
          options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
          },
        },
        plugins = {
          options = {
            enabled = true,
            ruler = true,
            showcmd = false,
          },
          twilight = { enabled = true },
          gitsigns = { enabled = true },
          tmux = { enabled = false },
        },
        on_open = function()
          vim.g.cmp_active = false
          require("cmp").setup.buffer { enabled = false }
        end,
        on_close = function()
          vim.g.cmp_active = true
          require("cmp").setup.buffer { enabled = true }
        end,
      })
      
      vim.keymap.set("n", "<leader>tz", "<cmd>ZenMode<CR>", { desc = "Toggle zen mode" })
    end,
  },

  -- Dim inactive portions of code
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({
        dimming = {
          alpha = 0.20,
          color = { "Normal", "#ffffff" },
          term_bg = "#000000",
          inactive = false,
        },
        context = 25,
        treesitter = true,
        expand = {
          "function",
          "method",
          "table",
          "if_statement",
        },
      })

      vim.keymap.set("n", "<leader>tt", "<cmd>Twilight<CR>", { desc = "Toggle twilight" })
    end,
  },
}
