# HerdR Sofle Layer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** Replace the Sofle Fn1 layer with an ergonomic, momentary HerdR command layer backed by direct HerdR shortcuts.

**Architecture:** The left inner thumb continues to hold layer 1, but layer 1 becomes HerdR rather than Fn1. Each assigned key sends a single Ctrl+Alt chord defined in HerdR configuration, so no firmware sequence macro needs timing. Left-hand positions provide navigation and reading controls; right-hand positions provide workspace creation, pane layout, and close controls.

**Tech Stack:** ZMK devicetree keymap, HerdR TOML configuration, GitHub Actions firmware build.

---

### Task 1: Add direct HerdR bindings

**Files:**

- Modify: /Users/foxleoly/.config/herdr/config.toml
- Test: HerdR configuration reload and active keybinding help

- [ ] **Step 1: Add the exact [keys] bindings**

Add this block after the existing onboarding setting:

    [keys]
    focus_pane_up = "ctrl+alt+u"
    focus_pane_left = "ctrl+alt+h"
    focus_pane_down = "ctrl+alt+j"
    focus_pane_right = "ctrl+alt+l"
    previous_tab = "ctrl+alt+p"
    next_tab = "ctrl+alt+n"
    workspace_picker = "ctrl+alt+w"
    copy_mode = "ctrl+alt+c"
    edit_scrollback = "ctrl+alt+e"
    toggle_sidebar = "ctrl+alt+b"
    new_tab = "ctrl+alt+t"
    split_vertical = "ctrl+alt+v"
    split_horizontal = "ctrl+alt+o"
    zoom = "ctrl+alt+z"
    detach = "ctrl+alt+d"
    new_workspace = "ctrl+alt+shift+n"
    new_worktree = "ctrl+alt+shift+g"
    close_pane = "ctrl+alt+x"
    close_tab = "ctrl+alt+shift+x"
    settings = "ctrl+alt+s"
    reload_config = "ctrl+alt+r"

- [ ] **Step 2: Reload the HerdR server**

Run: herdr server reload-config

Expected: successful reload with no invalid-keybinding warning.

- [ ] **Step 3: Verify the active direct commands**

Run: herdr status

Expected: the command returns normal session status. In an attached HerdR session, Ctrl+Alt+W must open the workspace picker and Ctrl+Alt+U/H/J/L must focus the matching pane direction.

### Task 2: Replace Fn1 firmware bindings with the HerdR layer

**Files:**

- Modify: /Users/foxleoly/workspace/zmk-sofle/config/eyelash_sofle.keymap:82-92
- Test: ZMK keymap preprocessing and GitHub Actions build

- [ ] **Step 1: Replace the Fn1 display name and bindings**

Replace the layer 1 block so the display name is HerdR. Keep the layer index at 1 and retain sensor-bindings. Use these five matrix rows, preserving the original 13/13/13/13/12 key counts:

    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans
    &trans &kp LC(LA(P)) &kp LC(LA(U)) &kp LC(LA(N)) &kp LC(LA(W)) &kp LC(LA(B)) &trans &kp LC(LA(T)) &kp LC(LA(V)) &kp LC(LA(O)) &kp LC(LA(Z)) &kp LC(LA(D)) &trans
    &trans &kp LC(LA(H)) &kp LC(LA(J)) &kp LC(LA(L)) &kp LC(LA(C)) &kp LC(LA(E)) &trans &kp LC(LS(LA(N))) &kp LC(LS(LA(G))) &kp LC(LA(X)) &kp LC(LS(LA(X))) &kp LC(LA(S)) &kp LC(LA(R))
    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans
    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans

All unassigned positions must use &trans. The default-layer thumb binding remains &mo 1, so the existing left inner Fn1 thumb key holds HerdR.

- [ ] **Step 2: Run a static keymap inspection**

Run:

    rg -n -C 2 'display-name = "HerdR"|&mo 1|LC\\(LA\\(' config/eyelash_sofle.keymap

Expected: layer 1 is named HerdR, the default layer still contains &mo 1, and each assigned direct chord is present only in layer 1.

- [ ] **Step 3: Trigger firmware compilation**

Commit only the keymap change and push the current branch. Use the repository GitHub Actions workflow to compile both Sofle halves.

Expected: left and right nice_nano_v2 firmware jobs succeed.

### Task 3: Validate the installed behavior

**Files:**

- Verify: /Users/foxleoly/.config/herdr/config.toml
- Verify: generated left and right UF2 artifacts

- [ ] **Step 1: Test safe navigation before destructive actions**

In a HerdR workspace with at least two panes, hold the left inner thumb key and press the physical W, A, S, and D keys. Then test Q, E, R, F, G, and T.

Expected: every key fires once; ordinary typing resumes immediately when the thumb is released.

- [ ] **Step 2: Test workspace actions in a disposable workspace**

With the HerdR layer held, test Y, U, I, O, P, H, and J. Test K and L only in a disposable workspace because they close a pane or tab.

Expected: creation actions affect the active HerdR workspace and the close actions present HerdR's normal confirmation behavior when configured.

- [ ] **Step 3: Flash firmware**

Flash the left UF2 to the left Sofle half and the right UF2 to the right Sofle half. Keep the downloaded reset UF2 only for recovery.

Expected: the keyboard reconnects, and the HerdR layer works without changing the QWERTY, Fn2, Codex, or Media layers.
