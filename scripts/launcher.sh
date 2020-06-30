#!/usr/bin/env bash
if [ $# -ne 0 ];then
    echo "I have no parameters just run the script without arguments"
    exit 1
fi

notify-send "Photoshop CC started." -i "photoshop"

# SCR_PATH="$HOME/.photoshopCCV19"
# CACHE_PATH="$HOME/.cache/photoshopCCV19"
SCR_PATH="pspath"
CACHE_PATH="pscache"

WINE_PATH="$SCR_PATH/wine-3.4"

RESOURCES_PATH="$SCR_PATH/resources"
WINE_PREFIX="$SCR_PATH/prefix"
 

export WINEPREFIX="$WINE_PREFIX"
export PATH="$WINE_PATH/bin:$PATH"
export LD_LIBRARY_PATH="$WINE_PATH/lib:$LD_LIBRARY_PATH"
#export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export WINESERVER="$WINE_PATH/bin/wineserver"
export WINELOADER="$WINE_PATH/bin/wine"
export WINEDLLPATH="$WINE_PATH/lib/wine"

wine "$SCR_PATH/prefix/drive_c/users/$USER/PhotoshopSE/Photoshop.exe"
