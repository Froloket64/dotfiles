# Shortcut to recompile dotfiles
function recomp_dots
    cd ~/.dotfiles
    ./install.sh -I
    cd -
end

# Execute broot and command it returns
function br --wraps=broot
    set -l cmd_file (mktemp)
    if broot --outcmd $cmd_file $argv
        read --local --null cmd < $cmd_file
        rm -f $cmd_file
        eval $cmd
    else
        set -l code $status
        rm -f $cmd_file
        return $code
    end
end

# Clone a git repo to $HOME/git and cd into it
function gclone -a repo
    set -l dir_name $HOME/git/(echo $repo | rev | cut -d / -f 1 | rev | cut -d . -f 1)

    git clone $repo --depth 1 $dir_name
    cd $dir_name
end
