## Aliases
# --Commands-- ###
alias ls="lsd"  # ;)
alias ll="lsd -l"
alias cl="clear; ll"
alias clt="clear; lsd --tree"
alias myip="curl zx2c4.com/ip"
alias new="$TERM --working-directory=\$PWD -e fish & test"
alias logout="pkill -KILL -u $USER"

# --Scripts-- ###
alias alarm="notify-send --icon /usr/share/icons/Papirus/16x16/actions/dialog-error.svg 'Time is UP!'"
alias pwd=ptpwd
alias cp=ptcp
