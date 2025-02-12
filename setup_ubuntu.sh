#!/usr/bin/env bash

apt update
apt upgrade
apt install -y build-essential \
    ca-certificates \
    curl \
    file \
    git \
    gnupg \
    locales \
    podman \
    procps \
    wget

locale-gen en_us.UTF-8
