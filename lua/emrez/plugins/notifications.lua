return {
  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "static",
        timeout = 3000,
        render = "default",
        max_width = 80,
        minimum_width = 50,
      })
      
      -- Set as default notification system
      vim.notify = notify
    end,
  },

  -- Improved UI for messages, cmdline, and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          opts = {},
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
            input = {},
          },
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
          kind_icons = {},
        },
        redirect = {
          view = "popup",
          filter = { event = "msg_show" },
        },
        commands = {
          history = {
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
          },
          last = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
            filter_opts = { count = 1 },
          },
          errors = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
        },
        notify = {
          enabled = true,
          view = "notify",
        },
        lsp = {
          progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = "mini",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            view = nil, -- when nil, use defaults from documentation
            opts = {},  -- merged with defaults from documentation
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true, -- automatically show signature help when typing a trigger character from the LSP
              luasnip = true, -- will open signature help when jumping to Luasnip insert nodes
              throttle = 50,  -- debounce lsp signature help request by 50ms
            },
            view = nil,       -- when nil, use defaults from documentation
            opts = {},        -- merged with defaults from documentation
          },
          message = {
            enabled = true,
            view = "notify",
            opts = {},
          },
          documentation = {
            view = "hover",
            opts = {
              lang = "markdown",
              replace = true,
              render = "plain",
              format = { "{message}" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
        },
        markdown = {
          hover = {
            ["|(%S-)|"] = vim.cmd.help,
            ["%[.-%]%((%S-)%)"] = require("noice.util").open,
          },
          highlights = {
            ["|%S-|"] = "@text.reference",
            ["@%S+"] = "@parameter",
            ["^%s*(Parameters:)"] = "@text.title",
            ["^%s*(Return:)"] = "@text.title",
            ["^%s*(See also:)"] = "@text.title",
            ["{%S-}"] = "@parameter",
          },
        },
        health = {
          checker = true,
        },
        smart_move = {
          enabled = true,
          excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = false,
        },
        throttle = 1000 / 30,
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>nl", function() require("noice").cmd("last") end, { desc = "Noice last message" })
      vim.keymap.set("n", "<leader>nh", function() require("noice").cmd("history") end, { desc = "Noice history" })
      vim.keymap.set("n", "<leader>na", function() require("noice").cmd("all") end, { desc = "Noice all" })
      vim.keymap.set("n", "<leader>nd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss all notifications" })
    end,
  },
}
