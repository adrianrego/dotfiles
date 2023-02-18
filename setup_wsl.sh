#!/bin/bash

# Setup default python virtualenv
mkdir -p ~/.local/python/venvs
python3 -m venv ~/.local/python/venvs/default
~/.local/python/venvs/default/bin/pip install -U pip
~/.local/python/venvs/default/bin/pip install -U -r ./python/requirements.txt

# Install global node packages
mkdir -p ~/.local/.npm-global
npm config set prefix '~/.local/.npm-global'

npm install -g eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-prettier eslint-plugin-react expo-cli fixjson prettier typescript yarn

# Cargo / Rust
cargo install stylua

# Symlink dotfiles
stow git
stow tmux
stow zsh
stow lvim
