# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Running
- `flutter run` - Run the app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter build web` - Build web version

### Code Quality
- `flutter analyze` - Run static analysis
- `flutter test` - Run unit tests
- `dart run build_runner build` - Generate ObjectBox code (required after modifying entities)

### Dependencies
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter clean` - Clean build cache

## Architecture Overview

This is a Flutter songbook application ("Bystřický mládežový zpěvník") with the following key architectural components:

### State Management
- **GetX**: Primary state management solution using controllers
- **ObjectBox**: Local database for offline storage
- **Firebase**: Backend services (Firestore, Auth, Analytics, Crashlytics)

### Core Controllers
- `SongsController` (lib/bloc/songs_controller.dart): Manages song data, search, favorites, history
- `PlaylistController` (lib/bloc/playlist_controller.dart): Handles playlist operations
- `ConfigController` (lib/bloc/config_controller.dart): App configuration and settings
- `ThemeController` (lib/controllers/theme_controller.dart): Theme management

### Data Models
- `Song` (lib/classes/song.dart): Main song entity with ObjectBox annotations
- `Playlist` (lib/classes/playlist.dart): Playlist data structure
- `HistoryEntry` (lib/classes/history_entry.dart): Song access history
- `Config` (lib/classes/config.dart): App configuration

### Key Features
- **Offline-first**: Songs stored locally with ObjectBox, synced from Firestore
- **Chord transposition**: Musical chord manipulation in helpers/transposition.dart
- **Search**: Diacritic-insensitive search with preprocessed search values
- **Themes**: Light/dark theme support with custom design system
- **Analytics**: Firebase Analytics integration for user behavior tracking
- **Presentation mode**: Special UI for displaying songs/playlists

### Navigation Structure
- Root route `/` → MainScreen (lib/main_screen.dart)
- `/song` → SongDisplay (lib/song_display.dart) - Individual song view
- `/present-song` → PresentSong - Presentation mode for songs
- `/playlist` → PlaylistDisplay - Playlist view
- `/present-playlist` → PresentPlaylist - Presentation mode for playlists
- `/favorite`, `/history`, `/playlists` → Respective list screens

### Firebase Integration
- Anonymous authentication for analytics
- Firestore collection `songs_next` for song data
- Crashlytics for error tracking
- Analytics for user behavior

### UI Components
- Modern Material Design with custom theme (lib/theme/)
- Native Flutter animations for smooth UI transitions
- Chord display with custom text rendering (lib/components/text_with_chords.dart)
- Responsive design supporting different screen sizes

#### Shared Reusable Widgets

**Layout & Structure:**
- `CommonAppBar` (lib/components/common_app_bar.dart): Consistent app bar with gradient background and proper theming
- `GradientBackground` (lib/components/gradient_background.dart): Background container with gradient and glass effects
- `GlassContainer` (lib/components/animated_components.dart): Glassmorphism container with customizable opacity

**Lists & Items:**
- `SongListView` (lib/components/song_list_view.dart): Reusable song list with loading, empty states, and refresh capability
- `SongListItem` (lib/components/song_list_item.dart): Modern song item with animations, favorite icon, and tap handling
- `SongListTile` (lib/components/song_list_tile.dart): Simple list tile variant for consistent song display
- `EmptyState` (lib/components/empty_state.dart): Consistent empty state display with icon, title, and subtitle
- `LoadingState` (lib/components/loading_state.dart): Loading indicator with message

**Interactive Elements:**
- `FavoriteIcon` (lib/components/favorite_icon.dart): Animated favorite toggle with design system colors
- `ActionButton` (lib/components/action_button.dart): Reusable action button with haptic feedback and animations
- `ModernNavButton` (lib/components/menu_row.dart): Navigation button with advanced animations and hover effects

**Dialogs:**
- `BottomDialogContainer` (lib/dialogs/bottom_dialog_container.dart): Base container for bottom sheets with design system styling
- `ConfirmationDialog` (lib/components/confirmation_dialog.dart): Reusable confirmation dialog with customizable text and actions
- `ConfirmRemove` (lib/dialogs/confirm_remove.dart): Specific removal confirmation using ConfirmationDialog

**Utilities:**
- `DismissibleRemove` (lib/components/dismissible_remove.dart): Swipe-to-remove functionality wrapper
- `PresentationScreenBase` (lib/components/presentation_screen_base.dart): Base class for presentation mode screens

#### Widget Development Guidelines

When creating or modifying widgets, follow these principles:

1. **DRY (Don't Repeat Yourself)**: Use existing reusable components where possible
2. **KISS (Keep It Simple, Stupid)**: Prefer simple, focused widgets over complex ones
3. **Design System Consistency**: Always use colors, spacing, and typography from `lib/theme/design_system.dart`
4. **Accessibility**: Consider accessibility features like proper contrast and semantic labels
5. **Performance**: Use `const` constructors when possible and minimize rebuilds with proper state management

**Preferred Widget Patterns:**
- Use `SongListView` for displaying lists of songs
- Use `CommonAppBar` for consistent app bars
- Use `ConfirmationDialog` for user confirmations
- Use design system colors (`AppColors.*`) instead of hardcoded colors
- Use design system spacing (`AppSpacing.*`) for consistent layouts

### ObjectBox Database
- `objectbox-model.json` defines the schema
- `objectbox.g.dart` contains generated code
- Run `dart run build_runner build` after modifying entities

### Development Notes
- Uses Firebase for backend services - ensure firebase_options.dart is properly configured
- MCP Toolkit integration for development tooling
- Wakelock enabled during song display to prevent screen timeout
- Font scaling and chord transposition are persisted per song
- Search preprocessing removes diacritics for Czech language support