#!/usr/bin/env bash
main(){
    check_arg $1
    ask_question "you are uninstalling photoshop cc v19 are you sure?" "N"
}

error(){
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

check_arg(){
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
