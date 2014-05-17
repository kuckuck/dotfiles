# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#---------------------------------------------------------------
# Bash options
#---------------------------------------------------------------

PS1='┌─[$PWD]\n└─╼ '

shopt -s autocd
shopt -s expand_aliases
shopt -s cdspell
shopt -s progcomp

unset HISTFILESIZE
HISTSIZE="1000000000000000"
export HISTCONTROL=ignoreboth:erasedups
PROMPT_COMMAND="history -a; history -c; history -r"
export HISTSIZE PROMPT_COMMAND

export EDITOR='vim'
export IMAGE_VIEWER='sxiv'
source /usr/share/doc/pkgfile/command-not-found.bash

#---------------------------------------------------------------
# Bash completion
#---------------------------------------------------------------

set show-all-if-ambiguous on
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#---------------------------------------------------------------
# Aliases 
#---------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias pacman='sudo pacman --color always'
alias ls='clear && ls --color=auto'
alias rm='rm -i -v'
alias ping='ping -c 5'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias clea='clear; echo "correcting clea to clear"'
alias wifi="wicd-curses"
alias youtube="youtube-dl --title --no-overwrites --continue --write-description"
alias ffp="sudo systemctl start polipo && firefox; exit"
alias main='grep -rni "main(" * ; grep -rni "main (" *'
alias dus='sudo du --human-readable --max-depth=1 | sort --human-numeric-sort'
alias +x='chmod +x'
alias loc='cloc'

#---------------------------------------------------------------
# Functions
#---------------------------------------------------------------

function secure_chromium {
    port=4711
    chromium --proxy-server="socks://localhost:$port" &
    exit
}

extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
        *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
               c='bsdtar xvf';;
        *.7z)  c='7z x';;
        *.Z)   c='uncompress';;
        *.bz2) c='bunzip2';;
        *.exe) c='cabextract';;
        *.gz)  c='gunzip';;
        *.rar) c='unrar x';;
        *.xz)  c='unxz';;
        *.zip) c='unzip';;
        *)     echo "$0: unrecognized file extension: \`$i'" >&2
               continue;;
        esac

        command $c "$i"
        e=$?
    done

    return $e
}
