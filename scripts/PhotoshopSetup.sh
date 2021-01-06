#!/usr/bin/env bash
source "sharedFuncs.sh"

function main() {
    
    mkdir -p $SCR_PATH
    mkdir -p $CACHE_PATH
    
    setup_log "================| script executed |================"

    is64

    #make sure wine and winetricks package is already installed
    package_installed wine
    package_installed md5sum
    package_installed winetricks

    RESOURCES_PATH="$SCR_PATH/resources"
    WINE_PREFIX="$SCR_PATH/prefix"
    
    #create new wine prefix for photoshop
    rmdir_if_exist $WINE_PREFIX
    
    #export necessary variable for wine
    export_var
    
    #config wine prefix and install mono and gecko automatic
    echo -e "\033[1;93mplease install mono and gecko packages then click on OK button\e[0m"
    winecfg 2> "$SCR_PATH/wine-error.log"
    if [ $? -eq 0 ];then
        show_message "prefix configured..."
        sleep 5
    else
        error "prefix config failed :("
    fi
    
    if [ -f "$WINE_PREFIX/user.reg" ];then
        #add dark mod
        set_dark_mod
    else
        error "user.reg Not Found :("
    fi
   
    #create resources directory 
    rmdir_if_exist $RESOURCES_PATH

    # winetricks atmlib corefonts fontsmooth=rgb gdiplus vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 atmlib msxml3 msxml6 gdiplus
    winetricks atmlib fontsmooth=rgb vcrun2008 vcrun2010 vcrun2012 vcrun2013 atmlib msxml3 msxml6
    
    #install photoshop
    sleep 3
    install_photoshopSE
    sleep 5
    
    replacement

    if [ -d $RESOURCES_PATH ];then
        show_message "deleting resources folder"
        rm -rf $RESOURCES_PATH
    else
        error "resources folder Not Found"
    fi

    launcher
    show_message "\033[1;33mwhen you run photoshop for the first time it may take a while\e[0m"
    show_message "Almost finished..."
    sleep 30
}

check_arg $@
save_paths
main
