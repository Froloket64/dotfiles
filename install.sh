#!/bin/bash
# This is an installation/deployment script for Arch Linux

# All packages including deps (e.g. `stow` for symlinking the dots)
pkgs=(alacritty dunst fish ly neofetch neovim qtile rofi stow)

# Install a package
install () {
  # If --force specified, (re-)install without check
  case $@ in
    "-f" | "--force")
      sudo pacman -S $1 
      return
  esac

  # Check if the package is installed and install if not
  if pacman -Qe $1; then
    echo $1 already installed. Skipping.
  else
    sudo pacman -S $1 
  fi
}

# Install all packages
for pkg in ${pkgs[@]}; do
  install $pkg
done

# Additional installations
# Oh My Fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf theme integral-froloket

# Override conflicting dotfiles if --force is set
case $@ in 
  "-f" | "--force")
    found=1

    find . -name "*" | sed "s/^/~\//" | xargs rm
esac

# Otherwise, ask if this should be done
if ! [[ $found ]]; then
    read -p "Override existing dotfiles? [y/n] " answer

    # Make check case-insensitive
    shopt -s nocasematch
    if [[ answer =~ (y|yes) ]]; then
      find . -name "*" | sed "s/^/~\//" | xargs rm
    fi
fi

# Symlink everything
stow -t ~ .

# and delete the symlinked `install.sh` ;)
# P.S. Bad idea, but haven't come up with anything better
# rm ~/install.sh
