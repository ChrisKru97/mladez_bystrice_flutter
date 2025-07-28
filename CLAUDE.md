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
- Animated components using flutter_animate
- Chord display with custom text rendering (lib/components/text_with_chords.dart)
- Responsive design supporting different screen sizes

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