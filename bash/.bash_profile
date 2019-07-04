#!/bin/bash
# ...declare as a Bash script for syntax coloring

# Use the kernal name "Darwin" to identify MacOS
case "$(uname -s)" in
  Darwin) _os="macos" ;;
  Linux ) _os="linux" ;;
esac

# Determine if Homebrew is installed
if [[ -x /usr/local/bin/brew ]]; then
  _brew="/usr/local"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  _brew="/home/linuxbrew/.linuxbrew"
else
  _brew=1
fi

# Common PATH locations for MacOS & Linux
PATH="$HOME/.local/bin:$HOME/bin"
PATH="$PATH:/usr/local/bin:/usr/local/sbin"
PATH="$PATH:/usr/bin:/usr/sbin:/bin:/sbin"

if [[ "$_os" == "macos" ]]; then
  # Miscellenous (append to PATH)
  PATH="$PATH:$HOME/Library/Python/3.7/bin"
  PATH="$PATH:/opt/X11/bin"
  # Homebrew (prefix to PATH)
  if [[ "$_brew" -ne 1 ]]; then
    PATH="$_brew/opt/coreutils/libexec/gnubin:$PATH"
    PATH="$_brew/opt/gnu-tar/libexec/gnubin:$PATH"
    PATH="$_brew/opt/ed/libexec/gnubin:$PATH"
    PATH="$_brew/opt/grep/libexec/gnubin:$PATH"
    PATH="$_brew/opt/gnu-sed/libexec/gnubin:$PATH"
    PATH="$_brew/opt/gawk/libexec/gnubin:$PATH"
    PATH="$_brew/opt/findutils/libexec/gnubin:$PATH"
  fi
elif [[ "$_os" == "linux" ]]; then
  # Homebrew (prefix to PATH)
  if [[ "$_brew" -ne 1 ]]; then
    PATH="$_brew/bin:$PATH"
  fi
fi

export PATH

# Common MANPATH locations for MacOS & Linux
MANPATH="$HOME/.local/share/man:$MANPATH"
MANPATH="/usr/local/share/man:/usr/share/man:$MANPATH"

if [[ "$_os" == "macos" ]]; then
  # Homebrew (prefix to MANPATH)
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
if [[ "$_brew" -ne 1 ]]; then
  export HOMEBREW_PREFIX="$_brew"
  export HOMEBREW_CELLAR="$_brew/Cellar"
  export HOMEBREW_REPOSITORY="$_brew/Homebrew"
  export INFOPATH="$_brew/share/info:$INFOPATH"
fi

# Load Bash completions
case "$_os" in
  macos) . /usr/local/etc/profile.d/bash_completion.sh ;;
  linux) . /etc/profile.d/bash_completion.sh ;;
esac

# Load and enable solarized LS_COLORS
eval "$(dircolors "$HOME"/.dir_colors)"
export CLICOLOR=1

# Start tmux on remote connections
if type tmux >/dev/null 2>&1 && [[ -n "$SSH_CONNECTION" ]]; then
  if ! tmux has -t main >/dev/null 2>&1; then
    tmux new -s main
  else
    tmux attach -t main
  fi
fi

# Source local bashrc
. "$HOME"/.bashrc