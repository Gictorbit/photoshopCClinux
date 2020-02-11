#!/usr/bin/env bash

main(){
    
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
    package_installed md5sum

    #delete wine3.4 dir if exist then create it
    WINE_PATH="$SCR_PATH/wine-3.4"
    rmdir_if_exist $WINE_PATH

    RESOURCES_PATH="$SCR_PATH/resources"
    WINE_PREFIX="$SCR_PATH/prefix"
    
    #install wine 3.4
    install_wine34
    
    #create new wine prefix for photoshop
    rmdir_if_exist $WINE_PREFIX
    
    #export necessary variable for wine 3.4
    export_var
    
    #config wine prefix and install mono and gecko automatic
    echo -e "\033[1;93mplease allow mono and gecko packages to be installed automatically\e[0m"
    echo -e "\033[1;93mif they're not already installed then click on OK button\e[0m"
    winecfg 2> "$SCR_PATH/wine-error.log"
    if [ $? -eq 0 ];then
        show_message "prefix configured..."
        sleep 5
    else
        error "prefix config failed :("
    fi
    
    if [ -f "$WINE_PREFIX/user.reg" ];then
        #add necessary dlls
        append_DLL
        sleep 4
        #add dark mod
        set_dark_mod
    else
        error "user.reg Not Found :("
    fi
   
    #create resources directory 
    rmdir_if_exist $RESOURCES_PATH
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

set_dark_mod(){
    echo " " >> "$WINE_PREFIX/user.reg"
    local colorarray=(
        '[Control Panel\\Colors] 1491939580'
        '#time=1d2b2fb5c69191c'
        '"ActiveBorder"="49 54 58"'
        '"ActiveTitle"="49 54 58"'
        '"AppWorkSpace"="60 64 72"'
        '"Background"="49 54 58"'
        '"ButtonAlternativeFace"="200 0 0"'
        '"ButtonDkShadow"="154 154 154"'
        '"ButtonFace"="49 54 58"'
        '"ButtonHilight"="119 126 140"'
        '"ButtonLight"="60 64 72"'
        '"ButtonShadow"="60 64 72"'
        '"ButtonText"="219 220 222"'
        '"GradientActiveTitle"="49 54 58"'
        '"GradientInactiveTitle"="49 54 58"'
        '"GrayText"="155 155 155"'
        '"Hilight"="119 126 140"'
        '"HilightText"="255 255 255"'
        '"InactiveBorder"="49 54 58"'
        '"InactiveTitle"="49 54 58"'
        '"InactiveTitleText"="219 220 222"'
        '"InfoText"="159 167 180"'
        '"InfoWindow"="49 54 58"'
        '"Menu"="49 54 58"'
        '"MenuBar"="49 54 58"'
        '"MenuHilight"="119 126 140"'
        '"MenuText"="219 220 222"'
        '"Scrollbar"="73 78 88"'
        '"TitleText"="219 220 222"'
        '"Window"="35 38 41"'
        '"WindowFrame"="49 54 58"'
        '"WindowText"="219 220 222"'
    )
    for i in "${colorarray[@]}";do
        echo "$i" >> "$WINE_PREFIX/user.reg"
    done
    show_message "set dark mode for wine..." 
    unset colorarray
}

append_DLL(){ 
    local dllarray=(
        '[Software\\Wine\\DllOverrides] 1580889458'
        '#time=1d5dbf9ef00b116'
        '"*atl110"="native,builtin"'
        '"*atl120"="native,builtin"'
        '"*msvcp110"="native,builtin"'
        '"*msvcp120"="native,builtin"'
        '"*msvcr100"="native,builtin"'
        '"*msvcr110"="native,builtin"'
        '"*msvcr120"="native,builtin"'
        '"*msvcr90"="native,builtin"'
        '"*msxml3"="native"'
        '"*msxml6"="native"'
        '"*vcomp110"="native,builtin"'
        '"*vcomp120"="native,builtin"'
        '"atl110"="native,builtin"'
        '"atl80"="native,builtin"'
        '"atl90"="native,builtin"'
        '"msvcp100"="native,builtin"'
        '"msvcp110"="native,builtin"'
        '"msvcp120"="native,builtin"'
        '"msvcr100"="native,builtin"'
        '"msvcr110"="native,builtin"'
        '"msvcr120"="native,builtin"'
        '"msvcr90"="native,builtin"'
        '"msxml3"="native,builtin"'
        '"msxml6"="native,builtin"'
        '"vcomp110"="native,builtin"'
        '"vcomp120"="native,builtin"' 
    )
    show_message "adding necessary DLLs..."
    echo " " >> "$WINE_PREFIX/user.reg"
    for i in ${dllarray[@]};do
        echo "$i" >> "$WINE_PREFIX/user.reg"
    done
    unset dllarray
}

export_var(){
    export WINEPREFIX="$WINE_PREFIX"
    export PATH="$WINE_PATH/bin:$PATH"
    export LD_LIBRARY_PATH="$WINE_PATH/lib:$LD_LIBRARY_PATH"
    export WINEDLLOVERRIDES="winemenubuilder.exe=d"
    export WINESERVER="$WINE_PATH/bin/wineserver"
    export WINELOADER="$WINE_PATH/bin/wine"
    export WINEDLLPATH="$WINE_PATH/lib/wine"
    
    show_message "wine variables exported..."
    local wine_version=$(wine --version)
    
    if [ $wine_version == "wine-3.4" ];then
        show_message "wine 3.4 is configured..."
    else
        error "wine 3.4 config is wrong"
    fi
}


function install_wine34(){
    local filename="wine-3.4.tgz"
    local filepath="$CACHE_PATH/$filename" 
    local filemd5="72b485c28e40bba2b73b0d4c0c29a15f" 
    local filelink="http://bit.ly/2Sh9idu"
    download_component $filepath $filemd5 $filelink $filename 
    tar -xzvf $filepath -C $WINE_PATH 1>/dev/null
    show_message "wine 3.4 installed..."
}

#parameters is [PATH] [CheckSum] [URL] [FILE NAME]
download_component(){
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
