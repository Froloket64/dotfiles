;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; General configuration ;;;

;; Personal Info
(when (file-exists-p "private.el")
      (load! "private.el"))

;; Font
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'normal)
     doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
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
