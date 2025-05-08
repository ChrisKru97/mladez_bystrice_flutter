import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

/// Service for handling Firebase Analytics events throughout the app
class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

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
}
