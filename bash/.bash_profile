export DOMAIN=$(echo "$HOSTNAME" | cut -d '.' -f2-)


if [[ -x /usr/bin/sw_vers ]]; then
  export MACOS="true"
else
  export MACOS="false"
fi


PATH="/usr/local/sbin:/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH


if [[ "$MACOS" == "false" ]]; then
  eval "$("$HOME"/.local/bin/keychain --eval --inherit any-once id_rsa)"
fi


if [[ "$DOMAIN" == "iq.harvard.edu" ]]; then
  eval "$("$HOME"/.local/bin/keychain --eval --inherit any-once id_ed25519)"
fi


if [[ "$DOMAIN" == "hmdc.harvard.edu" ]]; then
  umask 002
  export PATH="/nfs/tools/lib/anaconda/3/bin:$PATH:$HOME/.rvm/bin"
fi


[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
