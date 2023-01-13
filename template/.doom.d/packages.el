;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
;;; Package manipulation ;;;

;; Lang modes
(package! emacs-fish)

(package! vlang-mode
  :recipe (:host github :repo "Naheel-Azawy/vlang-mode"))

(package! nxhtml-mode
  :recipe (:host github :repo "dparnell/nxhtml"))

;; Lang-related
(package! markdown-preview-eww)
;; (package! markdown-preview-eww
;;   :recipe (:host github :repo "niku/markdown-preview-eww"))

;; Docs
(package! devdocs-browser)

;; Other
(package! visual-regexp-steroids)
