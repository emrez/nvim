-- Python utility functions
local M = {}

-- Run current Python file with the correct interpreter
function M.run_current_file()
  local python_path = M.get_python_path()
  local file_path = vim.fn.expand("%:p")
  
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("Current buffer is not a file or cannot be read", vim.log.levels.ERROR)
    return
  end
  
  if not string.match(file_path, ".py$") then
    vim.notify("Current file is not a Python file", vim.log.levels.ERROR)
    return
  end
  
  local cmd = string.format("%s %s", python_path, vim.fn.shellescape(file_path))
  vim.cmd("belowright 15split | terminal " .. cmd)
  vim.cmd("startinsert")
  
  vim.notify("Running: " .. cmd, vim.log.levels.INFO)
end

-- Find Python interpreter in UV virtual environment
function M.get_python_path()
  -- First, check for UV environment in current project
  local uv_venv = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(uv_venv) == 1 then
    return uv_venv
  end
  
  -- Check for UV environment in parent directories
  local parent_dir = vim.fn.getcwd()
  for _ = 1, 5 do  -- Check up to 5 levels up
    parent_dir = vim.fn.fnamemodify(parent_dir, ':h')
    local parent_venv = parent_dir .. "/.venv/bin/python"
    if vim.fn.executable(parent_venv) == 1 then
      return parent_venv
    end
  end
  
  -- Check for activated virtual environment
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  
  -- Fallback to system Python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- Run command with the correct Python interpreter
function M.run_with_python(cmd)
  local python_path = M.get_python_path()
  local command = python_path .. " " .. cmd
  vim.cmd("terminal " .. command)
end

-- Run a UV command with proper error handling
function M.run_uv_command(args)
  local cmd = "uv " .. args
  local result = vim.fn.system(cmd)
  
  if vim.v.shell_error ~= 0 then
    vim.notify("UV error: " .. result, vim.log.levels.ERROR)
    return false, result
  end
  
  vim.notify("UV command successful", vim.log.levels.INFO)
  return true, result
end

-- Detect project type and suggest UV setup
function M.detect_project()
  local files = {"pyproject.toml", "setup.py", "requirements.txt", "Pipfile", "poetry.lock"}
  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      vim.notify("Python project detected. Use :UvVenvCreate to set up a virtual environment.", vim.log.levels.INFO)
      return true
    end
  end
  return false
end

-- Check if current file is in a UV environment
function M.in_uv_environment()
  local python_path = M.get_python_path()
  return string.find(python_path, "/.venv/bin/python") ~= nil
end

-- Get the status of the current Python environment
function M.get_env_status()
  local python_path = M.get_python_path()
  local is_uv = string.find(python_path, "/.venv/bin/python") ~= nil
  local env_type = is_uv and "UV" or (vim.env.VIRTUAL_ENV and "venv" or "system")
  
  return {
    path = python_path,
    is_uv = is_uv,
    env_type = env_type,
    full_path = vim.fn.fnamemodify(python_path, ":p"),
  }
end

return M
