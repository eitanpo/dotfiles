Init
====
```bash
chsh -s /bin/bash
exec "$SHELL"
cd ~ && mkdir Projects && cd Projects
git clone https://github.com/eitanpo/dotfiles.git && cd dotfiles
source bootstrap.sh
```
> You might be asked to install Xcode Command Line Tools

Setup
=====
Review `Brewfile` to remove unnecessary installations.
```bash
source brew.sh
source ~/.macos
```

Configure Terminal colors by importing theme from `resources/` folder.

Update
======
```bash
source ~/Projects/dotfiles/bootstrap.sh
```
