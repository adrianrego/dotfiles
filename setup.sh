#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log() { echo "[setup] $*"; }

is_ubuntu_debian() {
  [[ -f /etc/os-release ]] && grep -qiE 'ubuntu|debian' /etc/os-release
}

# Keep sudo credentials alive for the duration of the script.
# Prompts once at the start; a background heartbeat refreshes every 50s.
sudo_keepalive() {
  sudo true
  (while true; do sudo -n true; sleep 50; done) &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

if is_ubuntu_debian; then
  log "Ubuntu/Debian detected — will run setup_ubuntu.sh first (requires sudo)"
  sudo_keepalive
  log "Running setup_ubuntu.sh..."
  sudo --preserve-env=HOME,USER bash "$SCRIPT_DIR/setup_ubuntu.sh"
  log "setup_ubuntu.sh complete"
fi

log "Running setup_dev.sh..."
bash "$SCRIPT_DIR/setup_dev.sh"
log "setup_dev.sh complete"

log "Done."
