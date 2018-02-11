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
# Puppet
alias pupupdate='puppet_module_update && update_homebox'
alias refresh='puppet_apply && powerline-daemon --replace'
# Python
alias py2update='python_update pip2'
alias py3update='python_update pip3'
alias pyupdate='py2update && py3update'
# System
alias macupdate='sudo softwareupdate -ia'
alias steep='brew update && brew upgrade --cleanup && brew prune'
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
export EDITOR="/usr/local/bin/mate -w"

# =============================================================================
# Evals
# -----------------------------------------------------------------------------

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

function get_puppet_config () {
  puppet config print ${1} | awk -F ':' '{print $1}'
}

function puppet_module_update () {
  modpath=$(get_puppet_config modulepath)
  modules=()
  while IFS='' read -r line || [[ -n "$line" ]]; do
    modules+=( "$line" )
  done < <( puppet module list --modulepath="$modpath" | grep - | awk '{print $2}' )
  for m in "${modules[@]}"; do
    puppet module upgrade "$m"
  done
}

function python_update () {
  $1 freeze --user | grep -v '^\-e' | cut -d = -f 1  | xargs $1 install -U --user
}

function sitepp () {
  codedir=$(get_puppet_config codedir)
  echo "${codedir}/manifests/site.pp"
}

function update_homebox () {
  modpath=$(get_puppet_config modulepath)
  codedir=$(get_puppet_config codedir)
  git -C "$modpath/homebox" pull
  git -C "$codedir" pull
}

# =============================================================================
# Sources
# -----------------------------------------------------------------------------

# =============================================================================
# Powerline
# -----------------------------------------------------------------------------
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
export POWERLINE_COMMAND=powerline
export POWERLINE_CONFIG_COMMAND=powerline-config
. /usr/local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh

if [[ -n "$TMUX" ]]; then powerline-config tmux setup; fi
