#!/usr/bin/env bash

function main(){
    mkdir -p $HOME/.photoshopCCV19
    mkdir -p $HOME/.cache/photoshopCCV19
    setup_log "================| script executed |================"
    check_arg $1
    is64
    package_installed aria2c
    package_installed wine
   

}

function setup_log(){
    echo -e "$(date) : $@" >> $HOME/.photoshopCCV19/setuplog.log
}

function show_message(){
    echo -e "$@"
    setup_log "$@"
}

function error(){
    echo -e "\033[1;31merror:\e[0m $@"
    setup_log "$@"
    exit 1
}

function warning(){
    echo -e "\033[1;33mWarning:\e[0m $@"
    setup_log "$@"
}

function check_arg(){
    if [ $1 != 0 ]
    then
        error "It haven't any parameter just execute script"
    fi
    show_message "argument checked..."
}

function is64(){
    local arch=$(uname -m)
    if [ $arch != "x86_64"  ];then
        warning "your distro is not 64 bit"
        read -r -p "Would you continue? [N/y] " response
        if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]];then
           echo "Good Bye!"
           exit 0
        fi
    fi
   show_message "is64 checked..."
}

function package_installed(){
    local which=$(which $1 2>/dev/null)
    if [ "$which" == "/usr/bin/$1" ];then
        show_message "package\033[1;36m $1\e[0m is installed..."
    else
        error "package\033[1;33m $1\e[0m is not installed.\nplease install it and Try again"
    fi
}

main $# $@
