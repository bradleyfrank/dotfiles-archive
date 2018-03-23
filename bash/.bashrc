[[ -f /etc/bashrc ]] && . /etc/bashrc


# =============================================================================
# Aliases
# -----------------------------------------------------------------------------

# For non-local systems
if [[ "$_DOMAIN" != "local" ]]; then
  alias mate='rmate'
fi


# Dev/Puppet machine at HMDC
if [[ "$_HOSTNAME" == "fedoraplex" ]]; then
  alias cap='bundle exec cap'
  alias yumdatedev='bundle exec cap development puppet:yumdate'
  alias yumdatedev7='bundle exec cap development-centos7 puppet:yumdate'
  alias yumdateqa='bundle exec cap qa deploy puppet:yumdate'
  alias yumdateprod='bundle exec cap production ROLES=`prodhosts` deploy puppet:yumdate'
  alias yumdateprod7='bundle exec cap production-centos7 deploy puppet:yumdate'
  alias yumdateprodrce='bundle exec cap production ROLES=cluster deploy puppet:yumdate'
  alias patchdvn='ssh opsview.hmdc.harvard.edu "gsh vdc \"sudo yum update -y\""'
  alias patchops='ssh opsview.hmdc.harvard.edu "gsh opsview \"sudo yum update -y\""'
fi

# Docker
alias dcu='docker-compose up -d'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}"'
alias dps='docker ps'
# Git
alias firstpush='git push --set-upstream origin $(githead)'
alias githead='git rev-parse --abbrev-ref HEAD'
alias lastcommit='git rev-parse --verify HEAD'
# HandBrake
alias transcode-h265='transcode-video --handbrake-option encoder=x265'
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
alias powerline-restart='powerline-daemon --replace'
alias rvmupdate='rvm get stable && rvm gemset update && rvm cleanup all'
alias steep='brew update && brew upgrade --cleanup && brew prune'
alias tag='dmidecode -s system-serial-number'
alias update='steep && pyupdate && powerline-restart && macupdate'
# Terminal
alias bb='bbedit'
alias du="ncdu"
alias df="pydf"
alias ll='ls -lhF'
alias mkdir='mkdir -pv'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias sane='stty sane'
alias t='tree'
alias wget='wget -c'
# Tmux
alias tat='tmux attach -t'
alias tka='tmux kill-server'
alias tks='tmux kill-session'
alias tls='tmux list-sessions'


# =============================================================================
# Evals
# -----------------------------------------------------------------------------
if type thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
fi


# =============================================================================
# Exports
# -----------------------------------------------------------------------------
if [[ "$_MACOS" == "true" ]]; then
  export EDITOR="/usr/local/bin/mate -w"
  export CLICOLOR=1
fi


# =============================================================================
# Functions
# -----------------------------------------------------------------------------
function condor_jobs () {
  condor_status -constraint 'JobId =!= undefined' -autoformat Machine RemoteOwner JobId | sort
}

function decrypt () {
  filename=(${1//./ })
  openssl enc -d -aes-256-cbc -in $1 -out $filename.txt
}

function encrypt () {
  filename=(${1//./ })
  openssl enc -aes-256-cbc -salt -in $1 -out $filename.enc
}

function prodhosts () {
  egrep '^server' ~/Development/hmdc/hmdc-admin/config/deploy/production.rb | awk -F: '{print $2}' | tr -d ',' | sort | uniq | awk '{$1=$1};1' | tr '\n' ',' | sed 's/.$//' | sed 's/cluster,//'
}

function pws () {
  local admin_share="$HOME/shared_space/ci3_admin"

  if [ "$1" == "list" ] || [ "$1" == "l" ]
  then
    7za l "$admin_share"/hmdc_"$2"_lp.7z
  elif [ "$1" == "read" ] || [ "$1" == "r" ]
  then
    7za x -so "$admin_share"/hmdc_"$2"_lp.7z "$3" 2>/dev/null
  elif [ "$1" == "write" ] || [ "$1" == "w" ]
  then
    7za a -p -mhe=on "$admin_share"/hmdc_"$2"_lp.7z "$3"
  else
    echo "Usage: pws [list|read|write] [internal|external|physical] [filename]"
  fi
}

function python_update () {
  "$1" freeze --user | grep -v '^\-e' | cut -d = -f 1  | xargs "$1" install -U --user
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

if [[ "$_MACOS" == "true" ]]; then
  PYLIB="/usr/local/lib/python3.6"
else
  PYLIB="$HOME/.local/lib/python3.6"
fi

. "$PYLIB"/site-packages/"$POWERLINE_BASH_SCRIPT"


if [[ -n "$TMUX" ]]; then powerline-config tmux setup; fi
