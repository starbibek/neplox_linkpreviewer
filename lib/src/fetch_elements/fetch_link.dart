import '../model/element_model.dart';
import 'fetch_link_method.dart';

/// Public metadata-fetching API for custom preview interfaces.
///
/// Use the shared [instance]. Successful results are cached for 24 hours.
/// Invalid URLs, request failures, and pages without usable metadata return
/// [ElementModel.empty].
class NeploxMetaDataFetcher {
  NeploxMetaDataFetcher._();

  /// Shared metadata fetcher.
  static final NeploxMetaDataFetcher instance = NeploxMetaDataFetcher._();

  /// Fetches metadata for [url].
  ///
  /// URLs without a scheme use HTTPS. Only HTTP and HTTPS are accepted.
  Future<ElementModel> fetchData(String url) =>
      NMetaFetcher.instance.fetch(url);
}
