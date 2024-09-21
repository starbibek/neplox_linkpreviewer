import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/cache/cache_manager.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link_index.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/helper/ncard_view.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';

import '../helper/style/styles.dart';

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
  final FontWeight? titleFontWeight;
  @Deprecated('Use TypographyStyle instead.')
  final Color? titleColor;
  @Deprecated('Use TypographyStyle instead.')
  final int? titleMaxLine;
  @Deprecated('Use TypographyStyle instead.')
  final TextStyle? titleTextStyle;
  @Deprecated('Use TypographyStyle instead.')
  final double? subtitleFontSize;
  @Deprecated('Use TypographyStyle instead.')
  final FontWeight? subtitleFontWeight;
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

  @protected
  Future<ElementModel> getData() async {
    return await nfetch.fetch(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.cardStyle.width ??
        0.95 *
            MediaQuery.of(context)
                .size
                .width; // Default to 95% of available width
    double height =
        widget.linkPreviewOptions.getCardHeight(context, widget.cardStyle);

    return Material(
      child: FutureBuilder<List<ElementModel>>(
          future: lotsOfData,
          builder: ((context, snapshot) {
            // Checking asynchronously loaded elements
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // returning CircularProgress Indicator if none
                return SizedBox(
                  width: width,
                  child: const Center(child: CircularProgressIndicator()),
                );
              case ConnectionState.waiting:
                // returning CircularProgress Indicator if waiting
                return SizedBox(
                    width: width,
                    height: height,
                    child: const Center(child: CircularProgressIndicator()));
              case ConnectionState.active:
                // returning text ...... if active
                return SizedBox(
                    width: width,
                    height: height,
                    child: const Center(child: Text("........")));
              case ConnectionState.done:
                if (!snapshot.hasData) {
                  return SizedBox(
                      width: width,
                      height: height,
                      child: const Center(
                          child: Text("Error while fetching data")));
                }
                return SizedBox(
                  width: 0.95 * MediaQuery.of(context).size.width,
                  child: NCardView(
                      snapshot: snapshot.data![0],
                      linkPreviewOptions: widget.linkPreviewOptions,
                      nTypographyStyle: widget.typographyStyle,
                      nCardStyle: widget.cardStyle),
                );
            }
          })),
    );
  }
}
