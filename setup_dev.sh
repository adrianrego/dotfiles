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
sudo usermod -s "$ZSH_PATH" "$USER"

# ---------------------------------------------------------------------------
# Python virtualenv
# ---------------------------------------------------------------------------
mkdir -p ~/.local/python/venvs
python3 -m venv ~/.local/python/venvs/default
~/.local/python/venvs/default/bin/pip install -U pip
~/.local/python/venvs/default/bin/pip install -U -r ./python/requirements.txt

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
# GPG permissions
# ---------------------------------------------------------------------------
if [ -d ~/.gnupg ]; then
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/* 2>/dev/null || true
fi

cat <<'EOF'

Setup complete. Remaining manual steps:

  1. Import GPG key and set trust:
       gpg --import /path/to/private-key.asc
       gpg --edit-key 63545724A9F7EF0E trust quit  # choose 5 = ultimate

  2. Authenticate with GitHub:
       gh auth login

EOF
