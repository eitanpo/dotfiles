#!/usr/bin/env bash

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_packages() {
	local brew_prefix=$(brew --prefix)

	echo "Installing packages from Brewfile ..."
	brew bundle --file="$dotfiles_dir/Brewfile"

	# macOS lacks sha256sum; symlink GNU version
	[ ! -f "${brew_prefix}/bin/sha256sum" ] && \
		ln -s "${brew_prefix}/bin/gsha256sum" "${brew_prefix}/bin/sha256sum"

	# Set brew bash as default shell
	if ! fgrep -q "${brew_prefix}/bin/bash" /etc/shells; then
		echo "${brew_prefix}/bin/bash" | sudo tee -a /etc/shells
		chsh -s "${brew_prefix}/bin/bash"
	fi

	brew cleanup
}

# Install Homebrew and packages if missing
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew ..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
	install_packages
fi

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo

[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0

read -p "Pull latest from GitHub? (y/n) " -n 1
echo

[[ $REPLY =~ ^[Yy]$ ]] && git -C "$dotfiles_dir" pull origin master

echo "Copying dotfiles to ~ ..."
rsync -avh --no-perms "$dotfiles_dir"/ ~ \
	--exclude=".git/" \
	--exclude=".DS_Store" \
	--exclude=".gitignore" \
	--exclude="bootstrap.sh" \
	--exclude="Brewfile" \
	--exclude="README.md" \
	--exclude="AGENTS.md" \
	--exclude="resources"

# Set DOTFILES_DIR in ~/.exports
echo -e "\n# Dotfiles location (set by bootstrap.sh)\nexport DOTFILES_DIR=\"$dotfiles_dir\"" >> ~/.exports

echo "Sourcing ~/.bash_profile ..."
source ~/.bash_profile
