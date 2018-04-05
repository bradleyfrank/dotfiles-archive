export _DOMAIN=$(echo "$HOSTNAME" | cut -d '.' -f2-)
export _HOSTNAME=$(echo "$HOSTNAME" | cut -d '.' -f1)


if [[ -x /usr/bin/sw_vers ]]; then
  export _MACOS=0
else
  export _MACOS=1
fi



PATH="/usr/local/sbin:/usr/local/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
if [[ "$_MACOS" -eq 0 ]]; then
  PATH="$HOME/Library/Python/3.6/bin:$PATH"
fi
export PATH


# Linux specific configs
if [[ "$_MACOS" -eq 1 ]]; then
  eval "$(keychain --eval --ignore-missing id_rsa id_ed25519)"
fi


# RCE specific configs
if [[ "$_DOMAIN" == "hmdc.harvard.edu" ]]; then
  umask 002
  export PATH="$PATH:$HOME/.rvm/bin"
fi


# HMDC dev system specific configs
if [[ "$_HOSTNAME" == "fedoraplex" ]]; then
  export HMDC_ADMIN_PATH="$HOME/Development/hmdc-admin"
  export HMDC_KEYS_PATH="$HOME/.hmdc_dev_keys"
  export CAP_SSH_GATEWAY="rce.hmdc.harvard.edu"
  eval "$(keychain --eval "$HMDC_KEYS_PATH"/{root,app}-id_rsa)"
fi


[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
