function christmas-tree () {
    d=$(date '+%m %d' | sed 's/^ *//; s/^0//; s/ /./'); # eg '12.01' or '01.03'
    if [[ $d -ge 12.01 && $d -le 12.25 ]]; then
        echo -e '\U0001F384  '
    fi
}

PROMPT='$(christmas-tree)%m%{$reset_color%}:%{$fg_bold[blue]%}%~%(!.%{$fg[red]%}#%{$reset_color%}.%{$reset_color%}$) '

if [[ ! ($USER == 'dougal' || $USER == 'dsutherl' || $USER == 's-dougal' || $USER == 'dsuther1') ]]; then
	PROMPT="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@${PROMPT}"
else;
	PROMPT="%{$fg_bold[green]%}${PROMPT}"
fi



if [[ $HOST == 'epanastrophe.local' ]]; then
	function battery_charge {
		# get the relevant numbers
		res=$(ioreg -rc AppleSmartBattery | egrep '(MaxCapacity|CurrentCapacity)')
		max=$(echo $res | grep Max | egrep -o '[[:digit:]]+')
		curr=$(echo $res | grep Current | egrep -o '[[:digit:]]+')

		# divide
		portion=`echo "100 * $curr / $max" | bc` # no -l, so int division

		# spit out the appropriate color
		if [ $portion -ge 60 ]; then
			echo '%{[32m%}' # green
		elif [ $portion -ge 30 ]; then
			echo '%{[1;33m%}' # yellow
		else
			echo '%{[31m%}' # red
		fi
	}

    local time_color='$(battery_charge)'
else
    local time_color='%{$fg[magenta]%}'
fi

local time_str='%D{%L:%M%p}'

retcode_enabled="%(?.. %{$fg_bold[red]%}%?)"
retcode_disabled=''
retcode=$retcode_enabled

if [[ -z $NO_GIT_IN_PROMPT ]]; then
	ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
	ZSH_THEME_GIT_PROMPT_CLEAN=""
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"

	RPROMPT='[$(git_prompt_info)'$time_color$time_str'${retcode}%{$reset_color%}]'
else
	RPROMPT='['$time_color$time_str'${retcode}%{$reset_color%}]'
fi

# taken from dieter.zsh-theme
function accept-line-or-clear-warning () {
	if [[ -z $BUFFER ]]; then
		retcode=$retcode_disabled
	else
		retcode=$retcode_enabled
	fi
	zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
