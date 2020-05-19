
function package_installed(){
    local which=$(which $1 2>/dev/null)
    if [ "$which" == "/usr/bin/$1" ];then
        show_message "package\033[1;36m $1\e[0m is installed..."
    else
        warning "package\033[1;33m $1\e[0m is not installed.\nplease make sure it's already installed"
        ask_question "would you continue?" "N"
        if [ "$question_result" == "no" ];then
            echo "exit..."
            exit 5
        fi
    fi
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

function error2(){
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function warning(){
    echo -e "\033[1;33mWarning:\e[0m $@"
    setup_log "$@"
}

function warning2(){
    echo -e "\033[1;33mWarning:\e[0m $@"
}

function show_message2(){
    echo -e "$@"
}

function launcher(){
    local launcher_path="$PWD/launcher.sh"
    rmdir_if_exist "$SCR_PATH/launcher"

    if [ -f "$launcher_path" ];then
        show_message "launcher.sh detected..."
        cp "$launcher_path" "$SCR_PATH/launcher" || error "can't copy launcher"
        chmod +x "$SCR_PATH/launcher/launcher.sh"
    else
        error "launcher.sh Note Found"
    fi

    #create desktop entry
    local desktop_entry="$PWD/photoshop.desktop"
    local desktop_entry_dest="/usr/share/applications/photoshop.desktop"
    
    if [ -f "$desktop_entry" ];then
        show_message "desktop entry detected..."
        #delete desktop entry if exists
        if [ -f "$desktop_entry_dest" ];then
            show_message "desktop entry exist deleted..."
            sudo rm "$desktop_entry_dest"
        fi
        sudo cp "$desktop_entry" "/usr/share/applications" || error "can't copy desktop entry"
        sudo sed -i "s|gictorbit|$HOME|g" "$desktop_entry_dest" || error "can't edit desktop entry"
    else
        error "desktop entry Not Found"
    fi

    #create photoshop command
    show_message "create photoshop command..."
    if [ -f "/usr/local/bin/photoshop" ];then
        show_message "photoshop command exist deleted..."
        sudo rm "/usr/local/bin/photoshop"
    fi
    sudo ln -s "$SCR_PATH/launcher/launcher.sh" "/usr/local/bin/photoshop" || error "can't create photoshop command"

    unset desktop_entry desktop_entry_dest launcher_path
}

function replacement(){
    local filename="replacement.tgz"
    local filemd5="6441a8e77c082897a99c2b7b588c9ac4"
    local filelink="https://www.dropbox.com/s/17pv6aezl7wz6gs/replacement.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"

    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/replacement"
    show_message "extract replacement component..."
    tar -xzf $filepath -C "$RESOURCES_PATH/replacement"

    local replacefiles=("IconResources.idx" "PSIconsHighRes.dat" "PSIconsLowRes.dat")
    local destpath="$WINE_PREFIX/drive_c/users/$USER/PhotoshopSE/Resources"
    
    for f in "${replacefiles[@]}";do
        local sourcepath="$RESOURCES_PATH/replacement/$f"
        cp -f "$sourcepath" "$destpath" || error "cant copy replacement $f file..."
    done

    show_message "replace component compeleted..."
    unset filename filemd5 filelink filepath
}

function install_photoshopSE(){
    local filename="photoshopCC-V19.1.6-2018x64.tgz"
    local filemd5="b63f6ed690343ee12b6195424f94c33f"
    local filelink="https://www.dropbox.com/s/dwfyzq2ie6jih7g/photoshopCC-V19.1.6-2018x64.tgz?dl=1"
    local filepath="$CACHE_PATH/$filename"

    download_component $filepath $filemd5 $filelink $filename

    mkdir "$RESOURCES_PATH/photoshopCC"
    show_message "extract photoshop..."
    tar -xzf "$filepath" -C "$RESOURCES_PATH/photoshopCC"

    echo "===============| photoshop CC v19 |===============" >> "$SCR_PATH/wine-error.log"
    show_message "install photoshop..."
    show_message "\033[1;33mPlease don't change default Destination Folder\e[0m"

    wine "$RESOURCES_PATH/photoshopCC/photoshop_cc.exe" &>> "$SCR_PATH/wine-error.log" || error "sorry something went wrong during photoshop installation"

    notify-send "photoshop installed successfully" -i "photoshop"
    show_message "photoshopCC V19 x64 installed..."
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
    
    if [ "$wine_version" == "wine-3.4" ];then
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
    tar -xzf "$filepath" -C "$WINE_PATH"
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

#parameters [Message] [default flag [Y/N]]
function ask_question(){
    question_result=""
    if [ "$2" == "Y" ];then
        read -r -p "$1 [Y/n] " response
        if [[ "$response" =~ $(locale noexpr) ]];then
            question_result="no"
        else
            question_result="yes"
        fi
    elif [ "$2" == "N" ];then
        read -r -p "$1 [N/y] " response
        if [[ "$response" =~ $(locale yesexpr) ]];then
            question_result="yes"
        else
            question_result="no"
        fi
    fi
}