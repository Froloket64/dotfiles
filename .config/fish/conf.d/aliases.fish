## Aliases
# --Commands-- ###
if command -v lsd >/dev/null
    alias ls="lsd"
    alias clt="clear; lsd --tree"
end

alias ll="ls -l"
alias cl="clear; ll"
alias myip="curl zx2c4.com/ip"
alias new="$TERM --working-directory=\$PWD -e fish & test"
alias logout="pkill -KILL -u $USER"

# --Scripts-- ###
alias alarm="notify-send --icon /usr/share/icons/Papirus/16x16/actions/dialog-error.svg 'Time is UP!'"

if command -v ptsh >/dev/null
    alias pwd=ptpwd
    alias cp=ptcp
end
