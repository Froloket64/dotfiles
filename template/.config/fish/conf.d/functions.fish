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
        scp "$source" "ssh-server@192.168.0.10:ssh-dump/$target"
    end
end
