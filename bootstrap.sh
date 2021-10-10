#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

if [ ! -f "which brew" ]; then
	echo "";
	echo "Installing Homebrew ...";
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
fi

echo "";
echo "Getting latest ...";
git pull origin master;

function doIt() {
	echo "";
	echo "Copying dotfiles to root ...";
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".gitignore" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "shortcuts.ahk" \
		--exclude "resources" \
		--exclude "osx.setup" \
		-avh --no-perms . ~;
	
	echo "";
	echo "Sourcing ~/.bash_profile ..."
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
