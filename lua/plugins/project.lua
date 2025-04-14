-- Project management plugins
return {
  -- Project detection and management
  {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("project_nvim").setup({
        -- Detection methods: lsp, pattern
        detection_methods = { "pattern", "lsp" },
        
        -- Patterns used to detect the root directory of a project
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "cargo.toml", "pyproject.toml", "requirements.txt" },
        
        -- Automatically change to project directory on detection
        silent_chdir = true,
        
        -- Don't show recent projects in telescope window
        show_hidden = false,
        
        -- When true, only shows the root directory instead of all containing paths
        scope_chdir = 'tab',
        
        -- Set datapath directory. Can be used to separate history per project
        datapath = vim.fn.stdpath("data"),
      })
      
      -- Load telescope extension
      require("telescope").load_extension('projects')
      
      -- Keybinding to show projects
      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Find projects" })
    end,
  },
  
  -- Session Management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        -- Directory where session files are stored
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        
        -- Save session on these events
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      })
      
      -- Keybindings for session management
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session for current directory" })
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save current session" })
    end,
  },
  
  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        sign_priority = 8,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        highlight = {
          before = "",
          keyword = "wide", 
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF00FF" }
        },
      })
      
      -- Keybindings
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
    end,
  },
  
  -- Project specific settings
  {
    "folke/neoconf.nvim",
    config = function()
      require("neoconf").setup({
        -- Automatically source the config file
        auto_reload = true,
        -- Don't add to global config
        global_settings = "auto",
        -- Import types
        import = {
          vscode = true,
          nlsp = true,
          coc = true
        },
        -- Don't use other config files like jsconfig.json
        plugins = {
          lspconfig = {
            enabled = true
          },
          jsonls = {
            enabled = true,
            configured_servers_only = true
          },
          lua_ls = {
            enabled = true,
            configured_servers_only = true
          }
        },
      })
    end,
  },
  
  -- Neovim Task Runner
  {
    "stevearc/overseer.nvim",
    config = function()
      local overseer = require("overseer")
      
      -- Override the enable_dap function to handle potential errors
      local original_enable_dap = overseer.enable_dap
      overseer.enable_dap = function(...)
        -- Use pcall to catch errors
        local status, err = pcall(original_enable_dap, ...)
        if not status then
          vim.notify("Could not enable DAP integration for Overseer: " .. err, vim.log.levels.WARN)
        end
      end
      
      overseer.setup({
        task_list = {
          direction = "bottom",
          min_height = 10,
          max_height = 15,
          bindings = {
            ["q"] = function() vim.cmd("OverseerClose") end,
          }
        },
        form = {
          border = "rounded",
        },
        task_win = {
          border = "rounded",
        },
        -- Explicitly disable DAP integration until it's properly configured
        dap = {
          enabled = false,
        },
      })
      
      vim.keymap.set("n", "<leader>pt", "<cmd>OverseerToggle<CR>", { desc = "Toggle task list" })
      vim.keymap.set("n", "<leader>pr", "<cmd>OverseerRun<CR>", { desc = "Run task" })
      vim.keymap.set("n", "<leader>pb", "<cmd>OverseerBuild<CR>", { desc = "Build task" })
    end,
  },
  
  -- Workspaces management
  {
    "natecraddock/workspaces.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("workspaces").setup({
        -- Hook that runs after switching to a workspace
        hooks = {
          open = function()
            -- Open file explorer
            require("nvim-tree.api").tree.open()
            -- Find a file
            require("telescope.builtin").find_files()
          end,
        },
      })
      
      -- Load extension
      require("telescope").load_extension("workspaces")
      
      -- Keybindings
      vim.keymap.set("n", "<leader>pw", "<cmd>Telescope workspaces<CR>", { desc = "Find workspaces" })
      vim.keymap.set("n", "<leader>pa", function() vim.ui.input({ prompt = "Add workspace name: " }, function(name)
        if name then require("workspaces").add(name) end
      end) end, { desc = "Add workspace" })
    end,
  }
}