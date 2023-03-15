#!/bin/bash
# This is an installation/deployment script for Arch Linux

# TODO:
# - Add more distros

# Some OS information
SASS_EXEC=sass
OS_NAME=$(cat /etc/os-release)

# All packages including deps (e.g. `stow` for symlinking the dots)
PKGS=(alacritty dunst fish neovim qtile rofi hyprland polybar sway waybar wezterm)

GUM_CHOOSE_STYLE=(--cursor.foreground="11" --selected.background="236" --selected.foreground="3")
GUM_CONFIRM_STYLE=(--selected.background="2" --selected.foreground="0" --unselected.background="")

## Definitions
# Install a package
# IDEA: Check for OS by checking installed pkg manager
install () {
    case $OS_NAME in
        *ubuntu*)
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
    case $OS_NAME in
        *ubuntu*)
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
            echo "Available dotfiles: ${PKGS[@]}"

            exit
            ;;

        -q | --quiet)
            quiet=1 # FIXME: Make it useful
            ;;

        -o=* | --os=*)
            # Strip off all --os='s
            OS_NAME=${arg#"--os="}; OS_NAME=${OS_NAME#"-o="}
            ;;

        -*)
            echo "ERROR: Unknown option: $arg"

            exit
            ;;

        *)
            if [[ " ${PKGS[*]} " == *" $arg "* ]]; then
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
    if gum confirm "Install packages? (Otherwise, just copy configs)" ${GUM_CONFIRM_STYLE[@]}; then
        install=1
    else
        install=0
    fi
fi

# If packages should be installed, but none were specified, ask
if [[ $install -eq 1 ]] && ! [[ $to_install ]]; then
    echo "Which packages to install?"
    echo "Space to select, Enter to confirm, Ctrl-C to select all"

    to_install=$(gum choose ${PKGS[@]} --no-limit ${GUM_CHOOSE_STYLE[@]})

    # If still none, select all
    if ! [[ $to_install ]]; then
        to_install=${PKGS[@]}
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

# Compile to home/
rm -rf home/ # Clean up all previous results ("cache")

copy_perms() { chmod --reference=$1 $2; }
sass_files=()

for file in $(find template/ -type f); do
    dest_dir=$(echo $file | sed -e "s/template/home/" | xargs -0 dirname)
    filename=$(basename $file)

    if ! [[ $quiet -eq 1 ]]; then
        echo $file
    fi

    mkdir -p $dest_dir

    if file $file | grep text >/dev/null; then
        filename_base=${filename%.*}
        filename_ext=${filename#$filename_base.}

        (jinja -d settings.json $file -o $dest_dir/$filename &&
             copy_perms $file $dest_dir/$filename) &

        # Compile Sass to CSS
        case $filename_ext in
            sass | scss)
                # TODO: Move the compilation here
                sass_files+=($dest_dir/$filename)
                ;;
        esac
    else
        (cp $file $dest_dir/$filename &&
            copy_perms $file $dest_dir/$filename) &
    fi
done

wait

for file in $sass_files; do
    file_base=${file%.*}

    $SASS_EXEC --no-source-map $file $file_base.css
done

## Symlinking
# Try
if ! [[ $quiet -eq 1 ]]; then
    echo "Symlinking dotfiles..."
fi

output=$(stow -t ~ home/ 2>&1)

# Ask whether override if unset
if [[ $output ]] && [[ -z $force ]]; then
    if gum confirm "Override existing dotfiles?" ${GUM_CONFIRM_STYLE[@]}; then
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

# Outro
if ! [[ $quiet -eq 1 ]]; then
    echo "DONE"
    echo "Enjoy the dotfiles!"
fi
