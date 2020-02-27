#!/bin/bash

export PROMPT_DIRTRIM=5

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

  # use CWD basename if in tmux session, otherwise use full CWD
  [[ -n "$TMUX" ]] && _cwd="${blue}\W${reset}"
  [[ -z "$TMUX" ]] && _cwd="${blue}\w${reset}"

  # combine username, hostname, and cwd
  [[ -n $_user || -n $_host ]] && _env="[${_user}${_host}:${_cwd}]"
  [[ -n $_user && -n $_host ]] && _env="[${_user}@${_host}:${_cwd}]"
  [[ -z $_user && -z $_host ]] && _env="[${_cwd}]"

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
    __git_ps1 "${_env}" "${_venv}${_suffix}"
  else
    export PS1="${_env} ${_venv}${_suffix}"
  fi

  # append to history (but don't read it into current list)
  history -a
}

PROMPT_COMMAND="__my_prompt"