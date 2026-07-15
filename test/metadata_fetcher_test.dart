import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('extracts metadata and resolves relative URLs', () async {
    final client = MockClient((request) async {
      expect(request.url, Uri.parse('https://example.com/articles/one'));
      return http.Response(
          '''
        <html>
          <head>
            <title>Fallback title</title>
            <meta property="og:title" content="Preview title">
            <meta name="description" content="Preview description">
            <meta property="og:image" content="/images/preview.jpg">
            <link rel="icon" href="../favicon.ico">
          </head>
        </html>
      ''',
          200,
          headers: {'content-type': 'text/html; charset=utf-8'});
    });

    final result = await NMetaFetcher.withClient(client).fetch(
      'example.com/articles/one',
    );

    expect(result.title, 'Preview title');
    expect(result.description, 'Preview description');
    expect(result.image, 'https://example.com/images/preview.jpg');
    expect(result.favIcon, 'https://example.com/favicon.ico');
    expect(result.link, 'https://example.com/articles/one');
  });

  test('returns an empty result for unsuccessful HTTP responses', () async {
    final client = MockClient((_) async => http.Response('Not found', 404));

    final result = await NMetaFetcher.withClient(client).fetch(
      'https://not-found.example/test',
    );

    expect(result.isEmpty(), isTrue);
  });

  test('rejects unsupported and malformed URLs without a request', () async {
    var requested = false;
    final client = MockClient((_) async {
      requested = true;
      return http.Response('', 200);
    });
    final fetcher = NMetaFetcher.withClient(client);

    expect((await fetcher.fetch('file:///secret')).isEmpty(), isTrue);
    expect((await fetcher.fetch('')).isEmpty(), isTrue);
    expect(requested, isFalse);
  });

  test('rejects explicit non-HTML content types', () async {
    final client = MockClient(
      (_) async => http.Response(
        '%PDF',
        200,
        headers: {'content-type': 'application/pdf'},
      ),
    );

    final result = await NMetaFetcher.withClient(client).fetch(
      'https://files.example/document.pdf',
    );

    expect(result.isEmpty(), isTrue);
  });

  test('resolves relative metadata against the final response URL', () async {
    final finalRequest = http.Request(
      'GET',
      Uri.parse('https://cdn.example/articles/final/'),
    );
    final client = MockClient(
      (_) async => http.Response(
        '<meta property="og:title" content="Redirected">'
        '<meta property="og:image" content="preview.jpg">',
        200,
        request: finalRequest,
      ),
    );

    final result = await NMetaFetcher.withClient(client).fetch(
      'https://example.com/old-location',
    );

    expect(result.image, 'https://cdn.example/articles/final/preview.jpg');
    expect(result.link, 'https://cdn.example/articles/final/');
  });

  test('removes fragments before requesting and caching a URL', () async {
    Uri? requestedUrl;
    final client = MockClient((request) async {
      requestedUrl = request.url;
      return http.Response(
        '<title>Fragment-free</title>',
        200,
        headers: {'content-type': 'text/html'},
      );
    });

    await NMetaFetcher.withClient(client).fetch(
      'https://fragment.example/article#comments',
    );

    expect(requestedUrl, Uri.parse('https://fragment.example/article'));
  });

  test('does not cache a successful response without preview data', () async {
    var requests = 0;
    final client = MockClient((_) async {
      requests++;
      return http.Response('<html></html>', 200);
    });
    final fetcher = NMetaFetcher.withClient(client);
    const url = 'https://blank.example/page';

    expect((await fetcher.fetch(url)).hasPreviewData, isFalse);
    expect((await fetcher.fetch(url)).hasPreviewData, isFalse);
    expect(requests, 2);
  });

  test('reuses a successful cached response', () async {
    var requests = 0;
    final client = MockClient((_) async {
      requests++;
      return http.Response(
        '<title>Cached title</title>',
        200,
        headers: {'content-type': 'text/html'},
      );
    });
    final fetcher = NMetaFetcher.withClient(client);
    const url = 'https://cached.example/unique-page';

    expect((await fetcher.fetch(url)).title, 'Cached title');
    expect((await fetcher.fetch(url)).title, 'Cached title');
    expect(requests, 1);
  });
}
