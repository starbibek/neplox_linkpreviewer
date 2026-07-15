import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/fetch_elements/fetch_link_index.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/helper/ncard_view.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';

import '../helper/style/styles.dart';

/// Fetches [url] and displays its title, description, and optional thumbnail.
///
/// Metadata is cached for 24 hours. When [url] changes on an existing widget,
/// the state automatically requests and displays the new preview.
class NeploxLinkPreviewer extends StatefulWidget {
  NeploxLinkPreviewer({
    super.key,
    required this.url,
    NLinkPreviewOptions? linkPreviewOptions,
    @Deprecated('Use typographyStyle instead.') this.titleFontSize,
    @Deprecated('Use typographyStyle instead.') this.titleColor,
    @Deprecated('Use typographyStyle instead.') this.titleMaxLine,
    @Deprecated('Use typographyStyle instead.') this.titleFontWeight,
    @Deprecated('Use typographyStyle instead.') this.titleTextStyle,
    @Deprecated('Use typographyStyle instead.') this.subtitleColor,
    @Deprecated('Use typographyStyle instead.') this.subtitleFontWeight,
    @Deprecated('Use typographyStyle instead.') this.subtitleMaxLine,
    @Deprecated('Use typographyStyle instead.') this.subtitleFontSize,
    @Deprecated('Use typographyStyle instead.') this.subtitleTextStyle,
    @Deprecated('Use cardStyle instead.') this.bgColor,
    NTypographyStyle? typographyStyle,
    NCardStyle? cardStyle,
    @visibleForTesting this.metadataLoader,
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
        cardStyle = cardStyle ?? NCardStyle(bgColor: bgColor);

  /// URL of the page to preview. HTTP and HTTPS URLs are supported. If the
  /// scheme is omitted, HTTPS is assumed.
  final String url;

  /// Controls thumbnail placement and tap behavior.
  final NLinkPreviewOptions linkPreviewOptions;

  /// Controls title and description typography.
  final NTypographyStyle typographyStyle;

  /// Controls dimensions and Material card decoration.
  final NCardStyle cardStyle;

  /// Overrides metadata loading in widget tests.
  @visibleForTesting
  final Future<ElementModel> Function(String url)? metadataLoader;

  @Deprecated('Use typographyStyle instead.')
  final double? titleFontSize;
  @Deprecated('Use typographyStyle instead.')
  final FontWeight? titleFontWeight;
  @Deprecated('Use typographyStyle instead.')
  final Color? titleColor;
  @Deprecated('Use typographyStyle instead.')
  final int? titleMaxLine;
  @Deprecated('Use typographyStyle instead.')
  final TextStyle? titleTextStyle;
  @Deprecated('Use typographyStyle instead.')
  final double? subtitleFontSize;
  @Deprecated('Use typographyStyle instead.')
  final FontWeight? subtitleFontWeight;
  @Deprecated('Use typographyStyle instead.')
  final Color? subtitleColor;
  @Deprecated('Use typographyStyle instead.')
  final int? subtitleMaxLine;
  @Deprecated('Use typographyStyle instead.')
  final TextStyle? subtitleTextStyle;
  @Deprecated('Use cardStyle instead.')
  final Color? bgColor;

  @override
  State<NeploxLinkPreviewer> createState() => _NeploxLinkPreviewerState();
}

class _NeploxLinkPreviewerState extends State<NeploxLinkPreviewer> {
  final NMetaFetcher _fetcher = NMetaFetcher.instance;
  late Future<ElementModel> _metadata;

  @override
  void initState() {
    super.initState();
    _metadata = _loadMetadata();
  }

  @override
  void didUpdateWidget(covariant NeploxLinkPreviewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _metadata = _loadMetadata();
    }
  }

  void _retry() {
    setState(() {
      _metadata = _loadMetadata();
    });
  }

  Future<ElementModel> _loadMetadata() =>
      widget.metadataLoader?.call(widget.url) ?? _fetcher.fetch(widget.url);

  @override
  Widget build(BuildContext context) {
    final width =
        widget.cardStyle.width ?? MediaQuery.sizeOf(context).width * 0.95;
    final fixedHeight = widget.cardStyle.heightMode == NCardHeightMode.fixed
        ? widget.linkPreviewOptions.getCardHeight(context, widget.cardStyle)
        : null;

    final preview = FutureBuilder<ElementModel>(
      future: _metadata,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final metadata = snapshot.data;
        if (snapshot.hasError || metadata == null || !metadata.hasPreviewData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Unable to load link preview'),
                const SizedBox(height: 8),
                TextButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          );
        }

        return NCardView(
          snapshot: metadata,
          linkPreviewOptions: widget.linkPreviewOptions,
          nTypographyStyle: widget.typographyStyle,
          nCardStyle: widget.cardStyle,
          wrapContent:
              widget.cardStyle.heightMode == NCardHeightMode.contentWrap,
        );
      },
    );

    return SizedBox(
      width: width,
      height: fixedHeight,
      child: widget.cardStyle.heightMode == NCardHeightMode.contentWrap
          ? ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: widget.cardStyle.minHeight),
              child: preview,
            )
          : preview,
    );
  }
}
