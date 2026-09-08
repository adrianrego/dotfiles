#!/usr/bin/env bash
set -euo pipefail

apt update
apt upgrade -y
apt install -y \
    build-essential \
    ca-certificates \
    curl \
    file \
    git \
    gnupg \
    locales \
    pinentry-gnome3 \
    podman \
    procps \
    wget

locale-gen en_US.UTF-8
