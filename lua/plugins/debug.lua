-- Debugging configuration using DAP (Debug Adapter Protocol)
return {
  -- Debug Adapter Protocol client for Neovim
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      "rcarriga/nvim-dap-ui",
      -- Required by nvim-dap-ui
      "nvim-neotest/nvim-nio",
      -- Virtual text for debug info
      "theHamsta/nvim-dap-virtual-text",
      -- Mason integration for managing debug adapters
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Set up language specific adapters
      -- Python
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }
      
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.exepath("python")
          end,
        },
      }
      
      -- Node.js / JavaScript / TypeScript
      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
      }
      
      dap.configurations.javascript = {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
      
      -- Make sure nvim-nio is required before dapui is setup
      local has_nio, nio = pcall(require, "nio")
      if not has_nio then
        vim.notify("nvim-nio not found, please install it for nvim-dap-ui to work", vim.log.levels.ERROR)
        return
      end
      
      -- DAP UI setup
      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "→",
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })
      
      -- Virtual text config
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        commented = false,
        only_first_definition = true,
        all_references = false,
        display_callback = function(variable, _buf, _stackframe, _node)
          return ' → ' .. variable.value
        end,
      })
      
      -- Mason DAP setup
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = {
          "python",
          "js",
          "node2",
          "chrome",
          "firefox",
        },
      })
      
      -- Events
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      -- Keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      keymap("n", "<leader>dc", dap.continue, { desc = "Continue" })
      keymap("n", "<leader>do", dap.step_over, { desc = "Step over" })
      keymap("n", "<leader>di", dap.step_into, { desc = "Step into" })
      keymap("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
      keymap("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
      keymap("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      keymap("n", "<leader>dl", function() 
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
      end, { desc = "Set log point" })
      keymap("n", "<leader>dB", function() 
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = "Set conditional breakpoint" })
    end,
  },
}