#!/bin/bash

# Convert iOS icons to macOS format
# Uses the largest iOS icon and creates all macOS sizes

set -e

echo "🎨 Converting iOS icons to macOS format..."

# Thanks to https://icon.kitchen/
IOS_DIR="docs/images/ios"
MACOS_DIR="PackageCleaner/Resources/Assets.xcassets/AppIcon.appiconset"

# Check if iOS icons exist
if [ ! -f "$IOS_DIR/AppIcon~ios-marketing.png" ]; then
    echo "❌ Error: iOS marketing icon not found at $IOS_DIR/AppIcon~ios-marketing.png"
    exit 1
fi

# Use the 1024x1024 iOS marketing icon as source
SOURCE_ICON="$IOS_DIR/AppIcon~ios-marketing.png"

echo "📍 Source: $SOURCE_ICON"
echo "📍 Target: $MACOS_DIR"

# Create macOS iconset directory
mkdir -p "$MACOS_DIR"

# Use sips (built-in macOS tool) to resize
echo "🔄 Resizing icons..."

sips -z 16 16 "$SOURCE_ICON" --out "$MACOS_DIR/icon_16x16.png" > /dev/null
sips -z 32 32 "$SOURCE_ICON" --out "$MACOS_DIR/icon_16x16@2x.png" > /dev/null
sips -z 32 32 "$SOURCE_ICON" --out "$MACOS_DIR/icon_32x32.png" > /dev/null
sips -z 64 64 "$SOURCE_ICON" --out "$MACOS_DIR/icon_32x32@2x.png" > /dev/null
sips -z 128 128 "$SOURCE_ICON" --out "$MACOS_DIR/icon_128x128.png" > /dev/null
sips -z 256 256 "$SOURCE_ICON" --out "$MACOS_DIR/icon_128x128@2x.png" > /dev/null
sips -z 256 256 "$SOURCE_ICON" --out "$MACOS_DIR/icon_256x256.png" > /dev/null
sips -z 512 512 "$SOURCE_ICON" --out "$MACOS_DIR/icon_256x256@2x.png" > /dev/null
sips -z 512 512 "$SOURCE_ICON" --out "$MACOS_DIR/icon_512x512.png" > /dev/null
sips -z 1024 1024 "$SOURCE_ICON" --out "$MACOS_DIR/icon_512x512@2x.png" > /dev/null

echo "✅ Created 10 icon sizes"

# Create Contents.json for macOS
cat > "$MACOS_DIR/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ Created Contents.json"
echo ""
echo "🎉 macOS app icon ready!"
echo "📍 Location: $MACOS_DIR"
echo ""
echo "Next steps:"
echo "  1. Build the app: swift build -c release"
echo "  2. Create .app bundle: ./scripts/build-app.sh"
echo "  3. Check the icon in Finder!"
