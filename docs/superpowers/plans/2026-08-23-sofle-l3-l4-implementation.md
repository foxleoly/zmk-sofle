# Sofle L3 and L4 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an ergonomic right-hand L3 code-symbol layer and left-hand L4 macOS/media layer to the Sofle ZMK keymap.

**Architecture:** Modify only the `layer_3` and `layer_4` binding matrices in the existing keymap. Preserve all 64 binding positions per layer, including the fixed physical C_MUTE and center positions; use `&trans` for unused positions. Validate through the existing GitHub Actions firmware workflow.

**Tech Stack:** ZMK devicetree keymap syntax, existing `eyelash_sofle` shield, GitHub Actions firmware build.

---

### Task 1: Implement sparse right-hand L3 symbols

**Files:**
- Modify: `config/eyelash_sofle.keymap:105-115`

- [ ] **Step 1: Replace L3 bindings while preserving the five-row matrix shape**

Use transparent bindings on the left half and map only these right-hand symbols:

```dts
&kp LBKT &kp RBKT &kp LBRC &kp RBRC &kp LPAR &kp RPAR
&kp BSLH &kp PIPE &kp COLON &kp QUESTION &kp EQUAL &kp PLUS
&kp MINUS &kp UNDER &kp LESS_THAN &kp GREATER_THAN &kp TILDE &kp CARET
&kp ASTRK &kp AMPS &trans &trans &trans &trans
```

- [ ] **Step 2: Verify no L3 row loses a matrix position**

Run:

```bash
sed -n '105,115p' config/eyelash_sofle.keymap
```

Expected: five L3 rows remain present; non-symbol positions use `&trans`.

- [ ] **Step 3: Commit the L3 change**

```bash
git add config/eyelash_sofle.keymap
git commit -m "Add sparse right-hand L3 symbols"
```

### Task 2: Implement left-hand L4 macOS and media controls

**Files:**
- Modify: `config/eyelash_sofle.keymap:117-127`

- [ ] **Step 1: Use valid ZMK key bindings for each macOS/media action**

Use these bindings in the left-hand matrix positions:

```dts
&kp C_BRI_DN &kp C_BRI_UP &kp LC(UP) &kp LG(F3) &kp LC(LG(Q))
&kp C_PREV &kp C_PLAY_PAUSE &kp C_NEXT &kp C_VOL_DN &kp C_VOL_UP
&kp C_MUTE &kp LG(LS(N4)) &kp LG(LS(N3)) &kp LG(SPACE)
```

- [ ] **Step 2: Place L4 controls only on the left-hand positions**

Keep the right half transparent because L4 is entered by holding the right-hand Enter position. Preserve all five rows and the fixed physical positions.

- [ ] **Step 3: Verify the L4 matrix shape**

Run:

```bash
sed -n '117,127p' config/eyelash_sofle.keymap
```

Expected: five L4 rows remain present, left-hand controls are populated, and right-hand unused positions are `&trans`.

- [ ] **Step 4: Commit the L4 change**

```bash
git add config/eyelash_sofle.keymap
git commit -m "Add left-hand macOS media layer"
```

### Task 3: Build and deliver firmware

**Files:**
- Modify: none

- [ ] **Step 1: Push the implementation branch**

```bash
git push origin migrate-corne-layout
```

Expected: GitHub Actions starts `Build ZMK firmware` for the new commit.

- [ ] **Step 2: Verify all build targets**

Run:

```bash
TASK_RUN_ID=$(gh run list --repo foxleoly/zmk-sofle --branch migrate-corne-layout --workflow 'Build ZMK firmware' --limit 1 --json databaseId --jq '.[0].databaseId')
gh run view "$TASK_RUN_ID" --repo foxleoly/zmk-sofle --json status,conclusion,jobs
```

Expected: `eyelash_sofle_left`, `eyelash_sofle_right`, `settings_reset`, and merge-artifacts jobs all succeed.

- [ ] **Step 3: Download firmware artifacts**

```bash
TASK_RUN_ID=$(gh run list --repo foxleoly/zmk-sofle --branch migrate-corne-layout --workflow 'Build ZMK firmware' --limit 1 --json databaseId --jq '.[0].databaseId')
gh run download "$TASK_RUN_ID" --repo foxleoly/zmk-sofle --name firmware --dir sofle-firmware-l3-l4
```

Expected: left, right, and settings-reset UF2 files are present.
