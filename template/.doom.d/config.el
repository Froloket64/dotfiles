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

(transparency 90)

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

;; (add-hook 'vlang-mode-hook
;;     (setq js-indent-align-list-continuation nil))
(add-to-list 'auto-mode-alist '("\\.v\\'" . vlang-mode))

;; (defun dashboard-insert-custom (list-size)
;;   (insert "Custom text"))

;; (add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom))
;; (add-to-list 'dashboard-items '(custom) t)

;; (setq fancy-splash-image (concat doom-user-dir "doom-emacs-gray.svg"))
