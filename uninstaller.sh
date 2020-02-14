#!/usr/bin/env bash
main (){
    check_arg $1
    echo "shah"
}

error (){
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

check_arg(){
    if [ $1 != 0 ];then
        error "please just run script without any argument"
    fi
}

main $# $@
