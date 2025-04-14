-- Python development configuration
return {
  -- Utilities for Python development
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap-python",  -- Python debugging support
    },
    config = function()
      -- Set up Python debugging
      require('dap-python').setup('~/.venv/bin/python')
      
      -- UV integration commands
      vim.api.nvim_create_user_command('UvVenvCreate', function()
        local venv_path = vim.fn.input("Virtual environment path (.venv): ", ".venv")
        vim.cmd('terminal uv venv create ' .. venv_path)
      end, { desc = "Create UV virtual environment" })
      
      vim.api.nvim_create_user_command('UvInstall', function(opts)
        vim.cmd('terminal uv pip install ' .. opts.args)
      end, { nargs = "*", desc = "Install packages with UV" })
      
      vim.api.nvim_create_user_command('UvInstallRequirements', function()
        local req_file = vim.fn.input("Requirements file: ", "requirements.txt")
        vim.cmd('terminal uv pip install -r ' .. req_file)
      end, { desc = "Install from requirements.txt with UV" })
      
      vim.api.nvim_create_user_command('UvRunPytest', function(opts)
        local args = opts.args or ""
        vim.cmd('terminal uv run pytest ' .. args)
      end, { nargs = "*", desc = "Run pytest with UV" })
      
      vim.api.nvim_create_user_command('UvRunMypy', function(opts)
        local args = opts.args or "."
        vim.cmd('terminal uv run mypy ' .. args)
      end, { nargs = "*", desc = "Run mypy with UV" })
      
      -- Keymaps for UV integration
      vim.keymap.set("n", "<leader>vc", "<cmd>UvVenvCreate<CR>", { desc = "Create UV virtual env" })
      vim.keymap.set("n", "<leader>vi", "<cmd>UvInstall<CR>", { desc = "Install package with UV" })
      vim.keymap.set("n", "<leader>vr", "<cmd>UvInstallRequirements<CR>", { desc = "Install requirements with UV" })
      vim.keymap.set("n", "<leader>vp", "<cmd>UvRunPytest<CR>", { desc = "Run pytest with UV" })
      vim.keymap.set("n", "<leader>vm", "<cmd>UvRunMypy<CR>", { desc = "Run mypy with UV" })
    end,
  }
}
