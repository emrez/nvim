-- Python Auto-Import Plugin
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- Load the Python auto-imports functionality
    local auto_imports = require("plugins.python.auto_imports")
    
    -- Map keys for Python files only
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Set up keymaps for auto-import functionality
        vim.keymap.set("n", "<leader>ii", auto_imports.prompt_import, 
          { buffer = true, desc = "Add import interactively" })
        
        vim.keymap.set("n", "<leader>ia", auto_imports.auto_import_symbol, 
          { buffer = true, desc = "Auto-import symbol under cursor" })
        
        vim.keymap.set("n", "<leader>io", auto_imports.organize_imports, 
          { buffer = true, desc = "Organize imports" })
        
        vim.keymap.set("n", "<leader>in", auto_imports.append_import, 
          { buffer = true, desc = "Add new import statement" })
        
        -- Visual mode import
        vim.keymap.set("v", "<leader>ii", function()
          -- Exit visual mode to execute auto_import_symbol
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
          auto_imports.auto_import_symbol()
        end, { desc = "Import selected symbol" })
        
        -- Register which-key labels if available
        local wk_ok, wk = pcall(require, "which-key")
        if wk_ok then
          wk.register({
            ["<leader>i"] = { name = "Import" },
            ["<leader>ii"] = { auto_imports.prompt_import, "Add import interactively" },
            ["<leader>ia"] = { auto_imports.auto_import_symbol, "Auto-import symbol" },
            ["<leader>io"] = { auto_imports.organize_imports, "Organize imports" },
            ["<leader>in"] = { auto_imports.append_import, "Add new import" },
          }, { buffer = 0 })
        end
      end
    })
    
    -- Create user commands for Python import management
    vim.api.nvim_create_user_command("PythonImport", function()
      auto_imports.prompt_import()
    end, { desc = "Add Python import interactively" })
    
    vim.api.nvim_create_user_command("PythonAutoImport", function()
      auto_imports.auto_import_symbol()
    end, { desc = "Auto-import Python symbol under cursor" })
    
    vim.api.nvim_create_user_command("PythonOrganizeImports", function()
      auto_imports.organize_imports()
    end, { desc = "Organize Python imports" })
    
    vim.api.nvim_create_user_command("PythonAddImport", function()
      auto_imports.append_import()
    end, { desc = "Add new Python import statement" })
    
    -- Setup Pyright with improved import capabilities
    local lspconfig_status, lspconfig = pcall(require, "lspconfig")
    if lspconfig_status then
      -- Make sure we have access to the original setup function
      local original_setup = lspconfig.pyright.setup
      local python_utils = require("utils.python")
      
      -- Override the pyright setup to include our import settings
      lspconfig.pyright.setup = function(user_config)
        -- Create a base config with auto-import capabilities
        local base_config = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                importFormat = "absolute"
              }
            }
          },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          before_init = function(_, config)
            config.settings.python.pythonPath = python_utils.get_python_path()
          end
        }
        
        -- Merge user config with base config
        if user_config then
          -- Merge settings recursively
          if user_config.settings and user_config.settings.python and user_config.settings.python.analysis then
            for k, v in pairs(user_config.settings.python.analysis) do
              base_config.settings.python.analysis[k] = v
            end
          end
          
          -- Copy other properties
          for k, v in pairs(user_config) do
            if k ~= "settings" then
              base_config[k] = v
            end
          end
        end
        
        -- Call the original setup with our merged config
        original_setup(base_config)
      end
      
      -- Apply our custom setup
      lspconfig.pyright.setup({})
    end
  end,
}
