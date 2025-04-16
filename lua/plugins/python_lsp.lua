-- Python LSP configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
      -- "mfussenegger/nvim-dap-python",  -- Python debugging support
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
    
    -- Function to run a Python tool with the correct interpreter
    local function run_python_tool(tool, args, silent)
      local python_path = python_utils.get_python_path()
      local venv_dir = vim.fn.fnamemodify(python_path, ':h')
      local tool_path = venv_dir .. "/" .. tool
      
      -- Check if tool exists in the virtual environment
      if vim.fn.filereadable(tool_path) ~= 1 then
        -- Try to find it in the system path
        if vim.fn.executable(tool) == 1 then
          tool_path = tool
        else
          vim.notify(tool .. " not found! You may need to install it with :PylspSetup", vim.log.levels.ERROR)
          return false
        end
      end
      
      local file_path = vim.fn.expand("%:p")
      local cmd = tool_path .. " " .. args .. " " .. file_path
      
      if not silent then
        vim.notify("Running: " .. cmd, vim.log.levels.INFO)
      end
      
      -- Save the current buffer before running the tool
      vim.cmd("silent! write")
      
      -- Run the command and display output in a split terminal
      vim.cmd("belowright 10split | terminal " .. cmd)
      return true
    end
    
    -- Commands for running Python tools
    vim.api.nvim_create_user_command("Black", function()
      run_python_tool("black", "", false)
    end, { desc = "Format with Black" })
    
    vim.api.nvim_create_user_command("Isort", function()
      run_python_tool("isort", "", false)
    end, { desc = "Sort imports with isort" })
    
    vim.api.nvim_create_user_command("Mypy", function()
      run_python_tool("mypy", "--show-column-numbers", false)
    end, { desc = "Type check with mypy" })
    
    vim.api.nvim_create_user_command("Flake8", function()
      run_python_tool("flake8", "", false)
    end, { desc = "Lint with flake8" })

    -- require('dap-python').setup('~/.venv/bin/python')
    
    -- -- UV integration commands
    -- vim.api.nvim_create_user_command('UvVenvCreate', function()
    --   local venv_path = vim.fn.input("Virtual environment path (.venv): ", ".venv")
    --   vim.cmd('terminal uv venv create ' .. venv_path)
    -- end, { desc = "Create UV virtual environment" })
    -- 
    -- vim.api.nvim_create_user_command('UvInstall', function(opts)
    --   vim.cmd('terminal uv pip install ' .. opts.args)
    -- end, { nargs = "*", desc = "Install packages with UV" })
    -- 
    -- vim.api.nvim_create_user_command('UvInstallRequirements', function()
    --   local req_file = vim.fn.input("Requirements file: ", "requirements.txt")
    --   vim.cmd('terminal uv pip install -r ' .. req_file)
    -- end, { desc = "Install from requirements.txt with UV" })
    -- 
    -- vim.api.nvim_create_user_command('UvRunPytest', function(opts)
    --   local args = opts.args or ""
    --   vim.cmd('terminal uv run pytest ' .. args)
    -- end, { nargs = "*", desc = "Run pytest with UV" })
    -- 
    -- vim.api.nvim_create_user_command('UvRunMypy', function(opts)
    --   local args = opts.args or "."
    --   vim.cmd('terminal uv run mypy ' .. args)
    -- end, { nargs = "*", desc = "Run mypy with UV" })
    -- 
    -- -- Keymaps for UV integration
    -- vim.keymap.set("n", "<leader>vc", "<cmd>UvVenvCreate<CR>", { desc = "Create UV virtual env" })
    -- vim.keymap.set("n", "<leader>vi", "<cmd>UvInstall<CR>", { desc = "Install package with UV" })
    -- vim.keymap.set("n", "<leader>vr", "<cmd>UvInstallRequirements<CR>", { desc = "Install requirements with UV" })
    -- vim.keymap.set("n", "<leader>vp", "<cmd>UvRunPytest<CR>", { desc = "Run pytest with UV" })
    -- vim.keymap.set("n", "<leader>vm", "<cmd>UvRunMypy<CR>", { desc = "Run mypy with UV" })
    
    -- Add keymaps for Python tools, but only for Python files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Register keymaps with which-key if available
        local wk_ok, wk = pcall(require, "which-key")
        if wk_ok then
          wk.register({
            -- LSP Python tools under leader + l + p
            ["<leader>lp"] = {
              name = "Python Tools",
              b = { "<cmd>Black<CR>", "Format with Black" },
              i = { "<cmd>Isort<CR>", "Sort imports" },
              m = { "<cmd>Mypy<CR>", "Run mypy" },
              f = { "<cmd>Flake8<CR>", "Run flake8" },
              r = { "<cmd>PylspRestart<CR>", "Restart Python LSP" },
            },
            -- Add direct formatting shortcut
            ["<leader>fb"] = { "<cmd>Black<CR>", "Format with Black" },
          })
        end
        
        -- Direct keymaps (not dependent on which-key)
        vim.keymap.set("n", "<leader>lpb", "<cmd>Black<CR>", { buffer = true, desc = "Format with Black" })
        vim.keymap.set("n", "<leader>lpi", "<cmd>Isort<CR>", { buffer = true, desc = "Sort imports" })
        vim.keymap.set("n", "<leader>lpm", "<cmd>Mypy<CR>", { buffer = true, desc = "Run mypy" })
        vim.keymap.set("n", "<leader>lpf", "<cmd>Flake8<CR>", { buffer = true, desc = "Run flake8" })
        vim.keymap.set("n", "<leader>lpr", "<cmd>PylspRestart<CR>", { buffer = true, desc = "Restart Python LSP" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Black<CR>", { buffer = true, desc = "Format with Black" })
        
        -- Ensure LSP is running and correctly attached
        vim.cmd("LspStart pylsp")
      end,
      group = vim.api.nvim_create_augroup("PythonLSPAutostart", { clear = true }),
    })
  end,
}
