#!/usr/bin/env bash
# Ask for the administrator password upfront
sudo -v


BOLD='\033[1;m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
color_off='\033[0m'

runSetup() {
  local brewFormulas=(
    "1password",
    "android-studio",
    "autojump",
    "bat",
    "dbeaver-community",
    "dotnet-sdk",
    "evernote",
    "fzf",
    "font-fira-code-nerd-font",
    "font-jetbrains-mono-nerd-font",
    "firefox",
    "gpg2",
    "google-chat",
    "htop",
    "iterm2",
    "jq",
    "kaf",
    "launchbar",
    "macpass",
    "nvm",
    "npm",
    "nvim",
    "oracle-jdk",
    "pomerium-cli",
    "postman",
    "rectangle",
    "spotify",
    "tig",
    "tree",
    "visual-studio-code",
    "yarn",
    "zed",
    "zoomus"
  )

  brew_init
  for formula in "${brewFormulas[@]}"; do
    brew_install $formula
  done
  brew_cleanup
  update_zshrc
  zsh_setup_plugins_and_themes
  install_latest_nodejs
  add_custom_functions_to_zshrc
  update_apple_settings
}

brew_init() {
  local brewtaps=(
    "homebrew/cask-fonts"
    "birdayz/kaf"
    "pomerium/tap"
  )
  print_header "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_footer "Done Installing Homebrew"

  print_header "Setting Homebrew Taps"
  for tap in "${brewtaps[@]}"; do
    brew_tap $tap
  done
  print_footer "Done Setting Homebrew Taps"
}

brew_install() {
  echo $BOLD$YELLOW"[Executing] $color_off : $BLUE brew install $GREEN$1"$color_off
  brew install $1
}

brew_cleanup() {
  echo $BOLD$YELLOW"[Executing] $color_off : $BLUE brew cleanup"$color_off
  brew cleanup
}

brew_tap() {
  echo $BOLD$YELLOW"[Executing] $color_off : $BLUE brew tap $GREEN$1"$color_off
  brew tap $1
}

update_zshrc() {
  print_header "Updating zshrc"
  echo $BOLD$YELLOW"[Executing] $color_off : Installing ZSH :$BLUE sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"$color_off
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo $BOLD$YELLOW"[Executing] $color_off :  Appending Autojump to Zshrc"
  echo "[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh" >> ~/.zshrc
  echo $BOLD$YELLOW"[Executing] $color_off :  Appending NVM to zshrc"
  echo "export NVM_DIR=\"$HOME/.nvm\"
    [ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm
    [ -s \"/usr/local/opt/nvm/etc/bash_completion\" ] && . \"/usr/local/opt/nvm/etc/bash_completion\"  # This loads nvm bash_completion" >> ~/.zshrc
  echo $BOLD$YELLOW"[Executing] $color_off :  Sourcing ~/.zshrc"
  source ~/.zshrc || echo "Error sourcing ~/.zshrc"
  print_footer "Done updating zshrc"
}

zsh_setup_plugins_and_themes() {
  print_header "Installing powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  print_header "Done installing powerlevel10k"
  print_header "Installing zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  print_header "Done zsh-autosuggestions"
  print_header "Installing zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  print_header "Done install zsh-syntax-highlighting"
  print_header "Enabling zsh plugins and setting zsh theme"
  omz plugin enable zsh-autosuggestions
  omz plugin enable zsh-syntax-highlighting
  omz theme use powerlevel10k/powerlevel10k
  print_header "Done enabling zsh plugins and setting zsh theme"
}

install_latest_nodejs() {
  print_header "Installing latest Node.js"
  echo $BOLD$YELLOW"[Executing] $color_off : $BLUE nvm install$GREEN node"$color_off
  nvm install node
  print_footer "Done installing latest Node.js"
}

add_custom_functions_to_zshrc() {
  print_header "Adding custom functions to zshrc"
  echo $BOLD$YELLOW"[Executing] $color_off : Adding pull_rebase_directory Function"
  cat <<-'EOF' >> ~/.zshrc
  pull_rebase_directory () {
    count=1
    currentDirectory=$(pwd)
    for i in */.git
    do
      cd $i/..
      echo "\u001b[47m\u001b[30;1mQueuing Update for Git Repo () [ $(pwd) ]\u001b[0m"
      git stash && git pull -r --all &
      # echo "\u001b[47m\u001b[30;1m-- Done Updating the Repo--\u001b[0m"
      cd $currentDirectory
      ((count++))
    done
    wait
    echo "\u001b[47m\u001b[30;1m-- Done Updating [$count] Repos--\u001b[0m"
  }
EOF

  echo $BOLD$YELLOW"[Executing] $color_off : Adding kafka_helper_count_messages Function"
  cat <<-'EOF' >> ~/.zshrc
  kafka_helper_count_messages() {
    while getopts b:t: flag
    do
        case "${flag}" in
            b) broker=${OPTARG};;
            t) topic=${OPTARG};;
        esac
    done
    local endCount=$(kafka-run-class.sh kafka.tools.GetOffsetShell --bootstrap-server="$broker"  --topic  "$topic" --time -1 |  awk -F  ":" '{sum += $3} END {print sum}')
    local startCount=$(kafka-run-class.sh kafka.tools.GetOffsetShell --bootstrap-server="$broker"  --topic  "$topic" --time -2 |  awk -F  ":" '{sum += $3} END {print sum}')
    local diff=$((endCount-startCount))
    LC_NUMERIC="en_US"
    local formattedDiff=$(builtin printf "%'d\n" $diff)
    local formattedEndCount=$(builtin printf "%'d\n" endCount)
    local formattedStartCount=$(builtin printf "%'d\n" startCount)
    echo "StartCount: $formattedStartCount | EndCount:$formattedEndCount | Total In Topic $topic: $formattedDiff"
    #echo "{\"topic\": ""$topic"", \"startCount\": \"""$formattedStartCount""\", \"endCount\": \"""$formattedEndCount\""", \"total_in_topic\": \"""$formattedDiff""\"}" | jq
  }
EOF
  print_footer "Done adding custom functions to zshrc"
}

update_apple_settings() {
  #From https://github.com/donnemartin/dev-setup/blob/master/osx.sh
  print_header "Updating Apple Settings"
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder

  # Expand save panel by default
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  # Save to disk (not to iCloud) by default
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false"
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  # Disable the crash reporter
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.CrashReporter DialogType -string \"none\""
  defaults write com.apple.CrashReporter DialogType -string "none"
  # Check for software updates daily, not just once per week
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1"
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
  # Disable smart quotes as they’re annoying when typing code
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false"
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false


  ########################################################################
  # Trackpad, mouse, keyboard, Bluetooth accessories, and input          #
  ########################################################################
  # Trackpad: enable tap to click for this user and for the login screen
  echo $BOLD$YELLOW"[Executing] $color_off  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  echo $BOLD$YELLOW"[Executing] $color_off : defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  # Increase sound quality for Bluetooth headphones/headsets
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.BluetoothAudioAgent \"Apple Bitpool Min (editable)\" -int 40"
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
  # Disable press-and-hold for keys in favor of key repeat
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set a blazingly fast keyboard repeat rate
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain KeyRepeat -int 1"
  defaults write NSGlobalDomain KeyRepeat -int 1
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain InitialKeyRepeat -int 15"
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Require password immediately after sleep or screen saver begins
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.screensaver askForPassword -int 1"
  defaults write com.apple.screensaver askForPassword -int 1
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.screensaver askForPasswordDelay -int 0"
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder QuitMenuItem -bool true"
  defaults write com.apple.finder QuitMenuItem -bool true
  # Show icons for hard drives, servers, and removable media on the desktop
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true"
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true"
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder ShowMountedServersOnDesktop -bool true"
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true"
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  # Finder: show hidden files by default
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder AppleShowAllFiles -bool true"
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # Finder: show all filename extensions
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write NSGlobalDomain AppleShowAllExtensions -bool true"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # Finder: show status bar
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder ShowStatusBar -bool true"
  defaults write com.apple.finder ShowStatusBar -bool true
  # Finder: show path bar
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder ShowPathbar -bool true"
  defaults write com.apple.finder ShowPathbar -bool true
  # Finder: allow text selection in Quick Look
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder QLEnableTextSelection -bool true"
  defaults write com.apple.finder QLEnableTextSelection -bool true
  # Display full POSIX path as Finder window title
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder _FXShowPosixPathInTitle -bool true"
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  #
  # When performing a search, search the current folder by default
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder FXDefaultSearchScope -string \"SCcf\""
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  # Disable the warning when changing a file extension
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  #
  # Avoid creating .DS_Store files on network volumes
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  # Use column view in all Finder windows by default
  # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder FXPreferredViewStyle -string \"clmv\""
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
  #
  # Disable the warning before emptying the Trash
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.finder WarnOnEmptyTrash -bool false"
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  # Show the ~/Library folder
  echo $BOLD$YELLOW"[Executing] $color_off : hflags nohidden ~/Library"
  chflags nohidden ~/Library
  # Show indicator lights for open applications in the Dock
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.dock show-process-indicators -bool true"
  defaults write com.apple.dock show-process-indicators -bool true
  # Remove the auto-hiding Dock delay
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.dock autohide-delay -float 0"
  defaults write com.apple.dock autohide-delay -float 0
  # Remove the animation when hiding/showing the Dock
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.dock autohide-time-modifier -float 0"
  defaults write com.apple.dock autohide-time-modifier -float 0
  # Automatically hide and show the Dock
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.dock autohide -bool true"
  defaults write com.apple.dock autohide -bool true
  #
  #
  ########################################################################
  # Terminal & iTerm 2                                                   #
  ########################################################################
  #
  # Only use UTF-8 in Terminal.app
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.apple.terminal StringEncodings -array 4"
  defaults write com.apple.terminal StringEncodings -array 4
  #
  # Don’t display the annoying prompt when quitting iTerm
  echo $BOLD$YELLOW"[Executing] $color_off : defaults write com.googlecode.iterm2 PromptOnQuit -bool false"
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false
  #
  ########################################################################
  # Kill affected applications                                           #
  ########################################################################
  echo $BOLD$YELLOW"[Executing] $color_off : Killing  cfprefsd Dock Finder Safari SystemUIServer"
  for app in "cfprefsd" "Dock" "Finder" "Safari" "SystemUIServer"; do
      killall "${app}" > /dev/null 2>&1
  done
  print_footer "Done updating Apple Settings"
}

print_header() {
  print_centered_string "" "="
  print_centered_string "$1" "-"
  print_centered_string "" "-"
}

print_footer() {
  print_centered_string "" "-"
  print_centered_string "$1" "-"
  print_centered_string "" "="
  echo "\n"
}

print_centered_string() {
  # Check if at least two arguments are provided
  if [ $# -lt 2 ]; then
  echo "Usage: $FUNCNAME <string_to_center> <surrounding_character>"
  exit 1
  fi

  string_to_center="$1"
  surrounding_char="$2"
  # output_width=$(tput cols)
  output_width=80

  padding_size_left=$(( (output_width - ${#string_to_center}) / 2 ))
  padding_size_right=$(( (output_width - ${#string_to_center}) / 2 ))

  total_output_width=$((padding_size_left + padding_size_right + ${#string_to_center}))
  if [ $((total_output_width != output_width)) ]; then
    padding_size_right=$((padding_size_right + (output_width - total_output_width)))
  fi

  function repeat(){
    printf "%*s" $1 | tr ' ' "$2"
  }

  echo $(repeat $padding_size_left "$surrounding_char")"$string_to_center"$(repeat $padding_size_right "$surrounding_char")
}

runSetup

echo $BOLD$YELLOW"[Executing] $color_off : Copying VIMRC : dot_vimrc ~/.vimrc"
cp dot_vimrc ~/.vimrc

echo "Done. Note that some of these changes require a logout/restart of your OS to take effect.  At a minimum, be sure to restart your Terminal."
echo "|||||||||THINGS TO SETUP MANUALLY|||||||||"
echo "||-> Xcode (From Appstore)"
echo "||-> Three Finger Drag"
echo "||-> CMD+Scroll Zoom (Accessibility -> Zoom -> Use Scroll gesture with modifier keys to zoom (Change to CMD)"
echo "||-> CMD+Scroll Zoom (Accessibility -> Mouse & Trackpad -> Trackpad Options... -> Enabble Dragging -> Three Finger Drag"
