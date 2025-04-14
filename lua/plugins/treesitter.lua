-- Treesitter (better syntax highlighting)
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { 
        "lua", "vim", "vimdoc", "query", 
        "javascript", "typescript", "tsx", 
        "html", "css", "json", "yaml", 
        "python", "go", "rust", "c", "cpp", 
        "bash", "markdown", "markdown_inline" 
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      autopairs = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },
    })
  end,
}
