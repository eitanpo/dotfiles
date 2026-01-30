#!/usr/bin/env bash
set -e

# Sync dotfiles
read -p "This may overwrite files in ~. Continue? (y/n) " -n 1; echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew and packages if missing
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew ..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"

	echo "Installing packages ..."
	brew bundle --file="$DIR/resources/Brewfile"
	brew cleanup
fi

# macOS lacks sha256sum; symlink GNU version
[ ! -f "$(brew --prefix)/bin/sha256sum" ] && [ -f "$(brew --prefix)/bin/gsha256sum" ] && \
	ln -s "$(brew --prefix)/bin/gsha256sum" "$(brew --prefix)/bin/sha256sum"

# Set brew bash as default shell (if not already)
BREW_BASH="$(brew --prefix)/bin/bash"
if [ -f "$BREW_BASH" ]; then
	/usr/bin/grep -Fq "$BREW_BASH" /etc/shells || {
		echo "Adding $BREW_BASH to /etc/shells ..."
		echo "$BREW_BASH" | sudo tee -a /etc/shells
	}
	CURRENT_SHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
	[ "$CURRENT_SHELL" != "$BREW_BASH" ] && {
		echo "Setting $BREW_BASH as default shell ..."
		chsh -s "$BREW_BASH"
	}
fi

read -p "Pull latest from GitHub? (y/n) " -n 1; echo
[[ $REPLY =~ ^[Yy]$ ]] && git -C "$DIR" pull origin master

echo
echo "Syncing dotfiles to ~"
rsync -avh --no-perms "$DIR/dotfiles/" ~ --exclude=".DS_Store"

echo
echo "Setting DOTFILES_DIR in ~/.exports"
echo -e "\n# Dotfiles location (set by bootstrap.sh)\nexport DOTFILES_DIR=\"$DIR\"" >> ~/.exports

echo
echo "Creating skills symlinks"
for dir in ~/.cursor ~/.claude ~/.gemini; do
    mkdir -p "$dir"
    ln -sfn "$DIR/resources/skills" "$dir/skills"
done

echo
echo "Reloading shell ..."
echo
if [ -f "$BREW_BASH" ] && [ "$BASH" != "$BREW_BASH" ]; then
	exec "$BREW_BASH" -l
else
	set +e  # Disable exit-on-error for bash_profile (some commands return non-zero normally)
	source ~/.bash_profile
fi
