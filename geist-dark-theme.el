;;; geist-dark-theme.el --- Vercel Geist dark theme for Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Eric Larson
;; Author: Eric Larson
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (geist "0.1.0"))
;; Keywords: faces, themes, vercel, geist, dark
;; URL: https://github.com/elarson/geistmacs

;;; Commentary:
;;
;; `geist-dark' is an ultra-minimal, high-contrast dark theme inspired by
;; Vercel's signature pitch-black (#000000) design system, sharp hairline
;; borders, and electric accent colors.
;;
;; Usage:
;;   (load-theme 'geist-dark t)
;;

;;; Code:

(eval-and-compile
  (let ((dir (file-name-directory (or load-file-name buffer-file-name (locate-library "geist-dark-theme.el") ""))))
    (when (and dir (file-directory-p dir))
      (add-to-list 'load-path dir))))

(require 'geist)

(deftheme geist-dark
  "Minimalist pitch-black dark theme inspired by Vercel Geist.")

(apply #'custom-theme-set-faces 'geist-dark (geist-theme-faces 'dark))

(custom-theme-set-variables
 'geist-dark
 `(ansi-color-names-vector ,(geist-ansi-color-vector 'dark)))

(provide-theme 'geist-dark)

;;; geist-dark-theme.el ends here
