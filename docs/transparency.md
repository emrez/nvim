# Transparency in Neovim

This documentation explains how to use and customize the transparency feature in your Neovim configuration.

## What is Transparency?

Transparency allows Neovim's background to be transparent, showing your terminal background through it. This creates a more integrated look with your terminal environment and can make your setup more visually appealing.

## Enabling and Disabling Transparency

### Using Commands

You can control transparency with these commands:

```vim
:TransparencyEnable   " Enable transparency
:TransparencyDisable  " Disable transparency
:TransparencyToggle   " Toggle transparency on/off
```

### Using Keybindings

The default keybinding for toggling transparency is:

```
<Space>tt
```

This will switch between transparent and opaque mode.

## How It Works

This configuration provides transparency through two complementary systems:

1. **Custom Transparency Module**: A Lua module that sets highlight groups to have transparent backgrounds
2. **transparent.nvim Plugin**: A dedicated plugin that provides additional transparency options

The transparency affects most UI elements, including:
- Main editor area
- Sidebars and panels
- Popup windows and floating menus
- Status lines

## Compatibility with Terminal Emulators

For transparency to work correctly, your terminal emulator must support transparency. Popular terminal emulators that support transparency include:

- iTerm2
- Alacritty
- Kitty
- Windows Terminal
- GNOME Terminal
- Konsole

You may need to configure your terminal emulator to have a transparent or semi-transparent background first.

## Customizing Transparency

### Adjusting Transparent Elements

If you want to customize which UI elements are transparent, you can edit the `transparent.nvim` configuration in `lua/plugins/transparency.lua`.

### Managing Transparency on Startup

By default, transparency is disabled on startup. If you want transparency to be enabled by default when you start Neovim, add this line to your `init.lua`:

```lua
-- Enable transparency on startup
vim.defer_fn(function() require('config.transparent').enable() end, 100)
```

## Troubleshooting

### Transparency Not Working

If transparency doesn't work:

1. Check if your terminal emulator supports transparency
2. Ensure your terminal background is actually transparent
3. Try running `:TransparencyEnable` manually
4. Check if your colorscheme supports transparency

### Elements Not Transparent

If certain UI elements aren't transparent:

1. Run `:highlight` to see current highlight groups
2. Add the non-transparent highlight groups to the configuration in `lua/plugins/transparency.lua`

## Recommended Terminal Configurations

For best results with transparency:

### iTerm2
- Go to Profiles → Window → Transparency
- Set to around 10-20% for subtle transparency

### Alacritty
Add to your `alacritty.yml`:
```yaml
window:
  opacity: 0.9
```

### WezTerm
Add to your `wezterm.lua` configuration:
```lua
local wezterm = require('wezterm')

return {
  -- Enable GPU acceleration for smooth rendering
  front_end = "WebGpu", -- or "OpenGL" if WebGpu causes issues
  
  -- Background settings
  window_background_opacity = 0.9, -- Adjust between 0.8-0.95 for best results
  
  -- Color scheme configuration
  color_scheme = "Catppuccin Mocha", -- Matches our Neovim theme
  
  -- Window padding (helps with the aesthetic)
  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },
  
  -- Disable window decorations for a cleaner look
  window_decorations = "RESIZE",
  
  -- If you want rounded corners (macOS and some Linux)
  -- window_background_corner_radius = 8.0,
  
  -- Better font rendering for transparency
  font_antialias = "Subpixel", 
  
  -- Recommended: Custom font that renders well with transparency
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 14.0,
  
  -- For better performance with transparency
  animation_fps = 60,
  max_fps = 60,
  
  -- Eliminate flickering with transparency
  adjust_window_size_when_changing_font_size = false,
}
```