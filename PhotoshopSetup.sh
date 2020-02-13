#!/usr/bin/env bash

function main(){
    
    SCR_PATH="$HOME/.photoshopCCV19"
    CACHE_PATH="$HOME/.cache/photoshopCCV19"
    
    mkdir -p $SCR_PATH
    mkdir -p $CACHE_PATH
    
    setup_log "================| script executed |================"
    
    check_arg $1
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
    echo -e "\033[1;93mplease allow mono and gecko packages to be installed automatically\e[0m"
    echo -e "\033[1;93mif they're not already installed then click on OK button\e[0m"
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

    if [ -d $RESOURCES_PATH ];then
        show_message "deleting resources folder"
        rm -rf $RESOURCES_PATH
    else
        error "resources folder Not Found"
    fi

    luncher
    show_message "\033[1;33mwhen you run photoshop for the first time it may take a while\e[0m"
    show_message "Almost Finish..."
    sleep 30
}

function setup_log(){
    echo -e "$(date) : $@" >> $SCR_PATH/setuplog.log
}

function show_message(){
    echo -e "$@"
    setup_log "$@"
}

function error(){
    echo -e "\033[1;31merror:\e[0m $@"
    setup_log "$@"
    exit 1
}

function warning(){
    echo -e "\033[1;33mWarning:\e[0m $@"
    setup_log "$@"
}

function luncher(){
    local luncher_path="$PWD/luncher.sh"
    rmdir_if_exist "$SCR_PATH/luncher"

    if [ -f "$luncher_path" ];then
        show_message "luncher.sh detected..."
        cp "$luncher_path" "$SCR_PATH/luncher" || error "can't copy luncher"
        chmod +x "$SCR_PATH/luncher/luncher.sh"
    else
        error "luncher.sh Note Found"
    fi

    #create desktop entry
    local desktop_entry="$PWD/photoshop.desktop"
    local desktop_entry_dest="$HOME/.local/share/applications/photoshop.desktop"
    
    if [ -f "$desktop_entry" ];then
        show_message "desktop entry detected..."
        #delete desktop entry if exists
        if [ -f "$desktop_entry_dest" ];then
            show_message "desktop entry exist deleted..."
            rm "$desktop_entry_dest"
        fi
        cp "$desktop_entry" "$HOME/.local/share/applications" || error "can't copy desktop entry"
        sed -i "s|gictorbit|$HOME|g" "$desktop_entry_dest" || error "can't edit desktop entry"
    else
        error "desktop entry Not Found"
    fi

    #create photoshop command
    show_message "create photoshop command..."
    if [ -f "/usr/local/bin/photoshop" ];then
        show_message "photoshop command exist deleted..."
        sudo rm "/usr/local/bin/photoshop"
    fi
    sudo ln -s "$SCR_PATH/luncher/luncher.sh" "/usr/local/bin/photoshop" || error "can't create photoshop command"

    unset desktop_entry desktop_entry_dest luncher_path
}

function install_photoshopSE(){
    local filename="photoshopCC-V19.1.6-2018x64.tgz"
    local filemd5="b63f6ed690343ee12b6195424f94c33f"
    local filelink="https://www.dropbox.com/s/dwfyzq2ie6jih7g/photoshopCC-V19.1.6-2018x64.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"

    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/photoshopCC"
    show_message "extract photoshop..."
    tar -xzf $filepath -C "$RESOURCES_PATH/photoshopCC"

    echo "===============| photoshop CC v19 |===============" >> "$SCR_PATH/wine-error.log"
    show_message "install photoshop..."
    wine "$RESOURCES_PATH/photoshopCC/photoshop_cc.exe" &>> "$SCR_PATH/wine-error.log" && notify-send "photoshop installed successfully" -i "photoshop" || error "sorry something went wrong during install photoshop"

    show_message "photoshopCC V19 x64 installed..."
    unset filename filemd5 filelink filepath
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
   
    wine msiexec /i "$RESOURCES_PATH/msxml6/msxml6_x64.msi" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing msxml6"
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
   
    wine msiexec /i "$RESOURCES_PATH/msxml3/msxml3.msi" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing msxml3"
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
   
    wine "$RESOURCES_PATH/vcrun2013/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing vcrun2013 x86"
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
   
    wine "$RESOURCES_PATH/vcrun2012/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing vcrun2012 x86"
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
   
    wine "$RESOURCES_PATH/vcrun2010/vcredist_x64.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing vcrun2010 x64"
    sleep 1
    wine "$RESOURCES_PATH/vcrun2010/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing vcrun2010 x86"
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
   
    wine "$RESOURCES_PATH/vcrun2008/vcredist_x64.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing vcrun2008 x64"
    sleep 1
    wine "$RESOURCES_PATH/vcrun2008/vcredist_x86.exe" 2>> "$SCR_PATH/wine-error.log" || error "something went wrong during installing vcrun2008 x86"
    show_message "vcrun 2008 installed..."
    unset filename filemd5 filelink filepath
}

function set_dark_mod(){
    echo " " >> "$WINE_PREFIX/user.reg"
    local colorarray=(
        '[Control Panel\\Colors] 1491939580'
        '#time=1d2b2fb5c69191c'
        '"ActiveBorder"="49 54 58"'
        '"ActiveTitle"="49 54 58"'
        '"AppWorkSpace"="60 64 72"'
        '"Background"="49 54 58"'
        '"ButtonAlternativeFace"="200 0 0"'
        '"ButtonDkShadow"="154 154 154"'
        '"ButtonFace"="49 54 58"'
        '"ButtonHilight"="119 126 140"'
        '"ButtonLight"="60 64 72"'
        '"ButtonShadow"="60 64 72"'
        '"ButtonText"="219 220 222"'
        '"GradientActiveTitle"="49 54 58"'
        '"GradientInactiveTitle"="49 54 58"'
        '"GrayText"="155 155 155"'
        '"Hilight"="119 126 140"'
        '"HilightText"="255 255 255"'
        '"InactiveBorder"="49 54 58"'
        '"InactiveTitle"="49 54 58"'
        '"InactiveTitleText"="219 220 222"'
        '"InfoText"="159 167 180"'
        '"InfoWindow"="49 54 58"'
        '"Menu"="49 54 58"'
        '"MenuBar"="49 54 58"'
        '"MenuHilight"="119 126 140"'
        '"MenuText"="219 220 222"'
        '"Scrollbar"="73 78 88"'
        '"TitleText"="219 220 222"'
        '"Window"="35 38 41"'
        '"WindowFrame"="49 54 58"'
        '"WindowText"="219 220 222"'
    )
    for i in "${colorarray[@]}";do
        echo "$i" >> "$WINE_PREFIX/user.reg"
    done
    show_message "set dark mode for wine..." 
    unset colorarray
}

function append_DLL(){ 
    local dllarray=(
        '[Software\\Wine\\DllOverrides] 1580889458'
        '#time=1d5dbf9ef00b116'
        '"*atl110"="native,builtin"'
        '"*atl120"="native,builtin"'
        '"*msvcp110"="native,builtin"'
        '"*msvcp120"="native,builtin"'
        '"*msvcr100"="native,builtin"'
        '"*msvcr110"="native,builtin"'
        '"*msvcr120"="native,builtin"'
        '"*msvcr90"="native,builtin"'
        '"*msxml3"="native"'
        '"*msxml6"="native"'
        '"*vcomp110"="native,builtin"'
        '"*vcomp120"="native,builtin"'
        '"atl110"="native,builtin"'
        '"atl80"="native,builtin"'
        '"atl90"="native,builtin"'
        '"msvcp100"="native,builtin"'
        '"msvcp110"="native,builtin"'
        '"msvcp120"="native,builtin"'
        '"msvcr100"="native,builtin"'
        '"msvcr110"="native,builtin"'
        '"msvcr120"="native,builtin"'
        '"msvcr90"="native,builtin"'
        '"msxml3"="native,builtin"'
        '"msxml6"="native,builtin"'
        '"vcomp110"="native,builtin"'
        '"vcomp120"="native,builtin"' 
    )
    show_message "add necessary DLLs..."
    echo " " >> "$WINE_PREFIX/user.reg"
    for i in ${dllarray[@]};do
        echo "$i" >> "$WINE_PREFIX/user.reg"
    done
    unset dllarray
}

function export_var(){
    export WINEPREFIX="$WINE_PREFIX"
    export PATH="$WINE_PATH/bin:$PATH"
    export LD_LIBRARY_PATH="$WINE_PATH/lib:$LD_LIBRARY_PATH"
    export WINEDLLOVERRIDES="winemenubuilder.exe=d"
    export WINESERVER="$WINE_PATH/bin/wineserver"
    export WINELOADER="$WINE_PATH/bin/wine"
    export WINEDLLPATH="$WINE_PATH/lib/wine"
    
    show_message "wine variables exported..."
    local wine_version=$(wine --version)
    
    if [ $wine_version == "wine-3.4" ];then
        show_message "wine 3.4 is configured..."
    else
        error "wine 3.4 config is wrong"
    fi
}


function install_wine34(){
    local filename="wine-3.4.tgz"
    local filepath="$CACHE_PATH/$filename" 
    local filemd5="72b485c28e40bba2b73b0d4c0c29a15f" 
    local filelink="http://www.playonlinux.com/wine/binaries/phoenicis/upstream-linux-amd64/PlayOnLinux-wine-3.4-upstream-linux-amd64.tar.gz"
    download_component $filepath $filemd5 $filelink $filename 
    tar -xzf $filepath -C $WINE_PATH
    show_message "wine 3.4 installed..."
    unset filename filepath filemd5 filelink
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
                return 1
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

function rmdir_if_exist(){
    if [ -d "$1" ];then
        rm -rf $1
        show_message "\033[0;36m$1\e[0m directory exists deleting it..."
    fi
    mkdir $1
    show_message "create\033[0;36m $1\e[0m directory..."
}

function check_arg(){
    if [ $1 != 0 ]
    then
        error "It haven't any parameter just execute script"
    fi
    show_message "argument checked..."
}

function is64(){
    local arch=$(uname -m)
    if [ $arch != "x86_64"  ];then
        warning "your distro is not 64 bit"
        read -r -p "Would you continue? [N/y] " response
        if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]];then
           echo "Good Bye!"
           exit 0
        fi
    fi
   show_message "is64 checked..."
}

function package_installed(){
    local which=$(which $1 2>/dev/null)
    if [ "$which" == "/usr/bin/$1" ];then
        show_message "package\033[1;36m $1\e[0m is installed..."
    else
        error "package\033[1;33m $1\e[0m is not installed.\nplease install it and Try again"
    fi
}

main $# $@
