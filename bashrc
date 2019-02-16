# macOS
[[ -f /usr/local/etc/bash_completion ]] && \
    . /usr/local/etc/bash_completion

# Ubuntu
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

. /usr/local/etc/bash_completion.d/git-prompt.sh

if [ -f ~/.git-completion.bash ]; then
	source ~/.git-completion.bash
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
export GIT_SSH="/usr/bin/ssh"

function prompt {
	local NO_COLOR="\[\033[0m\]"
	local LIGHT_CYAN="\[\033[1;36m\]"
	local LIGHT_BLUE="\[\033[1;34m\]"
	local TITLE="\[\033];\w\007\]"

	PS1="$TITLE$LIGHT_CYAN[\$(date +%H:%M)]$LIGHT_BLUE\$(__git_ps1 \" (%s)\") $LIGHT_CYAN\w$NO_COLOR \n\$ "
}	
prompt

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'

export LSCOLORS=gxfxcxdxbxegedbxbxgxgx
alias ls='ls -GF'

export HISTCONTROL=ignoreboth:erasedups
