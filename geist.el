;;; geist.el --- Minimalist Vercel Geist theme for Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Eric Larson
;; Author: Eric Larson
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: faces, themes, vercel, geist
;; URL: https://github.com/elarson/geistmacs

;;; Commentary:
;;
;; Geist is a minimalist, ultra-clean theme family for GNU Emacs inspired by
;; Vercel's iconic Geist design system and typography.
;;
;; Features:
;; - `geist-dark`: Pitch-black OLED background (#000000), hairline dividers,
;;   signature electric accents (Vercel blue, hot pink, cyan, amber).
;; - `geist-light`: Crisp pure white background (#ffffff), subtle light-gray
;;   surfaces, rich charcoal text, and balanced contrast.
;; - Seamless support for Geist and Geist Mono fonts.
;; - Tailored face specifications for standard font-lock, tree-sitter,
;;   completion UIs (Vertico, Corfu, Marginalia, Consult, Orderless),
;;   terminals (Eshell, Vterm, Term, ANSI colors), Magit, Dired, Org,
;;   Markdown, and LSP/Diagnostics.
;;
;; Usage:
;;   (load-theme 'geist-dark t)
;;   ;; or
;;   (load-theme 'geist-light t)
;;
;; To toggle between light and dark:
;;   M-x geist-toggle
;;

;;; Code:

(defgroup geist nil
  "Vercel Geist theme options."
  :group 'faces
  :prefix "geist-")

(defcustom geist-bold-constructs t
  "When non-nil, bold keywords, functions, and headings."
  :type 'boolean
  :group 'geist)

(defcustom geist-italic-comments t
  "When non-nil, italicize comments and documentation."
  :type 'boolean
  :group 'geist)

(defcustom geist-use-variable-pitch nil
  "When non-nil, use variable-pitch (Geist) for headings and modeline."
  :type 'boolean
  :group 'geist)

(defcustom geist-distinct-modeline t
  "When non-nil, draw a subtle border and distinctive background on the mode-line."
  :type 'boolean
  :group 'geist)

(defcustom geist-cursor-color 'blue
  "Cursor color style.
Choices are `blue' (Vercel blue), `white' (pure white), or `fg' (match foreground)."
  :type '(choice (const :tag "Vercel Blue (#0070f3)" blue)
                 (const :tag "Pure White" white)
                 (const :tag "Match Foreground" fg))
  :group 'geist)

;;; Color Palettes

(defconst geist-dark-palette
  '((bg-main            . "#000000") ; True pitch black (Vercel hallmark)
    (bg-alt             . "#0a0a0a") ; Subtle elevated surface
    (bg-surface         . "#111111") ; Cards, completion popups
    (bg-surface-active  . "#1c1c1c") ; Hover, active selection
    (bg-modeline        . "#0c0c0c") ; Active modeline
    (bg-modeline-dim    . "#040404") ; Inactive modeline
    (bg-highlight       . "#121212") ; hl-line / current line
    (bg-region          . "#222222") ; Visual selection
    (bg-region-subtle   . "#181818") ; Secondary highlight

    (border-subtle      . "#1c1c1c") ; Hairline divider
    (border-main        . "#2a2a2a") ; Standard border
    (border-focus       . "#444444") ; Active frame/divider

    (fg-main            . "#ededed") ; Signature Vercel high-contrast white
    (fg-alt             . "#a1a1a1") ; Secondary text / parameters
    (fg-dim             . "#737373") ; Line numbers / subtle metadata
    (fg-muted           . "#4d4d4d") ; Disabled / faint text
    (fg-ghost           . "#2e2e2e") ; Subtle separators

    ;; Vercel Geist Accents
    (blue               . "#0070f3") ; Core Vercel brand blue
    (blue-bright        . "#3291ff") ; Electric function/symbol blue
    (blue-dim           . "#004bb5") ; Subtle blue tint
    (blue-bg            . "#091a2f") ; Very faint blue background tint

    (pink               . "#ff0080") ; Vercel hot pink (keywords)
    (pink-bright        . "#f81ce5") ; Neon magenta
    (pink-dim           . "#9e0050") ; Muted pink

    (purple             . "#8a63d2") ; AI / Types / Primitives
    (purple-bright      . "#bf7af0") ; Light violet
    (purple-dim         . "#53258f")

    (cyan               . "#50e3c2") ; Mint / Cyan (strings / regex)
    (cyan-bright        . "#79ffe1") ; Bright neon cyan
    (cyan-dim           . "#1a705e")

    (green              . "#00df89") ; Emerald success
    (green-bright       . "#45d483") ; Bright green
    (green-dim          . "#006840") ; Dark green
    (green-bg           . "#042416") ; Diff added background

    (orange             . "#ff8024") ; Amber / Numbers / Constants
    (orange-bright      . "#ffa463") ; Bright orange
    (orange-dim         . "#964506")

    (red                . "#ff4444") ; Error / Deletions
    (red-bright         . "#ff6b6b") ; Bright red
    (red-dim            . "#8c1414") ; Muted red
    (red-bg             . "#2d0808") ; Diff removed background

    (yellow             . "#f5e158") ; Warning / Attention
    (yellow-dim         . "#85781a")
    (yellow-bg          . "#262104") ; Diff context/warning bg
    )
  "Vercel Geist Dark Color Palette.")

(defconst geist-light-palette
  '((bg-main            . "#ffffff") ; Crisp paper white
    (bg-alt             . "#fafafa") ; Subtle gray elevation (surface-1)
    (bg-surface         . "#f5f5f5") ; Cards, popups (surface-2)
    (bg-surface-active  . "#eaeaea") ; Active selection / hover
    (bg-modeline        . "#f7f7f7") ; Active modeline
    (bg-modeline-dim    . "#fafafa") ; Inactive modeline
    (bg-highlight       . "#f8f8f8") ; hl-line / current line
    (bg-region          . "#e5e5e5") ; Visual selection
    (bg-region-subtle   . "#f0f0f0") ; Secondary highlight

    (border-subtle      . "#f0f0f0") ; Hairline divider
    (border-main        . "#eaeaea") ; Standard border
    (border-focus       . "#d4d4d4") ; Active frame/divider

    (fg-main            . "#171717") ; Rich deep charcoal / near black
    (fg-alt             . "#525252") ; Secondary text / parameters
    (fg-dim             . "#888888") ; Line numbers / comments
    (fg-muted           . "#b3b3b3") ; Disabled / faint text
    (fg-ghost           . "#e5e5e5") ; Subtle separators

    ;; Vercel Geist Accents (Light)
    (blue               . "#0068d6") ; Core Vercel brand blue
    (blue-bright        . "#0070f3") ; Electric blue
    (blue-dim           . "#00438a")
    (blue-bg            . "#edf5ff") ; Faint blue background tint

    (pink               . "#be185d") ; Deep magenta / pink (keywords)
    (pink-bright        . "#d9006c") ; Vibrant pink
    (pink-dim           . "#831843")

    (purple             . "#6d28d9") ; Types / Primitives
    (purple-bright      . "#7c3aed")
    (purple-dim         . "#4c1d95")

    (cyan               . "#0891b2") ; Deep cyan / strings
    (cyan-bright        . "#06b6d4")
    (cyan-dim           . "#155e75")

    (green              . "#059669") ; Emerald success
    (green-bright       . "#10b981")
    (green-dim          . "#047857")
    (green-bg           . "#edfcf4") ; Diff added background

    (orange             . "#c2410c") ; Amber / Numbers / Constants
    (orange-bright      . "#ea580c")
    (orange-dim         . "#9a3412")

    (red                . "#dc2626") ; Error / Deletions
    (red-bright         . "#ef4444")
    (red-dim            . "#991b1b")
    (red-bg             . "#fef2f2") ; Diff removed background

    (yellow             . "#b45309") ; Warning / Attention
    (yellow-dim         . "#78350f")
    (yellow-bg          . "#fefce8") ; Warning background
    )
  "Vercel Geist Light Color Palette.")

(defun geist--c (key palette)
  "Lookup KEY in PALETTE."
  (cdr (assq key palette)))

(defun geist--cursor-hex (variant palette)
  "Return cursor hex color for VARIANT and PALETTE."
  (pcase geist-cursor-color
    ('blue (if (eq variant 'dark) "#0070f3" "#0068d6"))
    ('white (if (eq variant 'dark) "#ffffff" "#000000"))
    (_ (geist--c 'fg-main palette))))

(defun geist-theme-faces (variant)
  "Generate face definitions for VARIANT (`dark' or `light')."
  (let* ((p (if (eq variant 'dark) geist-dark-palette geist-light-palette))
         (bg-main           (geist--c 'bg-main p))
         (bg-alt            (geist--c 'bg-alt p))
         (bg-surface        (geist--c 'bg-surface p))
         (bg-surface-active (geist--c 'bg-surface-active p))
         (bg-modeline       (geist--c 'bg-modeline p))
         (bg-modeline-dim   (geist--c 'bg-modeline-dim p))
         (bg-highlight      (geist--c 'bg-highlight p))
         (bg-region         (geist--c 'bg-region p))
         (bg-region-subtle  (geist--c 'bg-region-subtle p))
         (border-subtle     (geist--c 'border-subtle p))
         (border-main       (geist--c 'border-main p))
         (border-focus      (geist--c 'border-focus p))
         (fg-main           (geist--c 'fg-main p))
         (fg-alt            (geist--c 'fg-alt p))
         (fg-dim            (geist--c 'fg-dim p))
         (fg-muted          (geist--c 'fg-muted p))
         (fg-ghost          (geist--c 'fg-ghost p))
         (blue              (geist--c 'blue p))
         (blue-bright       (geist--c 'blue-bright p))
         (blue-dim          (geist--c 'blue-dim p))
         (blue-bg           (geist--c 'blue-bg p))
         (pink              (geist--c 'pink p))
         (pink-bright       (geist--c 'pink-bright p))
         (pink-dim          (geist--c 'pink-dim p))
         (purple            (geist--c 'purple p))
         (purple-bright     (geist--c 'purple-bright p))
         (cyan              (geist--c 'cyan p))
         (cyan-bright       (geist--c 'cyan-bright p))
         (green             (geist--c 'green p))
         (green-bright      (geist--c 'green-bright p))
         (green-dim         (geist--c 'green-dim p))
         (green-bg          (geist--c 'green-bg p))
         (orange            (geist--c 'orange p))
         (orange-bright     (geist--c 'orange-bright p))
         (orange-dim        (geist--c 'orange-dim p))
         (red               (geist--c 'red p))
         (red-bright        (geist--c 'red-bright p))
         (red-dim           (geist--c 'red-dim p))
         (red-bg            (geist--c 'red-bg p))
         (yellow            (geist--c 'yellow p))
         (yellow-dim        (geist--c 'yellow-dim p))
         (yellow-bg         (geist--c 'yellow-bg p))
         (cursor-color      (geist--cursor-hex variant p))
         (weight-bold       (if geist-bold-constructs 'bold 'normal))
         (slant-italic      (if geist-italic-comments 'italic 'normal)))
    `(
      ;;; -------------------------------------------------------------
      ;;; Basic Core UI Faces
      ;;; -------------------------------------------------------------
      (default ((t (:foreground ,fg-main :background ,bg-main))))
      (bold ((t (:weight bold))))
      (italic ((t (:slant italic))))
      (bold-italic ((t (:weight bold :slant italic))))
      (underline ((t (:underline t))))

      (cursor ((t (:background ,cursor-color :foreground ,bg-main))))
      (region ((t (:background ,bg-region :extend t))))
      (secondary-selection ((t (:background ,bg-region-subtle :extend t))))
      (highlight ((t (:background ,bg-surface-active))))
      (hl-line ((t (:background ,bg-highlight :extend t))))

      (fringe ((t (:background ,bg-main :foreground ,fg-muted))))
      (vertical-border ((t (:foreground ,border-main))))
      (window-divider ((t (:foreground ,border-main))))
      (window-divider-first-pixel ((t (:foreground ,border-main))))
      (window-divider-last-pixel ((t (:foreground ,border-main))))

      (minibuffer-prompt ((t (:foreground ,blue-bright :weight ,weight-bold))))
      (link ((t (:foreground ,blue-bright :underline t))))
      (link-visited ((t (:foreground ,purple-bright :underline t))))
      (button ((t (:foreground ,blue :underline t :weight ,weight-bold))))
      (shadow ((t (:foreground ,fg-muted))))
      (trailing-whitespace ((t (:background ,red-dim))))
      (escape-glyph ((t (:foreground ,orange))))

      (error ((t (:foreground ,red-bright :weight bold))))
      (warning ((t (:foreground ,yellow :weight bold))))
      (success ((t (:foreground ,green :weight bold))))

      ;; Line Numbers
      (line-number ((t (:foreground ,fg-muted :background ,bg-main))))
      (line-number-current-line ((t (:foreground ,fg-main :background ,bg-highlight :weight bold))))
      (line-number-major-tick ((t (:foreground ,fg-alt :background ,bg-main :weight bold))))
      (line-number-minor-tick ((t (:foreground ,fg-dim :background ,bg-main))))

      ;; Mode-line
      (mode-line ((t (:foreground ,fg-alt
                      :background ,bg-modeline
                      ,@(when geist-distinct-modeline
                          `(:box (:line-width -1 :color ,border-main :style nil)))
                      ,@(when geist-use-variable-pitch
                          '(:family "Geist"))))))
      (mode-line-inactive ((t (:foreground ,fg-muted
                               :background ,bg-modeline-dim
                               ,@(when geist-distinct-modeline
                                   `(:box (:line-width -1 :color ,border-subtle :style nil)))
                               ,@(when geist-use-variable-pitch
                                   '(:family "Geist"))))))
      (mode-line-buffer-id ((t (:foreground ,fg-main :weight bold))))
      (mode-line-emphasis ((t (:foreground ,blue-bright :weight bold))))
      (mode-line-highlight ((t (:foreground ,blue-bright :box (:line-width 1 :color ,blue)))))

      ;; Header-line
      (header-line ((t (:foreground ,fg-alt :background ,bg-alt :box (:line-width -1 :color ,border-main)))))
      (header-line-highlight ((t (:foreground ,fg-main :background ,bg-surface))))

      ;; Tab-bar and Tab-line
      (tab-bar ((t (:background ,bg-alt :foreground ,fg-muted))))
      (tab-bar-tab ((t (:background ,bg-main :foreground ,fg-main :weight bold :box (:line-width 1 :color ,blue)))))
      (tab-bar-tab-inactive ((t (:background ,bg-alt :foreground ,fg-dim))))
      (tab-line ((t (:background ,bg-alt :foreground ,fg-muted))))
      (tab-line-tab ((t (:background ,bg-main :foreground ,fg-main :weight bold))))
      (tab-line-tab-inactive ((t (:background ,bg-alt :foreground ,fg-dim))))
      (tab-line-tab-current ((t (:background ,bg-main :foreground ,fg-main :weight bold :box (:line-width 1 :color ,blue)))))

      ;; Tooltip
      (tooltip ((t (:foreground ,fg-main :background ,bg-surface :box (:line-width 1 :color ,border-focus)))))

      ;;; -------------------------------------------------------------
      ;;; Font Lock Syntax Highlighting (Geist signature styling)
      ;;; -------------------------------------------------------------
      ;; Keywords: Signature Vercel hot pink / deep magenta
      (font-lock-keyword-face ((t (:foreground ,pink :weight ,weight-bold))))
      ;; Functions / Methods: Electric Vercel blue
      (font-lock-function-name-face ((t (:foreground ,blue-bright :weight ,weight-bold))))
      (font-lock-function-call-face ((t (:foreground ,blue-bright))))
      ;; Strings: Clean emerald / cyan mint
      (font-lock-string-face ((t (:foreground ,cyan))))
      (font-lock-doc-face ((t (:foreground ,fg-dim :slant ,slant-italic))))
      ;; Comments: Clean muted gray, italicized
      (font-lock-comment-face ((t (:foreground ,fg-dim :slant ,slant-italic))))
      (font-lock-comment-delimiter-face ((t (:foreground ,fg-muted :slant ,slant-italic))))
      ;; Types & Primitives: Vercel purple / violet
      (font-lock-type-face ((t (:foreground ,purple-bright :weight ,weight-bold))))
      (font-lock-builtin-face ((t (:foreground ,purple))))
      ;; Constants, Booleans, Numbers: Vercel Amber / Orange
      (font-lock-constant-face ((t (:foreground ,orange :weight ,weight-bold))))
      (font-lock-number-face ((t (:foreground ,orange))))
      ;; Variables & Identifiers: Clean high-contrast white / near black
      (font-lock-variable-name-face ((t (:foreground ,fg-main))))
      (font-lock-variable-use-face ((t (:foreground ,fg-main))))
      (font-lock-property-name-face ((t (:foreground ,fg-alt))))
      (font-lock-property-use-face ((t (:foreground ,fg-alt))))
      ;; Preprocessor & Macros: Vercel Yellow
      (font-lock-preprocessor-face ((t (:foreground ,yellow))))
      (font-lock-negation-char-face ((t (:foreground ,pink-bright :weight bold))))
      (font-lock-warning-face ((t (:foreground ,red-bright :weight bold))))
      (font-lock-regexp-grouping-backslash ((t (:foreground ,cyan-bright :weight bold))))
      (font-lock-regexp-grouping-construct ((t (:foreground ,pink :weight bold))))
      (font-lock-escape-face ((t (:foreground ,orange-bright :weight bold))))
      (font-lock-bracket-face ((t (:foreground ,fg-alt))))
      (font-lock-delimiter-face ((t (:foreground ,fg-dim))))
      (font-lock-misc-punctuation-face ((t (:foreground ,fg-dim))))
      (font-lock-operator-face ((t (:foreground ,pink-bright))))

      ;; Tree-sitter built-in face mappings (Emacs 29+)
      (treesit-font-lock-keyword-face ((t (:foreground ,pink :weight ,weight-bold))))
      (treesit-font-lock-function-name-face ((t (:foreground ,blue-bright :weight ,weight-bold))))
      (treesit-font-lock-string-face ((t (:foreground ,cyan))))
      (treesit-font-lock-type-face ((t (:foreground ,purple-bright :weight ,weight-bold))))
      (treesit-font-lock-variable-name-face ((t (:foreground ,fg-main))))
      (treesit-font-lock-constant-face ((t (:foreground ,orange :weight ,weight-bold))))
      (treesit-font-lock-property-name-face ((t (:foreground ,fg-alt))))
      (treesit-font-lock-number-face ((t (:foreground ,orange))))
      (treesit-font-lock-comment-face ((t (:foreground ,fg-dim :slant ,slant-italic))))
      (treesit-font-lock-bracket-face ((t (:foreground ,fg-alt))))
      (treesit-font-lock-delimiter-face ((t (:foreground ,fg-dim))))
      (treesit-font-lock-operator-face ((t (:foreground ,pink-bright))))

      ;;; -------------------------------------------------------------
      ;;; Search, Matching & Parentheses
      ;;; -------------------------------------------------------------
      (isearch ((t (:foreground ,bg-main :background ,pink :weight bold))))
      (isearch-fail ((t (:foreground ,red-bright :background ,red-bg :weight bold))))
      (lazy-highlight ((t (:foreground ,fg-main :background ,bg-surface-active :underline (:color ,blue-bright :style line)))))
      (match ((t (:foreground ,blue-bright :background ,blue-bg :weight bold))))
      (query-replace ((t (:inherit isearch))))
      (show-paren-match ((t (:foreground ,cyan-bright :background ,bg-surface-active :weight bold :underline t))))
      (show-paren-mismatch ((t (:foreground ,red-bright :background ,red-bg :weight bold :underline t))))

      ;;; -------------------------------------------------------------
      ;;; Completion UIs (Vertico, Corfu, Orderless, Marginalia, Consult)
      ;;; -------------------------------------------------------------
      ;; Vertico
      (vertico-current ((t (:background ,bg-surface-active :foreground ,fg-main :extend t :weight bold))))
      (vertico-multiline ((t (:foreground ,fg-dim))))
      (vertico-group-title ((t (:foreground ,fg-dim :weight bold :underline (:color ,border-main)))))
      (vertico-group-separator ((t (:strike-through ,border-main))))

      ;; Corfu
      (corfu-default ((t (:background ,bg-surface :foreground ,fg-main :box (:line-width 1 :color ,border-focus)))))
      (corfu-current ((t (:background ,bg-surface-active :foreground ,fg-main :weight bold))))
      (corfu-bar ((t (:background ,border-focus))))
      (corfu-border ((t (:background ,border-focus))))

      ;; Orderless
      (orderless-match-face-0 ((t (:foreground ,blue-bright :weight bold))))
      (orderless-match-face-1 ((t (:foreground ,pink :weight bold))))
      (orderless-match-face-2 ((t (:foreground ,green :weight bold))))
      (orderless-match-face-3 ((t (:foreground ,yellow :weight bold))))

      ;; Marginalia
      (marginalia-key ((t (:foreground ,pink :weight bold))))
      (marginalia-type ((t (:foreground ,purple-bright))))
      (marginalia-char ((t (:foreground ,cyan))))
      (marginalia-date ((t (:foreground ,fg-dim))))
      (marginalia-documentation ((t (:foreground ,fg-alt :slant ,slant-italic))))
      (marginalia-file-name ((t (:foreground ,fg-main))))
      (marginalia-file-owner ((t (:foreground ,fg-dim))))
      (marginalia-file-priv-dir ((t (:foreground ,blue))))
      (marginalia-file-priv-exec ((t (:foreground ,green))))
      (marginalia-file-priv-no ((t (:foreground ,fg-ghost))))
      (marginalia-file-priv-read ((t (:foreground ,yellow))))
      (marginalia-file-priv-write ((t (:foreground ,red))))
      (marginalia-mode ((t (:foreground ,blue-bright))))
      (marginalia-modified ((t (:foreground ,yellow))))
      (marginalia-number ((t (:foreground ,orange))))
      (marginalia-size ((t (:foreground ,fg-dim))))
      (marginalia-string ((t (:foreground ,cyan))))
      (marginalia-symbol ((t (:foreground ,purple))))
      (marginalia-value ((t (:foreground ,fg-alt))))
      (marginalia-version ((t (:foreground ,cyan-bright))))

      ;; Consult
      (consult-preview-line ((t (:background ,bg-surface-active))))
      (consult-preview-match ((t (:foreground ,blue-bright :weight bold))))
      (consult-async-running ((t (:foreground ,yellow :weight bold))))
      (consult-async-split ((t (:foreground ,pink :weight bold))))
      (consult-bookmark ((t (:foreground ,purple-bright))))
      (consult-file ((t (:foreground ,fg-main))))
      (consult-line-number ((t (:foreground ,fg-dim))))
      (consult-narrow-indicator ((t (:foreground ,pink-bright :weight bold))))

      ;; Company
      (company-tooltip ((t (:background ,bg-surface :foreground ,fg-main :box (:line-width 1 :color ,border-focus)))))
      (company-tooltip-selection ((t (:background ,bg-surface-active :foreground ,fg-main :weight bold))))
      (company-tooltip-common ((t (:foreground ,blue-bright :weight bold))))
      (company-tooltip-common-selection ((t (:foreground ,blue-bright :weight bold))))
      (company-tooltip-annotation ((t (:foreground ,fg-dim :slant ,slant-italic))))
      (company-scrollbar-bg ((t (:background ,bg-alt))))
      (company-scrollbar-fg ((t (:background ,border-focus))))
      (company-preview ((t (:foreground ,fg-muted))))
      (company-preview-common ((t (:foreground ,fg-dim :underline t))))

      ;;; -------------------------------------------------------------
      ;;; Terminals & Shells (Eshell, Vterm, Term, ANSI colors)
      ;;; -------------------------------------------------------------
      (ansi-color-black ((t (:foreground ,(if (eq variant 'dark) "#1c1c1c" "#e5e5e5")
                             :background ,(if (eq variant 'dark) "#1c1c1c" "#e5e5e5")))))
      (ansi-color-red ((t (:foreground ,red :background ,red))))
      (ansi-color-green ((t (:foreground ,green :background ,green))))
      (ansi-color-yellow ((t (:foreground ,yellow :background ,yellow))))
      (ansi-color-blue ((t (:foreground ,blue-bright :background ,blue-bright))))
      (ansi-color-magenta ((t (:foreground ,pink :background ,pink))))
      (ansi-color-cyan ((t (:foreground ,cyan :background ,cyan))))
      (ansi-color-white ((t (:foreground ,fg-main :background ,fg-main))))

      (ansi-color-bright-black ((t (:foreground ,fg-dim :background ,fg-dim))))
      (ansi-color-bright-red ((t (:foreground ,red-bright :background ,red-bright))))
      (ansi-color-bright-green ((t (:foreground ,green-bright :background ,green-bright))))
      (ansi-color-bright-yellow ((t (:foreground ,yellow :background ,yellow))))
      (ansi-color-bright-blue ((t (:foreground ,blue-bright :background ,blue-bright))))
      (ansi-color-bright-magenta ((t (:foreground ,pink-bright :background ,pink-bright))))
      (ansi-color-bright-cyan ((t (:foreground ,cyan-bright :background ,cyan-bright))))
      (ansi-color-bright-white ((t (:foreground ,(if (eq variant 'dark) "#ffffff" "#000000")
                                    :background ,(if (eq variant 'dark) "#ffffff" "#000000")))))

      ;; Term faces
      (term ((t (:foreground ,fg-main :background ,bg-main))))
      (term-color-black ((t (:inherit ansi-color-black))))
      (term-color-red ((t (:inherit ansi-color-red))))
      (term-color-green ((t (:inherit ansi-color-green))))
      (term-color-yellow ((t (:inherit ansi-color-yellow))))
      (term-color-blue ((t (:inherit ansi-color-blue))))
      (term-color-magenta ((t (:inherit ansi-color-magenta))))
      (term-color-cyan ((t (:inherit ansi-color-cyan))))
      (term-color-white ((t (:inherit ansi-color-white))))

      ;; Vterm faces
      (vterm-color-black ((t (:inherit ansi-color-black))))
      (vterm-color-red ((t (:inherit ansi-color-red))))
      (vterm-color-green ((t (:inherit ansi-color-green))))
      (vterm-color-yellow ((t (:inherit ansi-color-yellow))))
      (vterm-color-blue ((t (:inherit ansi-color-blue))))
      (vterm-color-magenta ((t (:inherit ansi-color-magenta))))
      (vterm-color-cyan ((t (:inherit ansi-color-cyan))))
      (vterm-color-white ((t (:inherit ansi-color-white))))
      (vterm-color-bright-black ((t (:inherit ansi-color-bright-black))))
      (vterm-color-bright-red ((t (:inherit ansi-color-bright-red))))
      (vterm-color-bright-green ((t (:inherit ansi-color-bright-green))))
      (vterm-color-bright-yellow ((t (:inherit ansi-color-bright-yellow))))
      (vterm-color-bright-blue ((t (:inherit ansi-color-bright-blue))))
      (vterm-color-bright-magenta ((t (:inherit ansi-color-bright-magenta))))
      (vterm-color-bright-cyan ((t (:inherit ansi-color-bright-cyan))))
      (vterm-color-bright-white ((t (:inherit ansi-color-bright-white))))

      ;; Eshell
      (eshell-prompt ((t (:foreground ,blue-bright :weight bold))))
      (eshell-ls-directory ((t (:foreground ,blue-bright :weight bold))))
      (eshell-ls-executable ((t (:foreground ,green :weight bold))))
      (eshell-ls-symlink ((t (:foreground ,cyan :slant italic))))
      (eshell-ls-archive ((t (:foreground ,orange))))
      (eshell-ls-missing ((t (:foreground ,red :strike-through t))))
      (eshell-ls-readonly ((t (:foreground ,fg-muted))))

      ;;; -------------------------------------------------------------
      ;;; Magit & Version Control
      ;;; -------------------------------------------------------------
      (diff-added ((t (:foreground ,green :background ,green-bg :extend t))))
      (diff-removed ((t (:foreground ,red :background ,red-bg :extend t))))
      (diff-changed ((t (:foreground ,yellow :background ,yellow-bg :extend t))))
      (diff-context ((t (:foreground ,fg-dim :extend t))))
      (diff-header ((t (:foreground ,fg-alt :background ,bg-alt :extend t))))
      (diff-file-header ((t (:foreground ,fg-main :background ,bg-surface :weight bold :extend t))))
      (diff-hunk-header ((t (:foreground ,blue-bright :background ,blue-bg :weight bold :extend t))))
      (diff-refine-added ((t (:foreground ,green-bright :background ,green-bg :weight bold))))
      (diff-refine-removed ((t (:foreground ,red-bright :background ,red-bg :weight bold))))

      (magit-section-heading ((t (:foreground ,fg-main :weight bold))))
      (magit-section-highlight ((t (:background ,bg-surface-active :extend t))))
      (magit-branch-local ((t (:foreground ,blue-bright :weight bold))))
      (magit-branch-remote ((t (:foreground ,purple-bright :slant italic))))
      (magit-branch-current ((t (:foreground ,blue-bright :weight bold :box (:line-width 1 :color ,blue)))))
      (magit-diff-added ((t (:foreground ,green :background ,green-bg :extend t))))
      (magit-diff-added-highlight ((t (:foreground ,green-bright :background ,green-bg :weight bold :extend t))))
      (magit-diff-removed ((t (:foreground ,red :background ,red-bg :extend t))))
      (magit-diff-removed-highlight ((t (:foreground ,red-bright :background ,red-bg :weight bold :extend t))))
      (magit-diff-context ((t (:foreground ,fg-dim :extend t))))
      (magit-diff-context-highlight ((t (:foreground ,fg-alt :background ,bg-surface :extend t))))
      (magit-diff-file-heading ((t (:foreground ,fg-main :background ,bg-surface :weight bold :extend t))))
      (magit-diff-file-heading-highlight ((t (:foreground ,fg-main :background ,bg-surface-active :weight bold :extend t))))
      (magit-diff-hunk-heading ((t (:foreground ,blue-bright :background ,blue-bg :weight bold :extend t))))
      (magit-diff-hunk-heading-highlight ((t (:foreground ,blue-bright :background ,blue-bg :weight bold :box (:line-width 1 :color ,blue-bright) :extend t))))
      (magit-hash ((t (:foreground ,fg-dim))))
      (magit-tag ((t (:foreground ,orange :weight bold))))
      (magit-log-author ((t (:foreground ,cyan))))
      (magit-log-date ((t (:foreground ,fg-dim))))

      ;; Diff-hl & Git-gutter
      (diff-hl-insert ((t (:foreground ,green :background ,green))))
      (diff-hl-delete ((t (:foreground ,red :background ,red))))
      (diff-hl-change ((t (:foreground ,yellow :background ,yellow))))
      (git-gutter:added ((t (:foreground ,green :weight bold))))
      (git-gutter:deleted ((t (:foreground ,red :weight bold))))
      (git-gutter:modified ((t (:foreground ,yellow :weight bold))))

      ;;; -------------------------------------------------------------
      ;;; Dired & Navigation
      ;;; -------------------------------------------------------------
      (dired-directory ((t (:foreground ,blue-bright :weight bold))))
      (dired-symlink ((t (:foreground ,cyan :slant italic))))
      (dired-header ((t (:foreground ,fg-main :weight bold :box (:line-width -1 :color ,border-main)))))
      (dired-marked ((t (:foreground ,pink-bright :weight bold :background ,bg-surface-active))))
      (dired-flagged ((t (:foreground ,red-bright :weight bold :background ,red-bg))))
      (dired-ignored ((t (:foreground ,fg-muted))))
      (dired-perm-write ((t (:foreground ,red))))

      ;; Treemacs
      (treemacs-root-face ((t (:foreground ,fg-main :weight bold :height 1.1))))
      (treemacs-directory-face ((t (:foreground ,blue-bright :weight bold))))
      (treemacs-file-face ((t (:foreground ,fg-main))))
      (treemacs-git-modified-face ((t (:foreground ,yellow))))
      (treemacs-git-added-face ((t (:foreground ,green))))
      (treemacs-git-untracked-face ((t (:foreground ,cyan))))

      ;;; -------------------------------------------------------------
      ;;; Diagnostics & LSP (Flymake, Flycheck, LSP)
      ;;; -------------------------------------------------------------
      (flymake-error ((t (:underline (:color ,red :style wave) :weight bold))))
      (flymake-warning ((t (:underline (:color ,yellow :style wave)))))
      (flymake-note ((t (:underline (:color ,blue-bright :style wave)))))
      (flycheck-error ((t (:underline (:color ,red :style wave) :weight bold))))
      (flycheck-warning ((t (:underline (:color ,yellow :style wave)))))
      (flycheck-info ((t (:underline (:color ,blue-bright :style wave)))))

      (lsp-ui-doc-background ((t (:background ,bg-surface :box (:line-width 1 :color ,border-focus)))))
      (lsp-ui-doc-header ((t (:foreground ,fg-main :background ,bg-surface-active :weight bold))))
      (lsp-ui-peek-header ((t (:background ,bg-surface-active :foreground ,fg-main :weight bold))))
      (lsp-ui-peek-list ((t (:background ,bg-surface))))
      (lsp-ui-peek-filename ((t (:foreground ,blue-bright :weight bold))))
      (lsp-ui-peek-line-number ((t (:foreground ,fg-dim))))

      ;;; -------------------------------------------------------------
      ;;; Org Mode & Markdown
      ;;; -------------------------------------------------------------
      (org-level-1 ((t (:foreground ,fg-main :weight bold :height 1.25
                        ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (org-level-2 ((t (:foreground ,blue-bright :weight bold :height 1.15
                        ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (org-level-3 ((t (:foreground ,purple-bright :weight bold :height 1.05
                        ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (org-level-4 ((t (:foreground ,pink :weight bold
                        ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (org-level-5 ((t (:foreground ,cyan :weight bold))))
      (org-level-6 ((t (:foreground ,orange :weight bold))))
      (org-document-title ((t (:foreground ,fg-main :weight bold :height 1.4
                               ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (org-document-info ((t (:foreground ,fg-dim))))
      (org-code ((t (:foreground ,pink-bright :background ,bg-surface :box (:line-width -1 :color ,border-main)))))
      (org-block ((t (:background ,bg-alt :extend t))))
      (org-block-begin-line ((t (:foreground ,fg-muted :background ,bg-alt :slant italic :extend t))))
      (org-block-end-line ((t (:foreground ,fg-muted :background ,bg-alt :slant italic :extend t))))
      (org-table ((t (:foreground ,cyan :background ,bg-alt))))
      (org-date ((t (:foreground ,blue-bright :underline t))))
      (org-todo ((t (:foreground ,red-bright :weight bold :box (:line-width 1 :color ,red-bright)))))
      (org-done ((t (:foreground ,green :weight bold :box (:line-width 1 :color ,green)))))
      (org-headline-done ((t (:foreground ,fg-muted :strike-through t))))
      (org-checkbox ((t (:foreground ,blue-bright :weight bold))))

      ;; Markdown
      (markdown-header-face-1 ((t (:foreground ,fg-main :weight bold :height 1.3
                                   ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (markdown-header-face-2 ((t (:foreground ,blue-bright :weight bold :height 1.2
                                   ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (markdown-header-face-3 ((t (:foreground ,purple-bright :weight bold :height 1.1
                                   ,@(when geist-use-variable-pitch '(:family "Geist"))))))
      (markdown-header-face-4 ((t (:foreground ,pink :weight bold))))
      (markdown-code-face ((t (:foreground ,pink-bright :background ,bg-surface :box (:line-width 1 :color ,border-main)))))
      (markdown-inline-code-face ((t (:foreground ,pink-bright :background ,bg-surface :box (:line-width 1 :color ,border-main)))))
      (markdown-pre-face ((t (:background ,bg-alt :extend t))))
      (markdown-table-face ((t (:foreground ,cyan))))
      (markdown-url-face ((t (:foreground ,blue :underline t))))
      (markdown-link-face ((t (:foreground ,blue-bright :underline t))))
      (markdown-blockquote-face ((t (:foreground ,fg-dim :slant italic :background ,bg-alt :extend t))))

      ;;; -------------------------------------------------------------
      ;;; Which-Key & Doom-Modeline
      ;;; -------------------------------------------------------------
      (which-key-key-face ((t (:foreground ,pink :weight bold))))
      (which-key-group-description-face ((t (:foreground ,purple-bright))))
      (which-key-command-description-face ((t (:foreground ,fg-main))))
      (which-key-separator-face ((t (:foreground ,fg-muted))))

      (doom-modeline-buffer-file ((t (:foreground ,fg-main :weight bold))))
      (doom-modeline-buffer-modified ((t (:foreground ,yellow :weight bold))))
      (doom-modeline-buffer-major-mode ((t (:foreground ,blue-bright :weight bold))))
      (doom-modeline-project-dir ((t (:foreground ,fg-dim :slant italic))))
      (doom-modeline-bar ((t (:background ,blue))))
      (doom-modeline-panel ((t (:background ,blue :foreground ,bg-main))))
      )))

(defun geist-ansi-color-vector (variant)
  "Return `ansi-color-names-vector' for VARIANT."
  (let* ((p (if (eq variant 'dark) geist-dark-palette geist-light-palette)))
    (vector (if (eq variant 'dark) "#1c1c1c" "#e5e5e5")
            (geist--c 'red p)
            (geist--c 'green p)
            (geist--c 'yellow p)
            (geist--c 'blue-bright p)
            (geist--c 'pink p)
            (geist--c 'cyan p)
            (geist--c 'fg-main p))))

;;;###autoload
(defun geist-load-dark ()
  "Load the `geist-dark' theme and disable active themes."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'geist-dark t))

;;;###autoload
(defun geist-load-light ()
  "Load the `geist-light' theme and disable active themes."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'geist-light t))

;;;###autoload
(defun geist-toggle ()
  "Toggle between `geist-dark' and `geist-light' themes."
  (interactive)
  (if (custom-theme-enabled-p 'geist-dark)
      (geist-load-light)
    (geist-load-dark)))

;;;###autoload
(defun geist-setup-fonts (&optional mono-size variable-size)
  "Set up default Geist Mono and Geist fonts with MONO-SIZE and VARIABLE-SIZE in pt.
Defaults are 14pt."
  (interactive)
  (let ((m-size (or mono-size 14))
        (v-size (or variable-size 14)))
    (when (member "Geist Mono" (font-family-list))
      (set-face-attribute 'default nil :family "Geist Mono" :height (* m-size 10))
      (set-face-attribute 'fixed-pitch nil :family "Geist Mono" :height (* m-size 10)))
    (when (member "Geist" (font-family-list))
      (set-face-attribute 'variable-pitch nil :family "Geist" :height (* v-size 10)))))

(provide 'geist)
;;; geist.el ends here
