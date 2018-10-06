
autoload -U compinit promptinit
compinit
promptinit

zstyle ':completion:*' menu select
setopt completealiases

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# ヒストリの共有の有効化
setopt share_history
# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
# ヒストリに追加されるコマンドが古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
setopt auto_cd
setopt auto_pushd
cdpath=(.. ~ ~/src)


autoload -Uz colors
colors

# zplug
source ~/.zplug/init.zsh
# ないコマンドで赤くなるやつ
zplug "zsh-users/zsh-syntax-highlighting"
# めちゃくちゃ補完候補増やすやつ
zplug "zsh-users/zsh-completions"
# 移動するやつ
zplug "junegunn/fzf-bin", \
    as:command, \
    rename-to:"fzf", \
    from:gh-r, \
    on: zplug "b4b4r07/enhancd", of:enhancd.sh

if ! zplug check; then
	zplug install
fi

zplug load --verbose


if [ -f "${HOME}/.commonshrc" ] ; then
    source "${HOME}/.commonshrc"
fi

function chpwd() { ls }
setopt promptsubst

PROMPT="[%*]%F{039}%n@%m%f %F{083}%d
%(?|%F{076}|%F{009})%(?!(*'-') !(%?;-;%) )%#%f " 
setopt correct
SPROMPT="%{%F{220}%}%{$suggest%}(._.%)? %B %r is correct? [n,y,a,e]:%f%}%b "

