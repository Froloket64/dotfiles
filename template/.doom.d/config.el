;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; General configuration ;;;

;; Personal Info
(when (file-exists-p "private.el")
     (load! "private.el"))

;; Transparency
(defun transparency (value)
     "Sets the transparency of the frame window. Doesnt' work with some compositors."
     (interactive "nTransparency value [0..100]:")
     (set-frame-parameter (selected-frame) 'alpha value))

(transparency 100) ;; Unfortunately, this also makes the text transparent :(

;; Font
(setq doom-font (font-spec :family "{{ font.name }}" :size {{ font.size + 4 }} :weight 'normal)
     doom-variable-pitch-font (font-spec :family "{{ font.name }}" :size {{ font.size + 5 }})
     doom-serif-font (font-spec :family "scientifica" :size {{ font.size + 5 }}))

;; Theme
(setq doom-theme 'doom-{{ doomEmacsTheme }})

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Org files directory
(setq org-directory "~/org/")

;; File major mode associations
(add-to-list 'auto-mode-alist '("\\.v\\'" . vlang-mode))
