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
</dict>
</plist>
EOF

# Copy assets if they exist
if [ -d "PackageCleaner/Resources/Assets.xcassets" ]; then
    echo "🎨 Copying assets..."
    cp -r "PackageCleaner/Resources/Assets.xcassets" "$RESOURCES_DIR/"
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
