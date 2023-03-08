#!/bin/bash

# Thanks to https://github.com/atomantic/dotfiles for revealing some key macOS settings
# commands!

#Save script directory
scriptDirectory = $pwd

echo [Setting up macOS]

echo [Who is logged in?]
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

echo Closing any system preferences to prevent issues with automated changes
osascript -e 'tell application "System Preferences" to quit'
echo ✅ Done

echo Requesting sudo elevation before proceeding
sudo -v
# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
echo ✅ Done

# Add symbolic links to the dotfiles in this directory
echo Installing Rosetta 2
source $(pwd)/macos/install_rosetta.sh
echo ✅ Done

#Install Homebrew
echo Installing Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
echo ✅ Done

# Install Xcode Command Line Tools
xcode-select --install

###
#
# macOS Settings
#
###

# Set appearance mode to Auto
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true
echo Appearance set to 'Auto'. Changes will take effect on next login.
echo ✅ Done


echo Setting screenshots to save to a screenshots folder on the Desktop.
mkdir ~/Desktop/Screenshots
defaults write com.apple.screencapture location ~/Desktop/Screenshots
echo ✅ Done

echo Showing status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
echo ✅ Done

echo Setting hidden files to always appear in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
echo ✅ Done

echo Showing all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo ✅ Done

echo Setting new Finder windows to start in '$Home'
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
echo ✅ Done

echo Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
echo ✅ Done

echo Show full path in Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
echo ✅ Done

echo Add Rename shortcut to Finder
defaults com.apple.finder NSUserKeyEquivalents -dict-add "Rename" "@r"
echo ✅ Done

#Turn off folders open in new tabs instead of windows. 
defaults write com.apple.finder FinderSpawnTab -bool false

echo Restarting Finder
killall Finder
echo ✅ Done

echo Adding additional filetype support to Finder\'s preview
brew install --cask quicklook-json quicklook-csv qlimagesize webpquicklook qlvideo
echo ✅Done


###
#
# Applications
#
###

# Set Downloads as working directory
cd ~/Downloads

# Install wget
echo Installing wget
brew install wget
echo ✅ Done

# Install Microsoft 365
wget -O Office.pkg "https://go.microsoft.com/fwlink/p/?linkid=2009112"
sudo installer -pkg Office.pkg -target / && rm Office.pkg


echo Installing Discord
brew install --cask discord
echo ✅ Done

echo Installing mas
brew install mas
echo ✅ Done

echo Installing tabby
brew install tabby
echo ✅ Done

echo Installing Visual Studio Code
brew install --cask visual-studio-code
echo ✅ Done

echo Installing Slack
brew install Slack
echo ✅ Done

echo Installing Suspicious Package
wget https://www.mothersruin.com/software/downloads/SuspiciousPackage.dmg
hdiutil attach SuspiciousPackage.dmg
cp -R "Suspicious Package.app" ~/Applications/


echo Installing Plex Media Player
brew install --cask plex-media-player
echo ✅ Done

echo Installing mackup
brew install mackup
echo ✅ Done

echo Install GitHub Desktop
brew install --cask github
echo ✅ Done

echo Install Docker
brew install docker
echo ✅ Done

echo Installing DockUtil
brew install dockutil
echo ✅ Done

###
#
# Mac App Store
#
###

echo Install Microsoft Remote Desktop from Mac App Store
mas install 1295203466
echo ✅ Done


echo Install Magnet from Mac App Store
mas install 441258766
echo ✅ Done


###
#
# Config Files
#
###

# Add symbolic links to the dotfiles in this directory
cd $scriptDirectory
source $(pwd)/add_symlinks.sh

###
#
# Post-Setup Steps
#
###

echo Writing a list of additional manual steps to ~/Desktop/NextSteps.txt
echo $'Configuration:
[ ] Finder (Finder > Preferences)
  [ ] Under Sidebar > Favorites, only CHECK the following:
    [ ] iCloud Drive
    [ ] Applications
    [ ] Desktop
    [ ] Documents
    [ ] Downloads
    [ ] mmiller (~/)
[ ] Dock
  [ ] Set Download folder to sort by "Date Added"
  [ ] Set Download folder to display as "Folder"
  [ ] Set Download folder to view content as "Grid"
[ ] Terminal (After installing shell themes)
  [ ] Set Homebrew theme\'s font to the installed Powerline font (12pt)
  [ ] Check "Use bright colors for bold text"
[ ] Keyboard (Preferences > Keyboard > Input Sources)
  [ ] Set up Japanese IME
    [ ] Uncheck all Input Modes except for default Hiragana
[ ] Internet Accounts (Preferences > Internet Accounts)
  [ ] Activate "Contacts" and "Calendars" for any inactive Google accounts"

Arrangement:

- The DOCK\'s pinned applications are typically arranged as such (left-to-right):
  - Finder, Firefox, Chrome, VS Code, <git client>, <chat clients>,
- The FINDER\'s sidebar Favorites section is typically arranged as such (top-to-bottom):
  - iCloud Drive, Desktop, Userfolder (~/), Applications, Repos, Screenshots, Downloads, Documents
- The MENU BAR\'s bits are typically arranged as such (left-to-right):
  - 1Password, Volume, Wifi, VPN, Bluetooth, MacOS Battery
'> ~/Desktop/NextSteps.txt
echo ✅ Done

echo SETUP COMPLETE\! PLEASE REBOOT YOUR MACHINE BEFORE GETTING BACK TO WORK\!
