$env.config.show_banner = false

$env.config.buffer_editor = ["emacsclient", "-nw"]
$env.config.edit_mode = "vi"
$env.EDITOR = "emacsclient -nw"
let editor = { |file| emacsclient -nw $file }

# Prompt
$env.PROMPT_INDICATOR_VI_NORMAL = " ∫ "
$env.PROMPT_INDICATOR_VI_INSERT = " > "
$env.PROMPT_MULTILINE_INDICATOR = ".."

$env.TRANSIENT_PROMPT_COMMAND = "$"
$env.TRANSIENT_PROMPT_INDICATOR = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = " "

# fzf
$env.FZF_DEFAULT_COMMAND = "fd"

# Aliases
alias ec = emacsclient -nw
alias f = fzf --preview 'bat --theme=gruvbox-dark --style=numbers --color=always {}'
alias cf = cd (with-env {FZF_DEFAULT_COMMAND: "fd --type dir"} { (f) })
alias ef = do $editor (with-env {FZF_DEFAULT_COMMAND: "fd --type file"} { (f) })
alias lg = lazygit
alias preview = bat --theme gruvbox-dark

# Functions
def cmp_dots [lhs] {
    let dir = echo $lhs | path relative-to template/.config/

    diff $lhs ~/.config/($dir)
}
