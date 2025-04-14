# Harpoon: Quick File Navigation

Harpoon is a powerful Neovim plugin that allows you to mark important files and quickly navigate between them. This guide explains how to use Harpoon in your configuration.

## What is Harpoon?

Harpoon solves a common problem: how to quickly switch between a small set of files you're actively working on. Rather than using buffer navigation or fuzzy finding repeatedly, you can "harpoon" (mark) files you're working with and jump to them with simple keybindings.

## Key Features

- Mark any file with a single keystroke
- Quickly navigate between marked files
- Persistent marks (saved between sessions)
- Project-specific marks
- Telescope integration

## Basic Usage

### Marking Files

1. Navigate to a file you want to mark
2. Press `<Space>ha` to add the current file to Harpoon

### Navigating Between Marks

There are several ways to navigate between your marked files:

- Press `<Space>he` to open the Harpoon quick menu, showing all marked files
- Press `<Space>h1` through `<Space>h9` to jump directly to the 1st through 9th marked file
- Press `<Space>hp` to navigate to the previous marked file
- Press `<Space>hn` to navigate to the next marked file
- Press `<Space>fh` to open a Telescope interface to find and select harpoon marks

## Workflow Examples

### Feature Development

When working on a new feature, you might have several related files open:

1. `feature_controller.py` - The controller handling requests
2. `feature_model.py` - The data model
3. `feature_view.py` - The view/template
4. `feature_test.py` - Tests for the feature

Mark each of these files with `<Space>ha`, and then you can quickly jump between them:

- `<Space>h1` to jump to controller
- `<Space>h2` to jump to model
- `<Space>h3` to jump to view
- `<Space>h4` to jump to tests

### Debugging

When debugging across multiple files:

1. Mark the file with the bug using `<Space>ha`
2. Mark other files you need to reference during debugging
3. Quickly switch between these files using `<Space>h1`, `<Space>h2`, etc.
4. Use `<Space>hp` and `<Space>hn` to cycle through marked files while investigating

## Tips and Tricks

1. **Organize your marks logically**: The order in which you add files matters, as they'll be assigned numbers sequentially
2. **Use project-specific marks**: Harpoon keeps different mark lists for different projects (based on git repositories)
3. **Re-order marks**: In the quick menu, you can move marks up and down using `<Ctrl-p>` and `<Ctrl-n>`
4. **Remove marks**: In the quick menu, you can remove a mark by pressing `<Ctrl-d>`
5. **Limit your marks**: It's more effective to keep a small, focused set of marks (4-6) rather than marking many files

## Integration with Other Plugins

### Telescope Integration

You can use `<Space>fh` to search through your marked files using Telescope.

### Project.nvim Integration

Harpoon automatically works with project.nvim, detecting the git root directory to keep project-specific harpoon marks.

## Key Mappings

Here are all the key mappings for Harpoon in this configuration:

| Mapping | Description |
|---------|-------------|
| `<Space>ha` | Add current file to harpoon |
| `<Space>he` | Toggle harpoon quick menu |
| `<Space>h1` to `<Space>h9` | Jump to harpoon file 1-9 |
| `<Space>hp` | Navigate to previous harpoon file |
| `<Space>hn` | Navigate to next harpoon file |
| `<Space>fh` | Find harpoon marks with telescope |

## Advanced Configuration

If you want to customize Harpoon further, edit the `lua/plugins/harpoon.lua` file. You can change:

- UI appearance (width, height, border style)
- Key detection strategy
- Integration with other plugins
- Key mappings