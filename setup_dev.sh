#!/bin/bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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

npm install -g eslint eslint-config-airbnb eslint-config-prettier fixjson prettier typescript

# Fonts
git clone --depth=1 https://github.com/ryanoasis/nerd-fonts ~/.nerd-fonts
~/.nerd-fonts/install.sh FiraCode

# Switch to ZSH
chsh -s $(which zsh)

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
