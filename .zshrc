
autoload -U compinit promptinit
autoload -Uz vcs_info
compinit
promptinit

# 補完に関する設定
zstyle ':completion:*' menu select=2 interactive
setopt menu_complete

zmodload zsh/complist
# 次の補完メニューを表示する
bindkey -M menuselect '^k' accept-and-infer-next-history  

zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
# https://gihyo.jp/dev/serial/01/zsh-book/0005
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
 
# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-pushd true
# ヒストリに関する設定
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


# コマンドの開始終了時刻表示するやつ
# http://auewe.hatenablog.com/entry/2017/07/02/145735 より
export PREV_COMMAND_END_TIME
export NEXT_COMMAND_BGN_TIME

function show_command_end_time() {
  PREV_COMMAND_END_TIME=`date "+%H:%M:%S"`
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd show_command_end_time
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' max-exports 7
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
zstyle ':vcs_info:*' formats '%R' '%S' '%b' '%s' '%c%u %m' 
zstyle ':vcs_info:*' actionformats '%R' '%S' '%b' '%s' '%c%u %m' '<!%a>'

prompt_refresh(){
NEXT_COMMAND_BGN_TIME=`date "+%H:%M:%S"`
PROMPT=" ${NEXT_COMMAND_BGN_TIME}]%(?|%F{076}|%F{009})%(?!(z ╹ヮ╹) !(%? ◞‸◟%) )%#%f " 
}
print_above_prompt(){
    local  prompt
    prompt="[${PREV_COMMAND_END_TIME} %F{039}%n@%m%f:%F{010}"
    if [[ -z ${vcs_info_msg_0_} ]]; then
        prompt+="%d%f"
    else
        if [[ "$vcs_info_msg_1_" == "." ]];then
          vcs_info_msg_1_=""
        else
          vcs_info_msg_1_="/$vcs_info_msg_1_"
        fi
        prompt+="${vcs_info_msg_0_}%f%F{154}${vcs_info_msg_1_}%f [${vcs_info_msg_2_}]"
        [[ -n ${vcs_info_msg_4_} ]] && prompt+="%F{221}${vcs_info_msg_4_}%f"
        [[ -n ${vcs_info_msg_5_} ]] && prompt+="%F{161}${vcs_info_msg_5_}%f"
        prompt+="(${vcs_info_msg_3_})"
       
    fi
    print -P $prompt
}
add-zsh-hook precmd print_above_prompt

setopt promptsubst

setopt correct
SPROMPT="%{%F{220}%}%{$suggest%}(._.%)? %B %r is correct? [n,y,a,e]:%f%}%b "
prompt_refresh
# orebibou.com
# 時刻を更新するやつ
TMOUT=1
TRAPALRM() {
    if test "$WIDGET" != "expand-or-complete" -a "$WIDGET" != "peco-history-selection"; then
        prompt_refresh
        zle reset-prompt
    fi
}


# history pecoで検索
function peco-history-selection() {
    BUFFER=`history -n 1 | perl -e 'print reverse <>' | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection


source ~/.profile
