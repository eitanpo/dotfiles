#!/usr/bin/env bash

# Install Homebrew if missing
if [ ! -f "`which brew`" ]; then
	echo "";
	echo "Installing Homebrew ...";
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";

	# for M1
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi


read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";

if [[ $REPLY =~ ^[Yy]$ ]]; then
	dotfiles_dir="~/Projects/dotfiles";

	# Get latest
	read -p "Do you want to get latest from GitHub? (y/n)" -n 1;
	echo "";

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "";
		echo "Getting latest ...";
		cd "$dotfiles_dir";
		git pull origin master;
		cd ~;
	fi;

	echo "";
	echo "Copying dotfiles from $dotfiles_dir to user root ...";
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".gitignore" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "shortcuts.ahk" \
		--exclude "resources" \
		--exclude "osx.setup" \
		-avh --no-perms "$dotfiles_dir"/ ~;
	
	echo "";
	echo "Sourcing ~/.bash_profile ...";
	echo "No need to restart terminal.";
	source ~/.bash_profile;
fi;
 