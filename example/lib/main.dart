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
      debugShowCheckedModeBanner: false,
      title: 'Linkpreviewer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Link Preview'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@protected
class _UrlDataClass {
  final String url;
  final NThumbnailPreviewDirection previewDir;
  _UrlDataClass(this.url, this.previewDir);
}

class _MyHomePageState extends State<MyHomePage> {
  List<_UrlDataClass> data = [
    _UrlDataClass(
        "https://www.youtube.com/watch?v=q_HEQajNwyY&list=RDq_HEQajNwyY&start_radio=1",
        NThumbnailPreviewDirection.rtl),
    _UrlDataClass(
        "https://www.youtube.com/watch?v=A9hcJgtnm6Q&list=RDRDwrng3YkNU&index=5",
        NThumbnailPreviewDirection.normal),
    _UrlDataClass("https://www.youtube.com/watch?v=uhUht6vAsMY",
        NThumbnailPreviewDirection.top),
    _UrlDataClass(
        "https://www.cricket.com/news/npl-2024-chitwan-rhinos-aim-to-continue-momentum-after-comprehensive-win-1222024-1733147907772",
        NThumbnailPreviewDirection.ltr),
    _UrlDataClass(
        "https://www.youtube.com/watch?v=qik_1dDvzEs&list=RDq_HEQajNwyY&index=3",
        NThumbnailPreviewDirection.bottom),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return LinkPreviwer(
            url: data[index].url,
            dir: data[index].previewDir,
          );
        },
      ),
    );
  }
}

class LinkPreviwer extends StatelessWidget {
  const LinkPreviwer({super.key, required this.url, required this.dir});
  final String url;
  final NThumbnailPreviewDirection dir;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),

      /// NeploxLinkPreviewer is the main widget that will show the preview of the link
      child: NeploxLinkPreviewer(
        url: url,
        linkPreviewOptions: NLinkPreviewOptions(
          urlLaunch: NURLLaunch.enable,
          urlLaunchIn: NURLLaunchIn.browser,
          thumbnailPreviewDirection: dir,
        ),
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
    return FutureBuilder<LinkMetadata>(
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
