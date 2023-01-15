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
- `dart-sass` (or other [Sass distribution](https://sass-lang.com/install))

### Supported distros\*

As simple as that\*:

``` bash
git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
cd ~/.dotfiles
./install.sh # Run the installation script
```

This will install all the packages and deploy the dotfiles.

\* Currently supported distros:

+ Arch Linux _(and -based)_
+ Ubuntu _(and -based)_

But note the repository changes (e.g. in some Ubuntu-based distros some package names can vary, or even be absent).

### Other distros

If you're not using one of the supported distros, the operations are the same, except for installation of the packages, you'll have to do that manually. Afterwards, the script can deploy all the dotfiles just fine (note the `-I` flag)

``` bash
git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
cd ~/.dotfiles
./install.sh -I # Deploy without installation
```

Contributions regarding other distro support are **welcome**.
