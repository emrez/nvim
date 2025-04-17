return {
  -- Which-key (helps you remember keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        window = {
          border = "rounded",
          padding = { 2, 2, 2, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "center",
        },
      })
      
      -- Register key groups using the new format
      local wk = require("which-key")
      wk.register({
        ["<leader>f"] = { name = "Find" },
        ["<leader>b"] = { name = "Buffers" },
        ["<leader>w"] = { name = "Write" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>h"] = { name = "Hunks" },
        ["<leader>l"] = { name = "LSP" },
        ["<leader>s"] = { name = "Split" },
        ["<leader>t"] = { name = "Toggle" },
        ["<leader>r"] = { name = "Refactor" },
        ["<leader>n"] = { name = "Notifications" },
        ["<leader>v"] = { name = "UV/Venv" },
      })
    end,
  },
}
