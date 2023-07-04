import 'dart:developer';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/element_model.dart';

class NMetaFetcher {
  NMetaFetcher._();
  static final NMetaFetcher instance = NMetaFetcher._();

  ///Fetch Elements from the url.
  get fetchNow => (String url) => _nfetch(url);

  /// Fetch Elements from the url.
  Future<ElementModel> _nfetch(String url) async {
    cacheManager.init();
    SharedPreferences prefs =
        cacheManager.prefs ?? await SharedPreferences.getInstance();
    if (prefs.containsKey(url)) {
      ElementModel data = cacheManager.getCache(url);
      return Future.value(data);
    } else {
      ElementModel elementModel = await _fetchElements(url);
      cacheManager.setCache(elementModel);
      return elementModel;
    }
  }

  Future<ElementModel> _fetchElements(url) async {
    try {
      final client = Client(); //http client
      ///parsing url
      var parsedUrl = Uri.parse(_validateUrl(url));

      /// validate url
      final response = await client.get(parsedUrl);

      /// get response
      final document = parse(response.body);

      /// parse response body

      String? description, title, image, appleIcon, favIcon, link;

      /// declare variables

      var elements = document.getElementsByTagName('meta');

      /// get meta tags
      final linkElements = document.getElementsByTagName('link');

      /// get link tags

      /// fetch data from meta tags
      for (var tmp in elements) {
        if (tmp.attributes['property'] == 'og:title') {
          //fetch seo title
          title = tmp.attributes['content'];
        }
        //if seo title is empty then fetch normal title
        if (title == null || title.isEmpty) {
          title = document.getElementsByTagName('title')[0].text;
        }

        //fetch seo description
        if (description?.isNotEmpty == false &&
            tmp.attributes['property'] == 'og:description') {
          description = tmp.attributes['content'];
        }
        if (tmp.attributes['property'] == 'og:url') {
          link = tmp.attributes['content'];
        }
        //if seo description is empty then fetch normal description.
        if (description == null) {
          //fetch base title
          if (tmp.attributes['name'] == 'description') {
            description = tmp.attributes['content'];
          }
        }

        //fetch image
        if (tmp.attributes['property'] == 'og:image') {
          image = tmp.attributes['content'] ?? '';
        }
      }

      /// Looping through links to get icons from metadata
      for (var tmp in linkElements) {
        ///checking if the link exists
        if (tmp.attributes['rel'] == 'apple-touch-icon') {
          /// Assigning the link for appleIcon
          appleIcon = tmp.attributes['href'];
        }

        /// checking if the link exists
        if (tmp.attributes['rel']?.contains('icon') == true) {
          /// Assigning the link for favicon
          favIcon = tmp.attributes['href'] ?? '';
        }
      }

      /// return ElementModel object
      return ElementModel(
          title: title,
          description: description,
          image: image,
          appleIcon: appleIcon,
          favIcon: favIcon,
          link: link);
    } catch (e) {
      log('Error: $e', name: 'NeploxLinkPreviewer');
      return ElementModel();
    }
  }

  /// validate url
  _validateUrl(String url) {
    if (url.startsWith('http://') == true ||
        url.startsWith('https://') == true) {
      return url;
    } else {
      return 'http://$url';
    }
  }
}
