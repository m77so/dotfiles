#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
    alias pacman=' sudo pacman'
fi
alias ll='ls -lah'
alias vi='vim'
alias ..='cd ..'
alias ...='cd ../..'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

PS1='[\t]\e[36m\]\u@\h\e[0m\]:\e[32m\]\w\e[0m\]\n\$ '
# Git repository check
function check_git {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
}
# cd -> cd + ls
function autols {
    if [ "${AUTOLS_DIR:-$PWD}" != "$PWD" ]; then
        ls -ACF
        check_git
    fi
    AUTOLS_DIR="${PWD}"
}
export PROMPT_COMMAND_AUTOLS="autols"

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

dispatch () {
        export EXIT_STATUS="$?" 

        local f
        for f in ${!PROMPT_COMMAND_*}; do 
            eval "${!f}" 
        done
        unset f
}
export PROMPT_COMMAND="dispatch"
