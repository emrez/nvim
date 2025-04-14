-- Python auto-imports utility functions
local M = {}

-- Helper function to check if a string starts with a specific prefix
local function starts_with(str, prefix)
  return string.sub(str, 1, string.len(prefix)) == prefix
end

-- Parse import lines from a Python file
function M.parse_imports(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local imports = {}
  local import_blocks = {}
  local current_block = {}
  local in_import_block = false

  for i, line in ipairs(lines) do
    if starts_with(line, "import ") or starts_with(line, "from ") then
      if not in_import_block then
        in_import_block = true
        current_block = {start = i}
      end
      table.insert(imports, {line = i, text = line})
    elseif in_import_block and (line == "" or not starts_with(line:gsub("^%s+", ""), "#")) then
      current_block.finish = i - 1
      table.insert(import_blocks, current_block)
      current_block = {}
      in_import_block = false
    end
  end

  -- Handle case where imports are at the end of the file
  if in_import_block then
    current_block.finish = #lines
    table.insert(import_blocks, current_block)
  end

  return imports, import_blocks
end

-- Add an import statement at the appropriate position
function M.add_import(import_statement)
  local bufnr = vim.api.nvim_get_current_buf()
  local imports, import_blocks = M.parse_imports(bufnr)
  
  -- Check if the import already exists
  for _, imp in ipairs(imports) do
    if imp.text == import_statement then
      vim.notify("Import already exists", vim.log.levels.INFO)
      return
    end
  end
  
  -- Find the appropriate position to add the import
  local insert_line = 1  -- Default to beginning of file
  
  -- If we have import blocks, add after the last one
  if #import_blocks > 0 then
    local last_block = import_blocks[#import_blocks]
    insert_line = last_block.finish + 1
  end
  
  -- Insert the import at the determined position
  vim.api.nvim_buf_set_lines(bufnr, insert_line - 1, insert_line - 1, false, {import_statement})
  vim.notify("Added import: " .. import_statement, vim.log.levels.INFO)
end

-- Organize imports to be in alphabetical order and grouped correctly
function M.organize_imports()
  local bufnr = vim.api.nvim_get_current_buf()
  local imports, import_blocks = M.parse_imports(bufnr)
  
  if #imports == 0 then
    vim.notify("No imports found", vim.log.levels.INFO)
    return
  end
  
  -- Extract all import lines
  local import_lines = {}
  for _, imp in ipairs(imports) do
    table.insert(import_lines, imp.text)
  end
  
  -- Group imports into standard lib, third-party, and local
  local stdlib_imports = {}
  local thirdparty_imports = {}
  local local_imports = {}
  
  -- Known standard library modules (a subset)
  local stdlib_modules = {
    "os", "sys", "re", "math", "time", "datetime", "collections", "random",
    "json", "csv", "logging", "pathlib", "traceback", "threading", "multiprocessing",
    "argparse", "unittest", "typing", "io", "tempfile", "urllib", "http", "socket"
  }
  
  local function is_stdlib(module)
    -- Extract the main module name from imports like "from X import Y"
    local main_module = module
    if module:find("from ") == 1 then
      main_module = module:match("from ([%w%.]+)")
      main_module = main_module:match("^([^%.]+)") -- Get first part before any dots
    elseif module:find("import ") == 1 then
      main_module = module:match("import ([%w%.]+)")
      main_module = main_module:match("^([^%.]+)") -- Get first part before any dots
    end
    
    for _, std_mod in ipairs(stdlib_modules) do
      if main_module == std_mod then
        return true
      end
    end
    return false
  end
  
  -- Categorize imports
  for _, imp in ipairs(import_lines) do
    if is_stdlib(imp) then
      table.insert(stdlib_imports, imp)
    elseif imp:find("from %.") == 1 or imp:find("from %w+%.%w+") == 1 then
      -- Relative imports or imports from submodules like 'from myapp.models'
      table.insert(local_imports, imp)
    else
      table.insert(thirdparty_imports, imp)
    end
  end
  
  -- Sort each category
  table.sort(stdlib_imports)
  table.sort(thirdparty_imports)
  table.sort(local_imports)
  
  -- Combine all imports with appropriate spacing
  local organized_imports = {}
  
  if #stdlib_imports > 0 then
    for _, imp in ipairs(stdlib_imports) do
      table.insert(organized_imports, imp)
    end
  end
  
  if #stdlib_imports > 0 and #thirdparty_imports > 0 then
    table.insert(organized_imports, "")  -- Add blank line between groups
  end
  
  if #thirdparty_imports > 0 then
    for _, imp in ipairs(thirdparty_imports) do
      table.insert(organized_imports, imp)
    end
  end
  
  if (#stdlib_imports > 0 or #thirdparty_imports > 0) and #local_imports > 0 then
    table.insert(organized_imports, "")  -- Add blank line between groups
  end
  
  if #local_imports > 0 then
    for _, imp in ipairs(local_imports) do
      table.insert(organized_imports, imp)
    end
  end
  
  -- Replace all import lines with organized ones
  if #import_blocks > 0 then
    local start_line = import_blocks[1].start - 1
    local end_line = import_blocks[#import_blocks].finish
    
    -- Delete all existing import lines
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, {})
    
    -- Insert organized imports
    vim.api.nvim_buf_set_lines(bufnr, start_line, start_line, false, organized_imports)
    
    vim.notify("Imports organized", vim.log.levels.INFO)
  end
end

-- Extract symbol from current word or selection
function M.get_current_symbol()
  local mode = vim.api.nvim_get_mode().mode
  local symbol = ""
  
  if mode == "v" or mode == "V" or mode == "" then
    -- Visual mode - get selected text
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
    
    if #lines == 1 then
      symbol = string.sub(lines[1], start_pos[3], end_pos[3])
    else
      symbol = string.sub(lines[1], start_pos[3])
      for i = 2, #lines - 1 do
        symbol = symbol .. "\n" .. lines[i]
      end
      symbol = symbol .. "\n" .. string.sub(lines[#lines], 1, end_pos[3])
    end
  else
    -- Normal mode - get word under cursor
    symbol = vim.fn.expand("<cword>")
  end
  
  return symbol
end

-- Prompt for import statement and add it
function M.prompt_import()
  local symbol = M.get_current_symbol()
  if symbol == "" then
    vim.notify("No symbol selected", vim.log.levels.WARN)
    return
  end
  
  local default_import = "from ? import " .. symbol
  local import_statement = vim.fn.input("Import statement: ", default_import)
  
  if import_statement ~= "" and import_statement ~= default_import then
    M.add_import(import_statement)
  end
end

-- Add a module name for a symbol based on common Python modules
function M.suggest_imports(symbol)
  local common_modules = {
    -- Standard library
    {"os", {"path", "environ", "getcwd", "makedirs", "remove", "listdir"}},
    {"sys", {"argv", "exit", "path", "modules", "version"}},
    {"datetime", {"datetime", "date", "time", "timedelta"}},
    {"random", {"random", "randint", "choice", "sample", "shuffle"}},
    {"json", {"loads", "dumps"}},
    {"re", {"match", "search", "findall", "sub", "compile"}},
    {"math", {"sqrt", "sin", "cos", "tan", "pi", "floor", "ceil", "fabs"}},
    {"collections", {"defaultdict", "Counter", "deque", "namedtuple", "OrderedDict"}},
    {"pathlib", {"Path"}},
    {"time", {"sleep", "time"}},
    {"typing", {"List", "Dict", "Tuple", "Optional", "Union", "Any", "Callable"}},
    
    -- Third-party libraries
    {"numpy", {"array", "zeros", "ones", "arange", "linspace", "random", "ndarray", "mean", "std", "max", "min"}},
    {"pandas", {"DataFrame", "Series", "read_csv", "read_excel", "concat", "merge"}},
    {"matplotlib.pyplot", {"plot", "figure", "subplot", "show", "imshow", "savefig", "title", "xlabel", "ylabel"}},
    {"requests", {"get", "post", "put", "delete", "session", "Response"}},
    {"torch", {"Tensor", "nn", "optim", "cuda", "load", "save", "from_numpy", "zeros", "ones"}},
    {"sklearn", {"train_test_split", "accuracy_score", "classification_report", "confusion_matrix"}},
    {"pytest", {"fixture", "mark", "raises", "approx", "parametrize"}},
    {"django.shortcuts", {"render", "redirect", "get_object_or_404"}},
    {"flask", {"Flask", "request", "jsonify", "render_template"}},
    {"sqlalchemy", {"Column", "Integer", "String", "create_engine", "ForeignKey", "relationship"}},
  }
  
  local suggestions = {}
  
  for _, mod in ipairs(common_modules) do
    local module_name = mod[1]
    local exports = mod[2]
    
    for _, export in ipairs(exports) do
      if export == symbol then
        table.insert(suggestions, {module = module_name, symbol = symbol})
      end
    end
  end
  
  return suggestions
end

-- Use the closest match for a symbol
function M.auto_import_symbol()
  local symbol = M.get_current_symbol()
  if symbol == "" then
    vim.notify("No symbol selected", vim.log.levels.WARN)
    return
  end
  
  local suggestions = M.suggest_imports(symbol)
  
  if #suggestions == 0 then
    vim.notify("No import suggestions for: " .. symbol, vim.log.levels.WARN)
    M.prompt_import()
    return
  elseif #suggestions == 1 then
    local import_statement = "from " .. suggestions[1].module .. " import " .. suggestions[1].symbol
    M.add_import(import_statement)
  else
    -- Multiple suggestions, let the user choose
    local import_options = {}
    for i, suggestion in ipairs(suggestions) do
      table.insert(import_options, i .. ". from " .. suggestion.module .. " import " .. suggestion.symbol)
    end
    
    vim.ui.select(import_options, {
      prompt = "Select import for " .. symbol .. ":",
      format_item = function(item) return item end,
    }, function(choice, idx)
      if not choice then return end
      
      local import_statement = "from " .. suggestions[idx].module .. " import " .. suggestions[idx].symbol
      M.add_import(import_statement)
    end)
  end
end

-- Generate import at the end of the import section
function M.append_import()
  local import_statement = vim.fn.input("Import statement: ", "import ")
  if import_statement ~= "" and import_statement ~= "import " then
    M.add_import(import_statement)
  end
end

return M
