# Python Auto-Import Configuration for Neovim

This guide explains how to use the new Python auto-import capabilities added to your Neovim configuration.

## Features Added

1. **Auto-import Symbols**: Automatically adds import statements for Python symbols
2. **Import Organization**: Sorts and groups imports by standard library, third-party, and local
3. **Import Suggestions**: Suggests imports for common Python modules and libraries
4. **Enhanced Pyright Integration**: Configures Pyright LSP for better auto-import support

## Keybindings

All Python auto-import commands are mapped under the `<leader>i` prefix for easy access in Python files:

- `<leader>ia` - Auto-import the symbol under the cursor
- `<leader>ii` - Interactively add an import statement for the current symbol
- `<leader>io` - Organize imports (sort and group)
- `<leader>in` - Add a new import statement

In visual mode:
- `<leader>ii` - Import the selected symbol

## Commands

The following commands are available across Neovim:

- `:PythonImport` - Add a Python import interactively
- `:PythonAutoImport` - Auto-import the symbol under the cursor
- `:PythonOrganizeImports` - Organize Python imports
- `:PythonAddImport` - Add a new Python import statement

## Prerequisites

Make sure pyright is installed in your environment:

```bash
# Using UV (recommended)
uv pip install pyright

# Or using regular pip
pip install pyright
```

##