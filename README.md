# Neplox LinkPreviewer

##### URL Preview and Meta Data

[![Build Status](https://app.travis-ci.com/starbibek/neplox_linkpreviewer.svg?branch=master)](https://app.travis-ci.com/starbibek/neplox_linkpreviewer.svg?branch=master)
![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

A flutter package that helps you preview web URLs with Pre-Made UI and with customizable options.You can also fetch meta data from url as Element object.

# Neplox LinkPreviewer: Preview Directions

## RTL

<img src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/rtl.jpg" data-canonical-src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/rtl.jpg" width="250" height="150" />

## LTR

<img src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/ltr.jpg" data-canonical-src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/ltr.jpg" width="250" height="150" />

## TOP

<img src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/top.jpg" data-canonical-src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/top.jpg" width="250" height="150" />

## BOTTOM

<img src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/bottom.jpg" data-canonical-src="https://github.com/starbibek/neplox_linkpreviewer/blob/master/assets/bottom.jpg" width="250" height="150" />

**Show some ❤️ and star the repo to support the project if it's helpful to you.**

## Features
 * Fetch Meta Data as ElementModel Object from url
 * Have varities of Link Preview direction style(TOP, BOTTOM, LTR, RTL)
 * Can customize the preview style 

## Installation

```Dart
flutter pub add neplox_linkpreviewer
```

# Usage

```Dart
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
````

```Dart
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
      child: NeploxLinkPreviewer(
        url: widget.url,
        linkPreviewOptions: NLinkPreviewOptions(
            urlContentType: NURLContentType.video,
            urlLaunch: NURLLaunch.enable,
            urlLaunchIn: NURLLaunchIn.browser,
            thumbnailPreviewDirection: NThumbnailPreviewDirection.bottom),
      ),
    );
  }
}

```

``` Dart
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

```

## MIT License

```
Copyright (c) 2023 Shobhit paudel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
