import 'dart:async';
import 'dart:developer';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';

import '../model/element_model.dart';

/// Fetches and caches metadata for HTTP and HTTPS pages.
class NMetaFetcher {
  NMetaFetcher._({http.Client? client}) : _client = client ?? http.Client();

  static final NMetaFetcher instance = NMetaFetcher._();

  /// Creates an isolated fetcher for package tests and advanced integrations.
  /// Most applications should use [instance].
  NMetaFetcher.withClient(http.Client client) : _client = client;

  final http.Client _client;

  /// Maximum age of a successful metadata response.
  final Duration cacheDuration = const Duration(hours: 24);

  /// Maximum time spent waiting for the page response.
  final Duration requestTimeout = const Duration(seconds: 15);

  /// Returns metadata for [url], preferring a valid cached response.
  ///
  /// Invalid URLs, non-success HTTP responses, timeouts, and parsing failures
  /// return [ElementModel.empty]. This preserves the package's original API
  /// while allowing the preview widget to display a stable error state.
  Future<ElementModel> fetch(String url) async {
    final uri = _normalizeUrl(url);
    if (uri == null) return ElementModel.empty();

    final cacheKey = uri.toString();
    final cached = await cacheManager.get(cacheKey, cacheDuration);
    if (cached != null) return cached;

    final metadata = await _fetchElements(uri);
    await cacheManager.set(cacheKey, metadata);
    return metadata;
  }

  Future<ElementModel> _fetchElements(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(requestTimeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        log(
          'Metadata request returned HTTP ${response.statusCode}',
          name: 'NeploxLinkPreviewer',
        );
        return ElementModel.empty();
      }

      final contentType = response.headers['content-type']?.toLowerCase();
      if (contentType != null &&
          !contentType.contains('text/html') &&
          !contentType.contains('application/xhtml+xml')) {
        log(
          'Metadata response is not HTML: $contentType',
          name: 'NeploxLinkPreviewer',
        );
        return ElementModel.empty();
      }

      final document = parse(response.body);
      final metadata = _metadata(document);
      final baseUri = response.request?.url ?? uri;

      final title =
          _firstContent(metadata, const ['og:title', 'twitter:title']) ??
              _nonEmpty(document.querySelector('title')?.text);
      final description = _firstContent(
        metadata,
        const ['og:description', 'twitter:description', 'description'],
      );
      final image = _resolveUrl(
        baseUri,
        _firstContent(metadata, const ['og:image', 'twitter:image']),
      );
      final canonicalLink = _resolveUrl(
        baseUri,
        _firstContent(metadata, const ['og:url']),
      );

      return ElementModel(
        title: title,
        description: description,
        image: image,
        appleIcon: _findIcon(document, baseUri, apple: true),
        favIcon: _findIcon(document, baseUri, apple: false),
        link: canonicalLink ?? baseUri.toString(),
      );
    } on TimeoutException {
      log('Metadata request timed out', name: 'NeploxLinkPreviewer');
      return ElementModel.empty();
    } on Object catch (error, stackTrace) {
      log(
        'Could not fetch metadata',
        name: 'NeploxLinkPreviewer',
        error: error,
        stackTrace: stackTrace,
      );
      return ElementModel.empty();
    }
  }

  Map<String, String> _metadata(Document document) {
    final values = <String, String>{};
    for (final meta in document.querySelectorAll('meta')) {
      final key = _nonEmpty(meta.attributes['property']) ??
          _nonEmpty(meta.attributes['name']);
      final content = _nonEmpty(meta.attributes['content']);
      if (key != null && content != null) {
        values.putIfAbsent(key.toLowerCase(), () => content);
      }
    }
    return values;
  }

  String? _firstContent(Map<String, String> metadata, List<String> keys) {
    for (final key in keys) {
      final value = metadata[key];
      if (value != null) return value;
    }
    return null;
  }

  String? _findIcon(Document document, Uri baseUri, {required bool apple}) {
    for (final element in document.querySelectorAll('link[rel][href]')) {
      final rel =
          element.attributes['rel']!.toLowerCase().split(RegExp(r'\s+'));
      final matches = apple
          ? rel.contains('apple-touch-icon')
          : rel.any((value) => value == 'icon' || value == 'shortcut');
      if (matches) return _resolveUrl(baseUri, element.attributes['href']);
    }
    return null;
  }

  Uri? _normalizeUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final withScheme = trimmed.contains('://') ? trimmed : 'https://$trimmed';
    final uri = Uri.tryParse(withScheme);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }
    return uri.removeFragment();
  }

  String? _resolveUrl(Uri baseUri, String? value) {
    final content = _nonEmpty(value);
    if (content == null) return null;
    final reference = Uri.tryParse(content);
    if (reference == null) return null;
    final resolved = baseUri.resolveUri(reference);
    return resolved.scheme == 'http' || resolved.scheme == 'https'
        ? resolved.toString()
        : null;
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
