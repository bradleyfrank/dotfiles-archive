domain=$(echo "$HOSTNAME" | cut -d '.' -f2-)
hostname=$(echo "$HOSTNAME" | cut -d '.' -f1)


PATH="/usr/local/sbin:/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
if [[ -d "$HOME/Library/Python/3.6/bin" ]]; then
  PATH="$HOME/Library/Python/3.6/bin:$PATH"
fi
export PATH


# Keep dotfiles updates
update_script="$HOME/.local/bin/update"
if [[ -x "$update_script" ]]; then
  if ! "$update_script" -i d >/dev/null 2>&1; then
    echo "Unable to update dotfiles!"
  fi
fi


[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
