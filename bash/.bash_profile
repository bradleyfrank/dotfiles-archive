export _DOMAIN=$(echo "$HOSTNAME" | cut -d '.' -f2-)
export _HOSTNAME=$(echo "$HOSTNAME" | cut -d '.' -f1)


if [[ -x /usr/bin/sw_vers ]]; then
  export _MACOS="true"
else
  export _MACOS="false"
fi


PATH="/usr/local/sbin:/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH


if [[ "$_MACOS" == "false" ]]; then
  eval "$("$HOME"/.local/bin/keychain --eval --inherit any-once id_rsa)"
fi


if [[ "$_DOMAIN" == "iq.harvard.edu" ]]; then
  eval "$("$HOME"/.local/bin/keychain --eval --inherit any-once id_ed25519)"
fi


if [[ "$_DOMAIN" == "hmdc.harvard.edu" ]]; then
  umask 002
  export PATH="/nfs/tools/lib/anaconda/3/bin:$PATH:$HOME/.rvm/bin"
fi


[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
