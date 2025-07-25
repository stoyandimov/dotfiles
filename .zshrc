# ZSH
export PATH=/home/$(whoami)/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/home/$(whoami)/.dotnet/tools
export ZSH=/home/$(whoami)/.oh-my-zsh
bindkey -v
ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"
plugins=(
	zsh-fzf-history-search
	zsh-you-should-use
	fzf-tab
	git
	dotnet
)

source $ZSH/oh-my-zsh.sh
source ~/.local/bin/ghc
export SYSTEMD_EDITOR=vim

# Aliases and key bindings
alias ssh='TERM=xterm ssh'
alias x=exit
alias p=~/.local/bin/output-processor
alias zshconfig="vim ~/.zshrc"
alias explorer=nautilus
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias beep="cvlc --play-and-exit -q /usr/share/sounds/freedesktop/stereo/service-logout.oga 2> /dev/null"
alias beepup="cvlc --play-and-exit -q /usr/share/sounds/freedesktop/stereo/service-login.oga 2> /dev/null"
alias notify="notify-phone && notify-send -i gnome-terminal 'Finished Terminal Job' && beep"
alias notify-when-done="fg; notify"

# Bat
export BAT_THEME="Solarized (dark)"
export BAT_STYLE="numbers"
if command -v batcat > /dev/null 2>&1; then
	alias rcat=$(which cat)
	alias cat=$(which batcat)
	alias bat=$(which batcat)
	export MANPAGER="sh -c 'col -bx | batcat -l man --paging always'"
fi

# FZF Defaults
FZF_DEFAULTS="--inline-info --select-1 --exit-0 \
	--bind='ctrl-e:execute(vim {})' \
	--bind='ctrl-t:change-preview(tree \$(dirname \$(pwd)/{}))' \
	--bind='ctrl-v:change-preview(batcat --style=numbers --color=always --line-range :500 {})'"

export FZF_DEFAULT_OPTS=$FZF_DEFAULTS

# FZF History search
export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS='--height=8 --info=hidden --layout=reverse --bind enter:replace-query+print-query'
export ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=true
export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0
export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0
export ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=1

# 1Password (op)
if which op > /dev/null; then
	eval "$(op completion zsh)"; compdef _op op
fi

# Misc
export EDITOR=vim
export DOTNET_USE_POLLING_FILE_WATCHER=true

# FUNCTIONS

# Schedules a command using time as in 12:01 and cron
schedule() {
	cronExpr="$(date --date "$1" +\%M\ \%H\ \%d\ \%m\ \%u)"
	cmd="${@:2}" # all args except first
	cronCmd="XDG_RUNTIME_DIR=/run/user/$(id -u) $HOME/.local/bin/schedule.sh \"$cmd\" 2>&1 | logger -t schedule"

	(crontab -l ; echo "$cronExpr $cronCmd") 2>&1 | grep -v "no crontab" | crontab -

	echo "'$cmd' scheduled to execute on $(date --date "$1") (use 'crontab -e' to cancel)"
	return 0;
}

alarm () {
	title="Zsh Alarm"
	time=$1
	content=$2
	schedule $time "notify-phone '$content' '$title' && notify-send -i clock '$title' '$content' && beep && beepup && beep" > /dev/null

	echo "Alarm '$content' scheduled for $(date --date "$1") (use 'crontab -e' to cancel)"

	return 0;
}
_alarm() {
	local state

	_arguments \
		'1: :->t'\
		'2: :->m'
	case $state in
			(t) _arguments (Q)"$@" '1:profiles:($(date --date "5 minutes" +\%H\:\%M) $(date --date "5 minutes" +\%H\:\%M) $(date --date "1 hour" +\%H\:\%M) "13:00" "tomorrow 09:00" "today 17:00")';;
			(m) _arguments (Q)"$@" '2:profiles:("Call/Reply " "Serve lunch" "Pickup Emil")';;
	esac
}
compdef _alarm alarm

notify-phone() {
	curl -s --get --output /dev/null \
		--data-urlencode "c=$1" \
		--data-urlencode "t=${2:-"Terminal Notification"}" \
		--data-urlencode "u=${3:-${$(hostname)}}" \
		--data-urlencode "k=$PNA_KEY" \
		https://xdroid.net/api/message

	return 0;
}

headtail() {
	head $@ && tail $@
}

syrinxctl() {
	pushd /srv/repos/intovoice/syrinxctl/src/Syrinx.AdHoc.Cli > /dev/null
	dotnet run -- $@
	popd > /dev/null
}

schoctl() {
	pushd /srv/repos/sdimov/scho-api/src/Apps/Scho.Apps.Cli > /dev/null
	dotnet run -- $@
	popd > /dev/null
}
