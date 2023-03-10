# Shell usage
set ls_exec ls

if command -vq lsd
    set ls_exec lsd

    alias clt="clear; lsd --tree"
end

alias cl="clear; ls"
alias new="$TERM --working-directory=\$PWD -e fish & test"

if command -vq ptsh
    alias pwd=ptpwd
    alias cp=ptcp
end

# Daily routine
alias ec="emacsclient -nw"
alias lg="lazygit"

# Other
alias logout="pkill -KILL -u $USER"
alias myip="curl zx2c4.com/ip"
alias alarm="notify-send --icon /usr/share/icons/{{ gtk.iconTheme }}/16x16/actions/dialog-error.svg 'Time is UP!'"
alias flatrun="flatpak run (flatpak list --columns=application | fzf --reverse --height=~10 | awk '{ print \$2 }')"
