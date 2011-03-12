PROMPT='%{$fg_bold[green]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~%(!.%{$fg[red]%}#%{$reset_color%}.%{$reset_color%}$) '

if [[ ! ($USER == 'dougal' || $USER == 'dsuther1' || $USER == 's-dougal') ]]; then
	PROMPT="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n%{$reset_color%}@${PROMPT}"
fi


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"

if [[ $HOST == 'epanastrophe.local' ]]; then
	function battery_charge {
		echo `$HOME/bin/batcharge.py` 2>/dev/null
	}

    local time_color='$(battery_charge)'
else
    local time_color='%{$fg[magenta]%}'
fi

RPROMPT='[$(git_prompt_info)'$time_color'%D{%L:%M%p}%(?.. %{$fg_bold[red]%}%?)%{$reset_color%}]'


# 	RPROMPT='[$(git_prompt_info)$(battery_charge)%(?.. %{$fg_bold[red]%}%?%{$reset_color%})]'
# 
# else
# 
# 	RPROMPT='[$(git_prompt_info)%{$fg[magenta]%}%t%(?.. %{$fg_bold[red]%}%?)%{$reset_color%}]'
# fi
# 
