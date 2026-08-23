# Sofle L4 Application Controls Design

## Goal

Replace the L4 media playback controls with macOS application and window controls.

## Scope

Only three existing L4 left-hand positions change. The rest of the keymap, the L4 hold entry, the full matrix shape, and the fixed physical positions remain unchanged.

## Mapping

Replace the current second-row playback controls with:

- Previous application: Command-Shift-Tab.
- Next application: Command-Tab.
- Close current window or tab: Command-W.

Keep the neighboring volume down and volume up controls unchanged.

## Validation

1. Confirm the L4 binding matrix still contains 64 positions.
2. Compile left, right, and settings-reset targets in GitHub Actions.
3. Download the merged firmware artifact only after every build job succeeds.
