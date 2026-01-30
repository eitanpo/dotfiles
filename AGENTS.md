# Dotfiles Repository

macOS development environment configuration. Files are copied from repo to `~` via rsync.

## Structure

| File | Purpose |
|------|---------|
| `bootstrap.sh` | Entry point - installs Homebrew, syncs dotfiles to ~ |
| `brew.sh` | Runs `brew bundle`, switches to Homebrew bash |
| `Brewfile` | Package list (brew, cask, mas), generated via `brew bundle dump` |
| `.macos` | macOS system preferences via `defaults` |
| `.bash_profile` | Main shell config, loads modules below |
| `.aliases` | Shell aliases |
| `.functions` | Utility functions |
| `.exports` | Environment variables |
| `.vimrc` | Vim config (Solarized theme) |
| `.starship` | Starship prompt config |

## Usage

```bash
# Initial setup
cd ~/Projects/dotfiles && source bootstrap.sh
source brew.sh && source ~/.macos

# Update existing install
source ~/Projects/dotfiles/bootstrap.sh
```

## Agent Guidelines

### Modifying Config
- **New tool integrations**: Add to `.bash_profile` with conditional check
- **Aliases**: Add to `.aliases`
- **Functions**: Add to `.functions`
- **Environment variables**: Add to `.exports`
- **Packages**: Install via `brew install`, then regenerate `Brewfile` with `brew bundle dump --force`

### Conditional Check Pattern
```bash
if command -v TOOL 1>/dev/null 2>&1; then
    eval "$(TOOL init bash)"
fi
```

### Drift
Repo is source of truth. Edits in `~` are overwritten on bootstrap - sync changes back to repo to persist.
