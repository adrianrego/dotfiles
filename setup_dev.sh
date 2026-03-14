#!/bin/bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Homebrew
if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -d /home/linuxbrew/.linuxbrew ]; then
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
fi

brew bundle

command -v zsh | sudo tee -a /etc/shells

# Setup default python virtualenv
mkdir -p ~/.local/python/venvs
python3 -m venv ~/.local/python/venvs/default
~/.local/python/venvs/default/bin/pip install -U pip
~/.local/python/venvs/default/bin/pip install -U -r ./python/requirements.txt

# Install global node packages
mkdir -p ~/.local/.npm-global
npm config set prefix '~/.local/.npm-global'

npm install -g fixjson prettier typescript

# Fonts
if [[ ! -d ~/.nerd-fonts ]]; then
  git clone --depth=1 https://github.com/ryanoasis/nerd-fonts ~/.nerd-fonts
fi
~/.nerd-fonts/install.sh FiraCode

# Switch to ZSH
sudo usermod -s "$(which zsh)" "$USER"

# Symlink dotfiles
stow config
stow git
stow tmux
stow zsh

if [ -d /home/linuxbrew/.linuxbrew ]; then
  mkdir -p ~/.docker/cli-plugins
  ln -s $(which docker-compose) ~/.docker/cli-plugins/docker-compose
fi

if [ -f "/usr/lib/systemd/user/podman.service" ]; then
  mkdir -p ~/.config/systemd/user/
  cp /usr/lib/systemd/user/podman.service ~/.config/systemd/user/podman.service
  cp /usr/lib/systemd/user/podman.socket ~/.config/systemd/user/podman.socket

  systemctl --user enable --now podman.socket
fi

# ---------------------------------------------------------------------------
# GPG setup
# ---------------------------------------------------------------------------
if [ -d ~/.gnupg ]; then
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/* 2>/dev/null || true
fi

cat <<'EOF'

Setup complete. To enable GPG commit signing:

  gpg --import /path/to/private-key.asc
  gpg --edit-key 63545724A9F7EF0E trust quit  # choose 5 = ultimate

EOF
