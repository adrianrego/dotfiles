#!/bin/bash

# Setup default python virtualenv
mkdir -p ~/.local/python/venvs
python3 -m venv ~/.local/python/venvs/default
~/.local/python/venvs/default/bin/pip install -U pip
~/.local/python/venvs/default/bin/pip install -U -r ./python/requirements.txt

# Install global node packages
mkdir -p ~/.local/.npm-global
npm config set prefix '~/.local/.npm-global'

npm install -g pnpm eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-prettier eslint-plugin-react expo-cli fixjson prettier typescript yarn pyright yaml-language-server

# Cargo / Rust
cargo install stylua
cargo install lsd

# Starship
curl -sS https://starship.rs/install.sh | sh

# Fonts
git clone --depth=1 https://github.com/ryanoasis/nerd-fonts ~/.nerd-fonts
~/.nerd-fonts/install.sh FiraCode

# Symlink dotfiles
stow git
stow tmux
stow zsh
stow config

# Switch to zsh
chsh -s $(which zsh)
