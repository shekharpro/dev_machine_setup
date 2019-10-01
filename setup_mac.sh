#!/usr/bin/env bash
# Ask for the administrator password upfront
sudo -v

echo "-----------------------------------------------------------------"
echo "----------------------Installing Homebrew------------------------"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "[Executing] : brew update"
brew update
echo "===================Done installing Homebrew======================"
echo "================================================================="
echo "--------------------------------------------------------------"
echo "----------------------Installing Casks------------------------"
echo "[Executing] : brew cask install launchbar"
brew cask install launchbar
echo "[Executing] : brew cask install shiftit"
brew cask install shiftit
echo "[Executing] : brew cask install visual-studio-code"
brew cask install visual-studio-code
echo "[Executing] : brew cask install evernote"
brew cask install evernote
echo "[Executing] : brew cask install firefox"
brew cask install firefox
echo "[Executing] : brew cask install spotify"
brew cask install spotify
echo "[Executing] : brew cask install zoomus"
brew cask install zoomus
echo "[Executing] : brew cask install 1password"
brew cask install 1password
echo "[Executing] : brew cask install iterm2"
brew cask install iterm2
echo "[Executing] : brew install android-studio"
brew cask install android-studio
echo "[Executing] : brew cask install google-chat"
brew cask install google-chat
echo "[Executing] : brew cask install macpass"
brew cask install macpass
echo "brew cask install postman"
brew cask install postman
echo "===================Done installing casks======================"
echo "=============================================================="
echo "-----------------------------------------------------------------"
echo "----------------------Installing Formulas------------------------"
echo "[Executing] : brew install gpg2"
brew install gpg2
echo "[Executing] : brew install nvm"
brew install nvm
echo "[Executing] : brew install autojump"
brew install autojump
echo "[Executing] : brew install npm"
brew install npm
echo "[Executing] : brew install yarn"
brew install yarn
echo "[Executing] : brew install tree"
brew install tree
echo "[Executing] : brew install htop"
brew install htop
echo "[Executing] : brew install tig"
brew install tig
echo "[Executing] : brew install bat"
brew install bat
echo "[Executing] : brew install oracle-jdk"
brew install oracle-jdk
echo "[Executing] : brew cleanup"
brew cleanup
echo "===================Done installing Formulas======================"
echo "================================================================="
echo "------------------------------------------------------------"
echo "----------------------Updating zshrc------------------------"
echo "[Executing] : Installing ZSH : sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\" \"\" --unattended"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

#-----------------------------------------------------
#-----------------------------------------------------
#-----------------------------------------------------

echo "[Executing] : Appending Autojump to Zshrc"
echo "[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh" >> ~/.zshrc
echo "[Executing] : Appending NVM to zshrc"
echo "export NVM_DIR=\"$HOME/.nvm\"
  [ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm
  [ -s \"/usr/local/opt/nvm/etc/bash_completion\" ] && . \"/usr/local/opt/nvm/etc/bash_completion\"  # This loads nvm bash_completion" >> ~/.zshrc
echo "[Executing] : Sourcing ~/.zshrc"
source ~/.zshrc
echo "[Executing] : Done Sourcing"
echo "===================Done Updating zshrc======================"
echo "============================================================"
echo "---------------------------------------------------------------"
echo "----------------------Installing NodeJs------------------------"
echo "[Executing] : nvm install node"
nvm install node
echo "===================Done Installing NodeJS======================"
echo "==============================================================="
echo "---------------------------------------------------------------------"
echo "----------------------Updating Apple Settings------------------------"
#From https://github.com/donnemartin/dev-setup/blob/master/osx.sh
echo "[Executing] : defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder

# Expand save panel by default
echo "[Executing] : defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
echo "[Executing] : defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Save to disk (not to iCloud) by default
echo "[Executing] : defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Disable the crash reporter
echo "[Executing] : defaults write com.apple.CrashReporter DialogType -string \"none\""
defaults write com.apple.CrashReporter DialogType -string "none"
# Check for software updates daily, not just once per week
echo "[Executing] : defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# Disable smart quotes as they’re annoying when typing code
echo "[Executing] : defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
# Trackpad: enable tap to click for this user and for the login screen
echo "[Executing] : defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
echo "[Executing] : defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
echo "[Executing] : defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Increase sound quality for Bluetooth headphones/headsets
echo "[Executing] : defaults write com.apple.BluetoothAudioAgent \"Apple Bitpool Min (editable)\" -int 40"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# Disable press-and-hold for keys in favor of key repeat
echo "[Executing] : defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
echo "[Executing] : defaults write NSGlobalDomain KeyRepeat -int 1"
defaults write NSGlobalDomain KeyRepeat -int 1
echo "[Executing] : defaults write NSGlobalDomain InitialKeyRepeat -int 15"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Require password immediately after sleep or screen saver begins
echo "[Executing] : defaults write com.apple.screensaver askForPassword -int 1"
defaults write com.apple.screensaver askForPassword -int 1
echo "[Executing] : defaults write com.apple.screensaver askForPasswordDelay -int 0"
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
echo "[Executing] : defaults write com.apple.finder QuitMenuItem -bool true"
defaults write com.apple.finder QuitMenuItem -bool true
# Show icons for hard drives, servers, and removable media on the desktop
echo "[Executing] : defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
echo "[Executing] : defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
echo "[Executing] : defaults write com.apple.finder ShowMountedServersOnDesktop -bool true"
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
echo "[Executing] : defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Finder: show hidden files by default
echo "[Executing] : defaults write com.apple.finder AppleShowAllFiles -bool true"
defaults write com.apple.finder AppleShowAllFiles -bool true
# Finder: show all filename extensions
echo "[Executing] : defaults write NSGlobalDomain AppleShowAllExtensions -bool true"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder: show status bar
echo "[Executing] : defaults write com.apple.finder ShowStatusBar -bool true"
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: show path bar
echo "[Executing] : defaults write com.apple.finder ShowPathbar -bool true"
defaults write com.apple.finder ShowPathbar -bool true
# Finder: allow text selection in Quick Look
echo "[Executing] : defaults write com.apple.finder QLEnableTextSelection -bool true"
defaults write com.apple.finder QLEnableTextSelection -bool true
# Display full POSIX path as Finder window title
echo "[Executing] : defaults write com.apple.finder _FXShowPosixPathInTitle -bool true"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
echo "[Executing] : defaults write com.apple.finder FXDefaultSearchScope -string \"SCcf\""
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
echo "[Executing] : defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
echo "[Executing] : defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
echo "[Executing] : defaults write com.apple.finder FXPreferredViewStyle -string \"clmv\""
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Disable the warning before emptying the Trash
echo "[Executing] : defaults write com.apple.finder WarnOnEmptyTrash -bool false"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Show the ~/Library folder
echo "[Executing] : hflags nohidden ~/Library"
chflags nohidden ~/Library
# Show indicator lights for open applications in the Dock
echo "[Executing] : defaults write com.apple.dock show-process-indicators -bool true"
defaults write com.apple.dock show-process-indicators -bool true
# Remove the auto-hiding Dock delay
echo "[Executing] : defaults write com.apple.dock autohide-delay -float 0"
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
echo "[Executing] : defaults write com.apple.dock autohide-time-modifier -float 0"
defaults write com.apple.dock autohide-time-modifier -float 0
# Automatically hide and show the Dock
echo "[Executing] : defaults write com.apple.dock autohide -bool true"
defaults write com.apple.dock autohide -bool true


###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Only use UTF-8 in Terminal.app
echo "[Executing] : defaults write com.apple.terminal StringEncodings -array 4"
defaults write com.apple.terminal StringEncodings -array 4

# Don’t display the annoying prompt when quitting iTerm
echo "[Executing] : defaults write com.googlecode.iterm2 PromptOnQuit -bool false"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Kill affected applications                                                  #
###############################################################################
echo "[Executing] : Killing  cfprefsd Dock Finder Safari SystemUIServer"
for app in "cfprefsd" "Dock" "Finder" \
    "Safari" "SystemUIServer"; do
    killall "${app}" > /dev/null 2>&1
done
echo "===================Done Updating Apple Settings======================"
echo "====================================================================="

echo "[Executing] : Copying VIMRC : dot_vimrc ~/.vimrc"
cp dot_vimrc ~/.vimrc

echo "Done. Note that some of these changes require a logout/restart of your OS to take effect.  At a minimum, be sure to restart your Terminal."
echo "|||||||||THINGS TO SETUP MANUALLY|||||||||"
echo "||-> Xcode (From Appstore)"
echo "||-> Three Finger Drag"
echo "||-> CMD+Scroll Zoom (Accessibility -> Zoom -> Use Scroll gesture with modifier keys to zoom (Change to CMD)"
echo "||-> CMD+Scroll Zoom (Accessibility -> Mouse & Trackpad -> Trackpad Options... -> Enabble Dragging -> Three Finger Drag"

