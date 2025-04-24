return {
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    config = function()
      require("ibl").setup()
    end,
  },
  { "akinsho/bufferline.nvim" },
  { "folke/trouble.nvim" },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        -- renderer = {
        --   group_empty = true,
        -- },
        filters = {
          dotfiles = false,
        },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
    end,
  },

  {
    'mikew/nvim-drawer',
    dependencies = { "nvim-tree/nvim-tree.lua" },
    opts = {},
    config = function(_, opts)
      local drawer = require('nvim-drawer')
      drawer.setup(opts)

      drawer.create_drawer({
        -- This is needed for nvim-tree.
        nvim_tree_hack = true,

        -- Position on the right size of the screen.
        -- position = 'left',
        -- size = 40,
        size = 15,
        position = 'below',

        --
        does_own_buffer = function(context)
            return context.bufname:match('term') ~= nil
          end,

        on_vim_enter = function(event)
          --- Example mapping to toggle.
          vim.keymap.set('n', '<leader>tf', function()
            event.instance.focus()
          end, { desc = "Focus terminal" })

          vim.keymap.set('n', '<leader>to', function()
            event.instance.toggle()
          end, { desc = "Toggle terminal" })

          vim.keymap.set('n', '<leader>tn', function()
            event.instance.open({ mode = 'new' })
          end, { desc = "New terminal" })
          vim.keymap.set('n', '<TAB>', function()
            event.instance.go(1)
          end, { desc = "Next terminal" })
          vim.keymap.set('n', '<S-TAB>', function()
            event.instance.go(-1)
          end, { desc = "Previous terminal" })
          vim.keymap.set('n', '<leader>tf', function()
            event.instance.toggle_zoom()
          end, { desc = "Toggle zoom" })
        end,

        on_did_create_buffer = function()
         vim.fn.termopen(os.getenv('SHELL'))
        end,

        -- Remove some UI elements.
          on_did_open_buffer = function()
            vim.opt_local.number = false
            vim.opt_local.signcolumn = 'no'
            vim.opt_local.statuscolumn = ''
          end,

          -- Scroll to the end when changing tabs.
          on_did_open = function()
            -- vim.cmd('$')
          end,
      })
    end
  },

  -- Better commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },
  
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  -- Better scrollbar
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",  -- Add hlslens as a dependency
    },
    config = function()
      -- Setup hlslens first
      require("hlslens").setup({
        calm_down = true,
        nearest_only = false,
        nearest_float_when = 'auto',
      })
      
      -- Integrate scrollbar with hlslens
      require("scrollbar").setup({
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
        max_lines = false, -- disables if no. of lines in buffer exceeds this
        hide_if_all_visible = false, -- Hides everything if all lines are visible
        throttle_ms = 100,
        handle = {
          text = " ",
          color = nil,
          color_nr = nil,
          highlight = "CursorColumn",
          hide_if_all_visible = true,
        },
        marks = {
          Cursor = {
            text = "•",
            priority = 0,
            color = nil,
            cterm = nil,
            highlight = "Normal",
          },
          Search = {
            text = { "-", "=" },
            priority = 1,
            color = nil,
            cterm = nil,
            highlight = "Search",
          },
          Error = {
            text = { "-", "=" },
            priority = 2,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextError",
          },
          Warn = {
            text = { "-", "=" },
            priority = 3,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextWarn",
          },
          Info = {
            text = { "-", "=" },
            priority = 4,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextInfo",
          },
          Hint = {
            text = { "-", "=" },
            priority = 5,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextHint",
          },
          Misc = {
            text = { "-", "=" },
            priority = 6,
            color = nil,
            cterm = nil,
            highlight = "Normal",
          },
          GitAdd = {
            text = "│",
            priority = 7,
            color = nil,
            cterm = nil,
            highlight = "GitSignsAdd",
          },
          GitChange = {
            text = "│",
            priority = 7,
            color = nil,
            cterm = nil,
            highlight = "GitSignsChange",
          },
          GitDelete = {
            text = "▁",
            priority = 7,
            color = nil,
            cterm = nil,
            highlight = "GitSignsDelete",
          },
        },
        excluded_buftypes = {
          "terminal",
        },
        excluded_filetypes = {
          "prompt",
          "TelescopePrompt",
          "noice",
          "alpha",
        },
        autocmd = {
          render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
          },
          clear = {
            "BufWinLeave",
            "TabLeave",
            "TermLeave",
            "WinLeave",
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        },
      })
      
      -- Explicitly require and initialize scrollbar.handlers.search with hlslens integration
      require("scrollbar.handlers.search").setup({
        -- These are the defaults
        override_lens = function() end,
      })
    end,
  },
  
  -- Better fold handling
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      local ufo = require("ufo")
      
      -- Using treesitter as a main provider
      ufo.setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end,
        -- fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        --   local newVirtText = {}
        --   local suffix = ('  %d '):format(endLnum - lnum)
        --   local sufWidth = vim.fn.strdisplaywidth(suffix)
        --   local targetWidth = width - sufWidth
        --   local curWidth = 0
        --   for _, chunk in ipairs(virtText) do
        --     local chunkText = chunk[1]
        --     local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        --     if targetWidth > curWidth + chunkWidth then
        --       table.insert(newVirtText, chunk)
        --     else
        --       chunkText = truncate(chunkText, targetWidth - curWidth)
        --       local hlGroup = chunk[2]
        --       table.insert(newVirtText, {chunkText, hlGroup})
        --       chunkWidth = vim.fn.strdisplaywidth(chunkText)
        --       -- str width returned from truncate() may less than 2nd argument, need padding
        --       if curWidth + chunkWidth < targetWidth then
        --         suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        --       end
        --       break
        --     end
        --     curWidth = curWidth + chunkWidth
        --   end
        --   table.insert(newVirtText, {suffix, 'MoreMsg'})
        --   return newVirtText
        -- end,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  %d lines '):format(endLnum - lnum)
          local preview = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
          preview = preview:sub(1, 30) -- Limit preview to 30 characters
          suffix = suffix .. " | " .. preview
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end,
        preview = {
          win_config = {
            border = {'', '─', '', '', '', '─', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
          }
        },
      })
      
      -- Keymaps
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds except kinds" })
      vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds with" })
      vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Peek folded lines under cursor" })

      vim.keymap.set("n", "za", "za", { desc = "Toggle fold at cursor" })
      vim.keymap.set("n", "[z", "zj", { desc = "Jump to next fold" })
      vim.keymap.set("n", "]z", "zk", { desc = "Jump to previous fold" })

      vim.cmd([[
        highlight Folded guibg=#2E3440 guifg=#88C0D0
        highlight FoldColumn guibg=#3B4252 guifg=#D8DEE9
      ]])
      
      -- Option for better look
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

}
