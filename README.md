# dev_machine_setup
Script to install common used tools on a new Mac (WIP)

This repo contains scripts to configure new OS X dev machines. The script will install/upgrade few utilities and development tools.

Configuring a new computer

    Install XCode from the Mac App Store; and start Xcode so you can accept the terms & conditions before moving on
    Enter your system password when prompted to start the setup

## Applications 
- Homebrew : https://brew.sh/
- launchbar : https://www.obdev.at/products/launchbar/index.html
- shiftit : https://github.com/fikovnik/ShiftIt
- Visual Studio Code
- Dotnet Core SDK
- Firefox
- Evernote
- Spotify
- Zoomus
- 1Password
- iTerm2
- Android-studio
- Google-chat
- Macpass
- Postman
- JetBrains Ner Fonts
- Dbeaver-Community

## Tools
- gpg2 : `gpg`
- `nvm`
- autojump : `j`
- `npm`
- `yarn`
- `tree`
- `htop`
- `tig`
- `bat`
- Oracle Jdk : `java`
- `jq`
- `fzf`
- `nvim`
- `node`
- `kaf`
- `pomerium-cli`

## Utility Funtcions
- `pull_rebase_directory` : To pull latest changes for all repos in the current directory
- `kafka_helper_count_messages` : To count messages in a kafka topic, this needs Kafka CLI tools to be installed in path

//TODO:  Looking forward to pick things from Kent's dotfiles https://github.com/kentcdodds/dotfiles/blob/master/.macos

# Tips 
## Find Java versions
- Run `/usr/libexec/java_home -V` to list versions
- Run `/usr/libexec/java_home -v XX` to retrive the java path, specify version in place of `XX` for example `11` for Java 11

## Setup JAVA version
- Run `export JAVA_HOME=$(/usr/libexec/java_home -v XX.XX)` with `XX` being the version you want to se, like `export JAVA_HOME=$(/usr/libexec/java_home -v 11)`  for Java 11

## Setup JQ Color scheme
- Run `export JQ_COLORS="2;30:0;31:1;31:0;34:0;32:1;37:1;37"`
- Add above to .zshrc


