#!/bin/bash
# ...declare as a Bash script for syntax coloring

# Skip sourcing if not running interactively
[[ $- != *i* ]] && return

# Aliases
alias bb='bbedit'
alias condense='grep -Erv "(^#|^$)"'
alias gdf='pydf'
alias gdu='ncdu'
alias e='extract'
alias ekans='. /usr/local/anaconda3/bin/activate'
alias glances='glances --theme-white'
alias groot='cd $(git rev-parse --show-toplevel)'
alias help='tldr'
alias ipca='ip -c a'
alias ll='ls -lAhF --color=auto'
alias lsdev='lsblk -o "NAME,FSTYPE,SIZE,UUID,MOUNTPOINT"'
alias lsmnt='mount | column -t'
alias orch='javaws ~/.local/java/orchestrator.jnlp'
alias pping='prettyping'
alias proc='ps -e --forest -o pid,ppid,user,cmd'
alias pubip='dig myip.opendns.com @resolver1.opendns.com'
alias safari='open -a Safari'
alias sane='stty sane'
alias tbrename='printf "\e]1;%s\a"'
alias ttrename='printf "\e]2;%s\a"'
alias typora='open -a typora'
alias weather='curl wttr.in'
alias wget='wget -c'

# Load SSH keys into ssh-agent
eval "$(keychain --eval --ignore-missing --quiet --inherit any id_esai id_home id_develop id_rsa id_ed25519)"

# Set default editors
export VISUAL=vim
export EDITOR=vim

# Tab-completion and `cd` settings
shopt -s cdspell
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
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT='%F %T '

# Settings for hstr
bind "'\C-r': '\C-a hh -- \C-j'"
export HH_CONFIG=hicolor

# Update Anaconda
coil() {
  . /usr/local/anaconda3/bin/activate
  conda update -n base conda -y
  conda update --prefix /usr/local/anaconda3 anaconda -y 
  conda clean --all -y
  conda deactivate
}

# Quick and dirty docker-compose linter
clint() {
  docker-compose -f "$1" config --quiet
}

# Decrypt a file using openssl
decrypt() {
  openssl enc -d -aes-256-cbc -in "$1" -out "$1.decrypted"
}

# Encrypt a file using openssl
encrypt() {
  openssl enc -aes-256-cbc -salt -in "$1" -out "$1.encrypted"
}

# Detach gedit from the terminal session and supress output
gedit() {
  nohup /usr/bin/gedit "$@" >/dev/null 2>&1
}

# Show website http headers; follow redirects
httptrace() {
  curl -s -L -D - "$1" -o /dev/null -w "%{url_effective}\n"
}

# Update dotfiles repo and restows all packages
mydots() {
  pushd "$HOME"/.dotfiles >/dev/null 2>&1 || return 1
  git stash
  git pull
  generate-dotfiles
  git submodule update --init --recursive
  for dir in */; do stow --restow "${dir%/}"; done
  popd >/dev/null 2>&1 || return 1
}

# Update user Python packages
pup() {
  pip_upgrade_outdated -3 --user --verbose
}

# Update HomeBrew packages and casks
steep() {
  brew update
  brew upgrade
  brew cask upgrade
  brew cleanup
}

# tar and gzip a given directory
tardir() {
  tar -czf "${1%/}".tar.gz "$1"
}

# Download YouTube video as music only
youtube-dl-music() {
  case "$(uname -s)" in
    Darwin) youtube-dl -x --audio-format m4a --postprocessor-args "-strict experimental" "$1" ;;
    Linux ) youtube-dl -x --audio-format m4a "$1" ;;
  esac
}

# Customize ps1
. "${HOME}"/.config/bashrc/ps1
export PROMPT_COMMAND="build_ps1; history -a; history -n"