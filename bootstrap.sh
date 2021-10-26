#!/usr/bin/env bash

# Install Homebrew if missing
if [ ! -f "`which brew`" ]; then
	echo "";
	echo "Installing Homebrew ...";
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
fi

# Sync
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		current_dir="$(pwd)";
		script_dir="$(dirname "${BASH_SOURCE}")";

		# Get latest
		read -p "Do you want to get latest from GitHub? (y/n)" -n 1;
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "";
			echo "Getting latest ...";
			cd "$script_dir";
			git pull origin master;
			cd "$current_dir";
		fi;

		echo "";
		echo "Copying dotfiles from $script_dir to user root ...";
		rsync --exclude ".git/" \
			--exclude ".DS_Store" \
			--exclude ".gitignore" \
			--exclude "bootstrap.sh" \
			--exclude "README.md" \
			--exclude "shortcuts.ahk" \
			--exclude "resources" \
			--exclude "osx.setup" \
			-avh --no-perms "$script_dir"/ ~;
		
		echo "";
		echo "Sourcing ~/.bash_profile ...";
		echo "No need to restart terminal.";
		source ~/.bash_profile;
	fi;
fi;
 