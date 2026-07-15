import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows fixed, wrapping, and metadata examples', (tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Link preview examples'), findsOneWidget);
    expect(find.text('Content-wrap height'), findsOneWidget);
    expect(find.text('Fixed height'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Metadata for custom UI'), 200);
    expect(find.text('Metadata for custom UI'), findsOneWidget);
  });
}
