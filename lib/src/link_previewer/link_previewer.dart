import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link_index.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';

import 'link_preview_styles/style_index.dart';

class NeploxLinkPreviewer extends StatefulWidget {
  NeploxLinkPreviewer({
    super.key,
    required this.url,
    NLinkPreviewOptions? linkPreviewOptions,
    this.titleFontSize,
    this.subtitleFontSize,
    this.titleColor,
    this.subtitleColor,
    this.titleFontWeight,
    this.subtitleFontWeight,
    this.bgColor,
    this.subtitleMaxLine,
    this.titleMaxLine,
    this.titleTextStyle,
    this.subtitleTextStyle,
  }) : linkPreviewOptions = linkPreviewOptions ?? NLinkPreviewOptions();

  /// [url] is the url of the link you want to preview
  final String url;

  /// [linkPreviewOptions] is the options you want to set for the link preview
  final NLinkPreviewOptions linkPreviewOptions;

  /// Styler for the link preview

  /// [titleFontSize] is the font size of the title of the link preview
  final double? titleFontSize;

  /// [titleFontWeight] is the font weight property of the title of the link preview
  final double? titleFontWeight;

  /// [titleColor] is the color of the title of the link preview
  final Color? titleColor;

  ///[titleMaxLine] is the maxline of the title
  final int? titleMaxLine;

  /// [subtitleFontSize] is the font size of the subtitle of the link preview
  final double? subtitleFontSize;

  /// [subtitleFontWeight] is the font weight property of the subtitle of the link preview
  final double? subtitleFontWeight;

  /// [subtitleColor] is the color of the subtitle of the link preview
  final Color? subtitleColor;

  ///[subtitleMaxLine] is the maxline of the title
  final int? subtitleMaxLine;

  ///[bgColor] is the color of Card BarckgroundColor
  final Color? bgColor;

  ///[titleTextStyle]  it TextStyle for the title
  final TextStyle? titleTextStyle;

  ///[subtitleTextStyle] is TextStyle for subtitle or body content
  final TextStyle? subtitleTextStyle;

  @override
  State<NeploxLinkPreviewer> createState() => _NeploxLinkPreviewerState();
}

class _NeploxLinkPreviewerState extends State<NeploxLinkPreviewer> {
  /// [cacheManager] is the instance of the cache manager
  final NMetaFetcher nfetch = NMetaFetcher.instance;
  late final lotsOfData = Future.wait(
    [
      getData(),
    ],
  );
  @override
  void initState() {
    /// [init] is the function that initializes the cache manager
    cacheManager.init();

    super.initState();
  }

  /// [getData] is the function that fetches the meta data from the url
  Future<ElementModel> getData() async {
    return await nfetch.fetchNow(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<ElementModel>>(
          future: lotsOfData,
          builder: ((context, snapshot) {
            /// Checking asynchronously loaded elements
            switch (snapshot.connectionState) {
              case ConnectionState.none:

                /// returning CircularProgress Indicator if none
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:

                /// returning CircularProgress Indicator if waiting
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:

                /// returning text ...... if active
                return const Center(child: Text("........"));
              case ConnectionState.done:

                /// returning  Checking Preview Style and switching accordingly
                switch (widget.linkPreviewOptions.thumbnailPreviewDirection) {
                  case NThumbnailPreviewDirection.rtl:

                    /// [rtl] is the direction of the thumbnail of the link preview
                    return RTLPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      subtitleColor: widget.subtitleColor,
                      titleFontSize: widget.titleFontSize,
                      titleColor: widget.titleColor,
                      subtitleFontSize: widget.subtitleFontSize,
                      bgColor: widget.bgColor,
                      subtitleFontWeight: widget.subtitleFontWeight,
                      subtitleMaxLine: widget.subtitleMaxLine,
                      titleFontWeight: widget.titleFontWeight,
                      titleMaxLine: widget.titleMaxLine,
                      subtitleTextStyle: widget.subtitleTextStyle,
                      titleTextStyle: widget.titleTextStyle,
                    );
                  case NThumbnailPreviewDirection.ltr:

                    /// [ltr] is the direction of the thumbnail of the link preview
                    return LTRPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      subtitleColor: widget.subtitleColor,
                      titleFontSize: widget.titleFontSize,
                      titleColor: widget.titleColor,
                      subtitleFontSize: widget.subtitleFontSize,
                      bgColor: widget.bgColor,
                      subtitleFontWeight: widget.subtitleFontWeight,
                      subtitleMaxLine: widget.subtitleMaxLine,
                      titleFontWeight: widget.titleFontWeight,
                      titleMaxLine: widget.titleMaxLine,
                      subtitleTextStyle: widget.subtitleTextStyle,
                      titleTextStyle: widget.titleTextStyle,
                    );
                  case NThumbnailPreviewDirection.top:

                    /// [top] is the direction of the thumbnail of the link preview
                    return TopPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      subtitleColor: widget.subtitleColor,
                      titleFontSize: widget.titleFontSize,
                      titleColor: widget.titleColor,
                      subtitleFontSize: widget.subtitleFontSize,
                      bgColor: widget.bgColor,
                      subtitleFontWeight: widget.subtitleFontWeight,
                      subtitleMaxLine: widget.subtitleMaxLine,
                      titleFontWeight: widget.titleFontWeight,
                      titleMaxLine: widget.titleMaxLine,
                      subtitleTextStyle: widget.subtitleTextStyle,
                      titleTextStyle: widget.titleTextStyle,
                    );
                  case NThumbnailPreviewDirection.bottom:

                    /// [bottom] is the direction of the thumbnail of the link preview
                    return BottomPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      subtitleColor: widget.subtitleColor,
                      titleFontSize: widget.titleFontSize,
                      titleColor: widget.titleColor,
                      subtitleFontSize: widget.subtitleFontSize,
                      bgColor: widget.bgColor,
                      subtitleFontWeight: widget.subtitleFontWeight,
                      subtitleMaxLine: widget.subtitleMaxLine,
                      titleFontWeight: widget.titleFontWeight,
                      titleMaxLine: widget.titleMaxLine,
                      subtitleTextStyle: widget.subtitleTextStyle,
                      titleTextStyle: widget.titleTextStyle,
                    );
                  case NThumbnailPreviewDirection.none:

                    /// [none] is the direction of the thumbnail of the link preview
                    return NonePreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      subtitleColor: widget.subtitleColor,
                      titleFontSize: widget.titleFontSize,
                      titleColor: widget.titleColor,
                      subtitleFontSize: widget.subtitleFontSize,
                      bgColor: widget.bgColor,
                      subtitleFontWeight: widget.subtitleFontWeight,
                      subtitleMaxLine: widget.subtitleMaxLine,
                      titleFontWeight: widget.titleFontWeight,
                      titleMaxLine: widget.titleMaxLine,
                      subtitleTextStyle: widget.subtitleTextStyle,
                      titleTextStyle: widget.titleTextStyle,
                    );
                }
            }
          })),
    );
  }
}
