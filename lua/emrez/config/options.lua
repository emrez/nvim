-- Global options
local opt = vim.opt

-- UI settings
opt.number = true                -- Line numbers
opt.relativenumber = true        -- Relative line numbers
opt.cursorline = true            -- Highlight current line
opt.termguicolors = true         -- True color support
opt.signcolumn = "yes"           -- Always show sign column
opt.showmode = false             -- Don't show mode (we'll use a statusline instead)
opt.laststatus = 3               -- Global statusline
opt.cmdheight = 1                -- Command line height
opt.scrolloff = 8                -- Lines above/below cursor when scrolling
opt.sidescrolloff = 8            -- Columns left/right of cursor when scrolling
opt.list = true                  -- Show some invisible characters
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Behavior
opt.hidden = true                -- Allow background buffers
opt.clipboard = "unnamedplus"    -- Use system clipboard
opt.ignorecase = true            -- Ignore case when searching
opt.smartcase = true             -- Don't ignore case when search includes uppercase
opt.smartindent = true           -- Auto indent new lines
opt.expandtab = true             -- Use spaces instead of tabs
opt.tabstop = 2                  -- Tab width
opt.shiftwidth = 2               -- Indent width
opt.wrap = false                 -- Don't wrap lines
opt.breakindent = true           -- Preserve indent on wrapped lines
opt.undofile = true              -- Persistent undo
opt.updatetime = 250             -- Faster completion
opt.timeoutlen = 300             -- Shorter timeout for key sequences
opt.completeopt = "menuone,noselect" -- Completion options
opt.splitright = true            -- Open vertical splits to the right
opt.splitbelow = true            -- Open horizontal splits below
opt.showmatch = true             -- Show matching brackets
opt.mouse = "a"                  -- Enable mouse in all modes

-- Disable some built-in plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Global variables
vim.g.mapleader = " "           -- Set leader key to space
vim.g.maplocalleader = ","      -- Set local leader key to comma
