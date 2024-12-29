import 'dart:developer';

import '../model/link_metadata.dart';
import 'fetch_link_method.dart';

/// Neplox URL Metadata Fetcher
/// Provides a singleton interface for fetching metadata from URLs
class NeploxMetaDataFetcher {
  // Singleton implementation
  NeploxMetaDataFetcher._();
  static final NeploxMetaDataFetcher instance = NeploxMetaDataFetcher._();

  // Instance of the meta fetcher
  final _metaFetcher = NMetaFetcher.instance;

  /// Fetches metadata from a given URL
  ///
  /// [url] The URL to fetch metadata from
  /// Returns [LinkMetadata] containing the metadata
  Future<LinkMetadata> fetchData(String url) async {
    if (url.isEmpty) {
      log('Empty URL provided', name: 'NeploxMetaDataFetcher');
      return LinkMetadata.empty();
    }

    try {
      final internalModel = await _metaFetcher.fetch(url);
      return internalModel;
    } catch (e, stackTrace) {
      log('Error fetching metadata',
          error: e, stackTrace: stackTrace, name: 'NeploxMetaDataFetcher');
      return LinkMetadata.empty();
    }
  }

  /// Configure cache duration
  void setCacheDuration(Duration duration) {
    _metaFetcher.setCacheDuration(duration);
  }

  /// Disable caching
  void disableCache() {
    _metaFetcher.disableCache();
  }

  /// Reset cache duration to default
  void resetCacheDuration() {
    _metaFetcher.resetCacheDuration();
  }

  /// Clean up resources
  void dispose() {
    _metaFetcher.dispose();
  }
}
