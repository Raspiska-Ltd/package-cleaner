#!/bin/bash

# Build script for Package Cleaner macOS app
# This creates a distributable .app bundle

set -e

echo "🔨 Building Package Cleaner..."

# Configuration
APP_NAME="Package Cleaner"
BUNDLE_ID="co.raspiska.package-cleaner"
VERSION="1.0.0"
BUILD_DIR=".build/release"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR/$APP_NAME.app"
rm -rf "$BUILD_DIR/$APP_NAME.zip"

# Build the Swift package in release mode
echo "⚙️  Building Swift package..."
swift build -c release

# Create app bundle structure
echo "📦 Creating app bundle..."
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy the executable
echo "📋 Copying executable..."
cp "$BUILD_DIR/PackageCleaner" "$MACOS_DIR/$APP_NAME"
chmod +x "$MACOS_DIR/$APP_NAME"

# Create Info.plist
echo "📝 Creating Info.plist..."
cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026 Raspiska Ltd. All rights reserved.</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.developer-tools</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
EOF

# Create app icon from iconset
ICONSET_DIR="PackageCleaner/Resources/Assets.xcassets/AppIcon.appiconset"
if [ -d "$ICONSET_DIR" ]; then
    echo "🎨 Creating app icon..."
    
    # Create temporary iconset
    TEMP_ICONSET=$(mktemp -d)/AppIcon.iconset
    mkdir -p "$TEMP_ICONSET"
    
    # Copy and rename icons to iconset format
    cp "$ICONSET_DIR/icon_16x16.png" "$TEMP_ICONSET/icon_16x16.png"
    cp "$ICONSET_DIR/icon_16x16@2x.png" "$TEMP_ICONSET/icon_16x16@2x.png"
    cp "$ICONSET_DIR/icon_32x32.png" "$TEMP_ICONSET/icon_32x32.png"
    cp "$ICONSET_DIR/icon_32x32@2x.png" "$TEMP_ICONSET/icon_32x32@2x.png"
    cp "$ICONSET_DIR/icon_128x128.png" "$TEMP_ICONSET/icon_128x128.png"
    cp "$ICONSET_DIR/icon_128x128@2x.png" "$TEMP_ICONSET/icon_128x128@2x.png"
    cp "$ICONSET_DIR/icon_256x256.png" "$TEMP_ICONSET/icon_256x256.png"
    cp "$ICONSET_DIR/icon_256x256@2x.png" "$TEMP_ICONSET/icon_256x256@2x.png"
    cp "$ICONSET_DIR/icon_512x512.png" "$TEMP_ICONSET/icon_512x512.png"
    cp "$ICONSET_DIR/icon_512x512@2x.png" "$TEMP_ICONSET/icon_512x512@2x.png"
    
    # Convert iconset to icns
    iconutil -c icns "$TEMP_ICONSET" -o "$RESOURCES_DIR/AppIcon.icns"
    
    # Cleanup
    rm -rf "$(dirname "$TEMP_ICONSET")"
fi

# Create PkgInfo
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

# Create zip archive
echo "🗜️  Creating zip archive..."
cd "$BUILD_DIR"
zip -r "$APP_NAME.zip" "$APP_NAME.app" -q
cd - > /dev/null

echo "✅ Build complete!"
echo "📍 App bundle: $APP_DIR"
echo "📍 Zip archive: $BUILD_DIR/$APP_NAME.zip"
echo ""
echo "To install: Copy '$APP_NAME.app' to /Applications"
echo "To distribute: Upload '$APP_NAME.zip' to GitHub Releases"
