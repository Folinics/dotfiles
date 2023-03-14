#!/bin/bash

# Thanks to https://github.com/atomantic/dotfiles for revealing some key macOS settings
# commands!

#Save working directory
scriptDirectory=$(pwd)

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

# Save architecture type in variable. 1 for x86_64, 0 for ARM
architecture_type=source $(pwd)/macos/check_architecture.sh

#Install Homebrew
echo Installing Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
echo ✅ Done

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
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Rename" "@r"
echo ✅ Done

echo Turn off folders open in new tabs instead of windows. 
defaults write com.apple.finder FinderSpawnTab -bool false
echo ✅ Done

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
echo Installing wget...
brew install wget
echo ✅ Done

# Install Microsoft 365
echo Installing Microsoft 365...
wget -O Office.pkg "https://go.microsoft.com/fwlink/p/?linkid=2009112"
sudo installer -pkg Office.pkg -target /
echo ✅ Done

echo Installing Arc...
brew install --cask arc
echo ✅ Done

echo Installing Discord...
brew install --cask discord
echo ✅ Done

echo Installing Spotify...
brew install --cask spotify
echo ✅ Done

echo Installing Apple Music Discord Rich Text Presence...
brew tap nextfire/tap
brew install apple-music-discord-rpc
brew services restart apple-music-discord-rpc
echo ✅ Done

echo Installing Steam...
brew install --cask steam
echo ✅ Done

echo Installing VLC Media Player
brew install --cask vlc
echo ✅ Done

echo Installing Sound Control
brew install --cask sound-control
echo ✅ Done

echo Installing Parallels
brew install --cask parallels
echo ✅ Done

echo Installing Quicken...
brew install --cask quicken
echo ✅ Done

echo Installing OpenEmu...
brew install --cask openemu
echo ✅ Done

echo Installing PS Remote Play...
wget https://remoteplay.dl.playstation.net/remoteplay/module/mac/RemotePlayInstaller.pkg
sudo installer -pkg RemotePlayInstaller.pkg -target / && rm RemotePlayInstaller.pkg
echo ✅ Done

echo Installing Dolphin...
brew install --cask dolphin
echo ✅ Done

# ARM Macs do not support Elgato devices that utilize Game Capture HD. Following only executes on Intel Macs.
if [ architecture_type ]; then
  echo Installing Game Capture HD...
  wget https://edge.elgato.com/egc/macos/egcm/2.11.14/final/Game_Capture_HD_2.11.14.zip
  unzip Game_Capture_HD_2.11.14.zip
  mv "Game Capture HD.app" /Applications/
  rm Game_Capture_HD_2.11.14.zip
  echo ✅ Done
else
  echo Mac with ARM processor detected. Skipping Game Capture HD installation...
fi

echo Installing mas...
brew install mas
echo ✅ Done

echo Installing tabby...
brew install tabby
echo ✅ Done

echo Installing Visual Studio Code...
brew install --cask visual-studio-code
echo ✅ Done

echo Installing Suspicious Package...
brew install --cask suspicious-package
echo ✅ Done

echo Installing Plex Media Player...
brew install --cask plex
echo ✅ Done

echo Install GitHub Desktop...
brew install --cask github
echo ✅ Done

echo Install Docker...
brew install docker
echo ✅ Done

echo Installing DockUtil...
wget "https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg"
sudo installer -pkg dockutil-3.0.2.pkg -target / && rm dockutil-3.0.2.pkg
echo ✅ Done

echo Installing Transmission...
brew install --cask transmission
echo ✅ Done

echo Installing iStat Menus...
brew install --cask istat-menus
echo ✅ Done

echo Installing MuseScore...
brew install --cask musescore
echo ✅ Done

###
#
# Mac App Store
#
###

echo Installing Xcode...
mas install 497799835
echo ✅ Done

echo Installing Microsoft Remote Desktop from Mac App Store...
mas install 1295203466
echo ✅ Done

echo Install Final Cut Pro...
mas install 424389933
echo ✅ Done

echo Installing Jolt...
mas install 1437130425
echo ✅ Done

echo Installing NordVPN...
mas install 905953485
echo ✅ Done

echo Installing Magnet from Mac App Store...
mas install 441258766
echo ✅ Done

echo Installing Twitter...
mas install 1482454543
echo ✅ Done

echo Installing The Unarchiver...
mas install 425424353
echo ✅ Done

echo Installing Dashlane...
mas install 517914548
echo ✅ Done

echo Installing GarageBand...
mas install 682658836
echo ✅ Done

echo Installing Speedtest...
mas install 1153157709
echo ✅ Done

echo Installing Amazon Prime Video...
mas install 545519333
echo ✅ Done

echo Instaling WhatsApp...
mas install 1147396723
echo ✅ Done

echo Installing Bitwarden...
mas install 1352778147
echo ✅ Done

echo Installing iMovie...
mas install 408981434
echo ✅ Done

echo Installing Slack...
mas install 803453959
echo ✅ Done

echo Installing Onigiri...
mas install 1639917298
echo ✅ Done

echo Installing Yubico Authenticator...
mas install 1497506650
echo ✅ Done

# Clean up
rm -rf Office.pkg

###
#
# Set up Dock with persistent apps and preferred settings
#
###

#Change directory
cd $scriptDirectory
# Remove current dock plist
rm -rf ~/Library/Preferences/com.apple.dock.plist
#Copy provided plist
cp $(pwd)/com.apple.dock.plist ~/Library/Preferences/com.apple.dock.plist
#Restart dock
killall Dock

echo SETUP COMPLETE\! PLEASE REBOOT YOUR MACHINE BEFORE GETTING BACK TO WORK\!
