[[ -f /etc/bashrc ]] && . /etc/bashrc


if [[ "$DOMAIN" == "hmdc.harvard.edu" ]]; then
  umask 002
  alias mate='rmate'
fi


# =============================================================================
# Aliases
# -----------------------------------------------------------------------------
# Docker
alias dcu='docker-compose up -d'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}"'
alias dps='docker ps'
# Git
alias firstpush='git push --set-upstream origin $(githead)'
alias githead='git rev-parse --abbrev-ref HEAD'
# Networking
alias digg='dig +noall +answer'
alias pingg='ping -c 4'
alias pubip='dig +short myip.opendns.com @resolver1.opendns.com'
# Python
alias py2update='python_update pip2'
alias py3update='python_update pip3'
alias pyupdate='py2update && py3update'
# System
alias lutil='sudo ldap_account_util.pl -P /root/pass '
alias macupdate='sudo softwareupdate -ia'
alias rvmupdate='rvm get stable && rvm gemset update'
alias steep='brew update && brew upgrade --cleanup && brew prune'
alias tag='dmidecode -s system-serial-number'
alias update='steep && pyupdate && powerline-restart && macupdate'
# Terminal
alias bb='bbedit'
alias ll='ls -lh'
alias powerline-restart='powerline-daemon --replace'
alias sane='stty sane'
alias t='tree'
# Tmux
alias tat='tmux attach -t'
alias tka='tmux kill-server'
alias tks='tmux kill-session'
alias tls='tmux list-sessions'


# =============================================================================
# Exports
# -----------------------------------------------------------------------------
[[ "$MACOS" == "true" ]] && export EDITOR="/usr/local/bin/mate -w"


# =============================================================================
# Functions
# -----------------------------------------------------------------------------
function decrypt () {
  filename=(${1//./ })
  openssl enc -d -aes-256-cbc -in $1 -out $filename.txt
}

function encrypt () {
  filename=(${1//./ })
  openssl enc -aes-256-cbc -salt -in $1 -out $filename.enc
}

function exit () {
  if [[ -n "$TMUX" ]]; then
    tmux detach
  else
    command exit
  fi
}

function pws () {
  local admin_share="$HOME/shared_space/ci3_admin"

  if [ "$1" == "list" ] || [ "$1" == "l" ]
  then
    7za l $admin_share/hmdc_${2}_lp.7z
  elif [ "$1" == "read" ] || [ "$1" == "r" ]
  then
    7za x -so $admin_share/hmdc_${2}_lp.7z ${3} 2>/dev/null
  elif [ "$1" == "write" ] || [ "$1" == "w" ]
  then
    7za a -p -mhe=on $admin_share/hmdc_${2}_lp.7z $3
  else
    echo "Usage: pws [list|read|write] [internal|external|physical] [filename]"
  fi
}

function condor_jobs () {
  condor_status -constraint 'JobId =!= undefined' -autoformat Machine RemoteOwner JobId | sort
}

function python_update () {
  $1 freeze --user | grep -v '^\-e' | cut -d = -f 1  | xargs $1 install -U --user
}


# =============================================================================
# Sources
# -----------------------------------------------------------------------------
[[ -x "$HOME"/.rvm/scripts/rvm ]] && . "$HOME"/.rvm/scripts/rvm


# =============================================================================
# Powerline
# -----------------------------------------------------------------------------
powerline-daemon -q
POWERLINE_BASH_SCRIPT="powerline/bindings/bash/powerline.sh"
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
export POWERLINE_COMMAND=powerline
export POWERLINE_CONFIG_COMMAND=powerline-config

if [[ "$MACOS" == "true" ]]; then
  PYLIB="/usr/local/lib/python3.6"
else
  PYLIB="$HOME/.local/lib/python3.6"
fi

. "$PYLIB"/site-packages/"$POWERLINE_BASH_SCRIPT"


if [[ -n "$TMUX" ]]; then powerline-config tmux setup; fi
