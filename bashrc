# Bash completion for macOs & brew
[[ -f /usr/local/etc/bash_completion ]] && \
	. /usr/local/etc/bash_completion

# Same for Ubuntu.
[[ -f /usr/share/bash-completion/bash_completionXX ]] && \
	. /usr/share/bash-completion/bash_completion

# No dupes, nor lines starting with space in history.
HISTCONTROL=ignoreboth:erasedups
# Set history length
HISTSIZE=3000
HISTFILESIZE=9000
# Append, don't overwrite
shopt -s histappend

# Adjust lines & columns when needed
shopt -s checkwinsize

# vim ftw
export VISUAL=/usr/bin/vim
export EDITOR=/usr/bin/vim

export GIT_SSH="/usr/bin/ssh"

function prompt {
	local NO_COLOR="\[\033[0m\]"
	local LIGHT_CYAN="\[\033[1;36m\]"
	local LIGHT_BLUE="\[\033[1;34m\]"

	# Set term title to $pwd
	local TITLE="\[\033];\w\007\]"

	PS_PREFIX="$TITLE$LIGHT_CYAN[\$(date +%H:%M)]$LIGHT_BLUE"
	PS_SUFFIX="$LIGHT_CYAN\w$NO_COLOR \n\$ "

	# Currently __git_ps1 comes from bash-completions. This might change.
	# [[ -f /usr/lib/git-core/git-sh-prompt ]] && . /usr/lib/git-core/git-sh-prompt

	if [[ $(type __git_ps1 2>/dev/null) ]];
	then
		export GIT_PS1_SHOWDIRTYSTATE=1
		export GIT_PS1_SHOWSTASHSTATE=1
		export GIT_PS1_SHOWCOLORHINTS=1
		export GIT_PS1_HIDE_IF_PWD_IGNORED=1
		PROMPT_COMMAND="__git_ps1 \"$PS_PREFIX\" \" $PS_SUFFIX\""
	else
		PS1="$PS_PREFIX $PS_SUFFIX"
	fi
}

prompt

export LSCOLORS=gxfxcxdxbxegedbxbxgxgx
alias ls='ls -GF'
alias grep='grep --color=auto'
