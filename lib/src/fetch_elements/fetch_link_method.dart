import 'dart:developer';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http; // Renamed to avoid conflicts
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NMetaFetcher {
  NMetaFetcher._();
  static final NMetaFetcher instance = NMetaFetcher._();

  static const Duration defaultCacheDuration = Duration(hours: 24);
  Duration _cacheDuration = defaultCacheDuration;

  // HTTP Client configuration
  static const Duration _timeout = Duration(seconds: 10);
  final _client = http.Client();

  // Supported metadata tag mappings
  static const Map<String, String> _metaTagMappings = {
    'og:title': 'title',
    'twitter:title': 'title',
    'og:description': 'description',
    'twitter:description': 'description',
    'description': 'description',
    'og:image': 'image',
    'twitter:image': 'image',
    'og:url': 'link',
    'canonical': 'link',
  };

  void setCacheDuration(Duration duration) => _cacheDuration = duration;
  void disableCache() => _cacheDuration = Duration.zero;
  void resetCacheDuration() => _cacheDuration = defaultCacheDuration;

  Future<LinkMetadata> fetch(String url) async {
    if (url.isEmpty) {
      log('Empty URL provided', name: 'NeploxLinkPreviewer');
      return LinkMetadata.empty();
    }

    try {
      final validUrl = _validateUrl(url);
      final prefs = kCacheManager.prefs;

      if (prefs == null) {
        return await _fetchElements(validUrl);
      }

      final LinkMetadata? cachedData = await _getCachedData(validUrl, prefs);
      if (cachedData != null) return cachedData;

      final LinkMetadata freshData = await _fetchElements(validUrl);
      await _cacheData(freshData, validUrl, prefs);

      return freshData;
    } catch (e) {
      log('Error in fetch: $e', name: 'NeploxLinkPreviewer');
      return LinkMetadata.empty();
    }
  }

  Future<LinkMetadata?> _getCachedData(
      String url, SharedPreferences prefs) async {
    if (_cacheDuration <= Duration.zero || !prefs.containsKey(url)) {
      return null;
    }

    final LinkMetadata cachedData = kCacheManager.getCache(url);
    final String? cachedTimeStr = prefs.getString('${url}_cachedAt');

    if (cachedTimeStr == null) {
      return null;
    }

    try {
      final cachedTime = DateTime.parse(cachedTimeStr);
      if (DateTime.now().difference(cachedTime) <= _cacheDuration &&
          !cachedData.isEmpty) {
        return cachedData;
      }
    } catch (e) {
      log('Invalid cache timestamp', name: 'NeploxLinkPreviewer');
    }

    // Clear invalid/expired cache
    await Future.wait([
      prefs.remove(url),
      prefs.remove('${url}_cachedAt'),
    ]);

    return null;
  }

  Future<void> _cacheData(
      LinkMetadata data, String url, SharedPreferences prefs) async {
    if (_cacheDuration > Duration.zero && !data.isEmpty) {
      await Future.wait<void>([
        kCacheManager.setCache(data).then((_) {}),
        prefs.setString('${url}_cachedAt', DateTime.now().toString()),
      ]);
    }
  }

  Future<LinkMetadata> _fetchElements(String url) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {'Accept': 'text/html,application/xhtml+xml'},
      ).timeout(_timeout);

      if (response.statusCode != 200) {
        throw HttpException('Failed to fetch URL: ${response.statusCode}');
      }

      final document = parse(response.body);
      final metadata = _extractMetadata(document);

      return LinkMetadata(
        title: metadata['title'],
        description: metadata['description'],
        image: metadata['image'],
        appleIcon: metadata['appleIcon'],
        favIcon: metadata['favIcon'],
        link: metadata['link'] ?? url,
      );
    } catch (e) {
      log('Error fetching elements: $e', name: 'NeploxLinkPreviewer');
      return LinkMetadata.empty();
    }
  }

  Map<String, String?> _extractMetadata(Document document) {
    final Map<String, String?> metadata = {};

    // Extract title from various sources
    metadata['title'] = _extractTitle(document);

    // Extract metadata from meta tags
    for (var meta in document.getElementsByTagName('meta')) {
      final property = meta.attributes['property'];
      final name = meta.attributes['name'];
      final content = meta.attributes['content'];

      if (property != null && _metaTagMappings.containsKey(property)) {
        metadata[_metaTagMappings[property]!] ??= content;
      } else if (name != null && _metaTagMappings.containsKey(name)) {
        metadata[_metaTagMappings[name]!] ??= content;
      }
    }

    // Extract icons
    _extractIcons(document, metadata);

    return metadata;
  }

  String? _extractTitle(Document document) {
    // Try OpenGraph title first
    final ogTitle = document
        .querySelector('meta[property="og:title"]')
        ?.attributes['content'];
    if (ogTitle?.isNotEmpty == true) return ogTitle;

    // Try Twitter title
    final twitterTitle = document
        .querySelector('meta[name="twitter:title"]')
        ?.attributes['content'];
    if (twitterTitle?.isNotEmpty == true) return twitterTitle;

    // Fallback to regular title tag
    return document.querySelector('title')?.text;
  }

  void _extractIcons(Document document, Map<String, String?> metadata) {
    for (var link in document.getElementsByTagName('link')) {
      final rel = link.attributes['rel'];
      final href = link.attributes['href'];

      if (rel == 'apple-touch-icon') {
        metadata['appleIcon'] = _normalizeUrl(href);
      } else if (rel?.contains('icon') == true) {
        metadata['favIcon'] = _normalizeUrl(href);
      }
    }
  }

  String? _normalizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    return url.startsWith('http') ? url : 'https:$url';
  }

  String _validateUrl(String url) {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    return url.trim();
  }

  // Clean up resources
  void dispose() {
    _client.close();
  }
}
