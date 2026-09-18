;;; geist-test.el --- Tests for Geist theme -*- lexical-binding: t; -*-

(require 'ert)

(add-to-list 'load-path default-directory)
(add-to-list 'custom-theme-load-path default-directory)

(require 'geist)

(ert-deftest geist-test-palettes-non-empty ()
  "Ensure both palettes have valid hex colors for all defined keys."
  (dolist (palette (list geist-dark-palette geist-light-palette))
    (dolist (entry palette)
      (let ((key (car entry))
            (val (cdr entry)))
        (should (symbolp key))
        (should (stringp val))
        (should (string-match-p "^#[0-9a-fA-F]\\{6\\}$" val))))))

(ert-deftest geist-test-load-dark ()
  "Ensure geist-dark loads without errors and sets proper background."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'geist-dark t)
  (should (custom-theme-enabled-p 'geist-dark))
  (should (string-equal (face-attribute 'default :background) "#000000"))
  (should (string-equal (face-attribute 'default :foreground) "#ededed")))

(ert-deftest geist-test-load-light ()
  "Ensure geist-light loads without errors and sets proper background."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'geist-light t)
  (should (custom-theme-enabled-p 'geist-light))
  (should (string-equal (face-attribute 'default :background) "#ffffff"))
  (should (string-equal (face-attribute 'default :foreground) "#171717")))

(ert-deftest geist-test-toggle ()
  "Ensure geist-toggle alternates between dark and light."
  (mapc #'disable-theme custom-enabled-themes)
  (geist-load-dark)
  (should (custom-theme-enabled-p 'geist-dark))
  (geist-toggle)
  (should (custom-theme-enabled-p 'geist-light))
  (geist-toggle)
  (should (custom-theme-enabled-p 'geist-dark)))

(ert-deftest geist-test-essential-faces ()
  "Ensure core font-lock and UI faces are declared in the theme."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'geist-dark t)
  (let ((theme-face-specs (get 'geist-dark 'theme-settings))
        (essential-faces '(default
                           cursor
                           region
                           hl-line
                           fringe
                           mode-line
                           mode-line-inactive
                           line-number
                           line-number-current-line
                           font-lock-keyword-face
                           font-lock-function-name-face
                           font-lock-string-face
                           font-lock-comment-face
                           font-lock-type-face
                           font-lock-constant-face
                           vertico-current
                           corfu-current
                           magit-diff-added
                           magit-diff-removed
                           eshell-prompt)))
    (dolist (face essential-faces)
      (should (cl-some (lambda (setting)
                         (and (eq (nth 0 setting) 'theme-face)
                              (eq (nth 1 setting) face)))
                       theme-face-specs)))))

(ert-deftest geist-test-ansi-vector ()
  "Ensure ANSI color vector is well-formed."
  (let ((dark-vec (geist-ansi-color-vector 'dark))
        (light-vec (geist-ansi-color-vector 'light)))
    (should (= (length dark-vec) 8))
    (should (= (length light-vec) 8))
    (dotimes (i 8)
      (should (string-match-p "^#[0-9a-fA-F]\\{6\\}$" (aref dark-vec i)))
      (should (string-match-p "^#[0-9a-fA-F]\\{6\\}$" (aref light-vec i))))))

(ert-deftest geist-test-setup-fonts-defaults ()
  "Ensure geist-setup-fonts defaults to 12pt."
  (geist-setup-fonts)
  (when (member "Geist Mono" (font-family-list))
    (should (= (face-attribute 'default :height) 120))
    (should (= (face-attribute 'fixed-pitch :height) 120)))
  (when (member "Geist" (font-family-list))
    (should (= (face-attribute 'variable-pitch :height) 120))))

(provide 'geist-test)
;;; geist-test.el ends here
