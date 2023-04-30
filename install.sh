#!/bin/bash
# This is an installation/deployment script for Arch Linux

# TODO:
# - Add more distros


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

    yay -S --needed ${deps[@]}
fi

# Template processing
log "Generating dotfiles"

dest_dir=$(mktemp -d)

for file in $(find template/ -type f); do
    file_stripped=$(echo "$file" | cut -d / -f 2-)
    dest_file="$dest_dir/$file_stripped"

    file_basename=$(basename "$file")

    file_ext=$(echo $file_basename | rev | cut -d . -f 1 | rev)
    file_no_ext=$(echo $file_basename | rev | cut -d . -f 2- | rev)

    log -n "$file_stripped... "

    mkdir -p $(dirname $dest_file)

    # Detect if a file is text or binary
    if file "$file" | grep text >/dev/null; then
        (j2 "$file" settings.json -o "$dest_file" &&
             copy_perms "$file" "$dest_file") &

        # Compile Sass/SCSS to CSS
        if [[ "$file_ext" =~ s[a|c]ss ]]; then
            wait

            sass --no-source-map $dest_file $(dirname $dest_file)/"$file_no_ext".css
            rm $dest_file
        fi
    else
        (cp $file $dest_file &&
            copy_perms $file $dest_file) &
    fi

    log "done"
done

wait

# Symlinking
log "Copying dotfiles"

for file in $(find $dest_dir -mindepth 1 -maxdepth 1); do
    cp -r $file $HOME
done

# Additional configuration
# Oh My Fish
if [[ $install == 1 ]] && [[ " ${to_install[*]} " == *" fish "* ]]; then
    fish -c "omf theme integral-froloket" 2&>/dev/null
fi

# Outro
log "Done"
