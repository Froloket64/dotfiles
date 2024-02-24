![dotfiles](https://socialify.git.ci/Froloket64/dotfiles/image?font=KoHo&logo=https%3A%2F%2Fsvgshare.com%2Fi%2Fr1Q.svg&name=1&owner=1&pattern=Plus&theme=Dark)
<p align="right">— powered by <a href="https://www.gnu.org/software/stow/">Stow</a></p>

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
- [`dottery`](https://github.com/Froloket64/dottery)

### Supported distros
Currently supported distros[<sup>1</sup>](#notes):
 - Arch Linux _(and -based)_

To install the packages and deploy the dotfiles you will need `dottery`.
Once it's installed, just do the following:

``` bash
$ git clone https://github.com/Froloket64/dotfiles --depth 1 ~/.dotfiles # Clone the repo
$ dot install
$ dot deploy
```

Contributions regarding other distro support are **welcome**.

## Metaconfiguration
Yes, there's configuration for your configs. It consists of a [`..toml`](/..toml) file that contains all "settings" to the configuration such as your theme, your monitors, wallpaper and so on. All of that is compiled into plain config files using [`minininja`](https://crates.io/crates/minijinja) and copied by `dottery`.

### Features
In [`..toml`](/..toml) there's also a section labeled `features`. It provides a way to enable/disable certain additional features that are opinionated/require additional dependencies. To toggle features on and off just set their values to `true` or `false` respectively.

``` diff
  [features]
- swayfx = false
+ swayfs = true
```

Available features are:
 - `swayfx` - Enables features unique to [Swayfx](https://github.com/WillPower3309/swayfx), a fork of Sway
 - `swayFade` - Enables fade in/out for windows in Sway (uses [these scripts](https://github.com/Froloket64/swayscripts/tree/main/fade) as a git submodule) **WIP**
 - `lsSingleLine` - Makes `ls` ouput each file on a separate line (without `ls -l` info)
 - `starship` - Use Starship prompt in all shells

## Notes
1. But note the package name changes for *N*-based (from above) distros which are not considered by the script.
