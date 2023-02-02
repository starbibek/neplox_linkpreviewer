import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/element_model.dart';
import 'fetch_link_method.dart';

/// Fetch Elements from the url.
Future<ElementModel> nfetch(String url) async {
  cacheManager.init();
  SharedPreferences prefs =
      cacheManager.prefs ?? await SharedPreferences.getInstance();
  if (prefs.containsKey(url)) {
    ElementModel data = cacheManager.getCache(url);
    return Future.value(data);
  } else {
    ElementModel elementModel = await fetchElements(url);
    cacheManager.setCache(elementModel);
    return elementModel;
  }
}

/// Neplox Link Fetcher.
class NeploxLinkMetaFetcher {
  // BEGIN SINGLETON
  NeploxLinkMetaFetcher._();
  static NeploxLinkMetaFetcher instance = NeploxLinkMetaFetcher._();
  // END SINGLETON

// BEGIN getData/ Fetch Meta Data

  ///Get Data from Element
  ///
  ///[url] is the url of the website you want to fetch data from
  ///
  ///return ElementModel from the url
  Future<ElementModel> getData(String url) async => await nfetch(url);
  // END getData/ Fetch Meta Data
}
