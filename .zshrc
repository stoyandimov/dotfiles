# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/$(whoami)/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git dotnet)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# my
bindkey -v

alias explorer=nautilus
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias mlnet="/home/$(whoami)/.dotnet/tools/mlnet"
alias syrinxctl="cd /srv/repos/intovoice/hpbxapi/src/AdHoc/Syrinx.AdHoc.In2voice && dotnet run -- "
alias beep="cvlc --play-and-exit -q /usr/share/sounds/freedesktop/stereo/service-logout.oga 2> /dev/null"
alias beepup="cvlc --play-and-exit -q /usr/share/sounds/freedesktop/stereo/service-login.oga 2> /dev/null"
alias notify="notify-phone && notify-send -i gnome-terminal 'Finished Terminal Job' && beep"
alias notify-when-done="fg; notify"

# FZF Defaults
export FZF_DEFAULT_OPTS='--inline-info --select-1 --exit-0'

# FZF History search
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search/zsh-fzf-history-search.zsh
export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS='--height=8 --info=hidden --layout=reverse --bind enter:replace-query+print-query'
export ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=true
export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0
export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0
export ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=1

# FZF ZSH Autocomplete
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh
export FZF_COMPLETION_OPTS='' # included after FZF_DEFAULT_OPTS

# Misc
export EDITOR=vim
export PATH=/home/$(whoami)/.local/bin:$PATH:/home/$(whoami)/.dotnet/tools
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

