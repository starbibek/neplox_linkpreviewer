import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/model/link_metadata.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global instance of the cache manager.
///
/// Use this instance throughout the application for consistent caching behavior.
final NCacheManager kCacheManager = NCacheManager.instance;

/// Manages caching of link metadata to improve performance and reduce network requests.
///
/// This class provides methods to store and retrieve [LinkMetadata] using
/// SharedPreferences as the underlying storage mechanism. It implements a
/// singleton pattern to ensure a single point of cache management.
class NCacheManager {
  /// Private constructor to enforce singleton pattern
  NCacheManager._();

  /// Singleton instance of the cache manager
  static final NCacheManager instance = NCacheManager._();

  /// SharedPreferences instance for persistent storage
  SharedPreferences? _prefs;

  /// Flag indicating if the cache manager has been initialized
  bool _initialized = false;

  /// Initializes the cache manager.
  ///
  /// This must be called before using any other cache operations.
  /// Subsequent calls will be ignored if already initialized.
  Future<void> init() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      debugPrint('Failed to initialize cache: $e');
    }
  }

  /// Stores metadata in the cache.
  ///
  /// [cache] The metadata to store
  /// Returns true if the operation was successful
  Future<bool> setCache(LinkMetadata cache) async {
    if (!_initialized || _prefs == null) {
      debugPrint('Cache not initialized');
      return false;
    }

    try {
      final data = jsonEncode(cache.toJson());
      return await _prefs!.setString(_getCacheKey(cache.link), data);
    } catch (e) {
      debugPrint('Error storing cache: $e');
      return false;
    }
  }

  /// Retrieves metadata from the cache.
  ///
  /// [link] The URL whose metadata should be retrieved
  /// Returns the cached metadata or an empty instance if not found
  LinkMetadata getCache(String link) {
    if (!_initialized || _prefs == null) {
      debugPrint('Cache not initialized');
      return LinkMetadata.empty();
    }

    try {
      final data = _prefs!.getString(_getCacheKey(link));
      if (data == null || data.isEmpty) {
        return LinkMetadata.empty();
      }

      return LinkMetadata.fromJson(jsonDecode(data));
    } catch (e) {
      debugPrint('Error retrieving cache: $e');
      return LinkMetadata.empty();
    }
  }

  /// Generates a unique cache key for a URL.
  ///
  /// [link] The URL to generate a key for
  String _getCacheKey(String? link) => 'neplox_cache_${link ?? ''}';

  /// Checks if the cache manager has been initialized.
  bool get isInitialized => _initialized;

  /// Gets the underlying SharedPreferences instance.
  ///
  /// May be null if not initialized.
  SharedPreferences? get prefs => _prefs;
}
