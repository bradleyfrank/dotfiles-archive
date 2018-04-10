[[ -f /etc/bashrc ]] && . /etc/bashrc


# =============================================================================
# Aliases
# -----------------------------------------------------------------------------

# For non-local systems
if [[ "$_DOMAIN" != "local" ]]; then
  alias mate='rmate'
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
alias anaconda3='source /usr/local/anaconda3/bin/activate root'
alias py2update='python_update pip2'
alias py3update='python_update pip3'
alias pyupdate='py2update && py3update'
# System
alias powerline-restart='powerline-daemon --replace'
alias tag='dmidecode -s system-serial-number'
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

export PROMPT_DIRTRIM=3

if [[ "$_MACOS" -eq 0 ]]; then
  export EDITOR="/usr/local/bin/mate -w"
  export CLICOLOR=1
fi


# =============================================================================
# Functions
# -----------------------------------------------------------------------------

function .. ()
{
  local arg=${1:-1};
  local dir=""
  while [ $arg -gt 0 ]; do
    dir="../$dir"
    arg=$(($arg - 1));
  done
  cd $dir >&/dev/null
}

function decrypt () {
  filename=(${1//./ })
  openssl enc -d -aes-256-cbc -in $1 -out $filename.txt
}

function encrypt () {
  filename=(${1//./ })
  openssl enc -aes-256-cbc -salt -in $1 -out $filename.enc
}


# =============================================================================
# Sources
# -----------------------------------------------------------------------------

[[ -x "$HOME"/.rvm/scripts/rvm ]] && . "$HOME"/.rvm/scripts/rvm


# =============================================================================
# PS1
# -----------------------------------------------------------------------------

function ps1_powerline {
  powerline-daemon -q
  POWERLINE_BASH_SCRIPT="powerline/bindings/bash/powerline.sh"
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  export POWERLINE_COMMAND=powerline
  export POWERLINE_CONFIG_COMMAND=powerline-config

  if [[ "$_MACOS" -eq 0 ]]; then
    _PYLIB="$HOME/Library/Python/3.6/lib/python"
  else
    _PYLIB="$HOME/.local/lib/python3.6"
  fi

  . "$_PYLIB"/site-packages/"$POWERLINE_BASH_SCRIPT"

  if [[ -n "$TMUX" ]]; then powerline-config tmux setup; fi
}

function ps1_bash-git-prompt {
  if [[ "$_MACOS" -eq 0 ]]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
    . "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
  else
    . "$HOME"/.bash-git-prompt/gitprompt.sh
  fi
}

if [[ "$_DOMAIN" == "local" ]]; then
  ps1_powerline
else
  ps1_bash-git-prompt
fi
