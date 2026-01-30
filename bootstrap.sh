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

echo
echo "Syncing dotfiles to ~
rsync -avh --no-perms "$DIR/dotfiles/" ~ --exclude=".DS_Store"

echo
echo "Setting DOTFILES_DIR in ~/.exports ..."
echo -e "\n# Dotfiles location (set by bootstrap.sh)\nexport DOTFILES_DIR=\"$DIR\"" >> ~/.exports

echo
echo "Creating skills symlinks ..."
for dir in ~/.cursor ~/.claude ~/.gemini; do
    mkdir -p "$dir"
    ln -sfn "$DIR/resources/skills" "$dir/skills"
done

echo
echo "Reloading shell ..."
echo
echo
set +e  # Disable exit-on-error for bash_profile (some commands return non-zero normally)
source ~/.bash_profile
