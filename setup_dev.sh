#!/bin/bash

# Setup default python virtualenv
mkdir -p ~/.local/python/venvs
python3 -m venv ~/.local/python/venvs/default
source ~/.local/python/venvs/default/bin/activate
pip install -U -r ./python/requirements.txt

# Install global node packages
npm install -g eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-prettier eslint-plugin-react expo-cli fixjson prettier typescript yarn

# Switch to ZSH
chsh -s $(which zsh)
