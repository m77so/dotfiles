#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f "${HOME}/.commonshrc" ] ; then
    source "${HOME}/.commonshrc"
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
# cd -> cd + ls
function autols {
    if [ "${AUTOLS_DIR:-$PWD}" != "$PWD" ]; then
        ls -CF
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
        history -a;
        echo "$(date "+%Y-%m-%d %H:%M:%S") [$(/bin/pwd)] $(history 1)" >> ~/.history_with_dir';
}
export PROMPT_COMMAND="dispatch"
