local map = vim.keymap.set

-- Modes:
--   n = normal
--   i = insert
--   v = visual
--   x = visual block
--   t = terminal
--   c = command

-- Helper function for better mapping
local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  map(mode, lhs, rhs, options)
end

-- Better window management
keymap("n", "<C-h>", "<C-w>h")                  -- Left window
keymap("n", "<C-j>", "<C-w>j")                  -- Down window
keymap("n", "<C-k>", "<C-w>k")                  -- Up window
keymap("n", "<C-l>", "<C-w>l")                  -- Right window
keymap("n", "<leader>sv", "<C-w>v")             -- Split vertically
keymap("n", "<leader>sh", "<C-w>s")             -- Split horizontally
keymap("n", "<leader>se", "<C-w>=")             -- Make splits equal
keymap("n", "<leader>sx", "<cmd>close<CR>")     -- Close current split
keymap("n", "<leader>z", "<C-w>|")              -- Toggle zoom (maximize width)
keymap("n", "<leader>Z", "<C-w>_")              -- Toggle zoom (maximize height)

-- Better navigation
keymap("n", "J", "mzJ`z")                       -- Join lines without moving cursor
keymap("n", "<C-d>", "<C-d>zz")                 -- Move half-page down & center
keymap("n", "<C-u>", "<C-u>zz")                 -- Move half-page up & center
keymap("n", "n", "nzzzv")                       -- Next search result & center
keymap("n", "N", "Nzzzv")                       -- Prev search result & center

-- Buffer navigation
keymap("n", "<leader>bp", "<cmd>bprevious<CR>") -- Previous buffer
keymap("n", "<leader>bn", "<cmd>bnext<CR>")     -- Next buffer
keymap("n", "<leader>bf", "<cmd>bfirst<CR>")    -- First buffer
keymap("n", "<leader>bl", "<cmd>blast<CR>")     -- Last buffer
keymap("n", "<leader>bd", "<cmd>bdelete<CR>")   -- Delete buffer

-- Better indenting
keymap("v", "<", "<gv")                         -- Stay in visual after indenting
keymap("v", ">", ">gv")                         -- Stay in visual after indenting

-- Move lines
keymap("n", "<A-j>", "<cmd>m .+1<CR>==")        -- Move line down in normal mode
keymap("n", "<A-k>", "<cmd>m .-2<CR>==")        -- Move line up in normal mode
keymap("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi") -- Move line down in insert mode
keymap("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi") -- Move line up in insert mode
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv")        -- Move selection down
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv")        -- Move selection up

-- Don't move cursor when joining lines
keymap("n", "J", "mzJ`z")

-- Paste without yanking in visual mode
keymap("x", "p", "\"_dP")

-- Clear search highlighting with ESC
keymap("n", "<ESC>", "<cmd>nohlsearch<CR>")

-- File explorer (will be replaced by a plugin)
keymap("n", "<leader>e", "<cmd>:Explore<CR>")

-- Quick save and quit
keymap("n", "<leader>w", "<cmd>w<CR>")          -- Save
keymap("n", "<leader>q", "<cmd>q<CR>")          -- Quit
keymap("n", "<leader>wq", "<cmd>wq<CR>")        -- Save and quit
keymap("n", "<leader>Q", "<cmd>qa!<CR>")        -- Force quit all

-- Pane resizing with leader keys (following existing patterns)
keymap("n", "<leader>rh", "<cmd>vertical resize -2<CR>")  -- Decrease width
keymap("n", "<leader>rj", "<cmd>resize +2<CR>")         -- Increase height
keymap("n", "<leader>rk", "<cmd>resize -2<CR>")         -- Decrease height
keymap("n", "<leader>rl", "<cmd>vertical resize +2<CR>")  -- Increase width

-- Larger resizing increments
keymap("n", "<leader>rH", "<cmd>vertical resize -10<CR>") -- Decrease width by 10
keymap("n", "<leader>rJ", "<cmd>resize +10<CR>")        -- Increase height by 10
keymap("n", "<leader>rK", "<cmd>resize -10<CR>")        -- Decrease height by 10
keymap("n", "<leader>rL", "<cmd>vertical resize +10<CR>") -- Increase width by 10

-- Reload configuration
keymap("n", "<leader>r", "<cmd>source $MYVIMRC<CR>")

-- Terminal mode mappings
keymap("t", "<ESC>", "<C-\\><C-n>")             -- Exit terminal with ESC
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")       -- Navigate from terminal
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })
