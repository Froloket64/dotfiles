;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; ▓█████▄  ▒█████   ▒█████   ███▄ ▄███▓  ███████╗███╗   ███╗ █████╗  ██████╗███████╗
;; ▒██▀ ██▌▒██▒  ██▒▒██▒  ██▒▓██▒▀█▀ ██▒  ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝
;; ░██   █▌▒██░  ██▒▒██░  ██▒▓██    ▓██░  █████╗  ██╔████╔██║███████║██║     ███████╗
;; ░▓█▄   ▌▒██   ██░▒██   ██░▒██    ▒██   ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║
;; ░▒████▓ ░ ████▓▒░░ ████▓▒░▒██▒   ░██▒  ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║
;;  ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░▒░▒░ ░ ▒░   ░  ░  ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝
;;  ░ ▒  ▒   ░ ▒ ▒░   ░ ▒ ▒░ ░  ░      ░
;;  ░ ░  ░ ░ ░ ░ ▒  ░ ░ ░ ▒  ░      ░
;;    ░        ░ ░      ░ ░         ░
;;  ░
;;
;; | Frolov
;; | Konstantin

;; Place your private configuration here! Remember, you do NOT need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Froloket"
      user-mail-address "ket.frol2006@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol and press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Enabling across-X clipboard (for copying)
(setq select-enable-clipboard t)


;; Enabling copying and pasting via common keybinds (C-c, C-v) (and probably other things?..)
(cua-mode t)


;; Setting theme
;; You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'doom-monokai-classic) ; Themes (doom-): "miramare", "gruvbox"


;; Setting font(-s)
(setq doom-font (font-spec :family "JetBrainsMono NF" :size 15 :weight 'regular) ; Families: "mononoki NF"
      doom-variable-pitch-font (font-spec :family "sans" :size 12))

;; Tab width
(setq tab-width 4)

;; If you wish to load another (config, or any other) file (called "private.el" here)
;; (load! "private")
