# Shell usage
if command -vq lsd
    alias ls="lsd"
    alias clt="clear; lsd --tree"
end

alias ll="ls -l"
alias cl="clear; ll"
alias new="$TERM --working-directory=\$PWD -e fish & test"

if command -vq ptsh
    alias pwd=ptpwd
    alias cp=ptcp
end

# Other
alias logout="pkill -KILL -u $USER"
alias myip="curl zx2c4.com/ip"

if command -vq notify-send
    alias alarm="notify-send --icon /usr/share/icons/{{ gtk.iconTheme }}/16x16/actions/dialog-error.svg 'Time is UP!'"
end

if command -vq flatpak
   alias flatrun="flatpak run (flatpak list --columns=application | fzf --reverse --height=~10 | awk '{ print \$2 }')"
end
