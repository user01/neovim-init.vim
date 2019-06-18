
alias "l"="ls -alh"
alias "lg"="l | grep "
alias "hg"="history | grep "
# export PS1="\[\e[34;1m\][\$(date +%k:%M)\w]\$ \[\e[0m\]"
export SVN_EDITOR=vim
export VISUAL=vim
export EDITOR="$VISUAL"

function exitstatus {
	EXITSTATUS="$?"
	BOLD="\[\033[1m\]"
	RED="\[\033[1;31m\]"
	GREEN="\[\e[32;1m\]"
	BLUE="\[\e[34;1m\]"
	OFF="\[\033[m\]"
	PROMPT="${BOLD}\u@\h ${OFF}\$(date +%k:%M) ${BLUE}\W${OFF}"
	if [ "${EXITSTATUS}" -eq 0 ]
	then
		PS1="${GREEN}[${PROMPT}${GREEN}]${OFF} "
	else
		PS1="${BOLD}${RED}[${PROMPT}${BOLD}${RED}]${OFF} "
	fi
	PS2="${BOLD}>${OFF}"
}

PROMPT_COMMAND=exitstatus

# Set config variables first
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

