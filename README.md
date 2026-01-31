# Dotfiles

macOS development environment configuration.

## Quick Start

```bash
cd ~ && mkdir -p Projects && cd Projects
git clone https://github.com/eitanpo/dotfiles.git
cd dotfiles && source bootstrap.sh
```

This will:
- Install Homebrew and packages (if missing)
- Set brew bash as default shell
- Sync dotfiles to `~`
- Create agent skills symlinks

> You may be prompted for your password or to install Xcode Command Line Tools.

## Post-Setup

1. Configure Terminal colors: import theme from `resources/` folder
2. Configure Git credentials:
   ```bash
   git config --global user.email "you@example.com"
   git config --global user.name "Your Name"
   ```
3. Apply macOS preferences (optional): `source macos.sh`

## Usage

After initial setup, these aliases are available:

```bash
dotfiles-apply    # Apply dotfiles from repo to ~
dotfiles-save     # Save changes from ~ back to repo
update            # Update Homebrew packages and regenerate Brewfile
```

## Documentation

See `AGENTS.md` for detailed documentation on:
- Repository structure
- Where to add aliases, functions, exports, packages
- Agent configuration (skills, rules, instructions)
