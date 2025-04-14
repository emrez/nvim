-- Python LSP configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Get Python utilities
    local python_utils = require("utils.python")
    
    -- Configure Python LSP
    local python_path = python_utils.get_python_path()
    local venv_dir = vim.fn.fnamemodify(python_path, ':h')
    local pylsp_cmd = venv_dir .. "/pylsp"
    
    -- Check if pylsp exists in the virtual environment
    if vim.fn.filereadable(pylsp_cmd) ~= 1 then
      pylsp_cmd = "pylsp"  -- Fallback to global pylsp
      vim.notify("Using global pylsp executable", vim.log.levels.INFO)
    else
      vim.notify("Using pylsp from virtual environment: " .. pylsp_cmd, vim.log.levels.INFO)
    end
    
    require("lspconfig").pylsp.setup({
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      settings = {
        pylsp = {
          plugins = {
            -- Disable default linters that flake8 will handle
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
            mccabe = { enabled = false },
            
            -- Enable flake8
            flake8 = { enabled = true },
            
            -- Enable mypy
            mypy = { 
              enabled = true,
              live_mode = true,
              dmypy = true
            },
            
            -- Other plugins will be managed by the third-party packages
            -- python-lsp-black and python-lsp-isort
          }
        },
        -- Use flake8 as configuration source
        configurationSources = { 'flake8' }
      },
      cmd = { pylsp_cmd },
      flags = {
        debounce_text_changes = 150,  -- This reduces the need to restart LSP
      },
      -- Ensure proper Python environment detection
      before_init = function(_, config)
        config.settings.pylsp = config.settings.pylsp or {}
        -- Use the Python path from our utility function
        config.settings.python = {
          pythonPath = python_utils.get_python_path()
        }
      end,
      -- This ensures the server doesn't need to be restarted
      on_attach = function(client, bufnr)
        -- You can add custom on_attach logic here if needed
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      end
    })
    
    -- Create commands to install and manage Python LSP plugins
    vim.api.nvim_create_user_command("PylspInstallPlugins", function()
      python_utils.install_lsp_plugins()
    end, { desc = "Install Python LSP plugins" })
    
    -- Command to install specific plugins with better defaults
    vim.api.nvim_create_user_command("PylspSetup", function()
      local python_path = python_utils.get_python_path()
      -- Install packages and make pylsp executable
      local cmd = string.format(
        "%s -m pip install 'python-lsp-server[flake8]' pylsp-mypy python-lsp-black python-lsp-isort && echo 'Installation complete'",
        python_path
      )
      vim.notify("Installing Python LSP and plugins...", vim.log.levels.INFO)
      vim.cmd('belowright 15split | terminal ' .. cmd)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*",
        once = true,
        callback = function()
          vim.notify("Please check if installation succeeded, then restart the LSP with :PylspRestart", vim.log.levels.INFO)
        end
      })
    end, { desc = "Set up Python LSP with recommended plugins" })
    
    -- Create a command to restart the LSP server
    vim.api.nvim_create_user_command("PylspRestart", function()
      -- Stop any running pylsp instance
      vim.cmd("LspStop pylsp")
      
      -- Clear the LSP client
      for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.name == "pylsp" then
          vim.lsp.stop_client(client.id)
        end
      end
      
      -- Find pylsp in the virtual environment
      local python_path = python_utils.get_python_path()
      local venv_dir = vim.fn.fnamemodify(python_path, ':h')
      local pylsp_cmd = venv_dir .. "/pylsp"
      
      -- Check if pylsp exists in the virtual environment
      if vim.fn.filereadable(pylsp_cmd) ~= 1 then
        vim.notify("pylsp not found in virtual environment. You may need to run :PylspSetup", vim.log.levels.WARN)
        
        -- Start with global pylsp if available
        if vim.fn.executable("pylsp") == 1 then
          vim.notify("Using global pylsp", vim.log.levels.INFO)
          vim.cmd("LspStart pylsp")
        else
          vim.notify("pylsp not found! Please run :PylspSetup to install it", vim.log.levels.ERROR)
          return
        end
      else
        -- Update the pylsp command to use the one from the virtual environment
        local lspconfig = require("lspconfig")
        lspconfig.pylsp.setup({ cmd = { pylsp_cmd } })
        vim.notify("Using pylsp from: " .. pylsp_cmd, vim.log.levels.INFO)
        vim.cmd("LspStart pylsp")
      end
      
      vim.notify("Python LSP server restarted", vim.log.levels.INFO)
    end, { desc = "Restart Python LSP server" })
    
    -- Create autocommand to ensure pylsp attaches correctly to Python files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Ensure LSP is running and correctly attached
        vim.cmd("LspStart pylsp")
      end,
      group = vim.api.nvim_create_augroup("PythonLSPAutostart", { clear = true }),
    })
  end,
}
