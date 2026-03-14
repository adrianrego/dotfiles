#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/adrianrego/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log() { echo "[bootstrap] $*"; }
die() { echo "[bootstrap] ERROR: $*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || die "git is required but not found. Install it and re-run."

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  log "Dotfiles already cloned at $DOTFILES_DIR — pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  log "Cloning dotfiles into $DOTFILES_DIR..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

log "Initializing submodules..."
git -C "$DOTFILES_DIR" submodule update --init --recursive

log "Running setup.sh..."
bash "$DOTFILES_DIR/setup.sh"

log "Bootstrap complete."
