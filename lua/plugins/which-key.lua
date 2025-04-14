-- Updated which-key configuration with the new spec format
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        -- Updated to use `win` instead of deprecated `window`
        win = {
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
      
      -- Register key groups using the new spec format
      wk.register({
        { "<leader>f", group = "Find" },
        { "<leader>b", group = "Buffers" },
        { "<leader>w", group = "Write" },
        -- { "<leader>hg", group = "Git" },
        { "<leader>g", group = "Go To" },
        { "<leader>h", group = "Harpoon/Hunks" },
        { "<leader>l", group = "LSP" },
        { "<leader>s", group = "Split" },
        { "<leader>t", group = "Toggle" },
        { "<leader>p", group = "Project" },
        { "<leader>q", group = "Session" },
        { "<leader>d", group = "Debug" },
        { "<leader>o", group = "Obsidian" },
        { "<leader>z", group = "Zettelkasten" },
        { "<leader>r", group = "Refactor" },
        { "<leader>n", group = "Notifications" },
        { "g", group = "Go to" }, -- Add this line for 'g' prefix
      })
    end,
  },
}
