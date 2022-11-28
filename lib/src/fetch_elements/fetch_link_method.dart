import 'package:html/parser.dart';
import 'package:http/http.dart';

import '../model/element_model.dart';



   Future fetchElements(url) async {
    try {
      final client = Client();
      var parsedUrl = Uri.parse(_validateUrl(url));
      final response = await client.get(parsedUrl);
      final document = parse(response.body);

      String? description, title, image, appleIcon, favIcon, link;

      var elements = document.getElementsByTagName('meta');
      final linkElements = document.getElementsByTagName('link');

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

      for (var tmp in linkElements) {
        if (tmp.attributes['rel'] == 'apple-touch-icon') {
          appleIcon = tmp.attributes['href'];
        }
        if (tmp.attributes['rel']?.contains('icon') == true) {
          favIcon = tmp.attributes['href'] ?? '';
        }
      }

      return ElementModel(title: title,description: description,image: image,appleIcon: appleIcon,favIcon: favIcon,link: link);
    } catch (e) {
      return ElementModel();
    }
  }

   _validateUrl(String url) {
    if (url.startsWith('http://') == true ||
        url.startsWith('https://') == true) {
      return url;
    } else {
      return 'http://$url';
    }
  }

