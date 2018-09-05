override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom_1"

  GIT_PROMPT_BRANCH="${White}on${ResetColor} ${Green}"
  GIT_PROMPT_PREFIX=""
  GIT_PROMPT_SUFFIX=""
  GIT_PROMPT_SEPARATOR=" "
  GIT_PROMPT_STAGED="${Blue}⋮"
  GIT_PROMPT_CONFLICTS="${Red}✗"
  GIT_PROMPT_CHANGED="${Yellow}+"
  GIT_PROMPT_UNTRACKED="${White}…"
  GIT_PROMPT_STASHED="${Magenta}⚑"
  GIT_PROMPT_CLEAN="${Green}✓"
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="✭"

  GIT_PROMPT_COMMAND_OK="${White}⋊>${ResetColor} "
  GIT_PROMPT_COMMAND_FAIL="${Red}⋊>${ResetColor} "

  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_${Yellow}${PathShort}${ResetColor}"
	GIT_PROMPT_END_USER="${ResetColor} "
	GIT_PROMPT_END_ROOT="${ResetColor} "
}

reload_git_prompt_colors "Custom_1"
