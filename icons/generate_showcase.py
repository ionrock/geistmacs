#!/usr/bin/env python3
"""
Generate an icon showcase graphic (1200x630, social card / README banner style)
displaying the dark icon, light icon, standalone mark, and macOS .icns ready format.
"""

import os
import subprocess

def generate_showcase():
    svg_content = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <defs>
    <!-- Background Gradient -->
    <radialGradient id="bg-grad" cx="50%" cy="30%" r="80%">
      <stop offset="0%" stop-color="#0f0f12"/>
      <stop offset="60%" stop-color="#050507"/>
      <stop offset="100%" stop-color="#000000"/>
    </radialGradient>

    <!-- Card Shadow -->
    <filter id="card-shadow" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow dx="0" dy="24" stdDeviation="32" flood-color="#000000" flood-opacity="0.8"/>
      <feDropShadow dx="0" dy="8" stdDeviation="16" flood-color="#000000" flood-opacity="0.6"/>
    </filter>

    <!-- Ambient Glow behind Dark Icon -->
    <radialGradient id="glow-dark" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#0070f3" stop-opacity="0.4"/>
      <stop offset="40%" stop-color="#7928ca" stop-opacity="0.25"/>
      <stop offset="70%" stop-color="#ff0080" stop-opacity="0.12"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </radialGradient>

    <!-- Ambient Glow behind Light Icon -->
    <radialGradient id="glow-light" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#3291ff" stop-opacity="0.25"/>
      <stop offset="50%" stop-color="#7928ca" stop-opacity="0.12"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </radialGradient>

    <!-- Subtle Hairline Card Border -->
    <linearGradient id="card-border" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff" stop-opacity="0.18"/>
      <stop offset="50%" stop-color="#ffffff" stop-opacity="0.06"/>
      <stop offset="100%" stop-color="#ffffff" stop-opacity="0.02"/>
    </linearGradient>

    <linearGradient id="spectral-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#50e3c2"/>
      <stop offset="28%" stop-color="#0070f3"/>
      <stop offset="68%" stop-color="#7928ca"/>
      <stop offset="100%" stop-color="#ff0080"/>
    </linearGradient>
  </defs>

  <!-- Deep Obsidian Background -->
  <rect width="1200" height="630" fill="url(#bg-grad)"/>

  <!-- Subtle Blueprint Grid Lines -->
  <g opacity="0.04" stroke="#ffffff" stroke-width="1">
    <line x1="0" y1="105" x2="1200" y2="105"/>
    <line x1="0" y1="210" x2="1200" y2="210"/>
    <line x1="0" y1="315" x2="1200" y2="315"/>
    <line x1="0" y1="420" x2="1200" y2="420"/>
    <line x1="0" y1="525" x2="1200" y2="525"/>
    <line x1="200" y1="0" x2="200" y2="630"/>
    <line x1="400" y1="0" x2="400" y2="630"/>
    <line x1="600" y1="0" x2="600" y2="630"/>
    <line x1="800" y1="0" x2="800" y2="630"/>
    <line x1="1000" y1="0" x2="1000" y2="630"/>
  </g>

  <!-- Header Branding -->
  <g transform="translate(600, 72)" text-anchor="middle">
    <!-- Mini Vercel Badge -->
    <rect x="-140" y="-18" width="280" height="26" rx="13" fill="#141416" stroke="rgba(255,255,255,0.12)" stroke-width="1"/>
    <text x="0" y="-1" fill="#a1a1aa" font-family="-apple-system, BlinkMacSystemFont, 'Geist', 'Segoe UI', sans-serif" font-size="11" font-weight="600" letter-spacing="1.5">▲ VERCEL GEIST × GNU EMACS</text>

    <!-- Main Title -->
    <text x="0" y="38" fill="#ffffff" font-family="-apple-system, BlinkMacSystemFont, 'Geist', 'Segoe UI', sans-serif" font-size="32" font-weight="700" letter-spacing="-0.5">Geistmacs Icon Family</text>
    <text x="0" y="62" fill="#71717a" font-family="-apple-system, BlinkMacSystemFont, 'Geist', 'Segoe UI', sans-serif" font-size="14" font-weight="400">Pure Euclidean geometry, obsidian titanium finish, and signature electric accents</text>
  </g>

  <!-- Left: Dark Mode App Icon -->
  <g transform="translate(180, 210)">
    <circle cx="150" cy="150" r="180" fill="url(#glow-dark)" style="mix-blend-mode: screen;"/>
    <image href="png/geistmacs-512x512.png" x="0" y="0" width="300" height="300"/>
    <!-- Label -->
    <text x="150" y="340" text-anchor="middle" fill="#f4f4f5" font-family="-apple-system, BlinkMacSystemFont, 'Geist Mono', monospace" font-size="13" font-weight="600">geistmacs-icon-dark</text>
    <text x="150" y="360" text-anchor="middle" fill="#71717a" font-family="-apple-system, BlinkMacSystemFont, 'Geist', sans-serif" font-size="12">macOS Dock &amp; Application Icon</text>
  </g>

  <!-- Center: Light Mode App Icon -->
  <g transform="translate(520, 210)">
    <circle cx="150" cy="150" r="180" fill="url(#glow-light)" style="mix-blend-mode: screen;"/>
    <image href="png/geistmacs-light-512x512.png" x="0" y="0" width="300" height="300"/>
    <!-- Label -->
    <text x="150" y="340" text-anchor="middle" fill="#f4f4f5" font-family="-apple-system, BlinkMacSystemFont, 'Geist Mono', monospace" font-size="13" font-weight="600">geistmacs-icon-light</text>
    <text x="150" y="360" text-anchor="middle" fill="#71717a" font-family="-apple-system, BlinkMacSystemFont, 'Geist', sans-serif" font-size="12">Paper White Surface Variant</text>
  </g>

  <!-- Right: Standalone Vector Mark & Format Specs -->
  <g transform="translate(860, 210)">
    <circle cx="150" cy="150" r="160" fill="url(#glow-dark)" style="mix-blend-mode: screen;"/>
    <image href="png/geistmacs-mark-512x512.png" x="25" y="25" width="250" height="250"/>
    <!-- Label -->
    <text x="150" y="340" text-anchor="middle" fill="#f4f4f5" font-family="-apple-system, BlinkMacSystemFont, 'Geist Mono', monospace" font-size="13" font-weight="600">geistmacs-mark</text>
    <text x="150" y="360" text-anchor="middle" fill="#71717a" font-family="-apple-system, BlinkMacSystemFont, 'Geist', sans-serif" font-size="12">Vector Glyph &amp; Favicon</text>
  </g>

  <!-- Bottom Badges / Format Pills -->
  <g transform="translate(600, 592)" text-anchor="middle">
    <rect x="-360" y="-16" width="720" height="28" rx="14" fill="#0c0c0e" stroke="rgba(255,255,255,0.08)" stroke-width="1"/>
    <text x="0" y="3" fill="#a1a1aa" font-family="-apple-system, BlinkMacSystemFont, 'Geist Mono', monospace" font-size="11" letter-spacing="0.5">
      SVG Vector  •  macOS .icns (1024×1024)  •  PNG (16px – 1024px)  •  Favicon
    </text>
  </g>
</svg>"""

    showcase_svg = "icons/icon-showcase.svg"
    showcase_png = "icons/icon-showcase.png"
    with open(showcase_svg, "w") as f:
        f.write(svg_content)
    subprocess.run(["rsvg-convert", "-w", "1200", "-h", "630", showcase_svg, "-o", showcase_png], check=True)
    print(f"Generated {showcase_png}")

if __name__ == "__main__":
    generate_showcase()
