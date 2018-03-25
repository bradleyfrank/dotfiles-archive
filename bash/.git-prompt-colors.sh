# This is an alternative approach. Single line in git repo.
# Theme optimised for Terminus and PowerLine compatible fonts.
# This theme for gitprompt.sh is optimized for the "Solarized Dark" and "Solarized Light" color schemes
# without the indicator of the last command state 
# tweaked for Ubuntu terminal fonts

define_helpers() {
  PathShort="${Blue}\u:${Cyan}\w"
}

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom_1"

  GIT_PROMPT_BRANCH=" "
  GIT_PROMPT_PREFIX="[ "
  GIT_PROMPT_SUFFIX=" ]"
  GIT_PROMPT_SEPARATOR=" |"
  GIT_PROMPT_STAGED=" ${Yellow}● ${ResetColor}"
  GIT_PROMPT_CONFLICTS=" ${Red}✖ ${ResetColor}"
  GIT_PROMPT_CHANGED=" ${Blue}✚ ${ResetColor}"
  GIT_PROMPT_UNTRACKED=" ${Cyan}… ${ResetColor}"
  GIT_PROMPT_STASHED=" ${BoldMagenta}⚑ ${ResetColor}"
  GIT_PROMPT_CLEAN=" ${Green}✔ ${ResetColor}"
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="✭"

  GIT_PROMPT_COMMAND_FAIL="${Red}✘"

  #GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${Yellow}${PathShort}${ResetColor}"
  GIT_PROMPT_START_USER="${PathShort}${ResetColor}"
  GIT_PROMPT_END_USER="${BoldBlue} $ ${ResetColor}"
  GIT_PROMPT_END_ROOT="${BoldRed} # ${ResetColor}"
}

reload_git_prompt_colors "Custom_1"
