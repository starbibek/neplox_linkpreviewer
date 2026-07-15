import 'package:flutter_test/flutter_test.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';

void main() {
  test('empty strings count as an empty metadata model', () {
    expect(ElementModel(title: ' ', link: '').isEmpty(), isTrue);
    expect(ElementModel(link: 'https://example.com').isEmpty(), isFalse);
    expect(ElementModel(link: 'https://example.com').hasPreviewData, isFalse);
    expect(ElementModel(title: 'Example').hasPreviewData, isTrue);
  });

  test('metadata fields remain mutable for backwards compatibility', () {
    final model = ElementModel();
    model.title = 'Updated';
    model.link = 'https://example.com';

    expect(model.title, 'Updated');
    expect(model.link, 'https://example.com');
  });

  test('empty strings can be capitalized safely', () {
    expect(''.capitalize(), '');
    expect('preview'.capitalize(), 'Preview');
  });
}
