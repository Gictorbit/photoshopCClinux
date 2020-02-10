#!/usr/bin/env bash

function main(){
    check_arg $1
    is64
    package_installed aria2c
    package_installed wine
}

function error(){
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function warning(){
    echo -e "\033[1;33mWarning:\e[0m $@"
}

function check_arg(){
    if [ $1 != 0 ]
    then
        error "It haven't any parameter just execute script"
    fi
    echo "argument checked..."
}

function is64(){
    local arch=$(uname -m)
    if [ $arch != "x86_64"  ];then
        warning "your distro is not 64 bit"
        read -r -p "Would you continue? [N/y] " response
        if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]];then
           echo "Good By!"
           exit 0
        fi
    fi
   echo "is64 checked..." 
}

function package_installed(){
    local which=$(which $1 2>/dev/null)
    if [ "$which" == "/usr/bin/$1" ];then
        echo -e "package\033[1;36m $1\e[0m is installed..."
    else
        error "package\033[1;33m $1\e[0m is not installed.\nplease install it and Try again"
    fi
}

main $# $@
