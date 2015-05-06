source ~/.profile

# Much of this customization was inspired by oh-my-zsh

HISTSIZE=8192
SAVEHIST=4096

# See zshoptions(1) for details
setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt ALWAYS_TO_END
setopt MENU_COMPLETE
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
setopt RC_STAR_WAIT
setopt PROMPT_SUBST
setopt PIPE_FAIL
setopt LONG_LIST_JOBS
unsetopt BEEP
unsetopt BG_NICE
unsetopt HIST_BEEP
unsetopt NOMATCH
unsetopt LIST_BEEP

zmodload -i zsh/compctl
zmodload -i zsh/complist
zmodload -i zsh/computil
zmodload -i zsh/curses
zmodload -i zsh/datetime
zmodload -i zsh/files
zmodload -i zsh/mathfunc
zmodload -i zsh/zle
zmodload -i zsh/zutil

autoload -U colors && colors
autoload -U compinit && compinit
autoload -U url-quote-magic && zle -N self-insert url-quote-magic

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors '=(-- *)=34'
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,comm -w -w"

git_prompt()
{
    local ref st
    local red="%{${fg[red]}%}"
    local green="%{${fg[green]}%}"
    local yellow="%{${fg[yellow]}%}"
    local reset="%{$reset_color%}"

    ref=$(git symbolic-ref HEAD 2>/dev/null) \
        || ref=$(git rev-parse --short HEAD 2>/dev/null) \
        || return 0

    [ -z "$(git status --porcelain --ignore-submodules)" ] \
        && st="$green✔" \
        || st="$red✗"

    echo " $yellow(${ref#refs/heads/}$reset $st$reset$yellow)$reset"
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
    local path="$magenta%~$reset"
    local prompt=" $blue%(!.#.»)$reset "
    local git='$(git_prompt)'

    PS1="$user@$host $path$git$prompt"
    PS2="%_$prompt"
    RPS1="$ret$*"
    RPS2=
}

zsh_prompt

bindkey -v
autoload -Uz edit-command-line
bindkey -M vicmd v edit-command-line

source ~/software/opp.zsh/opp.zsh
source ~/software/opp.zsh/opp/surround.zsh
source ~/software/opp.zsh/opp/textobj-between.zsh
# So that it doesn't take forever to switch into vim-like normal mode
export KEYTIMEOUT=100

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

source ~/.shellrc
