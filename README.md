# Init

```bash
chsh -s /bin/bash
exec "$SHELL"
cd ~ && mkdir Projects && cd Projects
git clone https://github.com/eitanpo/dotfiles.git && cd dotfiles
source bootstrap.sh
```

> You might be asked to install Xcode Command Line Tools

# Setup

Review `Brewfile` to remove unnecessary installations.

```bash
source brew.sh
source ~/.macos
```

Configure Terminal colors by importing theme from `resources/` folder.

# Configure Git

```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

# Update

```bash
source ~/Projects/dotfiles/bootstrap.sh
```
