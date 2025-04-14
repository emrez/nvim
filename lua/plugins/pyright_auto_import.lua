-- Pyright auto-import plugin
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    -- Load the Python auto-imports functionality
    local auto_imports = require("plugins.python.auto_imports")
    
    -- We'll set up keymaps and commands for Python auto-imports
    local function setup_python_auto_imports()
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
    end
    
    -- Setup Pyright with improved import capabilities
    local lspconfig_status, lspconfig = pcall(require, "lspconfig")
    if lspconfig_status then
      -- Get the current Pyright configuration
      local current_settings = lspconfig.pyright.document_config.default_config.settings or {}
      
      -- Merge analysis settings
      local merged_analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true
      }
      
      -- Add existing settings if they exist
      if current_settings.python and current_settings.python.analysis then
        for k, v in pairs(current_settings.python.analysis) do
          if merged_analysis[k] == nil then
            merged_analysis[k] = v
          end
        end
      end
      
      -- Enhance Pyright configuration for better auto-import support
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = merged_analysis
          }
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        -- Add code actions for import management
        handlers = {
          ["textDocument/codeAction"] = function(err, actions, ctx)
            -- Call the default handler first
            vim.lsp.handlers["textDocument/codeAction"](err, actions, ctx)
            
            -- Check for import-related code actions
            if actions then
              for _, action in ipairs(actions) do
                if action.title:match("Import") then
                  -- Prioritize import-related actions
                  table.insert(actions, 1, table.remove(actions, _))
                end
              end
            end
          end
        }
      })
    end
    
    -- Initialize the import functionality
    setup_python_auto_imports()
  end,
}
