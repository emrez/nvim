-- Harpoon configuration
-- Quickly jump between important files in your project
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    
    -- REQUIRED
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          -- Get git root dir for current buffer
          local git_dir = vim.fn.systemlist("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")[1]
          if vim.v.shell_error ~= 0 then
            -- Not in a git repo, use the current working directory
            return vim.fn.getcwd()
          else
            return git_dir
          end
        end,
      },
      -- Optional UI settings
      ui = {
        width = 80,
        height = 20,
        border = "rounded",
      }
    })

    -- Basic keymaps
    vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end,
      { desc = "Harpoon add file" })
    vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon quick menu" })

    -- Navigation - use <leader>h1-9 to jump to marked files
    for i = 1, 9 do
      vim.keymap.set("n", string.format("<leader>h%s", i), function()
        harpoon:list():select(i)
      end, { desc = string.format("Harpoon to file %s", i) })
    end

    -- Navigation using brackets (navigate through marked files in order)
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end,
      { desc = "Harpoon prev file" })
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end,
      { desc = "Harpoon next file" })

    -- Tell Telescope about Harpoon
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    -- Telescope integration
    vim.keymap.set("n", "<leader>fh", function() toggle_telescope(harpoon:list()) end,
      { desc = "Find harpoon marks" })
  end
}