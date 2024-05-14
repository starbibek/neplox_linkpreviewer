import '../model/element_model.dart';
import 'fetch_link_method.dart';

/// Neplox URL META DATA Fetcher.
class NeploxMetaDataFetcher {
  // BEGIN SINGLETON
  NeploxMetaDataFetcher._();
  static final NeploxMetaDataFetcher instance = NeploxMetaDataFetcher._();
  // END SINGLETON

// BEGIN getData/ Fetch Meta Data

  ///Get Data from Element
  ///
  ///[url] is the url of the website you want to fetch data from
  ///
  ///return ElementModel from the url
  Future<ElementModel> fetchData(String url) async =>
      await NMetaFetcher.instance.fetch(url);
  // END getData/ Fetch Meta Data
}
