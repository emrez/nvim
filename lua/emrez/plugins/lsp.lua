return {{
    'benomahony/uv.nvim',
    config = function()
        require('uv').setup({
            auto_activate_venv = true
        })
    end
}, {
    "williamboman/mason.nvim",
    dependencies = {'benomahony/uv.nvim'},
    opts = {}
}, {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {'benomahony/uv.nvim'},
    opts = {
        ensure_installed = {"ts_ls", 'eslint', -- ESLint
        'tailwindcss', -- For Tailwind if used
        'cssls', -- CSS
        'jsonls' -- JSON
        }
    }
}, {
    "scalameta/nvim-metals",
    dependencies = {"nvim-lua/plenary.nvim"},
    ft = {"scala", "sbt", "java"},
    opts = function()
        local metals_config = require("metals").bare_config()
        local config = require("emrez.config.lspconfig")
        require("mason").setup()

        local on_attach = config.on_attach

        metals_config.on_attach = on_attach

        return metals_config
    end,
    config = function(self, metals_config)
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", {
            clear = true
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = self.ft,
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group
        })
    end
}, {
    "neovim/nvim-lspconfig",
    dependencies = {'benomahony/uv.nvim', "williamboman/mason-lspconfig.nvim"},
    event = "User FilePost",
    config = function()
        local config = require("emrez.config.lspconfig")
        require("mason").setup()

        local on_attach = config.on_attach
        local capabilities = config.capabilities

        local lspconfig = require('lspconfig')

        lspconfig.pyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = {"python"},
            settings = {
                pyright = {
                    -- disableOrganizeImports = true,
                    useLibraryCodeForTypes = true
                },
                python = {
                    analysis = {
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace"
                    }
                }
                -- python = {
                --   analysis = {
                --     ignore = { "*" }
                --   }
                -- }
            }
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

        lspconfig.ts_ls.setup({
            root_dir = vim.loop.cwd,
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true
                    }
                },
                javascript = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true
                }
            },
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
            init_options = {
                preferences = {
                    importModuleSpecifierPreference = "absolute",
                    quotePreference = "double"
                }
            }
        })

        lspconfig.ruff.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = {"python"}
            -- before_init = function(_, config)
            --   require("uv").auto_activate_venv()
            -- end,
        })

        lspconfig.gopls.setup {
            on_attach = on_attach,
            capabilities = capabilities,

            filetypes = {"go", "gomod", "gosum", "gotmpl"},
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true
                    },
                    codelenses = {
                        generate = true,
                        test = true
                    }
                }
            }
        }
    end
}, -- Go power‑pack (LSP, DAP, testing, coverage, gomod helpers)
{
    "ray-x/go.nvim", -- actively maintained, modern Go plugin  [oai_citation_attribution:0‡GitHub](https://github.com/ray-x/go.nvim?utm_source=chatgpt.com)
    dependencies = {"nvim-treesitter/nvim-treesitter"}, -- , "mfussenegger/nvim-dap" },
    ft = {"go", "gomod", "gosum", "gotmpl"},
    opts = {
        lsp_keymaps = false,
        run_in_floaterm = true,
        dap_debug = false,
        dap_debug_keymap = false,
        trouble = true
    },
    build = ':lua require("go.install").update_all_sync()' -- installs dlv, etc.
}, {
    "nvimtools/none-ls.nvim",
    dependencies = {'benomahony/uv.nvim', 'neovim/nvim-lspconfig'},
    ft = {"python", "typescript", "javascript", "go", "typescript.tsx", "typescriptreact"},

    opts = function()
        return require("emrez.config.null-ls")
    end
}, -- formatting
{
    "stevearc/conform.nvim",
    dependencies = {'benomahony/uv.nvim'},
    opts = {
        formatters_by_ft = {
            lua = {"stylua"}
        }
    }
}}
