local M = {}
local map = vim.keymap.set

local diagnostic_config = function()
  local x = vim.diagnostic.severity

  vim.diagnostic.config {
    virtual_text = { prefix = "" },
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "single" },
  }

  -- Default border style
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end
-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", 'gr', vim.lsp.buf.references, opts 'Goto References')
  map('n', 'gI', vim.lsp.buf.implementation, opts 'Goto Implementation')
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do
      print(folder)
    end
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map('n', '<leader>ds', vim.lsp.buf.document_symbol, opts 'Document Symbols')
  map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts 'Workspace Symbols')
  map('n', '<leader>rn', vim.lsp.buf.rename, opts 'Rename')
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts 'Code Action')
  map("n", "<leader>ra", require "utils.lsp.renamer", opts "Rename symbol")



-- Show diagnostics in a hover window when moving cursor
  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   buffer = bufnr,
  --   callback = function()
  --     local opts = {
  --       focusable = false,
  --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  --       border = 'rounded',
  --       source = 'always',
  --       prefix = ' ',
  --       scope = 'cursor',
  --     }
  --     vim.diagnostic.open_float(nil, opts)
  --   end
  -- })
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

M.capabilities = capabilities

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init, on_attach = M.on_attach })

  dofile(vim.g.base46_cache .. "lsp")
  diagnostic_config()
  vim.lsp.enable "lua_ls"
end

return M
