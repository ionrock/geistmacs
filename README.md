# ▲ Geistmacs — Vercel Geist Theme for GNU Emacs

<p align="center">
  <img src="icons/icon-showcase.png" alt="Geistmacs Icon Family" width="100%">
</p>

A minimalist, high-contrast GNU Emacs theme family inspired by Vercel's iconic **Geist design system** and typography. Engineered for **Geist Mono** and **Geist** with pixel-precise contrast, obsidian OLED blacks, paper whites, and signature electric accents.

![Geist Theme Comparison](screenshots/geist-comparison.png)

---

## Previews

### Geist Dark (`geist-dark`)
*True OLED pitch black (`#000000`), razor-thin dividers (`#2a2a2a`), hot-pink keywords, electric blue functions, mint cyan strings, and Vercel CLI terminal integration.*

![Geist Dark Preview](screenshots/geist-dark.png)

### Geist Light (`geist-light`)
*Crisp paper white (`#ffffff`), subtle gray elevation surfaces (`#fafafa` / `#f5f5f5`), deep charcoal typography (`#171717`), and balanced contrast.*

![Geist Light Preview](screenshots/geist-light.png)

### Completion & Diagnostics (Corfu + Vertico + Marginalia)
*Floating autocomplete popups with subtle borders, high-contrast candidate selection, and structured metadata.*

![Geist Completion Preview](screenshots/geist-completion-dark.png)

---

## Design Principles

- **True Obsidian Black**: Unlike murky navy or gray themes, `geist-dark` uses pure `#000000` for unmatched contrast and OLED power efficiency.
- **Pure Paper White**: `geist-light` uses `#ffffff` with subtle neutral surfaces (`#fafafa`, `#f5f5f5`) to provide elevation without glare.
- **Hairline Precision**: 1px subtle borders (`#1c1c1c` / `#2a2a2a` in dark, `#eaeaea` in light) separate windows and dialogs cleanly.
- **Vercel Color System**: Accents match official Vercel tokens:
  - **Blue** (`#0070f3` / `#3291ff`): Functions, links, active state indicators.
  - **Pink / Magenta** (`#ff0080` / `#be185d`): Keywords, control flow, tags.
  - **Purple / Violet** (`#8a63d2` / `#6d28d9`): Types, interfaces, primitives.
  - **Cyan / Mint** (`#50e3c2` / `#0891b2`): Strings, regex.
  - **Amber / Orange** (`#ff8024` / `#c2410c`): Numbers, constants.
  - **Emerald Green** (`#00df89` / `#059669`): Success, additions, terminal readiness.
  - **Red** (`#ff4444` / `#dc2626`): Errors, deletions.
  - **Yellow** (`#f5e158` / `#b45309`): Warnings, highlights.

---

## Color Palette

| Token | Dark (`geist-dark`) | Light (`geist-light`) | Primary Usage |
|:---|:---:|:---:|:---|
| `bg-main` | `#000000` | `#ffffff` | Primary editor background |
| `bg-alt` | `#0a0a0a` | `#fafafa` | Subtle elevation, fringes, header |
| `bg-surface` | `#111111` | `#f5f5f5` | Popups, tooltips, dialogs |
| `bg-surface-active` | `#1c1c1c` | `#eaeaea` | Selection, active completion item |
| `bg-highlight` | `#121212` | `#f8f8f8` | Current line (`hl-line`) |
| `bg-region` | `#222222` | `#e5e5e5` | Visual selection / region |
| `fg-main` | `#ededed` | `#171717` | High-contrast text & variables |
| `fg-alt` | `#a1a1a1` | `#525252` | Secondary text, parameters |
| `fg-dim` | `#737373` | `#888888` | Line numbers, comments |
| `fg-muted` | `#4d4d4d` | `#b3b3b3` | Faint text, inactive items |
| `border-main` | `#2a2a2a` | `#eaeaea` | Window dividers, modeline borders |
| `blue-bright` | `#3291ff` | `#0070f3` | Function calls, prompt triangle |
| `pink` | `#ff0080` | `#be185d` | Keywords (`import`, `export`, `return`) |
| `purple` | `#8a63d2` | `#6d28d9` | Types, interfaces |
| `cyan` | `#50e3c2` | `#0891b2` | Strings |
| `orange` | `#ff8024` | `#c2410c` | Numbers, constants |
| `green` | `#00df89` | `#059669` | Success, git additions |
| `red` | `#ff4444` | `#dc2626` | Errors, git deletions |

---

## Installation

### With `straight.el`

```elisp
(straight-use-package
 '(geistmacs :type git :host github :repo "elarson/geistmacs"))

;; Load dark theme by default
(load-theme 'geist-dark t)
```

### With `use-package` (Emacs 29+ with `:vc`)

```elisp
(use-package geist
  :vc (:url "https://github.com/elarson/geistmacs")
  :init
  ;; Optional: configure font setup (defaults to 12pt)
  ;; (geist-setup-fonts)
  :config
  (load-theme 'geist-dark t))
```

### Manual Installation

Clone the repository into your Emacs configuration:

```bash
git clone https://github.com/elarson/geistmacs.git ~/.emacs.d/themes/geistmacs
```

---

## Application Icon (`geistmacs.icns`)

Geistmacs includes a custom-crafted application icon and vector mark suite inspired by Vercel's iconic equilateral triangle (`▲`) and the GNU Emacs "E" monogram.

<p align="center">
  <img src="icons/png/geistmacs-512x512.png" alt="Geistmacs Dark Icon" width="160">&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="icons/png/geistmacs-light-512x512.png" alt="Geistmacs Light Icon" width="160">&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="icons/png/geistmacs-mark-512x512.png" alt="Geistmacs Standalone Mark" width="160">
</p>

- **True Euclidean Geometry**: An equilateral 60° triangle container with precision negative-space cutouts forming the uppercase "E" and forward prompt chevron.
- **Titanium Specular Sheen**: Chiseled specular rim lighting along the left 60° spine, with an iridescent spectral prism sheen across the lower facet.
- **Signature Electric Aura**: Luminous radiant glow (`#0070f3` electric blue → `#7928ca` purple → `#ff0080` hot pink) blooming into OLED obsidian black (`#000000`).
- **Apple Standard Squircle**: Built to Apple Human Interface Guidelines continuous curvature with multi-layer ambient drop shadows.

### Applying to `Emacs.app` on macOS

```bash
# Option 1: Terminal command
cp icons/geistmacs.icns /Applications/Emacs.app/Contents/Resources/Emacs.icns
touch /Applications/Emacs.app && killall Finder Dock
```

Or via Finder GUI:
1. Open **Finder** and navigate to `/Applications`.
2. Select `Emacs.app` and press **⌘ + I** (Get Info).
3. Drag `icons/geistmacs.icns` directly onto the small icon in the top-left corner of the Get Info window.

### Available Formats in `icons/`

- `icons/geistmacs.icns`: Native macOS multi-resolution icon bundle (16px to 1024px @2x Retina).
- `icons/svg/geistmacs-icon-dark.svg`: Dark mode macOS squircle app icon.
- `icons/svg/geistmacs-icon-light.svg`: Light mode macOS squircle app icon.
- `icons/svg/geistmacs-mark-dark.svg`: Standalone vector glyph (transparent background).
- `icons/svg/geistmacs-mark-monochrome.svg`: Single-color vector glyph for masks or print.
- `icons/svg/favicon.svg`: Web favicon (32×32).
- `icons/png/`: Pre-rendered PNG exports from 16×16 to 1024×1024.

Then add it to your `init.el`:

```elisp
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/geistmacs")
(add-to-list 'load-path "~/.emacs.d/themes/geistmacs")

(require 'geist)
(load-theme 'geist-dark t)
```

---

## Configuration Options

Customize variables before or after loading the theme:

```elisp
;; Enable or disable bold keywords and function names (default: t)
(setq geist-bold-constructs t)

;; Enable or disable italic comments and docstrings (default: t)
(setq geist-italic-comments t)

;; Enable subtle box outline on the modeline (default: t)
(setq geist-distinct-modeline t)

;; Cursor color style: 'blue (Vercel blue), 'white, or 'fg (default: 'blue)
(setq geist-cursor-color 'blue)

;; Use variable-pitch (Geist) for headings and modeline (default: nil)
(setq geist-use-variable-pitch nil)
```

---

## Interactive Commands

| Command | Description |
|:---|:---|
| `M-x geist-load-dark` | Load `geist-dark` and disable other themes |
| `M-x geist-load-light` | Load `geist-light` and disable other themes |
| `M-x geist-toggle` | Toggle seamlessly between `geist-dark` and `geist-light` |
| `M-x geist-setup-fonts` | Apply `Geist Mono` and `Geist` fonts at 12pt (or custom size) |

---

## Supported Modes & Packages

- **Core & Syntax**: Built-in `font-lock`, Tree-sitter (`treesit`), line numbers (`display-line-numbers`), `hl-line`, `show-paren`.
- **Completion**: `vertico`, `corfu`, `orderless`, `marginalia`, `consult`, `company`, `ivy`.
- **Terminals & Shells**: `vterm`, `eshell`, `term`, `ansi-color` (supports 16-color ANSI palette).
- **Version Control**: `magit` (full section, hunk, diff, and branch styling), `diff-hl`, `git-gutter`, `smerge`.
- **File Managers**: `dired`, `treemacs`.
- **Diagnostics**: `flymake`, `flycheck`, `eglot`, `lsp-mode`, `lsp-ui`.
- **Notes & Docs**: `org-mode`, `markdown-mode`, `which-key`, `doom-modeline`.

---

## Running the Test Suite & Preview Generator

```bash
# Run unit tests
emacs -Q --batch -L . -L tests -l tests/geist-test.el -f ert-run-tests-batch-and-exit

# Re-generate all high-resolution PNG previews (fast & stall-free)
./preview/capture.sh
```

---

## License

MIT License © 2025 Eric Larson
