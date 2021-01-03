#!/usr/bin/env bash

function main() {
    
    #print banner
    banner

    #read inputs
    read_input
    let answer=$?

    case "$answer" in

    1)  
        echo "run photoshop CC Installation..."
        echo -n "using winetricks for component installation..."
        run_script "scripts/PhotoshopSetup.sh" "PhotoshopSetup.sh"
        ;;
    2)  
        echo -n "run adobe camera Raw installer"
        run_script "scripts/cameraRawInstaller.sh" "cameraRawInstaller.sh"
        ;;
    3)  
        echo "run winecfg..."
        echo -n "open virtualdrive configuration..."
        run_script "scripts/winecfg.sh" "winecfg.sh"
        ;;
    4)  
        echo -n "uninstall photoshop CC ..."
        run_script "scripts/uninstaller.sh" "uninstaller.sh"
        ;;
    5)  
        echo "exit setup..."
        exitScript
        ;;
    esac
}

#argumaents 1=script_path 2=script_name 
function run_script() {
    local script_path=$1
    local script_name=$2

    wait_second 5
    if [ -f "$script_path" ];then
        echo "$script_path Found..."
        chmod +x "$script_path"
    else
        error "$script_name not Found..."    
    fi
    cd "./scripts/" && bash $script_name
    unset script_path
}

function wait_second() {
    for (( i=0 ; i<$1 ; i++ ));do
        echo -n "."
        sleep 1
    done
    echo ""
}

function read_input() {
    while true ;do
        read -p "[choose an option]$ " choose
        if [[ "$choose" =~ (^[1-5]$) ]];then
            break
        fi
        warning "choose a number between 1 to 5"
    done

    return $choose
}

function exitScript() {
    echo "Good Bye :)"
}

function banner() {
    local banner_path="$PWD/images/banner"
    if [ -f $banner_path ];then 
        clear && echo ""
        cat $banner_path
        echo ""
    else
        error "banner not Found..."
    fi
    unset banner_path
}

function error() {
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function warning() {
    echo -e "\033[1;33mWarning:\e[0m $@"
}

main
