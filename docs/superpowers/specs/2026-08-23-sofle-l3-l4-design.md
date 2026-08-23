# Sofle L3 and L4 Layer Design

## Goal

Add two ergonomic hold layers to the Sofle ZMK keymap for a macOS Vim user.

## Entry Keys

- Hold the left-hand Space position to enter L3. A tap still sends Space.
- Hold the right-hand Enter position to enter L4. A tap still sends Enter.

## Invariants

- Every layer keeps all matrix binding positions.
- The physical C_MUTE position and center position remain present in every layer.
- Do not remove bindings to make a layer look smaller. Use `&trans` for keys that should inherit Layer 0.
- L3 and L4 must preserve the established left/right physical matrix order.

## L3: Code and Network Symbols

L3 is activated by the left thumb, so all added symbols are placed on the right half. The left half is transparent.

Right-hand additions:

- Top row: `[`, `]`, `{`, `}`, `(`, `)`.
- Second row: `\\`, `|`, `:`, `?`, `=`, `+`.
- Third row: `-`, `_`, `<`, `>`, `~`, `^`.
- Fourth row: `*`, `&`.

Existing Layer 0 direct keys such as `.`, `/`, `,`, `;`, and quotes remain transparent and are not duplicated.

## L4: macOS and Media

L4 is activated by the right thumb, so all active controls are placed on the left half. The right half is transparent.

Left-hand controls:

- Top row: brightness down, brightness up, Mission Control, show desktop, lock screen.
- Second row: previous track, play/pause, next track, volume down, volume up.
- Third row: mute, screenshot selection, full screenshot, Spotlight.
- Remaining positions are transparent for future shortcuts.

## Validation

Before delivery:

1. Verify every layer has the complete matrix binding count.
2. Verify the two fixed physical positions remain occupied in every layer.
3. Compile left, right, and settings-reset targets in GitHub Actions.
4. Download the merged firmware artifact only after all build jobs succeed.
