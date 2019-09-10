set -Ux EDITOR vim
set -Ux VISUAL vim

# ssh-agent setup
set keys "id_esai id_home id_develop id_rsa id_ed25519"
if status --is-interactive
  source $HOME/.keychain/(hostname)-fish
  switch "(uname -s)"
    case Linux
      keychain --eval --ignore-missing -q -Q $keys >/dev/null
    case '*'
      keychain --eval --ignore-missing -q -Q --inherit any $keys >/dev/null
  end
end

# git prompt configuration
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch green

set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_char_stashstate '$'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'