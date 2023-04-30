#!/bin/bash
# This is an installation/deployment script for Arch Linux

# TODO:
# - Add more distros

SASS_EXEC=sass

# All packages including deps (e.g. `stow` for symlinking the dots)
PKGS=(alacritty dunst fish neovim qtile rofi hyprland polybar sway waybar wezterm)

GUM_CHOOSE_STYLE=(--cursor.foreground="11" --selected.background="236" --selected.foreground="3")
GUM_CONFIRM_STYLE=(--selected.background="2" --selected.foreground="0" --unselected.background="")

# Return whether command exists
command_exists() {
    local cmd=$1

    if command -v $cmd 2&>/dev/null; then
        true
    else
        false
    fi
}

# Log a message
log() {
    if ! [[ $quiet -eq 1 ]]; then
        echo $@
    fi
}

copy_perms() { chmod --reference=$1 $2; }

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
            quiet=1
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

if [[ $install == 1 ]]; then
    # Install base dependencies
    if ! command_exists sudo; then
        log "sudo not found. Aborting."
        exit 1
    fi

    if ! command_exists yay; then
        install_dir=$(mktemp -d)

        log -n "yay not found, installing... "

        sudo pacman -S --needed git base-devel

        git clone https://aur.archlinux.org/yay.git --depth 1 $install_dir

        cd $install_dir
        makepkg -si
        cd - >/dev/null
        rm -rf $install_dir

        log "done"
    fi

    yay -S --needed stow gum python python-j2cli dart-sass

    # Install packages
    log "Installing packages"

    yay -Sy

    yay -S --needed ${to_install[@]}

    # Oh My Fish
    # curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish -c exit
    fish_install_script=$(mktemp)

    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o $fish_install_script
    fish -c ". $fish_install_script; exit"

    # Install optional dependencies
    log "Installing optional dependencies"

    readarray -t deps <<< `cat dependencies.txt`

## Template processing
if ! [[ $quiet -eq 1 ]]; then
    echo "Generating dotfiles..."
    yay -S --needed ${deps[@]}
fi

# Compile to home/
rm -rf home/ # Clean up all previous results ("cache")

sass_files=()

for file in $(find template/ -type f); do
    dest_dir=$(echo $file | sed -e "s/template/home/" | xargs -0 dirname)
    filename=$(basename $file)

    if ! [[ $quiet -eq 1 ]]; then
        echo -n "$file... "
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

    if ! [[ $quiet -eq 1 ]]; then
        echo done
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
    echo "Done"
    echo "Enjoy the dotfiles!"
fi
