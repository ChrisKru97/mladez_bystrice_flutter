import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';

/// Service for handling Firebase Analytics events throughout the app
class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  FirebaseAnalytics get analytics => _analytics;
  FirebaseCrashlytics get crashlytics => _crashlytics;

  /// Log when a song is viewed
  Future<void> logSongView(String songId, String songTitle) async {
    await _analytics.logEvent(
      name: 'song_view',
      parameters: {
        'song_id': songId,
        'song_title': songTitle,
      },
    );
  }

  /// Log when a song is added to favorites
  Future<void> logAddToFavorites(String songId, String songTitle) async {
    await _analytics.logEvent(
      name: 'add_to_favorites',
      parameters: {
        'song_id': songId,
        'song_title': songTitle,
      },
    );
  }

  /// Log when a song is removed from favorites
  Future<void> logRemoveFromFavorites(String songId, String songTitle) async {
    await _analytics.logEvent(
      name: 'remove_from_favorites',
      parameters: {
        'song_id': songId,
        'song_title': songTitle,
      },
    );
  }

  /// Log when a playlist is created
  Future<void> logPlaylistCreated(String playlistId, String playlistName) async {
    await _analytics.logEvent(
      name: 'playlist_created',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  /// Log when a song is added to a playlist
  Future<void> logAddToPlaylist(String songId, String songTitle, String playlistId, String playlistName) async {
    await _analytics.logEvent(
      name: 'add_to_playlist',
      parameters: {
        'song_id': songId,
        'song_title': songTitle,
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  /// Log when a song is presented (display mode)
  Future<void> logSongPresentation(String songId, String songTitle) async {
    await _analytics.logEvent(
      name: 'song_presentation',
      parameters: {
        'song_id': songId,
        'song_title': songTitle,
      },
    );
  }

  /// Log when a search is performed
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  /// Log when app settings are changed
  Future<void> logSettingsChanged(String setting, String value) async {
    await _analytics.logEvent(
      name: 'settings_changed',
      parameters: {
        'setting': setting,
        'value': value,
      },
    );
  }

  /// Log when a screen is viewed
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Log a custom event
  Future<void> logEvent({required String name, Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Log when chords are transposed
  Future<void> logChordTransposition(String songId, int transpose) async {
    await _analytics.logEvent(
      name: 'chord_transposition',
      parameters: {
        'song_id': songId,
        'transpose_value': transpose,
      },
    );
  }

  /// Log when font size is changed
  Future<void> logFontSizeChange(String songId, double fontSize) async {
    await _analytics.logEvent(
      name: 'font_size_change',
      parameters: {
        'song_id': songId,
        'font_size': fontSize,
      },
    );
  }

  /// Log when a song is removed from playlist
  Future<void> logRemoveFromPlaylist(String songId, String songTitle, String playlistId, String playlistName) async {
    await _analytics.logEvent(
      name: 'remove_from_playlist',
      parameters: {
        'song_id': songId,
        'song_title': songTitle,
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  /// Log when a playlist is deleted
  Future<void> logPlaylistDeleted(String playlistId, String playlistName) async {
    await _analytics.logEvent(
      name: 'playlist_deleted',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  /// Log when a playlist is presented
  Future<void> logPlaylistPresentation(String playlistId, String playlistName) async {
    await _analytics.logEvent(
      name: 'playlist_presentation',
      parameters: {
        'playlist_id': playlistId,
        'playlist_name': playlistName,
      },
    );
  }

  /// Log app launch
  Future<void> logAppLaunch() async {
    await _analytics.logAppOpen();
  }

  /// Log when data is loaded from Firestore
  Future<void> logDataSync(int songCount) async {
    await _analytics.logEvent(
      name: 'data_sync',
      parameters: {
        'song_count': songCount,
        'sync_type': 'firestore',
      },
    );
  }

  /// Log when data is loaded from local storage
  Future<void> logDataLoadLocal(int songCount) async {
    await _analytics.logEvent(
      name: 'data_load_local',
      parameters: {
        'song_count': songCount,
      },
    );
  }

  /// Record a non-fatal error to Crashlytics
  Future<void> recordError(dynamic error, StackTrace? stackTrace, {String? reason}) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: false,
    );
  }

  /// Record a fatal error to Crashlytics
  Future<void> recordFatalError(dynamic error, StackTrace? stackTrace, {String? reason}) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: true,
    );
  }

  /// Set user properties for analytics
  Future<void> setUserProperties({
    int? favoriteCount,
    int? playlistCount,
    String? lastSongViewed,
  }) async {
    if (favoriteCount != null) {
      await _analytics.setUserProperty(name: 'favorite_count', value: favoriteCount.toString());
    }
    if (playlistCount != null) {
      await _analytics.setUserProperty(name: 'playlist_count', value: playlistCount.toString());
    }
    if (lastSongViewed != null) {
      await _analytics.setUserProperty(name: 'last_song_viewed', value: lastSongViewed);
    }
  }

  /// Set custom keys for Crashlytics
  Future<void> setCrashlyticsKeys({
    int? songCount,
    String? currentScreen,
    String? userId,
  }) async {
    if (songCount != null) {
      await _crashlytics.setCustomKey('song_count', songCount);
    }
    if (currentScreen != null) {
      await _crashlytics.setCustomKey('current_screen', currentScreen);
    }
    if (userId != null) {
      await _crashlytics.setUserIdentifier(userId);
    }
  }
}
