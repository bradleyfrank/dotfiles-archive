#!/bin/bash
# ...declare as a Bash script for syntax coloring

# Skip sourcing if not running interactively
[[ $- != *i* ]] && return

[[ -f "$HOME"/.dir_colors ]] && eval "$(dircolors "$HOME"/.dir_colors)"

# Load Bash completions
case "$OSTYPE" in
  darwin*)
    # Workaround a bug in bash-completion@2 2.10
    # https://github.com/scop/bash-completion/issues/374
    # https://github.com/Homebrew/homebrew-core/pull/47527
    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d" 
    . /usr/local/etc/profile.d/bash_completion.sh
    ;;
  linux* ) . /etc/profile.d/bash_completion.sh ;;
esac

# Source git-prompt if necessary
_git_prompt="/usr/share/git-core/contrib/completion/git-prompt.sh"
[[ -e "$_git_prompt" ]] && . "$_git_prompt"

# Aliases
alias condense='grep -Erv "(^#|^$)"'
alias e='extract'
alias ekans='. /usr/local/anaconda3/bin/activate'
alias fuck='sudo $(fc -ln -1)'
alias glances='glances --theme-white'
alias groot='cd $(git rev-parse --show-toplevel)'
alias ipca='ip -c a'
alias ll='ls -lA --color --classify --human-readable'
alias lt='ls -1AS --color --classify --human-readable --group-directories-first --size'
alias lsdev='lsblk -o "NAME,FSTYPE,SIZE,UUID,MOUNTPOINT"'
alias lsmnt='mount | column -t'
alias pipi='python3 -m pip install --user'
alias please='sudo'
alias pping='prettyping'
alias proc='ps -e --forest -o pid,ppid,user,time,cmd'
alias pubip='dig myip.opendns.com @resolver1.opendns.com'
alias sane='stty sane'
alias tbrename='printf "\e]1;%s\a"'
alias ttrename='printf "\e]2;%s\a"'
alias typora='open -a typora'
alias wget='wget -c'

# Load SSH keys into ssh-agent
_keys="id_esai id_home id_develop id_rsa id_ed25519"
case "$OSTYPE" in
  darwin*) _keychain="keychain --eval --ignore-missing --quiet --inherit any $_keys" ;;
  linux* ) _keychain="keychain --eval --ignore-missing --quiet $_keys" ;;
esac
eval "$($_keychain)"

# Set default editors
export VISUAL=vim
export EDITOR=vim

# Navigation settings (i.e. `cd` and tab-completion)
shopt -s cdspell
shopt -s dotglob
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

# Settings for hstr
bind "'\C-r': '\C-a hh -- \C-j'"
export HH_CONFIG=hicolor

# Enable colorized ls output for Mac
[[ $OSTYPE =~ darwin* ]] && export CLICOLOR=1


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
clint() {
  docker-compose -f "$1" config --quiet
}

# Handles VSCodium across MacOS and Linux
code() {
  if type codium >/dev/null 2>&1; then
    command codium "$@"
  else
    command code "$@"
  fi
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
  nohup /usr/bin/gedit "$@" >/dev/null 2>&1 &
}

# Show website http headers; follow redirects
httptrace() {
  curl -s -L -D - "$1" -o /dev/null -w "%{url_effective}\n"
}

# Find a process by name or pid and show only its group/children
fproc() {
  local pid
  if [[ "$1" =~ ^[0-9]+$ ]]; then pid="$(ps -o sid= -p "$1")"
  else pid="$(pgrep "$1")"
  fi
  ps --forest -o pid,ppid,user,time,cmd -g "$pid"
}

# Make and change into a new directory
mkcd() {
  mkdir -p "$1"
  cd "$1"
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

# View cheat sheet for commands
tldr() {
  curl -s "cheat.sh/$1?style=vs"
}

# Download YouTube video as music only
youtube-dl-music() {
  case "$OSTYPE" in
    darwin*) youtube-dl --format bestaudio --extract-audio --audio-format mp3 \
      --postprocessor-args "-strict experimental" "$1" ;;
    linux* ) youtube-dl --format bestaudio --extract-audio --audio-format mp3 "$1" ;;
  esac
}

# Customize ps1
__my_prompt() {
  local _ret=$? _user="" _host="" _env="" _cwd="" _venv="" _suffix=""
  local reset="\[\e[0;0m\]" bold="\[\e[1m\]" \
    blue="\[\e[38;5;33m\]" \
    cyan="\[\e[38;5;37m\]" \
    green="\[\e[38;5;64m\]" \
    magenta="\[\e[38;5;125m\]" \
    red="\[\e[38;5;160m\]" \
    orange="\[\e[38;5;166m\]"

  # show username only if not me
  [[ ! "$USER" =~ ^bfrank ]] && _user="${magenta}\u${reset}"

  # show hostname only if remote session w/o tmux
  [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]] && _host="${orange}\h${reset}"

  # combine username and hostname
  [[ -n $_user || -n $_host ]] && _env="[${_user}${_host}] "
  [[ -n $_user && -n $_host ]] && _env="[${_user}@${_host}] "

  # show cwd always as prefixed path (e.g. ~/D/H/dotfiles)
  local _pwd="" _path="" _num_dirs=0
  readarray -t _path <<< "$(echo "$PWD" | sed "s|^${HOME}|~|" | sed "s|/|\n|g")"
  _num_dirs="${#_path[@]}"
  ((_num_dirs--))

  if [[ "$_num_dirs" -gt 0 ]]; then
    for ((i=0;i<"${_num_dirs}";i++)); do
      _pwd="${_pwd}${_path[$i]:0:1}/"
    done
  fi

  _cwd="${blue}${_pwd}${_path[$_num_dirs]}${reset}"

  # show anaconda _or_ virtualenv if activated
  [[ -n $VIRTUAL_ENV ]] && _venv=" (${cyan}$(basename "$VIRTUAL_ENV")${reset})"
  [[ -n $CONDA_DEFAULT_ENV ]] && _venv=" (${cyan}${CONDA_DEFAULT_ENV}${reset})"

  # colorize suffix based on return value
  if [[ ${_ret} -gt 0 ]]; then
    _suffix="${bold}${red} > ${reset}"
  else
    _suffix="${bold}${green} > ${reset}"
  fi

  # build PS1 with or without Git prompt
  if type __git_ps1 >/dev/null 2>&1; then
    __git_ps1 "${_env}${_cwd}" "${_venv}${_suffix}"
  else
    export PS1="${_env}${_cwd}${_venv}${_suffix}"
  fi

  # append to history (but don't read it into current list)
  history -a
}

PROMPT_COMMAND="__my_prompt"
