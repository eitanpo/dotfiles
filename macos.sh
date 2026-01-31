#!/usr/bin/env bash

# macOS settings - only non-default values
# Based on actual system state, excluding vanilla macOS defaults

# Close System Settings to prevent conflicts (renamed from System Preferences in Ventura)
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

# Ask for admin password upfront
sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Always show scrollbars (default: Automatic)
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Dark mode (default: Light)
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Restore windows when reopening apps (default: OFF)
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true

# Save to disk, not iCloud (default: iCloud)
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand save panel by default (default: collapsed)
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable auto-capitalization (default: ON)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes (default: ON)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes (default: ON)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable automatic period substitution (default: ON)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable auto-correct (default: ON)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Keyboard & Trackpad                                                         #
###############################################################################

# Full keyboard access: Tab navigates all controls (default: text fields only)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Fast key repeat (default: 6/35) - great for vim/terminal
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys (enables key repeat instead of accent menu)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Enable tap to click (default: OFF)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder                                                                      #
###############################################################################

# New Finder windows open in Downloads
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

# Show hidden files (default: OFF)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions (default: OFF)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar (default: OFF)
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar (default: OFF)
defaults write com.apple.finder ShowPathbar -bool true

# Use list view by default (default: icon view)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default (default: entire Mac)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Hide tags in sidebar (default: ON)
defaults write com.apple.finder ShowRecentTags -bool false

# Avoid creating .DS_Store files on network or USB volumes
# Note: Unreliable since Ventura for ._ files, but still reduces DS_Store creation
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library 2>/dev/null

###############################################################################
# Dock                                                                        #
###############################################################################

# Auto-hide the Dock (default: OFF)
defaults write com.apple.dock autohide -bool true

# Faster Dock show/hide animation (default: 0.5)
defaults write com.apple.dock autohide-time-modifier -float 0.2

# Don't auto-rearrange Spaces by recent use (default: ON)
defaults write com.apple.dock mru-spaces -bool false

# Don't show recent applications in Dock (default: ON)
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Disable Spotlight indexing (default: ON)
sudo mdutil -a -i off

###############################################################################
# Terminal                                                                    #
###############################################################################

# Import Solarized Dark theme if not already present
THEME_NAME="Solarized Dark xterm-256color"
THEME_FILE="$DOTFILES_DIR/resources/${THEME_NAME}.terminal"
if ! defaults read com.apple.terminal "Window Settings" 2>/dev/null | grep -q "$THEME_NAME"; then
	if [ -f "$THEME_FILE" ]; then
		echo "Importing Terminal theme: $THEME_NAME"
		open "$THEME_FILE"
		sleep 1  # Wait for Terminal to import
	fi
fi

# Set as default theme
defaults write com.apple.terminal "Default Window Settings" -string "$THEME_NAME"
defaults write com.apple.terminal "Startup Window Settings" -string "$THEME_NAME"

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show all processes (default: My Processes)
defaults write com.apple.ActivityMonitor ShowCategory -int 0

###############################################################################
# Apply changes                                                               #
###############################################################################

echo ""
read -p "Kill affected processes to apply changes? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	for app in "Dock" "Finder" "SystemUIServer" "Terminal"; do
		killall "${app}" &> /dev/null
	done
fi

echo ""
echo "Done. Some changes may require logout/restart."
