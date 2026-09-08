#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
  echo "[setup] Error: setup_dev.sh must not be run as root" >&2
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

# ---------------------------------------------------------------------------
# ChromeOS / Crostini shared folder symlinks
# ---------------------------------------------------------------------------
CHROMEOS_MYFILES="/mnt/chromeos/MyFiles"
if [ -d "$CHROMEOS_MYFILES" ]; then
  for folder in Downloads MyFiles; do
    src="$CHROMEOS_MYFILES/$folder"
    dst="$HOME/$folder"
    if [ -d "$src" ] && [ ! -e "$dst" ]; then
      ln -s "$src" "$dst"
      echo "[setup] Linked $dst -> $src"
    fi
  done
fi

# ---------------------------------------------------------------------------
# GPG directory — set early so any gpg calls during setup use correct perms
# ---------------------------------------------------------------------------
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# ---------------------------------------------------------------------------
# Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Activate Homebrew for the rest of this script
if [ -d /home/linuxbrew/.linuxbrew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -d ~/.linuxbrew ]; then
  eval "$(~/.linuxbrew/bin/brew shellenv)"
fi

# Append shellenv to ~/.bashrc only once
BREW_SHELLENV_LINE="eval \"\$($(brew --prefix)/bin/brew shellenv)\""
grep -qxF "$BREW_SHELLENV_LINE" ~/.bashrc || echo "$BREW_SHELLENV_LINE" >> ~/.bashrc

brew bundle

# ---------------------------------------------------------------------------
# ZSH as default shell
# ---------------------------------------------------------------------------
ZSH_PATH="$(command -v zsh)"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
if [ "${SHELL:-}" != "$ZSH_PATH" ]; then
  if command -v chsh &>/dev/null; then
    sudo chsh -s "$ZSH_PATH" "$USER"
  else
    sudo usermod -s "$ZSH_PATH" "$USER"
  fi
fi

# ---------------------------------------------------------------------------
# Python virtualenv (uv-managed, pinned to 3.14)
# ---------------------------------------------------------------------------
DEFAULT_VENV="$HOME/.local/python/venvs/default"
mkdir -p "$(dirname "$DEFAULT_VENV")"
if [ ! -x "$DEFAULT_VENV/bin/python" ]; then
  uv venv --python 3.14 --seed "$DEFAULT_VENV"
fi
uv pip install --python "$DEFAULT_VENV/bin/python" -U -r ./python/requirements.txt

# ---------------------------------------------------------------------------
# Nerd Fonts (FiraCode — direct download, avoids cloning the full ~5GB repo)
# ---------------------------------------------------------------------------
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

declare -A FIRACODE_FONTS=(
  ["FiraCodeNerdFont-Regular.ttf"]="FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
  ["FiraCodeNerdFont-Bold.ttf"]="FiraCode/Bold/FiraCodeNerdFont-Bold.ttf"
  ["FiraCodeNerdFont-Light.ttf"]="FiraCode/Light/FiraCodeNerdFont-Light.ttf"
  ["FiraCodeNerdFontMono-Regular.ttf"]="FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf"
)

FONTS_BASE="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts"
NEEDS_CACHE_REFRESH=false

for filename in "${!FIRACODE_FONTS[@]}"; do
  dest="$FONT_DIR/$filename"
  if [ ! -f "$dest" ]; then
    echo "[setup] Downloading font: $filename"
    curl -fLo "$dest" "$FONTS_BASE/${FIRACODE_FONTS[$filename]}"
    NEEDS_CACHE_REFRESH=true
  fi
done

if [ "$NEEDS_CACHE_REFRESH" = true ]; then
  fc-cache -fv
fi

# ---------------------------------------------------------------------------
# Symlink dotfiles
# ---------------------------------------------------------------------------
stow config
stow git
stow tmux
stow zsh

# ---------------------------------------------------------------------------
# Docker Compose plugin (Linux only, only if docker-compose is available)
# ---------------------------------------------------------------------------
if [ -d /home/linuxbrew/.linuxbrew ] || [ -d ~/.linuxbrew ]; then
  if command -v docker-compose &>/dev/null; then
    mkdir -p ~/.docker/cli-plugins
    ln -sf "$(command -v docker-compose)" ~/.docker/cli-plugins/docker-compose
  fi
fi

# ---------------------------------------------------------------------------
# Podman socket (skip gracefully in environments without systemd --user,
# e.g. Crostini / Chromebook Linux)
# ---------------------------------------------------------------------------
if [ -f "/usr/lib/systemd/user/podman.service" ]; then
  if systemctl --user daemon-reload &>/dev/null 2>&1; then
    mkdir -p ~/.config/systemd/user/
    cp /usr/lib/systemd/user/podman.service ~/.config/systemd/user/podman.service
    cp /usr/lib/systemd/user/podman.socket ~/.config/systemd/user/podman.socket
    systemctl --user enable --now podman.socket
  else
    echo "[setup] Skipping podman socket setup — systemd --user not available in this environment"
  fi
fi

# ---------------------------------------------------------------------------
# GPG agent config (generated — the pinentry path is machine-specific)
# ---------------------------------------------------------------------------
# gpg-agent needs an absolute pinentry path and does not search PATH, so this
# file cannot be stowed verbatim across macOS/Linux. Candidates are ordered
# most-preferred first; TTY-independent (GUI) pinentries come before the tty
# ones so that agent-driven `git commit` gets a prompt the user can actually
# see. See gnupg/gpg-agent.conf.tmpl for the full rationale.
PINENTRY_CANDIDATES=(
  pinentry-mac     # macOS GUI
  pinentry-gnome3  # Linux GUI; auto-falls back to curses when headless
  pinentry-qt      # Linux GUI (KDE)
  pinentry-gtk-2   # Linux GUI (older GTK)
  pinentry-curses  # last resort: needs a visible, adequately sized tty
  pinentry-tty
)

PINENTRY_PROGRAM=""
for candidate in "${PINENTRY_CANDIDATES[@]}"; do
  if resolved="$(command -v "$candidate" 2>/dev/null)"; then
    PINENTRY_PROGRAM="$resolved"
    break
  fi
done

if [ -z "$PINENTRY_PROGRAM" ]; then
  echo "[setup] Warning: no pinentry binary found — leaving ~/.gnupg/gpg-agent.conf alone." >&2
  echo "[setup]   Install one (brew install pinentry-mac / apt install pinentry-gnome3)," >&2
  echo "[setup]   then re-run this script." >&2
else
  # rm first so we never write *through* a stow symlink back into the repo.
  rm -f ~/.gnupg/gpg-agent.conf
  sed "s|@PINENTRY_PROGRAM@|${PINENTRY_PROGRAM}|" \
    gnupg/gpg-agent.conf.tmpl > ~/.gnupg/gpg-agent.conf
  echo "[setup] Generated ~/.gnupg/gpg-agent.conf (pinentry: $PINENTRY_PROGRAM)"
  # Pick up the new config if an agent is already running.
  gpgconf --kill gpg-agent 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# GPG permissions
# ---------------------------------------------------------------------------
if [ -d ~/.gnupg ]; then
  # Directories need 700 and files 600. A blanket `chmod 600 ~/.gnupg/*` also
  # hits private-keys-v1.d, stripping its execute bit so gpg can no longer read
  # the secret keys — so walk by type instead. -L because ~/.gnupg may itself be
  # a symlink. Sockets are neither -type f nor -type d and are left alone.
  chmod 700 ~/.gnupg
  find -L ~/.gnupg -type d -exec chmod 700 {} + 2>/dev/null || true
  find -L ~/.gnupg -type f -exec chmod 600 {} + 2>/dev/null || true
fi

cat <<'EOF'

Setup complete. Remaining manual steps:

  1. Import GPG key and set trust:
       gpg --import /path/to/private-key.asc
       gpg --edit-key 63545724A9F7EF0E trust quit  # choose 5 = ultimate

  2. Authenticate with GitHub:
       gh auth login

EOF
