domain=$(echo "$HOSTNAME" | cut -d '.' -f2-)
hostname=$(echo "$HOSTNAME" | cut -d '.' -f1)


PATH="/usr/local/sbin:/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
if [[ -d "$HOME/Library/Python/3.6/bin" ]]; then
  PATH="$HOME/Library/Python/3.6/bin:$PATH"
fi
export PATH


# Linux specific configs
if ! type sw_vers >/dev/null 2>&1; then
  eval "$(keychain --eval --ignore-missing id_rsa id_ed25519)"
fi


[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
