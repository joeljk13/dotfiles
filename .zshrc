source ~/.profile

case $- in
    (*i*) ;;
    (*) return
esac

# Much of this customization was inspired by oh-my-zsh; I wanted a more DIY
# approach than oh-my-zsh, though, so I've set things up myself, but using
# oh-my-zsh as a model.

HISTSIZE=8192
SAVEHIST=4096

# See zshoptions(1) for details
setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt ALWAYS_TO_END
setopt BARE_GLOB_QUAL
setopt BRACE_CCL
setopt MAGIC_EQUAL_SUBST
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_LEX_WORDS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY_TIME
setopt CORRECT
setopt CORRECT_ALL
setopt INTERACTIVE_COMMENTS
setopt HASH_EXECUTABLES_ONLY
setopt RC_QUOTES
setopt RM_STAR_WAIT
setopt PROMPT_SUBST
setopt PIPE_FAIL
setopt LONG_LIST_JOBS
unsetopt BEEP
unsetopt BG_NICE
unsetopt HIST_BEEP
unsetopt NOMATCH
unsetopt LIST_BEEP

# There are probably way more of these than necessary/useful, but even wiith
# them the shell takes less than a second to load.
zmodload -i zsh/compctl
zmodload -i zsh/complist
zmodload -i zsh/computil
zmodload -i zsh/curses
zmodload -i zsh/datetime
zmodload -i zsh/files
zmodload -i zsh/mathfunc
zmodload -i zsh/terminfo
zmodload -i zsh/zle
zmodload -i zsh/zutil

autoload -U colors && colors
autoload -U compinit && compinit
autoload -U url-quote-magic && zle -N self-insert url-quote-magic

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,comm -w -w"

git_prompt()
{
    local ref st
    local red="%{${fg[red]}%}"
    local green="%{${fg[green]}%}"
    local yellow="%{${fg[yellow]}%}"
    local reset="%{$reset_color%}"

    ref=$(git ref --short 2>/dev/null) || return 0

    [ -z "$(git status --porcelain --ignore-submodules 2>/dev/null)" ] \
        && st="$green✔$reset" \
        || st="$red✗$reset"

    echo " $yellow($ref$reset$st$yellow)$reset"
}

zsh_prompt()
{
    local red="%{${fg[red]}%}"
    local green="%{${fg[green]}%}"
    local cyan="%{${fg[cyan]}%}"
    local magenta="%{${fg[magenta]}%}"
    local blue="%{${fg[blue]}%}"
    local reset="%{$reset_color%}"

    local ret="%(?..$red%?↵$reset)"
    local user="$green%n$reset"
    local host="$cyan%m$reset"
    local dir="$magenta%~$reset"
    local end=" $blue%(!.#.»)$reset "
    local git='$(git_prompt)'

    PS1="$user@$host $dir$git$end"
    PS2="%_$end"
    RPS1="$ret %*"
    RPS2=
}

zsh_prompt

# I don't know all this is necessary, but oh-my-zsh does it and it makes things
# work (this code is basically taken from oh-my-zsh, but made prettier, IMO).
# Maybe it's because of bindkey -v?
if ((${+terminfo[smkx]})) && ((${+terminfo[rmkx]})); then
    zle-line-init() {
        echoti smkx
    }
    zle-line-finish() {
        echoti rmkx
    }

    zle -N zle-line-init
    zle -N zle-line-finish
fi

[ -z "${terminfo[kpp]}" ]   || bindkey "${terminfo[kpp]}"   \
    up-line-or-history
[ -z "${terminfo[knp]}" ]   || bindkey "${terminfo[knp]}"   \
    down-line-or-history
[ -z "${terminfo[kcuu1]}" ] || bindkey "${terminfo[kcuu1]}" \
    history-substring-search-up
[ -z "${terminfo[kcuu2]}" ] || bindkey "${terminfo[kcuu2]}" \
    history-substring-search-down
[ -z "${terminfo[khome]}" ] || bindkey "${terminfo[khome]}" \
    beginning-of-line
[ -z "${terminfo[kend]}" ]  || bindkey "${terminfo[kend]}"  \
    end-of-line
[ -z "${terminfo[kcbt]}" ]  || bindkey "${terminfo[kcbt]}"  \
    reverse-menu-complete

bindkey -M vicmd k history-substring-search-up
bindkey -M vicmd j history-substring-search-down

[ -n "${terminfo[kdch1]}" ] \
    && bindkey "${terminfo[kdch1]}" delete-char \
    || {
        bindkey "^[[3~"  delete-char
        bindkey "^[3;5~" delete-char
        bindkey "\e[3~"  delete-char
    }

bindkey ' ' magic-space
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^?' backward-delete-char
bindkey '^r' history-incremental-search-backward

zle -N edit-command-line
bindkey -v
autoload -Uz edit-command-line
bindkey -M vicmd v edit-command-line

# So that it doesn't take forever to switch into vim-like normal mode
export KEYTIMEOUT=100

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

source ~/.shellrc

[[ -f ~/.zsh-plugins/zsh-plugins ]] && source ~/.zsh-plugins/zsh-plugins
