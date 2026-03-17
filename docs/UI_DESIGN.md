# UI Design System

## Overview

Package Cleaner features a modern, native macOS design with carefully crafted components that follow Apple's Human Interface Guidelines while adding unique visual flair.

---

## Design Principles

1. **Native macOS Feel**: Uses system colors, fonts, and patterns
2. **Visual Hierarchy**: Clear information architecture with proper spacing
3. **Color-Coded Information**: Language-specific colors for quick recognition
4. **Progressive Disclosure**: Show relevant information when needed
5. **Responsive Feedback**: Visual states for interactions

---

## Component Libraries

### External Dependencies

| Library | Purpose | License |
|---------|---------|---------|
| **SwiftUIX** | Extended SwiftUI components | MIT |
| **Defaults** | Modern settings/preferences UI | MIT |
| **KeyboardShortcuts** | Keyboard shortcut recorder | MIT |

### Custom Components

#### ModernButton
- Three styles: Primary, Secondary, Destructive
- Icon + text combination
- Consistent padding and corner radius
- Hover and disabled states

#### ModernCard
- Rounded corners with subtle shadows
- Consistent padding
- Adapts to light/dark mode

#### StatCard
- Icon with gradient background
- Title and value display
- Color-coded by type

#### SearchBar
- Magnifying glass icon
- Clear button when text present
- Rounded border with subtle background

#### ModernProgressView
- Large, centered progress indicator
- Percentage display for determinate progress
- Cancel button with proper styling
- Backdrop blur effect

---

## Color System

### Language Colors

Each programming language has a distinctive color:

| Language | Color | Hex |
|----------|-------|-----|
| JavaScript/TypeScript | Yellow | System Yellow |
| PHP | Purple | System Purple |
| Java/Kotlin | Orange | System Orange |
| Rust | Red | System Red |
| Swift | Orange | System Orange |
| Python | Blue | System Blue |
| Dart | Cyan | System Cyan |
| Ruby | Red | System Red |
| Go | Cyan | System Cyan |
| .NET | Purple | System Purple |

### Age Indicators

Project age is color-coded for quick assessment:

| Age | Color | Meaning |
|-----|-------|---------|
| 0-90 days | Green | Recent/Active |
| 90-180 days | Yellow | Moderately old |
| 180-365 days | Orange | Old (cleanup candidate) |
| 365+ days | Red | Very old (priority cleanup) |

### Semantic Colors

- **Primary Action**: Accent Color (Blue)
- **Destructive Action**: Red
- **Success**: Green
- **Warning**: Orange
- **Info**: Blue

---

## Typography

### Font Hierarchy

```swift
// Headings
.font(.system(size: 20, weight: .semibold))  // Section titles
.font(.system(size: 16, weight: .semibold))  // Subsection titles
.font(.system(size: 14, weight: .semibold))  // Card titles

// Body
.font(.system(size: 14))                     // Primary text
.font(.system(size: 13))                     // Secondary text
.font(.system(size: 11))                     // Tertiary text

// Monospaced
.font(.system(size: 13, weight: .semibold, design: .monospaced))  // File sizes
```

---

## Layout & Spacing

### Spacing Scale

- **4pt**: Tight spacing (icon-text gaps)
- **8pt**: Standard spacing (between related elements)
- **12pt**: Medium spacing (between sections)
- **16pt**: Large spacing (major sections)
- **24pt**: Extra large spacing (page sections)

### Corner Radius

- **6pt**: Small elements (buttons, tags)
- **8pt**: Medium elements (search bars)
- **10pt**: Large elements (cards, rows)
- **12pt**: Extra large elements (modals)
- **16pt**: Overlays and dialogs

### Shadows

```swift
// Subtle shadow (cards)
.shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)

// Medium shadow (selected items)
.shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)

// Strong shadow (modals)
.shadow(color: Color.black.opacity(0.3), radius: 30, x: 0, y: 10)
```

---

## View Components

### DirectoryRowView

**Features:**
- Gradient language icon with shadow
- Two-line project information
- Capsule-style package type badge
- Monospaced size display
- Color-coded age indicator
- Selection state with border and background

**Layout:**
```
[Icon] [Project Name          ] [Type Badge] [Size    ] [Last Activity]
       [Project Path          ] [Language  ] [Age Days]
```

### ToolbarView

**Features:**
- Primary action buttons (Scan, Delete, Auto-Cleanup)
- Sort dropdown menu
- Live statistics cards (Found, Total Size)
- Modern search bar
- Settings gear icon

**Responsive:**
- Statistics cards only show when results exist
- Auto-Cleanup button only shows when candidates exist

### SidebarView

**Features:**
- Grouped sections with icons
- Filter buttons with checkmarks
- Action buttons with color coding
- Disabled states for unavailable actions

**Sections:**
1. Filters (Languages)
2. Package Types
3. Quick Actions

### Empty State

**Features:**
- Large centered icon with gradient background
- Clear messaging
- Helpful tip card
- Encourages first action (Scan)

---

## Interaction States

### Buttons

- **Default**: Standard appearance
- **Hover**: Subtle highlight (system handles)
- **Pressed**: Slight scale down (system handles)
- **Disabled**: Reduced opacity, gray color

### List Items

- **Default**: White/control background
- **Hover**: Slight highlight (system handles)
- **Selected**: Accent color background (8% opacity) with border
- **Pressed**: Deeper accent color

---

## Accessibility

### VoiceOver Support

All components include proper labels:
- Buttons have descriptive labels
- Icons have accessibility labels
- Stats have value + unit announcements

### Keyboard Navigation

- Full keyboard support via SwiftUI
- Tab navigation between sections
- Arrow keys for list navigation
- Keyboard shortcuts for actions

### Dynamic Type

- Uses system fonts that scale with user preferences
- Maintains readability at all sizes

---

## Dark Mode

All components automatically adapt to dark mode:
- Colors use semantic system colors
- Shadows adjust opacity
- Backgrounds use `NSColor` system colors
- Accent colors remain vibrant

---

## Animation

### Subtle Animations

- Smooth transitions between states
- Progress indicators with system animation
- List item selection with fade
- Modal overlays with backdrop fade

### Performance

- Animations use SwiftUI's built-in system
- Hardware-accelerated where possible
- No custom animation timing (uses system defaults)

---

## Future Enhancements

### Planned Improvements

1. **Glassmorphism**: Blur effects for overlays
2. **Micro-interactions**: Subtle hover effects
3. **Custom Icons**: Language-specific custom icons
4. **Themes**: User-selectable color themes
5. **Compact Mode**: Denser list view option

---

## Implementation Notes

### SwiftUI Best Practices

```swift
// Use semantic colors
Color(nsColor: .controlBackgroundColor)  // Not Color.gray

// Use SF Symbols
Image(systemName: "folder.fill")  // Not custom images

// Use system fonts
.font(.system(size: 14, weight: .medium))  // Not custom fonts

// Use native components
Button { } label: { }  // Not custom tap handlers
```

### Performance Considerations

- Lazy loading for long lists
- Efficient re-rendering with `@Published`
- Minimal view hierarchy depth
- Reusable components

---

## Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
