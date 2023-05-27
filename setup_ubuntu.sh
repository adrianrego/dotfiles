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
    podman \
    podman-docker \
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

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update &&  apt install terraform

# NeoVim
snap install nvim --classic

# Kubernetes
snap install kubectl --classic

# MicroK8s
snap install microk8s --classic

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
