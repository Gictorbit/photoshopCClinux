#!/usr/bin/env bash

source "sharedFuncs.sh"

function main(){
    
    mkdir -p $SCR_PATH
    mkdir -p $CACHE_PATH
    
    setup_log "================| script executed |================"
    
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
    echo -e "\033[1;93mplease install mono and gecko packages then click on ok button\e[0m"
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

    #install vcrun 2008 ,2010,2012,2013
    install_vcrun2008
    sleep 3
    install_vcrun2010
    sleep 3
    install_vcrun2012
    sleep 3
    install_vcrun2013
    
    #install msxml3 and msxml6 and atmlib 
    sleep 3
    install_msxml3
    sleep 3
    install_msxml6
    sleep 2
    install_atmlib
    
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
    show_message "Almost Finish..."
    sleep 30
}

function install_atmlib(){
    local filename="atmlib.tgz"
    local filemd5="d93d050fc2f310acd13894d6a0c32ee0"
    local filelink="https://www.dropbox.com/s/tnwv6prfoq5mc15/atmlib.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/atmlib"
    tar -xzf $filepath -C "$RESOURCES_PATH/atmlib"

    cp "$RESOURCES_PATH/atmlib/atmlib.dll" "$WINE_PREFIX/drive_c/windows/syswow64/atmlib.dll"
    cp "$RESOURCES_PATH/atmlib/atmlib32.dll" "$WINE_PREFIX/drive_c/windows/system32/atmlib.dll"

    show_message "atmlib installed..."
    unset filename filemd5 filelink filepath
}

function install_msxml6(){
    local filename="msxml6.tgz"
    local filemd5="6d0035ce77c0c5fdb81bafdbb145d993"
    local filelink="https://www.dropbox.com/s/z7mkvnknufji5a3/msxml6.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/msxml6"
    tar -xzf $filepath -C "$RESOURCES_PATH/msxml6"
   
    echo "===============| msxml6 |===============" >> "$SCR_PATH/wine-error.log"
   
    wine msiexec /i "$RESOURCES_PATH/msxml6/msxml6_x64.msi" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during msxml6 instalation"
    show_message "msxml6 installed..."
    unset filename filemd5 filelink filepath
}

function install_msxml3(){
    local filename="msxml3.tgz"
    local filemd5="f5d2f91929f4201c134e33daf0e07fec"
    local filelink="https://www.dropbox.com/s/oablx3gp16dneck/msxml3.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/msxml3"
    tar -xzf $filepath -C "$RESOURCES_PATH/msxml3"
   
    echo "===============| msxml3 |===============" >> "$SCR_PATH/wine-error.log"
   
    wine msiexec /i "$RESOURCES_PATH/msxml3/msxml3.msi" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during msxml3 installation"
    show_message "msxml3 installed..."
    unset filename filemd5 filelink filepath
}

function install_vcrun2013(){
    local filename="vcrun2013.tgz"
    local filemd5="f0d4e9405c9fc39974d7a62629bfe605"
    local filelink="https://www.dropbox.com/s/r1o6k8906gbx920/vcrun2013.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/vcrun2013"
    tar -xzf $filepath -C "$RESOURCES_PATH/vcrun2013"
   
    echo "===============| VCRUN 2013 |===============" >> "$SCR_PATH/wine-error.log"
   
    wine "$RESOURCES_PATH/vcrun2013/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during vcrun2013 x86 installation"
    show_message "vcrun 2013 installed..."
    unset filename filemd5 filelink filepath
}

function install_vcrun2012(){
    local filename="vcrun2012.tgz"
    local filemd5="86f912bed7b3d76aad04adc23dbe9f48"
    local filelink="https://www.dropbox.com/s/4lv27vgjkx5gkv2/vcrun2012.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/vcrun2012"
    tar -xzf $filepath -C "$RESOURCES_PATH/vcrun2012"
   
    echo "===============| VCRUN 2012 |===============" >> "$SCR_PATH/wine-error.log"
   
    wine "$RESOURCES_PATH/vcrun2012/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during vcrun2012 x86 installation"
    show_message "vcrun 2012 installed..."
    unset filename filemd5 filelink filepath
}

function install_vcrun2010(){
    local filename="vcrun2010.tgz"
    local filemd5="484a242b64b3a7de0fa6567d78b771f9"
    local filelink="https://www.dropbox.com/s/c7jyzb93hm2p7v8/vcrun2010.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/vcrun2010"
    tar -xzf $filepath -C "$RESOURCES_PATH/vcrun2010"
   
    echo "===============| VCRUN 2010 |===============" >> "$SCR_PATH/wine-error.log"
   
    wine "$RESOURCES_PATH/vcrun2010/vcredist_x64.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during vcrun2010 x64 installation"
    sleep 1
    wine "$RESOURCES_PATH/vcrun2010/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during vcrun2010 x86 installation"
    show_message "vcrun 2010 installed..."
    unset filename filemd5 filelink filepath
}

function install_vcrun2008(){
    local filename="vcrun2008.tgz"
    local filemd5="38983c8f8736738ed9d2e2bbf5d82373"
    local filelink="https://www.dropbox.com/s/fmjjrx9xq5a9qqc/vcrun2008.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"
    
    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/vcrun2008"
    tar -xzf $filepath -C "$RESOURCES_PATH/vcrun2008"
   
    echo "===============| VCRUN 2008 |===============" >> "$SCR_PATH/wine-error.log"
   
    wine "$RESOURCES_PATH/vcrun2008/vcredist_x64.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during vcrun2008 x64 installation"
    sleep 1
    wine "$RESOURCES_PATH/vcrun2008/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during vcrun2008 x86 installation"
    show_message "vcrun 2008 installed..."
    unset filename filemd5 filelink filepath
}

check_arg $@
save_paths
main
