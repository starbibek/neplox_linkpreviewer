# neplox_linkpreviewer

The `neplox_linkpreviewer` package is a Flutter package that allows you to fetch metadata from a URL link and provides a link preview. It also allows users to customize the link preview and fetched metadata to implement them in their own Widgets.

## Installation

Add `neplox_linkpreviewer` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  neplox_linkpreviewer: ^1.0.0
```

## Usage

To fetch a link preview from a URL, you can use the `NeploxLinkPreviewer` widget:

```dart
class LinkPreviewer extends StatefulWidget {
  const LinkPreviewer({Key? key, required this.url});
  final String url;

  @override
  _LinkPreviewerState createState() => _LinkPreviewerState();
}

class _LinkPreviewerState extends State<LinkPreviewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: NeploxLinkPreviewer(
        url: widget.url,
        linkPreviewOptions: NLinkPreviewOptions(
          urlContentType: NURLContentType.video,
          urlLaunch: NURLLaunch.enable,
          urlLaunchIn: NURLLaunchIn.browser,
          thumbnailPreviewDirection: NThumbnailPreviewDirection.bottom,
        ),
      ),
    );
  }
}
```

In the above example, the `NeploxLinkPreviewer` widget is used to fetch and display the link preview for the specified `url`. You can customize the link preview options by providing a `NLinkPreviewOptions` object.

To fetch metadata for your own Widget, you can use the `NeploxMetaDataFetcher`:

```dart
class ExampleMetaFetcher extends StatefulWidget {
  const ExampleMetaFetcher({Key? key});

  @override
  _ExampleMetaFetcherState createState() => _ExampleMetaFetcherState();
}

class _ExampleMetaFetcherState extends State<ExampleMetaFetcher> {
  final NeploxMetaDataFetcher _metaDataFetcher = NeploxMetaDataFetcher.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ElementModel>(
      future: _metaDataFetcher.fetchData(
          "https://ekantipur.com/news/2023/02/05/167556100681196555.html"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data?.title.toString() ?? "No Title");
        } else {
          return const Text("No data");
        }
      },
    );
  }
}
```

In the above example, the `NeploxMetaDataFetcher` is used to fetch metadata for the specified URL. The fetched data can be used to implement your own Widget. The `fetchData` method returns a `Future` that resolves to an `ElementModel` object containing the fetched metadata.

## Documentation

For more details and advanced usage, please refer to the [API documentation](https://pub.dev/documentation/neplox_linkpreviewer/latest/).

## License

This package is released under the [MIT License](https://opensource.org/licenses/MIT).
