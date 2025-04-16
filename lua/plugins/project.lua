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
  }
}
