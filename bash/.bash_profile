#!/bin/bash

# Set Homebrew location
[[ -x /usr/local/bin/brew ]] && _brew="/usr/local"
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && _brew="/home/linuxbrew/.linuxbrew"


# Common PATH locations for MacOS & Linux
PATH="$HOME/.local/bin:$HOME/bin"
PATH="$PATH:/usr/local/bin:/usr/local/sbin"
PATH="$PATH:/usr/bin:/usr/sbin:/bin:/sbin"

if [[ "$OSTYPE" =~ darwin ]]; then
  # Python 3 binaries
  if _pypath="$(python3 -m site \
    | grep -Eo "^USER_BASE:\s'.+'\s\(exists\)$" \
    | awk '{print $2}' \
    | tr -d "'")"
  then
    PATH="$PATH:$_pypath/bin"
  fi

  # X11 provided by XQuartz
  PATH="$PATH:/opt/X11/bin"

  # Homebrew MacOS GNU Core Utilities
  if [[ -n "$_brew" ]]; then
    PATH="$_brew/opt/coreutils/libexec/gnubin:$PATH"
    PATH="$_brew/opt/gnu-tar/libexec/gnubin:$PATH"
    PATH="$_brew/opt/ed/libexec/gnubin:$PATH"
    PATH="$_brew/opt/grep/libexec/gnubin:$PATH"
    PATH="$_brew/opt/gnu-sed/libexec/gnubin:$PATH"
    PATH="$_brew/opt/gawk/libexec/gnubin:$PATH"
    PATH="$_brew/opt/findutils/libexec/gnubin:$PATH"
  fi
elif [[ "$OSTYPE" =~ linux ]]; then
  # Homebrew formulas
  [[ -n "$_brew" ]] && PATH="$_brew/bin:$PATH"
fi

export PATH


# Common MANPATH locations for MacOS & Linux
MANPATH="$HOME/.local/share/man"
MANPATH="/usr/local/share/man:/usr/share/man:$MANPATH"

if [[ "$OSTYPE" =~ darwin && -n "$_brew" ]]; then
  # Homebrew MacOS GNU Core Utilities
  MANPATH="$_brew/opt/coreutils/libexec/gnuman:$MANPATH"
  MANPATH="$_brew/opt/gnu-tar/libexec/gnuman:$MANPATH"
  MANPATH="$_brew/opt/ed/libexec/gnuman:$MANPATH"
  MANPATH="$_brew/opt/grep/libexec/gnuman:$MANPATH"
  MANPATH="$_brew/opt/gnu-sed/libexec/gnuman:$MANPATH"
  MANPATH="$_brew/opt/gawk/libexec/gnuman:$MANPATH"
  MANPATH="$_brew/opt/findutils/libexec/gnuman:$MANPATH"
fi

export MANPATH


# Load additional Homebrew environment variables
if [[ -n "$_brew" ]]; then
  export HOMEBREW_PREFIX="$_brew"
  export HOMEBREW_CELLAR="$_brew/Cellar"
  export HOMEBREW_REPOSITORY="$_brew/Homebrew"
  export INFOPATH="$_brew/share/info:${INFOPATH:-}"
fi


# Start tmux on remote connections
if type tmux &> /dev/null && [[ -n "$SSH_CONNECTION" ]]; then
  if ! tmux has -t main &> /dev/null
  then tmux new -s main
  else tmux attach -t main
  fi
fi


# Source local bashrc
. "$HOME"/.bashrc
