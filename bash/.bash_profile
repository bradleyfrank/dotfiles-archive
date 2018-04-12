domain=$(echo "$HOSTNAME" | cut -d '.' -f2-)
hostname=$(echo "$HOSTNAME" | cut -d '.' -f1)


PATH="/usr/local/sbin:/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
if [[ -d "$HOME/Library/Python/3.6/bin" ]]; then
  PATH="$HOME/Library/Python/3.6/bin:$PATH"
fi
export PATH


[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
