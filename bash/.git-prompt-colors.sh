override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom_1"

  GIT_PROMPT_BRANCH="${Green}"
  GIT_PROMPT_PREFIX="["
  GIT_PROMPT_SUFFIX="]"
  GIT_PROMPT_SEPARATOR=" ${White}${ResetColor} "
  GIT_PROMPT_STAGED="${Yellow}● "
  GIT_PROMPT_CONFLICTS="${Red}✖ "
  GIT_PROMPT_CHANGED="${Yellow}✚ "
  GIT_PROMPT_UNTRACKED="${Cyan}… "
  GIT_PROMPT_STASHED="${BoldMagenta}⚑ "
  GIT_PROMPT_CLEAN="${Green}✔ "
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="✭"

  GIT_PROMPT_COMMAND_OK="${ResetColor}"
  GIT_PROMPT_COMMAND_FAIL="${Red}($?)${ResetColor}"

  GIT_PROMPT_START_USER="${ResetColor}[${Blue}\\u${White}@${BoldBlue}\\h ${Yellow}${PathShort}${ResetColor}]"
	GIT_PROMPT_END_USER="_LAST_COMMAND_INDICATOR_${Green}\$${ResetColor} "
	GIT_PROMPT_END_ROOT="_LAST_COMMAND_INDICATOR_${Green}#${ResetColor} "
}

reload_git_prompt_colors "Custom_1"
