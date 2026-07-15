import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neplox Link Previewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PreviewExamplesPage(),
    );
  }
}

class PreviewExamplesPage extends StatelessWidget {
  const PreviewExamplesPage({super.key});

  static const articleUrl =
      'https://ekantipur.com/news/2023/02/05/167556100681196555.html';
  static const videoUrl = 'https://www.youtube.com/watch?v=A9hcJgtnm6Q';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link preview examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle(
            title: 'Content-wrap height',
            description: 'The card grows as title and description lines wrap.',
          ),
          NeploxLinkPreviewer(
            url: articleUrl,
            cardStyle: NCardStyle(
              width: double.infinity,
              heightMode: NCardHeightMode.contentWrap,
              minHeight: 110,
              contentPadding: const EdgeInsets.all(14),
              textSpacing: 8,
              horizontalThumbnailFraction: 0.32,
            ),
            typographyStyle: NTypographyStyle(
              titleFontSize: 17,
              titleMaxLine: 3,
              bodyFontSize: 13,
              bodyMaxLine: 6,
            ),
            linkPreviewOptions: NLinkPreviewOptions(
              thumbnailPreviewDirection: NThumbnailPreviewDirection.ltr,
              urlLaunchIn: NURLLaunchIn.browser,
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(
            title: 'Fixed height',
            description: 'Useful when every card in a list must be uniform.',
          ),
          NeploxLinkPreviewer(
            url: videoUrl,
            cardStyle: NCardStyle(
              width: double.infinity,
              height: 150,
              heightMode: NCardHeightMode.fixed,
              contentPadding: const EdgeInsets.all(12),
              verticalThumbnailFraction: 0.48,
            ),
            typographyStyle: NTypographyStyle(titleMaxLine: 2, bodyMaxLine: 2),
            linkPreviewOptions: NLinkPreviewOptions(
              thumbnailPreviewDirection: NThumbnailPreviewDirection.rtl,
              urlLaunchIn: NURLLaunchIn.app,
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(
            title: 'Metadata for custom UI',
            description:
                'The fetcher can be used without the built-in card widget.',
          ),
          const MetadataExample(url: articleUrl),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class MetadataExample extends StatefulWidget {
  const MetadataExample({super.key, required this.url});

  final String url;

  @override
  State<MetadataExample> createState() => _MetadataExampleState();
}

class _MetadataExampleState extends State<MetadataExample> {
  late Future<ElementModel> _metadata;

  @override
  void initState() {
    super.initState();
    _metadata = NeploxMetaDataFetcher.instance.fetchData(widget.url);
  }

  @override
  void didUpdateWidget(covariant MetadataExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _metadata = NeploxMetaDataFetcher.instance.fetchData(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ElementModel>(
      future: _metadata,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final metadata = snapshot.data;
        if (metadata == null || !metadata.hasPreviewData) {
          return const Text('Metadata could not be loaded.');
        }
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.data_object),
          title: Text(metadata.title ?? 'Untitled page'),
          subtitle: Text(metadata.description ?? metadata.link ?? widget.url),
        );
      },
    );
  }
}
