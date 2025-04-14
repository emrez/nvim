# Python Auto-Import for Neovim

This document explains how to use the Python auto-import features in your Neovim configuration.

## Features

1. **Auto-Import Symbols**: Automatically add import statements for Python symbols
2. **Import Organization**: Sort and group imports by type (standard library, third-party, local)
3. **Import Suggestions**: Get suggestions for imports based on symbol names
4. **Enhanced Pyright Integration**: Improved LSP integration for better auto-import support

## Keybindings

All Python auto-import commands are available under the `<leader>i` prefix in Python files:

| Keybinding      | Description                               |
|-----------------|-------------------------------------------|
| `<leader>ia`    | Auto-import the symbol under the cursor   |
| `<leader>ii`    | Add an import interactively               |
| `<leader>io`    | Organize imports (sort & group)           |
| `<leader>in`    | Add a new import statement                |

In visual mode, you can also use:
- `<leader>ii` - Import the selected symbol

## Commands

These commands are available in all Neovim buffers:

| Command                | Description                             |
|------------------------|-----------------------------------------|
| `:PythonImport`        | Add a Python import interactively       |
| `:PythonAutoImport`    | Auto-import the symbol under the cursor |
| `:PythonOrganizeImports` | Organize Python imports               |
| `:PythonAddImport`     | Add a new Python import statement       |

## Example Usage

1. **Auto-importing a symbol**:
   - Place your cursor on an undefined symbol in your Python code
   - Press `<leader>ia` to try to auto-import it
   - If multiple import options exist, choose from the menu

2. **Organizing imports**:
   - After adding multiple imports, press `<leader>io` to:
     - Group imports by type (stdlib, third-party, local)
     - Sort each group alphabetically
     - Add appropriate spacing between groups

3. **Interactive import**:
   - Press `<leader>ii` on any symbol
   - Edit the import suggestion in the prompt
   - Press Enter to add the import

## Implementation Details

- The auto-import functionality is implemented in `lua/plugins/python/auto_imports.lua`
- It's integrated with the Pyright language server for Python
- Import suggestions come from a built-in dictionary of common Python modules
- The implementation follows PEP 8 import organization guidelines

## Troubleshooting

- If auto-import doesn't find a symbol, use `<leader>ii` to add it manually
- For third-party libraries, make sure they're installed in your Python environment
- If imports aren't being organized as expected, check for syntax errors in your import statements
