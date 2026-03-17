# Release Process

This document describes how to create and publish releases for Package Cleaner.

## Prerequisites

- macOS with Xcode Command Line Tools installed
- Swift 5.9 or later
- Write access to the GitHub repository

## Local Build

To build a distributable `.app` bundle locally:

```bash
./scripts/build-app.sh
```

This will:
1. Build the app in release mode
2. Create a proper `.app` bundle structure
3. Generate `Info.plist` with correct metadata
4. Create a zip archive for distribution

Output files:
- `.build/release/Package Cleaner.app` - The app bundle
- `.build/release/Package Cleaner.zip` - Zip archive for distribution

## Manual Release

1. **Update version number** in:
   - `scripts/build-app.sh` (VERSION variable)
   - `CHANGELOG.md` (add new version section)

2. **Commit changes**:
   ```bash
   git add .
   git commit -m "chore: bump version to X.Y.Z"
   git push
   ```

3. **Create and push tag**:
   ```bash
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin vX.Y.Z
   ```

4. **Build locally**:
   ```bash
   ./scripts/build-app.sh
   ```

5. **Create GitHub Release**:
   - Go to https://github.com/Raspiska-Ltd/package-cleaner/releases/new
   - Select the tag you just created
   - Title: `Package Cleaner vX.Y.Z`
   - Description: Copy from CHANGELOG.md
   - Upload `.build/release/Package Cleaner.zip`
   - Publish release

## Automated Release (GitHub Actions)

The repository includes a GitHub Actions workflow that automatically builds and publishes releases when you push a tag.

1. **Update version** in `scripts/build-app.sh` and `CHANGELOG.md`

2. **Commit and tag**:
   ```bash
   git add .
   git commit -m "chore: bump version to X.Y.Z"
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin main
   git push origin vX.Y.Z
   ```

3. **Wait for GitHub Actions**:
   - The workflow will automatically:
     - Build the app on macOS runner
     - Create a GitHub Release
     - Upload the zip file as a release asset

4. **Verify**:
   - Check https://github.com/Raspiska-Ltd/package-cleaner/releases
   - Download and test the zip file

## Version Numbering

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes or major redesigns
- **MINOR** (0.X.0): New features, backward compatible
- **PATCH** (0.0.X): Bug fixes, backward compatible

## Checklist

Before releasing:

- [ ] All tests pass (`swift test`)
- [ ] App builds successfully (`swift build -c release`)
- [ ] Version updated in `scripts/build-app.sh`
- [ ] CHANGELOG.md updated with changes
- [ ] README.md reflects current features
- [ ] Screenshots updated (if UI changed)
- [ ] Test the built app manually
- [ ] Verify all links work (raspiska.co, GitHub)

## Distribution

Users can install by:

1. Downloading `Package.Cleaner.zip` from Releases
2. Unzipping the file
3. Moving `Package Cleaner.app` to `/Applications`
4. Right-click → Open on first launch (macOS Gatekeeper)

## Code Signing (Future)

For notarized releases (recommended for wider distribution):

1. Get an Apple Developer account
2. Create a Developer ID Application certificate
3. Update build script to sign the app:
   ```bash
   codesign --deep --force --verify --verbose --sign "Developer ID Application: Your Name" "$APP_DIR"
   ```
4. Notarize with Apple:
   ```bash
   xcrun notarytool submit "Package Cleaner.zip" --apple-id "your@email.com" --team-id "TEAMID" --password "app-specific-password"
   ```
5. Staple the notarization:
   ```bash
   xcrun stapler staple "$APP_DIR"
   ```

## Troubleshooting

### Build fails
- Ensure Swift 5.9+ is installed: `swift --version`
- Clean build: `swift package clean`
- Update dependencies: `swift package update`

### App won't open
- User needs to right-click → Open on first launch
- Check if Gatekeeper is blocking: System Settings → Privacy & Security

### Zip file corrupted
- Rebuild: `./scripts/build-app.sh`
- Verify zip: `unzip -t "Package Cleaner.zip"`

## Support

For issues with releases:
- Open an issue: https://github.com/Raspiska-Ltd/package-cleaner/issues
- Contact: https://raspiska.co
