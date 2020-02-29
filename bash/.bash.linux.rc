#!/bin/bash

# Load Bash completions
. /etc/profile.d/bash_completion.sh

# Source git-prompt if necessary
_git_prompt="/usr/share/git-core/contrib/completion/git-prompt.sh"
[[ -e "$_git_prompt" ]] && . "$_git_prompt"

# Construct keychain eval statement for loading SSH keys into ssh-agent
_keychain="keychain --eval --ignore-missing --quiet ${ssh_keys[*]}"

# Aliases
alias ipa='ip -c a'
alias lsblk='lsblk -o "NAME,FSTYPE,SIZE,UUID,MOUNTPOINT"'
alias proc='ps -e --forest -o pid,ppid,user,time,cmd'

# Detach gedit from the terminal session and supress output
gedit() {
  nohup /usr/bin/gedit "$@" >/dev/null 2>&1 &
}

# Find a process by name or pid and show only its group/children
fproc() {
  local pid
  if [[ "$1" =~ ^[0-9]+$ ]]; then pid="$(ps -o sid= -p "$1")"
  else pid="$(pgrep "$1")"
  fi
  ps --forest -o pid,ppid,user,time,cmd -g "$pid"
}

# Download YouTube video as music only
youtube-dl-music() {
  youtube-dl --format bestaudio --extract-audio --audio-format mp3 "$1"
}