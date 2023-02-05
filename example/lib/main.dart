import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> urls = [
    "https://ekantipur.com/news/2023/02/05/167556100681196555.html",
    "https://www.youtube.com/watch?v=A9hcJgtnm6Q&list=RDRDwrng3YkNU&index=5",
    "https://shobhit.com.np/flubot-warning-over-major-android-package-delivery-scam/2193/",
    "https://www.youtube.com/watch?v=q_HEQajNwyY&list=RDq_HEQajNwyY&start_radio=1",
    "https://www.youtube.com/watch?v=qik_1dDvzEs&list=RDq_HEQajNwyY&index=3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return LinkPreviwer(
                url: urls[index],
              );
            }));
  }
}

class LinkPreviwer extends StatefulWidget {
  const LinkPreviwer({super.key, required this.url});
  final String url;

  @override
  State<LinkPreviwer> createState() => _LinkPreviwerState();
}

class _LinkPreviwerState extends State<LinkPreviwer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),

      /// NeploxLinkPreviewer is the main widget that will show the preview of the link
      child: NeploxLinkPreviewer(
        url: widget.url,
        linkPreviewOptions: NLinkPreviewOptions(
            urlLaunch: NURLLaunch.enable,
            urlLaunchIn: NURLLaunchIn.browser,
            thumbnailPreviewDirection: NThumbnailPreviewDirection.bottom),
      ),
    );
  }
}

class ExampleMetaFetcher extends StatefulWidget {
  const ExampleMetaFetcher({super.key});

  @override
  State<ExampleMetaFetcher> createState() => _ExampleMetaFetcherState();
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
