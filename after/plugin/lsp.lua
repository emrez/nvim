local lsp = require("lsp-zero")
local mason = require('mason')
local mason_lsp = require("mason-lspconfig")

lsp.preset("recommended")


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete()
})

cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
		{name = 'buffer'},
		{name = 'path'},
	},
	mapping = cmp_mappings
})

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

--lsp.setup_nvim_cmp({
--  mapping = cmp_mappings
-- })

lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
mason.setup({})
mason_lsp.setup({
	ensure_installed = {
		'tsserver',
		'rust_analyzer',
		"html",
		"htmx",
		"gopls",
		"lua_ls"
	},

	handlers = {
		function(server_name)
			if server_name == "lua_ls" then
				require('lspconfig')[server_name].setup({
					settings = {
						Lua = {
							diagnostics = {
								globals = { 'vim' }
							}
						}
					}
				})
			else
				require('lspconfig')[server_name].setup({})
			end
		end,
	},
})

vim.diagnostic.config({
    virtual_text = true
})
