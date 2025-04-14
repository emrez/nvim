# Python LSP Guide

This guide explains how to set up and use Python LSP (Language Server Protocol) in Neovim with flake8, isort, mypy, and black.

## Initial Setup

1. Install the required Python packages:

    ```bash
    # Install in your project's virtual environment
    pip install "python-lsp-server[flake8]" pylsp-mypy python-lsp-black python-lsp-isort
    ```

    Or use the Neovim command that does this for you:

    ```
    :PylspSetup
    ```

2. Restart the LSP server if needed:

    ```
    :PylspRestart
    ```

## Configuration

### Project Configuration

For best results, add a `pyproject.toml` file to your project root with the following configurations:

```toml
[tool.black]
line-length = 88
target-version = ['py38']
include = '\.pyi?$'

[tool.isort]
profile = "black"
line_length = 88
multi_line_output = 3

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
```

Or use the alternative configuration files:

- `.flake8` for flake8 configuration
- `setup.cfg` for multiple tool configurations

### Troubleshooting

If the LSP isn't working correctly:

1. Check if the plugins are installed:
   
   ```bash
   pip list | grep -E 'python-lsp|black|isort|flake8|mypy'
   ```

2. Make sure the correct virtual environment is active:
   
   ```
   :echo utils#python#get_python_path()
   ```

3. Restart the LSP server:
   
   ```
   :PylspRestart
   ```

4. If problems persist, try installing the plugins globally:
   
   ```bash
   pip install --user "python-lsp-server[flake8]" pylsp-mypy python-lsp-black python-lsp-isort
   ```

## Commands

- `:PylspSetup` - Install Python LSP and all required plugins
- `:PylspRestart` - Restart the Python LSP server
- `:PylspInstallPlugins` - Install the LSP plugins using the utility function

## Regular Workflow

1. Open your Python project in Neovim
2. The LSP should automatically start for Python files
3. Use the LSP features:
   - `gd` - Go to definition
   - `K` - Show documentation
   - `<leader>f` - Format file (using black)
   - `<leader>rn` - Rename symbol
   - `<leader>ca` - Code actions

## Auto-formatting

The Python LSP server with black will format your code on save. This is configured in the LSP setup.
