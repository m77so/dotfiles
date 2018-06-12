autoload -Uz compinit
compinit

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt auto_cd
case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne  "\033]0;${USER}@${HOSTNAME:=$(hostname)}: ${PWD/$HOME/"~"}\007"
    }
    ;;
esac

export EDITOR=vim
bindkey -v
setopt print_eight_bit

alias ls='ls --color=auto'
alias pacman=' sudo pacman'
alias vi='vim'
alias ll='ls -alF'
COLOR_F034="%{[38;5;034m%}"
COLOR_END="%{[0m%}"
PROMPT="[%*] ${COLOR_F034}%n@%m${COLOR_END}:%~
%# "


alias open='xdg-open'
