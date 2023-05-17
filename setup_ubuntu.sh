#!/usr/bin/env bash

apt update
apt upgrade
apt install -y bat \
  build-essential \
  ca-certificates \
  cargo \
	curl \
  fzf \
	git \
	gnupg \
  luajit \
	python3-dev \
	python3-pip \
  python3-venv \
	python3-software-properties \
  ripgrep \
	stow \
	tmux \
	zsh \
  wget \

# Node
curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&\
apt install -y nodejs

# Neovim
cd /tmp
wget https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
apt install ./nvim-linux64.deb

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update &&  apt install terraform

# Docker
# GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Setup Repo
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
