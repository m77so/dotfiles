
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

# orebibou.com
# 時刻を更新するやつ
TMOUT=1
TRAPALRM() {
    if [ "$WIDGET" != "expand-or-complete" ]; then
        zle reset-prompt
    fi
}

# コマンドの開始終了時刻表示するやつ
# http://auewe.hatenablog.com/entry/2017/07/02/145735 より
export PREV_COMMAND_END_TIME
export NEXT_COMMAND_BGN_TIME

function show_command_end_time() {
  PREV_COMMAND_END_TIME=`date "+%H:%M:%S"`
  RPROMPT="${PREV_COMMAND_END_TIME} -         "
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd show_command_end_time

show_command_begin_time() {
  NEXT_COMMAND_BGN_TIME=`date "+%H:%M:%S"`
  RPROMPT="${PREV_COMMAND_END_TIME} - ${NEXT_COMMAND_BGN_TIME}"
  zle .accept-line
  zle .reset-prompt
}
zle -N accept-line show_command_begin_time




# history pecoで検索
function peco-history-selection() {
    BUFFER=`history -n 1 | perl -e 'print reverse <>' | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
