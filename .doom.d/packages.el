;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
;;; Package manipulation ;;;

;; Lang modes
(package! emacs-fish)

(package! vlang-mode
  :recipe (:host github :repo "Naheel-Azawy/vlang-mode"))

;; Docs
(package! devdocs-browser)

;; Other
(package! visual-regexp-steroids)
