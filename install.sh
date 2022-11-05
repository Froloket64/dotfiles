#!/bin/bash
# This is an installation/deployment script for Arch Linux

# TODO:
# - Add dependency installation
# - Add more distros

shopt -s nocasematch

# Some OS information
os_name=$(cat /etc/os-release)

# All packages including deps (e.g. `stow` for symlinking the dots)
pkgs=(alacritty dunst fish neovim qtile rofi hyprland polybar sway waybar wezterm)

gum_choose_style=(--cursor.foreground="214" --selected.background="236" --selected.foreground="214")
gum_confirm_style=(--selected.background="100" --selected.foreground="235" --unselected.background="239")

# Install a package
# IDEA: Check for OS by checking installed pkg manager
install () {
    case $os_name in
        *ubuntu* | *mint*)
            sudo apt-get install $1
            ;;

        *arch*)
            if command -v yay 2&>/dev/null; then
                yay -S --needed $1
            else
                sudo pacman -S --needed $1
            fi
            ;;

        *)
            echo "Unknown distro"
            exit
    esac
}

find_pkg () {
    case $os_name in
        *ubuntu* | *mint*)
            sudo apt-get list --installed $1 | grep $1
            ;;

        *arch*)
            if command -v yay 2&>/dev/null; then
                yay -S --needed $1
            else
                sudo pacman -S --needed $1
            fi
            ;;

        *)
            echo "Unknown distro"
            exit
    esac
}

update () {
    case $os_name in
        *ubuntu* | *mint*)
            sudo apt-get update
            ;;

        *arch*)
            if command -v yay 2&>/dev/null; then
                yay -S --needed $1
            else
                sudo pacman -S --needed $1
            fi
            ;;

        *)
            echo "Unknown distro"
            exit
    esac
}

# Additional installations
install_ext () {
    # Oh My Fish
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
}

# Parsing args
for arg in $@; do
    case $arg in
    -h | --help)
        echo "Usage:  ./install.sh [OPTIONS] [DOTFILES]

Options:
    -h, --help        Print this message
    -f, --force       Override dotfiles which are already present
    -i, --install     Install the packages along with dotfiles
    -o, --os=OS       Set \"OS\" as OS name
    -d, --dotfiles    Print all available dotfiles

You can also pass program names to install only them."

        exit
        ;;

        -f | --force)
            force=1
            ;;

        -i | --install)
            install=1
            ;;

        -d | --dotfiles)
            echo "Available dotfiles: ${pkgs[@]}"

            exit
            ;;

        -o=* | --os=*)
            # Strip off all --os='s
            os_name=${arg#"--os="}; os_name=${os_name#"-o="}
            ;;

        -*)
            echo "ERROR: Unknown option: $arg"

            exit
            ;;

        *)
            to_install += $arg
            ;;
    esac
done

# Installing base dependencies
# stow
if ! command -v stow 2&>/dev/null; then
    install stow || exit
fi

# gum
if ! command -v gum 2&>/dev/null; then
    install gum || exit
fi

# If no packages were specified, ask
if ! [[ $to_install ]]; then
    echo "Which dotfiles/packages to install? (Defaults to all)"
    echo "Space to select, Enter to confirm"

    to_install=$(gum choose ${pkgs[@]} --no-limit ${gum_choose_style[@]})

    # If still none, select all
    if ! [[ $to_install ]]; then
        to_install=${pkgs[@]}
    fi
fi

# Install all packages
if [[ $install ]] ||
       gum confirm "Install packages? (Otherwise, just copying configs)" ${gum_confirm_style[@]}; then
    echo "Installing packages..."

    update

    for pkg in ${to_install[@]}; do
        install $pkg
    done

    install_ext
fi

# Ask if existing dotfiles should be overridden if unspecified
if [[ -z $force ]]; then
    # Make check case-insensitive
    if gum confirm "Override existing dotfiles?" ${gum_confirm_style[@]}; then
        force=1
    fi
fi

# Additional configuration
fish -c "omf theme integral-froloket" 2&>/dev/null

# Dependency installation
echo "Installing dependencies..."

readarray -t deps <<< `cat dependencies.txt`

for pkg in ${deps[@]}; do
    install pkg
done

# Symlinking
# Try
output=$(stow -t ~ . 2>&1)

# Process exceptions about existing files (if --force)
if [[ $force ]]; then
    echo Removing existing dotfiles...
    readarray -t lines <<< $output

    # Delete every known dotfile that was present
    for ((i=1; i<${#lines[@]}-1; i++)); do
        file=$HOME/$(echo ${lines[i]} | awk "{print \$NF}")

        rm -f $file
    done

    stow -t ~ .
fi

echo DONE
echo Enjoy the dotfiles!
