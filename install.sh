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
    -q, --quiet       Don't display anything (except for errors)
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

        -q | --quiet)
            quiet=1 # FIXME: Make it useful
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

# Ask to install if unset
if [[ -z $install ]]; then
    if gum confirm "Install packages? (Otherwise, just copy configs)" ${gum_confirm_style[@]}; then
        install=1
    else
        install=0
    fi
fi

# If packages should be installed, but none were specified, ask
if [[ $install -eq 1 ]] && ! [[ $to_install ]]; then
    echo "Which packages to install?"
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
    if ! [[ $quiet -eq 1 ]]; then
        echo "stow not found, installing... "
    fi

    install stow || exit
fi

# gum
if ! command -v gum 2&>/dev/null; then
    if ! [[ $quiet -eq 1 ]]; then
        echo "gum not found, installing... "
    fi

    install gum || exit
fi

# python
if ! command -v python 2&>/dev/null; then
    if ! [[ $quiet -eq 1 ]]; then
        echo "python not found, installing... "
    fi

    install python || exit
fi

# jinja
if ! command -v jinja 2&>/dev/null; then
    if ! [[ $quiet -eq 1 ]]; then
        echo "jinja not found, installing... "
    fi

    python -m pip install jinja-cli || exit
fi

# sass
if ! command -v sass 2&>/dev/null; then
    if ! [[ $quiet -eq 1 ]]; then
        echo "sass not found, installing..."
    fi

    install dart-sass || exit
fi

## Installing packages
# Install
if [[ $install == 1 ]]; then
    if ! [[ $quiet -eq 1 ]]; then
        echo "Installing packages..."
    fi

    update

    install ${to_install[@]}
    install_ext
fi

## Dependency installation
if [[ $install == 1 ]]; then
    if ! [[ $quiet -eq 1 ]]; then
        echo "Installing dependencies..."
    fi

    readarray -t deps <<< `cat dependencies.txt`

    install ${deps[@]}
fi

## Template processing
if ! [[ $quiet -eq 1 ]]; then
    echo "Generating dotfiles..."
fi

for file in $(find template/ -exec file {} \; | grep text | cut -d: -f1); do
    dest_path=$(echo $file | sed -e "s/template/home/")
    dest_dir=$(dirname $dest_path)

    if ! [[ $quiet -eq 1 ]]; then
        echo $file
    fi

    mkdir -p $dest_dir
    jinja -d settings.json $file -o $dest_path &

    chmod --reference=$file $dest_path
done

wait

## Symlinking
# Try
if ! [[ $quiet -eq 1 ]]; then
    echo "Symlinking dotfiles..."
fi

output=$(stow -t ~ home/ 2>&1)

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
    if ! [[ $quiet -eq 1 ]]; then
        echo "Conflicts found."
        echo "Removing existing dotfiles..."
    fi

    readarray -t lines <<< $output

    # Delete all conflicting dotfiles
    for ((i=1; i<${#lines[@]}-1; i++)); do
        file=$HOME/$(echo ${lines[i]} | awk "{print \$NF}")

        rm -f $file
    done

    if ! [[ $quiet -eq 1 ]]; then
        echo "Symlinking dotfiles..."
    fi

    stow -t ~ home/
fi

## Additional configuration
# Oh My Fish
if [[ " ${to_install[*]} " == *" fish "* ]]; then
    fish -c "omf theme integral-froloket" 2&>/dev/null
fi

# Compile Sass to CSS
sass --no-source-map home/.config/waybar/style.sass home/.config/waybar/style.css

# Outro
if ! [[ $quiet -eq 1 ]]; then
    echo "DONE"
    echo "Enjoy the dotfiles!"
fi
