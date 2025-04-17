return {
  {
    'benomahony/uv.nvim',
    config = function()
      require('uv').setup({
        auto_activate_venv = true,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = { 'benomahony/uv.nvim' },
    opts = {
    }
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { 'benomahony/uv.nvim' },
    event = "User FilePost",
    config = function() 
      local config = require("emrez.config.lspconfig")

      local on_attach = config.on_attach
      local capabilities = config.capabilities

      local lspconfig = require('lspconfig')

      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "python" },
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { "*" }
            }
          }
        },
        -- -- Configure for uv: find the Python executable from uv virtual environment
        -- before_init = function(_, config)
        --   -- Try to find the uv virtual environment
        --   local utils = require("emrez.utils.uv")
        --   local path = util.find_git_ancestor(config.root_dir)
        --   local venv_path = vim.fn.expand("~/.venv") -- Default uv path
        --   
        --   -- Check for specific project venv
        --   local project_venv = path and util.path.join(path, ".venv") or nil
        --   if project_venv and vim.fn.isdirectory(project_venv) ~= 0 then
        --     venv_path = project_venv
        --   end
        --   
        --   -- Set Python path to use the venv
        --   config.settings.python.pythonPath = util.path.join(venv_path, "bin", "python")
        -- end,
        -- before_init = function(_, config)
        --   require("uv").auto_activate_venv()
        --   -- config.settings.python.pythonPath = get_python_path(config.root_dir)
        -- end,
      })

      lspconfig.ruff.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "python" },
        -- before_init = function(_, config)
        --   require("uv").auto_activate_venv()
        -- end,
      })
    end
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { 'benomahony/uv.nvim', 'neovim/nvim-lspconfig' },
    ft = {"python"},
    
    opts = function() 
      return require("emrez.config.null-ls")
    end
  },
  -- formatting
  {
    "stevearc/conform.nvim",
    dependencies = { 'benomahony/uv.nvim' },
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
    },
  },
}
