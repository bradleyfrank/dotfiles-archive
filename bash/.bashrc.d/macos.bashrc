#!/bin/bash

# Load Bash completions
# Workaround a bug in bash-completion@2 2.10
# https://github.com/scop/bash-completion/issues/374
# https://github.com/Homebrew/homebrew-core/pull/47527
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d" 
. /usr/local/etc/profile.d/bash_completion.sh

# Construct keychain eval statement for loading SSH keys into ssh-agent
_keychain="keychain --eval --ignore-missing --quiet --inherit any ${ssh_keys[*]}"

# Enable colorized ls output
export CLICOLOR=1

# Aliases
alias tbrename='printf "\e]1;%s\a"'
alias ttrename='printf "\e]2;%s\a"'
alias typora='open -a typora'

# Download YouTube video as music only
youtube-dl-music() {
  youtube-dl --format bestaudio --extract-audio --audio-format mp3 \
      --postprocessor-args "-strict experimental" "$1"
}