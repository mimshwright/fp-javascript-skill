#!/usr/bin/env bash

# Build script for fp-javascript.skill
# Creates a distributable .skill file from markdown sources

set -e

SKILL_NAME="fp-javascript"
SRC_DIR="src"
DIST_DIR="dist"
TEMP_DIR="temp_build"

# Clean previous builds
rm -rf "$DIST_DIR" "$TEMP_DIR"
mkdir -p "$DIST_DIR" "$TEMP_DIR/$SKILL_NAME"

# Copy source files to temp directory
cp "$SRC_DIR/SKILL.md" "$TEMP_DIR/$SKILL_NAME/"
cp -r "$SRC_DIR/references" "$TEMP_DIR/$SKILL_NAME/"

# Create zip archive
cd "$TEMP_DIR"
zip -r "../$DIST_DIR/$SKILL_NAME.skill" "$SKILL_NAME"
cd ..

# Clean up temp directory
rm -rf "$TEMP_DIR"

echo "✓ Built $SKILL_NAME.skill successfully"
echo "  Location: $DIST_DIR/$SKILL_NAME.skill"
