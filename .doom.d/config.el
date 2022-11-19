;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; General configuration ;;;

;; Personal Info
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Font
(setq doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 14 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size 15)
      doom-serif-font (font-spec :family "scientifica" :size 15))

;; Theme
(setq doom-theme 'doom-gruvbox)

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Org files directory
(setq org-directory "~/org/")

;; (add-hook 'vlang-mode-hook
;;     (setq js-indent-align-list-continuation nil))
(add-to-list 'auto-mode-alist '("\\.v\\'" . vlang-mode))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
