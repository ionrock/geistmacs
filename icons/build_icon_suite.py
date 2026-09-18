#!/usr/bin/env python3
"""
Complete Geistmacs Icon Suite Generator
Generates:
1. Dark Mode macOS App Icon (SVG, PNG at 16, 32, 64, 128, 256, 512, 1024)
2. Light Mode macOS App Icon (SVG, PNG at 512)
3. Standalone Mark Dark (SVG, transparent background)
4. Standalone Mark Light (SVG, transparent background)
5. Standalone Mark Monochrome (SVG)
6. macOS .icns bundle via iconutil
7. Favicon SVG for web
"""

import os
import shutil
import subprocess

# Standard macOS squircle continuous curve path for 1024x1024 canvas (Apple HIG standard)
# Centers an 824x824 icon inside 100px padding
def macos_squircle_path(inset=100, size=824, radius=185):
    x0, y0 = inset, inset
    x1, y1 = inset + size, inset + size
    r = radius
    return f"""M {x0+r} {y0}
               L {x1-r} {y0}
               C {x1-r/3} {y0}, {x1} {y0+r/3}, {x1} {y0+r}
               L {x1} {y1-r}
               C {x1} {y1-r/3}, {x1-r/3} {y1}, {x1-r} {y1}
               L {x0+r} {y1}
               C {x0+r/3} {y1}, {x0} {y1-r/3}, {x0} {y1-r}
               L {x0} {y0+r}
               C {x0} {y0+r/3}, {x0+r/3} {y0}, {x0+r} {y0} Z"""

# Precise Delta-E polygon coordinates (Equilateral 60° triangle container, 552 base x 478 height)
POLY_DELTA_E = """
  M 512 238
  L 604 398
  L 508 398
  L 468 466
  L 600 466
  L 640 504
  L 600 542
  L 424 542
  L 384 612
  L 728 612
  L 788 716
  L 236 716
  Z
"""

# ============================================================================
# DARK MODE APP ICON SVG
# ============================================================================
def build_dark_icon_svg():
    squircle = macos_squircle_path()
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <defs>
    <!-- macOS System App Icon Drop Shadow -->
    <filter id="app-shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="16" stdDeviation="24" flood-color="#000000" flood-opacity="0.6"/>
      <feDropShadow dx="0" dy="36" stdDeviation="48" flood-color="#000000" flood-opacity="0.5"/>
    </filter>

    <!-- Base Obsidian Background Gradient -->
    <radialGradient id="base-bg-dark" cx="50%" cy="30%" r="80%">
      <stop offset="0%" stop-color="#161619"/>
      <stop offset="60%" stop-color="#08080a"/>
      <stop offset="100%" stop-color="#000000"/>
    </radialGradient>

    <!-- Signature Vercel Conic Ambient Glow -->
    <radialGradient id="vercel-glow" cx="50%" cy="50%" r="56%">
      <stop offset="0%" stop-color="#0070f3" stop-opacity="0.44"/>
      <stop offset="35%" stop-color="#7928ca" stop-opacity="0.30"/>
      <stop offset="70%" stop-color="#ff0080" stop-opacity="0.14"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </radialGradient>

    <!-- Spectral Vercel Prism: Cyan -> Blue -> Purple -> Pink -->
    <linearGradient id="spectral-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#50e3c2"/>
      <stop offset="28%" stop-color="#0070f3"/>
      <stop offset="68%" stop-color="#7928ca"/>
      <stop offset="100%" stop-color="#ff0080"/>
    </linearGradient>

    <!-- Titanium Metal Gradient for Foreground Glyph -->
    <linearGradient id="titanium" x1="20%" y1="0%" x2="80%" y2="100%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="65%" stop-color="#f5f5f7"/>
      <stop offset="100%" stop-color="#d8d8de"/>
    </linearGradient>

    <!-- App Squircle Border Highlight -->
    <linearGradient id="squircle-border-dark" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff" stop-opacity="0.25"/>
      <stop offset="40%" stop-color="#ffffff" stop-opacity="0.08"/>
      <stop offset="100%" stop-color="#ffffff" stop-opacity="0.02"/>
    </linearGradient>
  </defs>

  <rect width="1024" height="1024" fill="none"/>

  <!-- macOS App Icon Base -->
  <g filter="url(#app-shadow)">
    <path d="{squircle}" fill="url(#base-bg-dark)"/>
    <path d="{squircle}" fill="none" stroke="url(#squircle-border-dark)" stroke-width="2.5"/>
  </g>

  <!-- Ambient Electric Glow behind glyph -->
  <circle cx="512" cy="512" r="320" fill="url(#vercel-glow)" style="mix-blend-mode: screen;"/>

  <!-- Blueprint Engineering Guides (Vercel Precision Aesthetic) -->
  <g opacity="0.05" stroke="#ffffff" stroke-width="1">
    <circle cx="512" cy="512" r="280" fill="none"/>
    <circle cx="512" cy="512" r="180" fill="none"/>
    <line x1="512" y1="160" x2="512" y2="864"/>
    <line x1="160" y1="512" x2="864" y2="512"/>
  </g>

  <!-- Master Geistmacs Delta-E Glyph -->
  <g id="geistmacs-glyph" transform="translate(0, -6)" filter="drop-shadow(0 24px 44px rgba(0,0,0,0.9))">
    <!-- Ambient aura outline -->
    <polygon points="512,228 226,724 798,724" fill="none" stroke="url(#spectral-grad)" stroke-width="16" opacity="0.45" filter="blur(18px)"/>

    <!-- Base titanium body -->
    <path d="{POLY_DELTA_E}"
          fill="url(#titanium)"
          stroke="rgba(255,255,255,0.4)"
          stroke-width="1.5"/>

    <!-- Subtle spectral iridescent prism overlay on lower facet -->
    <g opacity="0.26" style="mix-blend-mode: overlay;">
      <path d="{POLY_DELTA_E}" fill="url(#spectral-grad)"/>
    </g>

    <!-- Razor sharp specular rim along 60° left spine -->
    <line x1="512" y1="238" x2="236" y2="716" stroke="#ffffff" stroke-width="3" stroke-linecap="round"/>
    <!-- Specular rim along base -->
    <line x1="236" y1="716" x2="788" y2="716" stroke="#ffffff" stroke-opacity="0.3" stroke-width="2"/>

    <!-- Inner neon bevel highlights on horizontal bays -->
    <line x1="504" y1="398" x2="604" y2="398" stroke="url(#spectral-grad)" stroke-width="3"/>
    <line x1="380" y1="612" x2="728" y2="612" stroke="url(#spectral-grad)" stroke-width="3"/>

    <!-- Middle arm chevron accent (prompt / forward arrow) -->
    <polygon points="640,504 600,474 600,534" fill="url(#spectral-grad)" filter="drop-shadow(0 2px 8px rgba(0, 112, 243, 0.6))"/>

    <!-- Apex laser pinpoint in Geist Mint/Cyan -->
    <circle cx="512" cy="238" r="4.5" fill="#50e3c2" filter="drop-shadow(0 0 8px #50e3c2)"/>
  </g>
</svg>"""

# ============================================================================
# LIGHT MODE APP ICON SVG
# ============================================================================
def build_light_icon_svg():
    squircle = macos_squircle_path()
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <defs>
    <!-- macOS System App Icon Drop Shadow (Light mode) -->
    <filter id="app-shadow-light" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="16" stdDeviation="24" flood-color="#000000" flood-opacity="0.12"/>
      <feDropShadow dx="0" dy="36" stdDeviation="48" flood-color="#000000" flood-opacity="0.08"/>
    </filter>

    <!-- Paper White Base Gradient -->
    <radialGradient id="base-bg-light" cx="50%" cy="30%" r="80%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="70%" stop-color="#f8f8f9"/>
      <stop offset="100%" stop-color="#eeeeef"/>
    </radialGradient>

    <!-- Subtle Light Mode Radial Glow -->
    <radialGradient id="light-ambient-glow" cx="50%" cy="50%" r="55%">
      <stop offset="0%" stop-color="#0070f3" stop-opacity="0.12"/>
      <stop offset="50%" stop-color="#7928ca" stop-opacity="0.08"/>
      <stop offset="100%" stop-color="#ffffff" stop-opacity="0"/>
    </radialGradient>

    <!-- Obsidian Charcoal Glyph Gradient for Light Mode -->
    <linearGradient id="obsidian-glyph" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#111113"/>
      <stop offset="70%" stop-color="#18181b"/>
      <stop offset="100%" stop-color="#27272a"/>
    </linearGradient>

    <!-- Spectral Gradient for Accents -->
    <linearGradient id="spectral-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0070f3"/>
      <stop offset="50%" stop-color="#7928ca"/>
      <stop offset="100%" stop-color="#ff0080"/>
    </linearGradient>

    <!-- Light Squircle Hairline Border -->
    <linearGradient id="squircle-border-light" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#000000" stop-opacity="0.15"/>
      <stop offset="50%" stop-color="#000000" stop-opacity="0.08"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0.05"/>
    </linearGradient>
  </defs>

  <rect width="1024" height="1024" fill="none"/>

  <!-- macOS App Icon Base -->
  <g filter="url(#app-shadow-light)">
    <path d="{squircle}" fill="url(#base-bg-light)"/>
    <path d="{squircle}" fill="none" stroke="url(#squircle-border-light)" stroke-width="2"/>
  </g>

  <!-- Ambient Subtle Glow -->
  <circle cx="512" cy="512" r="300" fill="url(#light-ambient-glow)"/>

  <!-- Blueprint Guides -->
  <g opacity="0.04" stroke="#000000" stroke-width="1">
    <circle cx="512" cy="512" r="280" fill="none"/>
    <circle cx="512" cy="512" r="180" fill="none"/>
    <line x1="512" y1="160" x2="512" y2="864"/>
    <line x1="160" y1="512" x2="864" y2="512"/>
  </g>

  <!-- Master Geistmacs Delta-E Glyph (Light mode) -->
  <g id="geistmacs-glyph-light" transform="translate(0, -6)" filter="drop-shadow(0 18px 32px rgba(0,0,0,0.18))">
    <!-- Base obsidian body -->
    <path d="{POLY_DELTA_E}"
          fill="url(#obsidian-glyph)"
          stroke="rgba(0,0,0,0.15)"
          stroke-width="1.5"/>

    <!-- Subtle rim bevel -->
    <line x1="512" y1="238" x2="236" y2="716" stroke="rgba(255,255,255,0.4)" stroke-width="2" stroke-linecap="round"/>
    <line x1="236" y1="716" x2="788" y2="716" stroke="rgba(255,255,255,0.2)" stroke-width="1.5"/>

    <!-- Electric accent runner on middle arm -->
    <polygon points="640,504 600,474 600,534" fill="url(#spectral-grad)"/>

    <!-- Apex dot in electric blue -->
    <circle cx="512" cy="238" r="4.5" fill="#0070f3"/>
  </g>
</svg>"""

# ============================================================================
# STANDALONE VECTOR MARK (TRANSPARENT BACKGROUND)
# ============================================================================
def build_standalone_mark_dark_svg():
    # Centered in an exact 600x600 viewBox
    # Shifted: apex at (300, 75), base at y = 525, base from x = 40 to 560
    # Original apex (512, 238), dx = -212, dy = -163
    dx, dy = -212, -163
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 600" width="600" height="600">
  <defs>
    <linearGradient id="spectral-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#50e3c2"/>
      <stop offset="28%" stop-color="#0070f3"/>
      <stop offset="68%" stop-color="#7928ca"/>
      <stop offset="100%" stop-color="#ff0080"/>
    </linearGradient>

    <linearGradient id="titanium" x1="20%" y1="0%" x2="80%" y2="100%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="65%" stop-color="#f5f5f7"/>
      <stop offset="100%" stop-color="#d8d8de"/>
    </linearGradient>
  </defs>

  <g transform="translate({dx}, {dy})">
    <!-- Ambient aura outline -->
    <polygon points="512,228 226,724 798,724" fill="none" stroke="url(#spectral-grad)" stroke-width="14" opacity="0.5" filter="blur(16px)"/>

    <!-- Delta E Body -->
    <path d="{POLY_DELTA_E}"
          fill="url(#titanium)"
          stroke="rgba(255,255,255,0.4)"
          stroke-width="1.5"/>

    <g opacity="0.25" style="mix-blend-mode: overlay;">
      <path d="{POLY_DELTA_E}" fill="url(#spectral-grad)"/>
    </g>

    <!-- Specular edges -->
    <line x1="512" y1="238" x2="236" y2="716" stroke="#ffffff" stroke-width="3" stroke-linecap="round"/>
    <line x1="236" y1="716" x2="788" y2="716" stroke="#ffffff" stroke-opacity="0.3" stroke-width="2"/>

    <!-- Neon bay accents -->
    <line x1="504" y1="398" x2="604" y2="398" stroke="url(#spectral-grad)" stroke-width="3"/>
    <line x1="380" y1="612" x2="728" y2="612" stroke="url(#spectral-grad)" stroke-width="3"/>

    <!-- Middle arm chevron -->
    <polygon points="640,504 600,474 600,534" fill="url(#spectral-grad)"/>

    <!-- Apex dot -->
    <circle cx="512" cy="238" r="4.5" fill="#50e3c2"/>
  </g>
</svg>"""

# ============================================================================
# STANDALONE MONOCHROME SVG
# ============================================================================
def build_monochrome_svg():
    dx, dy = -212, -163
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 600" width="600" height="600">
  <g transform="translate({dx}, {dy})">
    <path d="{POLY_DELTA_E}" fill="currentColor"/>
    <polygon points="640,504 600,474 600,534" fill="currentColor"/>
  </g>
</svg>"""

# ============================================================================
# FAVICON SVG (optimized for 32x32 / small rendering)
# ============================================================================
def build_favicon_svg():
    # In a 32x32 viewBox, we want bold clarity
    return """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32">
  <rect width="32" height="32" rx="7" fill="#000000"/>
  <rect width="32" height="32" rx="7" fill="none" stroke="#2a2a2a" stroke-width="1"/>
  <!-- Scaled Delta-E mark -->
  <!-- Triangle from (16, 5) to (6, 26) to (26, 26) -->
  <path d="M 16 5
           L 20 12
           L 16 12
           L 14 15
           L 19.5 15
           L 21 17
           L 19.5 19
           L 13 19
           L 11 22
           L 24 22
           L 26 26
           L 6 26
           Z"
        fill="#ffffff"/>
  <polygon points="21,17 19.5,15.2 19.5,18.8" fill="#0070f3"/>
</svg>"""

def main():
    base_dir = "icons"
    os.makedirs(f"{base_dir}/png", exist_ok=True)
    os.makedirs(f"{base_dir}/svg", exist_ok=True)

    # 1. Write SVG files
    dark_svg = f"{base_dir}/svg/geistmacs-icon-dark.svg"
    light_svg = f"{base_dir}/svg/geistmacs-icon-light.svg"
    mark_dark_svg = f"{base_dir}/svg/geistmacs-mark-dark.svg"
    mark_mono_svg = f"{base_dir}/svg/geistmacs-mark-monochrome.svg"
    favicon_svg = f"{base_dir}/svg/favicon.svg"

    with open(dark_svg, "w") as f:
        f.write(build_dark_icon_svg())
    with open(light_svg, "w") as f:
        f.write(build_light_icon_svg())
    with open(mark_dark_svg, "w") as f:
        f.write(build_standalone_mark_dark_svg())
    with open(mark_mono_svg, "w") as f:
        f.write(build_monochrome_svg())
    with open(favicon_svg, "w") as f:
        f.write(build_favicon_svg())

    print("Wrote SVG assets.")

    # 2. Render multi-resolution PNGs
    resolutions = [16, 32, 64, 128, 256, 512, 1024]
    for res in resolutions:
        png_out = f"{base_dir}/png/geistmacs-{res}x{res}.png"
        subprocess.run(["rsvg-convert", "-w", str(res), "-h", str(res), dark_svg, "-o", png_out], check=True)
        print(f"Generated {png_out}")

    # Light mode preview at 512
    light_png = f"{base_dir}/png/geistmacs-light-512x512.png"
    subprocess.run(["rsvg-convert", "-w", "512", "-h", "512", light_svg, "-o", light_png], check=True)
    print(f"Generated {light_png}")

    # Standalone mark preview at 512
    mark_png = f"{base_dir}/png/geistmacs-mark-512x512.png"
    subprocess.run(["rsvg-convert", "-w", "512", "-h", "512", mark_dark_svg, "-o", mark_png], check=True)
    print(f"Generated {mark_png}")

    # Favicon PNG at 32x32
    fav_png = f"{base_dir}/png/favicon-32x32.png"
    subprocess.run(["rsvg-convert", "-w", "32", "-h", "32", favicon_svg, "-o", fav_png], check=True)
    print(f"Generated {fav_png}")

    # 3. Build macOS .iconset and compile to geistmacs.icns
    iconset_dir = f"{base_dir}/geistmacs.iconset"
    os.makedirs(iconset_dir, exist_ok=True)

    iconset_specs = [
        ("icon_16x16.png", 16),
        ("icon_16x16@2x.png", 32),
        ("icon_32x32.png", 32),
        ("icon_32x32@2x.png", 64),
        ("icon_128x128.png", 128),
        ("icon_128x128@2x.png", 256),
        ("icon_256x256.png", 256),
        ("icon_256x256@2x.png", 512),
        ("icon_512x512.png", 512),
        ("icon_512x512@2x.png", 1024),
    ]

    for fname, size in iconset_specs:
        out_p = os.path.join(iconset_dir, fname)
        subprocess.run(["rsvg-convert", "-w", str(size), "-h", str(size), dark_svg, "-o", out_p], check=True)

    # Run iconutil
    icns_path = f"{base_dir}/geistmacs.icns"
    subprocess.run(["iconutil", "-c", "icns", iconset_dir, "-o", icns_path], check=True)
    print(f"Generated macOS app icon: {icns_path}")

    # Clean up temporary iconset
    shutil.rmtree(iconset_dir)

if __name__ == "__main__":
    main()
