#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
keymap="$repo_root/config/eyelash_sofle.keymap"
herdr_config="/Users/foxleoly/.config/herdr/config.toml"

require_text() {
    local file="$1"
    local expected="$2"

    if ! rg --fixed-strings --quiet "$expected" "$file"; then
        echo "Missing expected text in $file: $expected" >&2
        exit 1
    fi
}

require_text "$keymap" 'display-name = "HerdR"'
require_text "$keymap" '&mo 1'
require_text "$keymap" '&kp LC(LA(U))'
require_text "$keymap" '&kp LC(LA(H))'
require_text "$keymap" '&kp LC(LA(J))'
require_text "$keymap" '&kp LC(LA(L))'
require_text "$keymap" '&kp LC(LS(LA(N)))'
require_text "$keymap" '&kp LC(LS(LA(G)))'
require_text "$keymap" '&kp LC(LA(X))'
require_text "$keymap" '&kp LC(LS(LA(X)))'

require_text "$herdr_config" 'focus_pane_up = "ctrl+alt+u"'
require_text "$herdr_config" 'focus_pane_left = "ctrl+alt+h"'
require_text "$herdr_config" 'focus_pane_down = "ctrl+alt+j"'
require_text "$herdr_config" 'focus_pane_right = "ctrl+alt+l"'
require_text "$herdr_config" 'new_workspace = "ctrl+alt+shift+n"'
require_text "$herdr_config" 'close_pane = "ctrl+alt+x"'
