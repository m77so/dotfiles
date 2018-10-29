
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
if [ -f "${HOME}/.commonshrc" ] ; then
    source "${HOME}/.commonshrc"
fi

function chpwd() { ls }
# zplug
source ~/.zplug/init.zsh
# ないコマンドで赤くなるやつ
zplug "zsh-users/zsh-syntax-highlighting"
# めちゃくちゃ補完候補増やすやつ
zplug "zsh-users/zsh-completions"
# git の補完を効かせる
# 補完＆エイリアスが追加される
zplug "plugins/git",   from:oh-my-zsh
zplug "peterhurford/git-aliases.zsh"
# 薄く出すやつ
zplug "zsh-users/zsh-autosuggestions", defer:2  
if ! zplug check; then
	zplug install
fi

zplug load --verbose




setopt promptsubst

PROMPT="[%*]%F{039}%n@%m%f:%F{083}%d%f
%(?|%F{076}|%F{009})%(?!(*'-') !(%?;-;%) )%#%f " 
setopt correct
SPROMPT="%{%F{220}%}%{$suggest%}(._.%)? %B %r is correct? [n,y,a,e]:%f%}%b "


# history pecoで検索
function peco-history-selection() {
    BUFFER=`history -n 1 | perl -e 'print reverse <>' | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
