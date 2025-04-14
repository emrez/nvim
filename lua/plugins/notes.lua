-- Note-taking and knowledge management
return {
  -- Obsidian integration
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",
  --   lazy = true,
  --   ft = "markdown",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   config = function()
  --     require("obsidian").setup({
  --       workspaces = {
  --         {
  --           name = "personal",
  --           path = "~/Documents/Notes/Personal",
  --         },
  --         {
  --           name = "work",
  --           path = "~/Documents/Notes/Work",
  --         },
  --       },
  --       
  --       -- Optional, completion of wiki links, local markdown links, and tags.
  --       completion = {
  --         nvim_cmp = true,
  --         min_chars = 2,
  --       },
  --       
  --       -- Optional, configure key mappings for obsidian.nvim. These are the defaults.
  --       mappings = {
  --         -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
  --         ["gf"] = {
  --           action = function()
  --             return require("obsidian").util.gf_passthrough()
  --           end,
  --           opts = { noremap = false, expr = true, buffer = true },
  --         },
  --         -- Toggle checkboxes.
  --         ["<leader>ch"] = {
  --           action = function()
  --             return require("obsidian").util.toggle_checkbox()
  --           end,
  --           opts = { buffer = true },
  --         },
  --       },
  --       
  --       -- Optional, customize the backlinks interface.
  --       backlinks = {
  --         height = 10,
  --         wrap = true,
  --       },
  --       
  --       -- Optional, customize the tags interface.
  --       tags = {
  --         height = 10,
  --         wrap = true,
  --       },
  --       
  --       -- Optional, customize the hover interface.
  --       hover = {
  --         max_width = 80,
  --         max_height = 20,
  --         wrap = true,
  --       },
  --       
  --       -- Optional, customize the templates interface.
  --       templates = {
  --         folder = "templates",
  --         date_format = "%Y-%m-%d",
  --         time_format = "%H:%M",
  --         -- A table of substitutions to apply to templates.
  --         substitutions = {
  --           -- For example: today = function() return os.date("%Y-%m-%d") end,
  --         },
  --       },
  --       
  --       -- Optional, configure note frontmatter.
  --       -- Use with `ObsidianNewNote` to generate frontmatter automatically.
  --       note_frontmatter_func = function(note)
  --         local out = {
  --           id = note.id,
  --           aliases = note.aliases,
  --           tags = note.tags,
  --           created = os.date("%Y-%m-%d"),
  --         }
  --         
  --         if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
  --           for k, v in pairs(note.metadata) do
  --             out[k] = v
  --           end
  --         end
  --         
  --         return out
  --       end,
  --       
  --       -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
  --       -- URL it will be ignored but you can customize this behavior here.
  --       follow_url_func = function(url)
  --         -- Open the URL in the default web browser.
  --         vim.fn.jobstart({"open", url})  -- Mac OS
  --         -- vim.fn.jobstart({"xdg-open", url})  -- linux
  --       end,
  --       
  --       -- Optional, set to true if you use the Obsidian Advanced URI plugin.
  --       -- https://github.com/Vinzent03/obsidian-advanced-uri
  --       use_advanced_uri = true,
  --       
  --       -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
  --       open_app_foreground = false,
  --       
  --       picker = {
  --         -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
  --         name = "telescope.nvim",
  --         -- Optional, configure telescope.nvim.
  --         telescope = {
  --           -- See telescope.nvim documentation for picker.
  --           mappings = {
  --             -- Create a new note from your query.
  --             i = {
  --               ["<C-y>"] = function() return true end,
  --             },
  --           },
  --         },
  --       },
  --       
  --       -- Sort search results by "path", "modified", "accessed", or "created".
  --       sort_by = "modified",
  --       
  --       -- Sort search results in "ascending" or "descending" order.
  --       sort_order = "descending",
  --       
  --       -- Optional, configure additional syntax highlighting for obsidian.nvim.
  --       ui = {
  --         enable = true,
  --         update_debounce = 200,
  --         checkboxes = {
  --           -- Use prettier checkbox symbols in the UI.
  --           [" "] = { char = "☐", hl_group = "ObsidianTodo" },
  --           ["x"] = { char = "✓", hl_group = "ObsidianDone" },
  --           [">"] = { char = "❯", hl_group = "ObsidianRightArrow" },
  --           ["~"] = { char = "~", hl_group = "ObsidianTilde" },
  --         },
  --         -- Apply bullet colors to match obsidian.md.
  --         bullets = { char = "•", hl_group = "ObsidianBullet" },
  --         external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
  --         -- Replace the above with this if you don't have a patched font:
  --         -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
  --         reference_text = { hl_group = "ObsidianRefText" },
  --         highlight_text = { hl_group = "ObsidianHighlightText" },
  --         tags = { hl_group = "ObsidianTag" },
  --         codeblock = {
  --           -- Highlights markdown punctuations of a codeblock, like: ```foo ``` ```
  --           hl_group = "ObsidianCodeBlockPunctuation",
  --         },
  --         hl_groups = {
  --           -- The following are default highlight groups. Feel free to customize them.
  --           ObsidianTodo = { bold = true, fg = "#f78c6c" },
  --           ObsidianDone = { bold = true, fg = "#89ddff" },
  --           ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
  --           ObsidianTilde = { bold = true, fg = "#ff5370" },
  --           ObsidianBullet = { bold = true, fg = "#89ddff" },
  --           ObsidianRefText = { underline = true, fg = "#c792ea" },
  --           ObsidianExtLinkIcon = { fg = "#c792ea" },
  --           ObsidianTag = { italic = true, fg = "#89ddff" },
  --           ObsidianHighlightText = { bg = "#75662e" },
  --           ObsidianCodeBlockPunctuation = { fg = "#89ddff" },
  --         },
  --       },
  --       
  --       -- Keymaps
  --       attachments = {
  --         img_folder = "assets/imgs",  -- This is the default.
  --         use_folded_img_title = false,  -- This will use the old way to insert images.
  --         insert_mode_img_using_clipboard_cmd = {
  --           mac = "pngpaste $IMG_PATH",
  --           linux = "xclip -selection clipboard -t image/png -o > $IMG_PATH",
  --         },
  --       },
  --     })
  --     
  --     -- Custom keymaps
  --     local keymap = vim.keymap.set
  --     
  --     -- Create a new note
  --     keymap("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New Obsidian note" })
  --     
  --     -- Open quick switcher
  --     keymap("n", "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Find Obsidian notes" })
  --     
  --     -- Search in vault
  --     keymap("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search in Obsidian vault" })
  --     
  --     -- Follow link under cursor
  --     keymap("n", "<leader>oo", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow Obsidian link" })
  --     
  --     -- Create a link to a note
  --     keymap("n", "<leader>ol", "<cmd>ObsidianLink<CR>", { desc = "Create Obsidian link" })
  --     
  --     -- Create a link to a note, using the current selection as the link text
  --     keymap("v", "<leader>ol", "<cmd>ObsidianLinkNew<CR>", { desc = "Create Obsidian link from selection" })
  --     
  --     -- Open graph view
  --     keymap("n", "<leader>og", "<cmd>ObsidianBacklinks<CR>", { desc = "Show Obsidian backlinks" })
  --     
  --     -- Add the current file to the list of workspace files
  --     keymap("n", "<leader>oa", "<cmd>ObsidianWorkspace add<CR>", { desc = "Add to Obsidian workspace" })
  --     
  --     -- Show tags
  --     keymap("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "Show Obsidian tags" })
  --     
  --     -- Insert a template in the current note
  --     keymap("n", "<leader>oi", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian template" })
  --     
  --     -- Show daily note
  --     keymap("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Open today's note" })
  --     
  --     -- Show yesterday's daily note
  --     keymap("n", "<leader>oy", "<cmd>ObsidianYesterday<CR>", { desc = "Open yesterday's note" })
  --     
  --     -- Show tomorrow's daily note
  --     keymap("n", "<leader>om", "<cmd>ObsidianTomorrow<CR>", { desc = "Open tomorrow's note" })
  --   end,
  -- },
  
  -- Telekasten - Zettelkasten in Telescope
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telekasten").setup({
        home = vim.fn.expand("~/zettelkasten"),  -- Directory containing notes
        
        -- Optional, if you keep notes in a specific subdirectory
        take_over_my_home = true,
        
        -- Auto-set filetype to markdown
        auto_set_filetype = true,
        
        -- Customize the Telekasten directory structure
        dailies = vim.fn.expand("~/zettelkasten/daily"),
        weeklies = vim.fn.expand("~/zettelkasten/weekly"),
        templates = vim.fn.expand("~/zettelkasten/templates"),
        
        -- Template for new notes
        template_new_note = vim.fn.expand("~/zettelkasten/templates/new_note.md"),
        
        -- Template for new daily notes
        template_new_daily = vim.fn.expand("~/zettelkasten/templates/daily.md"),
        
        -- Template for new weekly notes
        template_new_weekly = vim.fn.expand("~/zettelkasten/templates/weekly.md"),
        
        -- Images subdir for pasting
        image_subdir = "img",
        
        -- Customize the prefix and extension of new notes
        uuid_type = "%Y%m%d%H%M",
        uuid_sep = "-",
        extension = ".md",
        -- Prefix for markdown links: "[]" for links [MyLink](path/to/file.md) or "wiki" for links [[MyLink]]
        preferred_link_style = "wiki",
        
        -- Integration with calendar-vim
        plug_into_calendar = true,
        calendar_opts = {
          -- Calendar week display mode: 1 for week starting Monday, 0 for Sunday
          weeknm = 1,
          -- Use calendar in Telekasten's home dir
          calendar_monday = 1,
          -- Create directories automatically when needed
          calendar_mark = "left-fit",
        },
        
        -- Telescope integration
        close_after_yanking = false,
        insert_after_inserting = true,
        
        -- Tag notation: "#tag" or ":tag:"
        tag_notation = "#tag",
        
        -- command palette theme: dropdown, ivy, or cursor
        command_palette_theme = "ivy",
        
        -- Subdirectory for new notes (relative to home)
        new_note_location = "notes",
        -- Should all notes be placed in subdirectories?
        subdirs_in_links = false,
        
        -- Rename notes using Telescope
        show_tags_theme = "ivy",
        
        -- Template string to use for renaming files with the cursor on the title
        rename_with_cursor = "{{title}}",
        
        -- Use syntax highlighting in markdown preview
        previewer_cmd = "glow",
        preview_in_splits = false,
        
        -- how to preview media files
        follow_creates_nonexisting = true,
        dailies_create_nonexisting = true,
        weeklies_create_nonexisting = true,
        
        -- skip telescope entries: "dropdown", "true" or "false"
        skip_unnamed = true,
        
        -- Customize media link style: text with file in brackets [[media link|path/to/media.jpg]] 
        media_previewer = "telescope-media-files",
        
        -- Use a custom date format
        journal_auto_open = false,
        
        -- Customize markdown checkboxes
        vaults = {
            vault2 = {
                -- Alternative directory for notes
                home = vim.fn.expand("~/vault2"),
            },
        },
        
        -- Control what happens when hitting enter on a link: "default", "vsplit", "hsplit", "tabnew"
        link_target = "default",
        
        -- Make syntax available to markdown buffers and telescope previewers
        install_syntax = true,
        
        -- Keymaps
        -- See default keymaps in the plugin documentation
      })
      
      -- Set up custom keymaps
      local keymap = vim.keymap.set
      
      -- Find notes
      keymap("n", "<leader>zf", function() require("telekasten").find_notes() end, { desc = "Find notes" })
      
      -- Search in notes
      keymap("n", "<leader>zs", function() require("telekasten").search_notes() end, { desc = "Search notes" })
      
      -- Create a new note
      keymap("n", "<leader>zn", function() require("telekasten").new_note() end, { desc = "New note" })
      
      -- Create a new note based on the selection
      keymap("v", "<leader>zn", function() require("telekasten").new_note({ selection = true }) end, { desc = "New note from selection" })
      
      -- Follow link under cursor
      keymap("n", "<leader>zg", function() require("telekasten").follow_link() end, { desc = "Follow link" })
      
      -- Go back to the previous note
      keymap("n", "<leader>zb", function() require("telekasten").browse_notes() end, { desc = "Back" })
      
      -- Insert a link to a note
      keymap("n", "<leader>zl", function() require("telekasten").insert_link() end, { desc = "Insert link" })
      
      -- Show tags
      keymap("n", "<leader>zt", function() require("telekasten").show_tags() end, { desc = "Show tags" })
      
      -- Show backlinks
      keymap("n", "<leader>zr", function() require("telekasten").show_backlinks() end, { desc = "Show backlinks" })
      
      -- Show note overview
      keymap("n", "<leader>zv", function() require("telekasten").show_note_overview() end, { desc = "Note overview" })
      
      -- Create today's daily note
      keymap("n", "<leader>zd", function() require("telekasten").goto_today() end, { desc = "Today's note" })
      
      -- Create a new weekly note
      keymap("n", "<leader>zw", function() require("telekasten").goto_thisweek() end, { desc = "Weekly note" })
      
      -- Find diary notes
      keymap("n", "<leader>zD", function() require("telekasten").find_daily_notes() end, { desc = "Find daily notes" })
      
      -- Find weekly notes
      keymap("n", "<leader>zW", function() require("telekasten").find_weekly_notes() end, { desc = "Find weekly notes" })
      
      -- Rename the current note
      keymap("n", "<leader>zR", function() require("telekasten").rename_note() end, { desc = "Rename note" })
      
      -- Toggle to-do item under cursor
      keymap("n", "<leader>zt", function() require("telekasten").toggle_todo() end, { desc = "Toggle todo" })
      
      -- Preview the current note
      keymap("n", "<leader>zp", function() require("telekasten").preview() end, { desc = "Preview note" })
    end,
  },
}
