import 'dart:convert';

import 'package:neplox_linkpreviewer/src/model/element_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared metadata cache used by the package.
final NCacheManager cacheManager = NCacheManager.instance;

/// Stores link metadata in [SharedPreferences].
///
/// Cache keys are based on the URL requested by the caller. They intentionally
/// do not use the page's canonical URL because that value is optional and may
/// differ from the requested URL.
class NCacheManager {
  NCacheManager._();

  static final NCacheManager instance = NCacheManager._();

  static const String _dataPrefix = 'neplox.metadata.';
  static const String _timePrefix = 'neplox.cachedAt.';

  SharedPreferences? _preferences;
  Future<SharedPreferences>? _initialization;

  Future<SharedPreferences> _prefs() {
    final existing = _preferences;
    if (existing != null) return Future.value(existing);

    return _initialization ??= SharedPreferences.getInstance().then((prefs) {
      _preferences = prefs;
      return prefs;
    });
  }

  /// Initializes the cache eagerly. Normal callers do not need to call this;
  /// all cache operations initialize themselves safely.
  Future<void> init() async {
    await _prefs();
  }

  /// Returns a non-expired cached value, or `null` when no usable entry exists.
  Future<ElementModel?> get(String url, Duration maxAge) async {
    final prefs = await _prefs();
    final data = prefs.getString('$_dataPrefix$url');
    final cachedAtValue = prefs.getString('$_timePrefix$url');

    if (data == null || cachedAtValue == null) {
      return null;
    }

    try {
      final cachedAt = DateTime.parse(cachedAtValue);
      final age = DateTime.now().difference(cachedAt);
      final model = ElementModel.fromJson(
        jsonDecode(data) as Map<String, dynamic>,
      );

      if (age.isNegative || age > maxAge || !model.hasPreviewData) {
        await remove(url);
        return null;
      }
      return model;
    } on Object {
      await remove(url);
      return null;
    }
  }

  /// Writes [metadata] and its timestamp atomically from the caller's point of
  /// view. Empty results are deliberately not cached so transient failures can
  /// be retried immediately.
  Future<void> set(String url, ElementModel metadata) async {
    if (!metadata.hasPreviewData) return;

    final prefs = await _prefs();
    await prefs.setString(
      '$_dataPrefix$url',
      ElementModel.elementModelToJson(metadata),
    );
    await prefs.setString(
      '$_timePrefix$url',
      DateTime.now().toIso8601String(),
    );
  }

  /// Removes both parts of a cache entry.
  Future<void> remove(String url) async {
    final prefs = await _prefs();
    await prefs.remove('$_dataPrefix$url');
    await prefs.remove('$_timePrefix$url');
  }
}
