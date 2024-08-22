;; Visual
(load-theme 'gruvbox-dark-hard t)

(with-eval-after-load "gruvbox-dark-hard"
  (custom-theme-set-faces
   'gruvbox-dark-hard
   '(lsp-face-semhl-method ((t (:foreground "#ebdbb2" :inherit nil))))))

(setq inhibit-splash-screen t)
(setq show-paren-delay 0) ; NOTE: Should this be `-default` ?

(menu-bar-mode -1)
(tool-bar-mode -1)
(line-number-mode -1)

; Font
(set-face-attribute 'default nil :height 225)
(set-face-attribute 'mode-line nil :height 150)
(set-face-attribute 'mode-line-inactive nil :height 150)
(set-frame-font "NeoDunggeunmo Code 24" nil t)

;; Key binds
(defmacro cmd (exp)
  "Inline `exp` as a command expression"
  `(lambda () (interactive) ,exp))

;; (define-key global-map (kbd "C-x B p") 'previous-buffer)
;; (define-key global-map (kbd "C-x B n") 'next-buffer)

;; Editing
(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)

;; Packages
(require 'package)

; Setup MELPA
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(use-package lsp-mode
  :ensure
  ;; :commands lsp
  :custom
  ;; (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay 0.1)
  (lsp-inlay-hint-enable nil)
  (lsp-semantic-tokens-enable t)

  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-chaining-hints nil)
  (lsp-rust-analyzer-display-closure-return-type-hints nil)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-call-info-full nil)
  (lsp-rust-analyzer-closing-brace-hints nil)
  (lsp-rust-analyzer-server-format-inlay-hints t)
  (lsp-rust-analyzer-display-reborrow-hints nil)

  :config
  (add-hook 'hack-local-variables-hook
            (lambda () (when (derived-mode-p 'rustic-mode) (lsp)))))

(use-package rustic
  :ensure
  :after (lsp-mode)
  :custom
  (rustic-format-on-save t))
  ;; (lsp-eldoc-hook nil)
  ;; (lsp-enable-symbol-highlighting nil)
  ;; (lsp-signature-auto-activate nil)

(use-package evil
  :ensure
  :custom
  ;; (evil-insert-state-cursor 'box)
  (evil-default-state 'normal)

  :config
  (evil-set-initial-state 'magit-mode 'emacs)
  (evil-set-initial-state 'Custom-mode 'normal)
  (evil-set-undo-system 'undo-redo)

  ;; FIXME: Doesn't work as a `:custom' option
  (setq evil-insert-state-cursor 'box)

  ;; More (evil) key maps
  (evil-set-leader 'normal (kbd "SPC"))

  ;; Undefine now-prefix keys
  (define-key evil-motion-state-map (kbd "C-f") nil)
  (define-key evil-motion-state-map (kbd "C-b") nil)
  (define-key global-map (kbd "C-b") nil)
  (evil-define-key 'emacs global-map (kbd "C-b") 'backward-char)

  ;; (evil-define-key 'normal global-map (kbd "<leader> w v") 'split-root-window-right)
  (evil-define-key 'normal global-map
    ;; (kbd "<leader> h a") 'apropos-command
    ;; (kbd "<leader> h k") 'describe-key
    (kbd "g c c") 'comment-line
    ;; TODO: Implement gcj, gck
    ;; (kbd "g c j") (cmd (progn (evil-visual-line) (evil-next-visual-line) (comment-or-uncomment-region (region-beginning) (region-end))))

    (kbd "C-f i") (cmd (find-file "~/.emacs.d/init.el"))
    (kbd "C-f f") 'find-file
    (kbd "C-f d") 'dired-jump
    (kbd "C-f D") 'dired-jump-other-window

    (kbd "C-w C") 'delete-other-windows

    (kbd "C-b k") 'kill-current-buffer
    (kbd "C-b K") 'kill-buffer-and-window
    (kbd "C-b b") 'switch-to-buffer
    (kbd "C-b B") 'list-buffers
    (kbd "C-b C-b") 'evil-switch-to-windows-last-buffer

    (kbd "C-c C-g") 'magit)

  (evil-define-key 'visual global-map (kbd "g c") 'comment-or-uncomment-region)

  (evil-mode 1))

;; TODO: Add/allow special handling for <ESC> and such
(defun my-escape-insert (fst snd)
  "Escape from the Evil insert mode using a
quick consecutive press of `fst` + `snd`"
  (interactive)

  (insert fst)
  (let
      ((start-time (float-time))
       (key (read-key)))
    (if (and (eq key snd)
	     (<= (- (float-time) start-time) 0.2))
	(progn (backward-delete-char 1)
	       (evil-normal-state))
      (insert key))))

(evil-define-key 'insert global-map (kbd "j")
  (cmd (my-escape-insert ?j ?k)))

;; Zettelkasten mode
(defun gen-name ()
  "Generate a random 4-letter name"
  (let (name)
    (dotimes (_ 4)
      (let ((char (+ (random 26) 97)))
        (setq name (cons char name))))
    (concat name ".md")))

(defun zk-create-note ()
  "Create a new note"
  (interactive)

  (let ((name (gen-name)))
    (find-file name)))

(defun zk-search-notes (pattern)
  "Search all notes for PATTERN"
  (interactive "sSearch for: ")

  (rg pattern "*" default-directory))

(define-minor-mode zk-mode
  "Zettelkasten mode"
  ;; :after-hook markdown-mode-hook
  :keymap (define-keymap
            "C-c C-z n" #'zk-create-note
            "C-c C-z s" #'zk-search-notes))

(add-hook 'markdown-mode-hook 'zk-mode)

;; Misc
(recentf-mode 1)
;; (setq)

;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("19a2c0b92a6aa1580f1be2deb7b8a8e3a4857b6c6ccf522d00547878837267e7" "d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7" "72ed8b6bffe0bfa8d097810649fd57d2b598deef47c992920aef8b5d9599eefe" default))
 '(package-selected-packages
   '(company rg gh-md markdown-preview-eww markdown-soma mkdown flymd markdown-preview-mode lsp-mode key-chord evil-escape gruvbox-theme evil magit rust-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
