#!/usr/bin/env bash
set -euo pipefail

# 1) Update this path to your local repo for storing VSCode settings
REPO_DIR="$HOME/works/vscode-settings"

# 2) Detect OS and set VSCode User settings directory accordingly
case "$(uname)" in
  Darwin*)
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    ;;
  Linux*)
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    ;;
  *)
    echo "Unsupported OS: $(uname)" >&2
    exit 1
    ;;
esac

# check that the repo directory exists
if [ ! -d "$REPO_DIR" ]; then
  echo "Repository directory not found: $REPO_DIR" >&2
  exit 1
fi

# check that the VSCode user settings directory exists
if [ ! -d "$VSCODE_USER_DIR" ]; then
  echo "VSCode user settings directory not found: $VSCODE_USER_DIR" >&2
  exit 1
fi

# ensure 'code' CLI is available
if ! command -v code >/dev/null 2>&1; then
  echo "'code' CLI not found. Please install 'Shell Command: Install \"code\" command in PATH' in VSCode." >&2
  exit 1
fi

cd "$REPO_DIR"

echo "1) Copy settings from $VSCODE_USER_DIR to $REPO_DIR"
if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
  cp -f "$VSCODE_USER_DIR/settings.json" ./settings.json
else
  echo "settings.json not found" >&2
fi

if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
  cp -f "$VSCODE_USER_DIR/keybindings.json" ./keybindings.json
else
  echo "keybindings.json not found" >&2
fi

echo "2) Export installed extensions"
code --list-extensions > extensions.txt

echo "3) Git commit & push"
git add settings.json keybindings.json extensions.txt
if git diff --cached --quiet; then
  echo "nothing to commit"
else
  git commit -m "chore: export vscode settings & extensions $(date +'%Y-%m-%d')"
  git push origin HEAD
fi

echo "Done: VSCode settings and extensions have been exported to $REPO_DIR"
