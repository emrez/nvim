return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
    opts = function()
      local nn = require "notebook-navigator"

      local opts = { custom_textobjects = { h = nn.miniai_spec } }
      return opts
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "VeryLazy",
    dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
    opts = function()
      local nn = require "notebook-navigator"

      local opts = { highlighters = { cells = nn.minihipatterns_spec } }
      return opts
    end,
  },
  {
  "GCBallesteros/NotebookNavigator.nvim",
  keys = {
    { "]h", function() require("notebook-navigator").move_cell "d" end },
    { "[h", function() require("notebook-navigator").move_cell "u" end },
    { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
    { "<leader>x", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
  },
  dependencies = {
    "echasnovski/mini.comment",
    "hkupty/iron.nvim", -- repl provider
    -- "akinsho/toggleterm.nvim", -- alternative repl provider
    -- "benlubas/molten-nvim", -- alternative repl provider
    "anuvyklack/hydra.nvim",
    'benomahony/uv.nvim',
  },
  event = "VeryLazy",
  config = function()
    local nn = require "notebook-navigator"
    nn.setup({ activate_hydra_keys = "<leader>h" })
  end,
  },

  {
    'Vigemus/iron.nvim',
    dependencies = { 'benomahony/uv.nvim' },
    config = function() 
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")
      local uv = require("uv")

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = {"zsh"}
            },
            python = {
              command = { "ipython", "--no-autoindent" },  -- or { "ipython", "--no-autoindent" }
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            }
          },
          -- set the file type of the newly created repl to ft
          -- bufnr is the buffer id of the REPL and ft is the filetype of the 
          -- language being used for the REPL. 
          repl_filetype = function(bufnr, ft)
            return ft
            -- or return a string name such as the following
            -- return "iron"
          end,
          repl_open_cmd = "vertical botright 80 split"

          -- repl_open_cmd can also be an array-style table so that multiple 
          -- repl_open_commands can be given.
          -- When repl_open_cmd is given as a table, the first command given will
          -- be the command that `IronRepl` initially toggles.
          -- Moreover, when repl_open_cmd is a table, each key will automatically
          -- be available as a keymap (see `keymaps` below) with the names 
          -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
          -- For example,
          -- 
          -- repl_open_cmd = {
          --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
          --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
          -- }

        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          toggle_repl = "<space>ro", -- toggles the repl open and closed.
          -- If repl_open_command is a table as above, then the following keymaps are
          -- available
          -- toggle_repl_with_cmd_1 = "<space>rv",
          -- toggle_repl_with_cmd_2 = "<space>rh",
          restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
          -- send_motion = "<space>sc",
          -- visual_send = "<space>sc",
          -- send_file = "<space>sf",
          -- send_line = "<space>sl",
          -- send_paragraph = "<space>sp",
          -- send_until_cursor = "<space>su",
          -- send_mark = "<space>sm",
          -- send_code_block = "<space>sb",
          -- send_code_block_and_move = "<space>sn",
          -- mark_motion = "<space>mc",
          -- mark_visual = "<space>mc",
          -- remove_mark = "<space>md",
          -- cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>rsq",
          clear = "<space>rcl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
      vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
    end
  }
}
