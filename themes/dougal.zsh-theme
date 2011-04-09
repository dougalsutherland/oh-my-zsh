PROMPT='%m%{$reset_color%}:%{$fg_bold[blue]%}%~%(!.%{$fg[red]%}#%{$reset_color%}.%{$reset_color%}$) '

if [[ ! ($USER == 'dougal' || $USER == 'dsuther1' || $USER == 's-dougal') ]]; then
	PROMPT="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@${PROMPT}"
else;
	PROMPT="%{$fg_bold[green]%}${PROMPT}"
fi


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"

if [[ $HOST == 'epanastrophe.local' ]]; then
	function battery_charge {
		# get the relevant numbers
		tmp=`mktemp -t battery`
		ioreg -rc AppleSmartBattery | egrep '(MaxCapacity|CurrentCapacity)' > $tmp

		max=`grep Max $tmp | egrep -o '[[:digit:]]+'`
		curr=`grep Current $tmp | egrep -o '[[:digit:]]+'`
		rm -f $tmp

		# divide
		portion=`echo "100 * $curr / $max" | bc` # no -l, so int division

		# spit out the appropriate color
		if [ $portion -gt 60 ]; then
			echo '%{[32m%}' # green
		elif [ $portion -gt 35 ]; then
			echo '%{[1;33m%}' # yellow
		else
			echo '%{[31m%}' # red
		fi
	}

    local time_color='$(battery_charge)'
else
    local time_color='%{$fg[magenta]%}'
fi

RPROMPT='[$(git_prompt_info)'$time_color'%D{%L:%M%p}%(?.. %{$fg_bold[red]%}%?)%{$reset_color%}]'
