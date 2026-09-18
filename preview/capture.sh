#!/usr/bin/env bash
set -euo pipefail

# Find Chromium/Brave binary
BROWSER=""
if [ -f "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" ]; then
  BROWSER="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
elif [ -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
  BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
elif command -v brave >/dev/null 2>&1; then
  BROWSER="$(command -v brave)"
elif command -v chromium >/dev/null 2>&1; then
  BROWSER="$(command -v chromium)"
fi

if [ -z "$BROWSER" ]; then
  echo "Error: Chromium-based browser not found for screenshots."
  exit 1
fi

take_screenshot() {
  local html_file="$1"
  local output_png="$2"
  local width="${3:-1460}"
  local height="${4:-940}"

  "$BROWSER" \
    --headless=new \
    --disable-gpu \
    --hide-scrollbars \
    --window-size="${width},${height}" \
    --screenshot="${output_png}" \
    "file://${html_file}" >/dev/null 2>&1
  echo "✓ Saved ${output_png} (${width}x${height})"
}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Generating HTML preview buffers via Emacs..."
emacs -Q --batch -L "$DIR" -l "$DIR/preview/render-preview.el" >/dev/null 2>&1

echo "Capturing high-resolution screenshots with ${BROWSER##*/}..."
take_screenshot "$DIR/preview/geist-dark-preview.html" "$DIR/screenshots/geist-dark.png" 1460 940
take_screenshot "$DIR/preview/geist-light-preview.html" "$DIR/screenshots/geist-light.png" 1460 940
take_screenshot "$DIR/preview/geist-completion-dark-preview.html" "$DIR/screenshots/geist-completion-dark.png" 1200 680
take_screenshot "$DIR/preview/geist-completion-light-preview.html" "$DIR/screenshots/geist-completion-light.png" 1200 680
take_screenshot "$DIR/preview/geist-comparison-preview.html" "$DIR/screenshots/geist-comparison.png" 1520 780

echo "All screenshots generated successfully!"
