# Shortcut to recompile dotfiles
function recomp_dots
    cd ~/.dotfiles
    ./install.sh -I -G $argv
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
    set -l dir_name $HOME/git/(echo $repo | rev | cut -d / -f 1 | cut -d . -f 2- | rev )

    git clone $repo --depth 1 $dir_name
    cd $dir_name
end

# TODO: To be generalized (?); Add scp flags/options
# Put a file on an MY local ssh server
function sput -w scp -a source target opts
    if test -n "$opts"
        scp $opts "$source" "ssh-server@192.168.0.10:ssh-dump/$target"
    else
        scp "$source" "ssh-server@192.168.0.10:ssh-dump/$target"
    end
end

# Get a file from MY local ssh server
function sget -w scp -a source target opts
    if test -n "$opts"
        scp $opts "ssh-server@192.168.0.10:ssh-dump/$source" "$target"
    else
        scp "ssh-server@192.168.0.10:ssh-dump/$source" "$target"
    end
end

# Pop the current dir off the stack (see `pushd` and `popd`)
function popd_func
    popd
    commandline -f repaint
end

# Push the current dir on the stack
function pushd_func
    pushd .
    commandline -f repaint
end

# Cycle to the next dir on the stack
function pushd_next
    pushd +1 >/dev/null
    commandline -f repaint
end

# Swap the top two dirs on the stack
function pushd_swap
    pushd >/dev/null
    commandline -f repaint
end

function ranger -w ranger -a dir
    set -l ranger_cmd (which ranger)
    $ranger_cmd $dir --choosedir=$HOME/.rangerdir

    set LASTDIR (cat $HOME/.rangerdir)
    cd "$LASTDIR"
end

function waysudo -w sudo -a cmd
    xhost si:localuser:root

    sudo env HOME=$HOME $cmd

    xhost -si:localuser:root
end
