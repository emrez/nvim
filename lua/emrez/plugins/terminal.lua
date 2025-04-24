
  -- Terminal integration
  return {
  {
      "nvimtools/hydra.nvim",
      config = function()
        --  local Hydra = require("hydra")
        --  Hydra({
        --     -- string? only used in auto-generated hint
        --     name = "Terminal",
        --
        --     -- string | string[] modes where the hydra exists, same as `vim.keymap.set()` accepts
        --     mode = "n",
        --
        --     -- string? key required to activate the hydra, when excluded, you can use
        --     -- Hydra:activate()
        --     body = "<leader>th",
        --
        --     -- these are explained below
        --     hint = [[ ... ]],
        --     -- config = { ... },
        --     -- heads = { ... },
        -- })       --
      end
  }

    -- "akinsho/toggleterm.nvim",
    -- config = function()
    --   require("toggleterm").setup({
    --     size = 20,
    --     open_mapping = [[<C-\>]],
    --     hide_numbers = true,
    --     shade_filetypes = {},
    --     shade_terminals = true,
    --     shading_factor = 2,
    --     start_in_insert = true,
    --     insert_mappings = true,
    --     persist_size = true,
    --     direction = "float",
    --     close_on_exit = true,
    --     shell = vim.o.shell,
    --     float_opts = {
    --       border = "curved",
    --       winblend = 0,
    --       highlights = {
    --         border = "Normal",
    --         background = "Normal",
    --       },
    --     },
    --   })
    --
    --   -- Terminal key mappings
    --   function _G.set_terminal_keymaps()
    --     local opts = { buffer = 0 }
    --     vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    --     vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    --     vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    --     vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    --     vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    --     vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    --   end
    --
    --   vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    --
    --   -- Custom terminal commands
    --   local Terminal = require("toggleterm.terminal").Terminal
    --
    --   local lazygit = Terminal:new({
    --     cmd = "lazygit",
    --     hidden = true,
    --     direction = "float",
    --   })
    --
    --   function _LAZYGIT_TOGGLE()
    --     lazygit:toggle()
    --   end
    --
    --   vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Toggle Lazygit" })
    -- end,
  }
