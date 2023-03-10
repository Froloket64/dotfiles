<h1 align="center">~/.dotfiles</h1>
<p align="right">-- powered by <a href="https://www.gnu.org/software/stow/">Stow</a></p>

## Previews
### QTile
![Some terminals](/preview/qtile/terminals.png)
![Coding](/preview/qtile/coding.png)

### Sway
![Some more terminals](/preview/sway/terminals.png)
![Web browser](/preview/sway/browser.png)

## Installation
### Dependencies
Normally, they should be taken care of by the installation script (see below), but it's a good idea to install them manually (or if the installation script fails to).
- `stow`
- `gum`
- `python`
- `jinja-cli` (from [PyPI](https://pypi.org/project/jinja-cli/))
- `dart-sass` (or other [Sass distribution](https://sass-lang.com/install)) [1](#notes)

### Supported distros
Currently supported distros[2](#notes):
+ Arch Linux _(and -based)_
+ Ubuntu _(and -based)_

To install the packages and deploy the dotfiles just do the following:

``` bash
git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
cd ~/.dotfiles
./install.sh # Run the installation script
```

Also, use `./install.sh --help` to see usage and options.

### Other distros
If you're not using one of the supported distros, the operations are the same, except for installation of the packages - you'll have to do that manually. Afterwards, the script can deploy all the dotfiles just fine (note the `-I` flag)

``` bash
git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
cd ~/.dotfiles
./install.sh -I # Deploy without installation
```

Contributions regarding other distro support are **welcome**.

## Notes
 1. (**NOTE**: If you install a different package, ensure that the `SASS_EXEC` variable in the `install.sh` script is set to its path or its name if it's in the [PATH](https://www.howtogeek.com/658904/how-to-add-a-directory-to-your-path-in-linux/))
 2. But note the package name changes for *N*-based (from above) distros which are not considered by the script.
