define_helpers() {
  Orange="\e[38;5;202m"
  ps1_hostname="${Orange}[\h]"
  Prompt="${Blue}[\u]${ps1_hostname}${BoldWhite}[\w]"
}

override_git_prompt_colors() {
  GreyBG="\e[48;5;236m"

  GIT_PROMPT_THEME_NAME="Custom_1"

  GIT_PROMPT_BRANCH="${Green} "
  GIT_PROMPT_PREFIX="│"
  GIT_PROMPT_SUFFIX="│"
  GIT_PROMPT_SEPARATOR=" "
  GIT_PROMPT_STAGED=" ${Yellow}● "
  GIT_PROMPT_CONFLICTS=" ${Red}✖ "
  GIT_PROMPT_CHANGED=" ${Blue}✚ "
  GIT_PROMPT_UNTRACKED=" ${Cyan}… "
  GIT_PROMPT_STASHED=" ${BoldMagenta}⚑ "
  GIT_PROMPT_CLEAN=" ${Green}✔ "
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="✭"

  GIT_PROMPT_COMMAND_OK=""
  GIT_PROMPT_COMMAND_FAIL="${Red}(✘)${ResetColor}"

  GIT_PROMPT_START_USER="${Prompt}${ResetColor}"
  GIT_PROMPT_END_USER="_LAST_COMMAND_INDICATOR_${Green}\$${ResetColor} "
  GIT_PROMPT_END_ROOT="${BoldRed} # ${ResetColor}"
}

reload_git_prompt_colors "Custom_1"
