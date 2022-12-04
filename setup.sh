#!/usr/bin/env bash

# Define global variables
readonly BANNER_PATH="$PWD/images/banner"
readonly PHOTOSHOP_CC_SCRIPT="scripts/PhotoshopSetup.sh"
readonly CAMERA_RAW_SCRIPT="scripts/cameraRawInstaller.sh"
readonly WINECFG_SCRIPT="scripts/winecfg.sh"
readonly UNINSTALL_SCRIPT="scripts/uninstaller.sh"

# Define the main function
function main() {
    # Print banner
    print_banner

    # Read user input
    local option=$(read_input)

    # Execute the chosen option
    case "$option" in
    1)  
        echo "Running Photoshop CC installation script..."
        echo -n "Using winetricks for component installation..."
        run_script "$PHOTOSHOP_CC_SCRIPT"
        ;;
    2)  
        echo "Running Adobe Camera Raw installer script..."
        run_script "$CAMERA_RAW_SCRIPT"
        ;;
    3)  
        echo "Running winecfg script..."
        echo -n "Opening virtualdrive configuration..."
        run_script "$WINECFG_SCRIPT"
        ;;
    4)  
        echo "Running Photoshop CC uninstaller script..."
        run_script "$UNINSTALL_SCRIPT"
        ;;
    5)  
        echo "Exiting setup..."
        exit_script
        ;;
    esac
}

# Define the function that runs a script
# Arguments:
#   - $1: The path to the script to be run
function run_script() {
    local script_path=$1

    # Wait for 5 seconds
    wait_seconds 5

    # Check if the script exists
    if [ -f "$script_path" ]; then
        echo "$script_path found..."
        # Make the script executable
        chmod +x "$script_path"
        # Change directory to the scripts directory and run the script
        cd "./scripts/" && bash "$script_path"
    else
        error "$script_path not found..."    
    fi
    unset script_path
}

# Define the function that waits for a specified number of seconds
# Arguments:
#   - $1: The number of seconds to wait
function wait_seconds() {
    for (( i=0; i<$1; i++ )); do
        echo -n "."
        sleep 1
    done
    echo ""
}

# Define the function that reads user input
function read_input() {
    # Read the user's choice
    read -p "[Choose an option]$ " choose

    # Check if the user's choice is a number between 1 and 5
    if [[ "$choose" =~ (^[1-5]$) ]]; then
        # Return the user's choice
        echo "$choose"
    else
        warning "Choose a number between 1 and 5"
        # Call the function recursively until the user enters a valid choice
        read_input
    fi
}

# Define the function that exits the script
function exit_script() {
    echo "Goodbye :)"
    exit 0
}
