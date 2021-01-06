#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f "${HOME}/.common_profile" ] ; then
    source "${HOME}/.common_profile"
fi
shopt -s autocd

if [ ${EUID:-${UID}} = 0 ]; then
    bash_color="\e[31m" 
else
    bash_color="\e[36m"
fi
PS1="[\t]${bash_color}\]\u@\h\e[0m\]:\e[32m\]\w\e[0m\]\n\\$ "
# Git repository check
function check_git {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
}

# Enter -> ls + git status
export HISTCONTROL=ignorespace
COUNT=$(wc -l < ~/.bash_history)
function lsgit {
    history -a
    COUNT_TMP=$(wc -l < ~/.bash_history)
    if [ "$COUNT" != "$COUNT_TMP" ]; then
        COUNT="$COUNT_TMP"
        return 0
    fi
    
    ls -ACF
    check_git
}
export PROMPT_COMMAND_LSGIT="lsgit"

peco-select-history() {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco-select-history'

dispatch () {
        export EXIT_STATUS="$?" 

        local f
        for f in ${!PROMPT_COMMAND_*}; do 
            eval "${!f}" 
        done
        unset f
}
export PROMPT_COMMAND="dispatch"

HISTSIZE=10000
HISTFILESIZE=10000

. /usr/local/opt/asdf/asdf.sh