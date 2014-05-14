function christmas-tree () {
    d=$(date '+%m %d' | sed 's/^ *//; s/^0//; s/ /./'); # eg '12.01' or '01.03'
    if [[ $d -ge 12.10 && $d -le 12.25 ]]; then
        echo -e '\U0001F384 '
    else
        echo -e '$'
    fi
}

PROMPT='%{$fg_bold[blue]%}%~%(!.%{$fg[red]%}#%{$reset_color%}.%{$reset_color%}$(christmas-tree)) '

if [[ ! ($USER == 'dougal' || $USER == 'dsutherl' || $USER == 's-dougal' || $USER == 'dsuther1') ]]; then
	userhost="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@%m"
else;
	userhost="%{$fg_bold[green]%}%m"
fi

if [[ -n $PROMPT_HOST ]]; then
    PROMPT="$PROMPT_HOST$PROMPT"
fi


# TODO: color the hostname instead of the time?
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

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
function my_git_prompt_info {
    if [[ -n $FORCE_GIT_IN_PROMPT ]]; then
        git_prompt_info
    elif if [[ -z $NO_GIT_IN_PROMPT ]]; then
        fs=$(df -P $PWD | tail -1 | cut -d' ' -f1)
        if [[ ( "$fs" != "AFS" ) && ( "$fs" != *:* ) ]]; then
            git_prompt_info
        fi
    fi
}

RPROMPT='[$(my_git_prompt_info)$(anaconda_prompt_info)'$userhost' '$time_color$time_str'${retcode}%{$reset_color%}]'


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
