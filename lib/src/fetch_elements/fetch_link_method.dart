import 'dart:developer';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http; // Renamed to avoid conflicts
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/element_model.dart';

class NMetaFetcher {
  NMetaFetcher._(); // Private constructor
  static final NMetaFetcher instance = NMetaFetcher._();

  /// Duration for caching metadata (adjust as needed)
  final Duration cacheDuration = const Duration(hours: 24); // Example: 24 hours

  /// Fetches metadata from the given URL, using a cache with expiration.
  Future<ElementModel> fetch(String url) async {
    cacheManager.init();
    SharedPreferences prefs =
        cacheManager.prefs ?? await SharedPreferences.getInstance();

    // Check if cached data exists and hasn't expired
    if (prefs.containsKey(url)) {
      final ElementModel cachedData = cacheManager.getCache(url);
      final cachedTime = DateTime.parse(prefs.getString('${url}_cachedAt')!);

      // Checking Cached Time and checking cached data is not empty
      if (DateTime.now().difference(cachedTime) <= cacheDuration &&
          !cachedData.isEmpty()) {
        return cachedData; // Return cached data if not expired
      } else {
        // Expired, so remove it
        prefs.remove(url);
        prefs.remove('${url}_cachedAt');
      }
    }

    // Fetch data from URL and cache it with timestamp
    ElementModel elementModel = await _fetchElements(url);
    cacheManager.setCache(elementModel);
    prefs.setString('${url}_cachedAt', DateTime.now().toString());
    return elementModel;
  }

  /// Fetches metadata elements (title, description, images, icons) from a URL.
  Future<ElementModel> _fetchElements(String url) async {
    try {
      final response = await http
          .get(Uri.parse(_validateUrl(url))); // Use renamed http client
      final document = parse(response.body);

      // Variables to store fetched data
      String? title, description, image, appleIcon, favIcon, link;

      // Extract metadata from meta tags
      for (var meta in document.getElementsByTagName('meta')) {
        String? property = meta.attributes['property'];

        switch (property) {
          case 'og:title':
            title ??= meta.attributes['content']; // Prioritize OpenGraph title
            break;
          case 'og:description':
            description ??=
                meta.attributes['content']; // Prioritize OpenGraph description
            break;
          case 'og:image':
            image = meta.attributes['content'] ?? '';
            break;
          case 'og:url': // Added to fetch the canonical URL
            link = meta.attributes['content'];
            break;
        }

        // Fallback to standard meta tags if OpenGraph not found
        if (title == null || title.isEmpty) {
          title = (document.getElementsByTagName('title').isNotEmpty)
              ? document.getElementsByTagName('title')[0].text
              : null; // Handle the case where the <title> tag may not exist
        }
        if (description == null && meta.attributes['name'] == 'description') {
          description = meta.attributes['content'];
        }
      }

      // Extract icons from link tags
      for (var linkElement in document.getElementsByTagName('link')) {
        String? rel = linkElement.attributes['rel'];

        if (rel == 'apple-touch-icon') {
          appleIcon = linkElement.attributes['href'];
        } else if (rel?.contains('icon') == true) {
          favIcon = linkElement.attributes['href'] ?? '';
        }
      }

      // Return fetched metadata
      return ElementModel(
        title: title,
        description: description,
        image: image,
        appleIcon: appleIcon,
        favIcon: favIcon,
        link: link,
      );
    } catch (e) {
      log('Error: $e', name: 'NeploxLinkPreviewer');
      return ElementModel.empty();
    }
  }

  /// Validates and adds "http://" if necessary.
  String _validateUrl(String url) {
    return url.startsWith('http') ? url : 'http://$url';
  }
}
