import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
import 'package:neplox_linkpreviewer/src/helper/ncard_view.dart';

void main() {
  testWidgets('honors dimensions and reloads when the URL changes',
      (tester) async {
    final requestedUrls = <String>[];
    Future<ElementModel> load(String url) async {
      requestedUrls.add(url);
      return ElementModel(title: url, link: url);
    }

    Widget preview(String url) => MaterialApp(
          home: Center(
            child: NeploxLinkPreviewer(
              url: url,
              metadataLoader: load,
              cardStyle: NCardStyle(width: 280, height: 120),
              linkPreviewOptions: NLinkPreviewOptions(
                thumbnailPreviewDirection: NThumbnailPreviewDirection.normal,
                urlLaunch: NURLLaunch.disable,
              ),
            ),
          ),
        );

    await tester.pumpWidget(preview('https://first.example'));
    await tester.pumpAndSettle();
    expect(find.text('https://first.example'), findsOneWidget);
    expect(tester.getSize(find.byType(NCardView)), const Size(280, 120));

    await tester.pumpWidget(preview('https://second.example'));
    await tester.pumpAndSettle();
    expect(find.text('https://second.example'), findsOneWidget);
    expect(requestedUrls, [
      'https://first.example',
      'https://second.example',
    ]);
  });

  testWidgets('offers a retry after metadata loading fails', (tester) async {
    var attempts = 0;
    Future<ElementModel> load(String _) async {
      attempts++;
      return attempts == 1
          ? ElementModel.empty()
          : ElementModel(title: 'Recovered', link: 'https://example.com');
    }

    await tester.pumpWidget(
      MaterialApp(
        home: NeploxLinkPreviewer(
          url: 'https://example.com',
          metadataLoader: load,
          cardStyle: NCardStyle(width: 280, height: 120),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unable to load link preview'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Recovered'), findsOneWidget);
    expect(attempts, 2);
  });

  testWidgets('content-wrap height grows as description lines increase',
      (tester) async {
    Future<ElementModel> load(String url) async => ElementModel(
          title: 'Wrapped title',
          description: url.contains('long')
              ? List.filled(30, 'Long responsive description').join(' ')
              : 'Short description',
          link: url,
        );

    Widget preview(String url) => MaterialApp(
          home: Center(
            child: NeploxLinkPreviewer(
              url: url,
              metadataLoader: load,
              cardStyle: NCardStyle(
                width: 220,
                heightMode: NCardHeightMode.contentWrap,
                minHeight: 72,
              ),
              typographyStyle: NTypographyStyle(bodyMaxLine: 8),
              linkPreviewOptions: NLinkPreviewOptions(
                thumbnailPreviewDirection: NThumbnailPreviewDirection.normal,
                urlLaunch: NURLLaunch.disable,
              ),
            ),
          ),
        );

    await tester.pumpWidget(preview('https://short.example'));
    await tester.pumpAndSettle();
    final shortHeight = tester.getSize(find.byType(NCardView)).height;

    await tester.pumpWidget(preview('https://long.example'));
    await tester.pumpAndSettle();
    final longHeight = tester.getSize(find.byType(NCardView)).height;

    expect(shortHeight, greaterThanOrEqualTo(72));
    expect(longHeight, greaterThan(shortHeight));
    expect(tester.takeException(), isNull);
  });
}
