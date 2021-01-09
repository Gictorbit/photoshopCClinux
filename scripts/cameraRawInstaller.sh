#!/usr/bin/env bash
function main() {
    
    source "sharedFuncs.sh"

    load_paths
    WINE_PREFIX="$SCR_PATH/prefix"

    #resources will be remove after installation
    RESOURCES_PATH="$SCR_PATH/resources"

    check_ps_installed
    
    export_var
    install_cameraRaw
}

function check_ps_installed() {
    ([ -d "$SCR_PATH" ] && [ -d "$CACHE_PATH" ] && [ -d "$WINE_PREFIX" ] && show_message2 "photoshop installed") || error2 "photoshop not found you should intsall photoshop first"
}

function install_cameraRaw() {
    local filename="CameraRaw_12_2_1.exe"
    local filemd5="b6a6b362e0c159be5ba1d0eb1ebd0054"
    local filelink="https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe"
    local filepath="$CACHE_PATH/$filename"

    download_component $filepath $filemd5 $filelink $filename

    echo "===============| Adobe Camera Raw v12 |===============" >> "$SCR_PATH/wine-error.log"
    show_message2 "Adobe Camera Raw v12 installation..."

    wine $filepath &>> "$SCR_PATH/wine-error.log" || error2 "sorry something went wrong during Adobe Camera Raw v12 installation"

    notify-send "Photoshop CC" "Adobe Camera Raw v12 installed successfully" -i "photoshop"
    show_message2 "Adobe Camera Raw v12 installed..."
    unset filename filemd5 filelink filepath
}

main
