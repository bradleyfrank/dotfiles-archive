#!/bin/bash
# ...declare as a Bash script for syntax coloring

# Skip sourcing if not running interactively
[[ $- != *i* ]] && return

# Load Solarized Light LS_COLORS
[[ -f "$HOME"/.dir_colors ]] && eval "$(dircolors "$HOME"/.dir_colors)"

# Declare array of ssh keys to load
declare -a ssh_keys=(id_rsa id_ed25519)

# Load user bashrc configs
. "$HOME"/.bashrc.d/[0-9][0-9]*.bashrc

# Load system-specific bashrc configs
case "$OSTYPE" in
  darwin*) . "$HOME"/.bashrc.d/macos.bashrc ;;
  linux* ) . "$HOME"/.bashrc.d/linux.bashrc ;;
esac

# Aliases
alias condense='grep -Erv "(^#|^$)"'
alias e='extract'
alias ekans='. /usr/local/anaconda3/bin/activate'
alias fuck='sudo $(fc -ln -1)'
alias glances='glances --theme-white'
alias groot='cd $(git rev-parse --show-toplevel)'
alias ll='ls -lA --color --classify --human-readable'
alias lt='ls -1AS --color --classify --human-readable --group-directories-first --size'
alias lsmnt='mount | column -t'
alias pipi='python3 -m pip install --user'
alias please='sudo'
alias pping='prettyping'
alias pubip='dig myip.opendns.com @resolver1.opendns.com'
alias sane='stty sane'
alias wget='wget -c'

# Load SSH keys into ssh-agent
eval "$($_keychain)"

# Set default editors
export VISUAL=vim
export EDITOR=vim

# Navigation settings (i.e. `cd` and tab-completion)
shopt -s cdspell
shopt -s dotglob
shopt -s no_empty_cmd_completion
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"
bind "set visible-stats on"

# Generic history settings
shopt -s histappend
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL="erasedups:ignoreboth:ignorespace"
export HISTIGNORE="&:[ ]*:exit:ls:ll:bg:fg:history:clear"
export HISTTIMEFORMAT='%F %T '

# __git_prompt settings
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUPSTREAM="auto verbose"

# Black formatter for Python
blackdiff() {
  black --line-length 79 --diff "$@" | diff-so-fancy
}

# Update Anaconda
coil() {
  . /usr/local/anaconda3/bin/activate
  conda update -n base conda -y
  conda update --prefix /usr/local/anaconda3 anaconda -y
  conda clean --all -y
  conda deactivate
}

# Quick and dirty docker-compose linter
clint() { docker-compose -f "$1" config --quiet ; }

# Decrypt a file using openssl
decrypt() { openssl enc -d -aes-256-cbc -in "$1" -out "$1.decrypted" ; }

# Encrypt a file using openssl
encrypt() { openssl enc -aes-256-cbc -salt -in "$1" -out "$1.encrypted" ; }

# Show website http headers; follow redirects
httptrace() { curl -s -L -D - "$1" -o /dev/null -w "%{url_effective}\n" ; }

# Make and change into a new directory
mkcd() { mkdir -p "$1" ; cd "$1" ; }

# Update user Python packages
pup() { pip_upgrade_outdated -3 --user --verbose ; }

# Update HomeBrew packages and casks
steep() {
  brew update
  brew upgrade
  brew cask upgrade
  brew cleanup
}

# tar and gzip a given directory
tardir() { tar -czf "${1%/}".tar.gz "$1" ; }

# View cheat sheet for commands
cheat() { curl -s "cheat.sh/$1?style=vs" ; }