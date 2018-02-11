#!/usr/bin/env bash

set -e
set -o nounset

# =========================================================================
# Variables
# -------------------------------------------------------------------------

DEV_DIR="$HOME/Development"
DW="defaults write"
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"

PACKAGES=(
  bash-completion2
  coreutils
  git
  heroku
  markdown
  mosh
  nmap
  p7zip
  python3
  rename
  ruby
  ssh-copy-id
  stow
  thefuck
  tldr
  tmux
  tree
  vim
  wget
  xz
)

CASKS=(
  1password
  docker
  dropbox
  firefox
  google-chrome
  keepingyouawake
  macdown
  slack
  virtualbox
  vlc
)

FONTS=(
  font-inconsolidata
  font-roboto
  font-clear-sans
)


# =========================================================================
# Functions
# -------------------------------------------------------------------------

function get_brew_status () {
  package="$1"
  cask="$2"
  brew "$cask" info "$package" 2>&1 | grep -Eq '^Not installed$'
}

function get_user_shell () {
  dscl . -read "$HOME" | grep -E '^UserShell' | awk '{print $2}'
}


# =========================================================================
# Main
# -------------------------------------------------------------------------

echo "Starting bootstrap..."


# Create environment
if [[ ! -d "$DEV_DIR" ]]; then mkdir "$DEV_DIR"; fi


# Install Xcode
if [[ "$(xcode-select -v >/dev/null 2>&1)" -ne "0" ]]; then
  echo "Installing Xcode..."
  xcode-select --install
fi


# Install Homebrew
if [[ ! -x "$(which brew)" ]]; then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL ${BREW_URL})" >/dev/null
fi


# Update homebrew recipes
echo "Refreshing Homebrew..."
brew update >/dev/null


# Install packages
echo "Installing packages..."
for package in "${PACKAGES[@]}"
do
  if get_brew_status "$package" ""; then
    echo " - installing $package"
    brew install "$package" >/dev/null
  elif brew outdated "$package" | grep -q "$package"; then
    echo " - upgrading $package"
    brew upgrade "$package"
  fi
done


echo "Installing casks..."
brew tap caskroom/cask
for cask in "${CASKS[@]}"
do
  if get_brew_status "$package" "cask"; then
    brew cask install "$cask" >/dev/null
  fi
done


echo "Installing fonts..."
brew tap caskroom/fonts
for font in "${FONTS[@]}"
do
  if get_brew_status "$font" "cask"; then
    brew cask install "$font" >/dev/null
  fi
done


echo "Cleaning up..."
brew cleanup


# Upgrade to Bash 4
if [ "$(get_user_shell)" != "/usr/local/bin/bash" ]; then
  echo "Upgrading Bash..."
  if [[ "$(grep -q '/usr/local/bin/bash' /etc/shells)" -ne 0 ]]; then
    sudo bash -c "echo '/usr/local/bin/bash' >> /etc/shells"
  fi
  echo -n "Setting default shell... "
  chsh -s /usr/local/bin/bash "$(whoami)"
  get_user_shell
fi


echo "Configuring OS defaults..."

# ==== App Settings ====

# Prevent Time Machine from prompting to use new hard drives as backup volume
"$DW" com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Automatically quit printer app once the print jobs complete
"$DW" com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true


# ==== Desktop Settings ====

# Set to auto-hide
"$DW" com.apple.dock autohide -bool true

# Convert to taskbar
"$DW" com.apple.dock static-only -bool true

# Hot corner (bottom-left): show desktop
"$DW" com.apple.dock wvous-bl-corner -int 4
"$DW" com.apple.dock wvous-bl-modifier -int 0

# Hot corner (bottom-right): screen saver
"$DW" com.apple.dock wvous-br-corner -int 5
"$DW" com.apple.dock wvous-br-modifier -int 0

# Hot corner (top-left): mission control
"$DW" com.apple.dock wvous-tl-corner -int 2
"$DW" com.apple.dock wvous-tl-modifier -int 0

# Hot corner (top-right): application windows
"$DW" com.apple.dock wvous-tr-corner -int 3
"$DW" com.apple.dock wvous-tr-modifier -int 0


# ==== Filesystem Settings ====

# Avoid creating .DS_Store files on network volumes
"$DW" com.apple.desktopservices DSDontWriteNetworkStores -bool true


# ==== Finder Settings ====

# Show filename extensions by default
"$DW" NSGlobalDomain AppleShowAllExtensions -bool true

# Hide icons for hard drives, servers, and removable media on the desktop"
"$DW" com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

# Show status bar by default
"$DW" com.apple.finder ShowStatusBar -bool true

# Show Finder breadcrumb menu
"$DW" com.apple.finder ShowPathbar -bool true

# Disable the warning when changing a file extension
"$DW" com.apple.finder FXEnableExtensionChangeWarning -bool false

# Default view style
"$DW" com.apple.finder FXPreferredViewStyle -string "clmv"


# ==== I/O Settings ====

# Enable tap-to-click
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
"$DW" com.apple.AppleMultitouchTrackpad Clicking -bool true
"$DW" -currentHost NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Two finger tap to right-click
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# Enable hand resting
"$DW" com.apple.AppleMultitouchTrackpad TrackpadHandResting -bool true

# Pinch to zoom
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true

# Two finger rotate
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true

# Two finger horizontal swipe between pages
"$DW" NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true

# Three finger horizontal swipe between pages
"$DW" -currentHost NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1
"$DW" com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerHorizSwipeGesture -int 1

# Show Notification Center with two finger swipe from fight edge
"$DW" -currentHost NSGlobalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 3
"$DW" com.apple.AppleMultitouchTrackpad                  TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

# Smart zoom
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1

# Three finger tap to look up
"$DW" com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 2


# ==== Safari Settings ====

# Enable the Debug menu
"$DW" com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu
"$DW" com.apple.Safari IncludeDevelopMenu -bool true

# Enable the Web Inspector
"$DW" com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
"$DW" com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true


# ==== System Settings ====

# Check for software updates daily
"$DW" com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Require password as soon as screensaver or sleep mode starts
"$DW" com.apple.screensaver askForPassword -int 1

# Grace period for requiring password to unlock
"$DW" com.apple.screensaver askForPasswordDelay -int 5


# ==== Terminal Settings ====
"$DW" com.apple.Terminal "Default Window Settings" -string "Novel Custom"
"$DW" com.apple.Terminal "Startup Window Settings" -string "Novel Custom"
"$DW" write com.apple.terminal StringEncodings -array 4
"$DW" com.apple.terminal FontAntialias -bool true
"$DW" com.apple.terminal ShowActiveProcessInTitle -bool false
"$DW" com.apple.terminal columnCount -float 100.00