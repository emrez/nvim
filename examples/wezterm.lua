-- Sample WezTerm configuration for optimal Neovim transparency
local wezterm = require('wezterm')

-- For newer versions of WezTerm, use the config builder pattern
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Basic settings
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 14.0

-- GPU acceleration (crucial for smooth transparency)
config.front_end = "WebGpu"  -- Use "OpenGL" as fallback if needed

-- Transparency settings
config.window_background_opacity = 0.92  -- Adjust to taste (0.85-0.95 works well)
config.macos_window_background_blur = 20 -- For macOS, adds subtle blur

-- Window decorations and appearance
config.window_decorations = "NONE"  -- Completely hide title bar and borders
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- If you're on macOS or Linux with compositor, enable rounded corners
if wezterm.target_triple == "aarch64-apple-darwin" or 
   wezterm.target_triple == "x86_64-apple-darwin" then
  config.window_background_corner_radius = 10
end

-- Performance optimizations for transparent windows
config.animation_fps = 60
config.max_fps = 120  -- Higher for smoother experience

-- Hide tab bar when only one tab is open (cleaner borderless look)
config.hide_tab_bar_if_only_one_tab = true

-- Tab bar appearance (when visible)
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_max_width = 25

-- Prevent UI flickering
config.adjust_window_size_when_changing_font_size = false

-- Better font rendering with transparency
config.font_antialias = "Subpixel"
config.freetype_load_target = "Light" -- "Light" or "Normal" for different rendering

-- Custom behavior that works better with Neovim transparency
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"

-- Set TERM_PROGRAM so Neovim can detect WezTerm
config.set_environment_variables = {
  TERM_PROGRAM = "WezTerm",
  TERM = "wezterm",
}

-- Set tab bar to match Neovim's transparent theme
config.colors = config.colors or {}
config.colors.tab_bar = {
  background = "rgba(0,0,0,0)",  -- Transparent background
  active_tab = {
    bg_color = "rgba(30,30,46,0.7)", -- Slightly visible
    fg_color = "#cdd6f4",
    intensity = "Normal",
    underline = "None",
    italic = false,
    strikethrough = false,
  },
  inactive_tab = {
    bg_color = "rgba(24,24,37,0.4)", -- More transparent for inactive
    fg_color = "#a6adc8",
    intensity = "Normal",
    underline = "None",
    italic = false,
    strikethrough = false,
  },
}

-- Scrolling behavior
config.enable_scroll_bar = false
config.scrollback_lines = 10000
config.scroll_to_bottom_on_input = true

-- Custom key bindings for window management (essential with hidden title bar)
config.keys = {
  -- Alt+Enter to toggle fullscreen
  { key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },
  
  -- Ctrl+Shift+F to toggle fullscreen
  { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },
  
  -- Resize with keyboard
  { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ActivateKeyTable { name = "resize_pane", one_shot = false } },
  
  -- Move window with keyboard when title bar is hidden
  { key = "m", mods = "CTRL|SHIFT", action = wezterm.action.ActivateKeyTable { name = "move_window", one_shot = false } },
  
  -- Quick split actions
  { key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "_", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
}

-- Define key tables for resize and move modes
config.key_tables = {
  -- Resize mode activated with CTRL+SHIFT+R
  resize_pane = {
    { key = "LeftArrow", action = wezterm.action.AdjustPaneSize { "Left", 1 } },
    { key = "h", action = wezterm.action.AdjustPaneSize { "Left", 1 } },
    
    { key = "RightArrow", action = wezterm.action.AdjustPaneSize { "Right", 1 } },
    { key = "l", action = wezterm.action.AdjustPaneSize { "Right", 1 } },
    
    { key = "UpArrow", action = wezterm.action.AdjustPaneSize { "Up", 1 } },
    { key = "k", action = wezterm.action.AdjustPaneSize { "Up", 1 } },
    
    { key = "DownArrow", action = wezterm.action.AdjustPaneSize { "Down", 1 } },
    { key = "j", action = wezterm.action.AdjustPaneSize { "Down", 1 } },
    
    -- Cancel with Escape
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
  
  -- Move window mode activated with CTRL+SHIFT+M
  move_window = {
    { key = "LeftArrow", action = wezterm.action.MoveWindow { "Left", 50 } },
    { key = "h", action = wezterm.action.MoveWindow { "Left", 50 } },
    
    { key = "RightArrow", action = wezterm.action.MoveWindow { "Right", 50 } },
    { key = "l", action = wezterm.action.MoveWindow { "Right", 50 } },
    
    { key = "UpArrow", action = wezterm.action.MoveWindow { "Up", 50 } },
    { key = "k", action = wezterm.action.MoveWindow { "Up", 50 } },
    
    { key = "DownArrow", action = wezterm.action.MoveWindow { "Down", 50 } },
    { key = "j", action = wezterm.action.MoveWindow { "Down", 50 } },
    
    -- Cancel with Escape
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
}

return config