# Sofle L4 Application Controls Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace L4 playback controls with macOS application navigation and close-window controls.

**Architecture:** Edit only the second L4 binding row in the existing ZMK keymap. Replace three left-hand consumer media bindings with three ZMK modifier key bindings; leave volume controls, matrix positions, and every other layer unchanged.

**Tech Stack:** ZMK devicetree keymap syntax and GitHub Actions firmware builds.

---

### Task 1: Replace L4 playback bindings

**Files:**
- Modify: `config/eyelash_sofle.keymap:121`

- [ ] **Step 1: Replace the three bindings in the left-hand L4 second row**

Change this binding sequence:

```dts
&kp C_PREV &kp C_PLAY_PAUSE &kp C_NEXT &kp C_VOL_DN &kp C_VOL_UP
```

to:

```dts
&kp LG(LS(TAB)) &kp LG(TAB) &kp LG(W) &kp C_VOL_DN &kp C_VOL_UP
```

- [ ] **Step 2: Verify L4 remains a 64-position matrix**

Run:

```bash
awk '/layer_4/{inside=1} inside && /bindings = </{bindings=1;next} bindings && />;/{exit} bindings && /^&/{n=gsub(/&/,"&"); print n}' config/eyelash_sofle.keymap
```

Expected output:

```text
13
13
13
13
12
```

- [ ] **Step 3: Commit and push the keymap change**

```bash
git add config/eyelash_sofle.keymap
git commit -m "Replace L4 playback with app controls"
git push origin migrate-corne-layout
```

### Task 2: Verify firmware and download artifacts

**Files:**
- Modify: none

- [ ] **Step 1: Verify the latest firmware build succeeds**

Run:

```bash
TASK_RUN_ID=$(gh run list --repo foxleoly/zmk-sofle --branch migrate-corne-layout --workflow 'Build ZMK firmware' --limit 1 --json databaseId --jq '.[0].databaseId')
gh run view "$TASK_RUN_ID" --repo foxleoly/zmk-sofle --json status,conclusion,jobs
```

Expected: left, right, settings-reset, and merge-artifacts jobs report `success`.

- [ ] **Step 2: Download the merged firmware**

```bash
TASK_RUN_ID=$(gh run list --repo foxleoly/zmk-sofle --branch migrate-corne-layout --workflow 'Build ZMK firmware' --limit 1 --json databaseId --jq '.[0].databaseId')
gh run download "$TASK_RUN_ID" --repo foxleoly/zmk-sofle --name firmware --dir sofle-firmware-l4-app-controls
```

Expected: `eyelash_sofle_left-nice_nano_v2-zmk.uf2`, `eyelash_sofle_right-nice_nano_v2-zmk.uf2`, and `settings_reset-nice_nano_v2-zmk.uf2` are downloaded.
