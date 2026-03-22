# MASTER PROMPT: QuickScan Pro - Production-Ready QR & Barcode Scanner

You are an expert Flutter developer with 5+ years of experience building production mobile applications. Create a complete, Play Store-ready QR & Barcode Scanner app called **QuickScan Pro** using Flutter with modern architecture, premium UI/UX, and advanced features.

---

## 📱 APPLICATION OVERVIEW

**App Name:** QuickScan Pro
**Package Name:** com.quickscan.pro
**Tagline:** "The Fastest QR Scanner"
**Category:** Tools / Productivity
**Target Platform:** Android (Play Store optimized) + iOS ready
**Minimum SDK:** Android 7.0 (API 24), iOS 12.0
**Architecture:** Clean Architecture + Feature-First Structure

---

## 🎯 CORE OBJECTIVES

Build a professional QR/Barcode scanner that:
- ✅ Scans instantly with 60 FPS camera performance (<500ms first scan)
- ✅ Works 100% offline-first with encrypted local database
- ✅ Provides intelligent content detection & contextual actions
- ✅ Includes comprehensive scan history management with search & filters
- ✅ Features premium, modern UI/UX design with dark theme
- ✅ Handles permissions gracefully with user-friendly dialogs
- ✅ Supports batch scanning operations
- ✅ Generates custom QR codes with advanced styling
- ✅ Zero crashes, production-grade error handling
- ✅ Optimized for Play Store featured placement

---

## 🛠️ TECHNOLOGY STACK

### Core Framework
- **Flutter:** 3.24+ (latest stable)
- **Dart:** 3.5+ with strict null safety
- **Minimum Deployment:** Android API 24, iOS 12

### Essential Packages (pubspec.yaml)
```yaml
name: quickscan_pro
description: The Fastest QR & Barcode Scanner
version: 1.0.0+1
environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Camera & Scanning
  mobile_scanner: ^5.1.1
  
  # Local Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.3
  
  # Permissions
  permission_handler: ^11.3.1
  
  # Smart Actions
  url_launcher: ^6.3.0
  share_plus: ^9.0.0
  
  # QR Generation
  qr_flutter: ^4.1.0
  
  # Image Handling
  image_picker: ^1.1.2
  image: ^4.2.0
  
  # UI Enhancements
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  lottie: ^3.1.2
  flutter_slidable: ^3.1.0
  
  # Utilities
  intl: ^0.19.0
  flutter_vibrate: ^1.3.0
  clipboard: ^0.1.3
  shared_preferences: ^2.2.3
  uuid: ^4.4.0
  
  # Additional Features
  csv: ^6.0.0
  printing: ^5.13.1
  pdf: ^3.11.0
  sqflite: ^2.3.3
  
  # Icons
  cupertino_icons: ^1.0.8
  font_awesome_flutter: ^10.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.0
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.4.0
  
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/animations/
    - assets/icons/
```

---

## 📂 PROJECT STRUCTURE
```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   ├── dimensions.dart
│   │   └── theme_provider.dart
│   │
│   ├── config/
│   │   ├── app_config.dart
│   │   ├── routes.dart
│   │   └── environment.dart
│   │
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── scan_types.dart
│   │   ├── assets.dart
│   │   └── strings.dart
│   │
│   ├── utils/
│   │   ├── helpers.dart
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── url_detector.dart
│   │   └── content_analyzer.dart
│   │
│   └── services/
│       ├── permission_service.dart
│       ├── vibration_service.dart
│       ├── sound_service.dart
│       ├── analytics_service.dart
│       └── storage_service.dart
│
├── data/
│   ├── models/
│   │   ├── scan_result.dart
│   │   ├── scan_history.dart
│   │   ├── app_settings.dart
│   │   ├── qr_style.dart
│   │   └── batch_scan.dart
│   │
│   ├── repositories/
│   │   ├── scan_repository.dart
│   │   ├── scan_repository_impl.dart
│   │   ├── settings_repository.dart
│   │   └── settings_repository_impl.dart
│   │
│   └── local/
│       ├── hive_service.dart
│       ├── database_helper.dart
│       └── adapters/
│           ├── scan_history_adapter.dart
│           └── settings_adapter.dart
│
├── features/
│   ├── onboarding/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── splash_screen.dart
│   │   │   │   └── onboarding_screen.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── onboarding_page.dart
│   │   │       └── page_indicator.dart
│   │   │
│   │   └── logic/
│   │       └── onboarding_provider.dart
│   │
│   ├── scanner/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── scanner_screen.dart
│   │   │   │   ├── result_detail_screen.dart
│   │   │   │   └── gallery_scan_screen.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── scanner_overlay.dart
│   │   │       ├── scanning_animation.dart
│   │   │       ├── scanner_frame.dart
│   │   │       ├── flash_button.dart
│   │   │       ├── camera_switch_button.dart
│   │   │       ├── scan_result_sheet.dart
│   │   │       ├── action_button_row.dart
│   │   │       └── permission_request_widget.dart
│   │   │
│   │   ├── logic/
│   │   │   ├── scanner_provider.dart
│   │   │   ├── scan_handler.dart
│   │   │   ├── content_analyzer.dart
│   │   │   └── action_handler.dart
│   │   │
│   │   └── models/
│   │       ├── scan_state.dart
│   │       └── detected_barcode.dart
│   │
│   ├── history/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── history_screen.dart
│   │   │   │   ├── history_detail_screen.dart
│   │   │   │   └── favorites_screen.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── history_card.dart
│   │   │       ├── history_search_bar.dart
│   │   │       ├── filter_chips.dart
│   │   │       ├── sort_bottom_sheet.dart
│   │   │       ├── empty_state.dart
│   │   │       ├── delete_confirmation_dialog.dart
│   │   │       └── export_options_sheet.dart
│   │   │
│   │   └── logic/
│   │       ├── history_provider.dart
│   │       ├── history_filter_provider.dart
│   │       └── export_service.dart
│   │
│   ├── generator/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── qr_generator_screen.dart
│   │   │   │   └── qr_preview_screen.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── qr_preview_card.dart
│   │   │       ├── input_form.dart
│   │   │       ├── qr_type_selector.dart
│   │   │       ├── style_customizer.dart
│   │   │       ├── color_picker.dart
│   │   │       └── save_share_buttons.dart
│   │   │
│   │   └── logic/
│   │       ├── generator_provider.dart
│   │       └── qr_builder_service.dart
│   │
│   ├── batch_scan/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── batch_scanner_screen.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── batch_control_panel.dart
│   │   │       ├── batch_scan_list.dart
│   │   │       ├── batch_stats.dart
│   │   │       └── batch_export_sheet.dart
│   │   │
│   │   └── logic/
│   │       ├── batch_provider.dart
│   │       └── batch_export_service.dart
│   │
│   ├── settings/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── settings_screen.dart
│   │   │   │   ├── about_screen.dart
│   │   │   │   └── privacy_screen.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── settings_section.dart
│   │   │       ├── settings_tile.dart
│   │   │       ├── theme_selector.dart
│   │   │       ├── accent_color_picker.dart
│   │   │       └── language_selector.dart
│   │   │
│   │   └── logic/
│   │       ├── settings_provider.dart
│   │       └── settings_service.dart
│   │
│   └── home/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── home_screen.dart
│       │   │
│       │   └── widgets/
│       │       ├── bottom_nav_bar.dart
│       │       └── feature_card.dart
│       │
│       └── logic/
│           └── navigation_provider.dart
│
└── shared/
    ├── widgets/
    │   ├── custom_button.dart
    │   ├── gradient_button.dart
    │   ├── loading_indicator.dart
    │   ├── error_widget.dart
    │   ├── custom_bottom_sheet.dart
    │   ├── custom_dialog.dart
    │   ├── custom_app_bar.dart
    │   ├── icon_badge.dart
    │   └── glassmorphic_container.dart
    │
    ├── extensions/
    │   ├── context_extensions.dart
    │   ├── date_extensions.dart
    │   ├── string_extensions.dart
    │   └── color_extensions.dart
    │
    └── animations/
        ├── slide_transition.dart
        ├── fade_transition.dart
        └── scale_transition.dart
```

---

## 🎨 DETAILED FEATURE SPECIFICATIONS

### 1. 🚀 SPLASH & ONBOARDING

#### Splash Screen (2 seconds max)
```dart
Design:
- Background: Gradient (#1E293B → #0F172A)
- Center: "QuickScan Pro" logo with glow effect
- Tagline below: "The Fastest QR Scanner"
- Loading indicator at bottom
- Version number (small, bottom corner)

Animation:
- Logo fade + scale in (500ms)
- Glow pulse effect (continuous)
- Fade to onboarding/main screen
```

#### Onboarding (First Launch Only)
```dart
3 Screens:

Screen 1: "Lightning Fast Scanning"
- Illustration: QR code being scanned with speed lines
- Description: "Scan any QR or barcode instantly"

Screen 2: "Smart Actions"
- Illustration: Various icons (phone, browser, wifi)
- Description: "Automatic actions for URLs, contacts, WiFi"

Screen 3: "Never Lose History"
- Illustration: Calendar/history icon
- Description: "All scans saved locally & searchable"

Controls:
- Skip button (top right)
- Next button (animated)
- Get Started button (last screen)
- Page indicators (dots)
```

---

### 2. 📸 SCANNER SCREEN (Main Feature)

#### Scanner Engine Requirements
```dart
Supported Formats:
✓ QR Code
✓ EAN-8, EAN-13
✓ UPC-A, UPC-E
✓ Code 39, Code 93, Code 128
✓ ITF-14, Codabar
✓ PDF417, Data Matrix, Aztec

Performance Targets:
- First scan detection: < 500ms
- Continuous scanning: 60 FPS
- Duplicate prevention: 2s cooldown (configurable)
- Auto-pause after successful scan
- Resume scanning after action

Configuration:
- Scan area: Center 280x280dp
- Detection confidence: > 0.85
- Multi-barcode handling: Highlight all, user selects
```

#### UI Layout (Full Screen)
```dart
┌─────────────────────────────────┐
│  [←] QuickScan Pro      [⚙]    │ ← Top Bar (gradient overlay)
│         [⚡Flash] [🔄Switch]     │
├─────────────────────────────────┤
│                                 │
│         ╔═══════════╗          │
│         ║           ║          │ ← Camera Preview
│         ║  Scanning ║          │   (Full screen)
│         ║   Frame   ║          │
│         ║           ║          │
│         ╚═══════════╝          │
│   "Align QR within frame"      │
│                                 │
├─────────────────────────────────┤
│  [🖼️]  [●Scan]  [📜+Badge]     │ ← Bottom Controls
└─────────────────────────────────┘

Components Breakdown:

Top Bar (Translucent):
├── Back button (if needed)
├── App title/logo
├── Flash toggle (auto/on/off icons)
├── Camera switch (front/back)
└── Settings icon

Center Scanning Zone:
├── Animated scanning frame
│   ├── Rounded corners (24dp)
│   ├── Gradient border (3dp, cyan→purple)
│   ├── Corner brackets (animated pulse)
│   └── Scanning laser line (vertical sweep, 1s)
│
├── Hint text below frame
└── Detected barcodes overlay (if multiple)

Dimmed Overlay:
└── 60% black outside scan frame

Bottom Control Panel (Glassmorphic):
├── Gallery button (scan from image)
├── Manual scan trigger (large, center)
├── History button (with unread badge)
└── Batch scan toggle
```

#### Scanning Animation Details
```dart
Scanning Frame:
- Size: 280x280dp
- Border radius: 24dp
- Border: 3dp gradient (linear: #06B6D4 → #8B5CF6)
- Background: transparent

Corner Brackets:
- Length: 40dp each
- Width: 4dp
- Color: #14B8A6 (teal accent)
- Animation: Gentle pulse (scale 1.0 → 1.1, 1.5s, repeat)

Scanning Line:
- Width: 100% of frame
- Height: 3dp
- Gradient: rgba(99, 102, 241, 0) → #6366F1 → rgba(99, 102, 241, 0)
- Animation: Vertical sweep top→bottom (1s, repeat)

Success Animation:
- Green flash overlay (200ms)
- Frame scales up (1.0 → 1.2, 150ms)
- Haptic feedback (medium impact)
- Sound effect (beep, if enabled)
```

---

### 3. 🧠 SMART CONTENT ANALYSIS & ACTIONS

#### Content Type Detection Logic
```dart
Detection Patterns:

URL:
- Regex: ^(https?:\/\/)|(www\.)
- Actions: [Open Browser] [Copy] [Share]

Email:
- Regex: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
- Actions: [Send Email] [Copy] [Add Contact]

Phone:
- Regex: ^\+?[0-9]{7,15}$ or specific country formats
- Actions: [Call] [SMS] [WhatsApp] [Add Contact] [Copy]

WiFi:
- Pattern: WIFI:T:WPA;S:NetworkName;P:password;;
- Parse: SSID, Password, Encryption
- Actions: [Auto Connect] [Show Password] [Copy Password] [Share]

SMS:
- Pattern: SMSTO:+1234567890:Message text
- Actions: [Send SMS] [Copy Number] [Copy Message]

Geo Location:
- Pattern: geo:37.7749,-122.4194 or google.com/maps/...
- Parse: Latitude, Longitude
- Actions: [Open Maps] [Navigate] [Copy Coordinates] [Share]

Contact (vCard):
- Pattern: BEGIN:VCARD...END:VCARD
- Parse: Name, Phone, Email, etc.
- Actions: [Add Contact] [View Details] [Share]

Event (iCalendar):
- Pattern: BEGIN:VEVENT...END:VEVENT
- Parse: Title, Date, Location
- Actions: [Add to Calendar] [Share]

Product Barcode (EAN/UPC):
- Pattern: Numeric codes (8-13 digits)
- Actions: [Search Product] [Price Compare] [Copy Code]

Plain Text:
- Default fallback
- Actions: [Copy] [Search Web] [Share] [Translate]
```

#### Result Bottom Sheet Design
```dart
┌─────────────────────────────────┐
│         ═══ Drag Handle ═══     │
├─────────────────────────────────┤
│  [Icon] URL Detected            │ ← Type badge
│                                 │
│  ┌─────────────────────────┐   │
│  │ https://example.com     │   │ ← Content preview
│  │ ...                     │   │   (scrollable if long)
│  └─────────────────────────┘   │
│                                 │
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ Open │ │ Copy │ │Share │   │ ← Primary actions
│  └──────┘ └──────┘ └──────┘   │   (max 4)
│                                 │
│  ─────────────────────────────  │
│                                 │
│  [⭐ Favorite] [🗑️ Delete]      │ ← Secondary actions
│  📅 Scanned: 2 min ago          │ ← Timestamp
│  🔢 Format: QR_CODE             │ ← Barcode format
│                                 │
└─────────────────────────────────┘

Behavior:
- Slide up from bottom (250ms ease-out)
- Backdrop blur + dim
- Swipe down to dismiss
- Tap outside to dismiss
- Haptic feedback on actions
```

#### Smart Action Handlers
```dart
URL Handler:
- Validate URL safety
- Check if app can handle (deep links)
- Open in default browser
- Track in history as "URL"

Phone Handler:
- Detect country code
- Format display (+1-234-567-8900)
- Direct dial intent
- SMS compose intent
- WhatsApp intent (if installed)

WiFi Handler:
- Parse SSID and password
- Android 10+: Use WifiNetworkSuggestion API
- Android <10: Show password, manual connect
- Security type detection (WPA, WEP, Open)

Email Handler:
- Parse email, subject, body from mailto:
- Compose email intent
- Option to add to contacts

Geo Handler:
- Parse coordinates
- Open Google Maps / Apple Maps
- Show address if reverse geocoding available
- Navigation mode option

Contact Handler:
- Parse vCard fields
- Preview contact details
- Add to device contacts (with permission)
- Merge duplicate detection
```

---

### 4. 📜 SCAN HISTORY MANAGEMENT

#### Database Schema (Hive)
```dart
@HiveType(typeId: 0)
class ScanHistory extends HiveObject {
  @HiveField(0)
  String id; // UUID v4
  
  @HiveField(1)
  String content; // Raw scanned data
  
  @HiveField(2)
  String type; // url, text, phone, email, wifi, contact, event, product
  
  @HiveField(3)
  DateTime timestamp;
  
  @HiveField(4)
  bool isFavorite;
  
  @HiveField(5)
  String? title; // User-editable custom title
  
  @HiveField(6)
  String? notes; // User notes
  
  @HiveField(7)
  int scanCount; // Track duplicates
  
  @HiveField(8)
  String format; // QR_CODE, EAN_13, etc.
  
  @HiveField(9)
  DateTime? lastScanned; // For duplicate tracking
  
  @HiveField(10)
  Map<String, dynamic>? metadata; // Extra parsed data
  
  @HiveField(11)
  List<String>? tags; // User-added tags
}

Indexes:
- Primary: id
- Secondary: timestamp (DESC)
- Secondary: type
- Secondary: isFavorite
```

#### History Screen Layout
```dart
┌─────────────────────────────────┐
│  ← History          [⋮Menu]     │ ← App bar
├─────────────────────────────────┤
│  🔍 Search scans...             │ ← Search bar
│  [All] [⭐] [🔗] [📱] [📧]      │ ← Filter chips
├─────────────────────────────────┤
│  Sort: Recent ▼  |  Select      │ ← Sort & multi-select
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐   │
│  │ 🔗 URL                  │   │
│  │ https://example.com     │   │ ← History cards
│  │ 2 hours ago        [→]  │   │   (swipeable)
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ ⭐ 📱 PHONE             │   │
│  │ +1-234-567-8900         │   │
│  │ Today at 10:30 AM  [→]  │   │
│  └─────────────────────────┘   │
│                                 │
│  ... (scrollable list)          │
│                                 │
└─────────────────────────────────┘

Features:

Search Bar:
- Real-time filtering
- Search content, title, notes, tags
- Debounced (300ms)
- Clear button when active

Filter Chips (Horizontal scroll):
- All (default)
- Favorites ⭐
- URLs 🔗
- Phone 📱
- Email 📧
- WiFi 📶
- Contacts 👤
- Products 🛒
- Text 📄

Sort Options (Bottom sheet):
- Recent first (default)
- Oldest first
- Alphabetical A→Z
- Alphabetical Z→A
- Most scanned
- Type

Card Swipe Actions:
- Swipe RIGHT: Toggle favorite (green background)
- Swipe LEFT: Delete (red background)
- Threshold: 30% of card width
```

#### History Card Design
```dart
┌─────────────────────────────────┐
│  [Icon] TYPE          [⭐]      │ ← Header
│  Content preview (2 lines max)  │ ← Body
│  📅 Timestamp   📊 Count   [→]  │ ← Footer
└─────────────────────────────────┘

Styling:
- Height: Auto (min 80dp)
- Padding: 16dp
- Border radius: 20dp
- Background: Gradient(#1E293B 0%, #334155 100%)
- Border: 1dp solid rgba(255, 255, 255, 0.05)
- Shadow: 0 2 8 rgba(0, 0, 0, 0.2)

Icon Colors by Type:
- URL: #3B82F6 (blue)
- Phone: #10B981 (green)
- Email: #F59E0B (amber)
- WiFi: #8B5CF6 (purple)
- Contact: #EC4899 (pink)
- Product: #14B8A6 (teal)
- Text: #6B7280 (gray)
- Event: #EF4444 (red)

Interaction:
- Tap: Open detail screen
- Long press: Enable multi-select mode
- Swipe gestures as described above
```

#### Bulk Operations
```dart
Multi-Select Mode:
- Triggered by long-press on any card
- Checkboxes appear on all cards
- Top bar changes to action bar

Action Bar:
├── [X] Cancel
├── "3 selected"
├── [Delete All]
├── [Export]
├── [Share]
└── [Add to Favorites]

Export Options (Bottom sheet):
- CSV file
- JSON file
- Text file (plain list)
- PDF report (formatted)

Confirmation Dialogs:
- Delete: "Delete 3 items? This can't be undone."
- Clear all: "Delete all history? This can't be undone."
```

#### Empty States
```dart
No History:
- Icon: Scanning animation (Lottie)
- Title: "No scans yet"
- Description: "Tap the scan button to get started"
- Action: [Start Scanning]

No Search Results:
- Icon: Magnifying glass
- Title: "No results found"
- Description: "Try different keywords"
- Action: [Clear Search]

No Favorites:
- Icon: Star outline
- Title: "No favorites yet"
- Description: "Swipe right on items to favorite"
```

---

### 5. ⚡ QR CODE GENERATOR

#### Generator Screen Layout
```dart
┌─────────────────────────────────┐
│  ← Generate QR Code             │
├─────────────────────────────────┤
│  [Text] [URL] [WiFi] [Contact]  │ ← Type selector tabs
├─────────────────────────────────┤
│                                 │
│  Input Form (based on type)     │ ← Dynamic form
│                                 │
├─────────────────────────────────┤
│  ┌─────────────────────────┐   │
│  │                         │   │
│  │    QR PREVIEW           │   │ ← Live preview
│  │    (Updates live)       │   │   (280x280dp)
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  ── Customize ──                │
│  [Size] [Colors] [Logo] [Shape]│ ← Style options
│                                 │
│  ┌──────────┐  ┌──────────┐    │
│  │   Save   │  │  Share   │    │ ← Action buttons
│  └──────────┘  └──────────┘    │
└─────────────────────────────────┘
```

#### QR Type Templates
```dart
1. Plain Text:
   ├── Text area (multiline)
   └── Character count

2. URL:
   ├── URL input (validation)
   └── Protocol dropdown (https://, http://)

3. WiFi:
   ├── Network name (SSID)
   ├── Password
   ├── Security type (WPA/WPA2, WEP, Open)
   └── Hidden network checkbox

4. Contact (vCard):
   ├── Full name
   ├── Phone number
   ├── Email
   ├── Company
   ├── Address
   └── Website

5. Email:
   ├── To address
   ├── Subject
   └── Message body

6. Phone:
   ├── Phone number
   └── Country code selector

7. SMS:
   ├── Phone number
   └── Message

8. Event (Calendar):
   ├── Event title
   ├── Start date/time
   ├── End date/time
   ├── Location
   └── Description

9. Geo Location:
   ├── Latitude
   ├── Longitude
   └── Label
   └── [Pick on Map] button
```

#### QR Customization Options
```dart
Size Presets:
- Small: 200x200
- Medium: 400x400 (default)
- Large: 800x800
- Custom: User input

Error Correction Levels:
- Low (7% recovery)
- Medium (15% recovery) [default]
- Quartile (25% recovery)
- High (30% recovery)

Color Customization:
├── Foreground color (QR dots)
│   └── Color picker + Recent colors
│
└── Background color
    └── Color picker + Transparency slider

Advanced Styling:
├── Dot shape: Square, Circle, Rounded
├── Eye shape: Square, Circle, Rounded
├── Add logo (center, max 20% of QR size)
└── Pattern style: Standard, Dots, Rounded

Preview Options:
- Real-time rendering
- Scan test (validate readability)
- Download quality indicator
```

#### Save & Share Actions
```dart
Save to Gallery:
- PNG format
- High resolution (1024x1024)
- Filename: QR_[type]_[timestamp].png
- Success toast

Share:
- Direct image share intent
- Include text content as caption
- Recent apps suggestion

Copy:
- Copy generated content (not image)
- "Copied to clipboard" feedback

Print:
- PDF generation
- A4 size, centered
- Include content text below QR
```

---

### 6. 🔄 BATCH SCANNING MODE

#### Batch Scanner Layout
```dart
┌─────────────────────────────────┐
│  Batch Scan  [Pause] [Finish]   │ ← Top controls
│  Scanned: 12  |  Unique: 10     │ ← Stats
├─────────────────────────────────┤
│                                 │
│     Camera Preview (60%)        │ ← Compact camera
│     with scan frame             │
│                                 │
├─────────────────────────────────┤
│  ── Scanned Items (40%) ──      │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 1. https://example.com  │   │ ← Scrollable list
│  │    QR_CODE | Just now   │   │   of scanned items
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 2. +1-234-567-8900      │   │
│  │    QR_CODE | 5s ago     │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘

Features:

Continuous Scanning:
- No pause between scans
- 1s cooldown for same code
- Visual/haptic feedback per scan
- Auto-scroll list to latest

Duplicate Handling:
- First scan: Add to list
- Duplicate: Increment counter badge
- Setting: "Skip duplicates" toggle

Pause Mode:
- Freeze camera
- Review scanned items
- Edit/delete individual items
- Resume scanning

Finish Actions (Bottom sheet):
├── Save all to history
├── Export as CSV
├── Export as PDF report
├── Share as text
└── Discard batch
```

#### Batch Statistics
```dart
Display Metrics:
- Total scanned
- Unique items
- Duplicates count
- Scan rate (items/min)
- Session duration

Export Formats:

CSV:
Index,Content,Type,Format,Timestamp,Count

PDF Report:
- Header: "Batch Scan Report"
- Date & time
- Summary stats
- Table of items
- QR codes included (optional)

Text File:
Simple list, one per line
```

---

### 7. ⚙️ SETTINGS & CONFIGURATION

#### Settings Screen Layout
```dart
┌─────────────────────────────────┐
│  ← Settings                     │
├─────────────────────────────────┤
│                                 │
│  ═══ Appearance ═══             │
│  Theme            [Dark Mode ▼] │
│  Accent Color     [🎨 Purple]   │
│  Language         [English ▼]   │
│                                 │
│  ═══ Scanner ═══                │
│  Beep on scan     [✓]           │
│  Vibration        [✓]           │
│  Auto copy        [ ]           │
│  Scan delay       [2s ▼]        │
│  Flash mode       [Auto ▼]      │
│                                 │
│  ═══ History ═══                │
│  Auto-delete      [Never ▼]     │
│  Max items        [1000 ▼]      │
│  Clear history    [Clear]       │
│                                 │
│  ═══ Advanced ═══               │
│  Camera quality   [Auto ▼]      │
│  Barcode formats  [Manage →]    │
│                                 │
│  ═══ Privacy ═══                │
│  Analytics        [ ]           │
│  Crash reports    [✓]           │
│  Privacy Policy   [View →]      │
│                                 │
│  ═══ About ═══                  │
│  Version          1.0.0         │
│  Rate app         [★ Rate]      │
│  Share app        [Share]       │
│  Support          [Contact →]   │
│  Licenses         [View →]      │
│                                 │
└─────────────────────────────────┘
```

#### Settings Options Details
```dart
Theme Options:
- Light (future feature)
- Dark (default)
- Auto (system preference)

Accent Colors:
- Purple (default)
- Blue
- Teal
- Green
- Pink
- Orange
- Custom (color picker)

Languages:
- English (default)
- Spanish
- French
- German
- Hindi
- Arabic
[Expandable list]

Scan Delay (Duplicate Prevention):
- None
- 1 second
- 2 seconds (default)
- 5 seconds
- 10 seconds

Flash Mode Default:
- Auto
- Always On
- Always Off

Auto-Delete History:
- Never (default)
- After 7 days
- After 30 days
- After 90 days
- After 1 year

Max History Items:
- 100
- 500
- 1000 (default)
- 5000
- Unlimited

Camera Quality:
- Auto (default)
- SD (480p)
- HD (720p)
- FHD (1080p)

Barcode Formats (Checkboxes):
✓ QR Code
✓ EAN-13
✓ EAN-8
✓ UPC-A
✓ UPC-E
✓ Code 128
✓ Code 39
✓ ITF
✓ PDF417
✓ Data Matrix
✓ Aztec
[ ] Codabar (disabled by user)
```

---

## 🎨 UI/UX DESIGN SYSTEM

### Color Palette (QuickScan Pro Theme)
```dart
// colors.dart

class AppColors {
  // Primary Brand Colors
  static const primary = Color(0xFF6366F1); // Indigo
  static const primaryDark = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFF818CF8);
  
  // Secondary Colors
  static const secondary = Color(0xFF8B5CF6); // Purple
  static const accent = Color(0xFF14B8A6); // Teal
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const accentGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Semantic Colors
  static const success = Color(0xFF10B981); // Green
  static const error = Color(0xFFEF4444); // Red
  static const warning = Color(0xFFF59E0B); // Amber
  static const info = Color(0xFF3B82F6); // Blue
  
  // Dark Theme Surface Colors
  static const background = Color(0xFF0F172A); // Slate-950
  static const surface = Color(0xFF1E293B); // Slate-800
  static const surfaceElevated = Color(0xFF334155); // Slate-700
  static const surfaceCard = Color(0xFF1E293B);
  
  // Text Colors
  static const textPrimary = Color(0xFFF1F5F9); // Slate-100
  static const textSecondary = Color(0xFF94A3B8); // Slate-400
  static const textDisabled = Color(0xFF64748B); // Slate-500
  static const textHint = Color(0xFF475569); // Slate-600
  
  // Type-Specific Colors
  static const typeUrl = Color(0xFF3B82F6);
  static const typePhone = Color(0xFF10B981);
  static const typeEmail = Color(0xFFF59E0B);
  static const typeWifi = Color(0xFF8B5CF6);
  static const typeContact = Color(0xFFEC4899);
  static const typeProduct = Color(0xFF14B8A6);
  static const typeText = Color(0xFF6B7280);
  static const typeEvent = Color(0xFFEF4444);
  
  // Border & Divider
  static const border = Color(0x0DFFFFFF); // 5% white
  static const divider = Color(0x1AFFFFFF); // 10% white
  
  // Overlay
  static const overlay = Color(0x99000000); // 60% black
  static const scrim = Color(0xCC000000); // 80% black
}
```

### Typography System
```dart
// text_styles.dart

class AppTextStyles {
  static const fontFamily = 'Inter';
  
  // Headlines
  static const h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  static const h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );
  
  static const h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Body Text
  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  // Labels & Buttons
  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  static const overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );
}
```

### Component Styling
```dart
// Button Styles
Primary Button:
- Height: 56dp
- Padding: 16dp horizontal
- Border radius: 16dp
- Background: primaryGradient
- Shadow: 0dp 4dp 12dp rgba(99, 102, 241, 0.3)
- Text: button style, white
- Ripple: white 20%

Secondary Button:
- Height: 56dp
- Padding: 16dp horizontal
- Border radius: 16dp
- Border: 2dp solid primary
- Background: transparent
- Text: button style, primary color
- Ripple: primary 10%

Icon Button:
- Size: 48dp x 48dp
- Border radius: 12dp
- Background: rgba(255, 255, 255, 0.1) with blur
- Icon size: 24dp
- Ripple: white 15%

// Card Styles
Standard Card:
- Border radius: 20dp
- Padding: 16dp
- Background: surfaceCard
- Border: 1dp solid rgba(255, 255, 255, 0.05)
- Shadow: 0dp 2dp 8dp rgba(0, 0, 0, 0.2)

Elevated Card:
- Border radius: 20dp
- Padding: 20dp
- Background: surfaceElevated
- Shadow: 0dp 4dp 16dp rgba(0, 0, 0, 0.3)

// Input Fields
Text Field:
- Height: 56dp
- Border radius: 12dp
- Background: surface
- Border: 2dp solid transparent (focused: primary)
- Padding: 16dp
- Text: bodyMedium
- Hint: textHint

// Bottom Sheets
- Border radius: 32dp (top corners only)
- Background: surface
- Handle: 4dp x 32dp, textDisabled
- Backdrop: scrim color
- Max height: 90% screen
```

### Spacing System
```dart
// dimensions.dart

class AppDimensions {
  // Spacing Scale (8dp base)
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  
  // Component Sizes
  static const buttonHeight = 56.0;
  static const iconButtonSize = 48.0;
  static const iconSize = 24.0;
  static const iconSizeSmall = 20.0;
  static const iconSizeLarge = 32.0;
  
  // Border Radius
  static const radiusXs = 8.0;
  static const radiusSm = 12.0;
  static const radiusMd = 16.0;
  static const radiusLg = 20.0;
  static const radiusXl = 24.0;
  static const radiusFull = 999.0;
  
  // Scanning Frame
  static const scanFrameSize = 280.0;
  static const scanFrameRadius = 24.0;
  static const scanFrameBorderWidth = 3.0;
  
  // App Bar
  static const appBarHeight = 56.0;
  
  // Bottom Nav
  static const bottomNavHeight = 72.0;
}
```

### Animation Durations
```dart
class AppAnimations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 350);
  static const slower = Duration(milliseconds: 500);
  
  // Specific Animations
  static const pageTransition = Duration(milliseconds: 300);
  static const bottomSheet = Duration(milliseconds: 250);
  static const buttonPress = Duration(milliseconds: 100);
  static const scanningLine = Duration(milliseconds: 1000);
  static const successFlash = Duration(milliseconds: 200);
}
```

---

## 🔐 PERMISSIONS & SECURITY

### Android Manifest Configuration
```xml
<!-- android/app/src/main/AndroidManifest.xml -->

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Required Permissions -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- Storage Permissions (Scoped Storage) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
                     android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                     android:maxSdkVersion="29"
                     tools:ignore="ScopedStorage" />
    
    <!-- Android 13+ Media Permissions -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    
    <!-- Camera Feature -->
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
    
    <application
        android:label="QuickScan Pro"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Activities, etc. -->
        
    </application>
</manifest>
```

### Permission Request Flow
```dart
// Core Permission Service

Permission Request Strategy:
1. Check permission status
2. If denied first time: Show rationale dialog
3. If permanently denied: Show settings dialog
4. Request permission
5. Handle result

Camera Permission Flow:
┌─ App Launch
│
├─ Check camera permission
│  │
│  ├─ Granted → Proceed to scanner
│  │
│  ├─ Not determined → Request directly
│  │  └─ Show inline explanation in scanner
│  │
│  └─ Denied → Show rationale dialog
│     ├─ User grants → Proceed
│     └─ User denies → Show limited functionality
│
└─ Permanently Denied
   └─ Show "Go to Settings" dialog
      ├─ Explain why needed
      ├─ "Open Settings" button
      └─ "Use Gallery" alternative

Rationale Dialog Design:
┌─────────────────────────────────┐
│  Camera Permission Required     │
│                                 │
│  📷 (Icon)                      │
│                                 │
│  QuickScan Pro needs camera     │
│  access to scan QR codes and    │
│  barcodes.                      │
│                                 │
│  [Not Now]  [Allow Camera]      │
└─────────────────────────────────┘

Settings Dialog:
┌─────────────────────────────────┐
│  Permission Required            │
│                                 │
│  ⚙️ (Icon)                      │
│                                 │
│  Camera permission is disabled. │
│  Please enable it in Settings   │
│  to scan QR codes.              │
│                                 │
│  Alternative: You can scan from │
│  gallery images.                │
│                                 │
│  [Use Gallery]  [Open Settings] │
└─────────────────────────────────┘
```

### Data Security & Privacy
```dart
Security Measures:

Local Storage:
- Hive encryption enabled
- Encryption key stored in secure storage
- No cloud backup by default
- Clear data option in settings

URL Safety:
- Validate URLs before opening
- Detect phishing patterns
- Warn on suspicious domains
- Option to preview before opening

Privacy Features:
- Analytics opt-in (not opt-out)
- No personally identifiable data collected
- All data stored locally
- Export/delete data anytime
- Clear privacy policy

Network Security:
- HTTPS only for web requests
- Certificate pinning for API calls (if any)
- No third-party trackers
```

---

## ⚡ PERFORMANCE OPTIMIZATION

### Camera & Scanning Performance
```dart
Optimization Strategies:

1. Efficient Camera Lifecycle:
   - Initialize camera on demand
   - Dispose immediately when leaving screen
   - Pause in background
   - Resume smoothly on foreground

2. Frame Processing:
   - Process every 3rd frame (20 FPS effective)
   - Skip frames if processing is slow
   - Use isolates for heavy decoding
   - Cache detection results (200ms)

3. Memory Management:
   - Limit camera resolution to HD (720p) default
   - Release image buffers immediately
   - Use memory-efficient barcode library
   - Monitor memory usage

4. Battery Optimization:
   - Auto-pause after 2min of no activity
   - Reduce frame rate when battery low
   - Disable flash auto-on when battery < 20%
```

### Database Performance
```dart
Optimization Strategies:

1. Indexing:
   - Primary index on ID
   - Secondary index on timestamp
   - Composite index on (type, timestamp)
   - Index on isFavorite for quick filtering

2. Pagination:
   - Load 20 items initially
   - Lazy load 20 more on scroll
   - Virtual scrolling for large lists

3. Caching:
   - Cache recent 100 items in memory
   - Invalidate on new scan
   - Background sync to disk

4. Cleanup:
   - Auto-delete based on settings
   - Compress old entries
   - Vacuum database monthly
```

### UI Performance
```dart
Optimization Strategies:

1. Widget Optimization:
   - Use const constructors everywhere
   - Implement shouldRebuild carefully
   - Use RepaintBoundary for complex widgets
   - Avoid unnecessary rebuilds

2. Image Optimization:
   - Cache network images
   - Compress QR code images
   - Use appropriate image formats
   - Lazy load thumbnails

3. Animation Performance:
   - Use Rive/Lottie for complex animations
   - Limit concurrent animations
   - Use Transform instead of positioned
   - 60 FPS target

4. Build Size:
   - Enable code splitting
   - Tree shake unused code
   - Compress assets
   - Use vector graphics (SVG)
```

### APK Size Optimization
```dart
Build Configuration:

android/app/build.gradle:

android {
    ...
    
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // App Bundle splits
            ndk {
                abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
            }
        }
    }
    
    // Enable R8 full mode
    buildFeatures {
        shrinkResources true
    }
}

Target APK Size: < 25 MB
```

---

## 🧪 ERROR HANDLING & EDGE CASES

### Scanner Errors
```dart
Error Scenarios & Handling:

1. Camera Permission Denied:
   - Show permission rationale
   - Offer gallery scan alternative
   - Provide settings shortcut

2. Camera Unavailable:
   - Detect camera hardware
   - Show error message
   - Offer retry option
   - Fallback to gallery

3. No Barcode Detected (10s):
   - Show hint: "Move closer or adjust lighting"
   - Toggle flash suggestion
   - Offer manual input option

4. Multiple Barcodes in Frame:
   - Highlight all detected codes
   - Let user tap to select
   - Show count badge

5. Damaged/Unreadable Code:
   - Show error: "Cannot read barcode"
   - Suggest better lighting
   - Offer manual entry

6. Low Light Conditions:
   - Auto-suggest flash
   - Increase exposure (if supported)
   - Show lighting hint

Error UI Pattern:
┌─────────────────────────────────┐
│                                 │
│  ⚠️ Error Icon                  │
│                                 │
│  Error Title (Bold)             │
│  Error description text         │
│                                 │
│  [Retry]  [Alternative Action]  │
│                                 │
└─────────────────────────────────┘
```

### Network Errors (URL Actions)
```dart
Error Scenarios:

1. No Internet Connection:
   - Show offline indicator
   - Queue action for later
   - Offer "Copy URL" alternative
   - Retry when online

2. Invalid URL:
   - Validate before opening
   - Show warning dialog
   - Offer to edit URL
   - Still save to history

3. Timeout:
   - 10s timeout for web requests
   - Show retry option
   - Cache failed URLs

4. SSL Certificate Error:
   - Warn user about security risk
   - Option to proceed (at own risk)
   - Default: Block unsafe URLs
```

### Database Errors
```dart
Error Scenarios:

1. Storage Full:
   - Detect available space
   - Prompt to clear old scans
   - Offer export before delete
   - Auto-delete oldest if critical

2. Corrupted Data:
   - Try to recover
   - Skip corrupted entries
   - Log error for debugging
   - Offer database reset option

3. Migration Failed:
   - Backup current database
   - Attempt safe migration
   - Rollback on failure
   - Report error with details

4. Concurrent Write Conflict:
   - Implement write locks
   - Retry with exponential backoff
   - Show loading state
```

### Crash Prevention
```dart
Global Error Handling:

1. Catch All Errors:
   - FlutterError.onError for Flutter errors
   - PlatformDispatcher.onError for Dart errors
   - Log to console (dev mode)
   - Silent fail in production (with logging)

2. Graceful Degradation:
   - Core features always work
   - Non-critical features fail silently
   - Show generic error messages
   - Offer restart option

3. Crash Reporting (Optional):
   - Firebase Crashlytics (opt-in)
   - Anonymized crash logs
   - User consent required
```

---

## 📱 PLATFORM-SPECIFIC REQUIREMENTS

### Android (Play Store Ready)

#### App Icon & Branding
```xml
<!-- Adaptive Icon -->
res/
├── mipmap-hdpi/
├── mipmap-mdpi/
├── mipmap-xhdpi/
├── mipmap-xxhdpi/
└── mipmap-xxxhdpi/
    ├── ic_launcher.png (Adaptive)
    └── ic_launcher_round.png

Icon Design:
- Background: Gradient (Indigo to Purple)
- Foreground: White QR code with scanning line
- Safe zone: 66dp diameter
- Full bleed: 108dp x 108dp

Store Icon (512x512):
- High-res PNG
- No transparency
- Same design as app icon
```

#### Splash Screen
```dart
flutter_native_splash configuration:

flutter_native_splash:
  color: "#0F172A"
  image: assets/images/splash_logo.png
  android: true
  ios: true
  android_12:
    image: assets/images/splash_logo.png
    icon_background_color: "#0F172A"

Design:
- Background: #0F172A (dark slate)
- Logo: "QuickScan Pro" with gradient
- Tagline below logo
- Duration: < 2 seconds
```

#### Build Configuration
```gradle
// android/app/build.gradle

android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.quickscan.pro"
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        
        multiDexEnabled true
    }
    
    signingConfigs {
        release {
            // Keystore configuration
            storeFile file('../keystore/quickscan_pro.jks')
            storePassword System.getenv("KEYSTORE_PASSWORD")
            keyAlias System.getenv("KEY_ALIAS")
            keyPassword System.getenv("KEY_PASSWORD")
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

#### Play Store Listing
```
App Title: QuickScan Pro
(30 characters max)

Short Description: 
The fastest QR & barcode scanner. Scan instantly, smart actions, unlimited history.
(80 characters max)

Full Description:
QuickScan Pro is the fastest and most powerful QR code and barcode scanner on Android. Scan any code instantly and take smart actions automatically.

🚀 LIGHTNING FAST SCANNING
- Instant detection in under 0.5 seconds
- Supports all major formats: QR, EAN, UPC, Code 128, and more
- Continuous batch scanning mode

🧠 SMART ACTIONS
- URLs → Open in browser automatically
- Phone numbers → Call, SMS, or WhatsApp
- WiFi codes → Auto-connect to networks
- Contacts → Add to your phonebook
- Products → Search and compare prices

📜 NEVER LOSE HISTORY
- Unlimited scan history
- Search and filter scans
- Mark favorites
- Export to CSV or PDF

⚡ POWERFUL FEATURES
- Generate custom QR codes
- Scan from gallery images
- Batch scanning mode
- Dark theme design
- 100% offline functionality
- No ads, no tracking

🔒 PRIVACY FIRST
- All data stored locally
- No internet required
- No third-party trackers
- Export or delete data anytime

Perfect for:
✓ Shopping (compare prices)
✓ Networking (scan business cards)
✓ Events (scan tickets)
✓ Inventory management
✓ Document tracking

Download QuickScan Pro today and experience the fastest QR scanner on Android!

Keywords:
qr scanner, barcode scanner, qr code reader, code scanner, qr generator, barcode reader, quick scan, fast scanner, qr reader

Category: Tools
Content Rating: Everyone
```

#### Screenshots Requirements
```
Minimum: 6 screenshots
Dimensions: 1080 x 1920 (16:9)

Screenshot 1: Scanner screen (with QR code aligned)
Screenshot 2: Scan result with smart actions
Screenshot 3: History screen with multiple scans
Screenshot 4: QR code generator
Screenshot 5: Batch scanning in action
Screenshot 6: Settings screen

Feature Graphic:
1024 x 500 pixels
Show app logo + key feature highlights
```

---

### iOS (Optional but Recommended)

#### Info.plist Additions
```xml
<key>NSCameraUsageDescription</key>
<string>QuickScan Pro needs camera access to scan QR codes and barcodes</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Access photos to scan QR codes from images</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save generated QR codes to your photo library</string>
```

#### iOS Build Configuration
```
Deployment Target: iOS 12.0
Bundle Identifier: com.quickscan.pro
Display Name: QuickScan Pro
```

---

## 🚀 ADVANCED FEATURES (Future Enhancements)

### Phase 2 Features
```dart
1. Cloud Sync (Optional Firebase Integration):
   - Cross-device sync
   - Backup & restore
   - Account system
   - Real-time sync

2. AI-Powered Enhancements:
   - Smart categorization (ML Kit)
   - OCR text extraction from images
   - Logo detection in QR codes
   - Spam URL detection
   - Product recognition

3. Analytics Dashboard:
   - Scan statistics (charts)
   - Daily/weekly/monthly trends
   - Most scanned types
   - Usage heatmap

4. Widgets:
   - Home screen quick scan widget
   - Recent scans widget
   - Favorite scans widget

5. Shortcuts & Automation:
   - Quick actions from app icon
   - Android shortcuts
   - Tasker integration

6. Pro Features (In-App Purchase):
   - Remove limits (if any)
   - Advanced QR customization
   - Bulk operations
   - Priority support
   - Cloud backup (unlimited)

7. Collaboration Features:
   - Share collections
   - Team workspaces
   - Collaborative history

8. Integration Features:
   - Export to Google Sheets
   - Zapier integration
   - REST API for power users
```

---

## 📦 DELIVERABLES CHECKLIST

### Code Quality ✅
- [ ] Zero compiler warnings
- [ ] All null safety checks passed
- [ ] Code commented (complex logic)
- [ ] Consistent naming conventions
- [ ] DRY principles followed
- [ ] SOLID principles applied
- [ ] No hardcoded strings (use constants)
- [ ] Proper error handling everywhere

### Testing ✅
- [ ] Manual testing on 3+ Android devices
- [ ] Test all barcode formats (QR, EAN, UPC, etc.)
- [ ] Test all permission scenarios
- [ ] Test offline functionality completely
- [ ] Test memory leaks (Android Profiler)
- [ ] Test battery usage
- [ ] Test on different Android versions (7.0 - 14)
- [ ] Test edge cases (low light, damaged codes, etc.)

### Assets ✅
- [ ] App icon (all densities: hdpi, xhdpi, xxhdpi, xxxhdpi)
- [ ] Adaptive icon (Android 8.0+)
- [ ] Splash screen assets
- [ ] Feature graphic (1024x500)
- [ ] Screenshots (minimum 6, 1080x1920)
- [ ] Promotional images
- [ ] App video preview (optional)

### Documentation ✅
- [ ] README.md with setup instructions
- [ ] Code comments on complex functions
- [ ] Privacy policy document
- [ ] Terms of service (if needed)
- [ ] In-app help/tutorial
- [ ] Changelog

### Play Store Listing ✅
- [ ] App title (≤ 30 chars): "QuickScan Pro"
- [ ] Short description (≤ 80 chars)
- [ ] Full description (≤ 4000 chars)
- [ ] Keywords optimized for ASO
- [ ] Category: Tools
- [ ] Content rating: Everyone
- [ ] Privacy policy URL

### Build & Release ✅
- [ ] Signed release APK/AAB
- [ ] ProGuard rules configured
- [ ] App size < 25MB
- [ ] No debug code in release
- [ ] Version code & name set correctly
- [ ] Tested release build thoroughly

---

## 🎯 ACCEPTANCE CRITERIA

### The app is COMPLETE when:

#### Performance ✅
1. ✅ QR code detection in < 500ms on average device
2. ✅ Camera preview runs at 60 FPS
3. ✅ App launches in < 2 seconds (cold start)
4. ✅ Smooth scrolling in history (60 FPS)
5. ✅ No frame drops during scanning
6. ✅ APK/AAB size < 25MB

#### Functionality ✅
7. ✅ Works on Android 7.0 (API 24) and above
8. ✅ Scans all specified barcode formats
9. ✅ History stores 1000+ items without lag
10. ✅ Scan from gallery works perfectly
11. ✅ QR code generation works for all types
12. ✅ Batch scanning processes 50+ codes smoothly
13. ✅ Export functions work (CSV, PDF, text)

#### Reliability ✅
14. ✅ Zero crashes in 30-minute stress test
15. ✅ No memory leaks detected
16. ✅ Works 100% offline (except URL opening)
17. ✅ Graceful handling of all edge cases
18. ✅ Proper cleanup on app close

#### UX ✅
19. ✅ All permissions handled gracefully
20. ✅ Intuitive navigation (user tests passed)
21. ✅ Dark theme looks polished & consistent
22. ✅ All buttons have proper touch feedback
23. ✅ Loading states shown appropriately
24. ✅ Error messages are user-friendly

#### Polish ✅
25. ✅ No placeholder text anywhere
26. ✅ All images/icons high quality
27. ✅ Consistent spacing & alignment
28. ✅ Animations smooth (no jank)
29. ✅ Accessibility labels present
30. ✅ Passes Play Store review guidelines

---

## 🔥 FINAL INSTRUCTIONS FOR AI AGENT

### Step-by-Step Generation Order

1. **Setup (First)**
```
   Generate:
   - pubspec.yaml (all dependencies)
   - Directory structure (create folders)
   - .gitignore
   - README.md
```

2. **Core Foundation**
```
   Generate:
   - core/theme/colors.dart
   - core/theme/text_styles.dart
   - core/theme/app_theme.dart
   - core/constants/app_constants.dart
   - core/constants/strings.dart
   - main.dart (app initialization)
```

3. **Data Layer**
```
   Generate:
   - data/models/scan_history.dart
   - data/models/app_settings.dart
   - data/local/hive_service.dart
   - data/repositories (all repository files)
```

4. **Shared Components**
```
   Generate:
   - shared/widgets (all common widgets)
   - shared/extensions (all extension files)
   - core/services (permission, vibration, etc.)
```

5. **Features (One by One)**
```
   Generate in order:
   a) Onboarding feature (complete)
   b) Scanner feature (complete)
   c) History feature (complete)
   d) Generator feature (complete)
   e) Batch scan feature (complete)
   f) Settings feature (complete)
   g) Home/Navigation (complete)
```

6. **Platform-Specific**
```
   Generate:
   - android/app/src/main/AndroidManifest.xml
   - android/app/build.gradle
   - iOS Info.plist (if supporting iOS)
   - Launcher icons configuration
   - Splash screen configuration
```

7. **Polish & Finalization**
```
   - Test all features
   - Fix any errors
   - Optimize performance
   - Add comments
   - Generate documentation
```

### Code Quality Requirements

**Every file MUST:**
- ✅ Have proper imports (no unused)
- ✅ Use null safety correctly
- ✅ Follow Dart naming conventions
- ✅ Include comments for complex logic
- ✅ Have no TODO or FIXME comments
- ✅ Use const constructors where possible
- ✅ Handle errors gracefully
- ✅ Be production-ready (no placeholders)

### Success Metrics (Verify Before Claiming Done)
```bash
# Run these commands - ALL must pass:

flutter analyze
# → No issues found

flutter build apk --release
# → Build successful, APK < 25MB

# Manual testing checklist:
# ✓ App launches without crash
# ✓ Camera scans QR codes
# ✓ History saves and loads
# ✓ Generator creates QR codes
# ✓ All buttons work
# ✓ No visual glitches
# ✓ Smooth 60 FPS performance
```

---

## 💡 IMPORTANT NOTES FOR AI

1. **NO SHORTCUTS**
   - Every feature must be fully implemented
   - No "TODO: Implement this later"
   - No placeholder UI
   - No mock data

2. **PRODUCTION QUALITY**
   - This goes to Play Store
   - Real users will use it
   - No compromises on quality
   - Must be polished & professional

3. **TESTING IS MANDATORY**
   - Test each feature as you build
   - Verify on real device/emulator
   - Check for crashes
   - Validate UX flow

4. **ASK IF UNCLEAR**
   - Don't guess implementation details
   - Don't skip complex features
   - Follow this spec exactly
   - Maintain consistency

---

**BUILD THIS APP LIKE 1 MILLION USERS WILL DOWNLOAD IT TOMORROW** 🚀

This is a premium, production-ready application. No compromises. No shortcuts. Full implementation only.

---

## 🎯 FINAL CHECKLIST BEFORE SUBMISSION

- [ ] All features implemented and tested
- [ ] No compiler errors or warnings
- [ ] App runs smoothly on test devices
- [ ] Memory leaks checked and fixed
- [ ] APK size optimized (< 25MB)
- [ ] All assets included (icons, splash, etc.)
- [ ] Privacy policy created
- [ ] Play Store listing prepared
- [ ] Release build signed and tested
- [ ] Ready for Play Store upload

**When you can check ALL boxes above, the app is DONE.** ✅

Good luck building QuickScan Pro! 🚀