#!/usr/bin/env bash

function main(){

    source "sharedFuncs.sh"
    
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
    package_installed winetricks

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

    # winetricks atmlib corefonts fontsmooth=rgb gdiplus vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 atmlib msxml3 msxml6 gdiplus
    winetricks atmlib fontsmooth=rgb vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 atmlib msxml3 msxml6
    #install photoshop
    sleep 3
    install_photoshopSE
    sleep 5

    echo -e "\033[1;93mSelect \"Windwos 7\" for windows version and then click OK\e[0m"
    winecfg
    
    replacement

    if [ -d $RESOURCES_PATH ];then
        show_message "deleting resources folder"
        rm -rf $RESOURCES_PATH
    else
        error "resources folder Not Found"
    fi

    launcher
    show_message "\033[1;33mwhen you run photoshop for the first time it may take a while\e[0m"
    show_message "Almost Finish..."
    sleep 30
}

main $# $@
