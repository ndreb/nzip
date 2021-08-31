#!/bin/sh

# https://github.com/ndreb/nzip

help="For help, type: nzip -h"

usage() {
    cat <<'END'


███╗   ██╗███████╗██╗██████╗ 
████╗  ██║╚══███╔╝██║██╔══██╗
██╔██╗ ██║  ███╔╝ ██║██████╔╝
██║╚██╗██║ ███╔╝  ██║██╔═══╝ 
██║ ╚████║███████╗██║██║     
╚═╝  ╚═══╝╚══════╝╚═╝╚═╝     
                             

Usage: nzip [FILE]
By default FILE(s) will be extracted to the working directory.

OPTIONS:
 
    -d, destination, e.g., nzip [FILE] [-d DESTINATION]
    -h, help


report bugs to https://github.com/ndreb/nzip
END
}

error() {
    printf '%s\n' "$@" >&2
    exit 1
}

filecheck() {
    if [ -f "$1" ]
    then
        return 0
    else
        error "FILE $1 does not exist."
    fi
}

optioncheck() {
    if [ "$2" = "-d" ]
    then
        return 0
    else
        case $2 in
            -h) error "$help"
                ;;
            *) error "$2 is not a valid option."
        esac
    fi
}

destinationcheck() {
    if [ -e "$3" ]
    then
        return 0
    else
        printf '%s\n' "DESTINATION $3 does not exist."
        printf '%s' "Do you want to create it? [Y/n] "
        read -r input
        case $input in
            y|Y|[yY][eE][sS]) mkdir -p "$3"
                ;;
            *) error "$3 was not created. nzip will abort."
        esac
    fi
}

firstcheck() {
    if [ $# -eq 1 ]
    then
        case $1 in
            -h) usage
                exit 0
                ;;
            -*) error "$help"
                ;;
            *) filecheck "$@"
        esac
    else
        if [ $# -gt 1 ]
        then
            case $1 in
                -h) error "$help"
                    ;;
                -*) error "$help"
                    ;;
                *) filecheck "$@"
            esac
        fi
    fi
}

checkall() {
    firstcheck "$@" && optioncheck "$@" && destinationcheck "$@"
}

if [ $# -eq 0 ]
then
    error "$help"
else
    if [ $# -eq 1 ] && firstcheck "$@"
    then
        case $1 in
            *.7z) exec 7z e "$1"
                ;;
            *.tar.bz2) exec tar xjf "$1"
                ;;
            *.tar.gz) exec tar xzf "$1"
                ;;
            *.rar) exec unrar e "$1"
                ;;
            *.tar) exec tar xf "$1"
                ;;
            *.bz2) exec bunzip2 -k "$1"
                ;;
            *.tbz) exec tar xjf "$1"
                ;;
            *.gz) exec gunzip -k "$1"
                ;;
            *.tgz) exec tar xzf "$1"
                ;;
            *.jar) exec unzip "$1"
                ;;
            *.cab|*.CAB) exec cabextract "$1"
                ;;
            *.xz) exec tar xf "$1"
                ;;
            *.zip) exec unzip "$1"
                ;;
            *.Z) exec uncompress "$1"
                ;;
            *) error "No extraction option for $1"
        esac
    else
        if [ $# -eq 3 ] && checkall "$@"
        then
            case $1 in
                *.7z) exec 7z e "$1" -o"$3"
                    ;;
                *.tar.bz2) exec tar xjf "$1" -C "$3"
                    ;;
                *.tar.gz) exec tar xzf "$1" -C "$3"
                    ;;
                *.rar) exec unrar e "$1" "$3"
                    ;;
                *.tar) exec tar xf "$1" -C "$3"
                    ;;
                *.bz2) exec bunzip2 "$1" -c > "$3/${1%.*}"
                    ;;
                *.tbz) exec tar xjf "$1" -C "$3"
                    ;;
                *.gz) exec gunzip "$1" -c > "$3/${1%.*}"
                    ;;
                *.tgz) exec tar xzf "$1" -C "$3"
                    ;;
                *.jar) exec unzip "$1" -d "$3"
                    ;;
                *.cab|*.CAB) exec cabextract -d "$3" "$1"
                    ;;
                *.xz) exec tar xf "$1" -C "$3"
                    ;;
                *.zip) exec unzip "$1" -d "$3"
                    ;;
                *.Z) exec uncompress "$1" -c > "$3/${1%.*}"
                    ;;
                *) error "No extraction option for $1"
            esac
        else
            error "$help"
        fi
    fi
fi
