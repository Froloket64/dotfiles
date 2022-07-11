<h1 align="center">~/.dotfiles</h1>
<p align="right">-- powered by <a href="https://www.gnu.org/software/stow/">Stow</a></p>

Includes dofiles for:
+ [Alacritty](https://github.com/alacritty/alacritty)
+ [fish](https://fishshell.com/)
+ [ly](https://github.com/fairyglade/ly)
+ [jonaburg/picom](https://github.com/jonaburg/picom)
+ [QTile](https://github.com/qtile/qtile)
+ [NeoVim](https://github.com/neovim/neovim)

## Previews
![Some terminals](/preview/terminals.png)
![Coding](/preview/coding.png)

## Installation
### Arch Linux
As simple as that\*:
``` bash
git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
cd ~/.dotfiles
bash install.sh # Run the installation script
```
This will install all the packages and deploy the dotfiles.

### Other distros
If you're not using Arch, the operations are similar, except you need to replace the run of installation script with some manual work
``` bash
git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
cd ~/.dotfiles
stow -t ~ . # Symlink dotfiles using GNU Stow
```

If some of the dotfiles are already in your system, you will have to delete them. To do that, you might just run the above (specifically, the `stow` command) and look through the errors to figure out which files you have to delete.

Contributions regarding other distros install script support are **welcome**.
