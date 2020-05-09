#!/usr/bin/env bash
function main(){
    
    SCR_PATH="$HOME/.photoshopCCV19"
    CACHE_PATH="$HOME/.cache/photoshopCCV19" 
    WINE_PATH="$SCR_PATH/wine-3.4"
    WINE_PREFIX="$SCR_PATH/prefix"

    #resources will be remove after installation
    RESOURCES_PATH="$SCR_PATH/resources"

    check_ps_installed
    
    exportVar
    install_cameraRaw
}

function check_ps_installed(){
    ([ -d "$SCR_PATH" ] && [ -d "$CACHE_PATH" ] && [ -d "$WINE_PATH" ] && [ -d "$WINE_PREFIX" ] && show_message "photoshop installed") || error "photoshop not found you should intsall photoshop first"
}

function exportVar(){
    export WINEPREFIX="$WINE_PREFIX"
    export PATH="$WINE_PATH/bin:$PATH"
    export LD_LIBRARY_PATH="$WINE_PATH/lib:$LD_LIBRARY_PATH"
    #export WINEDLLOVERRIDES="winemenubuilder.exe=d"
    export WINESERVER="$WINE_PATH/bin/wineserver"
    export WINELOADER="$WINE_PATH/bin/wine"
    export WINEDLLPATH="$WINE_PATH/lib/wine"
}

#parameters is [PATH] [CheckSum] [URL] [FILE NAME]
function download_component(){
    local tout=0
    while true;do
        if [ $tout -ge 2 ];then
            error "sorry somthing went wrong during download $4"
        fi
        if [ -f $1 ];then
            local FILE_ID=$(md5sum $1 | cut -d" " -f1)
            if [ "$FILE_ID" == $2 ];then
                show_message "\033[1;36m$4\e[0m detected"
                return 0
            else
                show_message "md5 is not match"
                rm $1 
            fi
        else   
            show_message "downloading $4 ..."
            aria2c -c -x 8 -d $CACHE_PATH -o $4 $3
            if [ $? -eq 0 ];then
                notify-send "$4 download completed" -i "download"
            fi
            ((tout++))
        fi
    done    
}

function install_cameraRaw(){
    local filename="CameraRaw_12_2_1.exe"
    local filemd5="b6a6b362e0c159be5ba1d0eb1ebd0054"
    local filelink="https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe"
    local filepath="$CACHE_PATH/$filename"

    download_component $filepath $filemd5 $filelink $filename

    echo "===============| Adobe Camera Raw v12 |===============" >> "$SCR_PATH/wine-error.log"
    show_message "Adobe Camera Raw v12 installation..."

    wine $filepath &>> "$SCR_PATH/wine-error.log" || error "sorry something went wrong during Adobe Camera Raw v12 installation"

    notify-send "Adobe Camera Raw v12 installed successfully" -i "photoshop"
    show_message "Adobe Camera Raw v12 installed..."
    unset filename filemd5 filelink filepath
}

function show_message(){
    echo -e "$@"
}

function error(){
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function warning(){
    echo -e "\033[1;33mWarning:\e[0m $@"
}

main
