;;; generate-screenshots.el --- Generate high-res preview screenshots for Geist -*- lexical-binding: t; -*-

(require 'cl-lib)

;; Add current directory to load-paths
(add-to-list 'load-path default-directory)
(add-to-list 'custom-theme-load-path default-directory)
(require 'geist)

(defun html-escape (str)
  "Escape STR for HTML."
  (let ((s (replace-regexp-in-string "&" "&amp;" str)))
    (setq s (replace-regexp-in-string "<" "&lt;" s))
    (setq s (replace-regexp-in-string ">" "&gt;" s))
    (setq s (replace-regexp-in-string "\"" "&quot;" s))
    s))

(defun face-to-css (face)
  "Convert Emacs FACE to CSS style string."
  (if (not face)
      ""
    (let* ((f (if (listp face) (car face) face))
           (fg (face-attribute f :foreground nil t))
           (bg (face-attribute f :background nil t))
           (weight (face-attribute f :weight nil t))
           (slant (face-attribute f :slant nil t))
           (underline (face-attribute f :underline nil t))
           (css '()))
      (when (and fg (not (eq fg 'unspecified)) (stringp fg))
        (push (format "color: %s;" fg) css))
      (when (and bg (not (eq bg 'unspecified)) (stringp bg))
        (push (format "background-color: %s;" bg) css))
      (when (and weight (not (eq weight 'unspecified)) (memq weight '(bold extra-bold heavy)))
        (push "font-weight: 600;" css))
      (when (and slant (not (eq slant 'unspecified)) (memq slant '(italic oblique)))
        (push "font-style: italic;" css))
      (when (and underline (not (eq underline 'unspecified)) underline)
        (push "text-decoration: underline;" css))
      (mapconcat #'identity (nreverse css) " "))))

(defun buffer-to-html-lines (buf hl-line-num cursor-pos)
  "Convert contents of BUF to HTML lines with syntax styling.
HL-LINE-NUM is the 1-based line number to highlight.
CURSOR-POS is a cons (LINE . COL) for cursor placement."
  (with-current-buffer buf
    (font-lock-ensure)
    (let ((lines '())
          (curr-line 1)
          (pt (point-min))
          (total (point-max)))
      (while (< pt total)
        (let* ((line-end (save-excursion (goto-char pt) (line-end-position)))
               (line-spans '())
               (pos pt)
               (col 0))
          (while (< pos line-end)
            (let* ((next-change (next-single-property-change pos 'face nil line-end))
                   (face (get-text-property pos 'face))
                   (text (buffer-substring-no-properties pos next-change))
                   (style (face-to-css face)))
              ;; Check if cursor is inside this span
              (if (and cursor-pos (= curr-line (car cursor-pos))
                       (<= col (cdr cursor-pos))
                       (< (cdr cursor-pos) (+ col (length text))))
                  (let* ((offset (- (cdr cursor-pos) col))
                         (before (substring text 0 offset))
                         (cursor-char (substring text offset (min (+ offset 1) (length text))))
                         (after (if (< (+ offset 1) (length text)) (substring text (+ offset 1)) "")))
                    (push (format "<span style=\"%s\">%s</span>" style (html-escape before)) line-spans)
                    (push (format "<span class=\"cursor\" style=\"%s\">%s</span>" style (html-escape cursor-char)) line-spans)
                    (push (format "<span style=\"%s\">%s</span>" style (html-escape after)) line-spans))
                (push (format "<span style=\"%s\">%s</span>" style (html-escape text)) line-spans))
              (setq col (+ col (length text)))
              (setq pos next-change)))
          (let ((line-content (if line-spans (mapconcat #'identity (nreverse line-spans) "") "&nbsp;"))
                (is-hl (and hl-line-num (= curr-line hl-line-num))))
            (push (list curr-line line-content is-hl) lines))
          (setq curr-line (1+ curr-line))
          (setq pt (min total (1+ line-end)))))
      (nreverse lines))))

(defconst sample-typescript-code
  "import { NextRequest, NextResponse } from \"next/server\";
import { kv } from \"@vercel/kv\";
import { edgeMetrics } from \"@/lib/telemetry\";

export const runtime = \"edge\";

interface DeploymentPayload {
  projectId: string;
  deploymentUrl: string;
  regions: string[];
  latencyMs: number;
}

/**
 * Handle incoming production deployment webhooks from Vercel Edge.
 * Emits realtime analytics and verifies HMAC signature.
 */
export async function POST(req: NextRequest): Promise<NextResponse> {
  const start = Date.now();
  const payload = (await req.json()) as DeploymentPayload;

  if (!payload.projectId || !payload.deploymentUrl) {
    return NextResponse.json({ error: \"Invalid payload\" }, { status: 400 });
  }

  // Record edge execution telemetry into KV store
  const metricKey = `deploy:${payload.projectId}:latest`;
  await kv.hset(metricKey, {
    url: payload.deploymentUrl,
    regions: payload.regions.join(\",\"),
    deployedAt: new Date().toISOString(),
    durationMs: Date.now() - start,
  });

  edgeMetrics.increment(\"deployments.success\", 1, {
    region: process.env.VERCEL_REGION || \"iad1\",
  });

  return NextResponse.json({
    status: \"deployed\",
    deploymentUrl: payload.deploymentUrl,
    activeRegions: payload.regions.length,
    edgeLatency: `${Date.now() - start}ms`,
  });
}
")

(defconst sample-terminal-output
  '(("▲ vercel deploy --prod" . term-cmd)
    ("Vercel CLI 41.3.2" . term-dim)
    ("Retrieving project configuration..." . term-text)
    ("Deploying elarson/geistmacs to production..." . term-text)
    ("" . term-text)
    ("🔍 Inspect:  https://vercel.com/elarson/geistmacs/H8j3kL9m  [1.1s]" . term-cyan)
    ("✅ Production: https://geistmacs.vercel.app  [1.8s]" . term-green)
    ("⚡ Ready in 248ms (Edge Middleware, Node.js 22, Rust Core)" . term-green)
    ("" . term-text)
    ("▲ git status -s" . term-cmd)
    (" M geist.el" . term-yellow)
    (" M geist-dark-theme.el" . term-yellow)
    (" M geist-light-theme.el" . term-yellow)
    ("?? screenshots/" . term-red)
    ("" . term-text)
    ("▲ pnpm test:theme" . term-cmd)
    ("  PASS  tests/geist-palette.test.ts" . term-green)
    ("  PASS  tests/face-contrast.test.ts" . term-green)
    ("  ✓ 24 tests passed, 0 failures (38ms)" . term-green)
    ("" . term-text)
    ("▲ echo \"Ready for production deployment.\"" . term-cmd)
    ("Ready for production deployment." . term-text)
    ("▲ " . term-prompt)))

(defun generate-terminal-html (theme-variant)
  (let* ((p (if (eq theme-variant 'dark) geist-dark-palette geist-light-palette))
         (fg-main (geist--c 'fg-main p))
         (fg-dim (geist--c 'fg-dim p))
         (blue (geist--c 'blue-bright p))
         (green (geist--c 'green p))
         (cyan (geist--c 'cyan p))
         (yellow (geist--c 'yellow p))
         (red (geist--c 'red p))
         (html '()))
    (dolist (item sample-terminal-output)
      (let* ((line (car item))
             (type (cdr item))
             (line-html
              (pcase type
                ('term-cmd
                 (format "<span style=\"color:%s; font-weight:700;\">▲</span> <span style=\"color:%s; font-weight:600;\">%s</span>"
                         blue fg-main (html-escape (substring line 2))))
                ('term-prompt
                 (format "<span style=\"color:%s; font-weight:700;\">▲</span> <span class=\"cursor\">&nbsp;</span>" blue))
                ('term-dim
                 (format "<span style=\"color:%s;\">%s</span>" fg-dim (html-escape line)))
                ('term-green
                 (format "<span style=\"color:%s; font-weight:500;\">%s</span>" green (html-escape line)))
                ('term-cyan
                 (format "<span style=\"color:%s;\">%s</span>" cyan (html-escape line)))
                ('term-yellow
                 (format "<span style=\"color:%s;\">%s</span>" yellow (html-escape line)))
                ('term-red
                 (format "<span style=\"color:%s;\">%s</span>" red (html-escape line)))
                (_
                 (format "<span style=\"color:%s;\">%s</span>" fg-main (html-escape line))))))
        (push (format "<div class=\"term-line\">%s</div>" (if (string-empty-p line) "&nbsp;" line-html)) html)))
    (mapconcat #'identity (nreverse html) "\n")))

(defun generate-git-diff-html (theme-variant)
  (let* ((p (if (eq theme-variant 'dark) geist-dark-palette geist-light-palette))
         (fg-main (geist--c 'fg-main p))
         (fg-dim (geist--c 'fg-dim p))
         (green (geist--c 'green p))
         (green-bg (geist--c 'green-bg p))
         (red (geist--c 'red p))
         (red-bg (geist--c 'red-bg p))
         (blue (geist--c 'blue-bright p))
         (diff-lines
          `(("diff --git a/geist.el b/geist.el" . header)
            ("index 4f82a1b..89c4ef0 100644" . header)
            ("@@ -18,6 +18,8 @@" . hunk)
            (" (defcustom geist-cursor-color 'blue" . context)
            ("   \"Cursor color style.\"" . context)
            ("-  :type '(choice (const blue) (const fg)))" . removed)
            ("+  :type '(choice (const :tag \"Vercel Blue\" blue)" . added)
            ("+                 (const :tag \"Pure White\" white)" . added)
            ("+                 (const :tag \"Match Foreground\" fg)))" . added)
            ("   :group 'geist)" . context))))
    (mapconcat
     (lambda (item)
       (let* ((line (car item))
              (type (cdr item)))
         (pcase type
           ('header (format "<div style=\"color:%s; font-weight:600;\">%s</div>" fg-dim (html-escape line)))
           ('hunk (format "<div style=\"color:%s; font-weight:700;\">%s</div>" blue (html-escape line)))
           ('added (format "<div style=\"color:%s; background-color:%s; font-weight:600;\">%s</div>" green green-bg (html-escape line)))
           ('removed (format "<div style=\"color:%s; background-color:%s;\">%s</div>" red red-bg (html-escape line)))
           (_ (format "<div style=\"color:%s;\">%s</div>" fg-dim (html-escape line))))))
     diff-lines "\n")))

(defun render-full-theme-html (theme-variant out-path)
  "Render a complete Emacs IDE window screenshot in HTML for THEME-VARIANT."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme (if (eq theme-variant 'dark) 'geist-dark 'geist-light) t)

  (let* ((p (if (eq theme-variant 'dark) geist-dark-palette geist-light-palette))
         (bg-main (geist--c 'bg-main p))
         (bg-alt (geist--c 'bg-alt p))
         (bg-surface (geist--c 'bg-surface p))
         (bg-surface-active (geist--c 'bg-surface-active p))
         (bg-modeline (geist--c 'bg-modeline p))
         (bg-highlight (geist--c 'bg-highlight p))
         (border-main (geist--c 'border-main p))
         (border-subtle (geist--c 'border-subtle p))
         (border-focus (geist--c 'border-focus p))
         (fg-main (geist--c 'fg-main p))
         (fg-alt (geist--c 'fg-alt p))
         (fg-dim (geist--c 'fg-dim p))
         (fg-muted (geist--c 'fg-muted p))
         (blue (geist--c 'blue p))
         (blue-bright (geist--c 'blue-bright p))
         (pink (geist--c 'pink p))
         (green (geist--c 'green p))
         (yellow (geist--c 'yellow p))
         (cursor-color (geist--cursor-hex theme-variant p))

         ;; Fontify TypeScript code in a temporary buffer
         (code-buf (generate-new-buffer "route.ts"))
         (_ (with-current-buffer code-buf
              (insert sample-typescript-code)
              (typescript-ts-mode)
              (font-lock-ensure)))
         (code-lines (buffer-to-html-lines code-buf 18 '(18 . 49)))
         (terminal-html (generate-terminal-html theme-variant))
         (diff-html (generate-git-diff-html theme-variant)))

    (with-temp-file out-path
      (insert (format "<!DOCTYPE html>
<html lang=\"en\">
<head>
<meta charset=\"utf-8\">
<title>Geist %s - Emacs Preview</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background-color: %s;
    font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 13.5px;
    line-height: 1.55;
    color: %s;
    padding: 32px;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
  }
  .window-frame {
    width: 1380px;
    background-color: %s;
    border: 1px solid %s;
    border-radius: 12px;
    box-shadow: %s;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }
  .titlebar {
    background-color: %s;
    border-bottom: 1px solid %s;
    height: 38px;
    display: flex;
    align-items: center;
    padding: 0 16px;
    user-select: none;
  }
  .traffic-lights {
    display: flex;
    gap: 8px;
  }
  .dot {
    width: 12px;
    height: 12px;
    border-radius: 50%%;
  }
  .dot-red { background: #ff5f56; }
  .dot-yellow { background: #ffbd2e; }
  .dot-green { background: #27c93f; }
  .titlebar-center {
    flex: 1;
    text-align: center;
    font-size: 12px;
    color: %s;
    font-weight: 500;
    letter-spacing: -0.2px;
    font-family: 'Geist', -apple-system, BlinkMacSystemFont, sans-serif;
  }
  .titlebar-center span {
    color: %s;
    font-weight: 600;
  }
  .tabbar {
    background-color: %s;
    border-bottom: 1px solid %s;
    display: flex;
    align-items: center;
    height: 32px;
    padding: 0 8px;
    gap: 4px;
    font-size: 12px;
  }
  .tab {
    padding: 4px 12px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    gap: 6px;
    color: %s;
  }
  .tab.active {
    background-color: %s;
    color: %s;
    font-weight: 600;
    border: 1px solid %s;
  }
  .split-container {
    display: flex;
    height: 720px;
    background-color: %s;
  }
  .pane-left {
    flex: 60;
    display: flex;
    flex-direction: column;
    border-right: 1px solid %s;
    background-color: %s;
  }
  .pane-right {
    flex: 40;
    display: flex;
    flex-direction: column;
    background-color: %s;
  }
  .editor-content {
    flex: 1;
    overflow: hidden;
    padding: 8px 0;
  }
  .line-row {
    display: flex;
    padding: 0 16px;
    height: 19.5px;
    align-items: center;
  }
  .line-row.hl-line {
    background-color: %s;
  }
  .line-num {
    width: 38px;
    text-align: right;
    padding-right: 18px;
    color: %s;
    user-select: none;
    font-size: 12.5px;
  }
  .line-row.hl-line .line-num {
    color: %s;
    font-weight: 700;
  }
  .line-code {
    flex: 1;
    white-space: pre;
  }
  .cursor {
    background-color: %s !important;
    color: %s !important;
    border-radius: 1px;
  }
  .modeline {
    height: 26px;
    background-color: %s;
    border-top: 1px solid %s;
    border-bottom: 1px solid %s;
    display: flex;
    align-items: center;
    padding: 0 14px;
    font-size: 11.5px;
    color: %s;
    justify-content: space-between;
    user-select: none;
  }
  .modeline-left, .modeline-right {
    display: flex;
    align-items: center;
    gap: 12px;
  }
  .modeline-name {
    color: %s;
    font-weight: 700;
  }
  .modeline-badge {
    color: %s;
    font-weight: 600;
  }
  .terminal-pane {
    flex: 55;
    border-bottom: 1px solid %s;
    display: flex;
    flex-direction: column;
    background-color: %s;
  }
  .terminal-header {
    height: 26px;
    background-color: %s;
    border-bottom: 1px solid %s;
    display: flex;
    align-items: center;
    padding: 0 12px;
    font-size: 11px;
    color: %s;
    font-weight: 600;
    justify-content: space-between;
  }
  .terminal-body {
    flex: 1;
    padding: 12px 14px;
    overflow: hidden;
    font-size: 12.5px;
    line-height: 1.5;
  }
  .term-line {
    white-space: pre-wrap;
    min-height: 19px;
  }
  .diff-pane {
    flex: 45;
    display: flex;
    flex-direction: column;
    background-color: %s;
  }
  .diff-body {
    flex: 1;
    padding: 10px 14px;
    overflow: hidden;
    font-size: 12px;
    line-height: 1.5;
  }
  .minibuffer {
    height: 30px;
    background-color: %s;
    border-top: 1px solid %s;
    display: flex;
    align-items: center;
    padding: 0 16px;
    font-size: 12px;
    color: %s;
  }
  .minibuffer-prompt {
    color: %s;
    font-weight: 700;
    margin-right: 8px;
  }
</style>
</head>
<body>

<div class=\"window-frame\">
  <!-- Titlebar -->
  <div class=\"titlebar\">
    <div class=\"traffic-lights\">
      <div class=\"dot dot-red\"></div>
      <div class=\"dot dot-yellow\"></div>
      <div class=\"dot dot-green\"></div>
    </div>
    <div class=\"titlebar-center\">
      <span>geist-%s</span> — app/api/deploy/route.ts — GNU Emacs 31
    </div>
  </div>

  <!-- Buffer Tabs -->
  <div class=\"tabbar\">
    <div class=\"tab active\">
      <span>📄</span> route.ts
    </div>
    <div class=\"tab\">
      <span>⚙️</span> telemetry.ts
    </div>
    <div class=\"tab\">
      <span>▲</span> *vterm*
    </div>
    <div class=\"tab\">
      <span>🔀</span> Magit: main
    </div>
  </div>

  <!-- Main Window Split -->
  <div class=\"split-container\">
    <!-- Left Pane: TypeScript Code -->
    <div class=\"pane-left\">
      <div class=\"editor-content\">
%s
      </div>
      <div class=\"modeline\">
        <div class=\"modeline-left\">
          <span style=\"color:%s; font-weight:700;\">▲ main</span>
          <span class=\"modeline-name\">route.ts</span>
          <span>(18, 49)</span>
          <span>Top</span>
        </div>
        <div class=\"modeline-right\">
          <span class=\"modeline-badge\">TSX [Geist]</span>
          <span>UTF-8</span>
          <span style=\"color:%s;\">● L18</span>
        </div>
      </div>
    </div>

    <!-- Right Pane: Terminal & Magit Diff -->
    <div class=\"pane-right\">
      <!-- Terminal View -->
      <div class=\"terminal-pane\">
        <div class=\"terminal-header\">
          <span>▲ *vterm: production*</span>
          <span style=\"color:%s;\">● live</span>
        </div>
        <div class=\"terminal-body\">
%s
        </div>
      </div>

      <!-- Magit / Diff View -->
      <div class=\"diff-pane\">
        <div class=\"terminal-header\">
          <span>🔀 Magit: unstaged changes (1 file)</span>
          <span style=\"color:%s;\">HEAD -&gt; main</span>
        </div>
        <div class=\"diff-body\">
%s
        </div>
      </div>
    </div>
  </div>

  <!-- Minibuffer -->
  <div class=\"minibuffer\">
    <span class=\"minibuffer-prompt\">M-x</span>
    <span>vercel-deploy-production</span>
    <span class=\"cursor\">&nbsp;</span>
  </div>
</div>

</body>
</html>"
              (capitalize (symbol-name theme-variant))
              (if (eq theme-variant 'dark) "#0a0a0a" "#e8e8e8")
              fg-main
              bg-main
              border-main
              (if (eq theme-variant 'dark)
                  "0 30px 80px rgba(0,0,0,0.9), 0 0 0 1px #222222"
                "0 24px 60px rgba(0,0,0,0.12), 0 0 0 1px #eaeaea")
              bg-alt
              border-main
              fg-dim
              fg-main
              bg-alt
              border-main
              fg-dim
              bg-main
              fg-main
              border-main
              bg-main
              border-main
              bg-main
              bg-alt
              bg-highlight
              fg-muted
              fg-main
              cursor-color
              bg-main
              bg-modeline
              border-main
              border-main
              fg-dim
              fg-main
              blue-bright
              border-main
              bg-main
              bg-alt
              border-main
              fg-dim
              bg-alt
              bg-alt
              border-main
              fg-dim
              blue-bright
              (symbol-name theme-variant)
              (mapconcat
               (lambda (row)
                 (let ((num (nth 0 row))
                       (content (nth 1 row))
                       (is-hl (nth 2 row)))
                   (format "<div class=\"line-row%s\"><div class=\"line-num\">%d</div><div class=\"line-code\">%s</div></div>"
                           (if is-hl " hl-line" "") num content)))
               code-lines "\n")
              blue-bright
              green
              green
              terminal-html
              blue-bright
              diff-html)))
    (kill-buffer code-buf)
    (message "Generated HTML preview for %s at %s" theme-variant out-path)))

(defun render-completion-html (variant out-path)
  "Render a preview focused on completion UIs for VARIANT (`dark' or `light')."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme (if (eq variant 'dark) 'geist-dark 'geist-light) t)
  (let* ((p (if (eq variant 'dark) geist-dark-palette geist-light-palette))
         (bg-main (geist--c 'bg-main p))
         (bg-alt (geist--c 'bg-alt p))
         (bg-surface (geist--c 'bg-surface p))
         (bg-surface-active (geist--c 'bg-surface-active p))
         (border-main (geist--c 'border-main p))
         (border-focus (geist--c 'border-focus p))
         (fg-main (geist--c 'fg-main p))
         (fg-alt (geist--c 'fg-alt p))
         (fg-dim (geist--c 'fg-dim p))
         (blue-bright (geist--c 'blue-bright p))
         (pink (geist--c 'pink p))
         (purple (geist--c 'purple-bright p))
         (cyan (geist--c 'cyan p))
         (green (geist--c 'green p))
         (orange (geist--c 'orange p)))
    (with-temp-file out-path
      (insert (format "<!DOCTYPE html>
<html>
<head>
<meta charset=\"utf-8\">
<title>Geist %s - Completion UI</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background-color: %s;
    font-family: 'Geist Mono', monospace;
    font-size: 13.5px;
    line-height: 1.5;
    color: %s;
    padding: 32px;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
  }
  .window {
    width: 1100px;
    background: %s;
    border: 1px solid %s;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: %s;
  }
  .titlebar {
    background: %s;
    border-bottom: 1px solid %s;
    height: 38px;
    display: flex;
    align-items: center;
    padding: 0 16px;
    font-size: 12px;
  }
  .lights { display: flex; gap: 8px; margin-right: 20px; }
  .dot { width: 12px; height: 12px; border-radius: 50%%; }
  .editor {
    position: relative;
    padding: 20px 24px;
    height: 420px;
    background: %s;
  }
  .code-line {
    height: 22px;
    line-height: 22px;
    white-space: pre;
    font-size: 13px;
  }
  .corfu-popup {
    position: absolute;
    top: 140px;
    left: 230px;
    background: %s;
    border: 1px solid %s;
    border-radius: 8px;
    box-shadow: %s;
    width: 380px;
    overflow: hidden;
    font-size: 13px;
    z-index: 10;
  }
  .corfu-item {
    display: flex;
    justify-content: space-between;
    padding: 6px 12px;
    align-items: center;
  }
  .corfu-item.active {
    background: %s;
    color: %s;
    font-weight: 600;
  }
  .corfu-item .kind {
    font-size: 11px;
    color: %s;
    font-weight: 500;
  }
  .corfu-item.active .kind {
    color: %s;
  }
  .vertico-box {
    border-top: 1px solid %s;
    background: %s;
    padding: 12px 18px;
  }
  .vertico-prompt {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 10px;
    font-weight: 600;
  }
  .vertico-row {
    display: flex;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12.5px;
    align-items: center;
  }
  .vertico-row.selected {
    background: %s;
    font-weight: 600;
  }
  .vertico-name { width: 260px; color: %s; }
  .vertico-row.selected .vertico-name { color: %s; }
  .vertico-meta { flex: 1; color: %s; font-size: 11.5px; }
  .vertico-key { color: %s; font-weight: 600; width: 90px; }
</style>
</head>
<body>

<div class=\"window\">
  <div class=\"titlebar\">
    <div class=\"lights\">
      <div class=\"dot\" style=\"background:#ff5f56;\"></div>
      <div class=\"dot\" style=\"background:#ffbd2e;\"></div>
      <div class=\"dot\" style=\"background:#27c93f;\"></div>
    </div>
    <div style=\"color:%s; font-weight:600;\">geist-%s — Completion & Diagnostics (Corfu + Vertico + Marginalia)</div>
  </div>

  <div class=\"editor\">
    <div class=\"code-line\"><span style=\"color:%s; font-weight:600;\">import</span> { NextRequest, NextResponse } <span style=\"color:%s; font-weight:600;\">from</span> <span style=\"color:%s;\">\"next/server\"</span>;</div>
    <div class=\"code-line\"><span style=\"color:%s; font-weight:600;\">import</span> { kv } <span style=\"color:%s; font-weight:600;\">from</span> <span style=\"color:%s;\">\"@vercel/kv\"</span>;</div>
    <div class=\"code-line\">&nbsp;</div>
    <div class=\"code-line\"><span style=\"color:%s; font-weight:600;\">export async function</span> <span style=\"color:%s; font-weight:600;\">GET</span>(req: <span style=\"color:%s;\">NextRequest</span>) {</div>
    <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:%s; font-weight:600;\">const</span> telemetry = <span style=\"color:%s; font-weight:600;\">await</span> kv.<span style=\"text-decoration:underline;\">hget</span></div>
    <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:%s; font-weight:600;\">return</span> NextResponse.json({ ok: <span style=\"color:%s;\">true</span> });</div>
    <div class=\"code-line\">}</div>

    <!-- Corfu Autocomplete Popup -->
    <div class=\"corfu-popup\">
      <div class=\"corfu-item active\">
        <span><span style=\"color:%s; font-weight:700;\">hget</span>all&lt;T&gt;(key: string)</span>
        <span class=\"kind\">Method [Vercel KV]</span>
      </div>
      <div class=\"corfu-item\">
        <span><span style=\"color:%s;\">hget</span>&lt;T&gt;(key: string, field: string)</span>
        <span class=\"kind\">Method</span>
      </div>
      <div class=\"corfu-item\">
        <span><span style=\"color:%s;\">hset</span>&lt;T&gt;(key: string, obj: object)</span>
        <span class=\"kind\">Method</span>
      </div>
      <div class=\"corfu-item\">
        <span><span style=\"color:%s;\">hdel</span>(key: string, ...fields: string[])</span>
        <span class=\"kind\">Method</span>
      </div>
      <div class=\"corfu-item\">
        <span><span style=\"color:%s;\">hlen</span>(key: string)</span>
        <span class=\"kind\">Method</span>
      </div>
    </div>
  </div>

  <!-- Vertico + Marginalia Completion Area -->
  <div class=\"vertico-box\">
    <div class=\"vertico-prompt\">
      <span style=\"color:%s; font-weight:700;\">▲ Find file or command:</span>
      <span style=\"color:%s;\">deploy</span>
      <span style=\"background:%s; color:%s; padding:0 2px;\">&nbsp;</span>
      <span style=\"color:%s; font-size:11px; margin-left:auto;\">3 of 28 matches</span>
    </div>

    <div class=\"vertico-row selected\">
      <span class=\"vertico-key\">C-c d p</span>
      <span class=\"vertico-name\">vercel-deploy-production</span>
      <span class=\"vertico-meta\">Deploy current edge project directly to Vercel production</span>
    </div>
    <div class=\"vertico-row\">
      <span class=\"vertico-key\">C-c d v</span>
      <span class=\"vertico-name\">vercel-deploy-preview</span>
      <span class=\"vertico-meta\">Create instant isolated preview URL</span>
    </div>
    <div class=\"vertico-row\">
      <span class=\"vertico-key\">C-c d l</span>
      <span class=\"vertico-name\">vercel-tail-logs</span>
      <span class=\"vertico-meta\">Stream live edge runtime logs from 18 regions</span>
    </div>
  </div>
</div>

</body>
</html>"
              (capitalize (symbol-name variant))
              (if (eq variant 'dark) "#0a0a0a" "#e8e8e8")
              fg-main
              bg-main
              border-main
              (if (eq variant 'dark)
                  "0 30px 80px rgba(0,0,0,0.9), 0 0 0 1px #222222"
                "0 24px 60px rgba(0,0,0,0.12), 0 0 0 1px #eaeaea")
              bg-alt
              border-main
              bg-main
              bg-surface
              border-focus
              (if (eq variant 'dark)
                  "0 16px 36px rgba(0,0,0,0.8), 0 0 0 1px #333333"
                "0 16px 36px rgba(0,0,0,0.1), 0 0 0 1px #eaeaea")
              bg-surface-active
              fg-main
              fg-dim
              blue-bright
              border-main
              bg-alt
              bg-surface-active
              fg-main
              fg-main
              fg-dim
              pink
              fg-main
              (symbol-name variant)
              pink pink cyan
              pink pink cyan
              pink blue-bright purple
              pink pink
              pink cyan
              blue-bright
              blue-bright
              blue-bright
              blue-bright
              blue-bright
              blue-bright
              fg-main
              blue-bright
              bg-main
              fg-dim)))))

(defun render-comparison-html (out-path)
  "Render a side-by-side comparison banner of Geist Dark and Geist Light."
  (let* ((p-dark geist-dark-palette)
         (p-light geist-light-palette))
    (with-temp-file out-path
      (insert (format "<!DOCTYPE html>
<html>
<head>
<meta charset=\"utf-8\">
<title>Geist Dark vs Geist Light Comparison</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background-color: #050505;
    font-family: 'Geist Mono', monospace;
    font-size: 13px;
    line-height: 1.5;
    padding: 32px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 24px;
  }
  .header-banner {
    text-align: center;
    margin-bottom: 8px;
  }
  .header-banner h1 {
    font-family: 'Geist', -apple-system, sans-serif;
    color: #ffffff;
    font-size: 26px;
    font-weight: 700;
    letter-spacing: -0.5px;
    margin-bottom: 6px;
  }
  .header-banner p {
    color: #888888;
    font-size: 14px;
    font-family: 'Geist', -apple-system, sans-serif;
  }
  .comparison-grid {
    display: flex;
    gap: 24px;
    width: 1420px;
  }
  .card {
    flex: 1;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 24px 60px rgba(0,0,0,0.6);
  }
  .card-dark {
    background: #000000;
    border: 1px solid #2a2a2a;
    color: #ededed;
  }
  .card-light {
    background: #ffffff;
    border: 1px solid #eaeaea;
    color: #171717;
  }
  .card-header {
    height: 38px;
    display: flex;
    align-items: center;
    padding: 0 16px;
    font-weight: 600;
    font-size: 12.5px;
  }
  .card-dark .card-header {
    background: #0a0a0a;
    border-bottom: 1px solid #222222;
    color: #ededed;
  }
  .card-light .card-header {
    background: #fafafa;
    border-bottom: 1px solid #eaeaea;
    color: #171717;
  }
  .code-body {
    padding: 16px 20px;
    height: 480px;
  }
  .code-line {
    height: 22px;
    white-space: pre;
  }
  .terminal-box {
    margin-top: 14px;
    padding: 12px 14px;
    border-radius: 6px;
    font-size: 12px;
    line-height: 1.5;
  }
  .card-dark .terminal-box {
    background: #080808;
    border: 1px solid #1f1f1f;
  }
  .card-light .terminal-box {
    background: #fafafa;
    border: 1px solid #eaeaea;
  }
</style>
</head>
<body>

<div class=\"header-banner\">
  <h1>▲ Vercel Geist Theme for GNU Emacs</h1>
  <p>Engineered for Geist and Geist Mono typography with pixel-precise contrast</p>
</div>

<div class=\"comparison-grid\">
  <!-- Dark Mode Card -->
  <div class=\"card card-dark\">
    <div class=\"card-header\">
      <span style=\"color:#0070f3; font-weight:700; margin-right:8px;\">▲</span>
      <span>geist-dark — OLED Pitch Black (#000000)</span>
    </div>
    <div class=\"code-body\">
      <div class=\"code-line\"><span style=\"color:#ff0080; font-weight:600;\">export async function</span> <span style=\"color:#3291ff; font-weight:600;\">handler</span>(req: <span style=\"color:#bf7af0;\">Request</span>) {</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#737373; font-style:italic;\">// Verify HMAC signature from Vercel Edge</span></div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#ff0080; font-weight:600;\">const</span> secret = process.env.EDGE_SECRET;</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#ff0080; font-weight:600;\">if</span> (!secret) {</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color:#ff0080; font-weight:600;\">throw new</span> <span style=\"color:#bf7af0;\">Error</span>(<span style=\"color:#50e3c2;\">\"Missing edge secret\"</span>);</div>
      <div class=\"code-line\">&nbsp;&nbsp;}</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#ff0080; font-weight:600;\">const</span> stats = <span style=\"color:#ff0080; font-weight:600;\">await</span> <span style=\"color:#3291ff;\">collectTelemetry</span>({</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;region: <span style=\"color:#50e3c2;\">\"iad1\"</span>,</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;latency: <span style=\"color:#ff8024;\">18</span>,</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;cached: <span style=\"color:#50e3c2;\">true</span>,</div>
      <div class=\"code-line\">&nbsp;&nbsp;});</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#ff0080; font-weight:600;\">return</span> Response.json(stats);</div>
      <div class=\"code-line\">}</div>

      <div class=\"terminal-box\">
        <div><span style=\"color:#3291ff; font-weight:700;\">▲</span> <span style=\"font-weight:600;\">vercel deploy --prod</span></div>
        <div style=\"color:#00df89; font-weight:600;\">✅ Production: https://geistmacs.vercel.app [1.8s]</div>
        <div style=\"color:#737373;\">⚡ Deployed to 18 regions (Next.js 15, Node 22)</div>
        <div style=\"color:#00df89; margin-top:4px;\">PASS tests/geist-palette.test.ts (24 tests, 0 fails)</div>
      </div>
    </div>
  </div>

  <!-- Light Mode Card -->
  <div class=\"card card-light\">
    <div class=\"card-header\">
      <span style=\"color:#0068d6; font-weight:700; margin-right:8px;\">▲</span>
      <span>geist-light — Paper Crisp White (#ffffff)</span>
    </div>
    <div class=\"code-body\">
      <div class=\"code-line\"><span style=\"color:#be185d; font-weight:600;\">export async function</span> <span style=\"color:#0068d6; font-weight:600;\">handler</span>(req: <span style=\"color:#6d28d9;\">Request</span>) {</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#888888; font-style:italic;\">// Verify HMAC signature from Vercel Edge</span></div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#be185d; font-weight:600;\">const</span> secret = process.env.EDGE_SECRET;</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#be185d; font-weight:600;\">if</span> (!secret) {</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color:#be185d; font-weight:600;\">throw new</span> <span style=\"color:#6d28d9;\">Error</span>(<span style=\"color:#059669;\">\"Missing edge secret\"</span>);</div>
      <div class=\"code-line\">&nbsp;&nbsp;}</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#be185d; font-weight:600;\">const</span> stats = <span style=\"color:#be185d; font-weight:600;\">await</span> <span style=\"color:#0068d6;\">collectTelemetry</span>({</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;region: <span style=\"color:#059669;\">\"iad1\"</span>,</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;latency: <span style=\"color:#c2410c;\">18</span>,</div>
      <div class=\"code-line\">&nbsp;&nbsp;&nbsp;&nbsp;cached: <span style=\"color:#059669;\">true</span>,</div>
      <div class=\"code-line\">&nbsp;&nbsp;});</div>
      <div class=\"code-line\">&nbsp;&nbsp;<span style=\"color:#be185d; font-weight:600;\">return</span> Response.json(stats);</div>
      <div class=\"code-line\">}</div>

      <div class=\"terminal-box\">
        <div><span style=\"color:#0068d6; font-weight:700;\">▲</span> <span style=\"font-weight:600;\">vercel deploy --prod</span></div>
        <div style=\"color:#059669; font-weight:600;\">✅ Production: https://geistmacs.vercel.app [1.8s]</div>
        <div style=\"color:#888888;\">⚡ Deployed to 18 regions (Next.js 15, Node 22)</div>
        <div style=\"color:#059669; margin-top:4px;\">PASS tests/geist-palette.test.ts (24 tests, 0 fails)</div>
      </div>
    </div>
  </div>
</div>

</body>
</html>")))))

(defun run-all-previews ()
  (make-directory "screenshots" t)
  (make-directory "preview" t)
  (render-full-theme-html 'dark "preview/geist-dark-preview.html")
  (render-full-theme-html 'light "preview/geist-light-preview.html")
  (render-completion-html 'dark "preview/geist-completion-dark-preview.html")
  (render-completion-html 'light "preview/geist-completion-light-preview.html")
  (render-comparison-html "preview/geist-comparison-preview.html"))

(run-all-previews)

