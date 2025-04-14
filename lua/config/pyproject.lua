-- Python project detection and auto-setup
local M = {}

function M.setup()
  -- Create auto-command group for Python project detection
  local python_group = vim.api.nvim_create_augroup("PythonProjectDetection", { clear = true })
  
  -- Auto-detect python project when opening a Python file
  vim.api.nvim_create_autocmd({"BufEnter", "BufNew"}, {
    pattern = {"*.py"},
    group = python_group,
    callback = function()
      -- Don't show notifications repeatedly
      if vim.b.python_project_detected then
        return
      end
      
      -- Try to detect a Python project
      local python_utils = require("utils.python")
      if python_utils.detect_project() then
        vim.b.python_project_detected = true
        
        -- Show environment status in statusline if using uv
        if python_utils.in_uv_environment() then
          local env_status = python_utils.get_env_status()
          vim.notify("Using UV environment: " .. env_status.full_path, vim.log.levels.INFO)
          vim.cmd("LspRestart")
          vim.cmd("PylspRestart")
          
        end
      end
    end
  })
  
  -- Create a command to display current Python environment info
  vim.api.nvim_create_user_command("PythonEnvInfo", function()
    local python_utils = require("utils.python")
    local env_status = python_utils.get_env_status()
    
    local info = {
      "Python Environment Information:",
      "Path: " .. env_status.full_path,
      "Type: " .. env_status.env_type
    }
    
    -- Display in a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, info)
    
    local width = 60
    local height = #info
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = "minimal",
      border = "rounded"
    })
    
    -- Set mappings to close the window
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", {noremap = true, silent = true})
    
    -- Highlight
    vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
  end, {})
  
  -- Create a command to run the current Python file
  vim.api.nvim_create_user_command("RunPythonFile", function()
    require("utils.python").run_current_file()
  end, { desc = "Run current Python file" })
  
  
  -- Add keymaps for Python commands
  vim.keymap.set("n", "<leader>vp", "<cmd>PythonEnvInfo<CR>", { desc = "Show Python env info" })
  vim.keymap.set("n", "<F5>", "<cmd>RunPythonFile<CR>", { desc = "Run current Python file" })
  vim.keymap.set("n", "<leader>vf", "<cmd>RunPythonFile<CR>", { desc = "Run current Python file" })
end

return M
