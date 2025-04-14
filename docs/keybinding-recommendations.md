# Keybinding Recommendations

This document provides recommendations for resolving key binding overlaps detected in the health check.

## Current Overlaps

The following overlaps were detected:

1. **Surrounds Plugin**:
   - `<yS>` overlaps with `<ySS>`
   - `<ys>` overlaps with `<yss>`
   
2. **Comment Plugin**:
   - `<gc>` overlaps with `<gco>`, `<gcO>`, `<gcc>`, `<gcA>`
   - `<gb>` overlaps with `<gbc>`

3. **Leader Mappings**:
   - `<Space>w` overlaps with `<Space>wq>`
   - `<Space>r` overlaps with `<Space>rb>`, `<Space>rr>`, `<Space>ri>`
   - `<Space>q` overlaps with `<Space>qd>`, `<Space>ql>`, `<Space>qs>`

## Recommendations

Most of these overlaps are actually by design and expected. The plugins are designed to have keybindings that build upon each other.

1. **For Leader Mappings**:
   - The leader mappings are intended to be hierarchical - pressing `<leader>r` shows the refactor menu, then pressing `b` performs the extract block refactoring.
   - No changes needed for these.

2. **For Plugin Mappings**:
   - The surrounds plugin (`ys`, `yss`, etc.) and comment plugin (`gc`, `gcc`, etc.) mappings are designed this way.
   - These are normal and expected.

## Timing Considerations

When using overlapping keybindings, timing becomes important:

- For plugins like which-key, a short delay is expected to see if you're going to type more keys.
- If you want to reduce this delay, you can adjust `timeoutlen` in your config:

```lua
vim.opt.timeoutlen = 300  -- Default is 1000ms, setting to a lower value for faster response
```

## If Overlaps Become Problematic

If any specific overlapping keybinding becomes problematic, you can:

1. Increase the delay to give yourself more time to complete key sequences:
   ```lua
   vim.opt.timeoutlen = 500  -- Increase if you find menu appears too quickly
   ```

2. Change specific mappings that cause issues:
   ```lua
   -- Example of changing a specific conflicting mapping
   vim.keymap.del("n", "<leader>w")  -- Remove the conflicting mapping
   vim.keymap.set("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })  -- Create alternative
   ```

Remember that the Which-Key menu shows available key bindings, so you can always refer to it if you forget any sequences.