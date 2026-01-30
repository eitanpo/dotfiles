# Dotfiles

macOS development environment configuration.

## Quick Start

```bash
# Initial setup
chsh -s /bin/bash
cd ~ && mkdir -p Projects && cd Projects
git clone https://github.com/eitanpo/dotfiles.git
cd dotfiles && source bootstrap.sh

# Apply macOS preferences (optional)
source macos.sh
```

> You may be prompted to install Xcode Command Line Tools.

## Post-Setup

1. Review and customize `resources/Brewfile` before running `update`
2. Configure Terminal colors by importing theme from `resources/` folder
3. Configure Git:
   ```bash
   git config --global user.email "you@example.com"
   git config --global user.name "Your Name"
   ```

## Documentation

See `AGENTS.md` for detailed documentation on:
- Repository structure
- Where to add aliases, functions, exports, packages
- Agent configuration (skills, rules, instructions)
- Sync commands

## Update

```bash
source ~/Projects/dotfiles/bootstrap.sh
```
