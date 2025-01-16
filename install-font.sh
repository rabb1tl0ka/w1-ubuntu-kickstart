#!/bin/bash

# Ensure the script exits on error
set -e

# Function to print usage
usage() {
  # $0 refers to the name of the script itself when it is executed.
  # It is a shell variable that holds the first word of the command used to run the script.
  echo "Usage: $0 <font-url>"
  echo "Example: $0 https://example.com/myfont.ttf"
  exit 1
}

# Check if a font URL is provided
if [ -z "$1" ]; then
  echo "Error: No font URL provided."
  usage
fi

FONT_URL="$1"
FONT_NAME=$(basename "$FONT_URL" | sed 's/%20/_/g')
FONTS_DIR="$HOME/.fonts"

# Create the fonts directory if it doesn't exist
if [ ! -d "$FONTS_DIR" ]; then
  mkdir -p "$FONTS_DIR"
  echo "Created fonts directory at $FONTS_DIR"
fi

# Download the font
FONT_PATH="$FONTS_DIR/$FONT_NAME"
echo "Downloading font from $FONT_URL to $FONT_PATH..."
curl -L -o "$FONT_PATH" "$FONT_URL"

# Refresh the font cache
if fc-cache -fv "$FONTS_DIR"; then
  echo "Font cache updated successfully."
  echo "The font $FONT_NAME is installed and ready to use."
else
  echo "Error: Failed to update the font cache."
  exit 1
fi
