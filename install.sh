#!/bin/bash
# This is an installation/deployment script for Arch Linux

# TODO:
# - Add dependency installation
# - Add more distros

# Some OS information
os_name=$(cat /etc/os-release)

# All packages including deps (e.g. `stow` for symlinking the dots)
pkgs=(alacritty dunst fish neovim qtile rofi hyprland polybar sway waybar wezterm)

gum_choose_style=(--cursor.foreground="11" --selected.background="236" --selected.foreground="3")
gum_confirm_style=(--selected.background="2" --selected.foreground="0" --unselected.background="")

## Definitions
# Install a package
# IDEA: Check for OS by checking installed pkg manager
install () {
    case $os_name in
        *ubuntu* | *mint*)
            # Try apt then snap
            sudo apt-get install -y $1 || snap install $1
            ;;

        *arch*)
            if command -v yay 2&>/dev/null; then
                yay -S --needed --noconfirm $1
            else
                sudo pacman -S --needed --noconfirm $1
            fi
            ;;

        *)
            echo "Unknown distro"
            exit
    esac
}

# Update repositories
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
    if [[ " ${to_install[*]} " == *" fish "* ]]; then
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    fi
}

## Parsing args
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

        -I | --no-install)
            install=0
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
            if [[ " ${pkgs[*]} " == *" $arg "* ]]; then
                to_install+=$arg
            else
                echo "Unknown argument: $arg"
                exit
            fi
            ;;
    esac
done

# If no packages were specified, ask
if ! [[ $to_install ]]; then
    echo "Which dotfiles/packages to install/copy?"
    echo "Space to select, Enter to confirm, Ctrl-C to select all"

    to_install=$(gum choose ${pkgs[@]} --no-limit ${gum_choose_style[@]})

    # If still none, select all
    if ! [[ $to_install ]]; then
        to_install=${pkgs[@]}
    fi
fi

## Installing base dependencies
# stow
if ! command -v stow 2&>/dev/null; then
    install stow || exit
fi

# gum
if ! command -v gum 2&>/dev/null; then
    install gum || exit
fi

## Installing packages
# Ask whether install if unset
if [[ -z $install ]]; then
    if gum confirm "Install packages? (Otherwise, just copying configs)" ${gum_confirm_style[@]}; then
        install=1
    else
        install=0
    fi
fi

# Install
if [[ $install == 1 ]]; then
    echo "Installing packages..."

    update

    for pkg in ${to_install[@]}; do
        install $pkg
    done

    install_ext
fi

## Additional configuration
if [[ " ${to_install[*]} " == *" fish "* ]]; then
    fish -c "omf theme integral-froloket" 2&>/dev/null
fi

## Dependency installation
if [[ $install == 1 ]]; then
    echo "Installing dependencies..."

    readarray -t deps <<< `cat dependencies.txt`

    for pkg in ${deps[@]}; do
        install $pkg
    done
fi

## Symlinking
# Try
echo "Symlinking dotfiles..."
output=$(stow -t ~ . 2>&1)

# Ask whether override if unset
if [[ $output ]] && [[ -z $force ]]; then
    if gum confirm "Override existing dotfiles?" ${gum_confirm_style[@]}; then
        force=1
    else
        force=0
    fi
fi

# Override existing dotfiles (if --force'd)
if [[ $output ]] && [[ $force == 1 ]]; then
    echo "Conflicts found."

    echo "Removing existing dotfiles..."
    readarray -t lines <<< $output

    # Delete all conflicting dotfiles
    for ((i=1; i<${#lines[@]}-1; i++)); do
        file=$HOME/$(echo ${lines[i]} | awk "{print \$NF}")

        rm -f $file
    done

    echo "Symlinking dotfiles..."
    stow -t ~ .
fi

echo "DONE"
echo "Enjoy the dotfiles!"
