-- In your lua/plugins/neorg.lua file
return {
  -- {
  --   "nvim-neorg/neorg",
  --       build = ":Neorg sync-parsers",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-treesitter/nvim-treesitter-textobjects",
  --     "hrsh7th/nvim-cmp", -- optional, for completion
  --     "nvim-telescope/telescope.nvim", -- optional, for telescope integration
  --   },
  --   cmd = "Neorg",
  --   ft = "norg",
  --   lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  --   version = "*", -- Pin Neorg to the latest stable release
  -- config = function()
  --     require("neorg").setup({
  --       load = {
  --         ["core.defaults"] = {}, -- Loads default behavior
  --         ["core.concealer"] = {  -- Adds pretty icons to your documents
  --           config = {
  --             icon_preset = "varied",
  --             icons = {
  --               todo = {
  --                 done = { icon = "✓" },
  --                 pending = { icon = "○" },
  --                 undone = { icon = "×" },
  --               },
  --             },
  --           },
  --         },
  --         ["core.dirman"] = { -- Manages Neorg workspaces
  --           config = {
  --             workspaces = {
  --               notes = "~/neorg/notes",
  --               personal = "~/neorg/personal",
  --               work = "~/neorg/work",
  --               projects = "~/neorg/projects",
  --             },
  --             default_workspace = "notes",
  --             index = "index.norg", -- The name of the main index file
  --           },
  --         },
  --         ["core.keybinds"] = { -- Configure core.keybinds
  --           config = {
  --             default_keybinds = true, -- Generate the default keybinds
  --             hook = function(keybinds)
  --               -- Define custom keybinds here
  --               keybinds.map("norg", "n", "n", "<cmd>Neorg keybind norg core.dirman.new.note<CR>")
  --               keybinds.map("norg", "n", "i", "<cmd>Neorg index<CR>")
  --               keybinds.map("norg", "n", "j", "<cmd>Neorg journal today<CR>")
  --               keybinds.map("norg", "n", "o", "<cmd>Neorg workspace<CR>")
  --               
  --               -- Toggle concealer (rendered vs source view)
  --               keybinds.map("norg", "n", "c", "<cmd>Neorg toggle-concealer<CR>")
  --               
  --               -- Links
  --               keybinds.map("norg", "n", "l", "<cmd>Neorg keybind norg core.norg.qol.insert_link<CR>")
  --               
  --               -- Navigation
  --               keybinds.map("norg", "n", "<leader>zf", "<cmd>Neorg keybind all core.esupports.hop.hop-link<CR>")
  --             end,
  --
  --           },
  --         },
  --         ["core.completion"] = {
  --           config = {
  --             engine = "nvim-cmp", -- Use nvim-cmp for completion
  --           },
  --         },
  --         ["core.journal"] = {
  --           config = {
  --             workspace = "notes",
  --             journal_folder = "journal",
  --             strategy = "flat", -- Save journal files in a flat structure
  --             use_template = true,
  --             template_name = "journal.norg", -- The journal template to use
  --           },
  --         },
  --         ["core.esupports.metagen"] = {
  --           config = {
  --             type = "auto", -- Generate metadata automatically
  --           },
  --         },
  --         ["core.qol.toc"] = {}, -- Adds table of contents support
  --         -- ["core.presenter"] = {}, -- For creating presentations
  --         ["core.export"] = {}, -- Export to different formats
  --         ["core.export.markdown"] = {
  --           config = {
  --             extensions = "all", -- Export all extensions
  --           },
  --         },
  --         -- Removing problematic integrations
  --         ["core.ui.calendar"] = {}, -- Calendar view
  --       },
  --     })
  --   end,
  -- },
    {
    "renerocksai/telekasten.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local home = vim.fn.expand("~/zettelkasten") -- Set your notes directory here
      
      require('telekasten').setup({
        -- Directory Settings
        home = home,
        take_over_my_home = true, -- Makes telekasten own the directory
        dailies = home .. "/" .. "daily", -- Daily notes directory
        weeklies = home .. "/" .. "weekly", -- Weekly notes directory
        templates = home .. "/" .. "templates", -- Templates directory
        
        -- Template settings
        template_new_note = home .. "/" .. "templates/new_note.md",
        template_new_daily = home .. "/" .. "templates/daily.md",
        template_new_weekly = home .. "/" .. "templates/weekly.md",
        
        -- File formatting
        extension = ".md", -- File extension for notes
        new_note_filename = "note-%Y%m%d%H%M", -- Format for new notes
        uuid_type = "%Y%m%d%H%M", -- Format for UUID timestamp
        uuid_sep = "-", -- Separator for UUID
        filename_case = "lowercase", -- lowercase/uppercase for filenames
        
        -- Link formatting
        preferred_link_style = "wiki", -- wiki, markdown
        wiki_link_func = function(text)
          return "[[" .. text .. "]]"
        end,
        markdown_link_func = function(text, path, desc)
          return "[" .. desc .. "](" .. path .. ")"
        end,
        
        -- Image settings
        image_subdir = "img", -- subdirectory for images
        image_link_style = "markdown", -- markdown [text](path), wiki ![text](path)
        
        -- Custom command for notes lookup
        command_palette_theme = "dropdown", -- Theme for command palette
        
        -- Customize your own actions
        follow_creates_nonexisting = true, -- Create non-existent notes when following links
        dailies_create_nonexisting = true, -- Create non-existent daily notes
        weeklies_create_nonexisting = true, -- Create non-existent weekly notes
      })
      
      -- Set up keybindings with <leader>z prefix to match our Neorg setup
      -- Ensure these don't conflict if you're using both systems
      vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>", { desc = "Find notes" })
      vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", { desc = "Search notes content" })
      vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", { desc = "Daily note" })
      vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>", { desc = "Follow link" })
      vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", { desc = "New note" })
      vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>", { desc = "Show calendar" })
      vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", { desc = "Show backlinks" })
      vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", { desc = "Insert image link" })
      vim.keymap.set("n", "<leader>zT", "<cmd>Telekasten show_tags<CR>", { desc = "Show tags" })
      vim.keymap.set("n", "<leader>zt", "<cmd>Telekasten toggle_todo<CR>", { desc = "Toggle todo" })
      
      -- Insert mode mappings
      vim.keymap.set("i", "<C-l>", "<cmd>Telekasten insert_link<CR>", { desc = "Insert link" })
      
      -- Optional Markdown concealer (for formatting)
      vim.g.telekasten_concealer = true
      
      -- Set up auto-commands for Telekasten files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          if string.find(vim.fn.expand("%:p"), home) then
            -- Enable spell checking for notes
            vim.opt_local.spell = true
            vim.opt_local.spelllang = "en_us"
            
            -- Set up additional markdown filetype specific options
            vim.opt_local.conceallevel = 2
          end
        end
      })
    end,
  }
}

