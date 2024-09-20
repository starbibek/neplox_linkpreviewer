import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link_index.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';

import 'link_preview_styles/style/styles.dart';
import 'link_preview_styles/style_index.dart';

/// Neplox link preview Widget
/// [url] is the url of the link you want to preview
/// [typographyStyle] - contain properties to style title, and body text
/// [cardStyle] - contain properties to style card
/// [getData] is the function that fetches the meta data from the url
/// [cacheManager] is the instance of the cache manager
class NeploxLinkPreviewer<T> extends StatefulWidget {
  NeploxLinkPreviewer({
    super.key,
    required this.url,
    NLinkPreviewOptions? linkPreviewOptions,
    @Deprecated('Use TypographyStyle instead to set title FontSize.')
    this.titleFontSize,
    @Deprecated('Use TypographyStyle instead to set title Color.')
    this.titleColor,
    @Deprecated('Use TypographyStyle instead to set title MaxLine.')
    this.titleMaxLine,
    @Deprecated('Use TypographyStyle instead to set title FontWeight.')
    this.titleFontWeight,
    @Deprecated('Use TypographyStyle instead to set title TextStyle.')
    this.titleTextStyle,
    @Deprecated('Use TypographyStyle instead to set subtitle Color.')
    this.subtitleColor,
    @Deprecated('Use TypographyStyle instead to set subtitle FontWeight.')
    this.subtitleFontWeight,
    @Deprecated('Use TypographyStyle instead to set subtitle MaxLine.')
    this.subtitleMaxLine,
    @Deprecated('Use TypographyStyle instead to set subtitle FontSize.')
    this.subtitleFontSize,
    @Deprecated('Use TypographyStyle instead to set subtitle TextStyle.')
    this.subtitleTextStyle,
    @Deprecated('Use CardStyle instead to style card.') this.bgColor,
    NTypographyStyle? typographyStyle,
    NCardStyle? cardStyle,
  })  : linkPreviewOptions = linkPreviewOptions ?? NLinkPreviewOptions(),
        typographyStyle = typographyStyle ??
            NTypographyStyle(
              titleColor: titleColor,
              titleFontWeight: titleFontWeight,
              titleMaxLine: titleMaxLine,
              titleFontSize: titleFontSize,
              titleTextStyle: titleTextStyle,
              bodyColor: subtitleColor,
              bodyFontSize: subtitleFontSize,
              bodyFontWeight: subtitleFontWeight,
              bodyMaxLine: subtitleMaxLine,
              bodyTextStyle: subtitleTextStyle,
            ),
        cardStyle = cardStyle ??
            NCardStyle(
              bgColor: bgColor ?? Colors.white,
            );

  // NeploxLinkPreviewer properties
  final String url;
  final NLinkPreviewOptions linkPreviewOptions;
  final NTypographyStyle typographyStyle;
  final NCardStyle cardStyle;

// NeploxLinkPreviewer deprecated properties
  @Deprecated('Use TypographyStyle instead.')
  final double? titleFontSize;
  @Deprecated('Use TypographyStyle instead.')
  final double? titleFontWeight;
  @Deprecated('Use TypographyStyle instead.')
  final Color? titleColor;
  @Deprecated('Use TypographyStyle instead.')
  final int? titleMaxLine;
  @Deprecated('Use TypographyStyle instead.')
  final TextStyle? titleTextStyle;
  @Deprecated('Use TypographyStyle instead.')
  final double? subtitleFontSize;
  @Deprecated('Use TypographyStyle instead.')
  final double? subtitleFontWeight;
  @Deprecated('Use TypographyStyle instead.')
  final Color? subtitleColor;
  @Deprecated('Use TypographyStyle instead.')
  final int? subtitleMaxLine;
  @Deprecated('Use TypographyStyle instead.')
  final TextStyle? subtitleTextStyle;
  @Deprecated('Use CardStyle instead.')
  final Color? bgColor;

  @override
  State<NeploxLinkPreviewer> createState() => _NeploxLinkPreviewerState();
}

class _NeploxLinkPreviewerState extends State<NeploxLinkPreviewer> {
  final NMetaFetcher nfetch = NMetaFetcher.instance;
  late final lotsOfData = Future.wait(
    [
      getData(),
    ],
  );
  @override
  void initState() {
    // initializing the cache manager
    cacheManager.init();
    super.initState();
  }

  Future<ElementModel> getData() async {
    return await nfetch.fetch(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<ElementModel>>(
          future: lotsOfData,
          builder: ((context, snapshot) {
            // Checking asynchronously loaded elements
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // returning CircularProgress Indicator if none
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                // returning CircularProgress Indicator if waiting
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                // returning text ...... if active
                return const Center(child: Text("........"));
              case ConnectionState.done:
                if (!snapshot.hasData) {
                  return Center(child: Text(" Has DATA ${snapshot.data}"));
                }
                // returning  Checking Preview Style and switching accordingly
                switch (widget.linkPreviewOptions.thumbnailPreviewDirection) {
                  case NThumbnailPreviewDirection.rtl:
                    // [rtl] is the direction of the thumbnail of the link preview
                    return RTLPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      nCardStyle: widget.cardStyle,
                      nTypographyStyle: widget.typographyStyle,
                    );
                  case NThumbnailPreviewDirection.ltr:
                    // [ltr] is the direction of the thumbnail of the link preview
                    return LTRPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      nCardStyle: widget.cardStyle,
                      nTypographyStyle: widget.typographyStyle,
                    );
                  case NThumbnailPreviewDirection.top:
                    // [top] is the direction of the thumbnail of the link preview
                    return TopPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      nCardStyle: widget.cardStyle,
                      nTypographyStyle: widget.typographyStyle,
                    );
                  case NThumbnailPreviewDirection.bottom:
                    // [bottom] is the direction of the thumbnail of the link preview
                    return BottomPreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      nCardStyle: widget.cardStyle,
                      nTypographyStyle: widget.typographyStyle,
                    );
                  case NThumbnailPreviewDirection.none:
                    // [none] is the direction of the thumbnail of the link preview
                    return NonePreviewStyle(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      nCardStyle: widget.cardStyle,
                      nTypographyStyle: widget.typographyStyle,
                    );
                }
            }
          })),
    );
  }
}
