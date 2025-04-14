# Project Management in Neovim

This document explains the project management features in your Neovim configuration and how to use them effectively.

## Core Project Management Features

### Project Detection and Navigation (project.nvim)

The `project.nvim` plugin automatically detects your project root directories and enables quick navigation between them.

#### How it works:

1. When you open a file, the plugin detects the project root based on markers like `.git`, `package.json`, etc.
2. It automatically changes your current working directory to the project root
3. It keeps a history of your projects for easy switching

#### Key features:

- **Project switching**: Press `<Space>fp` to see a list of recent projects and switch between them
- **Automatic root detection**: When you open a file, Neovim automatically changes to the project root
- **Multiple detection methods**: Uses both LSP and pattern matching to accurately find project roots

### Session Management (persistence.nvim)

This plugin automatically saves and restores your Neovim sessions, including open files, window layouts, and cursor positions.

#### Key features:

- **Automatic session saving**: Your session is automatically saved when you exit Neovim
- **Session restoration**: Press `<Space>qs` to restore the session for the current directory
- **Last session**: Press `<Space>ql` to restore the last session regardless of directory
- **Skip session saving**: Press `<Space>qd` to prevent saving the current session

### Project-specific Settings (neoconf.nvim)

This plugin allows you to have different settings for different projects.

#### How to use:

1. Create a `.neoconf.json` file in your project root
2. Add project-specific settings in this file

Example `.neoconf.json`:
```json
{
  "lspconfig": {
    "pyright": {
      "settings": {
        "python.analysis.typeCheckingMode": "basic"
      }
    }
  }
}
```

### Task Management (overseer.nvim)

Run and manage tasks within Neovim, such as build commands, tests, or any custom commands.

#### Key features:

- **Task list**: Press `<Space>pt` to toggle the task list window
- **Run tasks**: Press `<Space>pr` to run a task
- **Build tasks**: Press `<Space>pb` to run a build task

### Workspace Management (workspaces.nvim)

Manage and switch between different workspaces, which can contain multiple projects.

#### Key features:

- **Find workspaces**: Press `<Space>pw` to see and select a workspace
- **Add workspace**: Press `<Space>pa` to add the current directory as a named workspace
- **Automatic hooks**: Opening a workspace automatically opens the file explorer and find files dialog

### TODO Management (todo-comments.nvim)

Highlight and navigate between TODO comments in your codebase.

#### Key features:

- **Highlighted comments**: Special comments like `TODO:`, `FIXME:`, `HACK:`, etc. are highlighted
- **Find TODOs**: Press `<Space>ft` to find all TODOs in the project
- **Jump between TODOs**: Use `]t` and `[t` to jump to the next/previous TODO comment

## Workflow Examples

### Starting a New Coding Session

1. Open Neovim
2. Press `<Space>fp` to see your recent projects and select one
3. Press `<Space>qs` to restore your previous session for this project
4. Begin working where you left off

### Managing Multiple Projects

1. Open Project A using `<Space>fp`
2. Work on Project A
3. Press `<Space>pw` to switch to Workspace B which contains multiple related projects
4. When finished, your session is automatically saved

### Task-Based Workflow

1. Open your project
2. Add TODOs using comments like `-- TODO: Implement this feature`
3. Jump between TODOs using `]t` and `[t`
4. Press `<Space>ft` to see all TODOs in the project
5. Complete tasks and run them with `<Space>pr`

## Project-Specific Configuration Examples

### Example: Python Project Settings

Create `.neoconf.json` in your Python project root:

```json
{
  "lspconfig": {
    "pyright": {
      "settings": {
        "python.analysis.typeCheckingMode": "basic",
        "python.linting.enabled": true,
        "python.formatting.provider": "black"
      }
    }
  }
}
```

### Example: JavaScript Project Settings

Create `.neoconf.json` in your JavaScript project root:

```json
{
  "lspconfig": {
    "tsserver": {
      "settings": {
        "typescript.suggestionActions.enabled": true,
        "javascript.suggestionActions.enabled": true
      }
    },
    "eslint": {
      "settings": {
        "workingDirectory": { "mode": "auto" }
      }
    }
  }
}
```

## Tips and Best Practices

1. **Use project-based sessions**: Let the session manager handle your workflow state automatically
2. **Add common project markers**: Add custom markers to `patterns` in project.nvim config if your projects use unique file structures
3. **Use TODOs effectively**: Add categories like `TODO(feat):`, `FIXME(bug):` to organize your tasks
4. **Create task templates**: Set up common task templates in overseer.nvim for quick task creation
5. **Organize workspaces logically**: Group related projects into workspaces for easier switching