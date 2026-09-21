# HerdR Layer Design for Sofle

## Goal

Add a momentary HerdR control layer to the Sofle keymap. It must minimize finger travel during frequent pane navigation and keep destructive workspace actions physically separate from navigation.

## Context

The installed HerdR configuration contains no keybinding overrides, so it uses the application defaults. Default HerdR commands are prefix-first (Ctrl+B, then an action key). This is reliable but not ergonomically suitable for high-frequency use on a split keyboard: both Ctrl and B are produced by the left hand, followed by another command key.

The HerdR layer is layer 5. The left hand's inner Fn1 thumb key uses a custom hold-tap behavior: holding it activates the original Fn1 layer, while tapping it activates HerdR as a one-shot layer for the next key press. The QWERTY, Fn1, Fn2, Codex, and Media layers remain unchanged.

## Approach

HerdR will receive explicit Ctrl+Alt+letter or Ctrl+Alt+Shift+letter shortcuts. This avoids timing-dependent firmware macros that emulate Ctrl+B followed by an action. It also avoids the macOS system's possible interception of bare Ctrl+Arrow shortcuts.

Tapping the Fn1 thumb key activates HerdR for one subsequent key press. While that one-shot layer is active:

- The left hand performs navigation and reading actions.
- The right hand creates, resizes, or closes workspace objects.
- Potentially destructive actions are on the right hand, away from navigation.
- Unused keys remain transparent, preserving normal typing only where the layer does not assign an action.

## Layer Layout

The labels below describe the behavior while the left inner thumb holds the HerdR layer.

| Physical region | Assigned actions | Rationale |
| --- | --- | --- |
| Left non-navigation keys, Q/E/R/F/G/T | Previous tab, next tab, workspace picker, copy mode, edit scrollback, toggle sidebar | Sequential navigation and read-oriented controls stay under the left hand without conflicting with the WASD movement cross. |
| Left home area, W/A/S/D | Pane up, pane left, pane down, pane right | A physical WASD cross makes the most frequent four-way movement learnable without reaching the right half. |
| Left lower inner key | Toggle sidebar | A lower-priority view action, separate from movement. |
| Right top row, Y through P | New tab, split right, split down, zoom pane, detach client | Creation and view-sizing actions are grouped at the right index/middle fingers. |
| Right home row, H through semicolon | New workspace, new worktree, close pane, close tab, settings, reload configuration | Workspace management occupies the right hand; close actions are adjacent but not in the navigation cluster. |

## HerdR Keybinding Overrides

The HerdR configuration will add these direct bindings:

| HerdR action | Direct chord | Sofle key position |
| --- | --- | --- |
| Focus pane up | Ctrl+Alt+U | Left W |
| Focus pane left | Ctrl+Alt+H | Left A |
| Focus pane down | Ctrl+Alt+J | Left S |
| Focus pane right | Ctrl+Alt+L | Left D |
| Previous tab | Ctrl+Alt+P | Left Q |
| Next tab | Ctrl+Alt+N | Left E |
| Workspace picker | Ctrl+Alt+W | Left R |
| Copy mode | Ctrl+Alt+C | Left F |
| Edit scrollback | Ctrl+Alt+E | Left G |
| Toggle sidebar | Ctrl+Alt+B | Left T |
| New tab | Ctrl+Alt+T | Right Y |
| Split right | Ctrl+Alt+V | Right U |
| Split down | Ctrl+Alt+O | Right I |
| Zoom pane | Ctrl+Alt+Z | Right O |
| Detach client | Ctrl+Alt+D | Right P |
| New workspace | Ctrl+Alt+Shift+N | Right H |
| New worktree | Ctrl+Alt+Shift+G | Right J |
| Close pane | Ctrl+Alt+X | Right K |
| Close tab | Ctrl+Alt+Shift+X | Right L |
| Settings | Ctrl+Alt+S | Right semicolon |
| Reload configuration | Ctrl+Alt+R | Right quote |

Help remains available through the existing Ctrl+B, then ? default, rather than consuming a direct chord.

## Implementation Boundaries

Only two files need behavior changes:

- config/eyelash_sofle.keymap: add the Fn1 hold / HerdR one-shot behavior and add the HerdR layer as layer 5.
- ~/.config/herdr/config.toml: add the direct bindings in the existing [keys] table.

Firmware should be compiled through the existing GitHub Actions workflow. The HerdR configuration can be reloaded with the new direct reload shortcut after the first manual reload.

## Verification

1. Run herdr server reload-config once after writing the configuration.
2. Press the configured direct chords in a HerdR session and confirm that each action runs exactly once.
3. Flash both Sofle halves with the generated firmware.
4. Tap the left inner Fn1 thumb key, then test one HerdR navigation action. Repeat for creation and close actions in a disposable HerdR workspace.
5. Confirm ordinary QWERTY typing works normally when the thumb is released.

## Error Handling

If HerdR rejects any binding, it retains the previous valid keybindings while applying other valid configuration. The test sequence should therefore start with the direct navigation keys before relying on creation or close actions. If a host terminal consumes a chord, remap only that one action to another unused Ctrl+Alt+letter chord; the Sofle layer is the sole corresponding firmware change. If a tap is held for longer than 200 ms, Fn1 rather than HerdR activates; release and make a shorter tap before trying again.
 
