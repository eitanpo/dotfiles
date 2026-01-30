#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew and packages if missing
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew ..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"

	echo "Installing packages ..."
	brew bundle --file="$DIR/resources/Brewfile"
	brew cleanup

	# macOS lacks sha256sum; symlink GNU version
	[ ! -f "$(brew --prefix)/bin/sha256sum" ] && \
		ln -s "$(brew --prefix)/bin/gsha256sum" "$(brew --prefix)/bin/sha256sum"

	# Set brew bash as default shell
	grep -Fq "$(brew --prefix)/bin/bash" /etc/shells || {
		echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
		chsh -s "$(brew --prefix)/bin/bash"
	}
fi

# Sync dotfiles
read -p "This may overwrite files in ~. Continue? (y/n) " -n 1; echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0

read -p "Pull latest from GitHub? (y/n) " -n 1; echo
[[ $REPLY =~ ^[Yy]$ ]] && git -C "$DIR" pull origin master

rsync -avh --no-perms "$DIR/dotfiles/" ~ --exclude=".DS_Store"
echo -e "\n# Dotfiles location (set by bootstrap.sh)\nexport DOTFILES_DIR=\"$DIR\"" >> ~/.exports
source ~/.bash_profile
