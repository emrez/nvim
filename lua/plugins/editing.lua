-- Enhanced editing experience
return {
  -- Improved surround functionality
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
        },
      })
    end,
  },
  
  -- Fast cursor movement with leap
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
      -- Optional: Enhance leap's cross-window jumping
      require("leap").opts.special_keys = {
        repeat_search = '<enter>',
        next_match    = '<enter>',
        prev_match    = '<tab>',
        next_group    = '<space>',
        prev_group    = '<tab>',
        multi_accept  = '<enter>',
        multi_revert  = '<backspace>',
      }
    end,
  },
  
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
  
  -- Zen mode for focused editing
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 0.95,
          width = 120,
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
            ruler = false,
            showcmd = false,
          },
          twilight = { enabled = true },
          gitsigns = { enabled = false },
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
  
  -- Twilight dims inactive portions of code
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({
        dimming = {
          alpha = 0.25,
          color = { "Normal", "#ffffff" },
          term_bg = "#000000",
          inactive = false,
        },
        context = 10,
        treesitter = true,
        expand = {
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {},
      })
      
      vim.keymap.set("n", "<leader>tt", "<cmd>Twilight<CR>", { desc = "Toggle twilight" })
    end,
  },
}