# Shortcut to recompile dotfiles
function recomp_dots
    cd .dotfiles
    ./install.sh -I
    cd -
end
