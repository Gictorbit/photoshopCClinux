#!/usr/bin/env bash
source "sharedFuncs.sh"

function main() {
    load_paths 
    RESOURCES_PATH="$SCR_PATH/resources"
    WINE_PREFIX="$SCR_PATH/prefix"
    export WINEPREFIX="$WINE_PREFIX"
    winecfg
}

main
