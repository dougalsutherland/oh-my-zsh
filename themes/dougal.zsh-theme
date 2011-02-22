if [[ $HOST == 'epanastrophe.local' ]]; then
	function battery_charge {
		echo `$HOME/bin/batcharge.py` 2>/dev/null
	}
	RPROMPT='[$(battery_charge)'
	#RPROMPT=''
else
	RPROMPT='[%{$fg_bold[magenta]%}%m%{$reset_color%}'
fi

RPROMPT="${RPROMPT}%(?..%{$fg[red]%} %?↵%{$reset_color%})]"

ZSH_THEME_GIT_PROMPT_PREFIX="::%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"

PROMPT='%{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[red]%}%(!.#.»)%{$reset_color%} '

if [[ ! ($USER == 'dougal' || $USER == 'dsuther1' || $USER == 's-dougal') ]]; then
	PROMPT="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n%{$reset_color%}:${PROMPT}"
fi
