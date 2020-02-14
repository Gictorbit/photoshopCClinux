#!/usr/bin/env bash
main(){
    check_arg $1
    SCR_PATH="$HOME/.photoshopCCV19"
    CACHE_PATH="$HOME/.cache/photoshopCCV19"

    CMD_PATH="/usr/local/bin/photoshop"
    ENTRY_PATH="/usr/share/applications/photoshop.desktop"
    
    notify-send "photoshop uninstaller started" -i "photoshop"

    ask_question "you are uninstalling photoshop cc v19 are you sure?" "N"
    if [ $result == "no" ];then
        echo "Ok good Bye :)"
        exit 0
    fi
    
    #remove photoshop directory
    if [ -d "$SCR_PATH" ];then
        echo "remove photoshop directory..."
        rm -rf "$SCR_PATH" || error "couldn't remove photoshop directory"
        sleep 4
    else
        echo "photoshop directory Not Found!"
    fi
    
    #Unlink command 
    if [ -f "$CMD_PATH" ];then
        echo "remove luncher command..."
        sudo unlink "$CMD_PATH" || error "couln't remove luncher command"
    else
        echo "luncher command Not Found!"
    fi

    #delete desktop entry
    if [ -f "$ENTRY_PATH" ];then
        echo "remove dekstop entry...."
        sudo rm "$ENTRY_PATH" || error "couldn't remove desktop entry"
    else
        echo "desktop entry Not Found!"
    fi

    #delete cache directoy
    if [ -d "$CACHE_PATH" ];then
        echo "--------------------------------"
        echo "all downloaded components are in cache directory and you can use them for photoshop installation next time without wasting internet traffic"
        echo -e "your cache directory is \033[1;36m$CACHE_PATH\e[0m"
        echo "--------------------------------"
        ask_question "would you delete cache directory?" "N"
        if [ "$result" == "yes" ];then
            rm -rf "$CACHE_PATH" || error "couldn't remove cache directory"
        else
            echo "nice, you can copy component data and use them later for photoshop installation"
        fi
    else
        echo "cache directory Not Found!"    
    fi

}

function error(){
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function check_arg(){
    if [ $1 != 0 ];then
        error "please just run script without any argument"
    fi
}

#parameters [Message] [default flag [Y/N]]
function ask_question(){
    result=""
    if [ "$2" == "Y" ];then
        read -r -p "$1 [Y/n] " response
        if [[ "$response" =~ $(locale noexpr) ]];then
            result="no"
        else
            result="yes"
        fi
    elif [ "$2" == "N" ];then
        read -r -p "$1 [N/y] " response
        if [[ "$response" =~ $(locale yesexpr) ]];then
            result="yes"
        else
            result="no"
        fi
    fi
}

main $# $@
