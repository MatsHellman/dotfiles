#!/usr/bin/env bash

set -e

FONT_DIR="$HOME/.local/share/fonts"
TEMP_DIR="/tmp/nerd-fonts"

# List of required font files
REQUIRED_FONTS=(
  "FiraCodeNerdFont-Bold.ttf"
  "FiraCodeNerdFont-Light.ttf"
  "FiraCodeNerdFont-Medium.ttf"
  "FiraCodeNerdFontMono-Bold.ttf"
  "FiraCodeNerdFontMono-Light.ttf"
  "FiraCodeNerdFontMono-Medium.ttf"
  "FiraCodeNerdFontMono-Regular.ttf"
  "FiraCodeNerdFontMono-Retina.ttf"
  "FiraCodeNerdFontMono-SemiBold.ttf"
  "FiraCodeNerdFontPropo-Bold.ttf"
  "FiraCodeNerdFontPropo-Light.ttf"
  "FiraCodeNerdFontPropo-Medium.ttf"
  "FiraCodeNerdFontPropo-Regular.ttf"
  "FiraCodeNerdFontPropo-Retina.ttf"
  "FiraCodeNerdFontPropo-SemiBold.ttf"
  "FiraCodeNerdFont-Regular.ttf"
  "FiraCodeNerdFont-Retina.ttf"
  "FiraCodeNerdFont-SemiBold.ttf"

  "HackNerdFont-BoldItalic.ttf"
  "HackNerdFont-Bold.ttf"
  "HackNerdFont-Italic.ttf"
  "HackNerdFontMono-BoldItalic.ttf"
  "HackNerdFontMono-Bold.ttf"
  "HackNerdFontMono-Italic.ttf"
  "HackNerdFontMono-Regular.ttf"
  "HackNerdFontPropo-BoldItalic.ttf"
  "HackNerdFontPropo-Bold.ttf"
  "HackNerdFontPropo-Italic.ttf"
  "HackNerdFontPropo-Regular.ttf"
  "HackNerdFont-Regular.ttf"
)

# URLs for the fonts (direct ZIP download links)
FIRA_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
HACK_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"

# Ensure font directory exists
if [[ ! -d "$FONT_DIR" ]]; then
    echo "Creating font directory at $FONT_DIR"
    mkdir -p "$FONT_DIR"
fi

# Check if all required fonts exist
ALL_FOUND=true
for FONT in "${REQUIRED_FONTS[@]}"; do
    if [[ ! -f "$FONT_DIR/$FONT" ]]; then
        ALL_FOUND=false
        break
    fi
done

if [[ "$ALL_FOUND" = true ]]; then
    echo "All required Nerd Fonts already installed. Exiting."
    exit 0
fi

echo "Some fonts are missing. Downloading Nerd Fonts..."

# Prepare temp directory
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download ZIP files
wget -q --show-progress "$FIRA_URL" -O FiraCode.zip
wget -q --show-progress "$HACK_URL" -O Hack.zip

# Unpack fonts
echo "Extracting FiraCode..."
unzip -o FiraCode.zip -d FiraCode >/dev/null

echo "Extracting Hack..."
unzip -o Hack.zip -d Hack >/dev/null

# Move only .ttf files to the fonts directory
find FiraCode -name "*.ttf" -exec cp {} "$FONT_DIR" \;
find Hack -name "*.ttf" -exec cp {} "$FONT_DIR" \;

echo "Updating font cache..."
fc-cache -fv

echo "Nerd Fonts installed successfully."
