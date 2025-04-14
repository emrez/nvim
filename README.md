# Modern Neovim Configuration

A modern, feature-rich Neovim configuration using Lua. This setup includes sensible defaults, essential plugins, LSP integration, and more.

## Features

- 🎨 Catppuccin theme with true color support
- 🌲 File explorer with nvim-tree
- 🔍 Fuzzy finding with Telescope
- ✨ Syntax highlighting with Treesitter
- 🧠 LSP integration with auto-completion
- 🧩 Snippets with LuaSnip
- 📊 Beautiful status line with lualine
- 🔧 Sensible default settings
- ⌨️ Intuitive keymappings
- 🔌 Git integration
- 🖥️ Terminal integration
- 🏗️ Project management
- 💾 Session management
- 📝 Task management with TODO highlighting
- 🎣 Quick file navigation with Harpoon
- 🔄 Enhanced Git workflow with Diffview and Neogit
- 🔧 Debugging with DAP integration
- 📓 Note-taking with Obsidian and Telekasten
- 🛠️ Advanced code editing and refactoring tools
- 👁️ Beautiful UI improvements
- 🔍 Transparency support for modern terminals
- 🧪 And much more!

## Requirements

- Neovim 0.9.0 or higher
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional, but recommended)
- For telescope-fzf-native: `make` and a C compiler

## Installation

1. Backup your existing Neovim configuration (if any):

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this configuration:

```bash
mkdir -p ~/.config
cp -r /Users/emreacikgoz/Projects/nvim-config ~/.config/nvim
```

3. Run the setup script to install dependencies:

```bash
chmod +x ~/.config/nvim/setup.sh
~/.config/nvim/setup.sh
```

4. Start Neovim:

```bash
nvim
```

5. Install missing parsers:

```
:TSInstall regex jsonc
```

6. The plugin manager (lazy.nvim) will automatically install all plugins on the first run.

## Key Features and Plugins

### Core
- **lazy.nvim**: Modern plugin manager
- **plenary.nvim**: Required by many plugins

### Project Management
- **project.nvim**: Project detection and management
- **persistence.nvim**: Session management
- **neoconf.nvim**: Project-specific settings
- **todo-comments.nvim**: Highlight and search TODOs
- **overseer.nvim**: Task runner
- **workspaces.nvim**: Workspace management
- **harpoon**: Mark and quickly navigate between important files

### UI
- **catppuccin/nvim**: Beautiful and customizable theme
- **nvim-lualine/lualine.nvim**: Status line
- **nvim-tree/nvim-tree.lua**: File explorer
- **lukas-reineke/indent-blankline.nvim**: Indent guides

### Editor
- **nvim-treesitter**: Advanced syntax highlighting
- **nvim-telescope/telescope.nvim**: Fuzzy finder and more
- **windwp/nvim-autopairs**: Auto close pairs
- **numToStr/Comment.nvim**: Easy commenting
- **folke/which-key.nvim**: Key binding helper
- **akinsho/toggleterm.nvim**: Terminal integration

### Git
- **lewis6991/gitsigns.nvim**: Git integration

### LSP and Completion
- **neovim/nvim-lspconfig**: LSP configuration
- **williamboman/mason.nvim**: Package manager for LSP
- **hrsh7th/nvim-cmp**: Completion engine
- **L3MON4D3/LuaSnip**: Snippets engine

## Key Mappings

Space is the leader key. Some helpful mappings:

### General
- `<Space>w` - Save file
- `<Space>q` - Quit
- `<Space>wq` - Save and quit
- `<Space>Q` - Force quit all
- `<Space>r` - Reload configuration

### Navigation
- `<C-h/j/k/l>` - Navigate between windows
- `<Space>sv` - Split vertically
- `<Space>sh` - Split horizontally
- `<Space>se` - Make splits equal
- `<Space>sx` - Close current split

### Buffers
- `<Space>bp` - Previous buffer
- `<Space>bn` - Next buffer
- `<Space>bd` - Delete buffer

### File Explorer
- `<Space>e` - Toggle file explorer
- `<Space>o` - Focus file explorer

### Telescope
- `<Space>ff` - Find files
- `<Space>ft` - Find text (grep)
- `<Space>fb` - Find buffers
- `<Space>fh` - Find help
- `<Space>fd` - Find diagnostics

### LSP
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover information
- `<Space>rn` - Rename
- `<Space>ca` - Code action
- `<Space>f` - Format buffer
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<Space>ld` - Line diagnostics

### Git
- `<Space>gg` - Toggle Lazygit
- `<Space>hs` - Stage hunk
- `<Space>hr` - Reset hunk
- `<Space>hp` - Preview hunk
- `<Space>hb` - Blame line

### Terminal
- `<C-\>` - Toggle terminal
- `<Esc>` or `jk` - Exit terminal mode

### Theming
- `<Space>tt` - Toggle transparency

### Project Management
- `<Space>fp` - Find projects
- `<Space>pw` - Find workspaces
- `<Space>pa` - Add workspace
- `<Space>pt` - Toggle task list
- `<Space>pr` - Run task
- `<Space>ft` - Find TODOs

### Harpoon (File Navigation)
- `<Space>ha` - Add current file to harpoon
- `<Space>he` - Toggle harpoon quick menu
- `<Space>h1-9` - Jump to harpoon file 1-9
- `<Space>hp` - Navigate to previous harpoon file
- `<Space>hn` - Navigate to next harpoon file
- `<Space>fh` - Find harpoon marks with telescope

### Session Management
- `<Space>qs` - Restore session for current directory
- `<Space>ql` - Restore last session
- `<Space>qd` - Don't save current session

## Customization

Most configuration files are in the `lua/` directory:

- `lua/config/options.lua`: General Neovim settings
- `lua/config/keymaps.lua`: Key mappings
- `lua/config/autocmds.lua`: Autocommands
- `lua/plugins/init.lua`: Plugin configuration

## Troubleshooting

If you encounter issues:

1. Make sure your Neovim is up to date (0.9.0+)
2. Update plugins with `:Lazy update`
3. Check the health of your setup with `:checkhealth`
4. Run the setup script to install missing dependencies
5. If you find overlapping keybindings, check the `docs/keybinding-recommendations.md` file

Common Issues:

- **Missing Dependencies**: Run the setup.sh script to install required dependencies
- **Parser Errors**: Install missing parsers with `:TSInstall <parser-name>`
- **Keybinding Conflicts**: See `docs/keybinding-recommendations.md` for solutions

### Running Health Checks

To ensure your Neovim setup is working correctly, run a health check:

```
:checkhealth
```

This will check for common issues and provide recommendations for fixing them.

## License

This configuration is provided under the MIT License. Feel free to modify it to suit your needs!