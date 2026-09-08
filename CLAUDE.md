# CLAUDE.md — Dotfiles Repository Guide

## Project Overview

GNU Stow managed dotfiles for cross-platform development environments (macOS/Linux/Fedora).
Primary toolchain: Neovim + AstroNvim, ZSH + Starship, TMux, Docker/Podman/Colima + Kubernetes.

## Repository Structure

```
dotfiles/
├── config/         # → ~/.config/ (nvim, ghostty, kitty, gh, starship, zed, colima)
├── git/            # → ~/.gitconfig, ~/.gitignore_global, ~/.gnupg/
├── tmux/           # → ~/.tmux.conf.local
├── zsh/            # → ~/.zshrc
├── colima/         # → ~/.colima/ (Colima VM config)
├── eslint/         # → .eslintrc (global ESLint config)
├── gnupg/          # NOT stowed — gpg-agent.conf template, rendered by setup_dev.sh
├── python/         # requirements.txt for default venv
├── .tmux/          # git submodule: gpakosz/.tmux framework
├── Brewfile        # Homebrew packages (cross-platform with OS conditionals)
├── setup_dev.sh    # Main bootstrap script
└── setup_ubuntu.sh # Ubuntu/Debian APT pre-setup
```

## Symlink Management (GNU Stow)

Most top-level directories are stow packages (exceptions: `python/`, `gnupg/`, `.tmux/`).
The directory tree inside a package mirrors `$HOME`:

```bash
stow config   # config/.config/nvim → ~/.config/nvim, etc.
stow git      # git/.gitconfig → ~/.gitconfig, etc.
stow tmux     # tmux/.tmux.conf.local → ~/.tmux.conf.local
stow zsh      # zsh/.zshrc → ~/.zshrc
```

To add a new config: place it at `<package>/<relative-to-home>/file`, then `stow <package>`.
To remove symlinks: `stow -D <package>`.

## Package Management

| Manager   | Source                    | Purpose                              |
|-----------|---------------------------|--------------------------------------|
| Homebrew  | `Brewfile`                | CLI tools, languages, apps           |
| pip       | `python/requirements.txt` | Python tools (ruff, debugpy, pynvim) |
| npm       | hardcoded in setup_dev.sh | fixjson, prettier, typescript        |
| git submodule | `.gitmodules`         | gpakosz/.tmux framework              |

After editing `Brewfile`: `brew bundle` to apply changes.
After editing `python/requirements.txt`: reinstall via `~/.local/python/venvs/default/bin/pip install -U -r python/requirements.txt`.

## Key Configurations

### Neovim (`config/.config/nvim/`)
- Framework: **AstroNvim v4** (LazyVim-based, Lua)
- Leader: `,` | Local leader: `<space>`
- LSPs: bashls, helm_ls, jsonls, lua_ls, ruff, terraformls, yamlls
- Formatters: prettier, stylua
- Lock file: `config/.config/nvim/lazy-lock.json` — commit when updating plugins

### ZSH (`zsh/.zshrc`)
- History: 100k entries, shared across sessions
- Key aliases: `ls→lsd`, `cat→bat`, `vim→nvim`, `python→python3`
- FZF configured with ripgrep/fd backends
- PATH order: Homebrew → Snap → Go → Cargo → Python venv → npm global

### TMux (`tmux/.tmux.conf.local`)
- Based on gpakosz/.tmux (git submodule at `.tmux/`)
- Only customize `.tmux.conf.local` — never edit `.tmux/.tmux.conf` directly

### Git (`git/.gitconfig`)
- GPG signing enabled (key: `63545724A9F7EF0E`)
- Work overrides loaded from `~/.gitconfig.work` when inside `Code/work/` directories
- Global ignore: `~/.gitignore_global`

### GPG (`gnupg/gpg-agent.conf.tmpl` → `~/.gnupg/gpg-agent.conf`)
- **Generated, not stowed.** `gpg-agent` requires an *absolute* `pinentry-program`
  path and does not search `PATH`, so the path differs per machine
  (`/opt/homebrew/bin` vs `/usr/bin`). `setup_dev.sh` detects an installed
  pinentry and renders the template; the result is gitignored via `git/.gnupg/*`.
- Edit the **template**, then re-run `bash setup_dev.sh`. Editing
  `~/.gnupg/gpg-agent.conf` directly gets overwritten.
- Candidate order prefers TTY-independent (GUI) pinentries: `pinentry-mac`,
  `pinentry-gnome3`, `pinentry-qt`, `pinentry-gtk-2`, then `pinentry-curses`/`-tty`.
  This matters because an agent-driven `git commit` sends a tty prompt to a
  terminal the user cannot see, so the commit hangs; `pinentry-curses` also fails
  outright in a small window (`Screen or window too small`).
- Headless Linux (devcontainers, remote boxes) has no GUI to prompt into — use
  `allow-preset-passphrase` + `gpg-preset-passphrase` rather than a pinentry.

### Ghostty (`config/.config/ghostty/config`)
- Font: FiraCode Nerd Font, 16pt
- Theme: Nord
- Ctrl+A prefix keybindings (mirrors TMux)

### Starship (`config/.config/starship.toml`)
- Kubernetes module: enabled
- AWS + Python modules: disabled

### Colima (`colima/.colima/default/colima.yaml`)
- 4 CPUs / 16GB RAM / 120GB disk
- Architecture: aarch64 (ARM64 — macOS Apple Silicon)
- Kubernetes: K3s v1.27.1, Traefik disabled
- Docker runtime, gvproxy network driver

## Common Tasks

### Bootstrap a new machine
```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
git submodule update --init --recursive
# On Ubuntu first: bash setup_ubuntu.sh
bash setup_dev.sh
```

### Add a new application config
1. Create the path mirroring home: `mkdir -p config/.config/<app>/`
2. Add config files
3. `stow config` (or `stow -R config` to refresh)

### Add a new stow package
1. Create top-level directory: `mkdir <package>/`
2. Mirror home structure inside it
3. Add `stow <package>` to `setup_dev.sh`

### Update Neovim plugins
- In Neovim: `:Lazy update` then commit `lazy-lock.json`

### Update tmux submodule
```bash
git submodule update --remote .tmux
git add .tmux
git commit -m "bump tmux submodule"
```

### Refresh all symlinks after structural changes
```bash
stow -R config git tmux zsh
```

## Platform Notes

- **macOS**: Ghostty + Colima (for containers). Brewfile has macOS-only casks.
- **Linux (Fedora/Ubuntu)**: Podman socket enabled via systemd. `setup_ubuntu.sh` installs APT deps first.
- Homebrew works on both platforms; Linux uses `/home/linuxbrew/.linuxbrew`.

## Files to Commit Carefully

- `config/.config/nvim/lazy-lock.json` — plugin versions, commit after `:Lazy update`
- `Brewfile.lock.json` — generated by `brew bundle`, commit for reproducibility
- `git/.gitconfig` — contains personal email and GPG key ID

## What NOT to Do

- Do not edit `.tmux/.tmux.conf` — it's a git submodule, changes will be lost
- Do not edit `~/.gnupg/gpg-agent.conf` — generated; edit `gnupg/gpg-agent.conf.tmpl`
- Do not commit anything under `git/.gnupg/` — the live keyring
  (`private-keys-v1.d/`, `trustdb.gpg`) physically lives there and is ignored
- Do not add secrets or tokens to any config file
- Do not put work-specific config here — use `~/.gitconfig.work` pattern for overrides
