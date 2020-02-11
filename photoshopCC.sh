#!/usr/bin/env bash

function main(){
    
    SCR_PATH="$HOME/.photoshopCCV19"
    CACHE_PATH="$HOME/.cache/photoshopCCV19"
    
    mkdir -p $SCR_PATH
    mkdir -p $CACHE_PATH
    
    setup_log "================| script executed |================"
    
    check_arg $1
    is64

    #make sure aria2c and wine package is already installed 
    package_installed aria2c
    package_installed wine
    
    #delete wine3.4 dir if exist then create it
    WINE_PATH="$SCR_PATH/wine-3.4"
    rmdir_if_exist $WINE_PATH

    RESOURCES_PATH="$SCR_PATH/resources"
    echo "$RESOURCES_PATH"

    pathfile="$CACHE_PATH/fuck.jpg" 
    md5="b71c05c238f2cdb979e650ecb1d62bba" 
    link="https://www.dropbox.com/s/61hn7c9oezw0k75/salamKhoviefuckthisshit.jpg?dl=1" 
    filename="fuck.jpg"
    download_component $pathfile $md5 $link $filename 

}

function setup_log(){
    echo -e "$(date) : $@" >> $SCR_PATH/setuplog.log
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

#parameters is [PATH] [CheckSum] [URL] [FILE NAME]
function download_component(){
    local tout=0
    while true;do
        if [ $tout -ge 2 ];then
            error "sorry somthing went wrong"
        fi
        if [ -f $1 ];then
            local FILE_ID=$(md5sum $1 | cut -d" " -f1)
            if [ "$FILE_ID" == $2 ];then
                show_message "\033[1;36m$4\e[0m is detected"
                return 1
            else
                show_message "md5 is not match"
                rm $1 
            fi
        else   
            show_message "downloading $4"
            aria2c -c -x 8 -d $CACHE_PATH -o $4 $3
            ((tout++))
        fi
    done    
}

function rmdir_if_exist(){
    if [ -d "$1" ];then
        rm -rf $1
        show_message "\033[0;36m$1\e[0m directory exists deleting it..."
    fi
    mkdir $1
    show_message "create\033[0;36m $1\e[0m directory..."
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
