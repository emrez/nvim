-- LSP Configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    "folke/neoconf.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- Neodev setup (must be before lspconfig)
    require("neodev").setup()
    
    -- Setup neoconf before lspconfig
    require("neoconf").setup()
    
    -- First, set up mason
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
    
    -- Get LSP capabilities with nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    
    -- We're wrapping mason-lspconfig in pcall to handle potential errors gracefully
    local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_status then
      vim.notify("mason-lspconfig not found", vim.log.levels.ERROR)
      return
    end
    
    -- Verify valid server names for mason-lspconfig
    local function has_value(tab, val)
      for _, value in ipairs(tab) do
        if value == val then
          return true
        end
      end
      return false
    end

    -- Get the list of available server names from mason-lspconfig
    local mason_registry = require("mason-registry")
    local available_servers = mason_lspconfig.get_available_servers()
    
    -- Print available servers for debugging
    vim.api.nvim_create_user_command("MasonServers", function()
      local servers = mason_lspconfig.get_available_servers()
      print("Available Mason-LSPConfig servers:")
      for _, server in ipairs(servers) do
        print("  - " .. server)
      end
    end, {})
    
    -- Mason-lspconfig setup (make sure to use correct server names)
    -- These names must match those used by lspconfig
    local servers_to_install = {
      "lua_ls",      -- Lua
      "pylsp",       -- Python (with mypy plugin)
      "ts_ls",       -- TypeScript/JavaScript
      "gopls",       -- Go
      "jsonls",      -- JSON
      "html",        -- HTML
      "cssls",       -- CSS
    }
    
    -- Validate server names before passing to ensure_installed
    local valid_servers = {}
    for _, server in ipairs(servers_to_install) do
      if has_value(available_servers, server) then
        table.insert(valid_servers, server)
      else
        vim.notify("Server '" .. server .. "' is not a valid mason-lspconfig server name", vim.log.levels.WARN)
      end
    end
    
    -- Setup with validated servers
    mason_lspconfig.setup({
      ensure_installed = valid_servers,
      automatic_installation = true,
    })
    
    -- Configure LSP servers
    mason_lspconfig.setup_handlers({
      -- Default handler
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
      
      -- Custom server configurations
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            }
          }
        })
      end,
      
      -- Custom configuration for Python (pylsp with mypy)
      ["pylsp"] = function()
        local python_utils = require("utils.python")
        
        require("lspconfig").pylsp.setup({
          capabilities = capabilities,
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },  -- Disable pycodestyle in favor of mypy
                mccabe = { enabled = false },      -- Disable mccabe
                pyflakes = { enabled = false },    -- Disable pyflakes
                flake8 = { enabled = false },      -- Disable flake8
                mypy = { 
                  enabled = true,
                  live_mode = true,
                  dmypy = true
                }
              }
            }
          },
          before_init = function(_, config)
            config.settings.pylsp = config.settings.pylsp or {}
          end
        })
      end,
      
      -- Custom configuration for TypeScript/React/JSX (ts_ls)
      ["ts_ls"] = function()
        require("lspconfig")["ts_ls"].setup({
          capabilities = capabilities,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            }
          },
          filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "tsconfig.json",
              "jsconfig.json",
              "package.json"
            )(fname) or vim.fn.getcwd()
          end,
          single_file_support = true,
        })
      end,
    })
    
    -- Global mappings
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    
    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local wk = require("which-key")
        
        -- Register LSP keybindings with which-key
        wk.register({
          { "gD", vim.lsp.buf.declaration, desc = "Go to declaration", buffer = ev.buf },
          { "gd", vim.lsp.buf.definition, desc = "Go to definition", buffer = ev.buf },
          { "K", vim.lsp.buf.hover, desc = "Hover information", buffer = ev.buf },
          { "gi", vim.lsp.buf.implementation, desc = "Go to implementation", buffer = ev.buf },
          { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help", buffer = ev.buf },
          { "gr", vim.lsp.buf.references, desc = "Go to references", buffer = ev.buf },
        })
        
        -- Register leader-based LSP commands with which-key
        wk.register({
          { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder", buffer = ev.buf },
          { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder", buffer = ev.buf },
          { "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, desc = "List workspace folders", buffer = ev.buf },
          { "<leader>D", vim.lsp.buf.type_definition, desc = "Type definition", buffer = ev.buf },
          { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", buffer = ev.buf },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", buffer = ev.buf, mode = {"n", "v"} },
          { "<leader>f", function() 
            vim.lsp.buf.format { async = true } 
          end, desc = "Format buffer", buffer = ev.buf },
        })
        
        -- Register <leader>g LSP goto commands
        wk.register({
          { "<leader>gd", vim.lsp.buf.definition, desc = "Go to definition", buffer = ev.buf },
          { "<leader>gD", vim.lsp.buf.declaration, desc = "Go to declaration", buffer = ev.buf },
          { "<leader>gi", vim.lsp.buf.implementation, desc = "Go to implementation", buffer = ev.buf },
          { "<leader>gr", vim.lsp.buf.references, desc = "Go to references", buffer = ev.buf },
          { "<leader>gt", vim.lsp.buf.type_definition, desc = "Go to type definition", buffer = ev.buf },
        })
        
        -- Also set up traditional keymaps for backward compatibility
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover information" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "Add workspace folder" })
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "Remove workspace folder" })
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = ev.buf, desc = "List workspace folders" })
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Type definition" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
        vim.keymap.set("n", "<leader>f", function() 
          vim.lsp.buf.format { async = true } 
        end, { buffer = ev.buf, desc = "Format buffer" })
        
        -- Add <leader>g keymaps
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
        vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Go to type definition" })
      end,
    })
  end,
}
