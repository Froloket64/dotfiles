#!/bin/bash
# This is an installation/deployment script for Arch Linux

# Some OS information
os_info=$(cat /etc/os-release)

# All packages including deps (e.g. `stow` for symlinking the dots)
pkgs=(alacritty dunst fish ly neofetch neovim qtile rofi stow)

# Install a package
install_cmd () {
    case $os_info in
        *[Uu]buntu*)
            sudo apt-get install $1
            ;;

        *[Aa]rch*)
            sudo pacman -S $1
            ;;

        *)
            echo Unknown distro
            exit
    esac
}

findpkg_cmd () {
    case $os_info in
        *[Uu]buntu*)
            sudo apt-get list --installed $1 | grep $1
            ;;

        *[Aa]rch*)
            sudo pacman -Q $1
            ;;

        *)
            echo Unknown distro
            exit
    esac
}

update_cmd () {
    case $os_info in
        *[Uu]buntu*)
            sudo apt-get update
            ;;

        *[Aa]rch*)
            sudo pacman -Sy
            ;;

        *)
            echo Unknown distro
            exit
    esac
}

install_pkg () {
    # If --force specified, (re-)install without check
    case $@ in
        "-f" | "--force")
            install_cmd $1
            return
    esac

  # Check if the package is installed and install if not
    if findpkg_cmd $1; then
        echo $1 already installed. Skipping.
    else
        install_cmd $1
    fi
}

# Additional installations
install_ext () {
    # Oh My Fish
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
}

for arg in $@
do
    case $arg in
        -f | --force)
            force=1
            ;;

        -i | --install)
            install=1
            ;;

        -*)
            echo ERROR: Unknown option: $arg
            ;;

        *)
            to_install += $arg
            ;;
    esac
done

# Install all packages
if [[ $install ]]; then
    echo Installing packages...

    update_cmd

    for pkg in ${pkgs[@]}; do
        install_pkg $pkg
    done

    install_ext
else
    read -p "Install packages? (Otherwise, just copying configs) [y/n] " answer

    # Make check case-insensitive
    shopt -s nocasematch
    if [[ answer =~ (y|yes) ]]; then
        echo Installing packages...

	update_cmd

        for pkg in ${pkgs[@]}; do
            install_pkg $pkg
        done

        install_ext
    fi
fi

# Ask if existing dotfiles should be overridden if unspecified
if [[ -z $force ]]; then
    read -p "Override existing dotfiles? [y/n] " answer

    # Make check case-insensitive
    shopt -s nocasematch
    if [[ answer =~ (y|yes) ]]; then
        force=1
    fi
fi

# Additional configuration
fish -c "omf theme integral-froloket" 2&>/dev/null

# Symlinking
# Try
output=$(stow -t ~ . 2>&1)

# Process exceptions about existing files (if --force)
if [[ $force ]]; then
    echo Removing existing dotfiles...
    readarray -t lines <<< $output

    # Delete every dotfile that was present
    for ((i=1; i<${#lines[@]}-1; i++))
    do
        # file=$(echo ${lines[i]} | awk "{print \$NF}" | sed "s/^/$HOME\//")
        file=$HOME/$(echo ${lines[i]} | awk "{print \$NF}")

        rm -f $file
    done

    stow -t ~ .
fi

echo DONE
echo Enjoy the dotfiles!
