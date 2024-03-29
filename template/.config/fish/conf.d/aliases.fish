# Shell usage
set ls_exec ls

if command -vq exa
    set ls_exec "exa --icons"
else if command -vq lsd
    set ls_exec lsd
end

alias lst "$ls_exec --tree"
alias clt "clear; $ls_exec --tree"

{%- if features.lsSingleLine %}
# One file on each line
alias ls "$ls_exec -1"
{% else %}
alias ls "$ls_exec"
{%- endif %}

alias cl "clear; ls"
alias new "$TERM --working-directory=\$PWD -e fish & test"

if command -vq ptsh
    alias pwd ptpwd
    alias cp ptcp
end

# Daily routine
alias ec "emacsclient -nw"
alias lg "lazygit"

# Other
alias logout "pkill -KILL -u $USER"
alias myip "curl zx2c4.com/ip"
alias alarm "notify-send --icon /usr/share/icons/{{ themes.gtk.icon_theme }}/16x16/actions/dialog-error.svg 'Time is UP!'"
alias flatrun "flatpak run (flatpak list --columns=application | fzf --reverse --height=~10 | awk '{ print \$2 }')"
alias zel "zellij"
alias q "exit"
{%- if general.editor == "nvim" %}
alias vim "nvim"
alias nvs "nvim --listen /tmp/nvimsocket"
{%- endif %}
