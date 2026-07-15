import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/helper/ncard_view.dart';
import 'package:neplox_linkpreviewer/src/helper/style/styles.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';

void main() {
  testWidgets('renders every thumbnail direction in bounded space',
      (tester) async {
    for (final direction in NThumbnailPreviewDirection.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 320,
              height: 140,
              child: NCardView(
                snapshot: ElementModel(
                  title: 'Title',
                  description: 'Description',
                  link: 'https://example.com',
                ),
                linkPreviewOptions: NLinkPreviewOptions(
                  urlLaunch: NURLLaunch.disable,
                  thumbnailPreviewDirection: direction,
                ),
                nTypographyStyle: NTypographyStyle(),
                nCardStyle: NCardStyle(),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull, reason: direction.name);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    }
  });

  testWidgets('does not render null for absent text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 140,
          child: NCardView(
            snapshot: ElementModel(image: 'not-a-url'),
            linkPreviewOptions: NLinkPreviewOptions(),
            nTypographyStyle: NTypographyStyle(),
            nCardStyle: NCardStyle(),
          ),
        ),
      ),
    );

    expect(find.text('null'), findsNothing);
    expect(find.byIcon(Icons.link), findsOneWidget);
  });

  testWidgets('positions title above description with configured spacing',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 360,
            height: 140,
            child: NCardView(
              snapshot: ElementModel(
                title: 'Card title',
                description: 'Card description',
              ),
              linkPreviewOptions: NLinkPreviewOptions(
                thumbnailPreviewDirection: NThumbnailPreviewDirection.normal,
                urlLaunch: NURLLaunch.disable,
              ),
              nTypographyStyle: NTypographyStyle(),
              nCardStyle: NCardStyle(
                contentPadding: const EdgeInsets.all(16),
                textSpacing: 12,
              ),
            ),
          ),
        ),
      ),
    );

    final titleBottom = tester.getBottomLeft(find.text('Card title')).dy;
    final descriptionTop = tester.getTopLeft(find.text('Card description')).dy;
    expect(descriptionTop - titleBottom, greaterThanOrEqualTo(12));
  });

  testWidgets('changes a narrow side layout into a vertical layout',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 200,
            height: 160,
            child: NCardView(
              snapshot: ElementModel(title: 'Responsive title'),
              linkPreviewOptions: NLinkPreviewOptions(
                thumbnailPreviewDirection: NThumbnailPreviewDirection.ltr,
                urlLaunch: NURLLaunch.disable,
              ),
              nTypographyStyle: NTypographyStyle(),
              nCardStyle: NCardStyle(verticalThumbnailFraction: 0.4),
            ),
          ),
        ),
      ),
    );

    final imageSurface = find.ancestor(
      of: find.byIcon(Icons.link),
      matching: find.byType(ColoredBox),
    );
    expect(tester.getSize(imageSurface.first).height, 64);
    expect(
      tester.getCenter(find.byIcon(Icons.link)).dy,
      lessThan(tester.getTopLeft(find.text('Responsive title')).dy),
    );
  });
}
