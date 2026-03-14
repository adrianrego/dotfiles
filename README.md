# dotfiles

GNU Stow managed dotfiles and setup script for macOS and Linux (Ubuntu/Fedora).

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/adrianrego/dotfiles/main/bootstrap.sh | bash
```

This will clone the repo to `~/dotfiles`, initialize submodules, and run the full setup.

To use a custom location:

```bash
DOTFILES_DIR=~/code/dotfiles curl -fsSL https://raw.githubusercontent.com/adrianrego/dotfiles/main/bootstrap.sh | bash
```

## Manual Setup

```bash
git clone https://github.com/adrianrego/dotfiles.git ~/dotfiles
cd ~/dotfiles
git submodule update --init --recursive
bash setup.sh
```

## What's Included

- **Neovim** — AstroNvim v4 config
- **ZSH** — `.zshrc` with aliases, FZF, Starship prompt
- **TMux** — gpakosz/.tmux based config
- **Git** — `.gitconfig` with GPG signing
- **Ghostty** — terminal config (Nord theme, FiraCode)
- **Colima** — Docker/K3s VM config (macOS)
- **Brewfile** — Homebrew packages (macOS + Linux)
