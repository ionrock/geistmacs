;;; geist-light-theme.el --- Vercel Geist light theme for Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Eric Larson
;; Author: Eric Larson
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (geist "0.1.0"))
;; Keywords: faces, themes, vercel, geist, light
;; URL: https://github.com/elarson/geistmacs

;;; Commentary:
;;
;; `geist-light' is a crisp, modern light theme inspired by Vercel's
;; pure white (#ffffff) design system, subtle elevation surfaces,
;; deep charcoal text, and balanced contrast.
;;
;; Usage:
;;   (load-theme 'geist-light t)
;;

;;; Code:

(eval-and-compile
  (let ((dir (file-name-directory (or load-file-name buffer-file-name (locate-library "geist-light-theme.el") ""))))
    (when (and dir (file-directory-p dir))
      (add-to-list 'load-path dir))))

(require 'geist)

(deftheme geist-light
  "Minimalist crisp light theme inspired by Vercel Geist.")

(apply #'custom-theme-set-faces 'geist-light (geist-theme-faces 'light))

(custom-theme-set-variables
 'geist-light
 `(ansi-color-names-vector ,(geist-ansi-color-vector 'light)))

(provide-theme 'geist-light)

;;; geist-light-theme.el ends here
