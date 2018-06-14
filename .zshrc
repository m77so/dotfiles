autoload -Uz compinit
compinit

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# プロセスを横断してヒストリを共有
setopt inc_append_hisotry
# ヒストリの共有の有効化
setopt share_history
# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
# ヒストリに追加されるコマンドが古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
setopt auto_cd
setopt auto_pushd
cdpath=(.. ~ ~/src)
function chpwd() { ls }
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

if [ -f "${HOME}/.commonshrc" ] ; then
    source "${HOME}/.commonshrc"
fi
COLOR_F034="%{[38;5;034m%}"
COLOR_END="%{[0m%}"
PROMPT="[%*] ${COLOR_F034}%n@%m${COLOR_END}:%~
%# "


alias open='xdg-open'
