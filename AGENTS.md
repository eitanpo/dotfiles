# Dotfiles Repository

macOS development environment configuration. Files in `dotfiles/` are copied to `~` via rsync.

## Structure

| Path | Purpose |
|------|---------|
| `bootstrap.sh` | Entry point - installs Homebrew, syncs dotfiles, installs packages, sets up bash |
| `Brewfile` | Package list (brew, cask, mas), generated via `brew bundle dump` |
| `dotfiles/` | Dotfiles synced to ~ |
| `dotfiles/.bash_profile` | Main shell config, loads modules below |
| `dotfiles/.aliases` | Shell aliases |
| `dotfiles/.functions` | Utility functions |
| `dotfiles/.exports` | Environment variables |
| `dotfiles/.macos` | macOS system preferences via `defaults` |
| `dotfiles/.vimrc` | Vim config (Solarized theme) |
| `dotfiles/.starship` | Starship prompt config |

## Usage

```bash
# Initial setup
cd ~/Projects/dotfiles && source bootstrap.sh
source ~/.macos

# Update existing install
source ~/Projects/dotfiles/bootstrap.sh
```

## Agent Guidelines

### Modifying Config
- **New tool integrations**: Add to `dotfiles/.bash_profile` with conditional check
- **Aliases**: Add to `dotfiles/.aliases`
- **Functions**: Add to `dotfiles/.functions`
- **Environment variables**: Add to `dotfiles/.exports`
- **Packages**: Install via `brew install`, then run `update` (which regenerates `Brewfile`)

### Conditional Check Pattern
```bash
if command -v TOOL 1>/dev/null 2>&1; then
    eval "$(TOOL init bash)"
fi
```

### Drift
Repo is source of truth. Edits in `~` are overwritten on bootstrap - sync changes back to repo to persist.
