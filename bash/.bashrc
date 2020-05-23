#!/bin/bash

# Skip sourcing if not running interactively
[[ $- != *i* ]] && return

# Load Solarized Light LS_COLORS
[[ -f "$HOME"/.dir_colors ]] && eval "$(dircolors "$HOME"/.dir_colors)"

# SSH keys to load
readarray -t ssh_keys < <( find "$HOME"/.ssh/ -name 'id_*' -not -name '*.pub' )

# Source system-specific bashrc configs
# Note: `keychain` command is built here
. "$HOME"/.bashrc.d/"$(grep -Eo "(darwin|linux)" <<< "$OSTYPE")".rc

# Source machine-specific bashrc configs
hostrc="$(uname -n | cut -d '.' -f 1)".rc
[[ -f "$HOME"/.bashrc.d/"$hostrc" ]] && . "$HOME"/.bashrc.d/"$hostrc"

# Load SSH keys into ssh-agent
eval "$($_keychain)"

# Source aliases
. "$HOME"/.bashrc.d/aliases.rc

# Source environment variables and bindings
. "$HOME"/.bashrc.d/env.rc

# Source functions
. "$HOME"/.bashrc.d/functions.rc

# Source ps1 prompt
. "$HOME"/.bashrc.d/ps1.rc